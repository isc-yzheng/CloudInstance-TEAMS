Class HS.AU.Message.IHE.XDSb.QueryRequest Extends HS.Message.IHE.XDSb.QueryRequest
{

Parameter XMLTYPE = "AUQueryRequest";

/// Contains SAML user / rhio / token 
Property SAMLData As HS.AU.PCEHR.SecurityHeader.Data;

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
