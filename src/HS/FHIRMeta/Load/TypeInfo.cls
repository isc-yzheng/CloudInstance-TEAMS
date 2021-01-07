Include HS.FHIRMeta

/// This class builds the typeInfo array used by HS.FHIRMeta.API
/// 
Class HS.FHIRMeta.Load.TypeInfo Extends %RegisteredObject
{

ClassMethod populatePrimitivesGlobal(builder As Builder, metaAPI As HS.FHIRMeta.API) [ Internal ]
{
	Set GblName = $$$FSMetaPTypeInfoGlobal(metaAPI)
	Set typeName = ""
	for {
		Set typeName = $O(builder.types(typeName), 1, typeObj)
		Quit:typeName=""
		
		Continue:(typeObj.kind '= "primitive-type")
		// Simplify to "s,n,b,x"
		Set jt = $Case(typeName, "decimal":"n", "integer":"n", "positiveInt":"n", "unsignedInt":"n", "boolean":"b", "xhtml":"x", :"s")
		Set @GblName@(typeName) = jt
		Set @GblName@(typeName, "rx") = typeObj.regex
		// w "prim: ", typeName,!
		// Set @GblName@(typeName, "url") = typeObj.url
	}
}

/// Populates the "cp" section of the global with compartment metadata
ClassMethod populateCompartmentGlobal(loader As HS.FHIRMeta.Load.NpmLoader, metaAPI As HS.FHIRMeta.API) [ Internal ]
{
	Set GblName = $$$FSMetaCompartmentGlobal(metaAPI)
	Set iterator = loader.getRsrcIterator("CompartmentDefinition")
	while iterator.Next(.jrsrc) {
		set url = jrsrc.url
		
	    Set compartmentName = jrsrc.id
	    Set compartmentResource = jrsrc.code
	    // w "Adding Compartment ",compartmentName,!
	    Set iter = jrsrc.resource.%GetIterator()
	    while iter.%GetNext(.subsc, .item) {
			if (item.code '= compartmentResource) && (item.param '= "") {
				Set piter = item.param.%GetIterator()
				while piter.%GetNext(.ss, .paramName) {
					Set @GblName@(compartmentName, item.code, $Piece(paramName,".",1)) = ""	
				}
			}
	    }
	}
}

ClassMethod populateTypeInfoGlobal(builder As Builder, valueSets As ValueSets, metaAPI As HS.FHIRMeta.API) [ Internal ]
{
	Set global = $$$FSMetaTypeInfoGlobal(metaAPI)
	Set primGlobal = $$$FSMetaPTypeInfoGlobal(metaAPI) 
	Set typeName = ""
	for {
		#dim typeObj as Type
		Set typeName = $Order(builder.types(typeName), 1, typeObj)
		Quit:typeName=""
		
		//w typeObj.asString(),!
		Continue:typeObj.isPrimitive()
		// The old schema doesn't handle extension-types
		Continue:typeObj.isExtension()
		
		// Get the Global node name for this type
		Set typeNode = $Name(@global@(typeObj.id))
		
		Set @typeNode = 0
		Set @typeNode@("*dt") = typeObj.baseType
		Set propNames = ""
		Set requireds = ""
		
		set ic = ""
		for  {
			#dim field as Field
			Set ic = $Order(builder.types(typeName, "field",ic), 1, field)
			Quit:ic=""
			
			do $I(@typeNode)
			Set fhirType = field.fhirType
			if field.isVariant {
				set fhirType = "x-multi"
				Set iv=0
				Set maxv = builder.types(typeName, "field", ic, "v")
				Set variantTypeList = ""
			} else {
				Set iv=0
				Set maxv = 0
			}
			for {
				Set propName = field.name
				Set propNode = $Name(@typeNode@(propName))
				Set @propNode@("ix") = field.index
				Set @propNode@("dt") = fhirType
				if field.canReferTo '= "" {
					Set @propNode@("tl") = field.canReferTo
				}
				if field.isXmlAttr {
					Set @typeNode@("*xa", propName) = 1
					
				}
				if fhirType = "x-multi" {
					Set jt = "c"
					set variantPropNode = propNode
					if field.min = 1 {
						Set $List(requireds,*+1) = propName
					}
				} else {
					Set @propNode@("arr") = field.isArray
					Set $List(propNames,*+1) = propName
					#dim propTypeObj as Type = builder.types(fhirType)
					if '$D(@primGlobal@(fhirType), jt) {
#;					if propTypeObj.isPrimitive() {
#;						Set jt = $Case(fhirType, "decimal":"n", "integer":"n", "positiveInt":"n", "unsignedInt":"n", "boolean":"b", "xhtml":"x", :"s")
#;					} else {
						set jt = $Case(fhirType, "Resource":"alias", "x-multi":"c", :"o")
					}
				}
							
				Set vsUrl = $Piece(field.valueSetUrl, "|", 1)
				if vsUrl '= "" {
					Set @propNode@("vs") = vsUrl
					Set @propNode@("vss") = field.valueSetStrength
					if field.valueSetStrength = "required" {
						do valueSets.getValueSetCodes(vsUrl, .vsCodes) 	
						merge @propNode@("enum") = vsCodes
						kill vsCodes
					}
					//w "addValueSetEnums for ",vsUrl," | ",typeName,".",propName,! 	
				}
			
				Set @propNode@("jt") = jt
				if maxv = 0 {
					// Do this for non-variant fields
					if field.min = 1 {
						Set $List(requireds,*+1) = propName
					}
					Quit
				}
				// This is a variant type, re-initialize for the next field
				if $I(iv) > maxv {
					// All fields added, now add the type list
					Set @variantPropNode@("dt", "list") = variantTypeList
					Quit
				} else {
					// This is a variant, loop with each datatype field
					Set field = builder.types(typeName, "field", ic, "v", iv)
					Set fhirType = field.fhirType
					Set $List(variantTypeList, *+1) = fhirType
				}
			}
		}
		Set @typeNode@("*pn") = propNames
		for ip=1:1:$LL(requireds) {
			Set @typeNode@("*rq", $LG(requireds,ip)) = 1
			
		}
	
	}
}

}
