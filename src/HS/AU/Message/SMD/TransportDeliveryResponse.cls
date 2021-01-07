/// 
Class HS.AU.Message.SMD.TransportDeliveryResponse Extends (Ens.Response, %XML.Adaptor)
{

Property Status As %String;

Storage Default
{
<Data name="TransportDeliveryResponseDefaultData">
<Subscript>"TransportDeliveryResponse"</Subscript>
<Value name="1">
<Value>Status</Value>
</Value>
</Data>
<DefaultData>TransportDeliveryResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
