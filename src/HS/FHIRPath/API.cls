Class HS.FHIRPath.API Extends %RegisteredObject
{

Property parser As HS.FHIRPath.Parser [ Private ];

Property parserCache [ Private ];

Property impl As HS.FHIRPath.Impl [ Private ];

Method %OnNew(metaAPI As HS.FHIRMeta.API, debug As %Integer = 0) As %Status [ Private ]
{
	Set ..parser = ##class(HS.FHIRPath.Parser).%New("4.0")
	Set ..impl = ##class(HS.FHIRPath.Impl).%New(metaAPI, debug)
	Do ..enableCache(0)
	return $$$OK
}

/// Obtain an instance of a FHIRPath processor for the specified schema.
ClassMethod getInstance(mdSetKey As %String, traceLevel As %Integer = 0) As HS.FHIRPath.API
{
	#dim metaAPI as HS.FHIRMeta.API = ##class(HS.FHIRMeta.API).getInstance(mdSetKey)
	Set pathAPI = metaAPI.FHIRPathAPI
	Do pathAPI.setTraceLevel(traceLevel)
	return pathAPI
}

/// Clears and existing cached expressions and enables or disables an in-memory cache
/// of parsed FHIRPath expressions.  Provides performance improvement for repetitive usage
/// of a limited set of expressions (e.g. search parameter expressions, etc).
/// <br> @Input enable - If 1, enables caching, if 0, disables caching
Method enableCache(enable As %Boolean)
{
	if enable {
		Set ..parserCache = ##class(LocalParseCache).%New(..parser)	
	} else {
		Set ..parserCache = ..parser
	}
}

Method setTraceLevel(trace As %Integer)
{
	Do ..impl.setTraceLevel(trace)
}

/// Parse a FHIRPath expression into a "parse tree" of HS.FHIRPath.Node objects.
/// <br> returns the root Node of the tree.  
Method parse(fhirPath As %String) As Node [ CodeMode = expression ]
{
..parserCache.parse(fhirPath)
}

Method serializeParseTree(parseTree As Node) [ CodeMode = expression ]
{
parseTree.toSerial()
}

Method deserializeParseTree(serialData As %String) As Node [ CodeMode = expression ]
{
##class(Node).fromSerial(serialData)
}

/// Evaluate a FHIRPath Node (from a previously parsed expression) and return the
/// value collection selected by that expression from the provided resource object.
/// <br> Output is a multi-dimensional array of the following form
/// <pre>
/// Output         the count of value nodes
/// Output(n)      the value information of the n-th element in the output collection
/// Output(n,"ar") 1 if the referenced property is an array, 0 if a scalar 
/// Output(n,"mv") 1 if the expression can yield more than one value, 0 if a single value 
/// Output(n,"t")  the FHIR datatype of the n-th element in the output collection
/// Output(n,"tl") the FHIR datatype of the n-th element in the output collection
/// Output(n,"vt") the FHIR datatype of the n-th element in the output collection
/// </pre>
Method evaluate(resource As %DynamicObject, withParseTree As Node, Output OUTPUT)
{
	Do ..impl.interpret(resource, withParseTree, .OUTPUT)
}

/// Evaluate a FHIRPath Node (from a previously parsed expression) and return the
/// %DynamicArray of the values selected by that expression from the provided resource object.
/// <br>Note, if the FHIR datatype of the collection elements is needed, use the evaluate method
Method evaluateToJson(resource As %DynamicObject, withParseTree As Node) As %DynamicArray
{
	return ..impl.interpretToJson(resource, withParseTree)
}

/// Returns the contextPath and datatype of a FHIRPath expression.  The contextPath
/// <br>Output contextPath - is a %List of the field names used to navigate to the expression value.
/// <br>Output datatype - A multi-dimensional result.  The top-node is the resulting datatype of the expression. 
/// It may not be the datatype of the referenced data element if, say, a boolean function like 'exists' is applied to that
/// data element.
/// If the datatype is "Reference", then datatype("r") will be a %List of allowable target ResourceType's
/// 
/// datatype("ar") 1 if the referenced property is an array, 0 if a scalar 
/// datatype("mv") 1 if the expression can yield more than one value, 0 if a single value 
/// datatype("r")  If the reference property has a "where(resolve() is <type>)" the required <type>, otherwise empty
/// datatype("t")  the FHIR datatype of expression
/// datatype("tl") If the property contains a reference, a %List of allowable target ResourceType's, otherwise not present
/// datatype("vt") If the datatype is "variant", the allowable variant datatype(s), otherwise not present
/// <br>NOTE: This function is intended for single-path expressions and will fail otherwise.
Method getPathAndType(resourceType As %String, withParseTree As Node, Output contextPath As %List, Output datatype)
{
	Do ..impl.datatype(resourceType, withParseTree, .contextPath, .datatype)
}

}
