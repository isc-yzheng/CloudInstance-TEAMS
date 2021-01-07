Class HS.AU.Types.SMD.DeliverErrorType Extends (%SerialObject, %XML.Adaptor)
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/smd/svc/SealedMessageDelivery/2010";

Parameter XMLNAME = "DeliverErrorType";

Parameter XMLSEQUENCE = 1;

Property DeliveryResponse As HS.AU.Types.SMD.DeliveryResponseType(XMLNAME = "deliveryResponse");

Storage Default
{
<Data name="DeliverErrorTypeState">
<Value name="1">
<Value>DeliveryResponse</Value>
</Value>
</Data>
<State>DeliverErrorTypeState</State>
<StreamLocation>^HS.AU.TypesB46.DeliverErro79ACS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
