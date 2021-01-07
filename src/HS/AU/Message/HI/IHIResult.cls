/// 
Class HS.AU.Message.HI.IHIResult Extends (%SerialObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Property IHINumber As %String(MAXLEN = "", MINLEN = 1, REFELEMENTQUALIFIED = 1, XMLNAME = "ihiNumber", XMLREF = 1);

Property IHIRecordStatus As %String(REFELEMENTQUALIFIED = 1, VALUELIST = ",Provisional,Unverified,Verified", XMLNAME = "ihiRecordStatus", XMLREF = 1);

Property IHIStatus As %String(REFELEMENTQUALIFIED = 1, VALUELIST = ",Active,Deceased,Expired,Resolved,Retired", XMLNAME = "ihiStatus", XMLREF = 1);

Property ServiceMessages As HS.AU.Types.HI.ServiceMessagesType(REFELEMENTQUALIFIED = 1, XMLNAME = "serviceMessages", XMLREF = 1);

Storage Default
{
<Data name="IHIResultState">
<Value name="1">
<Value>IHINumber</Value>
</Value>
<Value name="2">
<Value>IHIRecordStatus</Value>
</Value>
<Value name="3">
<Value>IHIStatus</Value>
</Value>
<Value name="4">
<Value>ServiceMessages</Value>
</Value>
</Data>
<State>IHIResultState</State>
<StreamLocation>^HS.AU.Message.HI.IHIResultS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
