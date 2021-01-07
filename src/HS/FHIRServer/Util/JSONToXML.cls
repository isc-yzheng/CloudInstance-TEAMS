Include HS.FHIRServer

Class HS.FHIRServer.Util.JSONToXML [ Abstract ]
{

Parameter DEBUG As %Boolean = 0;

/// API
/// JSONToXML takes  FHIR JSON as either a %DynamicObject, a %Stream.Object or %String and
/// converts it to XML writing an %Stream provided in the call to %New()
/// This method needs a class package to be designated as the root of the data model classes to
/// use during this transform. Indent character(s) and line terminator character(s) for the XML
/// output are optional.<br>
/// <br>
/// Input:<br>
/// <li>pJSONInput          : Input FHIR JSON as either a %DynamicObject, a %Stream.Object or %String.
///                           The latter two forms will be converted into a %DynamicObject before conversion
/// <li>pOutputStream       : FHIR XML stream !passed ByRef!. If this object is not passed in then this method 
///                           initializes it as a %Stream.TmpCharacter.
/// <li>pSchema             : The FHIR Schema used to guide the conversion
/// <li>pIndentString       : (optional) Indent character(s) to use for each line in the XML output.
/// <li>pLineTerminator     : (optional) Line terminator character(s) to use for the XML output.
ClassMethod JSONToXML(pJSONInput, ByRef pOutputStream As %Stream.Object, pSchema As HS.FHIRServer.Schema, pIndentString As %String = "", pLineTerminator As %String = "")
{
	// Ensure that there is an Output stream
	If '$IsObject($Get(pOutputStream)) {
		Set pOutputStream = ##class(%Stream.TmpCharacter).%New()
	} elseif 'pOutputStream.%IsA("%Stream.Object") {
		$$$ThrowStatus($$$ERROR($$$GeneralError,"XML input not specified - must be a string or a %Stream.Object"))
	} 

	// Validate and Convert (if necessary) our input to a %DynamicObject
	Set jsonObject = ..EnsureDynamicObject(pJSONInput)
	
	// Kick off the conversion
	Set resourceType = jsonObject.resourceType
	If resourceType="" {
		$$$ThrowStatus($$$ERROR($$$GeneralError, "resourceType not found at top level of JSON object"))
	}
	
	Set %schema = pSchema
	Set %perfBuffer = ""
	Set %maxSize = 10000
	Set %indentString = pIndentString
	Set %lineEnd = pLineTerminator
	Set %outStream = pOutputStream
	// Special Prefix to indicate top level to the EmitXMLObject method
	Set prefix = $C(1)
	Do ..EmitXMLObject(resourceType, jsonObject, resourceType, prefix)
	$$$ThrowOnError(%outStream.Write(%perfBuffer) )
	
	kill %schema
	kill %outStream
	kill %indentString
	kill %lineEnd
	kill %perfBuffer
	kill %maxSize
}

ClassMethod EnsureDynamicObject(pJSONInput) As %DynamicObject
{
	If pJSONInput.%IsA("%Library.DynamicObject") {
		Set jsonObject = pJSONInput
	} else {
		Set jsonObject = ##class(%DynamicObject).%FromJSON(pJSONInput)
		If '$IsObject($Get(jsonObject)) {
			$$$ThrowStatus($$$ERROR($$$GeneralError, "Could not create object from FHIR JSON string"))
		}
		if ' jsonObject.%IsA("%Library.DynamicObject") {
			$$$ThrowStatus($$$ERROR($$$GeneralError,"JSON input must be a %DynamicObject"))
		}
	}
	Quit jsonObject
}

ClassMethod EmitXMLObject(pPropName As %String, jsonObject As %DynamicObject, elementType As %String, prefix As %String)
{
	#def1arg DBG(%str) w:..#DEBUG %str,!
	#define Emit(%str) Do %outStream.Write(emitPrefix_%str_%lineEnd)
	#define Emit(%str) Set %perfBuffer=%perfBuffer_emitPrefix_%str_%lineEnd ##Continue
			if ($Length(%perfBuffer) >= %maxSize) { Do %outStream.Write(%perfBuffer)  Set %perfBuffer="" }
			
	Set curPrefix = prefix
	if prefix=$C(1) {
		Set curPrefix = ""
		Set tagName = elementType
		Set tagStart = ("<"_elementType_" xmlns=""http://hl7.org/fhir""")
	} else {
		$$$DBG("Object of "_elementType_" named "_pPropName,", ")
		Set tagName = pPropName
		Set tagStart = ("<"_pPropName)
	}
	Set emitPrefix = curPrefix
	Set nextPrefix = curPrefix _ %indentString
	
	// Now Iterate through the possible fields in the object
	if ' $$$IsDatatypeDefined(%schema, elementType) {
		$$$ThrowStatus($$$ERROR($$$GeneralError, "Unknown Element Name '"_elementType_"'"))
	}
	// Add attributes to opening tag
	Set attrName = ""
	for {
		Set attrName = $$$NextXMLAttrProperty(%schema, elementType, attrName)
		Quit:attrName=""

		Set attrValue = jsonObject.%Get(attrName)
		if attrValue '="" {
			Set tagStart = tagStart _ (" "_attrName_"="""_attrValue_"""")
		}	
	}
	$$$Emit(tagStart _ ">")
	
	$$$DBG("Et: ",elementType)	
	if elementType = "Resource" {
		// NOTE: This could be generalized by noting that ResourceContainer is a 'union'
		// However, it is the only union in the schema so this is quicker for now.
		Set elementType = jsonObject.resourceType
		$$$DBG("  Really Object of "_elementType_" named "_pPropName,", ")
		Do ..EmitXMLObject(elementType, jsonObject, elementType, nextPrefix)
		$$$Emit("</"_pPropName_">")
		Quit
	}
	
	Set propNameList = $$$GetPropertyNameList(%schema, elementType)
	Set propNameCount = $LL(propNameList)
	for propIter=1:1:propNameCount {
		Set propName = $ListGet(propNameList, propIter)
		If $$$IsPropertyXMLAttr(%schema, elementType, propName) {
			// Don't emit attributes as value tags, they've already been
			// added to the containing tag
			Continue
		}
		$$$DBG("propName: ",propName)
		
		// Get the property value ... don't emit empty properties (shouldn't be any in the JSON either)
		Set propValue = jsonObject.%Get(propName)
		If propValue="" Continue
		$$$DBG("propValue ",propValue)

		// Get the JSON Type of the property
		// o = Object, s=String, n=Number, b=Boolean, x=XML-DIV (special string), c=Choice (type based on name)			
		Set propJsonType = $$$GetPropertyJsonType(%schema, elementType, propName)
		Set propElementType = $$$GetPropertyFHIRType(%schema, elementType, propName)

		Set propExtension = jsonObject.%Get("_"_propName)
		Set extensionObj=""

		#dim isArrayProperty as %Boolean = $$$IsPropertyArray(%schema, elementType, propName)
		if isArrayProperty {
			if jsonObject.%GetTypeOf(propName) '= "array" {
				$$$ThrowFHIR($$$HSFHIRErrNotAnArray, elementType, propName, "")
			}
			Set loopLast = propValue.%Size() - 1
		} else {
			if jsonObject.%GetTypeOf(propName) = "array" {
				$$$ThrowFHIR($$$HSFHIRErrUnexpectedArray, elementType, propName, "")
			}
			Set loopLast = 0
		}
		// Process all property values
		for ord=0:1:loopLast {
			// Get the next value from an array OR the only scalar value
			Set elementValue = $Select(isArrayProperty:propValue.%Get(ord), 1:propValue)
			if propExtension'="" {
				Set extensionObj = $Select(isArrayProperty:propExtension.%Get(ord), 1:propExtension)
			}
			// Not an object - process the primitive types
			Set emitPrefix = nextPrefix
			$$$DBG("jt:",propJsonType)
			if propJsonType="alias" {
				Do ..EmitXMLObject(propName, elementValue, propElementType, nextPrefix)
			} elseif propJsonType="o" {
				// This is an object, Recurse to emit its properties
				Do ..EmitXMLObject(propName, elementValue, propElementType, nextPrefix)
			} elseif propJsonType = "x" {
				$$$Emit(elementValue)
			} else {

				// Determine the value string based on type ...
				Set outputValue = $Case(propJsonType, "s":$ZConvert(elementValue,"O","XML"), "b":$Case(elementValue, "0":"false", "1":"true", "true":"true", "false":"false", :"false"), "n":elementValue)
				$$$DBG("Property of type "_propElementType_" named "_propName, " with value: ",outputValue)
				
				// Check for a Primitive Extension
				If extensionObj="" {
					// Assume that tData has a value if there is no id or extension data.
					$$$Emit("<"_propName_" value="""_outputValue_""""_"/>")
				} Else {
					Set tPropTag = "<"_propName
					If extensionObj.id'="" Set tPropTag = tPropTag_" id="""_extensionObj.id_""""
					If outputValue'="" Set tPropTag = tPropTag_" value="""_outputValue_""""
					Set extensionElements = extensionObj.extension
					If extensionElements="" {
						$$$Emit(tPropTag_"/>")
					} Else {
						$$$Emit(tPropTag_">")
						Set sz = extensionElements.%Size()
						for extOrd=0:1:sz-1 {
							Set extensionElement = extensionElements.%Get(extOrd)
							if extensionElement '= "" {
								Do ..EmitXMLObject("extension", extensionElement, "Extension", nextPrefix_%indentString)
							}
						}
						$$$Emit("</"_propName_">")
					}
				}
			}
			Set emitPrefix = curPrefix
		}
	}
	$$$Emit("</"_tagName_">")
}

}
