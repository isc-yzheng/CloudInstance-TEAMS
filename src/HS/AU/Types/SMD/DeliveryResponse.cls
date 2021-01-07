/// 
Class HS.AU.Types.SMD.DeliveryResponse Extends (%SerialObject, %XML.Adaptor)
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/smd/svc/SealedMessageDelivery/2010";

Parameter XMLNAME = "deliverResponse";

Parameter XMLSEQUENCE = 1;

Property Status As %String(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/smd/svc/SealedMessageDelivery/2010", VALUELIST = ",ok,duplicate", XMLNAME = "status");

Storage Default
{
<Data name="DeliveryResponseState">
<Value name="1">
<Value>Status</Value>
</Value>
</Data>
<State>DeliveryResponseState</State>
<StreamLocation>^HS.AU.TypesB46.DeliveryRes2D0ES</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
