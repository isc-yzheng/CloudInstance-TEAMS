Class HS.AU.Message.HI.NotifyReplicaIHIRequest Extends HS.AU.Message.CommonRequest [ ProcedureBlock ]
{

Parameter RESPONSECLASSNAME = "HS.AU.Message.HI.NotifyReplicaIHIResponse";

Parameter XMLTYPE = "notifyReplicaIHI";

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/svc/ConsumerNotifyReplicaIHI/3.2.0";

Property IHINumber As %String(MAXLEN = "", MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/ConsumerCoreElements/3.2.0", XMLNAME = "ihiNumber", XMLPROJECTION = "ELEMENT", XMLREF = 1);

Property Comment As %String(MAXLEN = 240, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/ConsumerCoreElements/3.2.0", XMLNAME = "comment", XMLREF = 1);

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.AU.Message.HI.NotifyReplicaIHIRequest.AdditionalInfo"</Subscript>
</Data>
<Data name="NotifyReplicaIHIRequestDefaultData">
<Subscript>"NotifyReplicaIHIRequest"</Subscript>
<Value name="1">
<Value>SAMLData</Value>
</Value>
<Value name="2">
<Value>IHINumber</Value>
</Value>
<Value name="3">
<Value>Comment</Value>
</Value>
</Data>
<DefaultData>NotifyReplicaIHIRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
