/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// A specialized HL7 TCP Service that receives ACKs on behalf of a paired HL7 TCP Operation It also
/// depends on this partner Operation to send ACKs on its behalf, for example to respond to messages from a dual-channel iSoft iCM application.
Class EnsLib.HL7.Service.TCPAckInService Extends EnsLib.HL7.Service.AckInStandard [ ClassType = "", ProcedureBlock, System = 4 ]
{

Parameter ADAPTER = "EnsLib.HL7.Adapter.TCPInboundAdapter";

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

Method NormalSendReply(pReplyDocument As EnsLib.EDI.Document, pOriginalDoc As EnsLib.EDI.Document = {$$$NULLOREF}) As %Status
{
	Quit:'..Adapter.Connected $$$OK
	Set:$Case(..%outFraming,"uninitialized":1,"xxf":1,:0) ..%outFraming=..%Parser.%outFraming
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
