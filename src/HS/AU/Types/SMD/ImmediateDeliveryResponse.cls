Class HS.AU.Types.SMD.ImmediateDeliveryResponse Extends (%SerialObject, %XML.Adaptor)
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/smd/svc/SealedImmediateMessageDelivery/2010";

Parameter XMLNAME = "deliverResponse";

Parameter XMLSEQUENCE = 1;

Property Response As HS.AU.Types.SMD.SealedMessageType(XMLNAME = "response") [ Required ];

Storage Default
{
<Data name="ImmediateDeliveryResponseState">
<Value name="1">
<Value>Response</Value>
</Value>
</Data>
<State>ImmediateDeliveryResponseState</State>
<StreamLocation>^HS.AU.TypesB46.ImmediateDeECBAS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
