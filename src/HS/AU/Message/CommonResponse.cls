Class HS.AU.Message.CommonResponse Extends Ens.Response [ ProcedureBlock ]
{

Parameter XMLIGNORENULL = "inputonly";

Property ServiceCallStatus As %Binary(MAXLEN = "") [ InitialExpression = {$$$OK} ];

Property ServiceCallCode As %String(MAXLEN = "", MINLEN = 1, XMLNAME = "ServiceCallCode");

Property ServiceCallDescription As %String(MAXLEN = "", XMLNAME = "ServiceCallDescription");

Storage Default
{
<Data name="CommonResponseDefaultData">
<Subscript>"CommonResponse"</Subscript>
<Value name="1">
<Value>ServiceCallStatus</Value>
</Value>
<Value name="2">
<Value>ServiceCallCode</Value>
</Value>
<Value name="3">
<Value>ServiceCallDescription</Value>
</Value>
</Data>
<DefaultData>CommonResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
