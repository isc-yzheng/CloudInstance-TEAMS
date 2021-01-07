/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// A service to receive HL7v2 messages sent via HTTP. Can use a HTTP.InboundAdapter listener, or the standard CSP service mechanism, or both.
/// In order for the CSP mechanism to work, Web Services derived from this class must be configured either with their configuration name the same as their
/// class name, or the invoking URL must include ?CfgItem= giving the config item name, or using a CSP application with a DispatchClass configured and the config item name as the next URL piece after the application name.
Class EnsLib.HL7.Service.HTTPAckInService Extends (EnsLib.HTTP.Service, EnsLib.HL7.Service.AckInStandard) [ ClassType = "", Inheritance = right, ProcedureBlock, System = 4 ]
{

Parameter ADAPTER = "EnsLib.HTTP.InboundAdapter";

Property ReplyStream As %GlobalCharacterStream;

Property ReplyIOStream As %IO.MetaCharacterStream;

/// End-Segment marker character(s)
Property SegTerminator As %String [ InitialExpression = {$C(13,10)} ];

/// Listen via the CSP WebServer in addition to listening on the HTTP.InboundAdapter's custom local port, if the Adapter is defined or pool size is more than 0/ <p/>
/// The default for HL7 HTTP Services is Off <p/>
/// Note that SSLConfig only applies to the custom local port. To use SSL via the CSP WebServer, you must configure the WebServer separately. <p/>
/// In order for the CSP mechanism to work, HTTP Services must be configured either with their configuration name the same as their
/// class name, or the invoking URL must include ?CfgItem= giving the config item name, or using a CSP application with a DispatchClass configured and the config item name as the next URL piece after the application name.
Property EnableStandardRequests As %Boolean [ InitialExpression = 0 ];

/* Override with HTTP.Service version, not HL7 Standard version */
/// initialize Business Host object
Method %OnNew(pConfigName As %String) As %Status
{
	#; %cspServer instantiates us without a config name. We need to defer initialization.
	Quit:""=$G(pConfigName) $$$OK
	Quit ##class(Ens.BusinessService)$this.%OnNew(.pConfigName)
}

Method OnInit() As %Status
{
	#dim tSC As %Status = $$$OK
	Set tSC=##class(EnsLib.HL7.Service.AckInStandard)$this.OnInit()  Quit:$$$ISERR(tSC) tSC
	Set ..ReplyStream=##class(%GlobalCharacterStream).%New()
	Set ..ReplyStream.Attributes("Content-Type")="text/hl7"
	Set ..ReplyIOStream=##class(%IO.MetaCharacterStream).%New(..ReplyStream)
	Set ..ReplyIOStream.Name="HTTP Response"
	Quit $$$OK
}

Method OnProcessInput(pStreamIn As %CharacterStream, Output pStreamOut As %CharacterStream) As %Status
{
	Do ..%Parser.Reset()
	Set tSC=..%Parser.ParseFramedIOStream(##class(%IO.StringStream).%New(pStreamIn.Read()),,1) Quit:$$$ISERR(tSC) tSC
	Do ..ReplyIOStream.Flush()
	Set pStreamOut=..ReplyStream
	Set t4=..ReplyStream.Read(4)
	If $Case($E(t4,4)," ":1,"":1,:0)&&(+t4=$E(t4,1,3)) {
		Set tResponse=t4_..ReplyStream.Read()
		Set:tResponse=t4 tResponse=$Case(+t4, $C($$$SingleByteAckAcceptAscii):"200 OK", $C($$$SingleByteAckErrorAscii):"500 Internal Server Error", :tResponse)
		Do ..ReplyStream.Clear()  Set ..ReplyStream.Attributes("ResponseCode")=tResponse
	} Else { Do ..ReplyStream.Rewind() }
	Quit tSC
}

Method NormalSendReply(pReplyDocument As EnsLib.EDI.Document, pOriginalDoc As EnsLib.EDI.Document = {$$$NULLOREF}) As %Status
{
	Quit:'$IsObject(pReplyDocument) ..ReplyStream.Write(pReplyDocument)
	Set pReplyDocument.IsMutable=0
	Quit:"ACK_HTTP"=$E(pReplyDocument.Name,1,$L("ACK_HTTP")) ..ReplyStream.Write($P(pReplyDocument.Name,"_",3))

	Set:$Case(..%outFraming,"uninitialized":1,"xxf":1,:0) ..%outFraming=..%Parser.%outFraming
	Do ..ReplyIOStream.Clear()
 	Set tSC=..OutputFramedToIOStream(..ReplyIOStream,pReplyDocument,,,1,..IOLogEntry)
	If $$$ISERR(tSC) {
		Set:$IsObject(..IOLogEntry) ..IOLogEntry.Annotation = $S(""=..IOLogEntry.Annotation:"",1:..IOLogEntry.Annotation_" | ")_"after HTTP WriteHL7 error on "_..Adapter.IOAddr
	} Else {
		Set:$IsObject(..IOLogEntry) ..IOLogEntry.Annotation = $S(""=..IOLogEntry.Annotation:"",1:..IOLogEntry.Annotation_" | ")_"after HTTP WriteHL7 on "_..Adapter.IOAddr
	}
	Quit tSC
}

}
