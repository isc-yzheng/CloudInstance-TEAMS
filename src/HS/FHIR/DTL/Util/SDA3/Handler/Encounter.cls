Class HS.FHIR.DTL.Util.SDA3.Handler.Encounter
{

/// Transforms a clinician from the Encounter streamlet into a practitioner in the Encounter resource. Will add the type
/// to the practitioner based on <var>type</var>.
ClassMethod Clinician(clinician As %RegisteredObject, type As %String, ByRef aux) As %RegisteredObject
{
	set configuredFhirVersion = ##class(HS.FHIR.DTL.Util.Package).GetConfiguredSchemaName((aux("transformer").fhirVersion))
	set participant = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Element.Encounter.participant", "%New")
	
	set practitioner = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Resource.Practitioner", "%New")
	if clinician.%ClassName() = "CareProvider" {
		set DTL = aux("transformer").GetDTL(clinician, "HS.FHIR.DTL.SDA3." _ configuredFhirVersion _ ".CodeTableDetail.CareProvider.Practitioner")
	}
	elseif clinician.%ClassName() = "ReferralDoctor" {
		set DTL = aux("transformer").GetDTL(clinician, "HS.FHIR.DTL.SDA3." _ configuredFhirVersion _ ".CodeTableDetail.ReferralDoctor.Practitioner")
	}
	else {
		return ""
	}
	if DTL = "" quit ""
	$$$ThrowOnError($classmethod(DTL, "Transform", clinician, .practitioner, .aux))
	
	set reference = aux("transformer").AddResource(clinician, practitioner)
	set participant.individual = reference
	
	set participantType = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Datatype.CodeableConcept", "%New")
	set participantCoding = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Datatype.Coding", "%New")
	set participantCoding.code = type
	set display = $select(type="ADM":"admitter",type="ATND":"attender",type="CON":"consultant",type="REF":"referrer",1:"")
	set participantCoding.display = display
	if display '= "" {
		if configuredFhirVersion = "vSTU3" {
			set participantCoding.system = "http://hl7.org/fhir/v3/ParticipationType"
		}
		else {
			set participantCoding.system = "http://terminology.hl7.org/CodeSystem/v3-ParticipationType"
		}
	}
	set participantType.text = display
	do participantType.coding.Insert(participantCoding)
	
	do participant.type.Insert(participantType)
	
 	quit participant
}

}
