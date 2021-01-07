/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsAgent

/// Service that accepts connections from Community Connector Agents
Class EnsLib.Agent.ProxyService Extends EnsLib.HTTP.Service [ System = 4 ]
{

// TCP stuff, UI

/// Local cache for options & their default values
Property %OptionDefaults [ MultiDimensional, Transient ];

Property %ReplyStream As %GlobalCharacterStream;

Property %ReplyIOStream As %IO.MetaCharacterStream;

/// List of events for $system.Socket.Select()
Property %EventList As %List [ Internal ];

/// Name of currently connected Agent
Property %ConnectedAgent As %String [ Internal ];

Property %tempSock;

ClassMethod updateAgentInterfacesTable(pConfigName As %String) As %Status
{
	/* !!!
	#; If there have been any config changes, freshen the Interfaces table
	Set tModIndexFlag=$G($$$EnsConfig("%ModIndexFlag"))
	Quit:tModIndexFlag'=""&&($G($$$EnsConfig("%AgentIndexFlag"))>=tModIndexFlag) $$$OK

	Set tOldIndexFlag=$G(^Ens.Config("%AgentIndexFlag"))
	Quit:tModIndexFlag'=""&&(tOldIndexFlag>=tModIndexFlag) $$$OK  ; someone got ahead of us somehow
	Lock +^Ens.Config("%AgentIndexFlag"):30  Set tTimedOut='$Test
	If tTimedOut $$$LOGWARNING("Failed to acquire lock on ^Ens.Config(""%AgentIndexFlag""); not updating Agent Interfaces table")  Quit $$$OK

	#; Skip update if someone else updated while we were waiting for the lock
	Set tAgentIndexFlag=$G(^Ens.Config("%AgentIndexFlag"))
	If tAgentIndexFlag>tOldIndexFlag  Set $$$EnsConfig("%AgentIndexFlag")=tAgentIndexFlag  Lock -^Ens.Config("%AgentIndexFlag")  Quit $$$OK
	*/
	Set tSC=##class(Ens.Config.Production).GetRuntimePortsArray(.tPortsArray)  Quit:$$$ISERR(tSC)
	try {
		Set tSC=$$$OK
		Set tHost="" For { Set tHost=$O($$$ConfigRoot(tHost))  Quit:""=tHost
			Continue:'$G($$$ConfigIsEnabled(tHost))
			Set tFilePath=$G($$$ConfigSetting(tHost,"Adapter","FilePath"))
			If ("@"=$E(tFilePath)) {
				Set tAgent=$E($P(tFilePath,":"),2,*), tXTimeout=$P(tAgent,"(",2), tAgent=$P(tAgent,"(")
				Set:""'=tXTimeout tXTimeout=+tXTimeout
				Set tType=$S($$$eHostTypeOperation=$G($$$ConfigBusinessType(tHost))
						:"File_Drop"
					  ,1:"File_Pick")
				Set tLocation=$P(tFilePath,":",2,$L(tFilePath,":"))
				Set tXPort=""
			} Else {
			Set tIPAddress=$G($$$ConfigSetting(tHost,"Adapter","IPAddress"))
			If ("@"=$E(tIPAddress)) {
				Set tAgent=$E($P(tIPAddress,":"),2,*), tXPort=$P(tAgent,"(",2), tAgent=$P(tAgent,"(")
				Set tType="TCP_Connect"
				Set tLocation=$P(tIPAddress,":",2,$L(tIPAddress,":"))_"|"_$G($$$ConfigSetting(tHost,"Adapter","Port"))
				Set tXTimeout=""
			} Else {
			Set tPort=$G($$$ConfigSetting(tHost,"Adapter","Port"))
			If ("@"=$E(tPort)) {
				Set tAgent=$E($P(tPort,":"),2,*), tXPort=$P(tAgent,"(",2), tAgent=$P(tAgent,"(")
				Set tType="TCP_Listen"
				Set tLocation=$P(tPort,":",2,$L(tPort,":"))
				Set tXTimeout=""
			} Else {
				Continue
			}
			}
			}
			Continue:""=tAgent

			#; Look for Agent/Interface in table
			If '$G(tAgent(tAgent)) {
				Set tAgent(tAgent)=1
				&sql(SELECT %ID,ConfigItem INTO :tID,:tConfigItem FROM EnsLib_Agent.Interface WHERE AgentName = :tAgent AND ClientId=0)
				If SQLCODE=100 {
					#; Add Agent if not there
					&sql(INSERT INTO EnsLib_Agent.Interface (AgentName,Type,ClientId,ConfigItem) VALUES (:tAgent,'Agent',0,:pConfigName))
					If SQLCODE {
						Set tSC=$$$ERROR($$$EnsErrGeneral,"SQL Error inserting Agent '"_tAgent_"':"_SQLCODE)
						Quit
					}
					Set tID=%ROWID, tNow=$$$timeUTC, tDesc="Agent added by updateAgentInterfacesTable(), Job "_$J
					&sql(INSERT INTO EnsLib_Agent.StatusEvent (Interface,Status,Description,EventTime) VALUES (:tID,'Init',:tDesc,:tNow))
					If SQLCODE $$$LOGWARNING("Failed to set initial status for agent "_tAgent_"; SQLCODE="_SQLCODE)
				} ElseIf SQLCODE {
					Set tSC=$$$ERROR($$$EnsErrGeneral,"SQL Error looking for Agent '"_tAgent_"':"_SQLCODE)
					Quit
				}
			}
			&sql(SELECT %ID,ConfigItem,ClientId,ConfigTimeout,RelayPort INTO :tID,:tConfigItem,:tClientId,:tConfigTimeout,:tRelayPort FROM EnsLib_Agent.Interface
					WHERE AgentName = :tAgent AND Type=:tType AND ConfigItem=:tHost)
			#; Add Interface if not there
			If SQLCODE=100 {
				Set tInterface=##class(EnsLib.Agent.Interface).%New()
				Set tInterface.AgentName=tAgent
				Set tInterface.Type=tType
				Set tInterface.Location=tLocation
				Set tInterface.ConfigItem=tHost
				If tType["File_" {
					Set tInterface.ConfigTimeout=$S(""=tXTimeout:30,1:tXTimeout)
				} Else {
					Set tInterface.RelayPort=$S(""=tXPort:..findFreePort(.tPortsArray,.tSC),1:tXPort)  Quit:$$$ISERR(tSC)
				}
				Set tSC=tInterface.%Save()
				If $$$ISERR(tSC) {
					Set tSC=$$$ERROR($$$EnsErrGeneral,"SQL Error adding Agent '"_tAgent_"' "_tType_" interface to '"_tLocation_"':"_$$$StatusDisplayString(tSC))
					Quit
				}
				Set:""'=tInterface.RelayPort tPortsArray(tInterface.RelayPort)=tHost_$S(tType="TCP_Listen":"|L|",1:"|C|")_tID
				$$$sysTRACE("Added Agent '"_tAgent_"' "_tType_" interface "_tInterface.ClientId_" with Location "_tLocation)

				Set tID=tInterface.%Id(), tNow=$$$timeUTC, tDesc="Interface added by updateAgentInterfacesTable() Host "_tHost_", Job "_$J
				&sql(INSERT INTO EnsLib_Agent.StatusEvent (Interface,Status,Description,EventTime) VALUES (:tID,'Init',:tDesc,:tNow))
				If SQLCODE $$$LOGWARNING("Failed to set initial status for interface "_tID_"; SQLCODE="_SQLCODE)
				Continue
			} ElseIf SQLCODE {
				Set tSC=$$$ERROR($$$EnsErrGeneral,"SQL Error looking for Agent '"_tAgent_"':"_SQLCODE)
				Quit
			}
			#; else Update Interface if already there
			Set:""=tXTimeout tXTimeout=tConfigTimeout
			If tType'["File_" {
				Set:""=tXPort tXPort=tRelayPort  Set:""=tXPort tXPort=..findFreePort(.tPortsArray,.tSC)  Quit:$$$ISERR(tSC)
			}
			If (tHost'=tConfigItem) || (tXTimeout'=tConfigTimeout) || (tXPort'=tRelayPort) {
				&sql(UPDATE EnsLib_Agent.Interface (ConfigItem,ConfigTimeout,RelayPort) VALUES (:tHost,:tXTimeout,:tXPort)
						WHERE %ID = :tID)
				If SQLCODE {
					Set tSC=$$$ERROR($$$EnsErrGeneral,"SQL error updating Agent '"_tAgent_"' interface "_tClientId_":"_SQLCODE)
					Quit
				}
				Set:""'=tXPort tPortsArray(tXPort)=tHost_$S(tType="TCP_Listen":"|L|",1:"|C|")_tID
				$$$sysTRACE("Updated Agent '"_tAgent_"' interface "_tClientId_" changing :"_$S(tHost'=tConfigItem:"ConfigItem "_tConfigItem_"->"_tHost_":",1:"")_$S(tXTimeout'=tConfigTimeout:"ConfigTimeout "_tConfigTimeout_"->"_tXTimeout_":",1:"")_$S(tXPort'=tRelayPort:"RelayPort "_tRelayPort_"->"_tXPort,1:""))

				Set tNow=$$$timeUTC, tDesc="Interface updated by updateAgentInterfacesTable() Host "_tHost_", Job "_$J
				&sql(INSERT INTO EnsLib_Agent.StatusEvent (Interface,Status,Description,EventTime) VALUES (:tID,'Init',:tDesc,:tNow))
				If SQLCODE $$$LOGWARNING("Failed to set status for updated interface "_tID_"; SQLCODE="_SQLCODE)
			}
		} ; end Host loop
		//!!!Set:""'=tModIndexFlag&&$$$ISOK(tSC) ^Ens.Config("%AgentIndexFlag")=tModIndexFlag
	} catch {
		Set tSC=$$$SystemError
	}
	//!!!Lock -^Ens.Config("%AgentIndexFlag")
	//!!!Set:""'=tModIndexFlag $$$EnsConfig("%AgentIndexFlag")=tModIndexFlag
	Quit tSC
}

ClassMethod findFreePort(ByRef pPortsArray, pStatus As %Status) As %Integer [ Internal ]
{
	Set pStatus=$$$OK, tPort=""
	try {
		For tEventPort=40001:1:50000 {
			Continue:$D(pPortsArray(tEventPort))
			Set tEventDevice="|TCP|"_tEventPort
			Open tEventDevice:(:tEventPort:"SA"):0
			If $Test Close tEventDevice  Quit  ; relies on locking of AgentIndexFlag
			Set tEventDevice=""
		}
		Set:tEventDevice'="" tPort=tEventPort
	} catch {
		Set pStatus=$$$SystemError
	}
	Quit tPort
}

Method OnInit() As %Status
{
	Set tSC=##super()  Quit:$$$ISERR(tSC) tSC
	Set ..%ReplyStream=##class(%GlobalCharacterStream).%New()
	Set ..%ReplyStream.Attributes("Content-Type")="text/hl7"
	Set ..%ReplyIOStream=##class(%IO.MetaCharacterStream).%New(..%ReplyStream)
	Set ..%ReplyIOStream.Name="HTTP Response"

 ; File_Drop   - N/A ; Stream class
 ; File_Pick   - TargetItem ; Stream class / EnsDir
 ; TCP_Listen  - CfgItem/EnsPort(for Svc to listen on)
 ; TCP_Connect - CfgItem/EnsPort (for Op to talk to)

	Set tSC=..updateAgentInterfacesTable(..%ConfigName)  Quit:$$$ISERR(tSC) tSC

	;; warn if agents unconfigured
	; Open ports for client TCP listeners
	; Create a queue for each Agent that has a FILEPUT interface configured
	; Check mapping table and AgentID within
	Quit $$$OK
}

/// initialize Business Host object
Method initConfig(pConfigName As %String) As %Status [ Internal ]
{
	#; Parse default options arrays
	For tTypeCode = "SA","FP","FD","TC","TL" {
		Set tOpts=$$$GetClassParameter("EnsLib.Agent.Interface",tTypeCode_"Options")
		Set tLen=$L(tOpts,",")  For i=1:1:tLen { Set tOpt=$P(tOpts,",",i)
			Set tName=$ZStrip($P(tOpt,"="),"<>WC"), tVal=$ZStrip($P(tOpt,"=",2,$L(tOpt,"=")),"<>WC")
			Continue:""=tName
			Set ..%OptionDefaults(tTypeCode,tName)=tVal
		}
	}

	#; TCP handling inbound:
	#;	JobPerConnection Child:
	#;		- enqueue to main job
	#;  CSP Job:
	#;		- enqueue to main job (which has no port)
	#;	JobPerConnection Main:
	#;		- dequeue from agent, send TCP to config item's port
	#;	Single job, no Port (agent connections possible only via CSP )
	#;		- dequeue from agent, send TCP to config item's port
	#;	Single job, have Port: (no CSP allowed if any TCP interfaces exist for agents)
	#;		- send TCP to config item's port
	
	#; TCP handling outbound:
	#;	JobPerConnection Child:
	#;		- dequeue for agent
	#;  CSP Job:
	#;		- dequeue for agent
	#;	JobPerConnection Main:
	#;		- wake for TCP, enqueue to agent (c/o child job)
	#;	Single job, no Port (agent connections possible only via CSP )
	#;		- wake for TCP, enqueue to agent (c/o CSP job)
	#;		- Queue for agent c/o child or CSP job
	#;		- don't dequeue for agents
	#;	Single job, have Port: (no CSP allowed if any TCP interfaces exist for agents)
	#;		- keep all TCP sockets ourself
	#;		- check TCP when idle (no wake for TCP)
	Set tSC=##super(.pConfigName) ; calls OnInit()
	If $$$ISERR(tSC) && '..Adapter.JobPerConnection && '..Adapter.Port && $$$StatusEquals(tSC,$$$EnsErrTCPListen) {
		$$$sysTRACE("Initializing Agent TCP helper job for CSP Agent callins")
		Set tSC=$$$OK
	}
	Quit tSC
}

Method OnTask() As %Status
{
	If '..Adapter.JobPerConnection && '..Adapter.Port || (..Adapter.JobPerConnection && (""=$ZU(53))) {
		#; check TCP sockets and forward traffic to associated Agent queue
		// default InboundAdapter behavior: always call ProcessInput on CallInterval
		Set tSC = ..ProcessInput($$$NULLOREF)
		Set ..%WaitForNextCallInterval=0
		Quit:'..Adapter.JobPerConnection&&'..Adapter.Port $$$OK
	}
	Quit ##super()
}

Method initEventList(Output pAlsoConfig As %Boolean) As %Status [ Internal ]
{
	/*
	#; Re-initialize %EventList if needed
	Set tOutQueue=..getOutQueueName()
	Set pAlsoConfig=(("!"=$E(..AllowedIPAddresses)||'..JobPerConnection))
	If tOutQueue'=..OutQueueName {
		Set tOldDev=$LG(..%EventList,2)
		Close:""'=tOldDev tOldDev
		Set i%OutQueueName=tOutQueue
	}
	Set tSC=..OpenEventDevice(.tDev)
	Set:$$$ISOK(tSC) tSC=##class(Ens.Queue).SetEventDevice(tOutQueue,tDev)  Quit:$$$ISERR(tSC) tSC
	Set tOldDev2=$LG(..%EventList,3)
	If pAlsoConfig {
		If ..%EventList'=$LB(..Device,tOutQueue,..%ConfigName) {
			If ""=tOldDev2 {
				Set tSC=..OpenEventDevice(.tDev2)
				Set:$$$ISOK(tSC) tSC=##class(Ens.Queue).SetEventDevice(..%ConfigName,tDev2)  Quit:$$$ISERR(tSC) tSC
			} Else {
				Set tDev2=tOldDev2 ; always our config name; no need to reopen or reset queue
			}
			Set ..%EventList=$LB(..Device,tDev,tDev2)
		}
	} Else {
		If ..%EventList'=$LB(..Device,tOutQueue) {
			Close:""'=tOldDev2 tOldDev2
			Set ..%EventList=$LB(..Device,tDev)
		}
	}
	*/
	Quit $$$OK
}

Method OnProcessInput(pStreamIn As %CharacterStream, Output pStreamOut As %CharacterStream) As %Status
{
	Quit:'$IsObject(pStreamIn) $$$ERROR($$$EnsErrGeneral,"No input request stream")
	Set tVer=$G(pStreamIn.Attributes("skorp-ver"))

	Quit:'tVer $$$ERROR($$$EnsErrGeneral,"Version '"_tVer_"' not recognized")
	Quit:tVer>1 $$$ERROR($$$EnsErrGeneral,"Versions above 1.0 not supported; got request with version "_tVer)
	Set tCmd=$G(pStreamIn.Attributes("skorp-cmd"))
	Set tAgent=$G(pStreamIn.Attributes("skorp-agent"))
	Quit:""=tAgent $$$ERROR($$$EnsErrGeneral,"No Agent Id received")
	Set tPacketId=$G(pStreamIn.Attributes("skorp-msg"))

	; Scan config for @Agent references connections, add Agents/Interfaces
	//!!!Set tSC=..updateAgentInterfacesTable(..%ConfigName)  Quit:$$$ISERR(tSC) tSC
	Set tCmdOut="IDLE"
	Set tClientId=$G(pStreamIn.Attributes("skorp-client"),0)
	If 'tClientId {
		Quit:$Case(tCmd,"TCP":1, "FILE":1, :0) $$$ERROR($$$EnsErrGeneral,"No Interface Client Id received for agent '"_tAgent_"'")
		&sql(SELECT %ID INTO :tID FROM EnsLib_Agent.Interface WHERE AgentName = :tAgent AND ClientId = 0)
		Quit:SQLCODE $$$ERROR($$$EnsErrGeneral,"Root Interface record not found for Agent '"_tAgent_"'")
	} Else {
		&sql(SELECT %ID INTO :tID FROM EnsLib_Agent.Interface WHERE AgentName = :tAgent AND ClientId = :tClientId)
		Quit:SQLCODE $$$ERROR($$$EnsErrGeneral,"Unknown client interface '"_tClientId_"' for agent '"_tAgent_"'")
	}
	Set tInterface=##class(EnsLib.Agent.Interface).%OpenId(tID,,.tSC)

	Do ..%ReplyStream.Clear()
	Do ..%ReplyIOStream.Flush()
	Set pStreamOut=..%ReplyStream
	Set pStreamOut.Attributes("Content-Type")="application/octet-stream"

	Set tSC=$Case(tCmd
				, "INIT":      ..doInit(tAgent,pStreamIn,.pStreamOut,.tCmdOut)
				, "POLL":      $$$OK
				, "FILE":      ..doFile(tInterface,pStreamIn,.pStreamOut,.tCmdOut)
				, "TCP":       ..doTCP(tInterface,pStreamIn,.pStreamOut,.tCmdOut)
				, "STATUS":    ..doStatus(tInterface,pStreamIn,.pStreamOut,.tCmdOut)
				, "ERROR":     ..doError(tInterface,pStreamIn,.pStreamOut,.tCmdOut)
				, "QUIESCENT": ..doQuiescent(tInterface,pStreamIn,.pStreamOut,.tCmdOut)
				, "GOODBYE":   ..doGoodbye(tInterface,pStreamIn,.pStreamOut,.tCmdOut)
				, "":          $$$ERROR($$$EnsErrGeneral,"No Command")
				, :$$$ERROR($$$EnsErrGeneral,"Unrecognized Command:"_tCmd))
	Quit:$$$ISERR(tSC) tSC
	If tCmdOut="IDLE" {
		#; If the Agent has finished initializing, see if we can dequeue something to send back
		If tClientId=0 {
			Set tAvailability=tInterface.Availability
		} Else {
			#; Get Agent's overall root availability
			&sql(SELECT Availability INTO :tAvailability FROM EnsLib_Agent.Interface WHERE AgentName = :tAgent and ClientId = 0)
			Quit:SQLCODE $$$ERROR($$$EnsErrGeneral,"Availability from root agent Interface record not found for Agent '"_tAgent_"'")
		}
	Set tAvailability="Ready" ; !!!
		If "Ready"'=tAvailability &&("Partial"'=$E(tAvailability,1,$L("Partial"))) {
			$$$sysTRACE("Not checking for outbound traffic to agent "_tAgent_" because it has not-ready combined Availability "_tAvailability)
		} Else {
			#; See if we have anything to send back
			$$$ASSERTNOLOG('pStreamOut.Size)
			//Set tSC=..initEventList(.tAlsoConfig)  Quit:$$$ISERR(tSC)
			#; Check Agent queue for the agent whose call we're handling
			Set tSC = ##class(Ens.Queue).DeQueue("@"_tAgent,.tOutHdr,0)  Quit:$$$ISERR(tSC)
			If $IsObject(tOutHdr) {
				Set tSC=..forwardStream(tAgent,tOutHdr,.pStreamOut,.tCmdOut)
			} ElseIf '..Adapter.JobPerConnection && '$G($$$EnsJobLocal("TCPIn.OutsideJob")) {
				#; If nothing in queue and we're a single-job listener, check TCP ports for traffic to forward
				Set tSC=..forwardTCP(tAgent,.pStreamOut,.tCmdOut)
			}
		}
		If $$$ISERR(tSC) { $$$sysTRACE("Hanging 4 because returning error")  Hang 4 } ; !!!!
		ElseIf tCmdOut="IDLE"&&(tCmd="POLL") { $$$sysTRACE("Hanging 4 because idle") Hang 4 } ; !!!!
	}
	Set pStreamOut.Attributes("Skorp-Cmd")=tCmdOut

	#; Get options for main interface for the Agent that has called in
	&sql(SELECT Description,Type,Location INTO :tDesc,:tType,:tLocation FROM EnsLib_Agent.Interface WHERE AgentName = :tAgent AND ClientId = 0)
	Set:SQLCODE tOptions=""
	Kill tOpts  Merge tOpts=..%OptionDefaults("SA")
	&sql(Declare C0 Cursor for
		SELECT element_key,Options INTO :tKey,:tVal FROM EnsLib_Agent.Interface_Options WHERE Interface->AgentName=:tAgent AND Interface->ClientId=0)
	&sql(OPEN C0) For { &sql(FETCH C0)  Quit:SQLCODE
		Set k=$ZStrip(tKey,"<>WC"), v=$ZStrip(tVal,"<>WC")
		Continue:""=k
		If '$D(tOpts(k)) $$$LOGWARNING("Found Agent "_tAgent_" main Interface 0 with Type '"_tType_"' and unrecognized option "_k_"="_v)
		Set tOpts(k)=v
	} Set tCode=SQLCODE &sql(CLOSE C0) Set:'SQLCODE SQLCODE=tCode
	If SQLCODE'=100&&SQLCODE Set tSC=$$$ERROR($$$EnsErrGeneral,"SQL error fetching Interfaces for agent '"_tAgent_"'; SQLCODE="_SQLCODE)  Quit
	Set (tOptStr,k)="" For { Set k=$O(..%OptionDefaults("SA",k))  Quit:""=k
		Set tOptStr=tOptStr_","_k_"="_tOpts(k)
	}
	Set tOptStr=$E(tOptStr,2,*)
	Set tStayConnected=$G(tOpts("SA_StayConnected"))
	Set:$L(tStayConnected)&&(+tStayConnected=tStayConnected) pStreamOut.Attributes("Keep-Alive")=$Case(tStayConnected,0:0,-1:"timeout=99999",:"timeout="_tStayConnected)

	Quit tSC
}

Method doInit(pAgent As %String, pStreamIn As %CharacterStream, ByRef pStreamOut As %CharacterStream, pCmdOut As %String) As %Status [ Internal ]
{
	#; payload is OS, JVM, IP addresses
	Set tSC=$$$OK
	Set tLine=pStreamIn.Read()

	Set tOS=$P(tLine,"|",1)
	Quit:""=tOS $$$ERROR($$$EnsErrGeneral,"No OS identifier received")

	Set tJVM=$P(tLine,"|",2)
	Quit:""=tJVM $$$ERROR($$$EnsErrGeneral,"No JVM identifier received")

	Set tIPv4=$P(tLine,"|",3)
	Quit:""=tIPv4 $$$ERROR($$$EnsErrGeneral,"No IPv4 address received")

	Set tIPv6=$P(tLine,"|",4)
	Quit:""=tIPv6 $$$ERROR($$$EnsErrGeneral,"No IPv6 address received")

	Set tAgent=pAgent

	#; Respond with INIT
	Set pCmdOut="INIT"
	#; Loop over all clients for this agent outputting INIT lines for them
	Set tFirst=1
	&sql(Declare C1 Cursor for
		SELECT ClientId,Description,Type,Location INTO :tClientId,:tDesc,:tType,:tLocation FROM EnsLib_Agent.Interface WHERE AgentName = :tAgent ORDER BY ClientId)
	&sql(OPEN C1) For { &sql(FETCH C1)  Quit:SQLCODE
		Set tOptStr=""
		If tFirst {
			Set tFirst=0
			If tClientId'=0 {
				#; Create artificial Agent config if none found in agent table
				Set k="" For { Set k=$O(..%OptionDefaults("SA",k),1,v)  Quit:""=k
					Set tOptStr=tOptStr_","_k_"="_v
				}
				Set tOptStr=$E(tOptStr,2,*)
				$$$LOGWARNING("No Agent config entry found in Interfaces table for agent "_tAgent_"; Using default options "_tOptStr)
				Do pStreamOut.Write("0|"_tAgent_" default config|||"_tOptStr_$C(13,10))
				Set tOptStr=""
			}
		}
		#; Construct options string from Interface options array
		Set tTypeCode=$Case(tType,"Agent":"SA", "":"SA", "File_Pick":"FP", "File_Drop":"FD", "TCP_Connect":"TC", "TCP_Listen":"TL", :"xx")
		If tTypeCode="xx" $$$LOGWARNING("Found Agent "_tAgent_" Interface "_tClientId_" with unrecognized Type '"_tType_"'")  Continue
		Kill tOpts  Merge tOpts=..%OptionDefaults(tTypeCode)
		&sql(Declare C2 Cursor for
			SELECT element_key,Options INTO :tKey,:tVal FROM EnsLib_Agent.Interface_Options WHERE Interface->AgentName=:tAgent AND Interface->ClientId=:tClientId)
		&sql(OPEN C2) For { &sql(FETCH C2)  Quit:SQLCODE
			Set k=$ZStrip(tKey,"<>WC"), v=$ZStrip(tVal,"<>WC")
			Continue:""=k
			If '$D(tOpts(k)) $$$LOGWARNING("Found Agent "_tAgent_" Interface "_tClientId_" with Type '"_tType_"' and unrecognized option "_k_"="_v)
			Set tOpts(k)=v
		} Set tCode=SQLCODE &sql(CLOSE C2) Set:'SQLCODE SQLCODE=tCode
		If SQLCODE'=100&&SQLCODE Set tSC=$$$ERROR($$$EnsErrGeneral,"SQL error fetching Interfaces for agent '"_tAgent_"'; SQLCODE="_SQLCODE)  Quit

		Set k="" For { Set k=$O(..%OptionDefaults(tTypeCode,k))  Quit:""=k
			Set tOptStr=tOptStr_","_k_"="_tOpts(k)
		}
		Set tOptStr=$E(tOptStr,2,*)
		Do pStreamOut.Write(tClientId_"|"_tDesc_"|"_tType_"|"_tLocation_"|"_tOptStr_$C(13,10))
	} Set tCode=SQLCODE &sql(CLOSE C1) Set:'SQLCODE SQLCODE=tCode
	Quit:SQLCODE'=100&&SQLCODE&&$$$ISOK(tSC) $$$ERROR($$$EnsErrGeneral,"SQL error fetching Interfaces for agent '"_tAgent_"'; SQLCODE="_SQLCODE)
	Quit tSC
}

Method doFile(pInterface As EnsLib.Agent.Interface, pStreamIn As %CharacterStream, ByRef pStreamOut As %CharacterStream, pCmdOut As %String) As %Status [ Internal ]
{
	#; Forward file as stream to associated BusinessOperation
	Set tFilename=$G(pStreamIn.Attributes("skorp-name"))
	Set:""=tFilename tFilename="Agent-"_pInterface.AgentName_"-"_$G(^Ens.MessageHeaderD)
	
	Set tStream=##class(%FileBinaryStream).%New()
	Set tStream.Attributes("Filename")=tFilename
	Set tStream.Attributes("Agent")=pInterface.AgentName
	Set tSC=tStream.CopyFrom(pStreamIn)
	Set:$$$ISOK(tSC) tSC=tStream.SaveStream()
	Set:$$$ISOK(tSC) tMsg=##class(Ens.StreamContainer).%New(tStream)
	Set:$$$ISOK(tSC) tMsg.OriginalFilename=tFilename
	Set:$$$ISOK(tSC) tSC=..SendRequestAsync(pInterface.ConfigItem,tMsg,pInterface.AgentName)

	Set pCmdOut="STATUS"
	Set pStreamOut.Attributes("Skorp-Agent")=pInterface.AgentName
	Set pStreamOut.Attributes("Skorp-Client")=pInterface.ClientId
	If $$$ISOK(tSC) {
		Set pStreamOut.Attributes("Skorp-Status")=$$$SkorpEStatusFPAcceptOK
	} Else {
		Set pStreamOut.Attributes("Skorp-Status")=$$$SkorpEStatusFPAcceptFailed
		Do pStreamOut.Write($$$StatusDisplayString(tSC))
	}
	Quit tSC
}

Method doTCP(pInterface As EnsLib.Agent.Interface, pStreamIn As %CharacterStream, ByRef pStreamOut As %CharacterStream, pCmdOut As %String) As %Status [ Internal ]
{
	Set tTempSock=$G(pStreamIn.Attributes("skorp-sock"))
	Quit $$$ERROR($$$EnsErrGeneral,"Command TCP not supported yet")
}

Method doQuiescent(pInterface As EnsLib.Agent.Interface, pStreamIn As %CharacterStream, ByRef pStreamOut As %CharacterStream, pCmdOut As %String) As %Status [ Internal ]
{
	Quit $$$ERROR($$$EnsErrGeneral,"Command Quiescent not supported yet")
}

Method doStatus(pInterface As EnsLib.Agent.Interface, pStreamIn As %CharacterStream, ByRef pStreamOut As %CharacterStream, pCmdOut As %String) As %Status [ Internal ]
{
	Set tStatus = pStreamIn.Attributes("skorp-status")
	Do pInterface.AddStatus(tStatus,pStreamIn.Read())
	If pInterface.Type="File_Drop" {
		If tStatus=$$$SkorpStatusFDStarted {
			Do pInterface.SetAvailability("Ready")
		} ElseIf tStatus=$$$SkorpStatusFDStartError {
			Do pInterface.SetAvailability("Failed")
		} ElseIf tStatus=$$$SkorpStatusFDStopped {
			Do pInterface.SetAvailability("Stopped")
		}
	} ElseIf pInterface.Type="File_Pick" {
		If tStatus=$$$SkorpStatusFPStarted {
			Do pInterface.SetAvailability("Ready")
		} ElseIf tStatus=$$$SkorpStatusFPStartError {
			Do pInterface.SetAvailability("Failed")
		} ElseIf tStatus=$$$SkorpStatusFPStopped {
			Do pInterface.SetAvailability("Stopped")
		}
	} ElseIf pInterface.Type="TCP_Connect" {
		If tStatus=$$$SkorpStatusTCStarted {
			Do pInterface.SetAvailability("Ready")
		}
	} ElseIf pInterface.Type="TCP_Listen" {
		If tStatus=$$$SkorpStatusTLStarted {
			Do pInterface.SetAvailability("Ready")
		} ElseIf tStatus=$$$SkorpStatusFPStartError {
			Do pInterface.SetAvailability("Failed")
		} ElseIf tStatus=$$$SkorpStatusFPStopped {
			Do pInterface.SetAvailability("Stopped")
		}
	} ElseIf pInterface.Type="Agent" {
		If tStatus=$$$SkorpStatusSATerminated {
			Set tAgent = pInterface.AgentName
			&sql(Declare C3 Cursor for
				SELECT ID INTO :tId FROM EnsLib_Agent.Interface WHERE AgentName=:tAgent AND ClientId<>0)
			&sql(OPEN C3) For { &sql(FETCH C3)  Quit:SQLCODE
				Set agentInterface = ##class(EnsLib.Agent.Interface).%OpenId(tId)
				Do agentInterface.SetAvailability("Stopped")
			} Set tCode=SQLCODE &sql(CLOSE C3) Set:'SQLCODE SQLCODE=tCode
			If (SQLCODE'=100 && SQLCODE) { 
				Quit $$$ERROR($$$EnsErrGeneral,"SQL error fetching Interfaces for agent '"_tAgent_"'; SQLCODE="_SQLCODE)  
			}
		}
	}
	Quit $$$OK
}

Method doError(pInterface As EnsLib.Agent.Interface, pStreamIn As %CharacterStream, ByRef pStreamOut As %CharacterStream, pCmdOut As %String) As %Status [ Internal ]
{
	Quit $$$ERROR($$$EnsErrGeneral,"Command Error not supported yet")
}

Method doGoodbye(pInterface As EnsLib.Agent.Interface, pStreamIn As %CharacterStream, ByRef pStreamOut As %CharacterStream, pCmdOut As %String) As %Status [ Internal ]
{
	#; Disconnect and go back to waiting
	Quit $$$ERROR($$$EnsErrGeneral,"Command Goodbye not supported yet")
}

Method forwardStream(pAgent As %String, pOutHdr As Ens.MessageHeader, ByRef pStreamOut As %CharacterStream, pCmdOut As %String) As %Status [ Internal ]
{
	#; Forward file from stream to targeted Agent Interface
	Do pOutHdr.SetStatus($$$eMessageStatusDelivered)
	Set (..%SessionId,$$$JobSessionId) = pOutHdr.SessionId

	#; Find Interface for this agent with ConfigItem = msg header source config item
	Set tSC=$$$OK, tConfigItem=pOutHdr.SourceConfigName
	&sql(SELECT %ID,Availability INTO :tID,:tAvailability FROM EnsLib_Agent.Interface WHERE AgentName = :pAgent AND ConfigItem = :tConfigItem)
	Set:SQLCODE tSC=$$$ERROR($$$EnsErrGeneral,"No interface found for Agent "_pAgent_" and config item "_tConfigItem_"; SQLCODE="_SQLCODE)
	//!!! Set:"Ready"'=tAvailability&&$$$ISOK(tSC) tSC=$$$ERROR($$$EnsErrGeneral,"Interface "_tID_" is not ready; Availability = "_tAvailability)
	Set:$$$ISOK(tSC) tInterface=##class(EnsLib.Agent.Interface).%OpenId(tID,,.tSC)
	If $$$ISERR(tSC) {
		Do pOutHdr.SetStatus($$$eMessageStatusDiscarded)
		Kill $$$EnsActiveMessage($$$SystemName_":"_$Job)
		Set ..%SessionId = ""  Kill $$$JobSessionId
		Quit tSC
	}
	#; Now open the stream
	try {
		If ""'=pOutHdr.MessageBodyClassName && $classmethod(pOutHdr.MessageBodyClassName,"%Extends","Ens.StreamContainer") {
			Set tMsgIn = $classmethod(pOutHdr.MessageBodyClassName,"%OpenId",pOutHdr.MessageBodyId,,.tSC)
			If '$IsObject(tMsgIn) Set tSC=$$$EnsError($$$EnsErrGeneral,"Could not open MessageBody "_pOutHdr.MessageBodyId_" for MessageHeader #"_pOutHdr.%Id()_" with body class "_pOutHdr.MessageBodyClassName_":"_$$$StatusDisplayString(tSC)) Quit
		} Else {
			Set tSC=$$$EnsError($$$EnsErrGeneral,"Only Ens.StreamContainer message bodies are accepted on the agent queue; found message body of class "_pOutHdr.MessageBodyClassName_" for MessageHeader #"_pOutHdr.%Id())
			Do pOutHdr.SetStatus($$$eMessageStatusDiscarded)
		}
	} catch {
		Set tSC=$$$EnsError($$$EnsErrGeneral,"Only Ens.StreamContainer message bodies are accepted on the agent queue; error testing message body for MessageHeader #"_pOutHdr.%Id()_": "_$ZE)
		Do pOutHdr.SetStatus($$$eMessageStatusDiscarded)
	}
	If $$$ISERR(tSC) {
		$$$LOGSTATUS(tSC)
		Do pOutHdr.SetStatus($$$eMessageStatusError)
		Kill $$$EnsActiveMessage($$$SystemName_":"_$Job)
		Set ..%SessionId = ""  Kill $$$JobSessionId
		Quit $$$OK
	}
	$$$sysTRACE("Forwarding stream '"_tMsgIn.OriginalFilename_"' ("_tMsgIn.Stream.Size_") to agent '"_tInterface.AgentName_"' interface "_tInterface.ClientId_" with location "_tInterface.Location_" from proxy '"_pOutHdr.SourceConfigName_"'")

	Set pCmdOut=$S(tInterface.Type["File_":"FILE", 1:"TCP")
	Set pStreamOut=tMsgIn.Stream
	Kill pStreamOut.Attributes
	Set pStreamOut.Attributes("Content-Type")="application/octet-stream"
	Set pStreamOut.Attributes("Skorp-Agent")=tInterface.AgentName
	Set pStreamOut.Attributes("Skorp-Client")=tInterface.ClientId
	Set pStreamOut.Attributes("Skorp-Name")=pOutHdr.Description
	Do pOutHdr.SetStatus($$$eMessageStatusCompleted)
	Kill $$$EnsActiveMessage($$$SystemName_":"_$Job)
	Set ..%SessionId = ""  Kill $$$JobSessionId
	Quit $$$OK
}

Method forwardTCP(pAgent As %String, ByRef pStreamOut As %CharacterStream, pCmdOut As %String) As %Status [ Internal ]
{
	Set tSC= $$$ERROR($$$EnsErrGeneral,"TCP forwarding not supported yet")
	Quit $$$OK
}

/// Control the type and content of error returned to the REST caller
ClassMethod OnErrorStream(pStatus As %Status, pInstance As EnsLib.Agent.ProxyService)
{
	Set tStream = ##class(%GlobalBinaryStream).%New()  $$$ASSERT($IsObject(tStream))
	Do tStream.Write($ZConvert($$$StatusDisplayString(pStatus)_$C(13,10),"O","UTF8"))
	Set tStream.Attributes("Content-Type")="text/plain; charset=""UTF-8"""
	Set tStream.Attributes("ResponseCode")="500 Internal Server Error"
	Quit tStream
}

}
