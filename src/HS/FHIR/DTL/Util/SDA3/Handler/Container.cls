Class HS.FHIR.DTL.Util.SDA3.Handler.Container
{

/// Convert a Medication streamlet into the to be determined number of FHIR resources and add them to the Bundle. A Medication
/// streamet will always create a Medication resource and a MedicationRequest resource. It will also create a MedicationDispense and
/// another Medication resource if the "DrugProduct" element is not empty. And finally for each Administration in the streamlet, a
/// MedicationAdministration resource will be created. This method will call that transformation, then save the resource ids so that
/// all Medication resources can be linked together with each other after they've all been created. Then the resources are added to the
/// Bundle.
/// medication - SDA3 Medication streamlet.
/// aux - The 'aux' parameter used in all DTLs that contains, among other things, the callback
/// object.
/// target - The Bundle resource that is in the process of being created, and new resources will be added to.
ClassMethod Medication(medication As HS.SDA3.Medication, ByRef aux, ByRef target As HS.FHIR.DTL.vSTU3.Model.Resource.Bundle) As HS.FHIR.DTL.vSTU3.Model.Element.Bundle.entry
{
	set callbackObject = aux("callbackObject")
	set entry = ##class(HS.FHIR.DTL.vSTU3.Model.Element.Bundle.entry).%New()
	set tSC = ##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL("HS.FHIR.DTL.SDA3.vSTU3.Medication.Bundle.entry", medication, .entry, .aux)
	set medicationTarget = entry.resource
	
	//Find the MedicationRequest and Medication resources, assign them ids, and save the IDs for use when
	//processing the MedicationAdministration resources.
	//Background: medicationTarget will either be MedicationRequest or MedicationDispense. MedicationDispense contains
	//MedicationRequest which contains Medication.
	if medicationTarget.resourceType = "MedicationRequest" {
		if medicationTarget.id = "" {
			set id = callbackObject.AssignResourceId(medicationTarget.resourceType)
			set medicationTarget.id = id
		}
		set requestId = medicationTarget.id
		
		for k=1:1:medicationTarget.newResource.Count() {
			if medicationTarget.newResource.GetAt(k).resourceType = "Medication" {
				if medicationTarget.newResource.GetAt(k).id = "" {
					set id = callbackObject.AssignResourceId(medicationTarget.newResource.GetAt(k).resourceType)
					set medicationTarget.newResource.GetAt(k).id = id
				}
				set medicationId = medicationTarget.newResource.GetAt(k).id
				quit
			}
		}
	}
	elseif medicationTarget.resourceType = "MedicationDispense" {
		for k=1:1:medicationTarget.newResource.Count() {
			if medicationTarget.newResource.GetAt(k).resourceType = "MedicationRequest" {
				if medicationTarget.newResource.GetAt(k).id = "" {
					set id = callbackObject.AssignResourceId(medicationTarget.newResource.GetAt(k).resourceType)
					set medicationTarget.newResource.GetAt(k).id = id
				}
				set requestId = medicationTarget.newResource.GetAt(k).id
				
				for l=1:1:medicationTarget.newResource.GetAt(k).newResource.Count() {
					if medicationTarget.newResource.GetAt(k).newResource.GetAt(l).resourceType = "Medication" {
						if medicationTarget.newResource.GetAt(k).newResource.GetAt(l).id = "" {
							set id = callbackObject.AssignResourceId(medicationTarget.newResource.GetAt(k).newResource.GetAt(l).resourceType)
							set medicationTarget.newResource.GetAt(k).newResource.GetAt(l).id = id
						}
						set medicationId = medicationTarget.newResource.GetAt(k).newResource.GetAt(l).id
						
						quit
					}
				}
				quit
			}
		}
	}
	
	for j=1:1:medication.Administrations.Count() {
		set adminEntry = ##class(HS.FHIR.DTL.vSTU3.Model.Element.Bundle.entry).%New()
		set tSC = ##class(HS.FHIR.DTL.Util.Execute).ExecuteDTL("HS.FHIR.DTL.SDA3.vSTU3.Administration.Bundle.entry", medication.Administrations.GetAt(j), .adminEntry, .aux)
		
		set administration = adminEntry.resource
		
		//Add the context to the MedicationAdministration resource here, because the SDA3 Administration object doesn't use the EncounterNumber
		//property, so that context would otherwise be lost.
		if medication.EncounterNumber '= "" {
			set encounterReference = ##class(HS.FHIR.DTL.Util.SDA3.Handler.ExternalId).GetHCReference("Encounter", medication.EncounterNumber, aux("callbackObject"))
			set adminEntry.resource.context = encounterReference
		}
		if requestId '= "" {
			set requestReference = ##class(HS.FHIR.DTL.vSTU3.Model.Base.Reference).%New()
			set requestReference.reference = "MedicationRequest/" _ requestId
			set administration.prescription = requestReference
		}
		if medicationId '= "" {
			set medicationReference = ##class(HS.FHIR.DTL.vSTU3.Model.Base.Reference).%New()
			set medicationReference.reference = "Medication/" _ medicationId
			set administration.medicationReference = medicationReference
		}
		do target.entry.Insert(adminEntry)
	}
	quit entry
}

}
