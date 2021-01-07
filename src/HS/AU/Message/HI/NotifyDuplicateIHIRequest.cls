Class HS.AU.Message.HI.NotifyDuplicateIHIRequest Extends HS.AU.Message.CommonRequest [ ProcedureBlock ]
{

Parameter XMLTYPE = "notifyDuplicateIHI";

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/svc/ConsumerNotifyDuplicateIHI/3.2.0";

Parameter RESPONSECLASSNAME = "HS.AU.Message.HI.NotifyDuplicateIHIResponse";

Property IHINumber As list Of %String(MAXLEN = "", MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/ConsumerCoreElements/3.2.0", XMLNAME = "ihiNumber", XMLPROJECTION = "ELEMENT", XMLREF = 1);

Property Comment As %String(MAXLEN = 240, MINLEN = 1, REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/ConsumerCoreElements/3.2.0", XMLNAME = "comment", XMLREF = 1);

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"HS.AU.Message.HI.NotifyDuplicateIHIRequest.AdditionalInfo"</Subscript>
</Data>
<Data name="NotifyDuplicateIHIRequestDefaultData">
<Subscript>"NotifyDuplicateIHIRequest"</Subscript>
<Value name="1">
<Value>IHINumber</Value>
</Value>
<Value name="2">
<Value>Comment</Value>
</Value>
<Value name="3">
<Value>SAMLData</Value>
</Value>
</Data>
<DefaultData>NotifyDuplicateIHIRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
