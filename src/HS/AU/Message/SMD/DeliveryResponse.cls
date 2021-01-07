/// 
Class HS.AU.Message.SMD.DeliveryResponse Extends (Ens.Response, %XML.Adaptor)
{

Property Status As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/smd/svc/SealedMessageDelivery/2010", VALUELIST = ",ok,duplicate", XMLNAME = "status");

Storage Default
{
<Data name="DeliveryResponseDefaultData">
<Subscript>"DeliveryResponse"</Subscript>
<Value name="1">
<Value>Status</Value>
</Value>
</Data>
<DefaultData>DeliveryResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
