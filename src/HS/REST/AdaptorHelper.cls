Class HS.REST.AdaptorHelper [ Abstract ]
{

/// Returns the JSON serialized type for <var>pObjPropType</var>, setting it to <var>pProvidedType</var>, if given. <br />
/// Returns "" if <var>pObjPropType</var> is not directly serialized to JSON. <br />
/// @Argument	pObjPropType				name of property as expressed in COS
/// @Argument	pProvidedType				optional JSON type to be used instead of generating a type from the COS type
ClassMethod GetJSONType(pObjPropType As %String, pProvidedType As %String = "") As %String [ Final ]
{
	If pProvidedType '= "" {
		Quit pProvidedType
	}
	// Get mappings from COS type to json type
	Do ..GetObjTypeToJsonTypeMappings(.tObjTypeToJsonType)
	
	Set tObjPropType = $$$NormalizeClassname(pObjPropType)
	Set tObjType = "", tJsonPropType = ""
	// Go through all mappings, setting the json type if a mapping is matched
	While 1 {
		Set tObjType = $Order(tObjTypeToJsonType(tObjType))
		Quit:(tObjType = "")
		// mapping is equal if object type directly matches, or is a data type and a subclass of the object type
		If ((tObjPropType = tObjType) || (($$$comClassKeyGet(tObjPropType, $$$cCLASSclasstype) = $$$cCLASSCLASSTYPEDATATYPE) && $ClassMethod(tObjPropType, "%Extends", tObjType))) {
			Set tJsonPropType = tObjTypeToJsonType(tObjType)
			Quit
		}
	}
	Quit tJsonPropType
}

/// Returns the mappings of COS property types to equivalent JSON types in the subscripted array <var>pObjTypeToJsonType</var>. <br />
/// Structure of <var>pObjTypeToJsonType</var>: <code> pObjTypeToJsonType("COS type") = "JSON type". </code>
ClassMethod GetObjTypeToJsonTypeMappings(Output pObjTypeToJsonType) [ Final, Private ]
{
	kill pObjTypeToJsonType
	Set pObjTypeToJsonType("%Library.Boolean") = "boolean"
	
	Set pObjTypeToJsonType("%Library.Decimal") = "number"
	Set pObjTypeToJsonType("%Library.Double") = "number"
	Set pObjTypeToJsonType("%Library.Float") = "number"
	Set pObjTypeToJsonType("%Library.Integer") = "number"
	Set pObjTypeToJsonType("%Library.Numeric") = "number"
	
	Set pObjTypeToJsonType("%Library.Binary") = "string"
	Set pObjTypeToJsonType("%Library.Currency") = "string"
	Set pObjTypeToJsonType("%Library.Date") = "string"
	Set pObjTypeToJsonType("%Library.EnumString") = "string"
	Set pObjTypeToJsonType("%Library.InformixTimeStamp") = "string"
	Set pObjTypeToJsonType("%Library.Name") = "string"
	Set pObjTypeToJsonType("%Library.String") = "string"
	Set pObjTypeToJsonType("%Library.StringTimeStamp") = "string"
	Set pObjTypeToJsonType("%Library.Time") = "string"
	Set pObjTypeToJsonType("%Library.TimeStamp") = "string"
	Set pObjTypeToJsonType("%Library.UTC") = "string"
	Set pObjTypeToJsonType("%Library.UniqueIdentifier") = "string"
	
	Set pObjTypeToJsonType("%Library.DynamicAbstractObject") = "json"
	Set pObjTypeToJsonType("%Library.DynamicObject") = "json"
	Set pObjTypeToJsonType("%Library.DynamicArray") = "json"
}

/// Returns the JSON serialized name for <var>pObjPropName</var>, setting it to <var>pProvidedName</var>, if given. <br />
/// @Argument	pObjPropName				name of property as expressed in COS
/// @Argument	pProvidedName				optional JSON name to be used instead of generating a name from the COS name
ClassMethod GetJSONName(pObjPropName As %String, pProvidedName As %String = "") [ Final ]
{
	
	Quit:pProvidedName'="" pProvidedName
	Quit pObjPropName
}

/// Returns the name of <var>pObjPropName</var> as exposed in JSON (i.e. all lower case, in snake_case). <br />
/// NOTE: This does not handle the case for when any special characters occur in <var>pObjPropName</var>. <br />
/// @Argument	pObjPropName				name of property as expressed in COS
ClassMethod GetObjNameToJsonName(pObjPropName As %String) [ Final, Private ]
{
	Set tResult = $Extract(pObjPropName)
	For ord=2:1:$Length(pObjPropName) {
		Set tPrev = $Extract(pObjPropName, (ord - 1))
		Set tCurr = $Extract(pObjPropName, ord)
		// only append underscore if one of these conditions is satisfied:
		// - previous letter was lower case and current letter is upper case
		// - previous letter was upper case. Current letter is upper case. Next letter is lower case
		If (tPrev = $ZConvert(tPrev, "L")) && (tCurr = $ZConvert(tCurr, "U")) {
			Set tResult = tResult_"_"_tCurr
		} ElseIf (ord < $Length(pObjPropName)) {
			Set tNext = $Extract(pObjPropName, (ord + 1))
			If (tPrev = $ZConvert(tPrev, "U")) && (tCurr = $ZConvert(tCurr, "U")) && (tNext = $ZConvert(tNext, "L")) {
				Set tResult = tResult_"_"_tCurr
			} Else {
				Set tResult = tResult_tCurr
			}
		} Else {
			Set tResult = tResult_tCurr
		}
	}
	// comvert entire string to lower case
	Quit $ZConvert(tResult, "L")
}

}
