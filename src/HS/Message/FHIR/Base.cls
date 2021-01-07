/// Defines a FHIR basic message
Class HS.Message.FHIR.Base Extends (%Persistent, %XML.Adaptor)
{

/// Time stamp of when we received this message
Property TimestampUTC As %TimeStamp [ InitialExpression = {$ZDT($ZTS,3)}, Required ];

/// The base URL for this request
Property BaseURL As %String(MAXLEN = 2048);

/// The FHIR entity type on which to perform this request
Property Type As %String(MAXLEN = 128);

/// The resource ID
Property Id As %String(MAXLEN = 256);

/// The resource version
Property VId As %String(MAXLEN = 256);

/// For client-side request messages for write-based interactions, ContentType is populated
/// into the HTTP Content-Type header.  It indicates the ContentType of the Payload being
/// sent to the server.<br>
/// For client-side request messages for read-based interactions, ContentType is populated
/// into the HTTP Accept header.  It indicates the requested content type of the Payload
/// that will be returned from the server.<br>
/// For server-side request messages for write-based interactions, ContentType is the content
/// type of the Payload in the request message.<br>
/// For server-side request messages for read-based interactions, ContentType is the content
/// type to use for any Payload that is returned in the response message.<br>
/// For any response messages, ContentType is the content type of the response Payload.
Property ContentType As %String(MAXLEN = 256);

/// The message payload. It can be FHIR resource content, or application/x-www-form-urlencoded
/// request data. When that content is stored in the Payload property of this message object,
/// it causes the standard message handling to log the Payload contents each time the message
/// is passed between config items. For large-scale and/or complex implementations, this may
/// not be desirable, as the logged data will quickly become voluminous and negatively affect
/// performance. The default behavior for product FHIR components is to use QuickStreams for
/// such content. See the QuickStream property comments for details. See also the method
/// comments for the GetPayloadOref() instance method.
Property Payload As %Stream.GlobalCharacter;

/// Object Id of a <class>HS.SDA3.QuickStream</class> object holding the message payload.
/// The payload can be FHIR resource content, or application/x-www-form-urlencoded request
/// data. A QuickStream is a storage alternative to the Payload property for the payload
/// content during the life of a message session. When QuickStream is used, it maintains
/// only a single object instance of the content, and avoids logging potentially huge
/// payloads - which could possibly be logged multiple times - as part of the standard
/// message handling. It is deleted at the end of each message session. If there is a
/// need to conduct diagnostics and see a log of the payload content during new message
/// sessions, use the TraceOperations setting of the relevant business services, processes
/// and/or operations. See also the method comments for the GetPayloadOref() instance method.
Property QuickStreamId As %String;

/// Message headers
Property Headers As array Of %String(MAXLEN = 8192);

/// FHIR Version indicator
Property FHIRVersion As %String(MAXLEN = 255);

/// DEPRECATED. Used only for DSTU2 DTL transformations. Applications should not make direct
/// use of this property. For FHIR versions after DSTU2, use other means for making an object
/// from FHIR stream and for making FHIR stream from object during DTL customization.
Property ResourceContainer As HS.FHIR.Model.Base.ResourceContainer [ Deprecated ];

/// Used for ad hoc data that is meant to travel only between config items and not between productions/systems.
Property AdditionalInfo As array Of HS.Types.AdditionalInfoItem;

/// Update the Payload stream property from the data in the ResourceContainer
/// object property, and set the ResourceContainer object property to null.
Method UpdatePayloadFromContainer() As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set tSC = ..Payload.Clear()
		If $$$ISERR(tSC) Quit
		
		Set tSC = ##class(HS.FHIR.Utils).GetResourceTypeFromContainer(..ResourceContainer, .tResourceType)
		If $$$ISERR(tSC) Quit
		
		Set tSC = ##class(HS.FHIR.Utils).HSFHIRToFHIR(..ContentType, $Property(..ResourceContainer,tResourceType), .tFHIRStream)
		If $$$ISERR(tSC) Quit
		
		Set tSC = ..Payload.CopyFrom(tFHIRStream)
		If $$$ISERR(tSC) Quit
		
		Set ..ResourceContainer = ""
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// Update the ResourceContainer object property from the stream data
/// in the Payload property, and clear out the Payload stream.
Method UpdateContainerFromPayload() As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set ..ResourceContainer = ""
		
		Set tSC = ##class(HS.FHIR.Utils).FHIRToHSFHIR(..ContentType, ..Payload, .tHSFHIRObj)
		If $$$ISERR(tSC) Quit
		
		Set tResourceContainerObj = ##class(HS.FHIR.Model.Base.ResourceContainer).%New(tHSFHIRObj)
		If '$IsObject($Get(tResourceContainerObj)) Set tSC = $$$ERROR($$$GeneralError,"%New of FHIR ResourceContainer object failed") Quit
		
		Set ..ResourceContainer = tResourceContainerObj.%ConstructClone(1)
		
		Set tSC = ..Payload.Clear()
		If $$$ISERR(tSC) Quit
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// API
/// The message payload may be held in either the Payload property or in a QuickStream.
/// Use GetPayloadOref() to get the pointer to the object (Payload property or QuickStream)
/// currently being used by this message instance.
Method GetPayloadOref() As %Library.ObjectHandle
{
	Set tPayloadOref = $$$NULLOREF
	
	If ..QuickStreamId'="" {
		Set tPayloadOref = ##class(HS.SDA3.QuickStream).%OpenId(..QuickStreamId)
	} Else {
		Set tPayloadOref = ..Payload
	}
	
	Quit tPayloadOref
}

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"AdditionalInfo"</Subscript>
</Data>
<Data name="BaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TimestampUTC</Value>
</Value>
<Value name="3">
<Value>BaseURL</Value>
</Value>
<Value name="4">
<Value>Type</Value>
</Value>
<Value name="5">
<Value>Id</Value>
</Value>
<Value name="6">
<Value>VId</Value>
</Value>
<Value name="7">
<Value>ContentType</Value>
</Value>
<Value name="8">
<Value>Payload</Value>
</Value>
<Value name="9">
<Value>FHIRVersion</Value>
</Value>
<Value name="10">
<Value>ResourceContainer</Value>
</Value>
<Value name="11">
<Value>QuickStreamId</Value>
</Value>
</Data>
<Data name="Headers">
<Attribute>Headers</Attribute>
<Structure>subnode</Structure>
<Subscript>"Headers"</Subscript>
</Data>
<DataLocation>^HS.Message.FHIR.BaseD</DataLocation>
<DefaultData>BaseDefaultData</DefaultData>
<IdLocation>^HS.Message.FHIR.BaseD</IdLocation>
<IndexLocation>^HS.Message.FHIR.BaseI</IndexLocation>
<StreamLocation>^HS.Message.FHIR.BaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
