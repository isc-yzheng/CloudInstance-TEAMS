Class HS.AU.Message.HI.SearchOrganisationProviderResponse Extends HS.AU.Message.CommonResponse [ ClassType = persistent, ProcedureBlock ]
{

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/providermessages/SearchOrganisation/5.0.0";

Parameter XMLNAME = "searchForProviderOrganisationResponse";

Property Result As HS.AU.Message.HI.SearchHPIOResult(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/providermessages/SearchOrganisation/5.0.0", XMLNAME = "searchForProviderOrganisationResult", XMLREF = 1);

Storage Default
{
<Data name="SearchOrganisationProviderResponseDefaultData">
<Subscript>"SearchOrganisationProviderResponse"</Subscript>
<Value name="1">
<Value>Result</Value>
</Value>
</Data>
<DefaultData>SearchOrganisationProviderResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
