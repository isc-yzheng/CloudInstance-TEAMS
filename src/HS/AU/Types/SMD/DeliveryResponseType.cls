Class HS.AU.Types.SMD.DeliveryResponseType Extends (%SerialObject, %XML.Adaptor)
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/smd/xsd/TransportResponse/2010";

Parameter XMLNAME = "DeliveryResponseType";

Parameter XMLSEQUENCE = 1;

Property ResponseClass As %String(MAXLEN = "", REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/smd/xsd/TransportResponse/2010", VALUELIST = ",Success,Information,Warning,Error", XMLNAME = "responseClass", XMLREF = 1);

Property ResponseCode As %xsd.anyURI(XMLNAME = "responseCode");

Property Message As %String(MAXLEN = "", XMLNAME = "message");

Property DigestValue As %xsd.base64Binary(XMLNAME = "digestValue");

Storage Default
{
<Data name="DeliveryResponseTypeState">
<Value name="1">
<Value>ResponseClass</Value>
</Value>
<Value name="2">
<Value>ResponseCode</Value>
</Value>
<Value name="3">
<Value>Message</Value>
</Value>
<Value name="4">
<Value>DigestValue</Value>
</Value>
</Data>
<State>DeliveryResponseTypeState</State>
<StreamLocation>^HS.AU.TypesB46.DeliveryResE3B6S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
