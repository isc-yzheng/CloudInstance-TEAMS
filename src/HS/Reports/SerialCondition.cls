Class HS.Reports.SerialCondition Extends (%SerialObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

/// for the left side of the expression
Property FieldName As %String;

/// for the right side of the expression
Property ValueInternal As %String(MAXLEN = 200);

/// The display value of the ValueInternal
Property ValueDisplay As %String(MAXLEN = "");

Storage Default
{
<Data name="SerialConditionState">
<Value name="1">
<Value>FieldName</Value>
</Value>
<Value name="2">
<Value>ValueInternal</Value>
</Value>
<Value name="3">
<Value>ValueDisplay</Value>
</Value>
</Data>
<State>SerialConditionState</State>
<StreamLocation>^HS.Reports.SerialConditionS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
