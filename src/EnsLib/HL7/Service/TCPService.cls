/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.HL7.Service.TCPService Extends EnsLib.HL7.Service.Standard [ ClassType = "", ProcedureBlock, System = 4 ]
{

Parameter ADAPTER = "EnsLib.HL7.Adapter.TCPInboundAdapter";

/// Control clearing of TCP receive buffer before sending ACK; options: <br/>
/// - No : do not discard any waiting inbound data before returning ACK for current message.<br/>
/// - Yes & Warn : discard waiting inbound data before returning ACK  for current message and log a warning in Event log<br/>
/// - Yes : discard waiting inbound data before returning ACK for current message. Record in Event log only if Debug trace is enabled. <br/>
/// If either Yes option is selected and ArchiveIO is enabled any data discarded will be written to the ArchiveIO log.
Property PreACKTCPClear As %String(DISPLAYLIST = ",No,Yes and Warn,Yes", VALUELIST = ",0,1,2") [ InitialExpression = "0", Required ];

Parameter SETTINGS = "TargetConfigNames:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},SearchTableClass::selector?context={Ens.ContextSearch/SearchTableClasses?host=EnsLib.HL7.Service.Standard},LocalFacilityApplication,Framing:Connection:selector?context={Ens.ContextSearch/getDisplayList?host=@currHostId&prop=Framing},AckMode,UseAckCommitCodes,IgnoreInboundAck,AddNackERR,NackErrorCode,PreACKTCPClear";

Method OnInit() As %Status
{
	Set tSC=##super()  Quit:$$$ISERR(tSC) tSC
	Set ..%Parser.StartTimeout=..Adapter.CallInterval, ..%Parser.ReadTimeout=..Adapter.ReadTimeout
	Quit $$$OK
}

Method OnProcessInput(pLine As Ens.StringContainer, Output pLineLeftOver As Ens.StringContainer) As %Status
{
 	Set pLineLeftOver=""
	Do ..%Parser.ResetPosition()
	Set ..%Parser.%LookaheadLineIsNew=$LI(pLine,1), ..%Parser.%LookaheadLine=$LI(pLine,3), ..%Parser.%LookaheadLineTerminator=$LI(pLine,2)
	Set tSC=..%Parser.ParseFramedIOStream(..Adapter.Socket,,1,..IOLogEntry)
	Set:""'=..%Parser.%LookaheadLine||(""'=..%Parser.%LookaheadLineTerminator) pLineLeftOver=$LB(0,..%Parser.%LookaheadLineTerminator,..%Parser.%LookaheadLine)
	Quit tSC
}

Method SendReply(pReplyDocument As EnsLib.EDI.Document, pOriginalDoc As EnsLib.EDI.Document = {$$$NULLOREF}) As %Status
{
	Quit:'..Adapter.Connected $$$OK
	
	If ..PreACKTCPClear {
		Set tSC1 = ..Adapter.ClearRecvBuffer(..PreACKTCPClear,.tMappedDiscardData,..IOLogEntry)
		Quit:'..Adapter.Connected tSC1
	}
	
	Set:$Case(..%outFraming,"uninitialized":1,"xxf":1,:'..%Parser.RememberFlex) ..%outFraming=..%Parser.%outFraming
 	Set tSC=..OutputFramedToIOStream(..Adapter.Socket,pReplyDocument,,,1,..IOLogEntry)
	If $$$ISERR(tSC) {
		If ..Adapter.IsWriteError(tSC) {
			Set tSC=$$$ERROR($$$EnsErrOutConnectionLost,"HL7 Write", ..Adapter.Device, $$$StatusDisplayString(tSC))
			Do ..Adapter.Disconnect()
		}
		$$$SAVEIOLOGENTRY(tSC,"after TCP WriteHL7 error on "_..Adapter.IOAddr,pReplyDocument)
	} Else {
		$$$SAVEIOLOGENTRY(tSC,"after TCP WriteHL7 on "_..Adapter.IOAddr,pReplyDocument)
	}
	Quit tSC
}

}
