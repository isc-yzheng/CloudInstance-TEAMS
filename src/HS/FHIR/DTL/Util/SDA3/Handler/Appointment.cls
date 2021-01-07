Class HS.FHIR.DTL.Util.SDA3.Handler.Appointment
{

/// Transforms a clinician from the Encounter streamlet into a practitioner in the Encounter resource. Will add the
/// status as "accepted".
/// actor - SDA3 CodeTable object that will either be a CareProvider or HealthCareFacility.
/// target - The Encounter resource being created, which will contain the references to the Practitioner or Location resources
/// aux - The 'aux' parameter used in all DTLs that contains, among other things, the callback
/// object.
ClassMethod participant(actor As %RegisteredObject, target As %RegisteredObject, ByRef aux) As HS.FHIR.DTL.vSTU3.Model.Element.Appointment.participant
{
	set configuredFhirVersion = ##class(HS.FHIR.DTL.Util.Package).GetConfiguredSchemaName(aux("transformer").fhirVersion)
	set participant = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Element.Appointment.participant", "%New")
	
	if actor.%ClassName() = "CareProvider" {
		set practitioner = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Resource.Practitioner", "%New")
		set DTL = aux("transformer").GetDTL(actor, "HS.FHIR.DTL.SDA3." _ configuredFhirVersion _ ".CodeTableDetail.CareProvider.Practitioner")
	}
	elseif actor.%ClassName() = "HealthCareFacility" {
		set practitioner = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Resource.Location", "%New")
		set DTL = aux("transformer").GetDTL(actor, "HS.FHIR.DTL.SDA3." _ configuredFhirVersion _ ".CodeTableDetail.HealthCareFacility.Location")
	}
	if DTL = "" quit ""
	$$$ThrowOnError($classmethod(DTL, "Transform", actor, .practitioner, .aux))
	
	set reference = aux("transformer").AddResource(actor, practitioner)
	
	set participant.actor = reference
	set participant.status = "accepted"
	
 	quit participant
}

/// Add the current Patient to the list of participants of an Appointment resource and set the status to "accepted".
ClassMethod Patient(ByRef aux) As HS.FHIR.DTL.vSTU3.Model.Element.Appointment.participant
{
	set configuredFhirVersion = ##class(HS.FHIR.DTL.Util.Package).GetConfiguredSchemaName(aux("transformer").fhirVersion)
	set participant = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Element.Appointment.participant", "%New")
	set participant.actor = aux("transformer").GetPatientReference()
	set participant.status = "accepted"
	
	return participant
}

}
