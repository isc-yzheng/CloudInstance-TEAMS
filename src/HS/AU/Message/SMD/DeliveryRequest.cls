/// Used for asynchronous / deferred delivery requests (versus ImmediateDeliveryRequest)
Class HS.AU.Message.SMD.DeliveryRequest Extends HS.AU.Message.SMD.DeliveryRequestBase
{

Parameter RESPONSECLASSNAME As %String = "HS.AU.Message.SMD.DeliveryResponse";

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
