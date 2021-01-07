Include (HS.FHIRMeta, HS.FHIRPath)

Class HS.FHIRPath.Engine Extends %RegisteredObject
{

Property trace As %Boolean;

Property context As %DynamicObject;

Property schema As HS.FHIRMeta.API;

Property opMap [ MultiDimensional ];

Property fhirToJson [ MultiDimensional ];

Method initEngine() [ Internal ]
{
	for t="string","id","markdown" {
		Set ..fhirToJson(t) = "s"
	}
	for t="integer","decimal","positiveInt","unsignedInt" {
		Set ..fhirToJson(t) = "n"
	}
	//#define fixPrimitive(%t) $Select(((%t="string") || (%t="id") || (%t="markdown")):"s", ((%t="integer") || (%t="decimal") || (%t="positiveInt") || (%t="unsignedInt")):"n", 1:%t)
}

Method fhirTypeToJsonType(fhirType As %String) As %String [ CodeMode = expression ]
{
$Get(..fhirToJson(fhirType),"o")
}

Method interpretToJson(pResourceObj As %DynamicObject, pParseTree As HS.FHIRPath.Node) As %DynamicArray
{
	do ..interpret(pResourceObj, pParseTree, .OUTPUT)
	return ..CollectionToJsonArray(.OUTPUT)
}

Method interpret(pResourceObj As %DynamicObject, pParseTree As HS.FHIRPath.Node, Output OUTPUT)
{
	$$$CollPushValue(INPUT, pResourceObj, pResourceObj.resourceType)
	Do ..processNode(pParseTree, .INPUT, .OUTPUT)
}

Method processNode(pNode As HS.FHIRPath.Node, ByRef INPUT, Output OUTPUT)
{
	set type = pNode.type
	w:..trace ">>>> Enter Level: ", $I(%fpdepth),", type: ", type,", name: ",pNode.name,!
	zw:..trace INPUT
	
	
	if type = "OP" {
		do ..processOP( pNode, .INPUT, .OUTPUT)
	} elseif type = "ID" {
		do ..processID(pNode, .INPUT, .OUTPUT)
	} elseif (type = "FN") {
		Do ..processFN(pNode, .INPUT, .OUTPUT)
	} elseif (type = "LIT") {
		Set literalType = pNode.literalType
		if literalType = "o" {
			$$$CollPushValue(OUTPUT, {}, "Element")
		} elseif literalType = "i" {
			if pNode.name = "$this" {
				$$$ThrowError($$$GeneralError,"$this not yet implemented")
			} elseif pNode.name = "$index" {
				$$$ThrowError($$$GeneralError,"$index not yet implemented")
			} elseif pNode.name = "$total" {
				$$$ThrowError($$$GeneralError,"$total not yet implemented")
			}
		} elseif literalType = "boolean" {
			$$$CollPushBoolean(OUTPUT, pNode.name="true")
			
		} else {
			$$$CollPushValue(OUTPUT, pNode.name, literalType)
		}
	}
	w:..trace "<<<< Exit Level: ", %fpdepth,!
	zw:..trace OUTPUT
	do $I(%fpdepth, -1)
}

Method processID(pNode As HS.FHIRPath.Node, ByRef INPUT, Output OUTPUT)
{
	if $IsObject(pNode.context)   {
		// Evaluate the context (if any)
		Do ..processNode(pNode.context, .INPUT, .CONTEXT)
	}
	else {
		// Use our input as the context
		merge CONTEXT = INPUT
	}
	Set propName = pNode.name
	Set isResource = ..schema.IsValidResourceType(propName)
	Set OUTPUT = 0
	for ix=1:1:CONTEXT {
		Set inputValue = CONTEXT(ix)
		if isResource {
			// The ID is a resource name, only keep resources of the specified type
			if ..schema.IsA(inputValue.resourceType,propName) {
				$$$CollPushFromColl(OUTPUT, CONTEXT, ix)
			}
		} else {
			Set inputType = $$$CollGetTypeAt(CONTEXT, ix)
			set type = $$$GetPropertyFHIRType(..schema, inputType, propName)
			// Skip any primitive values here, they do not have sub-properties
			Continue:type=""
			
			if type '= "x-multi" {			
				Do ..pushFieldValue(inputValue.%Get(propName), type, .OUTPUT)
			} else {
				// try all possible types for this variant
				Set typeList = $$$GetPropertyFHIRTypeList(..schema, inputType, propName)
				set tlix = 0
				while $listnext(typeList, tlix, type) {
					set vpropName = ..variantFieldName(propName, type)
					set value = inputValue.%Get(vpropName)
					//w vpropName, " =|",value,"|",!
					if value '= "" {
						$$$CollPushValue(OUTPUT, value, type)
						Quit		
					}
				}
			}
		}
	}
}

Method processOP(opNode As HS.FHIRPath.Node, ByRef INPUT, Output OUTPUT)
{
	Set opName = opNode.name
	if '$D(..opMap(opName), fnBase) {
		$$$ThrowError($$$GeneralError, "No Handler Function Base for operator " _ opName)	
	}
	
	Set leftNode = opNode.children.GetAt(1)
	Do ..processNode(leftNode, .INPUT, .LEFT)
	
	Set OUTPUT = 0
	if opNode.isUnary {
		do $Method($this, "IUOP" _ fnBase, .LEFT, .OUTPUT)	
	} else {
		Set rightNode = opNode.children.GetAt(2)
		if (opName="as") || (opName="is") {
			// Treat the node as a datatype
			$$$CollPushValue(RIGHT, rightNode.name, "")
		} else {
			Do ..processNode(rightNode, .INPUT, .RIGHT)
		}
		Set methodName = "IOP" _ fnBase
		zw:..trace LEFT
		zw:..trace RIGHT
		do $Method($this, methodName, .LEFT, .RIGHT, .OUTPUT)	
		zw:..trace OUTPUT
	}
}

Method processFN(fnNode As HS.FHIRPath.Node, ByRef INPUT, Output OUTPUT)
{
	if $IsObject(fnNode.context)   {
		// Evaluate the context (if any)
		Do ..processNode(fnNode.context, .INPUT, .CONTEXT)
	}
	else {
		// Use our input as the context
		Set CONTEXT = 0
		merge CONTEXT = INPUT
	}
	
	Set OUTPUT = 0
	if fnNode.name = "subscriptGeneric" {
		// Handle subscripting
		Do ..processNode(fnNode.children.GetAt(1), .CONTEXT, .SUBSCRIPT)
		if (SUBSCRIPT=1) && $$$CollIsNumber(SUBSCRIPT, 1) {
			Set subscript = $$$CollGetValueAt(SUBSCRIPT, 1)
			if (subscript >=0) && (subscript < CONTEXT) {
				$$$CollPushFromColl(OUTPUT, CONTEXT, subscript+1)
			}
		} else {
			$$$ThrowError($$$GeneralError, "Subscript must be a numeric value" )
		}
		return	
	}
	Set methodName = "IFN" _ fnNode.name
	Do $Method($this, methodName, .CONTEXT, fnNode.children, .OUTPUT)
}

ClassMethod pushFieldValue(value, type As %String, ByRef INTO)
{
	if value '= "" {
		if $IsObject(value) && value.%IsA("%DynamicArray") {
			do ..JsonArrayToCollection(value, type, .INTO)
		} else {
			$$$CollPushValue(INTO, value, type)
		}
	}
}

Method CollectionToJsonArray(ByRef input) As %DynamicArray
{
	#dim array as %DynamicArray = ##class(%DynamicArray).%New()
	set ix=""
	for {
		Set ix = $Order(input(ix), 1, value)
		Quit:ix=""
		
		Set type = $Get(input(ix,"t"))
		if type="boolean" {
			Do array.%Push(value,"boolean")
		} else {
			Set jtype = ""
			if jtype'="" {
				set jtype = ..fhirTypeToJsonType(type)
			}
			if jtype="n" {
				Do array.%Push(value,"number")
			} else {
				Do array.%Push(value)
			}
		}
	}
	return array
}

ClassMethod JsonArrayToCollection(array As %DynamicArray, type As %String, ByRef INTO)
{
	Set iter = array.%GetIterator()
	while iter.%GetNext(.key, .value) {
		$$$CollPushValue(INTO, value, type)
	}
}

ClassMethod variantFieldName(variantName As %String, fhirType As %String) As %String [ CodeMode = expression ]
{
variantName _ $ZCVT($E(fhirType),"U") _ $E(fhirType,2,*)
}

}
