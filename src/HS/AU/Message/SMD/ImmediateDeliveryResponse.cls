Class HS.AU.Message.SMD.ImmediateDeliveryResponse Extends Ens.Response [ ClassType = persistent, ProcedureBlock ]
{

Property Metadata As HS.AU.Types.SMD.MessageMetadataType(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/smd/xsd/SealedMessage/2010", XMLNAME = "metadata", XMLREF = 1);

Property PayloadObject As %Persistent(CLASSNAME = 1);

Storage Default
{
<Data name="ImmediateDeliveryResponseDefaultData">
<Subscript>"ImmediateDeliveryResponse"</Subscript>
<Value name="1">
<Value>Metadata</Value>
</Value>
<Value name="2">
<Value>PayloadObject</Value>
</Value>
</Data>
<DefaultData>ImmediateDeliveryResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
