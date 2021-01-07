Class HS.AU.Message.HI.SearchOrganisationProviderRequest Extends HS.AU.Message.CommonRequest [ ClassType = persistent, ProcedureBlock ]
{

Parameter RESPONSECLASSNAME = "HS.AU.Message.HI.SearchOrganisationProviderResponse";

Parameter XMLNAME = "searchForProviderOrganisation";

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/svc/ProviderSearchForProviderOrganisation/5.0.0";

Property HPIONumber As %String(MAXLEN = "", MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/providercore/ProviderCoreElements/5.0.0", XMLNAME = "hpioNumber", XMLREF = 1);

Storage Default
{
<Data name="SearchOrganisationProviderRequestDefaultData">
<Subscript>"SearchOrganisationProviderRequest"</Subscript>
<Value name="1">
<Value>HPIONumber</Value>
</Value>
</Data>
<DefaultData>SearchOrganisationProviderRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
