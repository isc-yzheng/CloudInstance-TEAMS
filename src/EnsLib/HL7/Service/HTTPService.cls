/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// A service to receive HL7v2 messages sent via HTTP. Can use a HTTP.InboundAdapter listener, or the standard CSP service mechanism, or both.
/// In order for the CSP mechanism to work, Web Services derived from this class must be configured either with their configuration name the same as their
/// class name, or the invoking URL must include ?CfgItem= giving the config item name, or using a CSP application with a DispatchClass configured and the config item name as the next URL piece after the application name.
Class EnsLib.HL7.Service.HTTPService Extends (EnsLib.HTTP.Service, EnsLib.HL7.Service.Standard) [ ClassType = "", Inheritance = right, ProcedureBlock, System = 4 ]
{

Parameter ADAPTER = "EnsLib.HTTP.InboundAdapter";

/// What kind of HTTP Response should this service return?
/// CodeOnly          : Return an HTTP Response Code of 200 for OK, 500 for Error, and no HTTP Response body text
/// CodeWithACKBody   : Return an HTTP Response Code of 200 for OK, 500 for Error, and the HL7 response message as body text
/// OKCodeWithACKBody : Return the HL7 response message as body text, and always an HTTP Response Code of 200 for OK if the body exists 
Property HTTPResponseMode As %String(VALUELIST = ",CodeOnly,CodeWithACKBody,OKCodeWithACKBody") [ InitialExpression = "OKCodeWithACKBody" ];

Parameter SETTINGS = "HTTPResponseMode";

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
	Set tSC=##class(EnsLib.HL7.Service.Standard)$this.OnInit()  Quit:$$$ISERR(tSC) tSC
	Set ..ReplyStream=##class(%GlobalCharacterStream).%New()
	Set ..ReplyStream.Attributes("Content-Type")="text/hl7"
	Set ..ReplyIOStream=##class(%IO.MetaCharacterStream).%New(..ReplyStream)
	Set ..ReplyIOStream.Name="HTTP Response"
	Set:""=$ZStrip(..HTTPResponseMode,"<>W") ..HTTPResponseMode="OKCodeWithACKBody"
	Quit $$$OK
}

Method OnProcessInput(pStreamIn As %CharacterStream, Output pStreamOut As %CharacterStream) As %Status
{
	Do ..%Parser.Reset()
	Do ..ReplyStream.Clear()
	Set tSC=..%Parser.ParseFramedIOStream(##class(%IO.MetaCharacterStream).%New(pStreamIn),,1)
	Do ..ReplyIOStream.Flush()
	If $$$ISERR(tSC) { $$$LOGSTATUS(tSC) } ; we are going to return OK regardless
	Set pStreamOut=..ReplyStream
	Set t4=..ReplyStream.Read(4)
	If t4?3N." " {
		#; If the response text represents an HTTP code, use it and skip the stream
		Set tResponse=t4_..ReplyStream.Read()
		Set:tResponse=t4 tResponse=$S($$$ISERR(tSC)&&(500'=+t4):"500 Internal Server Error", 1:tResponse)
		Do ..ReplyStream.Clear()
		Set ..ReplyStream.Attributes("ResponseCode")=tResponse
	} ElseIf $Case(t4, $C($$$SingleByteAckAcceptAscii):1, $C($$$SingleByteAckErrorAscii):1, :0) {
		#; If the response text represents a 1-byte ACK, use it and skip the stream
		Set tResponse=$S($$$ISERR(tSC)||($C($$$SingleByteAckErrorAscii)=t4):"500 Internal Server Error", 1:"200 OK")
		Do ..ReplyStream.Clear()
		Set ..ReplyStream.Attributes("ResponseCode")=tResponse
	} Else {
		#; If the response text represents an ACK message, use it as the response body, depending on Config setting
		If $$$ISERR(tSC) {
			If ..HTTPResponseMode="CodeOnly" {
				Do ..ReplyStream.Clear()
				Set ..ReplyStream.Attributes("ResponseCode")="500 Internal Server Error"
			} ElseIf ..HTTPResponseMode="CodeWithACKBody" {
				Do ..ReplyStream.Rewind()
				Set ..ReplyStream.Attributes("ResponseCode")="500 Internal Server Error"
			} Else { ; OKCodeWithACKBody
				Do ..ReplyStream.Rewind()
				Set:'..ReplyStream.Size ..ReplyStream.Attributes("ResponseCode")="500 Internal Server Error"
			}
		} Else {
			If ..HTTPResponseMode="CodeOnly" {
				Do ..ReplyStream.Clear()
			} Else {
				Do ..ReplyStream.Rewind()
			}
		}
	}
	Quit $$$OK ; use the Stream, don't make up a faultResponse
}

Method SendReply(pReplyDocument As EnsLib.EDI.Document, pOriginalDoc As EnsLib.EDI.Document = {$$$NULLOREF}) As %Status
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
