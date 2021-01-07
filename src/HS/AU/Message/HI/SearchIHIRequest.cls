Class HS.AU.Message.HI.SearchIHIRequest Extends HS.AU.Message.CommonRequest [ ClassType = persistent, ProcedureBlock ]
{

Parameter RESPONSECLASSNAME = "HS.AU.Message.HI.SearchIHIResponse";

Parameter XMLNAME = "searchIHI";

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/svc/ConsumerSearchIHI/3.0";

Property IHINumber As %String(MAXLEN = "", MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/ConsumerCoreElements/3.0", XMLNAME = "ihiNumber", XMLREF = 1);

Property MedicareCardNumber As %String(MAXLEN = 10, MINLEN = 10, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/ConsumerCoreElements/3.0", XMLNAME = "medicareCardNumber", XMLREF = 1);

Property MedicareIRN As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/ConsumerCoreElements/3.0", XMLNAME = "medicareIRN", XMLREF = 1);

Property DVAFileNumber As %String(MAXLEN = 9, MINLEN = 2, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/ConsumerCoreElements/3.0", XMLNAME = "dvaFileNumber", XMLREF = 1);

Property DateOfBirth As %Date(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0", XMLNAME = "dateOfBirth", XMLREF = 1);

Property Sex As %String(MAXLEN = 1, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0", VALUELIST = ",F,I,M,N", XMLNAME = "sex", XMLREF = 1);

Property FamilyName As %String(MAXLEN = 40, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/IndividualNameCore/3.0", TRUNCATE = 1, XMLNAME = "familyName", XMLREF = 1);

Property GivenName As %String(MAXLEN = 40, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/IndividualNameCore/3.0", TRUNCATE = 1, XMLNAME = "givenName", XMLREF = 1);

Property AustralianPostalAddress As HS.AU.Types.HI.Address.AustralianPostalAddressType(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/Address/3.0", XMLNAME = "australianPostalAddress", XMLREF = 1);

Property AustralianStreetAddress As HS.AU.Types.HI.Address.AustralianStreetAddressType(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/Address/3.0", XMLNAME = "australianStreetAddress", XMLREF = 1);

Property InternationalAddress As HS.AU.Types.HI.Address.InternationalAddressType(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/Address/3.0", XMLNAME = "internationalAddress", XMLREF = 1);

Property History As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/ConsumerCoreElements/3.0", VALUELIST = ",F,T", XMLNAME = "history", XMLREF = 1);

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.AU.Message.HI.SearchIHIRequest.AdditionalInfo"</Subscript>
</Data>
<Data name="SearchIHIRequestDefaultData">
<Subscript>"SearchIHIRequest"</Subscript>
<Value name="1">
<Value>IHINumber</Value>
</Value>
<Value name="2">
<Value>medicareCardNumber</Value>
</Value>
<Value name="3">
<Value>medicareIRN</Value>
</Value>
<Value name="4">
<Value>dvaFileNumber</Value>
</Value>
<Value name="5">
<Value>DateOfBirth</Value>
</Value>
<Value name="6">
<Value>Sex</Value>
</Value>
<Value name="7">
<Value>FamilyName</Value>
</Value>
<Value name="8">
<Value>GivenName</Value>
</Value>
<Value name="9">
<Value>australianPostalAddress</Value>
</Value>
<Value name="10">
<Value>australianStreetAddress</Value>
</Value>
<Value name="11">
<Value>internationalAddress</Value>
</Value>
<Value name="12">
<Value>history</Value>
</Value>
<Value name="13">
<Value>MedicareCardNumber</Value>
</Value>
<Value name="14">
<Value>MedicareIRN</Value>
</Value>
<Value name="15">
<Value>DVAFileNumber</Value>
</Value>
<Value name="16">
<Value>AustralianPostalAddress</Value>
</Value>
<Value name="17">
<Value>AustralianStreetAddress</Value>
</Value>
<Value name="18">
<Value>InternationalAddress</Value>
</Value>
<Value name="19">
<Value>History</Value>
</Value>
<Value name="20">
<Value>SAMLData</Value>
</Value>
</Data>
<DefaultData>SearchIHIRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
