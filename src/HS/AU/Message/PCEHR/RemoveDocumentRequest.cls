Class HS.AU.Message.PCEHR.RemoveDocumentRequest Extends HS.AU.Message.CommonRequest [ ProcedureBlock ]
{

Parameter XMLNAME = "removeDocument";

Property SAMLData As HS.AU.PCEHR.SecurityHeader.Data;

Parameter RESPONSECLASSNAME = "HS.AU.Message.PCEHR.RemoveDocumentResponse";

Parameter NAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/interfaces/RemoveDocument/1.0";

Property DocumentID As %String(MAXLEN = "", XMLNAME = "documentID") [ Required ];

Property ReasonForRemoval As %String(MAXLEN = "", VALUELIST = ",Withdrawn,ElectToRemove,IncorrectIdentity", XMLNAME = "reasonForRemoval") [ Required ];

Storage Default
{
<Data name="RemoveDocumentRequestDefaultData">
<Subscript>"RemoveDocumentRequest"</Subscript>
<Value name="1">
<Value>DocumentID</Value>
</Value>
<Value name="2">
<Value>ReasonForRemoval</Value>
</Value>
</Data>
<DefaultData>RemoveDocumentRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
