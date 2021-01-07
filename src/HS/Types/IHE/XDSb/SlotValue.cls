Class HS.Types.IHE.XDSb.SlotValue Extends (%SerialObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Parameter XMLNAME = "Value";

Property Value As %String(CONTENT = "ESCAPE", MAXLEN = "", XMLPROJECTION = "CONTENT");

Method %OnNew(initvalue As %Library.RawString) As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	Set ..Value=$G(initvalue)
	Quit $$$OK
}

Storage Default
{
<Data name="SlotValueState">
<Value name="1">
<Value>Value</Value>
</Value>
</Data>
<State>SlotValueState</State>
<StreamLocation>^HS.Types.IHE.XDSb.SlotValueS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
