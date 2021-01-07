Class HS.FHIR.Validation.ResourceValidator Extends %RegisteredObject
{

/// ValidateResource validates a given FHIR resource stream, string, %XML.Document object or
/// %DynamicObject against a specified schema.  If both a stream/string and an object are passed
/// in, the object is used. Streams/strings and objects that are passed in are not updated by
/// this method. If an object is not passed in, one is formulated from the stream/string, and
/// the object is available for the caller to receive back and re-use for other purposes if
/// desired. If validation errors are incurred, the return status is set to a fail status and
/// the validation errors are returned in an <class>HS.Types.FHIR.Errors object</class>.<br>
/// Inputs:
/// <li>pContentType            : (required if pResourceObject not provided) May be the ContentType from
///                               a FHIR request, or even just "json" or "xml".
/// <li>pResourceStreamOrString : (required if pResourceObject not provided) FHIR XML resource stream
///                               object or string.
/// <li>pResourceSchema         : Class package to use as the schema. Example is "HS.FHIR.vSTU3.Model.Resource".
/// <li>pResourceObject         : (required if pResourceStreamOrString not provided) %XML.Document object,
///                               %XML.Node object, or %DynamicObject representation of the FHIR resource.
/// <br>Outputs:<br>
/// <li>pResourceObject         : %XML.Document object or %DynamicObject representation of the FHIR resource.
/// <li>pErrors                 : <class>HS.Types.FHIR.Errors</class> object that includes a collection of
///                               error information.
ClassMethod ValidateResource(pContentType As %String = "", pResourceStreamOrString = "", pResourceSchema As %String, ByRef pResourceObject = "", ByRef pErrors As HS.Types.FHIR.Errors) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If '$IsObject($Get(pErrors)) Set pErrors = ##class(HS.Types.FHIR.Errors).%New()
		
		If (pResourceStreamOrString="")&&('$IsObject(pResourceObject)) {
			Set tSC = $$$ERROR($$$GeneralError,"FHIR input not specified")
			Quit
		}
		
		If $Get(pResourceSchema)="" {
			Set tSC = $$$ERROR($$$GeneralError,"Resource schema not specified")
			Quit
		}
		
		// If the %XML.Document object, %XML.Node object or %DynamicObject was not passed in,
		// then create it from the string or stream input.
		If '$IsObject(pResourceObject) {
			If pContentType="" {
				Set tSC = $$$ERROR($$$GeneralError, "Content type not specified")
			} ElseIf '(($ZConvert(pContentType,"L")["json")||($ZConvert(pContentType,"L")["xml")) {
				Set tSC = $$$ERROR($$$GeneralError, "Invalid content type '"_pContentType_"' specified")
			}
			If $$$ISERR(tSC) Quit
			If '$IsObject(pResourceStreamOrString) {
				Set tStream = ##class(%Stream.TmpCharacter).%New()
				Set tSC = tStream.Write(pResourceStreamOrString)
				If $$$ISERR(tSC) Quit
				Do tStream.Rewind()
			} Else {
				Set tStream = pResourceStreamOrString
			}
			Set tSC = ##class(HS.FHIR.Utils).CreateResourceObject(pContentType, tStream, .pResourceObject)
			If $$$ISERR(tSC) Quit
		}
		
		If pResourceObject.%IsA("%Library.DynamicObject") {
			Set tSC = ..ValidateDynamicObj(pResourceObject, pResourceSchema, .pErrors)
		} Else {
			Set tSC = ..ValidateXMLDocument(pResourceObject, pResourceSchema, .pErrors)
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// ValidateDynamicObj validates a given FHIR resource %DynamicObject against a specified schema.
/// If validation errors are incurred, the return status is set to a failure status and the
/// validation errors are returned in an HS.Types.FHIR.Errors object.<br>
/// Inputs:
/// <li>pJSONDynamicObject : (required) FHIR resource %DynamicObject.
/// <li>pResourceSchema    : (required) Class package to use as the schema. Example is "HS.FHIR.vSTU3.Model.Resource".
/// <br>Output:<br>
/// <li>pErrors            : HS.Types.FHIR.Errors object that includes a collection of error information.
///                          See <class>HS.Types.FHIR.Errors</class> for more details.<br>
ClassMethod ValidateDynamicObj(pJSONDynamicObject As %Library.DynamicObject, pResourceSchema As %String, ByRef pErrors As HS.Types.FHIR.Errors) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If '$IsObject($Get(pErrors)) Set pErrors = ##class(HS.Types.FHIR.Errors).%New()
		
		// Schema validation might get called consecutively after some other validation
		// that has already begun populating the pErrors collection. Note the initial error
		// count and check the count again at method end.
		Set tInitialErrorCount = pErrors.Errors.Count()
		
		If $Get(pResourceSchema)="" {
			Set tSC = $$$ERROR($$$GeneralError,"Resource schema not specified")
			Quit
		}
		
		If ('$IsObject($Get(pJSONDynamicObject)))||('pJSONDynamicObject.%IsA("%Library.DynamicObject")) {
			Set tSC = $$$ERROR($$$GeneralError,"Invalid JSON input - must be a %DynamicObject")
			Quit
		}
		
		Set tResourceType = pJSONDynamicObject.%Get("resourceType")
		If tResourceType="" {
			Do pErrors.logError("structure", "error", "resourceType not found at top level of JSON object", "f:")
			Quit
		}
		
		Set tResourceTypeClassName = pResourceSchema_"."_tResourceType
		
		If $$$defClassDefined(tResourceTypeClassName)=0 {
			Do pErrors.logError("invalid", "error", "Invalid resource type", "f:"_tResourceType)
			Quit
		}
		
		Set tSC = ..ValidateDynamicObj2(pJSONDynamicObject, tResourceTypeClassName, "f:"_tResourceType, .pErrors)
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	If ($$$ISOK(tSC))&&(pErrors.Errors.Count()>tInitialErrorCount) {
		Set tSC = $$$ERROR($$$GeneralError, "Resource failed schema validation")
	}
	
	Quit tSC
}

ClassMethod ValidateDynamicObj2(pJSONObject As %Library.DynamicObject, pHSFHIRClassName As %String, pPath As %String, ByRef pErrors As HS.Types.FHIR.Errors) [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		// Store the property information into %propsByName, indexed by property name.
		If $Data(%propsByName(pHSFHIRClassName))=0 Do ##class(HS.FHIR.Utils).GetPropInfo(pHSFHIRClassName)
		
		Set tPropName = "@"
		For {
			Set tPropName = $Order(%propsByName(pHSFHIRClassName, tPropName))
			If tPropName="" Quit
			If tPropName="Datatype" Continue
			If %propsByName(pHSFHIRClassName, tPropName,"Required") {
				Set tRequiredProps(tPropName)=""
			}
		}
		
		Set tIterator = pJSONObject.%GetIterator()
		
		Set tPropName = ""
		For {
			If 'tIterator.%GetNext(.tPropName, .tData) Quit
			If tPropName="" Quit
			
			// tPropName is the current property name.
			// tData can be:
			// - String value
			// - Boolean value
			// - Numeric value
			// - %Library.DynamicArray object reference
			// - %Library.DynamicObject object reference
			
			// resourceType is only used by the code calling this method, to determine the type of
			// FHIR resource (if any) that this object is.
			// fhir_comments is for the FHIR JSON equivalent of XML comments, which we want to ignore.
			If (tPropName="resourceType")||(tPropName="fhir_comments") Continue
			
			// extensions and ids will already have been processed earlier along with their
			// associated standard property.
			If $Extract(tPropName)="_" Continue
			
			If $Data(%propsByName(pHSFHIRClassName, tPropName))=0 {
				Do pErrors.logError("invalid", "error", "Invalid property '"_tPropName_"' found in "_pHSFHIRClassName_" object", pPath)
				Continue
			}
			
			Set tPropType = %propsByName(pHSFHIRClassName, tPropName, "Type")
			If tData="" Continue
			
			// Make a note of the object reference for the extension data, if any, for the
			// current property.
			Set tExtData = pJSONObject.%Get("_"_tPropName)
			
			Kill tExtensionCollArray
			Kill tPropIdArray
			Set tExtensionColl = ""
			
			// div is not an object and not extendable.
			If tPropName="div" {
				Kill tRequiredProps(tPropName)
				Set tCurrentPath = pPath_"/h:div"
				Set tValid = $ClassMethod(pHSFHIRClassName, "divIsValid", tData)
				If $$$ISERR(tValid) {
					Do pErrors.logError("value", "error", $system.Status.GetErrorText(tValid), tCurrentPath)
				}
				Continue
			}
			// Properties whose type ends in "Primitive" are not objects and not extendable.
			If $Extract(tPropType, *-8, *)="Primitive" {
				Kill tRequiredProps(tPropName)
				Set tCurrentPath = pPath_"/@"_tPropName
				Set tValid = $ClassMethod(pHSFHIRClassName, tPropName_"IsValid", tData)
				If $$$ISERR(tValid) {
					Do pErrors.logError("value", "error", $system.Status.GetErrorText(tValid), tCurrentPath)
				}
				Continue
			}
			
			If '$IsObject(tData) {
				// This is a primitive FHIR object type such as String, Code, etc.
				// Check for extension and/or id on this item first, and build
				// collection of extensions if necessary.
				
				Set tCurrentPath = pPath_"/f:"_tPropName
				
				If %propsByName(pHSFHIRClassName, tPropName, "Collection") {
					Do pErrors.logError("invalid", "error", pHSFHIRClassName_" property '"_tPropName_"' is serialized as singleton but is defined as a collection", tCurrentPath)
				}
				
				Set tPropId = ""
				If tExtData'="" {
					Kill tRequiredProps(tPropName)
					// Because this is not an array, the extension will be an object, not an array.
					Set tPropId = tExtData.%Get("id")
					If tExtData.%Get("extension")'="" {
						// Find the class definition for extension, then use it.
						If $Data(%propsByName(tPropType))=0 Do ##class(HS.FHIR.Utils).GetPropInfo(tPropType)
						Set tExtensionSchema = %propsByName(tPropType, "extension", "Type")
						Do ..ValidateDynamicObjExt(tExtData, .tExtensionColl, tExtensionSchema, tCurrentPath, .pErrors)
					}
				}
				If tData'="" {
					Kill tRequiredProps(tPropName)
					Set tValid = $ClassMethod(tPropType, "valueIsValid", tData)
					If $$$ISERR(tValid) {
						Do pErrors.logError("value", "error", $system.Status.GetErrorText(tValid), tCurrentPath_"/@value")
					}
				}
				If tPropId'="" {
					Set tValid = $ClassMethod(tPropType, "idIsValid", tPropId)
					If $$$ISERR(tValid) {
						Do pErrors.logError("value", "error", $system.Status.GetErrorText(tValid), tCurrentPath_"/@value")
					}
				}
			} ElseIf tData.%IsA("%Library.DynamicObject") {
				If %propsByName(pHSFHIRClassName, tPropName, "Collection") {
					Set tCurrentPath = pPath_"/f:"_tPropName
					Do pErrors.logError("invalid", "error", pHSFHIRClassName_" property '"_tPropName_"' is serialized as singleton but is defined as a collection", tCurrentPath)
				}
				// This is a %DynamicObject. Verify whether is ResourceContaner, and
				// make the recursive call.
				If $Extract(tPropType,*-16,*)'="ResourceContainer" {
					Set tTempPropType = tPropType
					Set tCurrentPath = pPath_"/f:"_tPropName
				} Else {
					// Special case: If type is ResourceContainer then the class
					// should be the resource type indicated in the JSON array.
					Set tResourceType = tData.%Get("resourceType")
					If $Data(%propsByName(tPropType))=0 Do ##class(HS.FHIR.Utils).GetPropInfo(tPropType)
					Set tResourcePropType = %propsByName(tPropType, tResourceType, "Type")
					Set tCurrentPath = pPath_"/f:resource/f:"_tResourceType
					Set tTempPropType = tResourcePropType
				}
				Kill tRequiredProps(tPropName)
				Set tSC = ..ValidateDynamicObj2(tData, tTempPropType, tCurrentPath, .pErrors)
				If $$$ISERR(tSC) Quit
			} Else {
				// This is a %DynamicArray of objects or primitive object types.
				// First, loop through any counterpart extension objects for this array.
				// For each extension object and id found in the JSON, generate the
				// extension object and put it in a local array, and do the same for any
				// id values.  This array of extension object references and id values
				// will then be used when looping through the array of standard objects
				// and values.
				If '%propsByName(pHSFHIRClassName, tPropName, "Collection") {
					Set tCurrentPath = pPath_"/f:"_tPropName
					Do pErrors.logError("invalid", "error", pHSFHIRClassName_" property '"_tPropName_"' is serialized as collection but is not defined as a collection", tCurrentPath)
				}
				If tExtData'="" {
					Kill tRequiredProps(tPropName)
					Set tIterator2 = tExtData.%GetIterator()
					Set tPropName2 = ""
					For {
						If 'tIterator2.%GetNext(.tPropName2, .tData2) Quit
						If tPropName2="" Quit
						// Empty tData2 here means there is "null" in the JSON array element.
						If tData2="" Continue
						If tData2.%Get("id")'="" Set tPropIdArray(tPropName2) = tData2.%Get("id")
						If tData2.%Get("extension")'="" {
							// Find the class definition for extension, then use it.
							If $Data(%propsByName(tPropType))=0 Do ##class(HS.FHIR.Utils).GetPropInfo(tPropType)
							Set tExtensionSchema = %propsByName(tPropType, "extension", "Type")
							Do ..ValidateDynamicObjExt(tData2, .tExtensionColl, tExtensionSchema, tCurrentPath, .pErrors)
							Set tExtensionCollArray(tPropName2) = tExtensionColl
							Kill tExtensionColl
						}
					}
					Kill tIterator2
				}
				// Loop through the array elements.
				Set tIterator2 = tData.%GetIterator()
				Set tPropName2 = ""
				Set tArrayCount = 0
				For {
					If 'tIterator2.%GetNext(.tPropName2, .tData2) Quit
					If tPropName2="" Quit
					// This condition should never ever happen, but noting it anyway.
					If (tData2="")&&('$Data(tExtensionCollArray(tPropName2))) Continue
					Kill tRequiredProps(tPropName)
					If $i(tArrayCount)
					// If tData2 is blank after this point, it means that the property
					// has no standard property value but has some extension data. 
					If ($IsObject(tData2))&&(tData2.%IsA("%Library.DynamicObject")) {
						// This is a %DynamicObject. Verify whether is ResourceContaner, and
						// make the recursive call.
						If $Extract(tPropType,*-16,*)'="ResourceContainer" {
							Set tCurrentPath = pPath_"/f:"_tPropName_"["_tArrayCount_"]"
							Set tTempPropType = tPropType
						} Else {
							Set tResourceType = tData2.%Get("resourceType")
							If $Data(%propsByName(tPropType))=0 Do ##class(HS.FHIR.Utils).GetPropInfo(tPropType)
							Set tResourcePropType = %propsByName(tPropType, tResourceType, "Type")
							Set tCurrentPath = pPath_"/f:resource/f:"_tResourceType
							Set tTempPropType = tResourcePropType
						}
						Set tSC = ..ValidateDynamicObj2(tData2, tTempPropType, tCurrentPath, .pErrors)
						If $$$ISERR(tSC) Quit
					} ElseIf '$IsObject(tData2) {
						Set tCurrentPath = pPath_"/f:"_tPropName_"["_tArrayCount_"]"
						// This is a primitive FHIR object type such as String, Code, etc.
						// Check for extension and/or id that may have been noted on this item
						// earlier, and include them when validating the property.
						Set tExtensionColl = $Get(tExtensionCollArray(tPropName2))
						Set tPropId = $Get(tPropIdArray(tPropName2))
						If tData2'="" {
							Kill tRequiredProps(tPropName)
							Set tValid = $ClassMethod(tPropType, "valueIsValid", tData2)
							If $$$ISERR(tValid) {
								Do pErrors.logError("value", "error", $system.Status.GetErrorText(tValid), tCurrentPath_"/@value")
							}
						}
						If tPropId'="" {
							Set tValid = $ClassMethod(tPropType, "idIsValid", tPropId)
							If $$$ISERR(tValid) {
								Do pErrors.logError("value", "error", $system.Status.GetErrorText(tValid), tCurrentPath_"/@id")
							}
						}
						If $$$ISERR(tSC) Quit
						Continue
					} Else {
						// This is an array.  Unlikely that this situation exists at all.
					}
				}
			}
		}
		
		// If there are required properties that we did not encounter, then report them.
		If $Data(tRequiredProps) {
			Set tMissingProps = ""
			Set tCount = 0
			Set tPropName = ""
			For {
				Set tPropName = $Order(tRequiredProps(tPropName))
				If tPropName="" Quit
				If $i(tCount)
				If tMissingProps'="" {
					If $Order(tRequiredProps(tPropName))="" {
						Set tMissingProps = tMissingProps_" and "
					} Else {
						Set tMissingProps = tMissingProps_", "
					}
				}
				Set tMissingProps = tMissingProps_"'"_tPropName_"'"
			}
			Set tFirstMissing = $Order(tRequiredProps(""))
			Do pErrors.logError("required", "error", "Required "_pHSFHIRClassName_" "_$Select(tCount>1:"properties",1:"property")_" "_tMissingProps_" missing", pPath)
		}
		
	} Catch ex {
		// Code 148 (METHOD DOES NOT EXIST) on *IsValid method name indicates
		// a data type mismatch in the resource object (e.g., someone put a
		// string value in a %DynamicObject where there should be an object
		// or a collection). Trap and add it to the errors collection.
		If (ex.Code=148)&&($Extract($Piece(ex.Data,",",1),*-6,*)="IsValid") {
			Do pErrors.logError("value", "error", "Resource data has incorrect data type for "_$Get(tPropType)_" property '"_$Get(tPropName)_"'", $Get(tCurrentPath))
			Set tSC = $$$OK
		} Else {
			Set tSC = ex.AsStatus()
		}
	}
	
	Quit tSC
}

ClassMethod ValidateDynamicObjExt(pJSONObject As %Library.DynamicObject, ByRef pExtensionColl, pExtensionClass As %String, pPath, ByRef pErrors As HS.Types.FHIR.Errors) [ Internal ]
{
	Set pExtensionColl = ##class(%Library.ListOfObjects).%New()
	Set tIterator = pJSONObject.%Get("extension").%GetIterator()
	Set tCurrentPath = pPath_"/f:extension"
	Set tPropName = ""
	For {
		If 'tIterator.%GetNext(.tPropName, .tData) Quit
		If tPropName="" Quit
		If tData'="" Set tSC = ..ValidateDynamicObj2(tData, pExtensionClass, tCurrentPath, .pErrors)
		If $$$ISERR(tSC) Quit
	}
	Quit
}

/// ValidateXMLDocument validates a given FHIR resource %XML.Document or %XML.Node object against
/// a specified schema. If validation errors are incurred, the return status is set to a failure
/// status and the validation errors are returned in an HS.Types.FHIR.Errors object.<br>
/// This method allows for taking a %XML.Node object as input to allow the caller to locate a
/// resource within a resource (%XML.Node within an %XML.Document) and use that inner resource as
/// the input to the validation.<br>
/// Inputs:
/// <li>pXMLDocument    : (required) FHIR resource %XML.Document or %XML.Node object.
/// <li>pResourceSchema : (required) Class package to use as the schema. Example is "HS.FHIR.vSTU3.Model.Resource".
/// <br>Output:<br>
/// <li>pErrors         : HS.Types.FHIR.Errors object that includes a collection of error information.
///                       See <class>HS.Types.FHIR.Errors</class> for more details.<br>
ClassMethod ValidateXMLDocument(pXMLDocument, pResourceSchema As %String, ByRef pErrors As HS.Types.FHIR.Errors) As %Status
{
	Set tSC = $$$OK
	
	#dim tNode As %XML.Node
	
	Try {
		If '$IsObject($Get(pErrors)) Set pErrors = ##class(HS.Types.FHIR.Errors).%New()
		
		// Schema validation might get called consecutively after some other validation
		// that has already begun populating the pErrors collection. Note the initial error
		// count and check the count again at method end.
		Set tInitialErrorCount = pErrors.Errors.Count()
		
		Set tErrorText = ""
		
		If $Get(pResourceSchema)="" {
			Set tErrorText = "Resource schema not specified"
		} ElseIf ('$IsObject($Get(pXMLDocument))) {
			Set tErrorText = "XML input not specified"
		} ElseIf pXMLDocument.%IsA("%XML.Document") {
			Set tNode = pXMLDocument.GetDocumentElement()
		} ElseIf pXMLDocument.%IsA("%XML.Node") {
			Set tNode = pXMLDocument
		} Else {
			Set tErrorText = "Invalid XML input - must be an %XML.Document object or %XML.Node object"
		}
		If tErrorText'="" Set tSC = $$$ERROR($$$GeneralError, tErrorText) Quit
		
		Set tResourceType = tNode.LocalName
		
		If tResourceType="" {
			Do pErrors.logError("structure", "error", "Top level FHIR resource type not found", "f:")
			Quit
		}
		
		If tNode.Namespace'="http://hl7.org/fhir" {
			Do pErrors.logError("structure", "error", "FHIR namespace not found on resource", "f:"_tResourceType)
		}
		
		Set tResourceTypeClassName = pResourceSchema_"."_tResourceType
		
		If $$$defClassDefined(tResourceTypeClassName)=0 {
			Do pErrors.logError("invalid", "error", "Invalid resource type", "f:"_tResourceType)
			Quit
		}
		
		Set tSC = ..ValidateXMLDocument2(tNode, tResourceTypeClassName, "f:"_tResourceType, .pErrors)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	If ($$$ISOK(tSC))&&(pErrors.Errors.Count()>tInitialErrorCount) {
		Set tSC = $$$ERROR($$$GeneralError, "Resource failed schema validation")
	}
	
	Quit tSC
}

ClassMethod ValidateXMLDocument2(pNode As %XML.Node, ByRef pHSFHIRClassName As %String, pPath As %String, ByRef pErrors As HS.Types.FHIR.Errors) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		Set tHSFHIRClassNameU = $ZConvert(pHSFHIRClassName,"U")
		
		// Store the property information into %propsByName, indexed by property name.
		If $Data(%propsByName(pHSFHIRClassName))=0 Do ##class(HS.FHIR.Utils).GetPropInfo(pHSFHIRClassName)
		
		Set tPropName = ""
		For {
			Set tPropName = $Order(%propsByName(pHSFHIRClassName, tPropName))
			If tPropName="" Quit
			If tPropName="Datatype" Continue
			If %propsByName(pHSFHIRClassName, tPropName,"Required") {
				Set tRequiredProps(tPropName)=""
			}
		}
		
		Set tPropName = pNode.LocalName
		Set tHasChild = pNode.HasChildNodes(1)
		Set tNumAtt = pNode.GetNumberAttributes()
		
		If (tNumAtt=0)&&('tHasChild) {
			Do pErrors.logError("invalid", "error", "Invalid empty element '"_tPropName_"'", pPath)
			Quit
		}
		
		If tNumAtt>0 {
			Set tAttName = ""
			For {
				Set tAttName = pNode.NextAttributeName(tAttName)
				If tAttName="" Quit
				Set tValue = pNode.GetAttributeValue(tAttName)
				Set tValid = 1
				Set tCurrentPath = pPath_"/@value"
				Kill tRequiredProps(tPropName)
				If tValue="" {
					Set tValid = $$$ERROR($$$GeneralError,"Invalid blank "_tAttName_" attribute value")
				} ElseIf tAttName="value" {
					If $Extract(tHSFHIRClassNameU,*-7,*)=".BOOLEAN" {
						Set tValid = $Case(tValue, "0":1, "1":1, "true":1, "false":1, :0)
						If tValid=0 Set tValid = $$$ERROR($$$GeneralError,"Invalid Boolean value '"_tValue_"'")
					} Else {
						Set tValid = $ClassMethod(pHSFHIRClassName, "valueIsValid", tValue)
					}
				} ElseIf tAttName="url" {
					Set tCurrentPath = pPath_"/@url"
					Kill tRequiredProps("url")
					Set tValid = $ClassMethod(pHSFHIRClassName, "urlIsValid", tValue)
				} ElseIf tAttName="id" {
					Set tCurrentPath = pPath_"/@id"
					Kill tRequiredProps("id")
					Set tValid = $ClassMethod(pHSFHIRClassName, "idIsValid", tValue)
				}
				If $$$ISERR(tValid) {
					Do pErrors.logError("value", "error", $system.Status.GetErrorText(tValid), tCurrentPath)
				}
			}
		}
		If $$$ISERR(tSC) Quit
		
		If 'tHasChild Quit
		
		// Save the current node id so that we may re-set back to it before returning.
		Set tSaveNodeId = pNode.NodeId
		Set tBoolean = pNode.MoveToFirstChild(1)
		If 'tBoolean Quit
		
		Set tLastPropName = ""
		
		For {
			Set tPropName = pNode.LocalName
			
			If '$Data(%propsByName(pHSFHIRClassName,tPropName)) {
				Do pErrors.logError("invalid", "error", "Invalid property '"_tPropName_"' found in "_pHSFHIRClassName_" object", pPath)
				Set tBoolean = pNode.MoveToNextSibling(1)
				If 'tBoolean Quit
				Continue
			}
			
			Set tPropType = $Get(%propsByName(pHSFHIRClassName, tPropName, "Type"))
			
			If tPropName'=tLastPropName {
				Set tPropArrayCount = 1
			} Else {
				Set tPropArrayCount = tPropArrayCount + 1
			}
			
			If '%propsByName(pHSFHIRClassName, tPropName, "Collection") {
				Set tCurrentPath = pPath_"/f:"_tPropName
				If tPropArrayCount>1 {
					Do pErrors.logError("invalid", "error", pHSFHIRClassName_" property '"_tPropName_"' is serialized as collection but is not defined as a collection", tCurrentPath)
				}
			} Else {
				Set tCurrentPath = pPath_"/f:"_tPropName_"["_tPropArrayCount_"]"
			}
			
			Set tLastPropName = tPropName
			
			Set tHasChild = pNode.HasChildNodes(1)
			Set tNumAtt = pNode.GetNumberAttributes()
			If (tPropName="div") {
				Kill tRequiredProps(tPropName)
				Set tString = ""
				Set ttSC = ..FHIRXMLDivString(pNode, .tString)
				Set tBoolean = pNode.MoveToNextSibling(1)
				If 'tBoolean Quit
				Continue
			}
			
			Kill tRequiredProps(tPropName)
			
			Set tSC = ..ValidateXMLDocument2(pNode, tPropType, tCurrentPath, .pErrors)
			If $$$ISERR(tSC) Quit
			Set tBoolean = pNode.MoveToNextSibling(1)
			If tBoolean=0 Quit
			Continue
		}
		
		Set pNode.NodeId = tSaveNodeId
		
		// If there are required properties that we did not encounter, then report them.
		If $Data(tRequiredProps) {
			Set tMissingProps = ""
			Set tCount = 0
			Set tPropName = ""
			For {
				Set tPropName = $Order(tRequiredProps(tPropName))
				If tPropName="" Quit
				If $i(tCount)
				If tMissingProps'="" {
					If $Order(tRequiredProps(tPropName))="" {
						Set tMissingProps = tMissingProps_" and "
					} Else {
						Set tMissingProps = tMissingProps_", "
					}
				}
				Set tMissingProps = tMissingProps_"'"_tPropName_"'"
			}
			Set tFirstMissing = $Order(tRequiredProps(""))
			Do pErrors.logError("required", "error", "Required "_pHSFHIRClassName_" "_$Select(tCount>1:"properties",1:"property")_" "_tMissingProps_" missing", pPath)
		}
		
	} Catch ex {
		// Code 148 (METHOD DOES NOT EXIST) on *IsValid method name indicates
		// a data type mismatch in the resource object (e.g., someone put a
		// string value in a %XML.Document where there should be an object
		// or a collection). Trap and add it to the errors collection.
		If (ex.Code=148)&&($Extract($Piece(ex.Data,",",1),*-6,*)="IsValid") {
			Do pErrors.logError("value", "error", "Resource data has incorrect data type for "_$Get(pHSFHIRClassName)_" property '"_$Get(tPropName)_"'", $Get(tCurrentPath))
			Set tSC = $$$OK
		} Else {
			Set tSC = ex.AsStatus()
		}
	}
	
	Quit tSC
}

/// FHIRXMLDivString parses the div of a FHIR XML resource and builds and returns
/// a string that represents the div xhtml with whitespace preserved.
ClassMethod FHIRXMLDivString(pNode As %XML.Node, ByRef pDivString As %String) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		For {
			Set tNodeType = pNode.NodeType
			
			If tNodeType=$$$xmlELEMENTNODE {
				Set tPropName = pNode.LocalName
				Set pDivString = pDivString_"<"_tPropName
				Set tNumAtt = pNode.GetNumberAttributes()
				Set tHasChild = pNode.HasChildNodes()
				If tNumAtt>0 {
					Set tAttName = ""
					For {
						Set tAttName = pNode.NextAttributeName(tAttName)
						If tAttName="" Quit
						Set tAttValue = pNode.GetAttributeValue(tAttName)
						Set pDivString = pDivString_" "_tAttName_"="""_$ZConvert(tAttValue,"O","HTML")_""""
					}
				}
				If tHasChild {
					Set pDivString = pDivString_">"
					Set tSaveNodeId = pNode.NodeId
					Set tBoolean = pNode.MoveToFirstChild()
					Set tSC = ..FHIRXMLDivString(pNode, .pDivString)
					If $$$ISERR(tSC) Quit
					Set pNode.NodeId = tSaveNodeId
					Set pDivString = pDivString_"</"_tPropName_">"
					Set tBoolean = pNode.MoveToNextSibling()
				} Else {
					Set pDivString = pDivString_">"
					Set tBoolean = pNode.MoveToNextSibling()
				}
				If tBoolean=0 Quit
			} Else {
				// is $$$xmlTEXTNODE or $$$xmlWHITESPACENODE
				Set pDivString = pDivString_pNode.NodeData
				Set tBoolean = pNode.MoveToNextSibling()
				If tBoolean=0 Quit
			}
		}
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

/// ValidateBySchematron validates a given FHIR resource stream, string, %XML.Document object or
/// %DynamicObject against its schematron rules.  If both a stream/string and an object are passed
/// in, the object is used. Streams/strings and objects that are passed in are not updated by
/// this method. If an object is not passed in, one is formulated from the stream/string, and
/// the object is available for the caller to receive back and re-use for other purposes if
/// desired. If validation errors are incurred, the return status is set to a fail status and
/// the validation errors are returned in an <class>HS.Types.FHIR.Errors object</class>.<br>
/// Inputs:
/// <li>pContentType            : (required if pResourceObject not provided) May be the ContentType from
///                               a FHIR request, or even just "json" or "xml".
/// <li>pResourceStreamOrString : (required if pResourceObject not provided) FHIR XML resource stream
///                               object or string.
/// <li>pResourceSchema         : Class package to use as the schema. Example is "HS.FHIR.vSTU3.Model.Resource".
/// <li>pResourceObject         : (required if pResourceStreamOrString not provided) %XML.Document object
///                               or %DynamicObject representation of the FHIR resource.
/// <li>pTransformer            : XSLT2 transformer object. If one is not passed in, then one is created
///                               by this method, however, that will incur a performance cost.
/// <li>pXSLTDir                : /csp/xslt sub-directory path for the location of the schematron XSLT2
///                               stylesheet files to use.
/// <br>Outputs:<br>
/// <li>pResourceObject         : %XML.Document object or %DynamicObject representation of the FHIR resource.
/// <li>pErrors                 : <class>HS.Types.FHIR.Errors</class> object that includes a collection of
///                               error information.
ClassMethod ValidateBySchematron(pContentType As %String = "", pResourceStreamOrString = "", pResourceObject = "", pResourceSchema As %String, pResourceType As %String, pTransformer, pXSLTDir As %String, ByRef pErrors As HS.Types.FHIR.Errors) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If '$IsObject($Get(pErrors)) Set pErrors = ##class(HS.Types.FHIR.Errors).%New()
		
		If (pResourceStreamOrString="")&&('$IsObject(pResourceObject)) {
			Set tSC = $$$ERROR($$$GeneralError,"FHIR input not specified")
			Quit
		}
		
		If $Get(pResourceType)="" {
			Set tSC = $$$ERROR($$$GeneralError,"Resource type not specified")
			Quit
		}
		
		If $Get(pXSLTDir)="" {
			Set tSC = $$$ERROR($$$GeneralError,"Schematron XSLT directory not specified")
			Quit
		}
		
		If '$IsObject($Get(pTransformer)) {
			Set pTransformer = ##class(HS.Util.XSLTTransformer).%New()
			Set pTransformer.UseXSLT2 = 1
		}
		
		If (pResourceStreamOrString'="")&&('$IsObject(pResourceObject)) {
			If '$IsObject(pResourceStreamOrString) {
				Set tStream = ##class(%Stream.TmpCharacter).%New()
				Set tSC = tStream.Write(pResourceStreamOrString)
				If $$$ISERR(tSC) Quit
				Do tStream.Rewind()
			} Else {
				Set tStream = pResourceStreamOrString
			}
		}
		
		// Conversion to XML stream alternatives, ranked from best to worst:
		// - XML stream input, no conversion needed
		// - %XML.Document input, run SerializeXMLDocument
		// - %DynamicObject input, run JSONDynamicObjectToXML
		// - JSON stream input, run JSONToXML, gets turned into object first
		
		// If an object was not passed in, assume that the stream/string was.
		// If it is a string, create an XML stream from it.
		If '$IsObject(pResourceObject) {
			If pContentType="" {
				Set tSC = $$$ERROR($$$GeneralError, "Content type not specified")
			} ElseIf '(($ZConvert(pContentType,"L")["json")||($ZConvert(pContentType,"L")["xml")) {
				Set tSC = $$$ERROR($$$GeneralError, "Invalid content type '"_pContentType_"' specified")
			}
			If $$$ISERR(tSC) Quit
			If '$IsObject(pResourceStreamOrString) {
				Set tStream = ##class(%Stream.TmpCharacter).%New()
				Set tSC = tStream.Write(pResourceStreamOrString)
				If $$$ISERR(tSC) Quit
				Do tStream.Rewind()
			} Else {
				Set tStream = pResourceStreamOrString
			}
			If pContentType["json" {
				Set tSC = ##class(HS.FHIR.Utils).JSONToXML(tStream, .tXMLStream, pResourceSchema)
			} Else {
				Set tXMLStream = tStream
			}
		} Else {
			// Otherwise, if an object was passed in
			If pResourceObject.%IsA("%Library.DynamicObject") {
				// Is a %DynamicObject already created from a JSON FHIR resource.
				Set tSC = ##class(HS.FHIR.Utils).JSONDynamicObjectToXML(pResourceObject, .tXMLStream, pResourceSchema)
			} ElseIf pResourceObject.%IsA("%XML.Document") {
				// Is a %XML.Document object already created from an XML FHIR resource.
				Set tSC = ##class(HS.FHIR.Utils).SerializeXMLDocument(pResourceObject, .tXMLStream)
			} Else {
				Set tSC = $$$ERROR($$$GeneralError, "FHIR object input must be %XML.Document object or %DynamicObject")
			}
		}
		If $$$ISERR(tSC) Quit
		
		Set tSC = ..ValidateBySchematronXMLStream(pResourceType, tXMLStream, .pTransformer, pXSLTDir, .pErrors)
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// ValidateBySchematronXMLStream validates a given FHIR resource XML stream against the
/// schematron rules provided by the HL7 FHIR specification. If validation errors are
/// incurred, the return status is set to a failure status and the validation errors are
/// returned in an HS.Types.FHIR.Errors object.<br>
/// Inputs:
/// <li>pResourceType : (required) FHIR resource type.
/// <li>pXMLStream    : (required) FHIR XML stream object.
/// <li>pTransformer  : (required) Transformer object to use for the XSLT2 schematron evaluation.
/// <li>pXSLTDir      : (required) XSLT directory that holds the XSLTs that will execute the schematron
///                     validation. Example is "FHIR/vDSTU2/Schematron".
/// <br>Output:<br>
/// <li>pErrors       : HS.Types.FHIR.Errors object that includes a collection of error information.
///                     See <class>HS.Types.FHIR.Errors</class> for more details.<br>
ClassMethod ValidateBySchematronXMLStream(pResourceType As %String, pXMLStream, pTransformer, pXSLTDir As %String, ByRef pErrors As HS.Types.FHIR.Errors) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If '$IsObject($Get(pErrors)) Set pErrors = ##class(HS.Types.FHIR.Errors).%New()
		
		// Schematron validation might get called consecutively after some other validation
		// that has already begun populating the pErrors collection. Note the initial error
		// count and check the count again at method end.
		Set tInitialErrorCount = pErrors.Errors.Count()
		
		If $Get(pResourceType)="" {
			Set tSC = $$$ERROR($$$GeneralError, "Resource type not specified")
			Quit
		}
		
		If '$IsObject($Get(pXMLStream)) {
			Set tSC = $$$ERROR($$$GeneralError, "FHIR XML stream object not specified")
			Quit
		}
		
		If $Get(pXSLTDir)="" {
			Set tSC = $$$ERROR($$$GeneralError, "Schematron XSLT directory not specified")
			Quit
		}
		
		If '$IsObject($Get(pTransformer)) {
			Set pTransformer = ##class(HS.Util.XSLTTransformer).%New()
			Set pTransformer.UseXSLT2 = 1
		}
		
		If pXSLTDir["csp/xslt/" {
			Set pXSLTDir = $Piece(pXSLTDir, "csp/xslt/", 2)
		} ElseIf pXSLTDir["csp\xslt\" {
			Set pXSLTDir = $Piece(pXSLTDir, "csp\xslt\", 2)
		}
		
		If (pXSLTDir["/")&&($Extract(pXSLTDir,*)'="/") {
			Set pXSLTDir = pXSLTDir_"/"
		} ElseIf (pXSLTDir["\")&&($Extract(pXSLTDir,*)'="\") {
			Set pXSLTDir = pXSLTDir_"\"
		}
		
		Set tSC = pTransformer.Transform(pXMLStream, pXSLTDir_pResourceType_".xsl", .tResultStream)
		If $$$ISERR(tSC) Quit
		
		Do tResultStream.Rewind()
		
		Set tJSONResultObj = ##class(%Library.DynamicObject).%FromJSON(tResultStream)
		If '$IsObject(tJSONResultObj) {
			Set tSC = $$$ERROR($$$GeneralError, "Unable to create JSON object from validation result stream")
			Quit
		}
		
		Set tIterator = tJSONResultObj.result.%GetIterator()
		Set tResult = ""
		For {
			Set tResult = tIterator.%GetNext(.tResult, .tData)
			If (tResult="")||(tData="") Quit
			If tData.text="" Quit
			If tData.status=0 {
				Set tError = ##class(HS.Types.FHIR.Error).%New()
				Set tError.Severity = "error"
				Set tError.Code = "invariant"
				Set tError.DetailsText = tData.text_" (context="_tData.context_", assert="_tData.assert_")"
				Set tError.Location = tData.location
				Set tSC = pErrors.Errors.Insert(tError)
				If $$$ISERR(tSC) Quit
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	If ($$$ISOK(tSC))&&(pErrors.Errors.Count()>tInitialErrorCount) {
		Set tSC = $$$ERROR($$$GeneralError, "Resource failed schematron validation")
	}
	
	Quit tSC
}

}
