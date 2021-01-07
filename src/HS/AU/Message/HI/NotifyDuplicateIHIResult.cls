/// 
Class HS.AU.Message.HI.NotifyDuplicateIHIResult Extends (%SerialObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumermessages/NotifyDuplicateIHI/3.2.0";

Parameter XMLNAME = "notifyDuplicateIHIResult";

Property IHINumberStatusGroup As list Of HS.AU.Types.HI.IHINumberStatusGroupType(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/consumercore/ConsumerCoreElements/3.2.0", XMLNAME = "ihiNumberStatusGroup", XMLPROJECTION = "ELEMENT", XMLREF = 1);

Property ServiceMessages As HS.AU.Types.HI.ServiceMessagesType(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0", XMLNAME = "serviceMessages", XMLREF = 1);

Storage Default
{
<Data name="NotifyDuplicateIHIResultState">
<Value name="1">
<Value>IHINumberStatusGroup</Value>
</Value>
<Value name="2">
<Value>ServiceMessages</Value>
</Value>
</Data>
<State>NotifyDuplicateIHIResultState</State>
<StreamLocation>^HS.AU.Mess8011.NotifyDupliDD01S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
