/// Test case values are always strings and have no length restriction 
Class HS.Test.Types.Value Extends HS.Test.Types.Base
{

Property Value As %String(MAXLEN = "", XMLNAME = "value", XMLPROJECTION = "ATTRIBUTE");

Method %OnNew(value) As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	Set i%Value = $G(value)
	Quit $$$OK
}

}
