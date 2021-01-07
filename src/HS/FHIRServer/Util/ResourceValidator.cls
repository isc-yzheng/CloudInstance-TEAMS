Include HS.FHIRServer

Class HS.FHIRServer.Util.ResourceValidator Extends HS.FHIRServer.API.ResourceValidator
{

Property matchers As array Of %Regex.Matcher;

Property schema As HS.FHIRServer.Schema;

Method %OnNew(pSchema As HS.FHIRServer.Schema) As %Status
{
	if '$IsObject(pSchema) || 'pSchema.%IsA("HS.FHIRServer.Schema") {
		$$$ThrowFHIR($$$HSFHIRErrAPIContractViolation, "pSchema")
	}
	Set ..schema = pSchema
	Set ..matchers = ##class(%ArrayOfObjects).%New()
	Return $$$OK
}

ClassMethod Test(s, path As %String = "C:\Users\aepstein\dev\fhir-meta\testfiles\fhir-sample-bad-stu3.json")
{
	Set %FHIRValidateVerbose = 0
	if $IsObject(path) && path.%IsA("%DynamicObject") {
		Set json = path
	} else {
		Set:(+path=1) path = "C:\Users\aepstein\dev\fhir-meta\testfiles\fhir-sample-bad-stu3.json"
		Set:(+path=2) path = "C:\Users\aepstein\dev\fhir-meta\testfiles\fhir-sample-stu3.json"
		Set:(+path=3) path = "C:\Users\aepstein\dev\fhir-meta\testfiles\stu3_bundle.json"
		w "Validating File: "_path,!
		Set json = ##class(%DynamicObject).%FromJSON(path)
	}
	Set obj = ..%New(s)
	Try {
		Do obj.ValidateResource(json)
		w "Success!",!
	} catch tEx {
		Set tsc = tEx.AsStatus()
		set json = ##class(HS.FHIRServer.Util.Outcome).CreateFromStatus(tsc)
		w $$$FormatJSON(json),!
	}
	kill %FHIRValidateVerbose
	if 0 {
		Merge data = $$$TypeInfoCache(obj.Schema)
		zw data
	}
}

/// @API
/// ValidateResource validates a FHIR Resource.  If a validation error is found, a
/// compound %Status is thrown in a StatusException.  The compound %Status starts with a
/// $$$ValidationFailure code, followed by additional %Status objects for each detected
/// validation error.
/// Inputs:
/// <li>pJsonResource           : (required) %DynamicObject representation of the FHIR resource.
/// <li>Throws					: A StatusException containing a compound %Status representing all
///                             : validation errors.
Method ValidateResource(pResourceObject As %DynamicObject)
{
	if '$IsObject(pResourceObject) || 'pResourceObject.%IsA("%DynamicObject") {
		$$$ThrowFHIR($$$HSFHIRErrAPIContractViolation, "pResourceObject")
	}

	Set resourceType = pResourceObject.resourceType
	//w:%FHIRValidateVerbose "Validating Resource Type ", resourceType,!
	
	if (resourceType="") || '..schema.IsValidResourceType(resourceType) {
		$$$ThrowFHIR($$$ERROR($$$HSFHIRErrResourceTypeUnknown, resourceType))
		//$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrResourceTypeUnknown, pResourceObject.resourceType, $$$OutcomeIs(400, "error", "invalid")))
	}
	Set tSC = ..ValidateObject(pResourceObject, resourceType, resourceType, $$$OK)
	If ($$$ISERR(tSC)) {
		Set rootsc = $$$ERROR($$$HSFHIRErrValidationFailure, $$$OutcomeIs(400, "error", "invalid"))
		$$$FHIRAddError(rootsc, tSC)
		$$$ThrowStatus(rootsc)
	}
}

/// This internal method validates the properties of a single class in the FHIR Schema.  If the class contains
/// properties that are objects, then this call is recursed with the sub-object(s)
/// Inputs:<br>
/// pFHIRObject      : The JSON object to validate. <br>
/// pFHIRTypename      : The classname in the FHIR Schema.<br>
/// pPath            : A FHIR-path representation to the object begin verified<br>
/// pStati           : The accumulated status from previous validations.  This invocation will append
///                    the details of any validation failures found.<br>
/// Returns:         : An updated status with any additional validation errors included.
Method ValidateObject(pFHIRObject As %Library.DynamicObject, pFHIRTypename As %String, pPath As %String, pStati As %Status) [ Internal ]
{
	//w:%FHIRValidateVerbose "Validating Type ", pFHIRTypename, " at ",pPath,!
	// w "Enter for ",pFHIRTypename,!
	Set tSC = pStati

	// Loop through all the properties in the object
	Do {
		// [DEV NOTE]
		// The 'usage' object is used to identify conflicting property names for value types
		// It is also used to ensure that extensions are properly handled.  When a property is
		// encountered, its index is used to indicate its presence, and its property name is saved.
		//   usage(ix) = propName
		// All value types for a single property (e.g. valueInteger, valueBoolean, etc) have the same
		// index.  This allows us to detect duplicate value specifications within the JSON.
		//
		// For extension properties, we flag their presence by
		//  usage("ext", propName) =  "done" (when processed) | "found" when encountered and not processed
		// This entry is removed when the property being extended is encountered.  At the end, any remaining
		// entries are validated without the corresponding property having to be present (no value present
		// but id or extension info is)
		kill usage
		
		// Iterate through the object's properties
		Set tIterator = pFHIRObject.%GetIterator()
		While tIterator.%GetNext(.tPropName, .tData) {
			if tData="" {
				$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrEmptyValue, pFHIRTypename, tPropName, $$$OutcomeInvalidPath(pPath)))
				Continue
			}
			
			// Handle 'resourceType' specially ... it is not a field in the XML schema (which uses the tag)
			if (tPropName="resourceType") && ..schema.IsValidResourceType(pFHIRTypename) {
				// Ignore 'resourceType' ONLY at the resource level
				Continue
			}
			
			// Get the type of the Json data
			set typeInJson = pFHIRObject.%GetTypeOf(tPropName)
			
			// Check for a primitive extension
			if $Extract(tPropName,1)="_" {
				Set propExtnName = tPropName
				Set tPropName = $E(tPropName,2,*)
				Set extnTypeInJson = typeInJson
				Set typeInJson = pFHIRObject.%GetTypeOf(tPropName)

				if typeInJson '= "unassigned" {
					// The corresponding property exists, we will handle this extension when
					// we encounter it
					Continue
				}
				Set extensionData = tData
				Set tData = pFHIRObject.%Get(tPropName)
				if extensionData = "" {
					// A Primitive extension cannot be an empty string (or null)
					$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrEmptyValue, pFHIRTypename, propExtnName, $$$OutcomeInvalidPath(pPath)))
					Continue
				}
			} else {
				Set propExtnName = "_"_tPropName
				Set extensionData = pFHIRObject.%Get(propExtnName)
				Set extnTypeInJson = pFHIRObject.%GetTypeOf(propExtnName)
			}
			
			
			If ' $$$IsPropertyDefined(..schema, pFHIRTypename, tPropName) {
				$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrUnexpectedPropertyName, pFHIRTypename, tPropName, $$$OutcomeInvalidPath(pPath)))
				Continue
			}
			Set jt =  $$$GetPropertyJsonType(..schema, pFHIRTypename, tPropName)
			Set dt =  $$$GetPropertyFHIRType(..schema, pFHIRTypename, tPropName)
			Set ix =  $$$GetPropertyIndex(..schema, pFHIRTypename, tPropName)
			Set arr = $$$IsPropertyArray(..schema, pFHIRTypename, tPropName)
			Set propertyIsObject = (jt = "o") || (jt = "alias")
			//w tPropName,":", jt,"|",dt,"|",ix,"|",arr,!
			
			// Primitive Extension is not valid for an object property, treat it as an invalid property name
			if propertyIsObject && (extensionData '= "") {
				$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrUnexpectedPropertyName, pFHIRTypename, propExtnName, $$$OutcomeInvalidPath(pPath)))
				set extensionData = ""
				// Pretend there is no extension and continue to validate the base property
			}
			
			// Check for duplicate usage (for choice properties)
			if $D(usage(ix), firstUsage)'=0 {
				$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrDuplicateValue, tPropName, firstUsage, $$$OutcomeInvalidPath(pPath)))
				Continue
			}
			// Flag the usage of this property
			Set usage(ix) = tPropName
			
			// Check for a primitive extension
			if extensionData '= "" {
				if arr '= (extnTypeInJson = "array") {
					$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrInvalidExtensionCardinality, pFHIRTypename, tPropName, $$$OutcomeInvalidPath(pPath)))
					// Error reported; Now ignore the extension and enable validation of the base property and extension separately
					Set extensionData = ""
				} else {
					if arr && (tData.%Size() '= extensionData.%Size()) {
						// If arrays, the sizes must match					
						$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrInvalidExtensionArraySize, pFHIRTypename, tPropName, $$$OutcomeInvalidPath(pPath)))
						Set extensionData = ""
					}
				}
			}
			
			Set curPath = $Select(pPath="":tPropName, 1:pPath_"."_tPropName)
			// w curPath," is ",typeInJson," | ",arr,!
			if arr=1 {
				if typeInJson '= "array" {
					$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrNotAnArray, pFHIRTypename, tPropName, $$$OutcomeInvalidPath(curPath)))
					Continue
				}
				Set array = tData
				Set lastix = array.%Size()-1
				// Define this variable.  It may be set if extensionData is present
				Set extensionElement = ""
				
			} else {
				if typeInJson = "array" {
					$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrUnexpectedArray, pFHIRTypename, tPropName, $$$OutcomeInvalidPath(curPath)))
					Continue
				}
				Set array = ""
				Set lastix = 0
				// Assign this here since its once-through for scalars
				Set extensionElement = extensionData
			}
			Set propPath = curPath
			for index=0:1:lastix {
				if array'="" {
					set tData = array.%Get(index)
					Set typeInJson = array.%GetTypeOf(index)
					Set propPath = curPath_"["_index_"]"
					// Extract the corresponding extension Element
					if extensionData '= "" {
						Set extensionElement = extensionData.%Get(index)
					}
				} 
				
					
				//w propPath,":", jt,"|",dt,"|",ix,"|",arr,"|",typeInJson,!
				// Below will handle single or multiple values in the same way.
				if propertyIsObject {
					// This property is an object
					if extensionElement '= "" {
						$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrUnexpectedExtension, pFHIRTypename, tPropName, $$$OutcomeInvalidPath(propPath)))
					}
					if typeInJson '= "object" {
						$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrNotAnObject, pFHIRTypename, tPropName, $$$OutcomeInvalidPath(propPath)))
						Continue
					}
					if (dt = "Reference") {
						Set ref = tData.reference
						Set targetList = $Get($$$GetPropertyTargetList(..schema, pFHIRTypename, tPropName))
						if (ref '= "") && (targetList '= "") {
							// Create a block for easy exit
							do {
								// If a reference, validate it
								Quit:(ref = "") 
								Quit:(targetList = "")
								
								kill urlparts
								Do ##class(%Net.URLParser).Parse(ref, .urlparts)
								// For now, don't validate a full URL
								Quit:(urlparts("scheme") '= "")
								// For now, don't validate an absolute URL or an internal reference
								Set path = urlparts("path")
								Quit:($E(path) = "/")
								Quit:(urlparts("fragment")'="")
								
								Set resourceType = $Piece(path,"/",1)
								Set id = $Piece(path,"/",2)
								Set shouldBeEmpty = $Piece(path,"/",3)
								
								if (id = "") || (shouldBeEmpty '= "") {
									$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrMalformedRelativeReference, ref, tPropName, pFHIRTypename, $$$OutcomeInvalidPath(propPath) ))
								} else {
									// Check the resourceType against each entry in the target list
									Set ok = 0
									for itl=1:1:$LL(targetList) {
										Set target = $ListGet(targetList,itl)
										if ..schema.IsA(resourceType, target) {
											// If it matches or is a Subclass, then accept it.
											set ok=1
											quit
										}
									}
									if 'ok {
										$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrInvalidReferenceTarget, resourceType_"::"_ref, tPropName, pFHIRTypename, $LTS(targetList), $$$OutcomeInvalidPath(propPath) ))
									}
								}
								
							} while 0
						}
					}
					
					// The type of this object is specified in the Schema.  If the schema says 'alias'
					// it means that the type is ResourceContainer, so the type is the object's resourceType
					Set ot = $Select(jt="alias": tData.resourceType, 1:dt)
					Set tSC = ..ValidateObject(tData, ot, propPath, tSC)
					Continue
					
				} 
				
				// This property is a primitive, so make sure that the JSON doesn't hold an object
				if (typeInJson = "object") {
					$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrUnexpectedObject, pFHIRTypename, tPropName, $$$OutcomeInvalidPath(propPath)))
					Continue
				}
				
				if extensionElement '= "" {
					// A primitive Extension exists, validate it	
					Set tSC = ..ValidateObject(extensionElement, "Element", propPath, tSC)
				}
				
				// Now process the various primitive types
				if jt="n" {
					Set expectedTypeInJson="number"
				} elseif jt="s" {
					Set expectedTypeInJson="string"
				} elseif jt="b" {
					Set expectedTypeInJson="boolean"
				} elseif jt="x" {
					// XML Div
					Set expectedTypeInJson="string"
				}
				Set noPropertyValue = (typeInJson = "unassigned") || (typeInJson = "null")
				// It is an error if the property is of the wrong type ... unless the property is missing and there is an extension
				if (typeInJson '= expectedTypeInJson) && ( (extensionData ="") || 'noPropertyValue) {
					// The property type in the provided JSON is not correct.
					$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrWrongJsonType, pFHIRTypename, tPropName, typeInJson, expectedTypeInJson, $$$OutcomeInvalidPath(propPath)))
				}
				
				// Now validate the value of the property
				if (noPropertyValue) {
					// If the value is missing, we know its ok because there is an extension, so we're done.
					Continue
				}
				
				Set propType = $$$GetPropertyFHIRType(..schema, pFHIRTypename, tPropName)
				if jt = "b" {
					// No more checking for boolean, if the parser saw true/false then the typeInJson would be correct, otherwise wrong.
				} elseif propType = "positiveInt" {
					if (tData <= 0) || (tData > 2147483647) || ((tData\1) '= tData)  {
						$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrInvalidNumber, pFHIRTypename, tPropName, tData, propType, $$$OutcomeInvalidPath(propPath)))
					}
				} elseif propType = "unsignedInt" {
					if (tData < 0) || (tData > 2147483647) || ((tData\1) '= tData)  {
						$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrInvalidNumber, pFHIRTypename, tPropName, tData, propType, $$$OutcomeInvalidPath(propPath)))
					}
				} elseif propType = "integer" {
					if (tData < -2147483648) || (tData > 2147483647) || ((tData\1) '= tData)  {
						$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrInvalidNumber, pFHIRTypename, tPropName, tData, propType, $$$OutcomeInvalidPath(propPath)))
					}
				} elseif propType = "decimal" {
					// No validation for decimals.  If it was numeric, its OK.
				} else {
					
					Set patternStr = $$$GetRegexForPrimitive(..schema, propType)
					if patternStr '= "" {
					
						Set matcher = ..matchers.GetAt(patternStr)
						if matcher="" {
							// Hack to work around a bad (sub-optimal) Regex in the R3 schema
							Set usePatternStr = $Select(patternStr="[^\s]+([\s]?[^\s]+)*":"[^\s]+(\s[^\s]+)*", 1:patternStr)
							// w "Adding Matcher for: "_patternStr, " / ", (usePatternStr=patternStr),!
							Set matcher = ##class(%Regex.Matcher).%New(usePatternStr)
							Do ..matchers.SetAt(matcher, patternStr)					
						}
						// Check the value against a regular expression	
						if 'matcher.Match(tData) {
							$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrMalformedValue, pFHIRTypename, tPropName, tData, propType, patternStr, $$$OutcomeInvalidPath(propPath)))
						}
						
					}
					
					if $$$IsPropertyValueSet(..schema, pFHIRTypename, tPropName) {
						// There is an enumerated set of allowed values.  Verify.
						if ' $$$IsPropertyValueInSet(..schema, pFHIRTypename, tPropName, tData) {
							// Build a list of valid values
							Set list = ""
							Set name = ""
							for { 
								Set name = $$$NextValueInPropertyValueSet(..schema, pFHIRTypename, tPropName, name)
								Quit:name=""
								Set list = list _ $select($length(list)=0: name, 1: ","_name)
							}
							$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrValueNotInEnumeration, pFHIRTypename, tPropName, tData, list, $$$OutcomeInvalidPath(propPath)))
							
						}
					}
				}
			}
		} 
	} while 0 // End of one-time-through block
	
	// Verify the presence of all required fields
	Set tPropName = ""
	for {
		Set tPropName = $$$NextRequiredProperty(..schema, pFHIRTypename, tPropName)
		Quit:tPropName=""
		// See if any of the variants of this property was present		
		Set ix = $$$GetPropertyIndex(..schema, pFHIRTypename, tPropName)
		if $Data(usage(ix))=0 {
			$$$FHIRAddError(tSC, $$$ERROR($$$HSFHIRErrMissingRequiredProperty, pFHIRTypename, tPropName, pPath_"."_tPropName))
		}
	}
		
	Return tSC
}

}
