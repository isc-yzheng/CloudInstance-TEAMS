/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// This is the base request class for any toolkit business 
/// operation. It cannot be used by itself because it does
/// not include a payload. This class holds all the optional
/// elements for the request that if not given are taken
/// direct from the business operation settings.
Class EnsLib.ITK.AdapterKit.Request Extends EnsLib.ITK.Framework.RequestBase [ System = 4 ]
{

/// The payload of the message to send back as a stream
/// Note: If receiving this from the business service this
/// will always be present over the message.
/// One of stream or message must be provided
Property Stream As %GlobalCharacterStream;

/// The payload message to send back as a object
/// This is provided as a convienience
Property Message As %XML.Adaptor;

/// Is this message a response to an erlier message;
Property IsResponse As %Boolean [ InitialExpression = 0, Required ];

/// If so then which message does it relate to
Property RelatesToMessageId As %String(MAXLEN = "");

/// Optional Physical URL endpoint for the service (added to BasePhysicalURL in business operation)
Property PartialPhysicalURL As %String(MAXLEN = "");

/// Optional Logical URL endpoint for the service (added to BaseLogicalURL in business operation)
Property PartialLogicalURL As %String(MAXLEN = "");

/// Calculated property which will return the stream or the message as a stream
Property Payload As %GlobalCharacterStream [ Calculated ];

/// Returns the payload as a stream, selecting either the stream
/// or the Message object
Method PayloadGet() As %GlobalCharacterStream
{
	if ..Stream'="" {
		do ..Stream.Rewind()	
		quit ..Stream
	}
	
	if ..Message="" quit ""
	
	do ..Message.XMLExportToStream(.str)
	quit str
}

Method ModifyAction(ByRef action As %String, behaviourType As %String) As %Status
{
	set:..IsResponse action = action_"Response"
	Quit $$$OK
}

Storage Default
{
<Data name="RequestDefaultData">
<Subscript>"Request"</Subscript>
<Value name="1">
<Value>Stream</Value>
</Value>
<Value name="2">
<Value>Message</Value>
</Value>
<Value name="3">
<Value>Service</Value>
</Value>
<Value name="4">
<Value>PartialPhysicalURL</Value>
</Value>
<Value name="5">
<Value>PartialLogicalURL</Value>
</Value>
<Value name="6">
<Value>IsResponse</Value>
</Value>
<Value name="7">
<Value>RelatesToMessageId</Value>
</Value>
</Data>
<DefaultData>RequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
