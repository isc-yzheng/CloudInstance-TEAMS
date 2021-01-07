Class HS.AU.Types.HI.Address.PostalDeliveryGroupType Extends (%SerialObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/AddressCore/3.0";

Property PostalDeliveryType As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/AddressCore/3.0", VALUELIST = ",Care PO,CMA,CMB,GPO Box,Locked Bag,MS,PO Box,POR,Private Bag,RSD,RMB,RMS", XMLNAME = "postalDeliveryType", XMLREF = 1);

Property PostalDeliveryNumber As %String(MAXLEN = 11, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/AddressCore/3.0", XMLNAME = "postalDeliveryNumber", XMLREF = 1);

Storage Default
{
<Data name="PostalDeliveryGroupTypeState">
<Value name="1">
<Value>PostalDeliveryType</Value>
</Value>
<Value name="2">
<Value>PostalDeliveryNumber</Value>
</Value>
</Data>
<State>PostalDeliveryGroupTypeState</State>
<StreamLocation>^HS.AU.Types2A5.PostalDelivDA18S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
