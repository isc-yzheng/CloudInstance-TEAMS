Class HS.AU.Types.HI.ServiceMessageType Extends (%SerialObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0";

Parameter XMLNAME = "ServiceMessageType";

Parameter XMLSEQUENCE = 1;

Property Code As %String(MAXLEN = "", XMLNAME = "code") [ Required ];

Property Severity As HS.AU.Types.HI.SeverityType(XMLNAME = "severity") [ Required ];

Property Reason As %String(MAXLEN = "", XMLNAME = "reason") [ Required ];

Property Details As HS.AU.Types.HI.Detail(XMLNAME = "details");

Storage Default
{
<Data name="ServiceMessageTypeState">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Severity</Value>
</Value>
<Value name="3">
<Value>Reason</Value>
</Value>
<Value name="4">
<Value>Details</Value>
</Value>
</Data>
<State>ServiceMessageTypeState</State>
<StreamLocation>^HS.AU.Type3554.ServiceMess24B2S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
