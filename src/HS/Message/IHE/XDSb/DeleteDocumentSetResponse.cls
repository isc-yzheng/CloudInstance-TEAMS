Class HS.Message.IHE.XDSb.DeleteDocumentSetResponse Extends (HS.Util.EnsResponse, HS.Message.XMLMessage) [ ClassType = persistent, ProcedureBlock ]
{

Property ErrStatus As %Status;

/// IHE Status text ie urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success
Property Status As %String(MAXLEN = 512);

Property Errors As HS.Types.IHE.Errors;

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.IHE.XDSb.DeleteDocumentSetResponse.AdditionalInfo"</Subscript>
</Data>
<Data name="CustomAuditInfo">
<Attribute>CustomAuditInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.Message.IHE.XDSb.DeleteDocumentSetResponse.CustomAuditInfo"</Subscript>
</Data>
<Data name="DeleteDocumentSetResponseDefaultData">
<Subscript>"DeleteDocumentSetResponse"</Subscript>
<Value name="1">
<Value>ErrStatus</Value>
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
<Value>UseQuickStream</Value>
</Value>
<Value name="9">
<Value>Errors</Value>
</Value>
<Value name="10">
<Value>Status</Value>
</Value>
</Data>
<DefaultData>DeleteDocumentSetResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
