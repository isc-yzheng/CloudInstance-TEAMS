Class HS.AU.Message.HI.SearchHPIOResult Extends (%SerialObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/providermessages/SearchOrganisation/5.0.0";

Parameter XMLNAME = "searchForProviderOrganisationResult";

Property HPIONumber As %String(MAXLEN = "", MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/providercore/ProviderCoreElements/5.0.0", XMLNAME = "hpioNumber", XMLREF = 1);

Property Status As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/providercore/ProviderCoreElements/5.0.0", XMLNAME = "status", XMLREF = 1);

Property ServiceMessages As HS.AU.Types.HI.ServiceMessagesType(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0", XMLNAME = "serviceMessages", XMLREF = 1);

Storage Default
{
<Data name="SearchHPIOResultState">
<Value name="1">
<Value>HPIONumber</Value>
</Value>
<Value name="2">
<Value>Status</Value>
</Value>
<Value name="3">
<Value>ServiceMessages</Value>
</Value>
</Data>
<State>SearchHPIOResultState</State>
<StreamLocation>^HS.AU.Mess8011.SearchHPIORB033S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
