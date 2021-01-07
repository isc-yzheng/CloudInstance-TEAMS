Class HS.FHIR.DTL.Util.SDA3.Handler.MedicalClaim
{

/// This method is needed to ensure the sequence numbers for the list of diagnoses is accurate and puts the principal
/// diagnosis first.
ClassMethod Diagnosis(diagnosis As HS.SDA3.CodeTableDetail.Diagnosis, isPrincipal As %Boolean, diagnosisList As %ListOfObjects, ByRef aux) As HS.FHIR.DTL.vSTU3.Model.Element.Claim.diagnosis
{
	set configuredFhirVersion = ##class(HS.FHIR.DTL.Util.Package).GetConfiguredSchemaName(aux("transformer").fhirVersion)
	set target = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Element.Claim.diagnosis", "%New")
	set diagnosisCodeableConcept = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Datatype.CodeableConcept", "%New")
	set DTL = aux("transformer").GetDTL(diagnosis, "HS.FHIR.DTL.SDA3." _ configuredFhirVersion _ ".CodeTableTranslated.CodeableConcept")
	if DTL = "" quit ""
	$$$ThrowOnError($classmethod(DTL, "Transform", diagnosis, .diagnosisCodeableConcept, .aux))
	
	if isPrincipal {
		set target.sequence = 1
	}
	else {
		set target.sequence = diagnosisList.Count() + 2
	}
	set target.diagnosisCodeableConcept = diagnosisCodeableConcept
	
	quit target
}

/// This method is needed to ensure the sequence numbers for the list of procedures is accurate.
ClassMethod Procedure(procedure As HS.SDA3.CodeTableDetail.Procedure, claim As HS.FHIR.DTL.vSTU3.Model.Resource.Claim) As HS.FHIR.DTL.vSTU3.Model.Element.Claim.procedure
{
	set configuredFhirVersion = ##class(HS.FHIR.DTL.Util.Package).GetConfiguredSchemaFromClassname($classname(claim))
	set target = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Element.Claim.procedure", "%New")
	set procedureCodeableConcept = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Datatype.CodeableConcept", "%New")
	set DTL = aux("transformer").GetDTL(procedure, "HS.FHIR.DTL.SDA3." _ configuredFhirVersion _ ".CodeTableTranslated.CodeableConcept")
	if DTL = "" quit ""
	$$$ThrowOnError($classmethod(DTL, "Transform", procedure, .procedureCodeableConcept, .aux))
	
	set target.sequence = claim.procedure.Count() + 1
	set target.procedureCodeableConcept = procedureCodeableConcept
	
	quit target
}

/// This method is needed to ensure the sequence numbers for the list of Claim items is accurate.
ClassMethod MedicalClaimLine(medicalClaimLine As HS.SDA3.MedicalClaimLine, claim As HS.FHIR.DTL.vSTU3.Model.Resource.Claim, ByRef aux) As HS.FHIR.DTL.vSTU3.Model.Element.Claim.item
{
	set configuredFhirVersion = ##class(HS.FHIR.DTL.Util.Package).GetConfiguredSchemaFromClassname($classname(claim))
	set item = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Element.Claim.item", "%New")
	set DTL = aux("transformer").GetDTL(medicalClaimLine, "HS.FHIR.DTL.SDA3." _ configuredFhirVersion _ ".MedicalClaimLine.Claim.item")
	if DTL = "" quit ""
	$$$ThrowOnError($classmethod(DTL, "Transform", medicalClaimLine, .item, .aux))
	
	set item.sequence = claim.item.Count() + 1
	
	quit item
}

ClassMethod MedicalClaimLineToInsurance(claim, target, ByRef aux)
{
	set configuredFhirVersion = ##class(HS.FHIR.DTL.Util.Package).GetConfiguredSchemaName(aux("transformer").fhirVersion)
	set count = 0
	for i=1:1:claim.MedicalClaimLines.Count() {
		for j=1:1:claim.MedicalClaimLines.GetAt(i).HealthFunds.Count() {
			set healthfund = claim.MedicalClaimLines.GetAt(i).HealthFunds.GetAt(j)
			set insurance = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Element.Claim.insurance", "%New")
			set coverage = $classmethod("HS.FHIR.DTL." _ configuredFhirVersion _ ".Model.Resource.Coverage", "%New")
			set DTL = aux("transformer").GetDTL(healthfund, "HS.FHIR.DTL.SDA3." _ configuredFhirVersion _ ".HealthFund.Coverage")
			if DTL = "" continue
			$$$ThrowOnError($classmethod(DTL, "Transform", healthfund, .coverage, .aux))
			set reference = aux("transformer").AddResource(healthfund, coverage)
			
			set insurance.sequence = $i(count)
			set insurance.focal = 0
			set insurance.coverage = reference
			
	 		do target.insurance.Insert(insurance)
		}
	}
	
	return target
}

}
