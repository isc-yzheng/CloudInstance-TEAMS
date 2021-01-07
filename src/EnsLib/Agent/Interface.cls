/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include Ensemble

/// instances of this class represent configuration linkages : entries in a table of client interfaces
Class EnsLib.Agent.Interface Extends (%Persistent, %XML.Adaptor) [ System = 4 ]
{

Index InterfaceId On (AgentName, ClientId) [ IdKey, Unique ];

Index AgentTypeConfig On (AgentName, Type, ConfigItem) [ Unique ];

/* Agent side settings */
/// Name of the Agent this interface communicates with
Property AgentName As %String(MAXLEN = 128) [ Required ];

/// Number of the client interface for a given Agent. Interface 0 is for the agent itself
Property ClientId As %Integer;

/// Type of interface on the agent; if empty then the interface is for the agent itself and the ClientId is 0
Property Type As %String(MAXLEN = 11, VALUELIST = ",Agent,File_Drop,File_Pick,TCP_Connect,TCP_Listen");

/// Descriptive name of the interface
Property Description As %String(MAXLEN = "");

/// File path or TCP Address/Port for the interface
Property Location As %String(MAXLEN = "");

/// Options for the interface to be sent to the remote agent; some may be derived from the ConfigItem
Property Options As array Of %String;

/* Options and default option values for each Type */
/// General Agent options
Parameter SAOptions = "SA_PollInterval=12,SA_StayConnected=20";

/// File_Drop options
Parameter FDOptions = "FD_CreateDir=0,FD_UseTemp=*";

/// File_Pick options
Parameter FPOptions As %String = "FP_DeleteWhenDone=1,FP_CreateDir=0,FP_DirPollingInterval=20,FP_ConfirmSizeInterval=0,FP_MinutesRecent=0,FP_Wildcard=*";

/// TCP_Connect options
Parameter TCOptions As %String = "TC_IdleDisconnect=0,TC_ConnectTimeout=20,TC_ReadTimeout=10,TC_CallInterval=2";

/// TCP_Listen options
Parameter TLOptions As %String = "TL_MaxSockets=4,TL_IdleDisconnect=0,TL_ReadTimeout=10,TL_CallInterval=2";

/* server side settings */
/// Associated config item for settings: if any then affinity with the named configured Agent.ProxyService; if empty the first Agent.ProxyService found will be used.
Property ConfigItem As %String(MAXLEN = 128);

/// Number of seconds the associated config item should wait for a synchronous confirmation from the Agent of outbound traffic on this interface
Property ConfigTimeout As %Numeric [ InitialExpression = 30 ];

/// Local port to use in relaying TCP traffic to the Agent.ProxyService
Property RelayPort As %Integer;

/// Notes about the interface
Property Notes As %String(MAXLEN = "");

/// Availability of Interface or of Agent as a whole (when ClientId=0). 'Partial...' and 'Overdue' values apply only to Agent root interface records.
Property Availability As %String(VALUELIST = ",Init,Ready,Failed,Stopped,Partial,PartialFailed,PartialStopped,Overdue", XMLPROJECTION = "None") [ InitialExpression = "Init" ];

/// Authentication for the client
Property Credential As %String(MAXLEN = "");

ClassMethod GetAgentService(pAgentName As %String, pConfigName As %String, Output pAgentService As %String, Output pParam As %String) As %Status
{
	Set pParam=$P($P(pAgentName,"(",2),")"), tAgent=$P(pAgentName,"(")
	Quit:""=tAgent $$$ERROR($$$EnsErrGeneral,"Can't find Agent with empty Name "_pAgentName)
	&sql(SELECT ConfigItem INTO :pAgentService FROM EnsLib_Agent.Interface WHERE AgentName = :tAgent AND ClientId = 0)
	If ""=pAgentService || SQLCODE {
		#; just find any agent service - first try Interfaces table, then runtime config table
		&sql(SELECT ConfigItem INTO :pAgentService FROM EnsLib_Agent.Interface WHERE ClientId = 0 AND ConfigItem <> '' AND ConfigItem IS NOT NULL)
		If ""=pAgentService || SQLCODE {
			Set pAgentService="" For { Set pAgentService=$O($$$EnsConfig(pAgentService))  Quit:""=pAgentService
				try {
					Set tExt=$classmethod($$$EnsConfig(pAgentService,"ClassName"),"%Extends","EnsLib.Agent.ProxyService")
				} catch {
					Set tExt=0
				}
				Quit:tExt
			}
		}
	}
	Quit:""=pAgentService $$$ERROR($$$EnsErrGeneral,"No Configured Agent.ProxyService item found")
	&SQL(SELECT Type, ConfigTimeout, RelayPort INTO :tType, :tTimeout, :tPort  FROM EnsLib_Agent.Interface WHERE AgentName = :tAgent AND ConfigItem = :pConfigName)
	Quit:SQLCODE $$$ERROR($$$EnsErrGeneral,"No stored Agent Interface record found for AgentName="_tAgent_" and ConfigItem="_pConfigName)
	If $Case(tType, "File_Pick":1, "TCP_Connect":1, "TCP_Listen":1, :0) {
		If tType = "File_Pick" {
			Set:""=pParam pParam=tTimeout
			If ""=pParam {
				#; Check table default value
				&SQL(SELECT ConfigTimeout INTO :pParam FROM EnsLib_Agent.Interface WHERE AgentName = '*' AND ClientId=0)
				Set:SQLCODE pParam=""
			}
			Set:""=pParam pParam=30 ; last resort default
		} Else {
			Set:""=pParam pParam=tPort
			If ""=pParam {
				#; Check table default value
				&SQL(SELECT RelayPort INTO :pParam FROM EnsLib_Agent.Interface WHERE AgentName = '*' AND ClientId=0)
				Set:SQLCODE pParam=""
			}
			Set:""=pParam pParam=3030 ; last resort default !!!
		}
	}
	Quit $$$OK
}

/// Construct a new StatusEvent entry for the current Interface
Method AddStatus(pCode, pText)
{
	Set tID=..%Id(), tTime=$$$timeUTC
	&sql(INSERT INTO EnsLib_Agent.StatusEvent (Interface,Status,Description,EventTime) VALUES (:tID,:pCode,:pText,:tTime))
	If SQLCODE {
		$$$LOGWARNING("SQL Error inserting StatusEvent "_pCode_" for Interface '"_tID_"':"_pText_"; SQLCODE="_SQLCODE)
	}
}

/// Set and immediately save the Availability field of this Interface object and its parent Agent
Method SetAvailability(pAvailability As %String)
{
	Set tID=..%Id()
	&sql(UPDATE EnsLib_Agent.Interface Set Availability = :pAvailability WHERE %ID = :tID)
	If SQLCODE $$$LOGWARNING("Failed to update Availability of interface "_..%Id()_" to "_pAvailability_"; SQLCODE="_SQLCODE)
	Set ..Availability=pAvailability

	#; now update availability of parent
	Set tAgent=..AgentName, (tInit,tReady,tFailed,tStopped)=0, tAgentAvail=""
	&sql(Declare C1 Cursor for
		SELECT Availability,ClientId INTO :tAvail,:tClientId FROM EnsLib_Agent.Interface WHERE AgentName = :tAgent ORDER BY ClientId)
	&sql(OPEN C1) For { &sql(FETCH C1)  Quit:SQLCODE
		If tClientId=0 {
			Set tAgentAvail=tAvail
			Continue
		}
		If tAvail = "Init" {
			Set tInit=tInit+1
		} ElseIf tAvail = "Ready" {
			Set tReady=tReady+1
		} ElseIf tAvail = "Failed" {
			Set tFailed=tFailed+1
		} ElseIf tAvail = "Stopped" {
			Set tStopped=tStopped+1
		} Else {
			$$$LOGWARNING("Unknown Availability status '"_tAvail_"' for agent "_..%Id())
		}
	} Set tCode=SQLCODE &sql(CLOSE C1) Set:'SQLCODE SQLCODE=tCode
	If ""=tAgentAvail $$$LOGWARNING("No Root Interface record Availability found for Agent '"_tAgent_"'")  Quit
	If SQLCODE'=100&&SQLCODE {
		$$$LOGWARNING("SQL error fetching interface Availabilities for agent '"_tAgent_"'; SQLCODE="_SQLCODE)
	} Else { ; Init,Ready,Failed,Stopped,Partial,PartialFailed,PartialStopped,Overdue
		Set tNewAvail=$S('tReady:$S(tFailed:"Failed",tStopped:"Stopped",1:"Init"),
							1:$S(tFailed:"PartialFailed",tStopped:"PartialStopped",1:"Partial"))
		If tNewAvail'=tAgentAvail {
			&sql(UPDATE EnsLib_Agent.Interface Set Availability = :tNewAvail WHERE AgentName = :tAgent AND ClientId = 0)
			$$$sysTRACE("Updated Availability for agent "_tAgent_" from '"_tAgentAvail_"' to '"_tNewAvail_"'")
		}
	}
}

ClassMethod DeleteAgent(pAgentName As %String) As %Status
{
	Set tRef=$$$EXTidlocation($$$pEXT,$$$CurrentClass)
	&sql(DELETE FROM EnsLib_Agent.Interface WHERE AgentName = :pAgentName)
	Kill:'SQLCODE @tRef@(pAgentName)
	Quit:SQLCODE $$$ERROR($$$EnsErrGeneral,"Failed to delete Agent '"_pAgentName_"', SQLCODE="_SQLCODE)
	Quit $$$OK
}

Method %OnAddToSaveSet(depth As %Integer = 3, insert As %Integer = 0, callcount As %Integer = 0) As %Status [ Private, ServerOnly = 1 ]
{
	Set tRef=$$$EXTidlocation($$$pEXT,$$$CurrentClass)
	Set:""=..ClientId ..ClientId=$I(@tRef@(..AgentName))
	Quit $$$OK
}

Method %OnNew(pAgent) As %Status [ Private, ServerOnly = 1 ]
{
	Set ..AgentName=$G(pAgent)
	Set:""'=..AgentName ..ClientId=0
	Quit $$$OK
}

Storage Default
{
<Data name="InterfaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Type</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>Location</Value>
</Value>
<Value name="5">
<Value>ConfigItem</Value>
</Value>
<Value name="6">
<Value>ConfigTimeout</Value>
</Value>
<Value name="7">
<Value>RelayPort</Value>
</Value>
<Value name="8">
<Value>Notes</Value>
</Value>
<Value name="9">
<Value>Credential</Value>
</Value>
<Value name="10">
<Value>Availability</Value>
</Value>
</Data>
<Data name="Options">
<Attribute>Options</Attribute>
<Structure>subnode</Structure>
<Subscript>"Options"</Subscript>
</Data>
<DataLocation>^EnsLib.Agent.InterfaceD</DataLocation>
<DefaultData>InterfaceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^EnsLib.Agent.InterfaceD</IdLocation>
<IndexLocation>^EnsLib.Agent.InterfaceI</IndexLocation>
<StreamLocation>^EnsLib.Agent.InterfaceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
