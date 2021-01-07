/// Message class for response to client-side (outgoing) FHIR REST API request.
Class HS.FHIRServer.API.Data.RestClient.Response Extends (%SerialObject, %XML.Adaptor)
{

/// JSON Response object
/// Note: This is not typed as a %DynamicObject because IRIS automatically creates an empty one
/// which we do not want.
Property Json;

/// HTTP Status code
Property Status As %String(MAXLEN = 256);

/// Format code requested for the response ($$$FHIRContentCodeJSON or $$$FHIRContentCodeXML)
Property ResponseFormat As %String;

Property ETag As %String(MAXLEN = 128);

Property LastModified As %String(MAXLEN = 128);

Property Location As %String(MAXLEN = "");

/// Length restriction will be enforced elsewhere by schema-based validation on id data type.
Property Id As %String(MAXLEN = "");

Property VId As %String;

/// Stream representation of the request or response payload, as a property of this class.
Property Payload As %Stream.Object;

/// True if output is to be formatted (_pretty=true)
Property IsPrettyOut As %Boolean;

/// Message headers not already covered by explicit response properties.
Property OtherHeaders As array Of %String(MAXLEN = 8192);

/// Used for ad hoc data that is meant to travel only between config items and not between productions/systems.
Property AdditionalInfo As array Of HS.Types.AdditionalInfoItem;

Storage Default
{
<Data name="ResponseState">
<Value name="1">
<Value>Json</Value>
</Value>
<Value name="2">
<Value>Status</Value>
</Value>
<Value name="3">
<Value>ResponseFormat</Value>
</Value>
<Value name="4">
<Value>ETag</Value>
</Value>
<Value name="5">
<Value>LastModified</Value>
</Value>
<Value name="6">
<Value>Location</Value>
</Value>
<Value name="7">
<Value>Id</Value>
</Value>
<Value name="8">
<Value>VId</Value>
</Value>
<Value name="9">
<Value>Payload</Value>
</Value>
<Value name="10">
<Value>IsPrettyOut</Value>
</Value>
<Value name="11">
<Value>OtherHeaders</Value>
</Value>
<Value name="12">
<Value>AdditionalInfo</Value>
</Value>
</Data>
<State>ResponseState</State>
<StreamLocation>^HS.FHIRServer.APIF724.ResponseS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
