Class HS.AU.Types.SMD.Deliver Extends (%SerialObject, %XML.Adaptor)
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/smd/svc/SealedMessageDelivery/2010";

Parameter XMLNAME = "deliver";

Parameter XMLSEQUENCE = 1;

Property Message As HS.AU.Types.SMD.SealedMessageType(XMLNAME = "message");

Storage Default
{
<Data name="DeliverState">
<Value name="1">
<Value>Message</Value>
</Value>
</Data>
<State>DeliverState</State>
<StreamLocation>^HS.AU.Types.SMD.DeliverS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
