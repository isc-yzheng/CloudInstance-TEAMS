/// Used for Synchronous requests (versus asynchronous DeliveryRequest)
Class HS.AU.Message.SMD.ImmediateDeliveryRequest Extends HS.AU.Message.SMD.DeliveryRequestBase [ ProcedureBlock ]
{

Parameter RESPONSECLASSNAME As %String = "HS.AU.Message.SMD.ImmediateDeliveryResponse";

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
