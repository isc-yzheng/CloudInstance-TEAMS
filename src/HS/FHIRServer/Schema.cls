Include (HS.FHIRServer, %occStatus)

Class HS.FHIRServer.Schema Extends HS.FHIRMeta.Impl.Impl
{

/// Override the Metadata implementation class.  This class adds
/// FHIRServer-specific methods.
Parameter ImplementationClass As %String = "HS.FHIRServer.Schema";

/// The ResourceType index (for properties and search parameters in Schema) for the type that specifies
/// parameters present in all resources
Parameter AllResourceTypeName As %String = "Resource";

Parameter NonResourceName As %String = "NotAResource";

Property referencePaths [ MultiDimensional, Transient ];

/// This is a MultiDimensional projection of property metadata.  It is a performance
/// optimization to get the information from a multidimensional rather than calling
/// %Get on a %DynamicObject (which is the input form of the schema information.  
/// [DEV NOTE] The include file HS.FHIRServer defines accessor macros for this type info.
Property propertyTypeCache [ MultiDimensional ];

/// Debugging Parameter
Parameter AlwaysReload As %Boolean = 1;

/// API
/// Loads the Metadata for the specified FHIR Metadata Set.
/// Includes:
/// 1. FHIR Data Model metadata (data types and properties)
/// 2  Search Parameter metadata
/// 3. Compartment Membership
ClassMethod LoadSchema(key As %String) As HS.FHIRServer.Schema
{
	// Preserve old behavior for friendly names ... map to the base schemas
	if (key = "STU3") {
		Set key = "HL7v30"
	} elseif (key = "R4") {
		Set key = "HL7v40"
	}
	set schema = ..getInstance( key )
	return schema
}

ClassMethod FormatJSON(json As %DynamicObject)
{
	return $$$FormatJSON(json)
}

Method GetSearchParam(resourceType As %String, pParamName As %String) As HS.FHIRServer.SearchParam
{
	#dim searchMeta as HS.FHIRServer.SearchParam  = ..FindSearchParam(resourceType, pParamName)
	If searchMeta="" {
		$$$ThrowFHIR($$$HSFHIRErrInvalidQueryParameter, resourceType, pParamName, $$$OutcomeInvalid(400))
	}
	Return searchMeta
}

/// For the specified search parameter name and value(s), if the search parameter is
/// a reference type parameter, gather search parameter id values that unambiguously
/// apply to the specified reference resource type. Return an error if the search
/// parameter is invalid. Return an error if the search parameter value specifies a
/// reference resource type that does not apply to the search parameter.
Method GetRefTypeIdsFromSearchParam(pSearchResourceType As %String, pParamName As %String, pParamVal As %String, pReferenceResourceType As %String) As %String
{
	#dim tReturnVals as %String = ""
	
	// If this parameter is not a search criteria then return success and no id values.
	if ..IsNonSearchParam(pParamName) {
		Return "" 
	}
	
	// This will throw if the parameter is not valid
	#dim searchParam as HS.FHIRServer.SearchParam = ..GetSearchParam(pSearchResourceType, pParamName)
	
	If searchParam.type '= "reference" {
		Return ""
	}
	
	// "OR" criteria for this parameter values will be separated by comma.
	For tOrIndex = 1:1:$Length(pParamVal, ",") {
		Set tOneVal = $Piece(pParamVal, ",", tOrIndex)
		Set tOneValP1 = $Piece(tOneVal, "/", 1)
		Set tOneValP2 = $Piece(tOneVal, "/", 2)
		
		If (tOneValP1'="")&&(tOneValP2'="") {
			If $ListFind(searchParam.target, tOneValP1) = 0 {
				// If the search param value specifies a reference resource type
				// that does not apply to this search param, return an error.
				$$$ThrowFHIR($$$HSFHIRErrInvalidReferenceType, pParamName, tOneValP1, $LTS(searchParam.target),$$$OutcomeInvalid(400))
			} 
			If tOneValP1=pReferenceResourceType {
				// If the search param value specifies a reference resource type
				// that matches the specified reference resource type, then add
				// piece 2 of the search param value to the returned values.
				// Don't duplicate a reference id in the string to return.
				If (","_tReturnVals_",")'[(","_tOneValP2_",") {
					If tReturnVals'="" Set tReturnVals = tReturnVals_","
					Set tReturnVals = tReturnVals_tOneValP2
				}
			}
			
		} ElseIf tOneValP1'="" {
			If ($ListFind(searchParam.target, tOneValP1) > 0)||((pParamName="patient")&&(pReferenceResourceType="Patient")) {
				// If there is only one piece to this reference type search param
				// value, and the only reference resource type on this search
				// param is the specified reference resource type, then add that
				// value to the returned values.
				// Don't duplicate a reference id in the list to return.
				If (","_tReturnVals_",")'[(","_tOneValP1_",") {
					If tReturnVals'="" Set tReturnVals = tReturnVals_","
					Set tReturnVals = tReturnVals_tOneValP1
				}
			}
		}
	}
	
	Quit tReturnVals
}

Method GetReferencePaths(pType As %String) As %String
{
	if $D(..referencePaths(pType), pathsList) = 0 {
		Set pathsList = ""
		Do ..BuildReferencePaths(pType, "", .pathsList)
		if $LL(pathsList) '= 0 {
			Set ..referencePaths(pType) = pathsList
		}
	}
	return pathsList
}

Method BuildReferencePaths(pType As %String, pCurPath As %String, ByRef pPathsList) [ Private ]
{
	Set propName = ""
	for { 
		Set propName = $$$NextPropertyNameInType(., pType, propName)
		Quit:propName=""
		Continue:propName="extension"
		Continue:propName="modifierExtension"
		
		if $$$GetPropertyJsonType(., pType, propName)="o" {
			Set curPath = pCurPath_$lb(propName, $Select($$$IsPropertyArray(., pType, propName)=1:1, 1:0))
			Set tFHIRType = $$$GetPropertyFHIRType(., pType, propName)
			if tFHIRType ="Reference" {
				Set $List(pPathsList, *+1) = curPath
			} elseif pType '= tFHIRType {
				Do ..BuildReferencePaths(tFHIRType, curPath, .pPathsList)
			}
		}
	}
}

ClassMethod LoadJSONFromFile(pPath As %String)
{
	Set stream=##class(%Stream.FileCharacter).%New()
	$$$ThrowOnError(stream.LinkToFile(pPath))
	Set json = ##class(%DynamicObject).%FromJSON(stream)
	set stream = ""
	Quit json
}

ClassMethod LoadJSONFromXData(pXname As %String)
{
	set tXDataObj = ##class(%Dictionary.XDataDefinition).%OpenId(pXname, .tSC)
	$$$ThrowOnError(tSC)
	// Copy the JSON Stream to the output
	Quit ##class(%DynamicObject).%FromJSON(tXDataObj.Data)

	/* File-based version
		Set stream=##class(%Stream.FileCharacter).%New()
		$$$ThrowOnError(stream.LinkToFile(pPath))
		Set json = ##class(%DynamicObject).%FromJSON(stream)
		set stream = ""
		Quit json
		
	*/
}

ClassMethod arrayToList(array As %DynamicArray) As %String
{
	Set list = ""

	Set iter = array.%GetIterator()
	while iter.%GetNext(.ss, .val) {
		Set $List(list, *+1) = val
	}
	Return list
}

/// @API 
/// Returns a $List of compartments containing the specified resource
Method BuildCompartmentList(pResourceObj As %DynamicObject) As %String
{
	return ..GetCompartmentsForResource(pResourceObj)
}

Method GetValueSetCardinality(pResourceType As %String, pExpressionList As %CacheString) As %Integer
{
	Set lastIndex = $ListLength(pExpressionList)
	Set doFunctionExists = 0
	Set doFunctionIs = 0
	Set lastProp = $ListGet(pExpressionList, lastIndex)
	if lastProp = "exists()" {
		set lastIndex = lastIndex-1
	} elseif ($extract(lastProp,1,3) = "is(") {
		set lastIndex = lastIndex-1
	}
	//set typeInfoGlobal=$$$FSMetaTypeInfoGlobal(..%FHIRMetadataSetKey)
	//FSMetaTypeInfoGlobal
	set type=pResourceType
	for index=1:1:lastIndex {
		Set propName = $ListGet(pExpressionList, index)
		set dt=$$$GetPropertyFHIRType($this, type,propName)
		set previousType = type
		set type =dt
		if type="" quit 
	}
	if type="" quit -1
	if '$$$IsPropertyValueSet(.,previousType,propName) {
		quit -1
	}
	set count = 0
	set idx=""
	for {
		set idx=$$$NextValueInPropertyValueSet(.,previousType,propName,idx)
		quit:idx=""
		set count = count+1
	}
	quit count
}

}
