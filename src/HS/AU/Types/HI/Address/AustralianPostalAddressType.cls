Class HS.AU.Types.HI.Address.AustralianPostalAddressType Extends (%SerialObject, %XML.Adaptor) [ CompileAfter = HS.AU.Types.HI.Address.PostalDeliveryGroupType, ProcedureBlock ]
{

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/Address/3.0";

Property State As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/AddressCore/3.0", VALUELIST = ",ACT,NSW,NT,QLD,SA,TAS,VIC,WA", XMLNAME = "state", XMLREF = 1);

Property Postcode As %String(MAXLEN = 4, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/AddressCore/3.0", XMLNAME = "postcode", XMLREF = 1);

Property Suburb As %String(MAXLEN = 30, MINLEN = 1, REFELEMENTQUALIFIED = 0, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/AddressCore/3.0", XMLNAME = "suburb", XMLREF = 0);

Property PostalDeliveryGroup As HS.AU.Types.HI.Address.PostalDeliveryGroupType(REFELEMENTQUALIFIED = 0, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/AddressCore/3.0", XMLNAME = "postalDeliveryGroup", XMLREF = 1);

Storage Default
{
<Data name="AustralianPostalAddressTypeState">
<Value name="1">
<Value>State</Value>
</Value>
<Value name="2">
<Value>Postcode</Value>
</Value>
<Value name="3">
<Value>Suburb</Value>
</Value>
<Value name="4">
<Value>PostalDeliveryGroup</Value>
</Value>
</Data>
<State>AustralianPostalAddressTypeState</State>
<StreamLocation>^HS.AU.Types2A5.AustralianPF0C3S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
