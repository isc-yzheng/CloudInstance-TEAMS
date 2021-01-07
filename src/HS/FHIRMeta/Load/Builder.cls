Class HS.FHIRMeta.Load.Builder Extends (%RegisteredObject, HS.FHIRMeta.Load.JSONUtil)
{

/// types(<type>) = Type object
/// types(<type>, "field", n) = Field object
/// types(<type>, "field", n, "v", vn) = Field Object for variant
Property types [ MultiDimensional ];

Property loader As HS.FHIRMeta.Load.NpmLoader;

ClassMethod Build(loader As HS.FHIRMeta.Load.NpmLoader)
{
	Set obj = ..%New(loader)
	Do obj.buildTypeInfo()
	return obj
}

Method %OnNew(loader As HS.FHIRMeta.Load.NpmLoader) As %Status
{
	set ..loader = loader
	return $$$OK
}

Method typeIsResource(typeName As %String) As %Boolean [ CodeMode = expression ]
{
..typeIsA(typeName, "Resource")
}

Method typeIsDomainResource(typeName As %String) As %Boolean [ CodeMode = expression ]
{
..typeIsA(typeName, "DomainResource")
}

Method typeIsA(typeName As %String, baseTypeName As %String) As %Boolean
{
	while typeName '= "" {
		if '$D(..types(typeName), typeObj) {
			return 0
		}
		if typeName = typeObj.id {
			return 1
		}
		set typeName = typeObj.baseType
	}
	return 0
}

Method buildTypeInfo()
{
	
	Set iterator = ..loader.getRsrcIterator("StructureDefinition")
	while iterator.Next(.jsd) {
		// Load all StructureDefinitions indexed by 'id'
		// And build statistics while we're at it
		Set url = jsd.url
		
		// Skip 'logical' StructureDefinitions
		Continue:jsd.kind="logical"
		
		Do $I(stats("sd"))
		Do $I(stats("sd", jsd.kind, $S(jsd.derivation="":"base", 1:jsd.derivation)))
		
		#dim typeObj as Type= ..getTypeForSD(jsd)
		kill names
		kill profiles
		
		// Determine whether this is a type of the base schema.  We need this because an array
		// type may be constrained to "max=1" in a profile but the field must still be an array.
		Set isBaseType = (jsd.baseDefinition="") || (jsd.derivation="specialization")
		Set prefix = $Select(isBaseType:"", 1: jsd.id _ ":")
		
		// (DEVNOTE:  We do not process 'constraint' definitions (which are profiles on resources)
		if (jsd.kind="resource") && (jsd.id '= jsd.type) {
			Continue
		}
		Continue:(jsd.snapshot = "")
		Set elements = jsd.snapshot.element
		Set iter = elements.%GetIterator()
		while iter.%GetNext(.elix, .jel) {
			Quit:elix=""
			if elix=0 {
				// This is the type-level element
				Set names(prefix_jel.id) = typeObj
			} else {
				// This is a field element.  If the field id has multiple components
				// then treat the leading components as the "object' id and the last component as the
				// field name and list all fields below the inline-object
				Set elid = jel.id
				Set tn = prefix _ $Piece(elid, ".", 1, *-1)
				Set fn = $Piece(elid, ".", *)
				Set $List(elinfo,1) = fn
				Set names(tn, "field", elix) = $LB(fn, jsd.id, elix, isBaseType)
			}
		}

		// The first index of 'names' is a StructureDefinition or "in-line" type
		// (effectively fields of fields).
		Set tn = ""
		for {
			Set tn = $O(names(tn))
			Quit:tn=""
			if $Get(names(tn))="" {
				// This is an in-line type
				Set names(tn) = $LB("r", jsd.id)
			
				
			} else {
				if jsd.derivation = "constraint" {
					// A constraint object is a 'profile' on its base class (type)
					Set profiles(jsd.type, "profile", jsd.id ) = typeObj
				}
			}
		}
		Merge ..types = names
		Merge ..types = profiles
	}
	Do ..addSynthesizedTypeObjects()
	Do ..addFieldObjects()
	Do ..simplifyExtensions()
	Do ..distributeExtensions()
	zw stats
}

/// Go through each type
Method addSynthesizedTypeObjects()
{
	#dim jsd as %DynamicObject
	set type = ""
	for {
		Set type = $O(..types(type))
		Quit:type=""
		
		Set typeObj = $Get(..types(type))
		if '$IsObject(typeObj) {
			// This is a custom type.  Either it is a 
			// StructureElement or a constraint on a FHIR Object declared as a structure element.
			// Either way, its definition is scoped to the containing Structure element.
			Set baseType = $Piece(type,".",1,*-1)
			Set propName = $Piece(type,".",*)
			// Get the first element index in this object
			Set elix = $O(..types(type,"field", ""))
			Set prevElix = $O(..types(baseType, "field", elix), -1)

			// Set the type for the referring property
			Set $List(..types(baseType, "field", prevElix), 5) = type
			
			// Basetype identifies the JSD
			Set jsd = ..loader.getRsrcByUrl(..types(baseType).url)
			Set jel = jsd.snapshot.element.%Get(prevElix)
		 	Do ..getCodesForElement(jel, .codes)
		 	
			//w "BB Type: ", type, " -> ", $LTS(..types(baseType, elix-1)),!
			Set typeObj = ##class(Type).%New(type, jsd.url, "complex-type")
			Set typeObj.baseType = $Order(codes(""))
			Set ..types(type) = typeObj
		}
	}
}

/// Go through each type
Method addFieldObjects()
{
	#dim jsd as %DynamicObject
	set type = ""
	for {
		Set type = $O(..types(type), 1, typeObj)
		Quit:type=""

		Set jsd = ..loader.getRsrcByUrl(typeObj.url)
		
		
		
		// Create field object for each property
		kill ixByPath
		Set elix = ""
		for {
			Set elix = $O(..types(type, "field", elix), 1, list)
			Quit:elix=""
			
			// Deserialize fields from the list
		 	Set fieldName = $LG(list,1)
		 	// Set jsdId = $LG(list,2)
		 	// Validate the index into the JSD
			if elix '= $LG(list,3) {
				w "HUH?????",!
				break
			}
			// This property element is defined in the base schema
			Set isBaseType = $LG(list,4)
			// Get the synthesized type (if any)
			Set synthesizedType = $LG(list,5)
			
			Set jel = jsd.snapshot.element.%Get(elix)
			// Get the list of type codes for this property.  It will have
			// exactly one unless this is a variant field (which may have 1 or more types)
			
			if synthesizedType '= "" {
				kill codes
				Set codes = 1
				Set codes(1) = synthesizedType
			} else {
				Set refType = jel.contentReference
				//w "ContentRef for ",jel.id," is ", type,!
				if $E(refType) = "#" {
					kill codes
					Set refType = $E(refType,2,*)
					if 'isBaseType {
						Set refType = jsd.id _ ":" _ refType
						w "New RefType: ",refType,!
					}
					Set codes($E(type,2,*)) = refType
					do $I(codes)
				} else {
		 			Do ..getCodesForElement(jel, .codes)
				}
			}
			// Determine whether the field is an array
			if $IsObject(jel.base) {
				Set isArray = (jel.base.max '= 1)
			} else {
				Set isArray = (jel.max '= 1)
			}
			
		 	Set isVariant = $Find(jel.id, "[") > 0
		 	if isVariant {
			 	// If this is a variant field, fix the name and mark the property slot
			 	// Subsequent code will add a child entry for each variant type
			 	Set fieldName = $Piece(fieldName,"[", 1)
				set variantField = ##class(Field).%New(fieldName, elix, "variant", jel.min, jel.max)
				Set variantField.isArray = isArray
				Set variantField.variantTypeCount = codes
				Set ..types(type, "field", elix) = variantField
		 	}
			// Now create a field for each data type that this property can have.
			Set fhirType = ""
			for  {
			
				Set fhirType = $Order(codes(fhirType), 1, variantType)
				Quit:fhirType=""
		
				Set vFieldName = $Select(isVariant:fieldName _ $ZConvert($E(variantType),"U") _ $E(variantType,2,*), 1:fieldName)
				set field = ##class(Field).%New(vFieldName, elix, variantType, jel.min, jel.max)
				Set field.fixedUri = jel.fixedUri
				Set field.canReferTo = $Get(codes(fhirType, "target"))
				Set field.isXmlAttr = ..JIndex(jel.representation,"xmlAttr") >= 0
				Set field.isArray = isArray

				// Now see if there is a value set enumeration for this property
				if (jel.binding '= "") {
					Set field.valueSetStrength = jel.binding.strength 
					if (jel.binding.valueSetReference '="") {
						Set field.valueSetUrl = jel.binding.valueSetReference.reference
					} elseif jel.binding.valueSet '= "" {
						Set field.valueSetUrl = jel.binding.valueSet
					}
				}
			
				
				if isVariant {
					Set varIndex = $I(..types(type, "field",elix,"v"))
					Set field.vindex = varIndex
					Set ..types(type, "field", elix,"v",varIndex) = field
					//w "Field: ",parentKey,"|",fieldIndex,"|",varIndex,"=",field.asString(),!
				} else {
					Set field.vindex = 0
					Set ..types(type, "field", elix) = field
					// "Field: ",type,"|",elix,"=",field.asString(),!
				}
			}
			// If this property path was used, this must be a slice
			if $D(ixByPath(jel.path), propix) {
				if jel.sliceName '= "" {
					Set fieldObj = ..types(type, "field", elix)
					Set ..types(type, "field", propix, "slice", $I(..types(type, "field", propix, "slice"))) = fieldObj
					kill ..types(type, "field", elix)
				} else {
					w "Duplicate Path in type: ",jsd.id, "|",jel.path,"|",propix,"|",elix,!
				}
			} else {
				Set ixByPath(jel.path) = elix
			}
			
		}
	}
}

Method simplifyExtensions()
{
	set type = ""
	for {
		Set type = $O(..types(type), 1, typeObj)
		Quit:type=""
			if typeObj.baseType = "Extension" {
			do ..simplifyExtension(type)
		}
	}
}

Method simplifyExtension(type As %String) As Type
{

	// Get the 4 component fields (id, url, value, extension)
	set ix=""
	for {
		Set ix = $Order(..types(type, "field", ix), 1, field)
		quit:ix=""
		if field.name = "id" {
			Set idField = field
		} elseif field.name = "extension" {
			set extField = field
			Set noExtensionAllowed = (extField.max = 0)
			// Save the child extension specs
			merge slices = ..types(type, "field", ix, "slice")
		} elseif field.name = "url" {
			set urlField = field
			Set fixedUri = urlField.fixedUri
		} else {
			// Field name must start with 'value'
			// (Internal error otherwise)
			if $find(field.name, "value")'=6 {
				w "INTERNAL ERROR: Unexpected field name '", field.name," in extension: ", type,!
				Quit
			}
			
			Set valueField = field
			Set isValueAllowed = (valueField.max > 0)
			if isValueAllowed {
				// Grab the Field object and all of its variants
				merge value = ..types(type, "field", ix)
			}
		}
		// Kill this field entry.
	}
	kill ..types(type, "field")
	
	// Create a single 
	
	if urlField.fixedUri = "" {
		// This is a "standard" extension, we don't need this object
		// Remove this extension type
		kill ..types(type)
		quit	
	}
	Set extnObj = ##class(ExtensionType).%New(type, ..types(type).url, , fixedUri, noExtensionAllowed, isValueAllowed)
	Set ..types(type) = extnObj
	
	if isValueAllowed {
		set vix = ""
		for {
			Set vix = $O(value("v",vix), 1, vField)
			Quit:vix=""
			Set vField.index = 1
			set ..types(type, "field", 1, "v", vix) = vField
		}
		Set valueField.index = 1
		Set ..types(type, "field", 1) = valueField
	}
	
	// Now any slices are actually child extensions
	set fix = 1
	set six = ""
	
	for { 
		set six = $O(slices(six),1,sField)
		quit:six=""
		
		do $I(fix)
		Set sField.index = fix
		Set ..types(type, "field", fix) = sField
	}
}

/// Go through all extension profiles and add them as child Field objects of the object they extend.
Method distributeExtensions()
{
	Quit
	set xid = ""
	for {
		Set xid = $Order(..types("Extension", "profile", xid), 1, typeObj)
		Quit:xid=""
		
		Set jsd = ..loader.getRsrcById("StructureDefinition", xid)
		//w jsd,": ",typeObj.asString(),!
		Set jel = jsd.snapshot.element.%Get(0)

		// The 'context' property enumerates which resource properties support this extension
		// The 'type' property of each context object can be 'element' 
		// or ( 'extension' or 'fhirpath' which are not yet supported)
#;		kill visited

		Set isSTU3 = (+$E(..loader.coreVersion)) = 3
		if isSTU3 && jsd.contextType '= "element" {
			// Only a singleton contextType in stu3
			w "Context.type value of ", jsd.contextType, " not yet supported",!
			Continue
		}
		Set iter = jsd.context.%GetIterator()
		while iter.%GetNext(.subsc, .context ) {
			if 'isSTU3 && (context.type '= "element") {
				w "Context.type value of ", context.type, " not yet supported",!
				continue
			}
			Set expression = $S(isSTU3: context, 1:context.expression)
			if '..getPathKeys($Piece(expression,"#",*), .contextType, .propName) {
				Continue
			}
#;			Set visitKey = contextType_"." _ propName
#;			Continue:$D(visited(visitKey))
#;			Set visited(visitKey) = ""
			//w "  ", context.expression, " -> ", contextType, " . ",propName, !
			
			// Get the ExtensionType object
			Set typeKey = typeObj.id_":Extension"
			Set xtypeObj = ..types(typeKey)
			if propName = "" {
				set fix = 0
			} else {
				Set fieldObj = ..findField(contextType, propName)
				Set fix = fieldObj.index
			}
			
			// Create the Field object for this extension
			Set extnField = ##class(Field).%New("extension", 0, typeKey, jel.min, jel.max)
			Set extnField.isArray = (jel.max '= 1)
			Set extnField.fixedUri = xtypeObj.fixedUri
			Set ..types(contextType, "extension", fix, xtypeObj.fixedUri) = extnField
		}
	}
}

/// Returns information the parent type and property name for a property path string
/// <br>@Input path  An extracted FHIR path (only property names or extension('url') as elements)
/// <br>@Output type The key for the datatype containing the property
/// <br>@Output propName The name of the property
/// <br>@Output multiFlag True if any parent property in the path is an array.
Method getPathKeys(path As %DynamicObject, Output type As %String, Output propName As %String) As %Boolean
{
	Set multiFlag = 0
	Set pathList = ..pathToList(path)
	Set pll = $LL(pathList)
	Set type = $LG(pathList,1)
	if pll<=2 {
		Set propName = $LG(pathList,2)
		return 1
	}
	Set propName = $LG(pathList, *)
	for pix = 2:1:pll-1 {
		Set field = ..findField(type, $LG(pathList,pix))
		Set type = field.fhirType
	}
	return 1
}

Method findFields(typeName As %String, propName As %String, Output fields)
{
	kill fields
	set fields = 0
	
	#dim fieldObj as HS.FHIRMeta.Load.Field = ..findField(typeName, propName)
	if $IsObject(fieldObj) {
		if fieldObj.fhirType = "variant" {
			Set fix = fieldObj.index
			Set vix = ""
			for {
				Set vix = $Order(..types(typeName, "field", fix, "v", vix), 1, fieldObj)
				Quit:vix=""
				Set fields($I(fields)) = fieldObj
			}
		} else {
			Set fields($I(fields)) = fieldObj
		}
	}
}

/// Return the field object for the specified typeName and Property name
Method findField(typeName As %String, propName As %String) As Field
{
	if '$D(..types(typeName)) {
		w "No Type Info for: ",typeName,!
		break
		return ""
	}
	set fix = ""
	#dim fieldObj as HS.FHIRMeta.Load.Field
	for {
		Set fix = $Order(..types(typeName, "field", fix), 1, fieldObj)
		if fix="" {
			//w "Property '", propName,"' not found in: ",typeName,!
			//break
			return ""
		}
		if fieldObj.name = propName {
			return fieldObj
			Set fields($I(fields)) = fieldObj
			zw fieldObj
			return fieldObj
		} elseif fieldObj.fhirType = "variant" {
			Set vix = ""
			for {
				Set vix = $Order(..types(typeName, "field", fix, "v", vix), 1, fieldObj)
				Quit:vix=""
				if fieldObj.name = propName {
					return fieldObj
				}
			}
		}
	}
	return ""
}

/// Returns all Field objects that match the path. This may
/// return multiple objects if an element of the path is a variant type.
Method findFieldForPath(path As %String) As Field
{
	#dim fieldObj as Field = ""
	Set type = $Piece(path,".",1)
	Set typeFieldIndex = 0
	Set pathList = ..pathToList($Piece(path, ".", 2, *))
	Set pix=0
	while $ListNext(pathList, pix, propName) {
		Set fieldObj = ..GetExtensionField(type, propName, typeFieldIndex)
		if fieldObj '= "" {
			Set type = fieldObj.fhirType
		} else {
		
			Set fieldObj = ..findField(type, propName)
			if fieldObj="" {
				w "No Field for ",type,"|",propName,!
				Quit
			}
			Set type = fieldObj.fhirType
			Set typeFieldIndex = fieldObj.index
			if type = "variant" {
				// Check each variant type for the propName
				Set vix=""
				kill foList
				Set foList=0
				for {
					Set vix = $Order(..types(type, "field", fieldObj.index, "v", vix),1,fo)
					Quit:vix=""
					
					Set fo = ..findField(fo.fhirType, propName)
					if $IsObject(fo) {
						Set foList($I(foList)) = fo
						Set newtype = fo.fhirType
					}
				}
				Set type = newtype
			}
		}
	}
	return fieldObj
}

/// Take a path that may contain a variant, and resolve it to the actual
/// set of property paths
Method ResolvePath(path As %String, Output resolved)
{
	kill resolved
	set resolved = 0
	
	Set pathList = ..pathToList(path)
	Set pll = $LL(pathList)
	Set rt = $LG(pathList,1)
	Set inputs($I(inputs)) = $LB(rt, rt, 0)
	
	for pix=2:1:pll {
		kill resolved
		set resolved = 0
		
		Set propName = $LG(pathList, pix)
	
		for ord=1:1:inputs {
			Set type = $LG(inputs(ord),1)
			Set path = $LG(inputs(ord),2)
			Set fieldIndex = $LG(inputs(ord),3)

			#dim extField as Field = ""
			
#;			if propName = "extension" {
#;				Set type = "Extension"
#;			} else {
#;				set extField = ..GetExtensionField(type, propName, fieldIndex)
#;			}

			set extField = ..GetExtensionField(type, propName, fieldIndex)
			if (extField '= "") {
				//w type, "|", propName," -> ", extField.asString(),!
				// Special processing for Extension properties
				Set prevResolved = resolved
				Set extnType = extField.fhirType
				//w types(extnType).fhirType,!
				if extnType = "Extension" {
					// This is an "unqualified" extension.  If it is a child of a
					// qualified extension, then enumerate the child extensions as possible
					// paths
					Set typeObj = ..types(type)
					set efix = ""
					for {
						Set efix = $Order(..types(type, "field", efix), 1, xfieldObj)
						Quit:efix=""
						if $E(xfieldObj.name,1,10) = "extension:" {
							// Construct the qualified extension path for this sub-extension
							Set fixedUri = ..types(xfieldObj.fhirType).fixedUri
							Set propPath = propName _ "('" _ fixedUri _ "')"
							Set resolved($i(resolved)) = $LB(xfieldObj.fhirType, path _ "." _ propPath, 0)
						}
					}
				} else {
					// Add this qualified extension
					Set resolved($i(resolved)) = $LB(extnType, path _ "." _ propName, 0)
					//w "  resolved to: ",$LTS(resolved(resolved)),!
				}
				// No profiled sub-types, treat as an unqualified extension
				if prevResolved = resolved {
					// Nothing was added, so just add a raw "extension" type to the path
					Set resolved($i(resolved)) = $LB("Extension", path _ "." _ propName, 0)
				}
				
			} else {
				// This is a base-schema property
				if $D(..types(type), typeObj) {
					Continue:(typeObj.kind = "primitive-type")
					
					#dim fieldObj as Field = ..findField(type, propName)
					if $IsObject(fieldObj) {
						set fhirType = fieldObj.fhirType
						if fhirType '= "variant" {
							Set resolved($i(resolved)) = $LB(fhirType, path _ "." _ propName, fieldObj.index)
						} else {
							Set vix = ""
							for {
								Set vix = $Order(..types(type, "field", fieldObj.index, "v", vix),1,fo)
								Quit:vix=""
								
								if $IsObject(fo) {
									Set resolved($i(resolved)) = $LB(fo.fhirType, path _ "." _ fo.name, , fieldObj.index)
								}
							}
						}
					} else {
						w "WARNING: No property found for ",type," | ",propName,!
					}
				} else {
					w "No in typeInfo for ",type, !
					break	
				}
			}
		}
		kill inputs
		merge inputs = resolved
}
}

Method GetExtensionField(parentType As %String, propName As %String, fieldIndex As %Integer) As %String
{
	#dim extnFieldObj as Field = ""
	if $Find(propName,"extension") = 10 {
		// An extension field.  
		if $E(propName,10,11) = "('" {
			// A profiled extension	
			Set extnUrl = $E(propName,12,$Find(propName,"'",12)-2)
			// w "ExtnURL: ",extnUrl,!
			if $E(extnUrl,1,6) = "http:/" {
				Set extnFieldObj = ..types(parentType, "extension", fieldIndex, extnUrl)
			} else {
				Set extnFieldObj = ..findField(parentType, "extension:" _ extnUrl)
			}
		} else {
			Set extnFieldObj = ..findField("Extension", "extension")
		}
	}
	return extnFieldObj
}

/// Get the next piece of a '.' separated string, ignoring dots in single-quoted
/// strings
ClassMethod pathToList(path As %String) As %List
{
	Set pathList = ""
	Set index = 0
	for {
		Set name = $$nextField()
		Quit:name=""
		Set $List(pathList,*+1) = name
	}
	return pathList
	
nextField()
	Set start = index
	Set inQuotes = 0
	for {
		Set c = $E(path, $I(index))
		Quit:c=""
		
		if inQuotes {
			if (c = "'") {
				Set inQuotes = 0
			}
		} elseif (c = "'") {
			Set inQuotes = 1
		} else { 
			Quit:c="."
		}
	}
	Quit $E(path, start+1, index-1)
}

ClassMethod nextField(str As %String, ByRef index) As %String
{
	Set start = index
	Set inQuotes = 0
	for {
		Set c = $E(str, $I(index))
		Quit:c=""
		
		if inQuotes {
			if (c = "'") {
				Set inQuotes = 0
			}
		} elseif (c = "'") {
			Set inQuotes = 1
		} else { 
			Quit:c="."
		}
	}
	return $E(str, start+1, index-1)
}

Method getTypeForSD(jsd As %DynamicObject) As Type
{
	Set type = ""
	 
	if jsd.kind = "primitive-type" {
		Set typeKey = "pr"
		Set jsonType = "?"
		Set regex = ""
		// Extract the JSON type from the resource (Extension on value.type.code)
		if ..JFind(jsd.snapshot.element, "id", jsd.id _ ".value", .jvalue)
		{
			Set typeProp = jvalue(1).type.%Get(0)
			if ..JFindExtensions(typeProp, "http://hl7.org/fhir/StructureDefinition/structuredefinition-fhir-type", .extn) {
				Set jsonType = extn(1).valueUrl	
			}
			elseif ..JFindExtensions(typeProp."_code", "http://hl7.org/fhir/StructureDefinition/structuredefinition-json-type", .extn) {
				// This was obsoleted in 4.0.1, but it can hurt to keep it
				Set jsonType = extn(1).valueString	
			}
			// Extract the validation Regex from the resource (Extension on value.type)
			if ..JFindExtensions(typeProp, "http://hl7.org/fhir/StructureDefinition/regex", .extn) {
				// R4 extension URL
				Set regex = extn(1).valueString	
			} elseif ..JFindExtensions(typeProp, "http://hl7.org/fhir/StructureDefinition/structuredefinition-regex", .extn) {
				// STU3 extension URL
				Set regex = extn(1).valueString	
			}
		}
		Set type = ##class(Type).%New(jsd.id, jsd.url, jsd.kind)
		Set type.jsonType = jsonType
		Set type.regex = regex
		return type
#;			Set context(jsd.id) = type
#;			Set c = $I(context)
	} elseif (jsd.kind = "resource") || (jsd.kind = "complex-type") {
		if jsd.baseDefinition '= "" {
			set baseResource = ..loader.getRsrcByUrl(jsd.baseDefinition)
			if '$isobject(baseResource) $$$ThrowStatus($$$ERROR($$$GeneralError, "baseDefinition '" _ jsd.baseDefinition _ "' referenced by '" _ jsd.url _ "' does not exist"))
			set baseType = baseResource.type
		}
		else {
			set baseType = ""
		}
		
		Set type = ##class(Type).%New(jsd.id, jsd.url, jsd.kind)
		Set type.baseType = baseType
		Set type.isAbstract = (jsd.abstract = 1)
		//Set context(jsd.id) = type
		// If this StructureDefinition is a 'constraint', mark it as a profile object of the
		// Type it extends
		if jsd.derivation = "constraint" {
			Set context(jsd.type, "profile", jsd.url) = type
		}
		//Set c = $I(context)
	} elseif (jsd.kind = "logical" ) {
		//w "Skipping logical StructureDefinition: ", jsd.url,!
	} else {
		w "Skipping StructureDefinition with unsupported 'kind': ", kind," :",jsd.url,!
	}
	return type
}

/// This method populates a multidimensional array with the set of
/// datatypes that a field (represented by a StructureElement) allows.  If
/// more than one, then the field is a 'variant' type field
Method getCodesForElement(jel As %DynamicObject, Output codes) [ Private ]
{
	kill codes
	Set codes = 0
	#dim typeArray As %DynamicArray = jel.type
	if (typeArray = "") {
		// If there is not a 'type' property, then we expect
		// that there is a contentReference to another property in this
		// object, and we will use the type of that property
		Set type = jel.contentReference
		//w "ContentRef for ",jel.id," is ", type,!
		if $E(type) = "#" {
			Set codes($E(type,2,*)) = $E(type,2,*)
			do $I(codes)
		} else {
			
			if ($Find(jel.id,".")>0) {
				zw jel
			}
		}
		return
	}
	
	Set canReferTo = ""
	Set iter = typeArray.%GetIterator()
	while iter.%GetNext(.subsc, .type) {
		Do ..JFindExtensions(type, "http://hl7.org/fhir/StructureDefinition/structuredefinition-fhir-type", .extype)
		if extype = 1 {
			Set code = extype(1).valueUrl
		} else 	{	
			Set code = type.code
		}
		Set profileName = type.profile
		if type.profile '= "" {
			if $IsObject(profileName) {
				Set profileName = profileName.%Get(0)
			}
			Set code = ..loader.getRsrcByUrl(profileName).id
		}
		if code = "" {
			// There are a couple of places this happens (Element.id, Extension.url).
			// They have a primitive extension for code that result in 'string'.  
			// (Also Extension.url has a regex for the url that includes valid resource types)
			// We can come back to this 
			Set code = "string"
		}
		if '$D(codes(code)) {
			Set codes(code) = $Select(profileName'="":type.code, 1:code)
			do $I(codes)
		}
		Set profile = type.profile
		if (profile '= "") {
			Set codes(code, "profile") = profile
		} 
		if ( (code = "Reference") && (type.targetProfile '= "") ) {
			if $IsObject(type.targetProfile) {
				Do ..JsonArrayToArray(type.targetProfile, .targets)
			} else {
				Set targets = 1
				Set targets(1) = type.targetProfile
			}
			// Convert reference type URLs to typeNames
			for it=1:1:targets {
				Set refType = ..loader.getRsrcByUrl(targets(it)).id
				Set $List(canReferTo, *+1) = refType
			}
			Set codes(code, "target") = canReferTo
		}
	}
}

Method distributeExtensionTypes()
{
	set type = ""
	for {
		Set type = $O(..types(type),1,typeObj)
		Quit:type=""
		Continue:typeObj.kind'="extension-type"
	
		Set jsd = ..loader.getRsrcByUrl(typeObj.url)
		w jsd.id,!
		Set contexts = jsd.context
		Continue:contexts=""
		
		Set iter = contexts.%GetIterator()
		while iter.%GetNext(.subsc, .context ) {
			w "  ", context.type, " in ", context.expression, !
		}
	}
}

ClassMethod Keys(name)
{
	Set key=""
	Write "Keys for " _ name,!
	Set ix = 0
	for { 
		Set key = $O(@name@(key))
		Quit:key=""
		w "  ",$I(ix),": ", key,!
	}
}

Method dump(key = "", options = "pfsx")
{
	if key="" {
		Set type = ""
		for {
			Set type = $O(..types(type))
			Quit:type=""
			
			Do ..dumpOne(type, options)
		}
	} else {
		do ..dumpOne(key, options)
	}
}

Method dumpOne(key As %String, options = "pfsx")
{
	Set doProfiles = $Find(options,"p") > 0
	Set doFields = $Find(options,"f") > 0
	Set doSlices = $Find(options,"s") > 0
	Set doExtensions = $Find(options,"x") > 0
	set val = ..types(key)
	if $IsObject(val) {
		w key,": ", val.asString(), !
	} else {
		w key,": ", $LTS(val), !
	}
	// Now the profiles
	if doProfiles {
		set pix = ""
		for {
			Set pix = $O(..types(key, "profile", pix), 1, ptype)
			Quit:pix=""
			w "  Profile: ", ptype.asString(),!
		}
	}
	// Now the fields
	if doFields {
		if doExtensions {
			Do showExtn(0)
		}
		set fix = ""
		for {
			Set fix = $O(..types(key, "field", fix), 1, finfo)
			Quit:fix=""
			if $IsObject(finfo) {
				w "  ", finfo.asString(),!
			} else {
				w "  ", $lts(finfo),!
			}
			if (finfo.fhirType = "variant") && (finfo.variantTypeCount < 4) {
				Set tl = ""
				for vix=1:1:finfo.variantTypeCount {
					Set $List(tl, *+1) = ..types(key, "field", fix, "v", vix).fhirType
				}
				w "     Types: ",$LTS(tl),!
				
			}
			if doExtensions {
				Do showExtn(fix)
			}
			if doSlices && ($D(..types(key, "field", fix, "slice"), sliceCount)) {
				for ord=1:1:sliceCount {
					w "     Slice: ",..types(key, "field", fix, "slice",ord).asString(),!
				}	
			}
		}
	}
	Quit	
showExtn(xix) 
	Set xid = ""
	for {
		Set xid = $Order(..types(key, "extension", xix, xid), 1, xField)
		Quit:xid=""
		w ("    "),"  [x: ", xid,"] ", xField,!
		//w $Select(xix=0:"",1:"    "),"  [x: ", xid,"] ", xField,!
	}

	Quit
}

}
