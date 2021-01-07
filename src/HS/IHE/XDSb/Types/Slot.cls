Class HS.IHE.XDSb.Types.Slot Extends (%SerialObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property Name As %String(MAXLEN = "", XMLNAME = "name", XMLPROJECTION = "ATTRIBUTE");

Property ValueList As list Of SlotValue;

Storage Default
{
<Data name="SlotState">
<Value name="1">
<Value>Name</Value>
</Value>
<Value name="2">
<Value>ValueList</Value>
</Value>
</Data>
<State>SlotState</State>
<StreamLocation>^HS.IHE.XDSb.Types.SlotS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
