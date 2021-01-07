Class HS.FHIR.DTL.Util.SDA3.Handler.Patient
{

/// Convert an SDA3 Name to a FHIR HumanName and give it a use of "official". This should
/// be used on the HS.SDA3.Patient:Name element, as Aliases shouldn't be "official".
ClassMethod Name(source As HS.SDA3.Name, ByRef aux) As HS.FHIR.DTL.vSTU3.Model.Datatype.HumanName
{
	set configuredFhirVersion = ##class(HS.FHIR.DTL.Util.Package).GetConfiguredSchemaName(aux("transformer").fhirVersion)
	set humanName = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Datatype.HumanName", "%New")
	set DTL = aux("transformer").GetDTL(source, "HS.FHIR.DTL.SDA3." _ configuredFhirVersion _ ".Name.HumanName")
	if DTL = "" quit ""
	$$$ThrowOnError($classmethod(DTL, "Transform", source, .humanName, .aux))
	if humanName '= "" {
		set humanName.use = "official"
	}
	quit humanName
}

/// Transform the patient's primary language into a FHIR communication BackboneElement and
/// give it a 'preferred' value of '1'.
ClassMethod PrimaryLanguage(source As HS.SDA3.CodeTableTranslated, ByRef aux) As HS.FHIR.DTL.vSTU3.Model.Element.Patient.communication
{
	set configuredFhirVersion = ##class(HS.FHIR.DTL.Util.Package).GetConfiguredSchemaName(aux("transformer").fhirVersion)
	set communication = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Element.Patient.communication", "%New")
	set language = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Datatype.CodeableConcept", "%New")
	set DTL = aux("transformer").GetDTL(source, "HS.FHIR.DTL.SDA3." _ configuredFhirVersion _ ".CodeTableTranslated.CodeableConcept")
	if DTL = "" quit ""
	$$$ThrowOnError($classmethod(DTL, "Transform", source, .language, .aux))
	if (language '= "") {
		set communication.language = language
		set communication.preferred = 1
	}
	else {
		set communication = ""
	}
	quit communication
}

/// Transform a citizenship CodeTable into a FHIR extension. This method is needed due to the unique
/// format of the hl7.org citizenship extension.
ClassMethod Citizenship(citizenship As HS.SDA3.CodeTableDetail.Citizenship, ByRef aux) As HS.FHIR.DTL.vSTU3.Model.Base.Extension
{
	set configuredFhirVersion = ##class(HS.FHIR.DTL.Util.Package).GetConfiguredSchemaName(aux("transformer").fhirVersion)
	set extension = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Base.Extension", "%New")
	set code = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Base.Extension", "%New")
	set DTL = aux("transformer").GetDTL(citizenship, "HS.FHIR.DTL.SDA3." _ configuredFhirVersion _ ".CodeTableTranslated.Extension")
	if DTL = "" quit ""
	$$$ThrowOnError($classmethod(DTL, "Transform", citizenship, .code, .aux))
	
	set code.url = "code"
	do extension.extension.Insert(code)
	
	quit extension
}

}
