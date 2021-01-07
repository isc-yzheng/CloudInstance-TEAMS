Include (%occSAX, HS.FHIRServer)

Class HS.FHIRServer.Util.XMLToJSON [ Abstract ]
{

Parameter DEBUG As %Boolean = 0;

/// @API
/// XMLToJSON takes a XML-encoded FHIR Resource or string as input, and returns a %DynamicObject (JSON)
/// representation of the FHIR Resource
/// <br>
/// Input:<br>
/// <li>pXMLStreamOrString  : (required) XML stream object or string or an %XML.Document object representation
/// 	                          of a FHIR resource
/// <li>pSchema             : The FHIR Schema used to guide the conversion
/// <br><br>
/// Returns                 : A %DynamicObject (JSON) representation of the FHIR Resource
ClassMethod XMLToJSON(pXMLInput, pSchema As HS.FHIRServer.Schema) As %DynamicObject
{
	Set xmlDocument = ..EnsureXMLDocument(pXMLInput)
	Set tNode = xmlDocument.GetDocumentElement()
	
	Set tTopResourceName = ""
	
	If tNode.NodeType=$$$xmlELEMENTNODE {
		If tNode.Namespace'="http://hl7.org/fhir" {
			$$$ThrowStatus($$$ERROR($$$GeneralError,"FHIR namespace not found"))
		}
		Set tTopResourceName = tNode.LocalName
	}
	If tTopResourceName="" {
		$$$ThrowStatus($$$ERROR($$$GeneralError,"Top level FHIR resource name not found"))
	}
	
	set %schema = pSchema
	#dim result As %DynamicObject = ..EmitNode(tNode, tTopResourceName)
	kill %schema
		
	return result
}

/// @API
/// XMLToJSON takes a FHIR XML stream object or string as input, and returns a FHIR JSON stream.
/// This method requires a class package to be designated as the root of the data model classes
/// to use during this transform. Indent character(s) and line terminator character(s) for the
/// JSON output are optional.<br>
/// <br>
/// Input:<br>
/// <li>pXMLStreamOrString  : (required) FHIR XML stream object or string.
/// <li>pIndentString       : (optional) Indent character(s) to use for each line in the XML output.
/// <li>pLineTerminator     : (optional) Line terminator character(s) to use for the XML output.
/// <br><br>
/// Output:<br>
/// <li>pJSONStream         : FHIR JSON stream. If this object is not passed in as input then this
///                           method initializes it as %Stream.TmpCharacter.
ClassMethod XMLToJSONStream(pXMLInput, ByRef pOutputStream As %Stream.Object, pSchema As HS.FHIRServer.Schema, pIndentString As %String = "", pLineTerminator As %String = "")
{
	Set json = ..XMLToJSON(pXMLInput, pSchema)
	Do ##class(HS.FHIRServer.Util.JsonHelper).ToJSONStream(jout, .pOutputStream, pIndentString, pLineTerminator)
}

ClassMethod EnsureXMLDocument(pXMLInput) As %XML.Document [ Private ]
{
	if $Get(pXMLInput)="" {
		$$$ThrowStatus($$$ERROR($$$GeneralError,"XML input is required"))
	}
	if $IsObject(pXMLInput) {
		if pXMLInput.%IsA("%XML.Document") {
			Quit pXMLInput
		}
		if ' pXMLInput.%IsA("%Stream.Object") {
			$$$ThrowStatus($$$ERROR($$$GeneralError,"XML input object must be a %Stream or %XML.Document"))
		}
	}
	// Here its either a %Stream or a non-object
	
	Set xmlStream = ##class(HS.Util.StreamUtils).EnsureStream(pXMLInput)
	
	// This methodology is used instead of the %XML.Document GetDocumentFromStream()
	// class method because this enables us to get a %XML.Document object with the
	// KeepWhitespace property set to 0.
	Set tReader = ##class(%XML.Reader).%New()
	Set tReader.SAXFlags = $$$SAXFULLDEFAULT-$$$SAXVALIDATIONSCHEMA
	Set tReader.KeepWhitespace = 0
	$$$ThrowOnError( tReader.OpenStream(xmlStream) )
	Set pXMLDocument = tReader.Document
	If '$IsObject($Get(pXMLDocument)) {
		$$$ThrowStatus($$$ERROR($$$GeneralError, "Could not create object from FHIR XML stream"))
	}
	Quit tReader.Document
}

ClassMethod EmitNode(pNode As %XML.Node, pElementType As %String) As %DynamicObject [ Private ]
{
	#def1arg DBG(%str) w:..#DEBUG %str,!
	#define NewObject ##class(%DynamicObject).%New()
	#define NewArray ##class(%DynamicArray).%New()
	#define SetString(%obj,%prop,%value) Do %obj.%Set(%prop,%value,"string")
	#define SetBool(%obj,%prop,%value) Do %obj.%Set(%prop,%value,"boolean")
	#define SetNumber(%obj,%prop,%value) Do %obj.%Set(%prop,%value,"number")
	#define SetObject(%obj,%prop,%value) Do %obj.%Set(%prop,%value)
	#define SetNull(%obj,%prop) Do %obj.%Set(%prop,"","null")
	#define PushString(%obj,%value) Do %obj.%Push(%value,"string")
	#define PushBool(%obj,%value) Do %obj.%Push(%value,"boolean")
	#define PushNumber(%obj,%value) Do %obj.%Push(%value,"number")
	#define PushObject(%obj,%value) Do %obj.%Push(%value)
	#define PushNull(%obj) Do %obj.%Push("","null")
	
	// THis is the object being returned
	#dim resultObject as %DynamicObject = $$$NewObject

	$$$DBG("EmitNode of type: ",pElementType,": ", pNode.Serialize(.ignore))
	// Save the current node id so that we may re-set back to it before returning.
	Set savedNodeId = pNode.NodeId
	
	// Now Iterate through the possible fields in the object
	// Get the Metadata Definition for this Object Type
	Set elementType = pElementType
	
	// If it is a resource
	Set superclass = $Get($$$GetSuperclass(%schema, elementType))
	if (superclass = "DomainResource") || (superclass = "Resource")
	{
		$$$SetString(resultObject, "resourceType", pNode.LocalName)
	}
	
	// Now emit any properties that are stored in XML Attributes
	Set attrName = ""
	for {
		Set attrName = $$$NextXMLAttrProperty(%schema, elementType, attrName)	
		Quit:attrName=""
		
		Set attrValue = pNode.GetAttributeValue(attrName)
		if attrValue '="" {
			$$$SetString(resultObject, attrName, attrValue)
		}
	}

	
	// Now loop through the properties (child nodes)
	// Try to move to the first child node, quit if no child nodes.
	If 'pNode.MoveToFirstChild(1) {
		return resultObject
	}
		
	Set arrayPropName = ""
	Set propName = ""
	#dim propArray as %DynamicArray = ""
	For {
		// Determine whether this is a new property.  We need to do this because
		// in XML, we don't know the end of an array until we hit a node that has
		// a different name than the previous.
		Set isNewProp = (propName '= pNode.LocalName)
		
		if isNewProp {
			// If this property is an array, close the array
			if (arrayPropName'="") {
				// Close the active array 
				$$$DBG("Close Array: ",arrayPropName)
				Set arrayPropName = ""
				Set propArray = ""
			} 
			// Emit any primitive extensions from the previous property
			if (propName '= "") && havePrimitiveExtensions {
				Do resultObject.%Set("_" _ propName, primitiveExtensions)
			}

			// Reset for potential primitive extensions
			Set havePrimitiveExtensions = 0
			Set primitiveExtensions = []
			
			// Here we begin NEW property handling
			Set propName = pNode.LocalName
			$$$DBG("Tag: ", propName)
			
			// Make sure such a property is part of the schema
			if ' $$$IsPropertyDefined(%schema, elementType, propName) {
				$$$ThrowFHIR($$$HSFHIRErrUnexpectedPropertyName, propName, elementType, "")
			}
			// Outer Wrapper for Array Values
			if $$$IsPropertyArray(%schema, elementType, propName) {
				// Open an Array
				$$$DBG("Open Array: ",propName)
				Set arrayPropName = propName
				Set propArray = $$$NewArray
				$$$SetObject(resultObject, propName, propArray)
			}
		}
	
		// Determine how to output this property
		Set jsonType = $$$GetPropertyJsonType(%schema, elementType, propName)
		
		if jsonType = "o" {
			Set value = ..EmitNode(pNode, $$$GetPropertyFHIRType(%schema, elementType, propName))
			if propArray '= "" {
				$$$PushObject(propArray, value)
			} else {
				$$$SetObject(resultObject, propName, value)
			}
		} elseif jsonType = "x" {
			Set divNode = pNode.Serialize(.endDivNode)
			Do pNode.GetText(.divText,1)
			Set divText = divNode_divText_endDivNode
			Set divText = $ZStrip(divText,"<>W")
			if propArray '= "" {
				$$$PushString(propArray, divText)
			} else {
				$$$SetString(resultObject, propName, divText)
			}
		} elseif jsonType="alias" {
			Do pNode.MoveToFirstChild()
			Set value = ..EmitNode(pNode, pNode.LocalName)
			if propArray '= "" {
				$$$PushObject(propArray, value)
			} else {
				$$$SetObject(resultObject, propName, value)
			}
			Do pNode.MoveToParent()
		} else {
			// This is primitive value
			if pNode.HasChildNodes() || pNode.AttributeDefined("id") {
				Set extn = ..EmitNode(pNode, "Element")
				Do primitiveExtensions.%Push(extn)
				set havePrimitiveExtensions = 1
			} else {
				Do primitiveExtensions.%Push("","null")
			}

			Set value = pNode.GetAttributeValue("value")
			if (value="") {
				Set dynObjType = "null"
			} else {
				Set dynObjType = $Case(jsonType, "s":"string", "n":"number", "b":"boolean")
				if jsonType="b" {
					Set value = (value="true")	
				}
			}
			if propArray '= "" {
				Do propArray.%Push(value, dynObjType)
			} else {
				if (dynObjType '= "null") {
					Do resultObject.%Set(propName, value, dynObjType)
				}
				// For a scalar, extract the first array element
				Set primitiveExtensions = primitiveExtensions.%Get(0)
			}
		}
		If 'pNode.MoveToNextSibling(1) {
			Quit
		}
	}

	// Revert the Node object to where we entered this method
	Set pNode.NodeId = savedNodeId
		
	if havePrimitiveExtensions {
		Do resultObject.%Set("_" _ propName, primitiveExtensions)
	}

	Quit resultObject
}

}
