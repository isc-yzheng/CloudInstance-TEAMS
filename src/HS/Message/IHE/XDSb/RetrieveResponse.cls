/// Request object which will be used with a transformation to produce a valid query for the XDSb.Registry
Class HS.Message.IHE.XDSb.RetrieveResponse Extends (HS.Util.EnsResponse, HS.Message.XMLMessage) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Property Documents As list Of HS.Message.IHE.XDSb.Document(XMLNAME = "Document", XMLPROJECTION = "ELEMENT");

Property Errors As HS.Types.IHE.Errors;

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.IHE.XDSb.RetrieveResponse.AdditionalInfo"</Subscript>
</Data>
<Data name="CustomAuditInfo">
<Attribute>CustomAuditInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.IHE.XDSb.RetrieveResponse.CustomAuditInfo"</Subscript>
</Data>
<Data name="RetrieveResponseDefaultData">
<Subscript>"RetrieveResponse"</Subscript>
<Value name="1">
<Value>Documents</Value>
</Value>
<Value name="2">
<Value>DocType</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>ContentStream</Value>
</Value>
<Value name="5">
<Value>StreamCollection</Value>
</Value>
<Value name="6">
<Value>SOAPFault</Value>
</Value>
<Value name="7">
<Value>SAMLData</Value>
</Value>
<Value name="8">
<Value>Errors</Value>
</Value>
<Value name="9">
<Value>UseQuickStream</Value>
</Value>
</Data>
<DefaultData>RetrieveResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
