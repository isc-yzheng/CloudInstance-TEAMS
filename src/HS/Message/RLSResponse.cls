Class HS.Message.RLSResponse Extends HS.Util.EnsResponse [ ClassType = persistent, ProcedureBlock ]
{

Property Accepted As %Boolean [ InitialExpression = 1 ];

Property Code As %Integer [ InitialExpression = 0 ];

Property Text As %String(MAXLEN = 1024);

Storage Default
{
<Data name="RLSResponseDefaultData">
<Subscript>"RLSResponse"</Subscript>
<Value name="1">
<Value>Accepted</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Text</Value>
</Value>
</Data>
<DefaultData>RLSResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
