Class HS.Types.IHE.XDSb.ValueType Extends (%SerialObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property ValueText As %String(MAXLEN = "", XMLPROJECTION = "content");

Property Charset As %String(XMLPROJECTION = "attribute");

Property Lang As %String(XMLPROJECTION = "attribute");

Method %OnNew(pValueText = "", pCharSet = "", pLang = "") As %Status [ Private, ServerOnly = 1 ]
{
	Set i%ValueText=pValueText
	Set i%Charset=pCharSet
	Set i%Lang=pLang
	Quit $$$OK
}

Storage Default
{
<Data name="ValueTypeState">
<Value name="1">
<Value>ValueText</Value>
</Value>
<Value name="2">
<Value>Charset</Value>
</Value>
<Value name="3">
<Value>Lang</Value>
</Value>
</Data>
<State>ValueTypeState</State>
<StreamLocation>^HS.Types.IHE.XDSb.ValueTypeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
