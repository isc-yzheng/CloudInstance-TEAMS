Class HS.AU.Types.SMD.TransportResponseType Extends (%SerialObject, %XML.Adaptor)
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/smd/xsd/TransportResponse/2010";

Parameter XMLNAME = "TransportResponseType";

Parameter XMLSEQUENCE = 1;

Property Metadata As HS.AU.Types.SMD.TransportResponseMetadataType(XMLNAME = "metadata");

Property DeliveryResponse As HS.AU.Types.SMD.DeliveryResponseType(XMLNAME = "deliveryResponse");

Property Final As %Boolean(XMLNAME = "final");

Storage Default
{
<Data name="TransportResponseTypeState">
<Value name="1">
<Value>Metadata</Value>
</Value>
<Value name="2">
<Value>DeliveryResponse</Value>
</Value>
<Value name="3">
<Value>Final</Value>
</Value>
</Data>
<State>TransportResponseTypeState</State>
<StreamLocation>^HS.AU.TypesB46.TransportReA703S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
