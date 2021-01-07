Class HS.FHIRServer.API.Data.Response Extends (%SerialObject, %XML.Adaptor)
{

/// JSON Response object
/// Note: This is not typed as a %DynamicObject because IRIS automatically creates an empty one
/// which we do not want.
Property Json [ Transient ];

/// HTTP Status code
Property Status As %String(MAXLEN = 256);

/// Format code requested for the response ($$$FHIRContentCodeJSON or $$$FHIRContentCodeXML)
Property ResponseFormatCode As %String;

Property ETag As %String;

Property LastModified As %String;

Property Location As %String(MAXLEN = "");

/// Length restriction will be enforced elsewhere by schema-based validation on id data type.
Property Id As %String(MAXLEN = "");

Property VId As %String;

/// True if output is to be formatted (_pretty=true)
Property IsPrettyOut As %Boolean;

Storage Default
{
<Data name="ResponseState">
<Value name="1">
<Value>Status</Value>
</Value>
<Value name="2">
<Value>ResponseFormatCode</Value>
</Value>
<Value name="3">
<Value>ETag</Value>
</Value>
<Value name="4">
<Value>LastModified</Value>
</Value>
<Value name="5">
<Value>Location</Value>
</Value>
<Value name="6">
<Value>Id</Value>
</Value>
<Value name="7">
<Value>VersionId</Value>
</Value>
<Value name="8">
<Value>IsPrettyOut</Value>
</Value>
<Value name="9">
<Value>VId</Value>
</Value>
</Data>
<State>ResponseState</State>
<StreamLocation>^HS.FHIRServer.API26D2.ResponseS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
