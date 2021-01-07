/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsITK

/// Request class to carry details and metadata of a Web Request.
Class EnsLib.ITK.Framework.RequestData Extends EnsLib.ITK.Framework.RequestBase [ System = 4 ]
{

// Wrapper Fields (i.e. SOAP Header)

/// Holds the underlying ITK Action (WS)
Property Action As %String(MAXLEN = "");

/// The application that has invoked the (WS-A) 
Property SourceApplication As %String;

/// Only used for responses. Populated by the callback response handler
Property SourceDevice As %String;

/// The ID of the message (WS-A)
Property MessageId As %String(MAXLEN = "");

/// When the message was Created (WS-S)
Property Created As %String(MAXLEN = "");

/// When the message expires (WS-S)
Property Expires As %String(MAXLEN = "");

/// Who the message is addressed to at a SOAP level (WS-A)
Property To As %String(MAXLEN = "");

/// Who any reply should be re-directed to (WS-A)
Property ReplyTo As %String(MAXLEN = "");

/// Who any fault should be sent to (WS-A)
Property FaultTo As %String(MAXLEN = "");

/// The message this message relates to (WS-A)
Property RelatesTo As %String(MAXLEN = "");

/// The sequence number (WS-A)
Property SequenceNumber As %Integer;

// Registry/Setting Fields

/// The invocation pattern based on the business service or the source application registry entry
Property InvocationPattern As %String;

/// The mode under which we should distribute entries
Property DistributionMode As %String;

// Content Fields

/// Distribution Envelope (as XML VDOC Document) without any payload
/// Note this is only present if there is a Distribution Envelope
Property DistributionEnvelope As EnsLib.EDI.XML.Document;

/// The payload itself
Property Payload As %Stream.GlobalCharacter;

/// Holds the faul code if this request is a fault response
Property FaultCode As %String;

/// Holds the status of the request (if the request is a fault this will not be OK)
Property Status As %Status;

// Additional Fields, added as resolved

/// Holds the resolved endpoint
Property ResolvedEndpoint As %String(MAXLEN = "");

/// Only used for responses. Populated by the callback response handler
Property OriginalRelatesTo As %String(MAXLEN = "");

Index RequestDataU1 On MessageId [ Unique ];

Method ServiceBehaviourType() As %String
{
	Quit ##class(EnsLib.ITK.Setup.ServiceDefinition).%OpenId(..ServiceName).BehaviourType
}

Method ModifyAction(ByRef action As %String, behaviourType As %String) As %Status
{
	if (behaviourType=$$$ITKBPAsynchResponseHandler) || (behaviourType=$$$ITKBPFaultHandler) 
	{
		set action = ..Action
	}
	quit $$$OK
}

/// Need to clean up DistributionEnvelope
ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Private ]
{
	#dim tSC As %Status = $$$OK
	#dim e As %Exception.AbstractException
	#dim tDistributionEnvelope As %RegisteredObject = ""
	#dim tDistributionEnvelopeId,tDistributionEnvelopeClass,tID As %String
	
	Try { 
		Set tID=$$$oidPrimary(oid)
		Set tDistributionEnvelope = $PROPERTY($CLASSMETHOD($CLASSNAME(),"%OpenId",tID),"DistributionEnvelope")
		If $IsObject(tDistributionEnvelope),(tDistributionEnvelope.%Id()'="") {Set tDistributionEnvelopeId = tDistributionEnvelope.%Id(), tDistributionEnvelopeClass = $classname(tDistributionEnvelope),tDistributionEnvelope="", tSC = $CLASSMETHOD(tDistributionEnvelopeClass,"%DeleteId",tDistributionEnvelopeId)}
	} Catch e { Set tSC = e.AsStatus()}
	
	Quit tSC
}

Trigger OnDelete [ Event = DELETE ]
{
	New tDistributionEnvelope,tDistributionEnvelopeId,tDistributionEnvelopeClass,e
	
	Try { 
		Set tDistributionEnvelope = $PROPERTY($CLASSMETHOD($CLASSNAME(),"%OpenId",{%%ID}),"DistributionEnvelope")
		If $IsObject(tDistributionEnvelope),(tDistributionEnvelope.%Id()'="") {Set tDistributionEnvelopeId = tDistributionEnvelope.%Id(), tDistributionEnvelopeClass = $classname(tDistributionEnvelope),tDistributionEnvelope="", %ok = $CLASSMETHOD(tDistributionEnvelopeClass,"%DeleteId",tDistributionEnvelopeId)}
		If $$$ISERR(%ok) Set %msg=$SYSTEM.Status.GetOneStatusText(%ok),%ok=0
	} Catch e {Set %msg=e.DisplayString(),%ok=0}

	Quit
}

Storage Default
{
<Data name="RequestDataDefaultData">
<Subscript>"RequestData"</Subscript>
<Value name="1">
<Value>SessionId</Value>
</Value>
<Value name="2">
<Value>MessageId</Value>
</Value>
<Value name="3">
<Value>ServiceName</Value>
</Value>
<Value name="4">
<Value>SourceApplication</Value>
</Value>
<Value name="5">
<Value>AddressingIn</Value>
</Value>
<Value name="6">
<Value>SecurityIn</Value>
</Value>
<Value name="7">
<Value>SequenceNumber</Value>
</Value>
<Value name="8">
<Value>Payload</Value>
</Value>
<Value name="9">
<Value>ServicePattern</Value>
</Value>
<Value name="10">
<Value>ReplyTo</Value>
</Value>
<Value name="11">
<Value>FaultTo</Value>
</Value>
<Value name="12">
<Value>RelatesTo</Value>
</Value>
<Value name="13">
<Value>SecurityInXML</Value>
</Value>
<Value name="14">
<Value>SubscriptionPullStatus</Value>
</Value>
<Value name="15">
<Value>SubscriptionPullMsgSent</Value>
</Value>
<Value name="16">
<Value>SubscriptionPullMsgSentDate</Value>
</Value>
<Value name="17">
<Value>SubscriptionQueueName</Value>
</Value>
<Value name="18">
<Value>To</Value>
</Value>
<Value name="19">
<Value>Created</Value>
</Value>
<Value name="20">
<Value>Expires</Value>
</Value>
<Value name="21">
<Value>IsDiscarder</Value>
</Value>
<Value name="22">
<Value>IsDiscarded</Value>
</Value>
<Value name="23">
<Value>TrackingId</Value>
</Value>
<Value name="24">
<Value>InvocationPattern</Value>
</Value>
<Value name="25">
<Value>Action</Value>
</Value>
<Value name="26">
<Value>BehaviourType</Value>
</Value>
<Value name="27">
<Value>ResolvedEndpoint</Value>
</Value>
<Value name="28">
<Value>Status</Value>
</Value>
<Value name="29">
<Value>FaultCode</Value>
</Value>
<Value name="30">
<Value>SourceDevice</Value>
</Value>
<Value name="31">
<Value>OriginalRelatesTo</Value>
</Value>
<Value name="32">
<Value>DistributionEvalope</Value>
</Value>
<Value name="33">
<Value>DistributionEnvelope</Value>
</Value>
<Value name="34">
<Value>DistributionMode</Value>
</Value>
<Value name="35">
<Value>PayloadId</Value>
</Value>
<Value name="36">
<Value>PayloadFilename</Value>
</Value>
</Data>
<DefaultData>RequestDataDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
