/// This is an INTERNAL object, used only during parsing
/// PSE stands for Parser Stack Element.
Class HS.FHIRPath.PSE Extends %RegisteredObject
{

Property cls As %String;

Property token As Token;

/// Terms for operator or function call arguments
Property node As Node;

Method %OnNew(cls As %String, token As Token, node As Node = "") As %Status
{
	Set ..cls = cls
	Set ..token = token
	Set ..node = node
	Quit $$$OK
}

Method asString() As %String
{
	return "[" _ ..cls _ "] " _ ..node.asString()
}

}
