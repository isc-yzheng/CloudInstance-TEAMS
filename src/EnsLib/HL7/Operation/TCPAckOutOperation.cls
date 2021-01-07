/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// A specialized HL7 TCP Operation that sends out ACKs on behalf of a paired HL7 TCP Service. It also
/// depends on this partner Service to collect ACKs on its behalf, for example to send messages to a dual-channel iSoft iCM application.
Class EnsLib.HL7.Operation.TCPAckOutOperation Extends EnsLib.HL7.Operation.AckOutStandard [ ClassType = "", ProcedureBlock, System = 4 ]
{

Parameter ADAPTER = "EnsLib.HL7.Adapter.TCPOutboundAdapter";

Method OnInit() As %Status
{
	Set tSC=##super()
	Set:$$$ISOK(tSC) ..%Parser.StartTimeout=..Adapter.ResponseTimeout, ..%Parser.ReadTimeout=..Adapter.ReadTimeout
	Quit tSC
}

Method SendMessage(pMsgOut As EnsLib.HL7.Message, Output pMsgIn As EnsLib.HL7.Message, pExpectedSequenceNumber As %String) As %Status [ CodeMode = expression ]
{
..Adapter.HL7Message(pMsgOut,.pMsgIn,pExpectedSequenceNumber)
}

}
