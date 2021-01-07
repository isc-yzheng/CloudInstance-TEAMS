Include %occErrors

Class HS.FHIR.DTL.Mapping.Base [ Abstract ]
{

/// Class that is being transformed to FHIR extensions
Parameter SourceClass [ Abstract ];

Parameter TargetSchema [ Abstract ];

/// Type in FHIR that the extensions will be mapped to, eg. "Patient" or "Address"
Parameter FHIRTargetType [ Abstract ];

/// Generates a method which will transform the properties in <var>sdaObject</var>, which is an instance
/// of SDAExtensionClass, to FHIR extensions, which will be added to the <var>fhirTarget</var> object. 
ClassMethod Transform(sdaObject As %RegisteredObject, ByRef fhirTarget As %RegisteredObject, ByRef aux) As %RegisteredObject [ CodeMode = objectgenerator, ForceGenerate ]
{
	#dim baseClass As %Dictionary.CompiledClass = %compiledclass
	if (baseClass.Abstract) {
		quit $$$OK
	}
	
	set sourceClass = $$$comMemberKeyGet(baseClass.Name, $$$cCLASSparameter, "SourceClass", $$$cPARAMdefault)
	set targetSchema = $$$comMemberKeyGet(baseClass.Name, $$$cCLASSparameter, "TargetSchema", $$$cPARAMdefault)
	set fhirTargetType = $$$comMemberKeyGet(baseClass.Name, $$$cCLASSparameter, "FHIRTargetType", $$$cPARAMdefault)
	if (sourceClass = "") {
		$$$ThrowStatus($$$ERROR($$$GeneralError, "SourceClass parameter must be defined"))
	}
	if (targetSchema = "") {
		$$$ThrowStatus($$$ERROR($$$GeneralError, "TargetSchema parameter must be defined"))
	}
	//Get API objects to be used for this class
	set service = ##class(HS.Flash.Configuration.FHIR.Mapping.API.Service).Instance()
	if fhirTargetType '= "" {
		set mapping = service.GetMappingsByTarget(sourceClass, targetSchema, "extension", fhirTargetType)
	}
	else {
		set mapping = service.GetMappingsByTarget(sourceClass, targetSchema, "custom")
	}
	if mapping.%Size() = 0 {
		$$$ThrowStatus($$$ERROR($$$GeneralError, "No extension mappings defined for " _ sourceClass _ " to " _ fhirTargetType _ " in " _ targetSchema))
	}
	do %code.WriteLine("  try {")
	
	#dim mappingIterator As %Iterator.Array = mapping.%GetIterator()
	while mappingIterator.%GetNext(.key, .mappingEntry) {
		#dim mappingEntry As %DynamicObject
		set propertyName = mappingEntry.%Get("property_name")
		set extensionUrl = mappingEntry.%Get("extension_url")
		set fhirDatatype = mappingEntry.%Get("fhir_datatype")
		
		set sourceIsList = ($$$comMemberKeyGet(sourceClass, $$$cCLASSproperty, propertyName, $$$cPROPcollection) = "list")
		if sourceIsList {
			do %code.WriteLine("  for i=1:1:sdaObject." _ propertyName _ ".Count() {")
		}
		
		do %code.WriteLine("  set extension = ##class(HS.FHIR.DTL." _ targetSchema _ ".Model.Base.Extension).%New()")
		do %code.WriteLine("  set extension.url = """ _ extensionUrl _ """")
		
		//Check if the FHIR datatype is a primitive or complex element
		set firstChar = $extract(fhirDatatype, 1)
		set isObject = (firstChar = $zconvert(firstChar, "U"))
		
		set isReference = 0
		if fhirDatatype '= "Extension" {
			set isCustomType = 0
		}
		else {
			set isCustomType = 1
		}
		set valueProperty = "value" _ $zconvert(firstChar, "U") _ $extract(fhirDatatype, 2, *)
		
		set sdaType = $$$comMemberKeyGet(sourceClass, $$$cCLASSproperty, propertyName, $$$cPROPtype)
		if isObject {
			//If fhirDatatype is "Extension", we know a custom datatype is being mapped, and we need to look for the
			//transformation class there
			if 'isCustomType {
				set transformSourceType = $piece(sdaType, "HS.SDA3.", *)
				set transformTargetType = fhirDatatype
				
				//If we are creating a reference, the target type should be the resource that is being created
				if fhirDatatype [ "Reference" {
					set isReference = 1
					set transformTargetType = $extract($piece(fhirDatatype, "(", *), 1, *-1)
					if transformTargetType = "" {
						$$$ThrowStatus($$$ERROR($$$GeneralError, "Reference type is not defined"))
					}
				}
				
				//Find the appropriate subtransform to use for the given SDA and FHIR datatypes
				if ##class(%Dictionary.ClassDefinition).%ExistsId("HS.FHIR.DTL.SDA3." _ targetSchema _ "." _ transformSourceType _ "." _ transformTargetType) {
					set DTL = "HS.FHIR.DTL.SDA3." _ targetSchema _ "." _ transformSourceType _ "." _ transformTargetType
				}
				elseif ##class(%Dictionary.ClassDefinition).%ExistsId("HS.FHIR.DTL.SubXFrm.SDA3." _ targetSchema _ "." _ transformSourceType _ "." _ transformTargetType){
					set DTL = "HS.FHIR.DTL.SubXFrm.SDA3." _ targetSchema _ "." _ transformSourceType _ "." _ transformTargetType
				}
				elseif sdaType [ "CodeTableDetail" {
					set classDefinition = ##class(%Dictionary.ClassDefinition).%OpenId(sdaType)
					if (classDefinition.Super = "HS.SDA3.CodeTableTranslated") || (classDefinition.Super = "HS.SDA3.CodeTableDetail") {
						set sdaType = classDefinition.Super
						set transformSourceType = $piece(sdaType, "HS.SDA3.", *)
					}
					
					if ##class(%Dictionary.ClassDefinition).%ExistsId("HS.FHIR.DTL.SDA3." _ targetSchema _ "." _ transformSourceType _ "." _ transformTargetType) {
						set DTL = "HS.FHIR.DTL.SDA3." _ targetSchema _ "." _ transformSourceType _ "." _ transformTargetType
					}
					else {
						$$$ThrowStatus($$$ERROR($$$GeneralError, "Invalid extension mapping from " _ propertyName _ " in " _ sourceClass))
					}
				}
				else {
					$$$ThrowStatus($$$ERROR($$$GeneralError, "Invalid extension mapping from " _ propertyName _ " in " _ sourceClass))
				}
				
				do %code.WriteLine("  set value = ##class(" _ $classmethod(DTL, "GetTargetType") _ ").%New()")
				do %code.WriteLine("  set tSC = ##class(" _ DTL _ ").Transform(sdaObject." _ propertyName _ $case(sourceIsList, 1:".GetAt(i)", :"") _ ", .value, .aux)")
				do %code.WriteLine("  $$$ThrowOnError(tSC)")
				do %code.WriteLine("  if value '= """" { ")
				if isReference {
				  	do %code.WriteLine("    set reference=aux(""transformer"").AddResource(sdaObject." _ propertyName _ $case(sourceIsList, 1:".GetAt(i)", :"") _ ", value)")
					do %code.WriteLine("    if (reference '= """") {")
					do %code.WriteLine("    	set extension.valueReference=reference")
					do %code.WriteLine("    }")
				}
				else {
					if fhirDatatype '= "ContactPoint" {
						do %code.WriteLine("    set extension." _ valueProperty _ " = value")
					}
					else {
						do %code.WriteLine("    for j=1:1:value.Count() {")
						do %code.WriteLine("      set extension = ##class(HS.FHIR.DTL." _ targetSchema _ ".Model.Base.Extension).%New()")
						do %code.WriteLine("      set extension.url = """ _ extensionUrl _ """")
						do %code.WriteLine("      set extension." _ valueProperty _ " = value.GetAt(j)")
						do %code.WriteLine("      do fhirTarget.extension.Insert(extension)")
						do %code.WriteLine("    }")
					}
				}
				do %code.WriteLine("  }")
			}
			else {
				set DTL = "HS.FHIR.DTL.Mapping.CustomType.SDA3." _ targetSchema _ "." _ $replace(sdaType, ".", "") _ ".Extension"
				if '##class(%Dictionary.ClassDefinition).%ExistsId(DTL) {
					$$$ThrowStatus($$$ERROR($$$GeneralError, "No mappings defined for custom datatype " _ sdaType))
				}
				//do %code.WriteLine("  set value = ##class(HS.FHIR.DTL." _ targetSchema _ ".Model.Base.Extension).%New()")
				do %code.WriteLine("  lock +^HS.FHIR.DTL(""lock"", """ _ DTL _ """)")
				do %code.WriteLine("  set tSC = ##class(" _ DTL _ ").Transform(sdaObject." _ propertyName _ $case(sourceIsList, 1:".GetAt(i)", :"") _ ", .extension, .aux)")
				do %code.WriteLine("  lock -^HS.FHIR.DTL(""lock"", """ _ DTL _ """)")
			}
		}
		else {
			if ((sdaType '[ "HS.SDA3") && (sdaType '= "%Library.String")) {
				$$$ThrowStatus($$$ERROR($$$GeneralError, "Invalid extension mapping from " _ propertyName _ " in " _ sourceClass))
			}
			
			//Anything going to a string can simply be put into the target with no typecasting necessary
			if fhirDatatype = "string" {
				do %code.WriteLine("  set extension." _ valueProperty _ " = sdaObject." _ propertyName _ $case(sourceIsList, 1:".GetAt(i)", :""))
			}
			//Transform dates using a special utility
			elseif (sdaType [ "HS.SDA3.TimeStamp") {
				do %code.WriteLine("  set extension." _ valueProperty _ " = ##class(HS.FHIR.DTL.Util.Element.TypeCast).DateToFHIR(sdaObject." _ propertyName _ $case(sourceIsList, 1:".GetAt(i)", :"") _ ", """ _ fhirDatatype _ """)")
			}
			else {
				//Match the SDA type with its FHIR equivalent, if possible
				set sdaType = $case(sdaType,"HS.SDA3.Numeric":"decimal", "HS.SDA3.Boolean":"boolean", "HS.SDA3.StrippedString":"string", "%Library.String":"string", :"error")
				if (sdaType = "error") {
				    $$$ThrowStatus($$$ERROR($$$GeneralError, "Invalid extension mapping from " _ propertyName _ " in " _ sourceClass))
				}
				
				if sdaType = fhirDatatype {
					do %code.WriteLine("  set extension." _ valueProperty _ " = sdaObject." _ propertyName _ $case(sourceIsList, 1:".GetAt(i)", :""))
				}
				else {
					//If the types don't match, see if there is a typecast utility available for the pair
					set typeCastClass = ##class(%Dictionary.ClassDefinition).%OpenId("HS.FHIR.DTL.Util.Element.TypeCast")
					set method = ""
					for j=1:1:typeCastClass.Methods.Count() {
						if typeCastClass.Methods.GetAt(j).Name = (sdaType _ "TO" _ fhirDatatype) {
							set method = typeCastClass.Methods.GetAt(j).Name
							quit
						}
					}
					
					if method '= "" {
						do %code.WriteLine("  set extension." _ valueProperty _ " = ##class(HS.FHIR.DTL.Util.Element.TypeCast)." _ method _ "(sdaObject." _ propertyName _ $case(sourceIsList, 1:".GetAt(i)", :"") _ ")")
					}
					else {
						$$$ThrowStatus($$$ERROR($$$GeneralError, "Method to transform " _ sdaType _ " to " _ fhirDatatype _ " does not exist"))
					}
				}
			}
		}
		
		//References and custom types don't immediately populate the value property, so
		//we shouldn't check for its existence before inserting the extension
		if ('isReference) && ('isCustomType) {
			do %code.WriteLine("  if extension." _ valueProperty _ " '= """" {")
		}
		
		if fhirDatatype '= "ContactPoint" {
			do %code.WriteLine("    do fhirTarget.extension.Insert(extension)")
		}
		
		if ('isReference) && ('isCustomType) {
			do %code.WriteLine("  }")
		}
		
		if sourceIsList {
			do %code.WriteLine("  }")
		}
	}
	do %code.WriteLine("  } catch ex {")
	do %code.WriteLine("    lock -^HS.FHIR.DTL(""lock"", """ _ baseClass.Name _ """)")
	do %code.WriteLine("    kill parts")
	do %code.WriteLine("    do $system.Status.DecomposeStatus(ex.AsStatus(), .parts)")
	do %code.WriteLine("    if parts(1) [ ""<PROPERTY DOES NOT EXIST>"" {")
	do %code.WriteLine("      set $ze = """"")
	do %code.WriteLine("      set property = $piece($piece(parts(1), ""*"", *), "","", 1)")
	do %code.WriteLine("      $$$ThrowStatus($$$ERROR($$$GeneralError, ""Extension property '"" _ property _ ""' in "" _ sdaObject.%ClassName(1) _ "" was deleted but still has a mapping to FHIR. Delete the mapping or replace the extension property.""))")
	do %code.WriteLine("    }")
	do %code.WriteLine("    else {")
	do %code.WriteLine("      $$$ThrowStatus(ex.AsStatus())")
	do %code.WriteLine("    }")
	do %code.WriteLine("  }")
	do %code.WriteLine("  quit fhirTarget")
	
	quit $$$OK
}

}
