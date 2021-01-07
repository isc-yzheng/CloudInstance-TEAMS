Class HS.AU.Message.HI.SearchIndividualProviderRequest Extends (HS.AU.Message.CommonRequest, HS.AU.Message.HI.SearchIndividualProviderCommon) [ ClassType = persistent, ProcedureBlock ]
{

Parameter RESPONSECLASSNAME = "HS.AU.Message.HI.SearchIndividualProviderResponse";

Parameter XMLNAME = "searchForProviderIndividual";

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/svc/ProviderSearchForProviderIndividual/5.0.0";

Storage Default
{
<Data name="SearchIndividualProviderRequestDefaultData">
<Subscript>"SearchIndividualProviderRequest"</Subscript>
<Value name="1">
<Value>HPIINumber</Value>
</Value>
<Value name="2">
<Value>RegistrationId</Value>
</Value>
<Value name="3">
<Value>FamilyName</Value>
</Value>
<Value name="4">
<Value>OnlyNameIndicator</Value>
</Value>
<Value name="5">
<Value>GivenName</Value>
</Value>
<Value name="6">
<Value>DateOfBirth</Value>
</Value>
<Value name="7">
<Value>Sex</Value>
</Value>
<Value name="8">
<Value>State</Value>
</Value>
<Value name="9">
<Value>Postcode</Value>
</Value>
<Value name="10">
<Value>SearchAustralianAddress</Value>
</Value>
<Value name="11">
<Value>SearchInternationalAddress</Value>
</Value>
</Data>
<DefaultData>SearchIndividualProviderRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
