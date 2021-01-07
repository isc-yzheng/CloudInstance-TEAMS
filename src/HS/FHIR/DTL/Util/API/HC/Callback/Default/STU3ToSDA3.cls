Class HS.FHIR.DTL.Util.API.HC.Callback.Default.STU3ToSDA3 Extends HS.FHIR.DTL.Util.API.HC.Callback.Abstract.STU3ToSDA3
{

Property encounterNumber As %String;

Property externalId As %String [ MultiDimensional ];

/// Increment for each unique Encounter, starting
/// at 1. Values are saved in the encounterNumber
/// class property.
Method AssignEncounterNumber() As %String
{
	if ..encounterNumber = "" {
		set ..encounterNumber = 0
	}
	set ..encounterNumber = ..encounterNumber + 1
	quit ..encounterNumber
}

/// Increment for each unique streamlet, starting
/// at 1. Values are saved in the externalId
/// class property, indexed by streamletType.
Method AssignExternalId(streamletType As %String) As %String
{
	if $get(..externalId(streamletType)) = "" {
		set ..externalId(streamletType) = 0
	}
	set ..externalId(streamletType) = ..externalId(streamletType) + 1
	quit ..externalId(streamletType)
}

/// Use the code for the Patient managingOrganization if the reference exists
/// and the Organization is in the Bundle. Otherwise, parse through the Patient
/// identifiers looking for an MRN. If one can be found that has an assigner
/// included in the bundle, use that assigner's code.
/// If none can be found, the string "FHIR" will be used.
Method GetSendingFacility(bundle As HS.FHIR.DTL.vSTU3.Model.Resource.Bundle, ByRef aux) As %String
{
	set patient = $get(aux("bundleIndex", "Patient"))
	if '$isobject(patient) quit "FHIR"
	
	if patient.managingOrganization '= "" {
		set sendingFacility = ..GetSendingFacilityFromReference(patient.managingOrganization, patient, .aux)
		if sendingFacility '= "" {
			quit sendingFacility
		}
	}
	else {
		for i=1:1:patient.identifier.Count() {
			if (patient.identifier.GetAt(i).type '= "") && (patient.identifier.GetAt(i).type.coding.Count() > 0) && (patient.identifier.GetAt(i).type.coding.GetAt(1).code = "MR") {
				if patient.identifier.GetAt(i).assigner '= "" {
					set sendingFacility = ..GetSendingFacilityFromReference(patient.identifier.GetAt(i).assigner, patient, .aux)
					if sendingFacility '= "" {
						return sendingFacility
					}
				}
			}
		}
	}
	
	quit "FHIR"
}

ClassMethod GetSendingFacilityFromReference(reference As HS.FHIR.DTL.vSTU3.Model.Base.Reference, currentResource As HS.FHIR.DTL.vSTU3.Model.Base.Resource, ByRef aux) As %String
{
	if reference.reference '= "" {
		set tSC = ##class(HS.FHIR.DTL.Util.FHIR.Handler.Reference).FindReferenceResource(reference.reference, currentResource, .organization, .aux)
		$$$ThrowOnError(tSC)
		
		if organization '= "" {
			for i=1:1:organization.identifier.Count() {
				if organization.identifier.GetAt(i).value '= "" {
					return organization.identifier.GetAt(i).value
				}
			}
			
			if organization.name '= "" {
				quit organization.name
			}
		}
	}
	if reference.display '= "" {
		quit reference.display
	}
	quit ""
}

}
