Class HS.AU.Message.HI.SearchIndividualProviderResponse Extends HS.AU.Message.CommonResponse [ ClassType = persistent, ProcedureBlock ]
{

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/svc/ProviderSearchForProviderIndividual/5.0.0";

Parameter XMLNAME = "searchForProviderIndividualResponse";

Property Result As HS.AU.Message.HI.SearchHPIIResult(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/providermessages/SearchIndividual/5.0.0", XMLNAME = "searchForProviderIndividualResult", XMLREF = 1);

Storage Default
{
<Data name="SearchIndividualProviderResponseDefaultData">
<Subscript>"SearchIndividualProviderResponse"</Subscript>
<Value name="1">
<Value>Result</Value>
</Value>
</Data>
<DefaultData>SearchIndividualProviderResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
