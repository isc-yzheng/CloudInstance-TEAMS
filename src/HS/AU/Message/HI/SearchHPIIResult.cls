Class HS.AU.Message.HI.SearchHPIIResult Extends (%SerialObject, HS.AU.Message.HI.SearchIndividualProviderCommon) [ ProcedureBlock ]
{

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/providermessages/SearchIndividual/5.0.0";

Parameter XMLNAME = "searchForProviderIndividualResult";

Property Status As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/providercore/ProviderCoreElements/5.0.0", XMLNAME = "status", XMLREF = 1);

Property ServiceMessages As HS.AU.Types.HI.ServiceMessagesType(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0", XMLNAME = "serviceMessages", XMLREF = 1);

Storage Default
{
<Data name="SearchHPIIResultState">
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
<Value name="12">
<Value>ServiceMessages</Value>
</Value>
<Value name="13">
<Value>Status</Value>
</Value>
</Data>
<State>SearchHPIIResultState</State>
<StreamLocation>^HS.AU.Mess8011.SearchHPIIRB055S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
