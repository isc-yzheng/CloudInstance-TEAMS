/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsUtil

/// Monitor Service<br>
/// Checks all hosts for inactivity
Class Ens.MonitorService Extends Ens.BusinessService [ ClassType = "", ProcedureBlock, System = 4 ]
{

/// Use an adapter to make sure we get invoked.
Parameter ADAPTER = "Ens.InboundAdapter";

Property Config [ MultiDimensional ];

Property QueueCounts [ MultiDimensional ];

Property QueueDelays [ MultiDimensional ];

Property LastUpdate As %String;

Property ActorQueueStatement As %SQL.Statement;

Property queueWaitResetPercentage As %Numeric [ InitialExpression = {##class(Ens.MonitorService).getQWTPct()}, Transient ];

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
	// Use Process Private Global for dead job listing to ensure local memory
	// usage is bounded, especially for large systems with extensive up-time
	#define LocalDeadJobs ^||%EnsMonitor.DeadJobs

	Set $ZT="Trap", tSC=$$$OK
	Do {
		Do ##class(Ens.Job).MarkDeadJobs()
		Do ##class(Ens.Job).CheckMirrorGlobals()
		Do ..CheckEnsRuntime()

		#; get now in seconds
		Set tNow = $$$timeUTC

		#; inspect status global for all hosts
		Set tHost="" For { Set tHost=$$$OrderHostMonitor(tHost)  Quit:""=tHost

			Set tClassname=$G(..Config(tHost,"ClassName"))
			If ""=tClassname $$$SetHostMonitor(tHost,$$$eMonitorStatus,"Unconfigured")  Continue

			#; get last host activity time; test for inactivity
			Set tTimeout = +$G(..Config(tHost,"Setting","Host","InactivityTimeout"))
			#;An item that is enabled could have run as job of 0. If item has a schedule and run as job is 0 and PoolSize is not 0 then means schedule STOPPED.
			If (tTimeout > 0) && $G(..Config(tHost,"IsEnabled")) && ($G(..Config(tHost,"Job"))||($G(..Config(tHost,"Schedule"))="")||('$G(..Config(tHost,"PoolSize")))) {
				// get last time in seconds
				If ($$$timeDiff(tNow, $$$GetHostMonitor(tHost,$$$eMonitorLastActivity)) > tTimeout) {
					// do not change state unless currently ok
					If ($$$GetHostMonitor(tHost,$$$eMonitorStatus) = "OK") {
						$$$SetHostMonitor(tHost,$$$eMonitorStatus,"Inactive")
						Set tAlert = ##class(Ens.AlertRequest).%New($lb(tHost,"InactivityTimeoutAlert: "_$$$FormatText($$$Text("@AlertInactivityTimeout@Inactivity timeout of '%1' seconds exceeded for host '%2'","Ensemble"),tTimeout,tHost)))
						Set tSC1 = ..SendAlert(tAlert)
						If $$$ISERR(tSC1) Set tSC = $$$ADDSC(tSC,tSC1)
					}
				}
				#; now test each job for this host
				Set tJob="" For { Set tJob=$$$OrderHostMonitor(tHost,$$$eMonitorJob,tJob)  Quit:""=tJob

					If ($$$timeDiff(tNow, $$$GetJobMonitor(tHost,tJob,$$$eMonitorLastActivity)) > tTimeout) {
						#; do not change state unless currently ok
						If ($$$GetJobMonitor(tHost,tJob,$$$eMonitorStatus) = "OK") {
							$$$SetJobMonitor(tHost,tJob,$$$eMonitorStatus,"Inactive")
						}
					}
				}
			}
			#; check for dead jobs
			Set tDeadPrefix = $$$SystemName_":Z"
			Set tPrefixLen = $length(tDeadPrefix)
			Set tGhostJob = tDeadPrefix
			For {
				Set tGhostJob = $$$OrderHostMonitor(tHost, $$$eMonitorJob, tGhostJob)
				If (tGhostJob = "")||($extract(tGhostJob, 1, tPrefixLen) '= tDeadPrefix) Quit
				If $data($$$LocalDeadJobs(tHost, tGhostJob)) Continue

				Set tJob = $piece($extract(tGhostJob, tPrefixLen+1, *), "_", 1)
				Set tAlert = ##class(Ens.AlertRequest).%New($lb(tHost,"DeadJobAlert: "_$$$FormatText($$$Text("@AlertDeadJob@Job '%1' for config item '%2' was marked as 'dead' under ghost Id '%3'","Ensemble"),tJob,tHost,tGhostJob)))
				Set tSC1 = ..SendAlert(tAlert)
				If $$$ISERR(tSC1) { Set tSC = $$$ADDSC(tSC, tSC1) }
				Else { Set $$$LocalDeadJobs(tHost, tGhostJob) = "" }
			}

			#; check queue count
			Set tQueueCount = +$get(..Config(tHost,"Setting","Host","QueueCountAlert"))
			If (tQueueCount > 0) {
				Set tQueueName = $get(..Config(tHost,"QueueName"))
				If tQueueName '= "" {
					Set tLastCount = +$get(..QueueCounts(tHost))
					Set tCurrentCount = ##class(Ens.Queue).GetCount(tQueueName)

					If tLastCount {
						Set tBoundary = (8*tQueueCount)\10
						If tCurrentCount <= tBoundary {
							Kill ..QueueCounts(tHost)
							Kill $$$EnsAlertedCount(tHost)
						}
						Else {
							Set ..QueueCounts(tHost) = tCurrentCount
						}
					}
					ElseIf tCurrentCount > tQueueCount {
						Set tAlertText = "QueueCountAlert: "_$$$FormatText($$$Text("@AlertQueueCount@Queue count of '%1' exceeded for host '%2'","Ensemble"),tQueueCount,tHost)
						If '$get(..Config(tHost,"IsEnabled")) Set tAlertText = tAlertText _ " ("_$$$Text("Host is disabled","Ensemble")_")"
						Set tAlert = ##class(Ens.AlertRequest).%New($lb(tHost,tAlertText))
						Set tSC1 = ..SendAlert(tAlert)
						If $$$ISERR(tSC1) Set tSC = $$$ADDSC(tSC, tSC1)
						Set ..QueueCounts(tHost) = tCurrentCount
						Set $$$EnsAlertedCount(tHost)=tCurrentCount
					}
				}
			}

			#; check time on queue for first message, if check is enabled
			Set tPermittedDelay = +$get(..Config(tHost, "Setting", "Host", "QueueWaitAlert"))
			If tPermittedDelay > 0 {

				Set tSC1 = ..AlertIfQueueWait(tHost, tPermittedDelay)
				If $$$ISERR(tSC1) Set tSC = $$$ADDSC(tSC, tSC1)

			}

			#; now invoke OnMonitor callback for the host class
			Set $ZTrap="MonitorTrap"
			Set tSC1=$zobjclassmethod(tClassname,"OnMonitor",tHost)  Set:$$$ISERR(tSC1) tSC=$$$ADDSC(tSC,tSC1)
			Set $ZT="Trap"
ContinueMonitor
		}
		#; check if purge of temporary uncollected statistics needs to run. It may end up running more than once a day if restarted.
		If $G($$$EnsJobLocal("Stats","TempPurgeCheck"))'=+$H {
			Set tSC1 = ##class(Ens.Util.Statistics).PurgeUncollectedStats(##class(Ens.Util.Statistics).GetTempStatsDaystoKeep(),.pDeleted)
			If $$$ISERR(tSC1) {
				Set tSC = $$$ADDSC(tSC, tSC1)
			} Else {
				If pDeleted $$$LOGINFO("Purged "_pDeleted_" uncollected temporary statistics.")
			}
			Set $$$EnsJobLocal("Stats","TempPurgeCheck")=+$H
		}
		#; update monitor & counter for the MonitorService
		#; global stats
		Set tConfigName=..%ConfigName
		$$$IncHostCounterTime(tConfigName)

		#; local stats
		$$$IncJobCounterTime(tConfigName,$$$SystemName_":"_$Job)

	} while (0)
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
MonitorTrap
 	Set $ZT="Trap",tZE=$ZE
 	If $G(tZE)'["<CLASS DOES NOT EXIST>" {
		Set tSC=$$$ADDSC(tSC,$$$SystemError)
	} Else {
		Set tSC=$$$ADDSC(tSC,$$$ERROR($$$EnsErrGeneral,"Could not call OnMonitor() on nonexistent class '"_$G(tClassname)_"'"))
	}
		Goto ContinueMonitor
}

/// Retrieve time on queue for oldest message
Method GetHostQueueTime(pHostName As %String, Output pMsgId As %Integer, Output pPriority As Ens.DataType.MessagePriority, Output pSessionId As %Integer, Output pFailedDelayCompute As %Boolean) As %Numeric [ Private ]
{
	Set tTimeQueued = 0
	Set pPriority = 0
	Set pMsgId = 0
	Set pSessionId = 0
	Set pFailedDelayCompute = 0
	Set tCurrTime = $$$timeUTC // Use the same timestamp mechanism
	Set tQueueName = $get(..Config(pHostName, "QueueName"))
	If tQueueName = "Ens.Actor" { // need to isolate messages queued for Ens.Actor
		Set tRS = ..ActorQueueStatement.%Execute(tCurrTime, pHostName)
		If tRS.%Next() {
			Set tTimeQueued = tRS.%Get("TimeQueued")
			Set pMsgId = tRS.%Get("MessageId")
			Set pPriority = tRS.%Get("Priority")
			Set pSessionId = tRS.%Get("SessionId")
		}
	}
	Else {
		For tPrio = $$$eMessagePriorityHighSync, $$$eMessagePrioritySync, $$$eMessagePrioritySimSync, $$$eMessagePriorityAsync {
			Set tMsgId = ""
			Set tNext = $order($$$EnsQueue(tQueueName, tPrio, ""), 1, tMsgId)
			If tMsgId '= "" {
				#; Get queued message with no locking
				Set tQueuedHeader = ##class(Ens.MessageHeader).%OpenId(tMsgId,0,.tSC)
				#; Only trust the TimeProcessed if status is queued.
				If $$$ISOK(tSC) && $IsObject(tQueuedHeader) && (tQueuedHeader.Status=$$$eMessageStatusQueued) {
					Set tThisWait = $SYSTEM.SQL.DATEDIFF("ss",tQueuedHeader.TimeProcessed,tCurrTime)
					If tThisWait > tTimeQueued {
						Set tTimeQueued = tThisWait
						Set pMsgId = tMsgId
						Set pPriority = tQueuedHeader.Priority
						Set pSessionId = tQueuedHeader.SessionId
					}
				} Else {
					#; We identified a message id on the queue but failed to get information on this pass.
					Set pFailedDelayCompute = 1
				}
			}
		}
	}
	Quit tTimeQueued
}

/// Retrieve time for active message - does not support those using Ens.Actor
Method GetHostActiveTime(pHostName As %String, Output pMsgId As %Integer, Output pPriority As Ens.DataType.MessagePriority, Output pSessionId As %Integer) As %Numeric [ Private ]
{
	#dim tTimeActive = 0
	Set pPriority = 0
	Set pMsgId = 0
	Set pSessionId = 0
	#dim tCurrTime = $$$timeUTC // Use the same timestamp mechanism

	#dim tSYSJobID As %String = ""
	#dim tActiveMessageID As %String = ""
	#dim tActiveHeader As Ens.MessageHeader
	#dim tSC As Status

	#dim tThisWait
	/* Find oldest of active message. Ought to be just one job.*/
	For {
		Set tSYSJobID=$$$OrderHostMonitor(pHostName,"%Job",tSYSJobID)
		If tSYSJobID = "" Quit
		If $Data($$$EnsActiveMessage(tSYSJobID),tActiveMessageID)#2 {
			#; Get active message with no locking
			Set tActiveHeader = ##class(Ens.MessageHeader).%OpenId(tActiveMessageID,0,.tSC)
			#; Only trust the TimeProcessed if status is delivered.
			If $$$ISOK(tSC) && $IsObject(tActiveHeader) && (tActiveHeader.Status=$$$eMessageStatusDelivered) {
				Set tThisWait = $SYSTEM.SQL.DATEDIFF("ss",tActiveHeader.TimeProcessed,tCurrTime)
				If tThisWait > tTimeActive {
					Set tTimeActive = tThisWait
					Set pMsgId = tActiveMessageID
					Set pPriority = tActiveHeader.Priority
					Set pSessionId = tActiveHeader.SessionId
				}
			}
		}
	}
	Quit tTimeActive
}

/// Check local array is in sync with ^Ens.Runtime
Method CheckEnsRuntime()
{
	Set tDoUpdate =0
	If ..LastUpdate = "" {
		Set tDoUpdate = 1
	}
	Else {
		Set tLastProdUpdate = $get($$$EnsRuntime("LastUpdate"))
		If tLastProdUpdate '= ..LastUpdate { Set tDoUpdate = 1 }
	}
	If tDoUpdate {
		Kill ..Config
		Merge ..Config = $$$EnsRuntime("ConfigItem")
		Set ..LastUpdate = $get($$$EnsRuntime("LastUpdate"))
	}
	Quit
}

ClassMethod Purge(Output pDeletedCount As %Integer, pDaysToKeep As %Integer = 7, pDummy As %Boolean) As %Status
{
	Set tSC = $$$OK
	Try {
		set pDeletedCount=0
		set tDoNotDeleteDateH = $$$timeUTCtoUTCH(##class(Ens.Purge).GetDoNotDeleteDate(pDaysToKeep))
		set tDoNotDeleteInterval=$P(tDoNotDeleteDateH,",",2)\$$$EnsCounterInterval
		set host="" for  { set host=$$$OrderHostCounter(host)  quit:host=""
			set date="" for  { set date=$$$OrderHostCounter(host,date)  quit:date=""
				set interval="" for  { set interval=$$$OrderHostCounter(host,date,interval)  quit:interval=""
					if (date<tDoNotDeleteDateH)
					 || ((+date=+tDoNotDeleteDateH)
					  && (interval<tDoNotDeleteInterval)) {
						  $$$KillHostCounter(host,date,interval)
						  set pDeletedCount=pDeletedCount+1
					  }
				}
			}
		}
		/* Clean up stale EnsHostTotals */
		If pDaysToKeep=0 {Kill $$$EnsHostCounterTotalsRoot($NAMESPACE)  Quit}
		Set tNowUTCH=$ZTS, tStartDate=$P(tNowUTCH,",",1), tStartTime=$P(tNowUTCH,",",2)\1
		Set tUpdateStamp = (tStartDate*86400) + tStartTime
		Set tTimeFrame = $O($$$EnsHostCounterTotals(""))
		While (tTimeFrame'="") {
			If ((tTimeFrame="lastWeek")&&(pDaysToKeep<7)) {
				Kill $$$EnsHostCounterTotals(tTimeFrame)
			} Else {
				Set tConfigSubscript = $O($$$EnsHostCounterTotals(tTimeFrame,""))
				While (tConfigSubscript'="") {
					If ((tUpdateStamp-$G($$$EnsHostCounterTotals(tTimeFrame,tConfigSubscript),0))>$$$EnsCounterInterval) {
						Set date = $O($$$EnsHostCounterTotals(tTimeFrame,tConfigSubscript,""))
						While ((date'="")&&(date<tDoNotDeleteDateH)) {
							Kill $$$EnsHostCounterTotals(tTimeFrame,tConfigSubscript,date)
							Set date = $O($$$EnsHostCounterTotals(tTimeFrame,tConfigSubscript,date))
						}
					}
					Set tConfigSubscript = $O($$$EnsHostCounterTotals(tTimeFrame,tConfigSubscript))
				}
			}
			Set tTimeFrame = $O($$$EnsHostCounterTotals(tTimeFrame))
		}

		/* Clean up old Scheduler AlarmSets */
		Set tSC = $$$ADDSC(tSC, ##class(Ens.ScheduleHandler).PurgeAlarmSets(.pDeletedCount, pDaysToKeep))

	} Catch e {
		Set tSC = e.AsStatus()
	}
	Quit tSC
}

Method OnInit() As %Status
{
	Merge ..QueueCounts = $$$EnsAlertedCountRoot
	Merge ..QueueDelays = $$$EnsAlertedDelayRoot

	Set ..ActorQueueStatement = ##class(%SQL.Statement).%New()
	Quit ..ActorQueueStatement.%Prepare("SELECT DATEDIFF('ss', TimeProcessed, ?) As TimeQueued, %ID As MessageId, Priority, SessionId FROM Ens.MessageHeader WHERE TargetConfigName = ? AND Status = 2 ORDER BY ID")
}

/// Analyze Queue and Active message to see if delay.
Method AlertIfQueueWait(pHost As %String, pPermittedDelay As %Integer = 0) As %Status [ Internal, Private ]
{
	/// Initialized Variables
	#dim tSC As %Status = $$$OK
	/* tHasDelay values:
		0 no delay,
		1 delay on the queue,
		2 delay in active processing
		This is so that we could detect if delayed queued message moves to active (TimeProcessed will be updated)
		Use the differentiation in the tracing.*/
	#dim tHasDelay = 0
	#dim tTimeActive = 0 // Time message in ^Ens.ActiveMessage
	#dim tTimeQueued = 0 // Time message at front of ^Ens.Queue
	/*	It is possible that the queue wait queries fail to obtain accurate data
		due to timing and non locking.
		We need to avoid false detection of delay clearance.
		This flag used to indicate to caller such a false detection. */
	#dim tFailedDelayCompute As %Boolean = 0

	/// Uninitialized Variables
	#dim tMsgId // Id of Message being checked
	#dim tPrio // Queue Priority
	#dim tSessionId // Message Session
	#dim tLastMsgId // Message ID of last detected delayed message.
	#dim tNeedToAlert //Flag to indicate need to send Alert
	#dim tAlertText // Text string used in Alert
	#dim tDebugTimeActive //TimeActive before being zeroed

	/* Find active message age if enabled and single job */
	If $Get(..Config(pHost,"IsEnabled")) && ($Get(..Config(pHost,"PoolSize"))=1) {

		Set tTimeActive = ..GetHostActiveTime(pHost,.tMsgId,.tPrio, .tSessionId)

		If (tTimeActive > pPermittedDelay) {

			Set tHasDelay = 2

		} ElseIf ($Data(..QueueDelays(pHost),tLastMsgId)#2) && (tLastMsgId=tMsgId) {

			/*	A known delayed queued message has been moved (TimeProcessed updated) to Active so remember delayed
				Don't mark as active delay since last delay was queued and don't want to send another alert
				as if active become stuck again. */
			Set tHasDelay = 1

		} Else {

			/*	Use tTimeActive to provide extra Alert info so set to 0 if not triggered delay */
			Set tDebugTimeActive = tTimeActive
			Set tTimeActive = 0

		}

		$$$catTRACE("queue","Active wait time monitor for "_pHost_" setting detected delay type: "_$Case(tHasDelay,2:"Active",1:"Queue (from prior detection)",:"None")_". Time active "_$Get(tDebugTimeActive,tTimeActive)_", MsgId:"_tMsgId_", PriorAlerted: "_$Get(tLastMsgId))

	}

	#; Not found/not checked delay in Active. Check front of queue for delay.
	If 'tHasDelay {

		Set tTimeQueued = ..GetHostQueueTime(pHost, .tMsgId, .tPrio, .tSessionId,.tFailedDelayCompute)

		If (tTimeQueued > pPermittedDelay) {

			Set tHasDelay = 1

		} ElseIf ($Data(..QueueDelays(pHost),tLastMsgId)#2) {

			/*	Most recent queue item is not thought to be delayed but
				we are currently in 'delayed' mode.
				Need to identify if delay really cleared.
					1. If we failed to compute a delay - keep delayed.
					2. Queue Drained - identified by tMsgId = 0 - clear delay
					3. Same message - keep delayed.
					3. Could be the TimeProcessed of the message at the front of the queue
						due to change in status from Delivered to Queued for example
							A. Item Disabled - keep delayed.
							B. MsgId less that message that triggered wait - keep delayed.
			*/

			If tFailedDelayCompute {

				/*	Keep in delay since failed minimally invasive enquiry
						1. State that still in delay
						2. Set tMsgId and other variables for safety - alert will not be called.
						3. Set tTimeQueued to permitted delay+1 */

				Set tMsgId = tLastMsgId
				Set tHasDelay = 1
				Set tSessionId = 0
				Set tPrio = 3
				Set tTimeQueued = pPermittedDelay+1

			} ElseIf tMsgId = 0 {

				/*	Queue drained so no delay */
				Set tHasDelay = 0

			} ElseIf (tLastMsgId=tMsgId) {

				/*	The delayed active message that triggered the alert has been moved (TimeProcessed updated)
					to queue so remember delay */
				Set tHasDelay = 1

			} ElseIf '$Get(..Config(pHost,"IsEnabled")) {

				/*	The delayed message that triggered the alert is not the one found at the front of the queue.
					This could be because the active message was put back at the front of queue when item disabled
					and TimeProcessed was updated.
					Keep as delayed */
				Set tHasDelay = 1

			} ElseIf (tLastMsgId > tMsgId){

				/*	An active or resent message went to the front of the queue */
				Set tHasDelay = 1

			}

		} /* Else were not in a delay and didnt detect a delay */

		$$$catTRACE("queue","Queue wait time for "_pHost_$Select(tFailedDelayCompute:" temporary failed calculation",1:(" detected delay type: "_$Case(tHasDelay,2:"Active",1:"Queue",:"None")_" and time queued "_tTimeQueued))_", MsgId:"_tMsgId_", PriorAlerted: "_$Get(tLastMsgId))

	}

	#; Detected delay
	If tHasDelay {

		#; Clean up in case used above
		Kill tLastMsgId

		If '($Data(..QueueDelays(pHost),tLastMsgId)#2) {

			#; Not already in delay or active message delay
			Set tNeedToAlert = 1

		} Else {
			#; Don't differentiate between delay type changes or msg id changes. Just mark as not neeced to alert.
			Set tNeedToAlert = 0
			$$$catTRACE("queue","Alert Not needed "_pHost_", PriorAlerted: "_$Get(tLastMsgId))

		}

		If tNeedToAlert {

			/*	Store message Id since when message changes from Queue to Active or vice versa
				the updating of TimeProcessed does not lead to extra wait alert(s) */
			Set ..QueueDelays(pHost) = tMsgId
			Set $$$EnsAlertedDelay(pHost)=..QueueDelays(pHost)

			Set tAlertText = "QueueWaitAlert: "_$$$FormatText($$$Text("@AlertQueueDelay@Message Header Id '%1' queued for config item '%2' with priority '%3' has been queued for more than %4 seconds","Ensemble"),tMsgId,pHost,##class(Ens.DataType.MessagePriority).LogicalToDisplay(tPrio),pPermittedDelay)

			If '$Get(..Config(pHost,"IsEnabled")) {

				Set tAlertText = tAlertText _ " ("_$$$Text("QueueWait Host is disabled","Ensemble")_")"

			} ElseIf tTimeActive {

				Set tAlertText = tAlertText _ " ("_$$$Text("QueueWait Message is active","Ensemble")_")"

			}

			Set tAlert = ##class(Ens.AlertRequest).%New($lb(pHost, tAlertText))
			Set ..%SessionId = tSessionId, $$$JobSessionId = tSessionId
			Set tSC = ..SendAlert(tAlert)
			Set ..%SessionId = "", $$$JobSessionId = ""

		}

	} Else {

		If $Data(..QueueDelays(pHost),tLastMsgId)#2 {

			#; Only remove queue delay record if different message when no delay detected & less than wait percentage threshold
			#dim tLessThanQWThreshold = 1
			If (pPermittedDelay>0) && ((tTimeQueued/pPermittedDelay) > ..queueWaitResetPercentage) Set tLessThanQWThreshold = 0

			If (tLastMsgId'=tMsgId) && tLessThanQWThreshold {

				Kill ..QueueDelays(pHost)
				Kill $$$EnsAlertedDelay(pHost)
				#dim tResetDelay = pPermittedDelay * ..queueWaitResetPercentage
				#dim tNoMoreQueueDelayTest = "Queue Wait: "_$$$FormatText("Resetting queue wait alert for config item '%1'. It now has a delay less than %2 seconds (permitted alert delay of %3) or an empty queue.",pHost,tResetDelay,pPermittedDelay)
				$$$LOGINFO(tNoMoreQueueDelayTest)

			}

		}

	}

	Quit tSC
}

/// Obtain value used to identify when a known queue wait alert can be cleared
ClassMethod getQWTPct() As %Numeric [ Internal ]
{
	Quit $Get($$$EnsConfigurationGbl("Alerting","QWaitReset"),0.8)
}

/// Change default used for queue wait delay clearance
ClassMethod setQWTPct(pPercent As %Numeric = 0.8) As %Boolean [ Internal ]
{
	If (pPercent > 1) || (pPercent <=0) Quit 0
	Set $$$EnsConfigurationGbl("Alerting","QWaitReset") = pPercent
	Quit 1
}

}
