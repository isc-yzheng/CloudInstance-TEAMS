Class HS.AU.Types.HI.AddressType Extends (%SerialObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter XMLNAME = "addressType";

Property AustralianStreetAddress As HS.AU.Types.HI.Address.AustralianStreetAddressType(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/Address/3.0", XMLNAME = "australianStreetAddress", XMLREF = 1);

Property AustralianPostalAddress As HS.AU.Types.HI.Address.AustralianPostalAddressType(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/Address/3.0", XMLNAME = "australianPostalAddress", XMLREF = 1);

Property InternationalAddress As HS.AU.Types.HI.Address.InternationalAddressType(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/Address/3.0", XMLNAME = "internationalAddress", XMLREF = 1);

Property Purpose As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/AddressCore/3.0", VALUELIST = ",B,M,U,R,T", XMLNAME = "purpose", XMLREF = 1);

Property Preferred As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0", VALUELIST = ",F,T", XMLNAME = "preferred", XMLREF = 1);

Storage Default
{
<Data name="AddressTypeState">
<Value name="1">
<Value>AustralianStreetAddress</Value>
</Value>
<Value name="2">
<Value>AustralianPostalAddress</Value>
</Value>
<Value name="3">
<Value>InternationalAddress</Value>
</Value>
<Value name="4">
<Value>Purpose</Value>
</Value>
<Value name="5">
<Value>Preferred</Value>
</Value>
</Data>
<State>AddressTypeState</State>
<StreamLocation>^HS.AU.Types.HI.AddressTypeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
