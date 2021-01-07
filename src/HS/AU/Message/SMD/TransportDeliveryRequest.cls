Class HS.AU.Message.SMD.TransportDeliveryRequest Extends Ens.Request [ ProcedureBlock ]
{

Parameter RESPONSECLASSNAME = "HS.AU.Message.SMD.TransportDeliveryResponse";

Property Response As list Of HS.AU.Types.SMD.TransportResponseType(XMLNAME = "response");

/// Used when creating a TransportDelivery message
Property TransportDeliveryEndpoint As %String(MAXLEN = 3200);

/// Used when creating a TransportDelivery message
Property Sender As %String(MAXLEN = "");

/// Specifiying a NAMESPACE here fixes a problem with projection of these messages in the VisualTrace.
Parameter NAMESPACE As STRING = "http://tempuri.org";

Storage Default
{
<Data name="TransportDeliveryRequestDefaultData">
<Subscript>"TransportDeliveryRequest"</Subscript>
<Value name="1">
<Value>Response</Value>
</Value>
<Value name="2">
<Value>TransportDeliveryEndpoint</Value>
</Value>
<Value name="3">
<Value>Sender</Value>
</Value>
</Data>
<DefaultData>TransportDeliveryRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
