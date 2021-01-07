Class HS.FHIR.DTL.Util.SDA3.Handler.Order
{

/// Save an SDA3 placer id as a FHIR Identifier, giving it the proper 'type' value.
ClassMethod PlacerId(source As %String, ByRef aux) As %RegisteredObject
{
	set configuredFhirVersion = ##class(HS.FHIR.DTL.Util.Package).GetConfiguredSchemaName(aux("transformer").fhirVersion)
	set packageModel = ##class(HS.FHIR.DTL.Util.Package).GetConfiguredPackageModelName(aux("transformer").fhirVersion)
	if (packageModel = "") quit
	set target = $classmethod(packageModel _ ".Datatype.Identifier", "%New")
	set target.value = source
	set target.use = "official"
	set target.type = $classmethod(packageModel _ ".Datatype.CodeableConcept", "%New")
	set target.type.text = "PlacerId"
	set coding = $classmethod(packageModel _ ".Datatype.Coding", "%New")
	set coding.display = "Placer Identifier"
	if configuredFhirVersion = "vSTU3" {
		set coding.system = "http://hl7.org/fhir/identifier-type"
	} else {
		set coding.system = "http://terminology.hl7.org/CodeSystem/v2-0203"
	}
	set coding.code = "PLAC"
	do target.type.coding.Insert(coding)
	
	quit target
}

/// Save an SDA3 filler id as a FHIR identifier, giving it the proper 'type' value
ClassMethod FillerId(source As %String, ByRef aux) As %RegisteredObject
{
	set configuredFhirVersion = ##class(HS.FHIR.DTL.Util.Package).GetConfiguredSchemaName(aux("transformer").fhirVersion)
	set packageModel = ##class(HS.FHIR.DTL.Util.Package).GetConfiguredPackageModelName(aux("transformer").fhirVersion)
	if (packageModel = "") quit
	set target = $classmethod(packageModel _ ".Datatype.Identifier", "%New")
	set target.value = source
	set target.use = "official"
	set target.type = $classmethod(packageModel _ ".Datatype.CodeableConcept", "%New")
	set target.type.text = "FillerId"
	set coding = $classmethod(packageModel _ ".Datatype.Coding", "%New")
	set coding.display = "Filler Identifier"
	if configuredFhirVersion = "vSTU3" {
		set coding.system = "http://hl7.org/fhir/identifier-type"
	} else {
		set coding.system = "http://terminology.hl7.org/CodeSystem/v2-0203"
	}
	set coding.code = "FILL"
	do target.type.coding.Insert(coding)
	
	quit target
}

ClassMethod Clinician(clinician As %RegisteredObject, ByRef aux) As %RegisteredObject
{
	set configuredFhirVersion = ##class(HS.FHIR.DTL.Util.Package).GetConfiguredSchemaName((aux("transformer").fhirVersion))
	set performer = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Element.DiagnosticReport.performer", "%New")
	
	set practitioner = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Resource.Practitioner", "%New")
	set DTL = aux("transformer").GetDTL(clinician, "HS.FHIR.DTL.SDA3." _ configuredFhirVersion _ ".CodeTableDetail.CareProvider.Practitioner")
	if DTL = "" quit ""
	$$$ThrowOnError($classmethod(DTL, "Transform", clinician, .practitioner, .aux))
	
	set reference = aux("transformer").AddResource(clinician, practitioner)
	set performer.actor = reference
	
 	quit performer
}

}
