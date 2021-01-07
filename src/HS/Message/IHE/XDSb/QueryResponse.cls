/// Request object which will be used with a transformation to produce a valid query for the XDSb.Registry
Class HS.Message.IHE.XDSb.QueryResponse Extends (HS.Util.EnsResponse, HS.Message.XMLMessage) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

/// HealthShare Foundation
Parameter FOUNDATION = 1;

Property Documents As list Of HS.Message.IHE.XDSb.Document(XMLNAME = "Document", XMLPROJECTION = "ELEMENT");

Property Submissions As list Of HS.Message.IHE.XDSb.Submission(XMLNAME = "Submission", XMLPROJECTION = "ELEMENT");

Property Folders As list Of HS.Message.IHE.XDSb.Folder(XMLNAME = "Folder", XMLPROJECTION = "ELEMENT");

Property ObjectRefs As list Of ObjectRef(XMLNAME = "ObjectRef", XMLPROJECTION = "ELEMENT");

Property Associations As list Of HS.Message.IHE.XDSb.Association(XMLNAME = "Association", XMLPROJECTION = "ELEMENTREF");

Property Errors As HS.Types.IHE.Errors;

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.IHE.XDSb.QueryResponse.AdditionalInfo"</Subscript>
</Data>
<Data name="CustomAuditInfo">
<Attribute>CustomAuditInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.IHE.XDSb.QueryResponse.CustomAuditInfo"</Subscript>
</Data>
<Data name="QueryResponseDefaultData">
<Subscript>"QueryResponse"</Subscript>
<Value name="1">
<Value>DocType</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>ContentStream</Value>
</Value>
<Value name="4">
<Value>StreamCollection</Value>
</Value>
<Value name="5">
<Value>SOAPFault</Value>
</Value>
<Value name="6">
<Value>Documents</Value>
</Value>
<Value name="7">
<Value>ObjectRefs</Value>
</Value>
<Value name="8">
<Value>Errors</Value>
</Value>
<Value name="9">
<Value>SAMLData</Value>
</Value>
<Value name="10">
<Value>Submissions</Value>
</Value>
<Value name="11">
<Value>Folders</Value>
</Value>
<Value name="12">
<Value>Associations</Value>
</Value>
<Value name="13">
<Value>UseQuickStream</Value>
</Value>
</Data>
<DefaultData>QueryResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
