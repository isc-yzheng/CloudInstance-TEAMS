/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Accepts HL7 Messages and forwards them to a remote IP address, reading a response HL7 Message object returned from the remote IP address if the GetReply setting is enabled.
Class EnsLib.HL7.Operation.TCPOperation Extends EnsLib.HL7.Operation.ReplyStandard [ ClassType = "", ProcedureBlock, System = 4 ]
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
