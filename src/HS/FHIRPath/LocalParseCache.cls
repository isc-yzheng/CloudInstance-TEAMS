Class HS.FHIRPath.LocalParseCache Extends %RegisteredObject
{

Property parser As HS.FHIRPath.Parser [ Private ];

Property cache [ MultiDimensional ];

Method %OnNew(parser As HS.FHIRPath.Parser) As %Status
{
	Set ..parser = parser
	return $$$OK
}

/// Parse a FHIRPath expression into a "parse tree" of HS.FHIRPath.Node objects.
/// <br> returns the root Node of the tree.  
Method parse(fhirPath As %String) As Node
{
	if '$D(..cache(fhirPath), tree) {
		Set tree = ..parser.parse(fhirPath)
		Set ..cache(fhirPath) = tree
	}
	return tree
}

}
