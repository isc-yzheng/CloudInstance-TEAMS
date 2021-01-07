Include %occErrors

Class HS.REST.Adaptor Extends %RegisteredObject [ Abstract, DependsOn = HS.REST.AdaptorHelper, PropertyClass = HS.REST.JSONProps ]
{

/// Converts this object to a %DynamicObject and returns the %DynamicObject. <br />
/// The following rules are used for the conversion: <br /> <br />
/// 
/// - Data type: Direct set of the json field, with the json name and type mapped appropriately 
/// from the object name and type. <br />
/// - Single JSON object: Direct set of the json field, with the json name mapped appropriately
/// from the object name. <br />
/// - Single Object: Set the json field to the output of a recursive call on this object, with 
/// the json name mapped appropriately from the object name.  <br />
/// - List (of data types): Create a %DynamicArray. Insert each list element into it as would be
/// done for a single data type property. Set the json field to the %DynamicArray. <br />
/// - List (of JSON objects): create a %DynamicArray. Insert each list element into it as would be 
/// done for a single JSON object property. Set the json field to the %DynamicArray. <br />
/// - List (of objects): create a %DynamicArray. Insert each list element into it as would be done
/// for a single object property. Set the json field to the %DynamicArray.  <br />
/// - Array (of data types): create a %DynamicObject. Insert each array value into it as would be 
/// done for single data type property, using the array key as the name of a field in the 
/// %DynamicObject. Set the json field to the %DynamicObject. <br />
/// - Array (of JSON objects): create a %DynamicObject. Insert each array value into it as would be
/// done for single JSON object property, using the array key as the name of a field in the
/// %DynamicObject. Set the json field to the %DynamicObject. <br />
/// - Array (of objects): create a %DynamicObject. Insert each array value into it as would be done
/// for single object property, using the array key as the name of a field in the %DynamicObject.
/// Set the json field to the %DynamicObject.  <br />
/// NOTE: Properties not converted: Multi-dimensional, private properties, if property parameter
/// JSON = 0. <br />
/// @API.Method
Method %ToJSON() As %DynamicObject [ CodeMode = objectgenerator, Final, ForceGenerate ]
{
	#define Generate(%s) Do %code.WriteLine(%s)
	Set tBaseClassDef = %compiledclass
	Quit:(tBaseClassDef.Abstract) $$$OK
	
	$$$Generate("	Set tJson = ##class(%Library.DynamicObject).%New()")
	For ord=1:1:tBaseClassDef.Properties.Count() {
		#dim tPropDef As %PropertyDefinition = tBaseClassDef.Properties.GetAt(ord)
		
		Set tObjRealPropName = tPropDef.Name
		// Quote any name containing an underscore
		Set tObjPropName = $Select(tObjRealPropName["_":$$$QUOTE(tObjRealPropName), 1:tObjRealPropName)
		Set tObjPropType = tPropDef.Type
		Set tJsonPropName = ##class(HS.REST.AdaptorHelper).GetJSONName(tObjRealPropName, tPropDef.Parameters.GetAt("JSONName"))
		Set tJsonPropType = ##class(HS.REST.AdaptorHelper).GetJSONType(tObjPropType, tPropDef.Parameters.GetAt("JSONType"))
		
		// Skip multi-dimensional, private and %Concurrency
		Continue:(tPropDef.MultiDimensional || tPropDef.Private || (tObjPropName = "%Concurrency"))
		
		// If property is meant to be JSON serialized
		If (tJsonPropName '= "") && tPropDef.Parameters.GetAt("JSON") {
			// if property is a collection
			If tPropDef.Collection '= "" {
				If tPropDef.Collection = "list" {
					$$$Generate("	Set tJsonList = ##class(%Library.DynamicArray).%New()")
					$$$Generate("	Set tKey = """"")
					$$$Generate("	While 1 {")
					$$$Generate("		Set tValue = .."_tObjPropName_".GetNext(.tKey)")
					$$$Generate("		Quit:(tKey = """")")
					If tJsonPropType = "" {
						$$$Generate("		Do tJsonList.%Push(tValue.%ToJSON())")
					} Else {
						If tJsonPropType = "json" {
							$$$Generate("		Do tJsonList.%Push(tValue)")
						} Else {
							$$$Generate("		Do tJsonList.%Push(tValue, "_$$$QUOTE(tJsonPropType)_")")
						}
					}
					$$$Generate("	}")
					$$$Generate("	Do tJson.%Set("_$$$QUOTE(tJsonPropName)_", tJsonList)")
				} ElseIf tPropDef.Collection = "array" {
					$$$Generate("	Set tJsonArray = ##class(%Library.DynamicObject).%New()")
					$$$Generate("	Set tKey = """"")
					$$$Generate("	While 1 {")
					$$$Generate("		Set tValue = .."_tObjPropName_".GetNext(.tKey)")
					$$$Generate("		Quit:(tKey = """")")
					If tJsonPropType = "" {
						$$$Generate("		Do tJsonArray.%Set(tKey, tValue.%ToJSON())")
					} Else {
						If tJsonPropType = "json" {
							$$$Generate("		Do tJsonArray.%Set(tKey, tValue)")
						} Else {
							$$$Generate("		Do tJsonArray.%Set(tKey, tValue, "_$$$QUOTE(tJsonPropType)_")")
						}
					}
					$$$Generate("	}")
					$$$Generate("	Do tJson.%Set("_$$$QUOTE(tJsonPropName)_", tJsonArray)")
				} Else {
					$$$ThrowStatus($$$ERROR($$$NotImplemented))
				}				
			}
			// if property is scalar
			Else {
				If tJsonPropType = "" {
					// child non-JSON object, instatiate from JSON
					$$$Generate("	If '$IsObject(.."_tObjPropName_") {")
					$$$Generate("		Set .."_tObjPropName_" = ##class("_tObjPropType_").%New()")
					$$$Generate("	}")
					$$$Generate("	Do tJson.%Set("_$$$QUOTE(tJsonPropName)_", .."_tObjPropName_".%ToJSON())")
				} Else {
					If tJsonPropType = "json" {
						// if json, do not provide type
						$$$Generate("	Do tJson.%Set("_$$$QUOTE(tJsonPropName)_", .."_tObjPropName_")")
					} Else {
						// direct copy with type provided
						$$$Generate("	Do tJson.%Set("_$$$QUOTE(tJsonPropName)_", .."_tObjPropName_", "_$$$QUOTE(tJsonPropType)_")")
					}
				}
			}
		}
	}
	$$$Generate("	Quit tJson")
}

/// Copies the property values from the <var>pJson</var> %DynamicObject into this object. <br />
/// The following rules are used for the copy: <br /> <br />
/// 
/// - Data type/Single JSON object: Direct set of the caller's property to the json field. <br />
/// - Single Object: Recursive call on the caller's property, passing in the equivalent json field
/// as an argument. <br />
/// - List (of data types/JSON objects): Iterate over the json field, inserting sub-fields into the
/// caller's list property as would be done for a single data type/JSON object property. <br />
/// - List (of objects): Iterate over the json field, inserting sub-fields into the caller's list 
/// property as would be done for a single object property. <br />
/// - Array (of data types): Iterate over the json field, inserting sub-field values into the 
/// caller's array property as would be done for a single data type/JSON object property value, 
/// using the sub-field name as the array key. <br />
/// - Array (of objects): Iterate over the json field, inserting sub-field values into the 
/// caller's array property as would be done for a single object property, using the sub-field name
/// as the array key. <br />
/// NOTE: Properties not converted: multi-dimensional, private properties, if property parameter
/// JSON = 0. <br />
/// @API.Method
/// @Argument	pJson				the %DynamicObject from which to copy contents
Method %FromJSON(pJson As %DynamicObject) [ CodeMode = objectgenerator, Final, ForceGenerate ]
{
	#define Generate(%s) Do %code.WriteLine(%s)
	Set tBaseClassDef = %compiledclass
	Quit:(tBaseClassDef.Abstract) $$$OK

	For ord=1:1:tBaseClassDef.Properties.Count() {
		#dim tPropDef As %PropertyDefinition = tBaseClassDef.Properties.GetAt(ord)
		
		Set tObjRealPropName = tPropDef.Name
		// Quote any name containing an underscore
		Set tObjPropName = $Select(tObjRealPropName["_":$$$QUOTE(tObjRealPropName), 1:tObjRealPropName)
		Set tObjPropType = tPropDef.Type
		Set tJsonPropName = ##class(HS.REST.AdaptorHelper).GetJSONName(tObjRealPropName, tPropDef.Parameters.GetAt("JSONName"))
		Set tJsonPropType = ##class(HS.REST.AdaptorHelper).GetJSONType(tObjPropType, tPropDef.Parameters.GetAt("JSONType"))

		// Skip multi-dimensional, private and %Concurrency
		Continue:(tPropDef.MultiDimensional || tPropDef.Private || (tObjPropName = "%Concurrency"))
		
		// If property is meant to be JSON serialized
		If (tJsonPropName '= "") && tPropDef.Parameters.GetAt("JSON") {
			// if property is a collection
			If tPropDef.Collection '= "" {
				If tPropDef.Collection = "list" {
					$$$Generate("	Set tJsonChildList = pJson.%Get("_$$$QUOTE(tJsonPropName)_")")
					$$$Generate("	Set tIter = tJsonChildList.%GetIterator()")
					$$$Generate("	While tIter.%GetNext(.key, .value) {")
					If tJsonPropType = "" {
						$$$Generate("		If $IsObject(value) {")
						$$$Generate("			Set tObj = ##class("_tObjPropType_").%New()")
						$$$Generate("			Do tObj.%FromJSON(value)")
						$$$Generate("			Do .."_tObjPropName_".Insert(tObj)")
						$$$Generate("		} Else {")
						$$$Generate("			Do .."_tObjPropName_".Insert(value)")
						$$$Generate("		}")
					} Else {
						$$$Generate("		Do .."_tObjPropName_".Insert(value)")
					}
					$$$Generate("	}")
				} ElseIf tPropDef.Collection = "array" {
					$$$Generate("	Set tJsonChildArray = pJson.%Get("_$$$QUOTE(tJsonPropName)_")")
					$$$Generate("	Set tIter = tJsonChildArray.%GetIterator()")
					$$$Generate("	While tIter.%GetNext(.key, .value) {")
					If tJsonPropType = "" {
						$$$Generate("		If $IsObject(value) {")
						$$$Generate("			Set tObj = ##class("_tObjPropType_").%New()")
						$$$Generate("			Do tObj.%FromJSON(value)")
						$$$Generate("			Do .."_tObjPropName_".SetAt(tObj, key)")
						$$$Generate("		} Else {")
						$$$Generate("			Do .."_tObjPropName_".SetAt(value, key)")
						$$$Generate("		}")
					} Else {
						$$$Generate("		Do .."_tObjPropName_".SetAt(value, key)")
					}
					$$$Generate("	}")
				} Else {
					$$$ThrowStatus($$$ERROR($$$NotImplemented))
				}				
			}
			// if property is scalar
			Else {
				If tJsonPropType = "" {
					// child non-JSON object, instatiate from JSON
					$$$Generate("	Set tJsonChild = pJson.%Get("_$$$QUOTE(tJsonPropName)_")")
					$$$Generate("	If tJsonChild '= """" {")
					$$$Generate("		If '$IsObject(.."_tObjPropName_") {")
					$$$Generate("			Set .."_tObjPropName_" = ##class("_tObjPropType_").%New()")
					$$$Generate("		}")
					$$$Generate("		Do .."_tObjPropName_".%FromJSON(tJsonChild)")
					$$$Generate("	} Else {")
					$$$Generate("		Set .."_tObjPropName_" = """" ")
					$$$Generate("	}")
				} Else {
					// direct copy
					$$$Generate("	Set .."_tObjPropName_" = pJson.%Get("_$$$QUOTE(tJsonPropName)_")")
				}
			}
		}
	}
}

/// Checks for changes to properties between <var>pOldObj</var> and <var>pNewObj</var>.
/// Returns 1 if changes found and 0 otherwise. <br />
/// The following rules are used for to check for equality: <br /> <br />
/// 
/// - Data type: Direct equality check using equality operator. <br />
/// - Single JSON Object: Convert both objects to JSON strings and check equality. <br />
/// - Single Object: Recursive call to this function. <br />
/// - Collection (of data types): Check for equal count in both collections. Check equality of
/// elements with the same key using equality operator. <br />
/// - Collection (of objects): Check for equal count in both collections. Check equality of 
/// elements with the same key using by recursive calls to this function. <br />
/// NOTE: Properties ignored when checking for equality: multi-dimensional, private, read-only
/// if property parameter JSON = 0 <br />
/// @API.Method
/// @Argument	pOldObj				First object of comparison
/// @Argument	pNewObj				Second object of comparison
ClassMethod %ChangesToObject(pOldObj As HS.REST.Adaptor, pNewObj As HS.REST.Adaptor) As %Boolean [ CodeMode = objectgenerator, Final, ForceGenerate ]
{
	Set tBaseClassDef = %compiledclass
	Quit:(tBaseClassDef.Abstract) $$$OK
	#define Generate(%s) Do %code.WriteLine(%s)

	// Objects must be of the same class
	$$$Generate("	If $ClassName(pOldObj) '= $ClassName(pNewObj) {")
	$$$Generate("		$$$ThrowStatus($$$ERROR($$$GeneralError, ""Both objects must be of the same class""))")
	$$$Generate("	}")
	$$$Generate("	Set tHasChanges = 0")
	
	Set tJsonTypesList = $ListBuild("%Library.DynamicObject", "%Library.DynamicArray", "%Library.DynamicAbstractObject")
	For ord=1:1:tBaseClassDef.Properties.Count() {
		#dim tPropDef As %PropertyDefinition = tBaseClassDef.Properties.GetAt(ord)
		Set tObjPropName = tPropDef.Name
		Set tObjPropType = tPropDef.Type
		Set:tObjPropName["_" tObjPropName = $$$QUOTE(tObjPropName)
		
		// Skip multi-dimensional, read-only and private. Skip properties marked with JSON = 0
		Continue:(tPropDef.MultiDimensional || tPropDef.ReadOnly || tPropDef.Private || 'tPropDef.Parameters.GetAt("JSON"))
		
		$$$Generate("	Set tOldPropVal = pOldObj."_tObjPropName_", tNewPropVal = pNewObj."_tObjPropName)
		If tPropDef.Collection '= "" {
			$$$Generate("	// Check if collection count is different")
			$$$Generate("	Set tHasChanges = tHasChanges || (tOldPropVal.Count() '= tNewPropVal.Count())")
			$$$Generate("	// If no changes recorded yet, then check for changes")
			$$$Generate("	If 'tHasChanges {")
			$$$Generate("		Set tOldKey = """"")
			$$$Generate("		While 1 {")
			$$$Generate("			Set tOldValue = tOldPropVal.GetNext(.tOldKey)")
			$$$Generate("			Quit:(tOldKey = """")")
			$$$Generate("			Set tNewKey = """"")
			// Set flag to ensure at least one key is matched
			$$$Generate("			Set tFoundKey = 0")
			$$$Generate("			While 1 {")
			$$$Generate("				Set tNewValue = tNewPropVal.GetNext(.tNewKey)")
			$$$Generate("				Quit:(tNewKey = """")")
			$$$Generate("				// Only check for equality if key matches")
			$$$Generate("				Continue:(tOldKey '= tNewKey)")
			// If we make it past the continue, then a key has matched
			$$$Generate("				Set tFoundKey = 1")
			If $$$comClassKeyGet(tObjPropType, $$$cCLASSclasstype) = $$$cCLASSCLASSTYPEDATATYPE {
				// Check equality using equality operator
				$$$Generate("				Set tHasChanges = tHasChanges || (tOldValue '= tNewValue)")
			} ElseIf $ListFind(tJsonTypesList, $$$NormalizeClassname(tObjPropType)) {
				// Convert JSON objects to strings and compare
				$$$Generate("				Set tHasChanges = tHasChanges || (tOldValue.%ToJSON() '= tNewValue.%ToJSON())")
			} Else {
				// If both properties are objects, call that property's %ChangesToObject method
				// If neither is an object, then no changes. Else changes must have occurred
				$$$Generate("				If $IsObject(tOldValue) && $IsObject(tNewValue) {")
				$$$Generate("					Set tChildHasChanges = ##class("_tObjPropType_").%ChangesToObject(tOldValue, tNewValue)")
				$$$Generate("				} ElseIf '$IsObject(tOldValue) && '$IsObject(tNewValue) {")
				$$$Generate("					Set tChildHasChanges = 0")
				$$$Generate("				} Else {")
				$$$Generate("					Set tChildHasChanges = 1")
				$$$Generate("				}")
				$$$Generate("				Set tHasChanges = tHasChanges || tChildHasChanges")
			}
			$$$Generate("				Quit:tHasChanges")
			$$$Generate("			}")
			$$$Generate("			If 'tFoundKey {")
			$$$Generate("				Set tHasChanges = 1")
			$$$Generate("			}")
			$$$Generate("			Quit:tHasChanges")
			$$$Generate("		}")
			$$$Generate("	}")
		} Else {
			If $$$comClassKeyGet(tObjPropType, $$$cCLASSclasstype) = $$$cCLASSCLASSTYPEDATATYPE {
				// Check equality using equality operator
				$$$Generate("	Set tHasChanges = tHasChanges || (tOldPropVal '= tNewPropVal)")
			} ElseIf $ListFind(tJsonTypesList, $$$NormalizeClassname(tObjPropType)) {
				// Convert JSON objects to strings and compare
				$$$Generate("	Set tHasChanges = tHasChanges || (tOldPropVal.%ToJSON() '= tNewPropVal.%ToJSON())")
			} Else {
				// If both properties are objects, call that property's %ChangesToObject method
				// If neither is an object, then no changes. Else changes must have occurred
				$$$Generate("	If $IsObject(tOldPropVal) && $IsObject(tNewPropVal) {")
				$$$Generate("		Set tChildHasChanges = ##class("_tObjPropType_").%ChangesToObject(tOldPropVal, tNewPropVal)")
				$$$Generate("	} ElseIf '$IsObject(tOldPropVal) && '$IsObject(tNewPropVal) {")
				$$$Generate("		Set tChildHasChanges = 0")
				$$$Generate("	} Else {")
				$$$Generate("		Set tChildHasChanges = 1")
				$$$Generate("	}")
				$$$Generate("	Set tHasChanges = tHasChanges || tChildHasChanges")
			}
		}
		// immediately quit if changes have been recorded
		$$$Generate("	Quit:tHasChanges 1")
	}
	// End of function reached which means no changes recorded
	$$$Generate("	Quit 0")
}

}
