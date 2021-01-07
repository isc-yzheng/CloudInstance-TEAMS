Class HS.FHIRMeta.Load.Type Extends %RegisteredObject
{

Property id As %String;

/// "complex-type", "primitive-type", "resource"
Property kind As %String;

/// Superclass of this type
Property baseType As %String;

/// Validation Regex (for primitives)
Property regex As %String;

/// JSON type (for primitives)
Property jsonType As %String;

/// True if type is abstract
Property isAbstract As %Boolean;

/// Unique StructureDefinition Identifier
Property url As %String;

Method %OnNew(id As %String, url As %String, kind As %String = "") As %Status
{
	Set ..id = id
	Set ..url = url
	Set ..kind = kind
	// Defaults
	Set ..jsonType = "object"
	set ..isAbstract = 0
	return $$$OK
}

Method isPrimitive() As %Boolean [ CodeMode = expression ]
{
..kind = "primitive-type"
}

Method isResource() As %Boolean [ CodeMode = expression ]
{
..kind = "resource"
}

Method isComplex() As %Boolean [ CodeMode = expression ]
{
..kind = "complex-type"
}

Method isExtension() As %Boolean [ CodeMode = expression ]
{
..kind = "extension-type"
}

Method asString() As %String
{
	Set str = "Type[" _ $E(..kind) _ ": " _ ..id 
	if ..baseType '= "" {
		set str = str _ " :: " _ ..baseType
	}
	if ..isAbstract {
		set str = str _ " (abstract)"
	}
	Set str = str _ ", jt="_..jsonType
	if ..regex '= "" {
		Set str = str _ ", rx="_..regex
	}
	Set str = str _ " from " _ $Piece(..url, "/", *)
	return str _ "]"
}

}
