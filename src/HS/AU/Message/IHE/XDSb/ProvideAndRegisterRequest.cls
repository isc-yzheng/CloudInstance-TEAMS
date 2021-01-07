Class HS.AU.Message.IHE.XDSb.ProvideAndRegisterRequest Extends HS.Message.IHE.XDSb.ProvideAndRegisterRequest
{

Parameter XMLTYPE = "AUProvideAndRequest";

/// Contains SAML user / rhio / token 
Property SAMLData As HS.AU.PCEHR.SecurityHeader.Data;

/// Approver 
Property Approver As HS.AU.SMD.ApproverType;

/// Approver 
Storage Default
{
<Data name="ProvideAndRegisterRequestDefaul1">
<Subscript>"ProvideAndRegisterRequest1"</Subscript>
<Value name="1">
<Value>Approver</Value>
</Value>
</Data>
<DefaultData>ProvideAndRegisterRequestDefaul1</DefaultData>
<Description>
<![CDATA[Approver ]]></Description>
<Type>%Storage.Persistent</Type>
}

}
