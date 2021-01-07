/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class Ens.Activity.Operation.Base Extends Ens.BusinessOperation [ Abstract, ClassType = "", Inheritance = right, ProcedureBlock, System = 4 ]
{

/// How frequently the activity statistics should be moved into permanent storage. <br>
/// 0 means do not check. Default is 60 seconds.
Property RecordStatsInterval As %Numeric [ InitialExpression = 60 ];

Property %Instance As %String(MAXLEN = 128) [ InitialExpression = {##class(%SYS.System).GetUniqueInstanceName()}, Private, Transient ];

Property %StatsInterval As %Integer [ InitialExpression = {##class(Ens.Util.Statistics).StatsCounterInterval()}, Private, Transient ];

/// How long to keep retrying before giving up and returning an error code. <br/>
/// -1 means never give up.
Property FailureTimeout As %Numeric(MINVAL = -1) [ InitialExpression = -1 ];

Parameter SETTINGS = "RecordStatsInterval";

Method OnInit() As %Status
{
	If ..RecordStatsInterval>0 Set ..Adapter.KeepaliveInterval=..RecordStatsInterval
	Quit ##super()
}

Method OnKeepalive(pAdapterStatus As %Status) As %Status
{
	#dim tSC As %Status = $$$OK
	#dim e As %Exception.AbstractException
	
	#dim tNamespace, tHostName, tUserDimension, tUTC As %String
	#dim tDay, tSecondsSlot, tHostType, tCount, tSeconds As %Integer
	#dim tTimeStampDay, tTimeStampSeconds As %Integer
	
	#dim tDuration, tQueueDuration, tSquares As %Numeric
	
	If $$$ISOK(pAdapterStatus),(..RecordStatsInterval>0) {
		Try {
			// Sample data:
			// $$$StatsPersistCountersRoot("DEVBUS~2336",63334,6704,1,"RESTaCSP3","enterpriseid 525","count") = 20
			// $$$StatsPersistCountersRoot("DEVBUS~2336",63334,6704,1,"RESTaCSP3","enterpriseid 525","duration") = .225824
			// $$$StatsPersistCountersRoot("DEVBUS~2336",63334,6704,1,"RESTaCSP3","enterpriseid 525","queue") = .5
			// $$$StatsPersistCountersRoot("DEVBUS~2336",63334,6704,1,"RESTaCSP3","enterpriseid 525","d2") = .0144
			Set tNamespace = $O($$$StatsPersistCountersRoot(($NAMESPACE_"~")))
			While ($NAMESPACE=$P(tNamespace,"~",1)) {
				Set tDay = ""
				Set tTimeStampDay = $ZTS
				Set tTimeStampSeconds = $P(tTimeStampDay,",",2)\..%StatsInterval*..%StatsInterval // Current tSeconds slot
				Set tTimeStampDay = +tTimeStampDay
				For {
					Set tDay = $O($$$StatsPersistCountersRoot(tNamespace,tDay))
					If (tDay="") Quit
					Set tSecondsSlot = ""
					For {
						Set tSecondsSlot = $O($$$StatsPersistCountersRoot(tNamespace,tDay,tSecondsSlot))
						If tSecondsSlot="" Quit
						If (tDay<tTimeStampDay) || ((tDay=tTimeStampDay) && ($P(tSecondsSlot,",",2)<tTimeStampSeconds)) {
							// Time slot is in the past
							Set tHostType = ""
							For {
								Set tHostType = $O($$$StatsPersistCountersRoot(tNamespace,tDay,tSecondsSlot,tHostType))
								If tHostType="" Quit
								Set tHostName = ""
								For {	
									Set tHostName = $O($$$StatsPersistCountersRoot(tNamespace,tDay,tSecondsSlot,tHostType,tHostName))
									If tHostName="" Quit
									Set tUserDimension = ""
									For {
										Set tUserDimension = $O($$$StatsPersistCountersRoot(tNamespace,tDay,tSecondsSlot,tHostType,tHostName,tUserDimension))
										If tUserDimension="" Quit
										Set tCount = $G($$$StatsPersistCountersRoot(tNamespace,tDay,tSecondsSlot,tHostType,tHostName,tUserDimension,"count"),0)
										Set tDuration = $G($$$StatsPersistCountersRoot(tNamespace,tDay,tSecondsSlot,tHostType,tHostName,tUserDimension,"duration"),0)
										Set tQueueDuration = $G($$$StatsPersistCountersRoot(tNamespace,tDay,tSecondsSlot,tHostType,tHostName,tUserDimension,"queue"),0)
										Set tSquares = $G($$$StatsPersistCountersRoot(tNamespace,tDay,tSecondsSlot,tHostType,tHostName,tUserDimension,"d2"),0)
										Set tSeconds = (tSecondsSlot*..%StatsInterval)
										Set tUTC = $ZDT(tDay_","_tSeconds,3)
										Set tLocalTime = $$$timeUTCtoLocal(tUTC)
										#;"SC" = stats counters										
										Set tSC = ..OnAddActivity("SC",tDay,tSecondsSlot,tLocalTime, tUTC, ..%Instance, tNamespace, tHostType, tHostName, $ZSTRIP(tUserDimension,"<>W"), tCount, tDuration, tQueueDuration, tSquares)
										If tSC {
											Kill $$$StatsPersistCountersRoot(tNamespace,tDay,tSecondsSlot,tHostType,tHostName,tUserDimension) // Not using a lock here to avoid slowing things down, it is unlikely to need a lock as only sending data in past tSeconds slot
										} Else {
											Throw ##class(%Exception.StatusException).CreateFromStatus(tSC)
										}
									} // End loop on tUserDimension
								} // End loop on tHostName
							} // End loop on tHostType
						} // End if
					} // End loop on tSecondsSlot
				} // End loop on tDay
				Set tNamespace = $O($$$StatsPersistCountersRoot(tNamespace))
			} // End while tNamespace
		} Catch e {
			Set tSC = e.AsStatus()
		}
		If $$$ISERR(tSC) {
			Set pAdapterStatus = tSC
		} Else {
			$$$SetHostMonitor(..%ConfigName,$$$eMonitorStatus,"OK")
			#If ..#INVOCATION="Queue"
				$$$SetJobMonitor(..%ConfigName,$$$SystemName_":"_$Job,$$$eMonitorStatus,"OK")
			#EndIf
		}
	} //End if pAdapterStatus ok
	Quit ##super(pAdapterStatus)
}

/// SubClass responsibility <br>
/// Only return an error if expect a retry will be successful as 
/// returning an error will mean the temporary data is not deleted <br>
/// Expected parameters are 
/// "SC",tLocalTime, tUTC, ..%Instance, tNamespace, tHostType, tHostName, tUserDimension, tCount, tDuration, tQueueDuration, tSquares
Method OnAddActivity(pStatsCategory As %String = "SC", pDays, pSeconds, pLocalTime, pUTC, pInstance, pNamespace, pHostType, pHostName, pUserDimension, pCount, pDuration, pQueueduration, pSquares) As %Status
{
	Quit $$$ERROR($$$NotImplemented)
}

}
