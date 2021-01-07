Include HS.FHIRMeta

Class HS.FHIRMeta.Impl.TypeInfo Extends Base
{

/// API
/// IsValidResourceType validates the specified resource type against this Schema, returning a %Boolean
/// <br>
/// Input:<br>
/// <li>pResourceType       : (required) FHIR resource type.
/// <br><br>
/// Output:<br>
/// Return: a %Boolean - 0 = Is not a valid resource type as per the specified schema, 1 = Is valid.
Method IsValidResourceType(pResourceType As %String) As %Boolean
{
	return ..IsA(pResourceType, "Resource")
}

/// API
/// IsSharedResourceType Indicates whether a resourceType is or can reference a Patient
/// <br>
/// Input:<br>
/// <li>pResourceType       : (required) FHIR resource type.
/// <br><br>
/// Return: a %Boolean - 1 if shared (no patient references), 0 if unshared
Method IsSharedResourceType(pResourceType As %String)
{
	// TODO: Right now it is "not in patient compartment"
	return '($$$IsTypeInCompartment(., "patient", pResourceType) || (pResourceType = "Patient"))
}

Method IsA(pTypeName As %String, pAncestorName As %String)
{
	Set type = pTypeName
	for {
		if type = pAncestorName {
			return 1
		}
		Set type = $Get($$$GetSuperclass(., type))
		if type = "" {
			return 0
		}
	}
}

Method initTypeInfo() [ Internal ]
{
}

/// @API 
/// Returns a $List of compartments containing the specified resource
Method GetCompartmentsForResource(pResourceObj As %DynamicObject) As %List
{
	Set resourceType = pResourceObj.resourceType
	Set compartmentList = ""
	
	Set compartmentName = ""
	for {
		$$$NextCompartment(.,compartmentName)
		Quit:(compartmentName="")
		
		Set containsResource = $$$IsTypeInCompartment(.,compartmentName,resourceType)
		Continue:('containsResource)

		Set compartmentType = $ZConvert($E(compartmentName),"U") _ $E(compartmentName,2,*) _ "/"
		Set prefixLen = $length(compartmentType)
		
		Set paramName = ""
		for {
			$$$NextParamNameInCompartment(.,compartmentName,resourceType,paramName)
			Quit:(paramName="")

			#dim searchParam as HS.FHIRServer.SearchParam = ..FindSearchParam(resourceType, paramName)
			Continue:searchParam=""
			
			//w "Get for ",searchParam.name,", expression: ",$lts(searchParam.expression),!
			Set tree = ..FHIRPathAPI.parse(searchParam.fhirPath)
			Do ..FHIRPathAPI.evaluate(pResourceObj, tree, .values)
			if values>0 {
				// References are scalars, but nevertheless ...
				for ord=1:1:values {
					if values(ord,"t") = "Reference" {
						Set refValue = values(ord).reference
					} elseif values(ord,"t") = "canonical" {
						Set refValue = values(ord)
					} else {
						/// This indicates invalid FHIR Metadata
						$$$ThrowError($$$GeneralError, "Compartment Parameters must be type Reference: "_resourceType_"?"_paramName)
					}
					if $E(refValue,1,prefixLen) = compartmentType {
						Set $List(compartmentList,*+1) = refValue	
					}
				}
			}
		}
		
	}
	return compartmentList
}

}
