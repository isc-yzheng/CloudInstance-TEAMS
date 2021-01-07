Class HS.Util.Trace.Item Extends (%SerialObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property ItemName As %String(MAXLEN = "");

Property ItemValue As %String(CONTENT = "MIXED", MAXLEN = "");

Property ItemClass As %String(MAXLEN = "");

Property ItemStream As %GlobalCharacterStream(CONTENT = "MIXED");

Storage Default
{
<Data name="ItemState">
<Value name="1">
<Value>vName</Value>
</Value>
<Value name="2">
<Value>vValue</Value>
</Value>
<Value name="3">
<Value>vClass</Value>
</Value>
<Value name="4">
<Value>ItemName</Value>
</Value>
<Value name="5">
<Value>ItemValue</Value>
</Value>
<Value name="6">
<Value>ItemClass</Value>
</Value>
<Value name="7">
<Value>ItemStream</Value>
</Value>
</Data>
<State>ItemState</State>
<StreamLocation>^HS.Util.Trace.ItemS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
