Class HS.FHIR.DTL.Util.Lookup
{

/// Wrapper method to get the coding system in FHIR from the SDACodingStandard field.
/// The method that is being called is the same one that was used for the SDA/vDSTU2
/// transforms.
ClassMethod GetURIForCode(identityCode As %String) As %String
{
	quit ##class(HS.FHIR.DTL.Utils).GetURIForCode(identityCode)
}

/// Given a code, check to see if it's in a known valueset. If so, return the system
/// for that valueset. Eg. "cm" is known to be in "UCUM", so "http://unitsofmeasure.org"
/// can be returned.
ClassMethod GetURIForValueSet(schema As %String, system As %String, code As %String) As %String
{
	if schema = "vR4" {
		set schema = "vSTU3"
	}
	if code '= "" {
		if $data(^HS.XF.ValueSet(schema, system, code)) {
			quit system
		}
	}
	quit ""
}

/// Wrapper method to get the SDACodingStandard from a FHIR system value.
ClassMethod GetCodeForURI(identityCode As %String) As %String
{
	quit ##class(HS.FHIR.DTL.Utils).GetCodeForURI(identityCode)
}

/// Perform a code lookup to see if the value in the source value set has a 
/// match in the target value set. If so, return that value.
/// from - The source schema, eg. "SDA3"
/// to - The target schema, eg. "vSTU3"
/// sourceValueSet - The value set for the source coded field. For FHIR, it will be the valueset. For SDA,
/// it will be the CodeTable name if it is a CodeTable object. If it's a string, it will be the element
/// name. Eg. FHIR - "allergy-clinical-status" and for SDA3 "HS.SDA3.CodeTableDetail.AllergyCategory" 
/// or "HS.SDA3.CarePlan:Status"
/// targetValueSet - same as above for the target
/// value - The coded element to be looked up. It can either be a primitive string or a coded object in
/// either schema. If it's a list, the first value to return something will be used. Both code and description
/// values will be used for the lookup as SDA3 documentation differs between which one is used.
ClassMethod Code(from As %String, to As %String, sourceValueSet As %String, targetValueSet As %String, value = "") As %String
{
	if (value = "") {
		quit ""
	}
	
	set targetCode = ""
	if $isobject(value) {
		if value.%Extends("%Collection.AbstractIterator") {
			set type = value.ElementType
		}
		else {
			set type = value.%ClassName(1)
		}
		
		//Coming from SDA3 code table
		if (type [ "CodeTableDetail") || (type [ "CodeTableTranslated") {
			set propertyList = $lb("Code", "Description")
		}
		//Coming from FHIR Coding
		elseif type [ "Coding" {
			set propertyList = $lb("code", "display")
		}
		//Coming from FHIR CodeableConcept
		elseif type [ "CodeableConcept" {
			set propertyList = $lb("code", "display")
			if 'value.%Extends("%Collection.AbstractIterator") {
				if value.coding '= "" && (value.coding.Count() > 0) {
					set value = value.coding.GetAt(1)
				}
				else {
					// Do not fall back to CodeableConcept text, as that property is mapped to OriginalText.
					quit ""
				}
			}
		}
		
		if value.%Extends("%Collection.AbstractIterator") {
			for j=1:1:value.Count() {
				set codedObject = value.GetAt(j)
				if type [ "CodeableConcept" {
					if value.GetAt(j).coding '= "" && (value.GetAt(j).coding.Count() > 0) {
						set codedObject = value.GetAt(j).coding.GetAt(1)
					} else {
						// Do not fall back to CodeableConcept text, as that property is mapped to OriginalText.
						set codedObject = ""
					}
				}
				
				if $isobject(codedObject) {
					for i=1:1:$ll(propertyList) {
						set sourceValue = $property(codedObject, $lg(propertyList, i))
						if sourceValue = "" continue
						set targetCode = $get(^HS.XF.LookupTable(from, to, sourceValueSet, targetValueSet, sourceValue), "")
						if targetCode '= "" {
							quit
						}
					}
				}
				elseif codedObject '= "" {
					set targetCode = $get(^HS.XF.LookupTable(from, to, sourceValueSet, targetValueSet, codedObject), "")
				}
				else {
					set targetCode = ""
				}
				
				if targetCode '= "" {
					quit
				}
			}
		}
		else {
			for i=1:1:$ll(propertyList) {
				set sourceValue = $property(value, $lg(propertyList, i))
				if sourceValue = "" continue
				set targetCode = $get(^HS.XF.LookupTable(from, to, sourceValueSet, targetValueSet, sourceValue), "")
				if targetCode '= "" {
					quit
				}
			}
		}
	}
	else {
		set targetCode = $get(^HS.XF.LookupTable(from, to, sourceValueSet, targetValueSet, value), "")
	}
	quit targetCode
}

/// Looks to see if the reference type that is being provided is one of the accepted reference types in the
/// given schema. Used to transform between STU3 and DSTU2.
ClassMethod Reference(schema As %String, path As %String, reference As %RegisteredObject) As %Boolean
{
	set list = $get(^HS.XF.ReferenceType(schema, path), "")
	
	if ($isobject(reference) && reference.%Extends("%Collection.AbstractIterator")) {
		set referenceTypes = $lb("")
		for i=1:1:reference.Count() {
			if reference.GetAt(i).reference [ "#" return 1
			set referenceString = ##class(HS.FHIR.DTL.Util.FHIR.Handler.Reference).ConvertResourceType($select(schema="vSTU3":"vDSTU2",1:"vSTU3"), schema, reference.GetAt(i).reference)
			set referenceType = $piece(referenceString, "/", *-1)
			set referenceTypes = $lu(referenceTypes, $ll(referenceTypes) + 1, referenceType)
		}
		set found = 0
		for i=1:1:$listlength(referenceTypes) {
			for j=1:1:$listlength(list) {
				if $listget(list, j) = $listget(referenceTypes, i) {
					set found = 1
					quit
				}
				if $listget(list, j) = "*" {
					return 1
				}
			}
			if found quit
		}
		quit found
	}
	else {
		if reference.reference [ "#" quit 1
		set referenceString = ##class(HS.FHIR.DTL.Util.FHIR.Handler.Reference).ConvertResourceType($select(schema="vSTU3":"vDSTU2",1:"vSTU3"), schema, reference.reference)
		set referenceType = $piece(referenceString, "/", *-1)
		
		for i=1:1:$listlength(list) {
			if $listget(list, i) = "*" {
				return 1
			}
			if $listget(list, i) = referenceType {
				return 1
			}
		}
	}
	quit 0
}

/// Used to save a value in the 'aux' parameter if it's needed in a subtransformation
/// and won't be accessible otherwise.
ClassMethod SaveValueToAux(index As %String, value As %String, ByRef aux) As %String
{
	set aux(index) = value
	quit ""
}

/// Used to fetch a value from the 'aux' parameter that was saved with SaveValueToAux.
ClassMethod GetValueFromAux(index As %String, ByRef aux) As %String
{
	quit $get(aux(index))
}

/// Return the target(s) within a schema for a given class.
/// sourceClass - The class being transformed, eg. "HS.SDA3.Patient"
/// sourceSchema - The schema of the class being transformed, eg. "SDA3"
/// targetSchema - The schema being transformed to, eg. "vSTU3"
/// returns {"vSTU3":["HS.FHIR.DTL.vSTU3.Model.Resource.Patient"]}
ClassMethod GetTargetClasses(sourceClass As %String, sourceSchema As %String, targetSchema As %String = "") As %DynamicObject
{
	if sourceSchema '= "SDA3" {
		if sourceClass [ ".Element." {
			set sourceClass = $piece(sourceClass, ".", *-1, *)
		}
		else {
			set sourceClass = $piece(sourceClass, ".", *)
		}
	}
	
	set output = {}
	set getAll = 0
	if targetSchema = "" {
		set getAll = 1
		set targetSchema = $order(^HS.XF.Transform(sourceSchema, ""))
	}
	
	while targetSchema '= "" {
		set schemaTargets = []
		
		set targetDTL = $order(^HS.XF.Transform(sourceSchema, targetSchema, sourceClass, ""))
		
		//For generic code tables (eg. HS.SDA3.CodeTableDetail.City) that have identical properties,
		//they all share the same transform. Therefore, we need to get the targets for those transforms instead.
		if (targetDTL = "") && (sourceClass [ "HS.SDA3.CodeTableDetail") {
			set classDefinition = ##class(%Dictionary.ClassDefinition).%OpenId(sourceClass)
			if (classDefinition.Super = "HS.SDA3.CodeTableTranslated") || (classDefinition.Super = "HS.SDA3.CodeTableDetail") {
				set sourceClass = classDefinition.Super
				set targetDTL = $order(^HS.XF.Transform(sourceSchema, targetSchema, sourceClass, ""))
			}
		}
		while targetDTL '= "" {
			set targetClass = $classmethod(targetDTL, "GetTargetType")
			do schemaTargets.%Push(targetClass)
			set targetDTL = $order(^HS.XF.Transform(sourceSchema, targetSchema, sourceClass, targetDTL))
		}
		
		//Also include targets only possible to create through non-generated subtransformations
		set sourceClassShort = $piece(sourceClass, "HS.SDA3.", *)
		set subTransformClass = "HS.FHIR.DTL.SubXFrm." _ sourceSchema _ "." _ targetSchema _ "." _ sourceClassShort
		for {
			//Quit once we've reached classes outside of HS.FHIR.DTL.SubXFrm
			set subTransformClass = $$$comClassNext(subTransformClass)
			if subTransformClass '[ ("HS.FHIR.DTL.SubXFrm." _ sourceSchema _ "." _ targetSchema _ "." _ sourceClassShort) quit
			
			set targetClass = $classmethod(subTransformClass, "GetTargetType")
			do schemaTargets.%Push(targetClass)
		}
		
		do output.%Set(targetSchema, schemaTargets)
		if getAll {
			set targetSchema = $order(^HS.XF.Transform(sourceSchema, targetSchema))
		}
		else {
			quit
		}
	}
	return output
}

/// Return list of FHIR data types supported via transformation code for a given SDA data type
ClassMethod GetFHIRDataTypes(sourceDataType As %String) As %List
{
	set targetList = ""
	if (sourceDataType = "HS.SDA3.Numeric") {
		set targetList = targetList _ $listbuild("decimal") _ $listbuild("string")
	}
	elseif (sourceDataType = "HS.SDA3.Boolean") {
		set targetList = targetList _ $listbuild("boolean") _ $listbuild("string")
	}
	elseif (sourceDataType = "HS.SDA3.TimeStamp") {
		set targetList = targetList _ $listbuild("date") _ $listbuild("dateTime") _ $listbuild("time") _ $listbuild("instant") _ $listbuild("string")
	}
	elseif (sourceDataType = "%Library.String") || (sourceDataType = "HS.SDA3.StrippedString") || (sourceDataType = "HS.SDA3.Date") {
		set targetList = targetList _ $listbuild("string")
	}
	quit targetList
}

}
