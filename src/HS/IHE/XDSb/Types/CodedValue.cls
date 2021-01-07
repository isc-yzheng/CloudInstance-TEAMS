Class HS.IHE.XDSb.Types.CodedValue Extends (%SerialObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property Code As %String(MAXLEN = 100);

Property Description As %String(MAXLEN = "");

Property Scheme As %String(MAXLEN = 100);

/// Code, Scheme, Description
Method %OnNew(code, scheme, description) As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	Set i%Code=$G(code)
	Set i%Scheme=$G(scheme)
	Set i%Description=$G(description)
	Quit $$$OK
}

ClassMethod Create(Code = "", Scheme = "", Description = "") As CodedValue
{
	Quit ..%New(Code,Scheme,Description)
}

Storage Default
{
<Data name="CodedValueState">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Scheme</Value>
</Value>
</Data>
<State>CodedValueState</State>
<StreamLocation>^HS.IHE.XDSb.Types.CodedValueS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
