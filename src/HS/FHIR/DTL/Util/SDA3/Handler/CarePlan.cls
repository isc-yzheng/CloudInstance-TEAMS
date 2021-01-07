Class HS.FHIR.DTL.Util.SDA3.Handler.CarePlan
{

/// All Intervention streamlets are first transformed to a CarePlan:activity element. Then the same is done for Outcomes.
/// After that, the activity elements are matched whenever possible by matching the Intervention ExternalId with the Outcome
/// InterventionId. Whenever that occurs, the two activity elements are merged into one. Right now there aren't any overlapping
/// mappings, but the default would be to take the value from the Outcome if there ever was any overlap.
/// interventions - The list of interventions in the CarePlan streamlet.
/// outcomes - The list of outcomes in the CarePlan streamlet.
/// target - The CarePlan resource that is in the middle of being created. New activity elements will be inserted into this resource.
/// aux - The 'aux' parameter used in all DTLs that contains, among other things, the callback
/// object.
ClassMethod Activity(interventions As %ListOfObjects, outcomes As %ListOfObjects, target As %RegisteredObject, ByRef aux) As %RegisteredObject
{
	set activities = ##class(%ListOfObjects).%New()
	set configuredFhirVersion = ##class(HS.FHIR.DTL.Util.Package).GetConfiguredSchemaName(aux("transformer").fhirVersion)
	
	//Transform all intervention streamlets
	for i=1:1:interventions.Count() {
		set activity = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Element.CarePlan.activity", "%New")
		set DTL = aux("transformer").GetDTL(interventions.GetAt(i), "HS.FHIR.DTL.SDA3." _ configuredFhirVersion _ ".Intervention.CarePlan.activity")
		if DTL = "" continue
		$$$ThrowOnError($classmethod(DTL, "Transform", interventions.GetAt(i), .activity, .aux))
		
		do activities.Insert(activity)
	}
	
	//Transform all outcome streamlets
	for i=1:1:outcomes.Count() {
		set observation = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Resource.Observation", "%New")
		set DTL = aux("transformer").GetDTL(outcomes.GetAt(i), "HS.FHIR.DTL.SDA3." _ configuredFhirVersion _ ".Outcome.Observation")
		if DTL = "" continue
		$$$ThrowOnError($classmethod(DTL, "Transform", outcomes.GetAt(i), .observation, .aux))
		set reference = aux("transformer").AddResource(outcomes.GetAt(i), observation)
		
		//Match the ExternalId of the Intervention and the InterventionId of the outcome.
		//Store the Observation in a reference within the activity created for that Intervention.
		set found = 0
		for j=1:1:interventions.Count() {
			if outcomes.GetAt(i).InterventionId = interventions.GetAt(j).ExternalId {
				do activities.GetAt(j).outcomeReference.Insert(reference)
				set found = 1
			}
		}
		//If we can't find an Intervention to match with, save it in a new activity.
		if 'found {
			set activity = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Element.CarePlan.activity", "%New")
			do activity.outcomeReference.Insert(reference)
				
			do activities.Insert(activity)
		}
	}
	
	//Put into the target resource
	for i=1:1:activities.Count() {
		if target.activity = "" {
			set target.activity = ##class(%ListOfObjects).%New()
		}
		do target.activity.Insert(activities.GetAt(i))
	}
	quit target
}

}
