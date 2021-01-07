/// A FHIR request message.  Typically represents the inbound REST request
Class HS.Message.FHIR.Response Extends (HS.Message.FHIR.Base, HS.Util.EnsResponse) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

/// HTTP Status code
Property Status As %String(MAXLEN = 256);

Storage Default
{
<Data name="ResponseDefaultData">
<Subscript>"Response"</Subscript>
<Value name="1">
<Value>Status</Value>
</Value>
<Value name="2">
<Value>HSCoreVersion</Value>
</Value>
<Value name="3">
<Value>HSMinVersionError</Value>
</Value>
</Data>
<DefaultData>ResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
