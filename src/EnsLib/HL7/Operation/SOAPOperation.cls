/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Accepts HL7 Messages and forwards them to a remote IP address, reading a response HL7 Message object returned from the remote IP address if the GetReply setting is enabled.
Class EnsLib.HL7.Operation.SOAPOperation Extends EnsLib.HL7.Operation.ReplyStandard [ ClassType = "", ProcedureBlock, System = 4 ]
{

Parameter ADAPTER = "EnsLib.SOAP.OutboundAdapter";

Parameter SETTINGS = "-Framing";

/* Override inherited InitialExpression */
Property Framing As %String [ InitialExpression = "AsciiLF" ];

Property LibStreamOut As %Stream.GlobalCharacter [ Internal ];

Property IOStreamOut As %IO.MetaCharacterStream [ Internal ];

Property IOStreamReply As %IO.MetaCharacterStream [ Internal ];

Method OnInit() As %Status
{
	Set tSC=##super()
	Set:$$$ISOK(tSC) ..%Parser.StartTimeout=..Adapter.ResponseTimeout, ..%Parser.ReadTimeout=0
	Set ..LibStreamOut=##class(%Stream.GlobalCharacter).%New()
	Set ..IOStreamOut=##class(%IO.MetaCharacterStream).%New(..LibStreamOut)
	Set ..IOStreamReply=##class(%IO.MetaCharacterStream).%New()
	Set ..IOStreamOut.Name="SOAPRequestStream"
	Quit tSC
}

Method SendMessage(pMsgOut As EnsLib.HL7.Message, Output pMsgIn As EnsLib.HL7.Message, pExpectedSequenceNumber As %String) As %Status
{
	Set:""=..Adapter.WebServiceClientClass ..Adapter.WebServiceClientClass = "EnsLib.HL7.Util.SOAPClient"
	Set tSourceId=$Piece(pMsgOut.Source,$C(13))
	Set tSC=pMsgOut.OutputToIOStream(..IOStreamOut)  Quit:$$$ISERR(tSC) tSC
	Set tSC = ..Adapter.InvokeMethod("Send",.tReply, ..LibStreamOut)
	Do ..LibStreamOut.Clear(), ..IOStreamOut.Rewind(.tSC1)  Quit:$$$ISERR(tSC1) $$$ADDSC(tSC,tSC1)
	Quit:$$$ISERR(tSC) tSC
	If $IsObject(tReply) {
		#; Parse the HL7 ACK object out of the reply stream
		Do tReply.Rewind()
		Do ..IOStreamReply.BindInput(tReply, .tSC)  Quit:$$$ISERR(tSC) tSC
		Set tSC = ..IOStreamReply.BindOutput(tReply)  Quit:$$$ISERR(tSC) tSC
		Set ..IOStreamReply.Name=..%ConfigName_"_ReplyStream"
		Set pMsgIn=pMsgOut.ImportFromLibraryStream(..IOStreamReply,.tSC,"class||EnsLib.HL7.Service.SOAPService")  Quit:$$$ISERR(tSC) tSC
		Do ..IOStreamReply.Reset(,,.tSC)
	}
	Quit tSC
}

}
