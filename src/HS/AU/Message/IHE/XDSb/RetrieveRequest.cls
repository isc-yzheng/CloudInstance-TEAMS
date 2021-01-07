Class HS.AU.Message.IHE.XDSb.RetrieveRequest Extends HS.Message.IHE.XDSb.RetrieveRequest
{

Parameter XMLTYPE = "AURetrieveRequest";

/// Contains SAML user / rhio / token 
Property SAMLData As HS.AU.PCEHR.SecurityHeader.Data;

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
