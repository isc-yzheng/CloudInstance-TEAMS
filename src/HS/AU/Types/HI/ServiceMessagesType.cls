Class HS.AU.Types.HI.ServiceMessagesType Extends (%SerialObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0";

Parameter XMLNAME = "ServiceMessagesType";

Parameter XMLSEQUENCE = 1;

Property HighestSeverity As HS.AU.Types.HI.SeverityType(XMLNAME = "highestSeverity");

Property ServiceMessage As list Of HS.AU.Types.HI.ServiceMessageType(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0", XMLNAME = "serviceMessage", XMLPROJECTION = "ELEMENT", XMLREF = 1);

Storage Default
{
<Data name="ServiceMessagesTypeState">
<Value name="1">
<Value>HighestSeverity</Value>
</Value>
<Value name="2">
<Value>ServiceMessage</Value>
</Value>
</Data>
<State>ServiceMessagesTypeState</State>
<StreamLocation>^HS.AU.Type3554.ServiceMessA787S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
