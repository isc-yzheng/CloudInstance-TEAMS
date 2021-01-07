Class HS.AU.Message.PCEHR.RemoveDocumentResponse Extends HS.AU.Message.CommonResponse [ ProcedureBlock ]
{

Parameter NAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/interfaces/RemoveDocument/1.0";

Parameter XMLNAME = "removeDocumentResponse";

Property ResponseStatus As HS.AU.Types.PCEHR.ResponseStatusType(XMLNAME = "responseStatus");

Storage Default
{
<Data name="RemoveDocumentResponseDefaultData">
<Subscript>"RemoveDocumentResponse"</Subscript>
<Value name="1">
<Value>SAMLData</Value>
</Value>
<Value name="2">
<Value>ResponseStatus</Value>
</Value>
</Data>
<DefaultData>RemoveDocumentResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
