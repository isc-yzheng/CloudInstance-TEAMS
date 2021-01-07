Class HS.FHIRMeta.SearchParam Extends %SerialObject
{

/// The resource that this parameter applies to
Property resourceType As %String;

/// The name used in the URL
Property name As %String;

/// Type of search parameter
Property type As %String;

/// For 'reference' parameters: $List of allowable reference targets 
/// For 'composite' parameters: $List of component parameter names
Property target As %List;

/// $List of access steps
Property expression As %List;

/// The full FHIRPath expression for this parameter
Property fhirPath As %String;

/// $List of allowable data types if the datatype is "variant"
Property variantTypes As %List;

Property code As %String;

/// $List of allowable data types for the values of this searchParameter
Property datatypes As %List;

/// True if this field could have multiple values (because some property
/// within its target path is an array)
Property isMultiValue As %Boolean;

/// If this search parameter can match the value of multiple properties, then
/// this is a $List of the additional serialized parameters in the set
Property otherParams As %List;

/// Serialized Search Parameter if there are multiple sources
/// All elements in this chain are OR'd together in a query
Method toSerial() As %String
{
	return ..%GetSerial()
}

ClassMethod fromSerial(ser)
{
	Set obj = ..%New()
	Do obj.%SetSerial(ser)
	return obj
}

Method nextOther(ByRef index As %Integer, Output searchParam As SearchParam) As %Boolean
{
	if $I(index) <= $LL(..otherParams) {
		Set searchParam = ..fromSerial($LG(..otherParams, index))
		return 1
	}
	return 0
}

Method getParamSet(Output paramSet)
{
	kill paramSet
	Set paramSet = 0
	Set paramSet($I(paramSet)) = $this
	for ord=1:1:$LL(..otherParams) {
		Set paramSet($I(paramSet)) = ..fromSerial($LG(..otherParams, ord))	
	}
}

Method ToString() As %String
{
	Set s = ..resourceType _ "?" _ ..code _ $select(..code '= ..name:(" (name=" _ ..name) _") [", 1:" [") _ ..type _ "]"
	if ..type="composite" {
		Set s = s _ " composite of (" _ $lts(..target) _ ")"
	} else {
		Do ..getParamSet(.set)
		Set ix = ""
		Set suffix = ""
		for {
			Set ix = $Order(set(ix),1,param)
			Quit:ix=""
			Set s = s _ suffix
			Set suffix = " OR"
			Do appendParam()
		}
			}	
	quit s
	
appendParam()
	Set multiStr = $Case(param.isMultiValue, 0:"} ", 1:":a} ", 2:":A} ", 3:":Aa} ")
	Set s = s _ " {" _ $LG(param.datatypes) _ multiStr
	Set s = s _ " at (" _ $lts(param.expression) _ ")"
	if ..type="reference" {
		set s = s _ " for "_$S(param.target="":"<Any>", 1:$lts(param.target))
		}
	if param.where '= "" {
		set s = s _ ", where: " _ $LTS(param.where," = ")
	}
	Quit
}

Storage Default
{
<Data name="SearchParamState">
<Value name="1">
<Value>resourceType</Value>
</Value>
<Value name="2">
<Value>name</Value>
</Value>
<Value name="3">
<Value>type</Value>
</Value>
<Value name="4">
<Value>target</Value>
</Value>
<Value name="5">
<Value>expression</Value>
</Value>
<Value name="6">
<Value>code</Value>
</Value>
<Value name="7">
<Value>datatypes</Value>
</Value>
<Value name="8">
<Value>isMultiValue</Value>
</Value>
<Value name="9">
<Value>otherParams</Value>
</Value>
<Value name="10">
<Value>fhirPath</Value>
</Value>
<Value name="11">
<Value>varianttypes</Value>
</Value>
<Value name="12">
<Value>variantTypes</Value>
</Value>
</Data>
<State>SearchParamState</State>
<StreamLocation>^HS.FHIRServer.SearchParamS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
