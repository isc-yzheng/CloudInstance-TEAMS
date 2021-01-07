Class HS.Types.IHE.Error Extends (%SerialObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property Code As %String;

Property Description As %String(MAXLEN = "");

Property Severity As %String;

Property Location As %String(MAXLEN = "");

Storage Default
{
<Data name="ErrorState">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Severity</Value>
</Value>
<Value name="4">
<Value>Location</Value>
</Value>
</Data>
<State>ErrorState</State>
<StreamLocation>^HS.Types.IHE.ErrorS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
