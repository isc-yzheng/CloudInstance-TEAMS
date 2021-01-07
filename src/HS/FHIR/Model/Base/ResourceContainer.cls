/// *** <b>THIS CLASS IS DEPRECATED.</b> Please use HS.FHIR.<b>vDSTU2.</b>Model.Base.ResourceContainer when working with FHIR DSTU2.
Class HS.FHIR.Model.Base.ResourceContainer Extends HS.FHIR.Model.Base.AbstractBase [ Deprecated, ProcedureBlock ]
{

///  
Parameter JSONTYPEFIELD;

///  
Parameter ELEMENTQUALIFIED = 1;

///  
Parameter XMLNAME = "ResourceContainer";

///  
Parameter XMLSEQUENCE = 0;

///  
Property Account As HS.FHIR.Model.Resource.Account(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Account", XMLREF = 1);

///  
Property AllergyIntolerance As HS.FHIR.Model.Resource.AllergyIntolerance(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "AllergyIntolerance", XMLREF = 1);

///  
Property Appointment As HS.FHIR.Model.Resource.Appointment(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Appointment", XMLREF = 1);

///  
Property AppointmentResponse As HS.FHIR.Model.Resource.AppointmentResponse(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "AppointmentResponse", XMLREF = 1);

///  
Property AuditEvent As HS.FHIR.Model.Resource.AuditEvent(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "AuditEvent", XMLREF = 1);

///  
Property Basic As HS.FHIR.Model.Resource.Basic(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Basic", XMLREF = 1);

///  
Property Binary As HS.FHIR.Model.Resource.Binary(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Binary", XMLREF = 1);

///  
Property BodySite As HS.FHIR.Model.Resource.BodySite(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "BodySite", XMLREF = 1);

///  
Property Bundle As HS.FHIR.Model.Resource.Bundle(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Bundle", XMLREF = 1);

///  
Property CarePlan As HS.FHIR.Model.Resource.CarePlan(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "CarePlan", XMLREF = 1);

///  
Property Claim As HS.FHIR.Model.Resource.Claim(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Claim", XMLREF = 1);

///  
Property ClaimResponse As HS.FHIR.Model.Resource.ClaimResponse(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "ClaimResponse", XMLREF = 1);

///  
Property ClinicalImpression As HS.FHIR.Model.Resource.ClinicalImpression(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "ClinicalImpression", XMLREF = 1);

///  
Property Communication As HS.FHIR.Model.Resource.Communication(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Communication", XMLREF = 1);

///  
Property CommunicationRequest As HS.FHIR.Model.Resource.CommunicationRequest(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "CommunicationRequest", XMLREF = 1);

///  
Property Composition As HS.FHIR.Model.Resource.Composition(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Composition", XMLREF = 1);

///  
Property ConceptMap As HS.FHIR.Model.Resource.ConceptMap(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "ConceptMap", XMLREF = 1);

///  
Property Condition As HS.FHIR.Model.Resource.Condition(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Condition", XMLREF = 1);

///  
Property Conformance As HS.FHIR.Model.Resource.Conformance(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Conformance", XMLREF = 1);

///  
Property Contract As HS.FHIR.Model.Resource.Contract(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Contract", XMLREF = 1);

///  
Property Coverage As HS.FHIR.Model.Resource.Coverage(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Coverage", XMLREF = 1);

///  
Property DataElement As HS.FHIR.Model.Resource.DataElement(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "DataElement", XMLREF = 1);

///  
Property DetectedIssue As HS.FHIR.Model.Resource.DetectedIssue(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "DetectedIssue", XMLREF = 1);

///  
Property Device As HS.FHIR.Model.Resource.Device(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Device", XMLREF = 1);

///  
Property DeviceComponent As HS.FHIR.Model.Resource.DeviceComponent(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "DeviceComponent", XMLREF = 1);

///  
Property DeviceMetric As HS.FHIR.Model.Resource.DeviceMetric(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "DeviceMetric", XMLREF = 1);

///  
Property DeviceUseRequest As HS.FHIR.Model.Resource.DeviceUseRequest(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "DeviceUseRequest", XMLREF = 1);

///  
Property DeviceUseStatement As HS.FHIR.Model.Resource.DeviceUseStatement(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "DeviceUseStatement", XMLREF = 1);

///  
Property DiagnosticOrder As HS.FHIR.Model.Resource.DiagnosticOrder(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "DiagnosticOrder", XMLREF = 1);

///  
Property DiagnosticReport As HS.FHIR.Model.Resource.DiagnosticReport(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "DiagnosticReport", XMLREF = 1);

///  
Property DocumentManifest As HS.FHIR.Model.Resource.DocumentManifest(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "DocumentManifest", XMLREF = 1);

///  
Property DocumentReference As HS.FHIR.Model.Resource.DocumentReference(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "DocumentReference", XMLREF = 1);

///  
Property EligibilityRequest As HS.FHIR.Model.Resource.EligibilityRequest(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "EligibilityRequest", XMLREF = 1);

///  
Property EligibilityResponse As HS.FHIR.Model.Resource.EligibilityResponse(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "EligibilityResponse", XMLREF = 1);

///  
Property Encounter As HS.FHIR.Model.Resource.Encounter(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Encounter", XMLREF = 1);

///  
Property EnrollmentRequest As HS.FHIR.Model.Resource.EnrollmentRequest(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "EnrollmentRequest", XMLREF = 1);

///  
Property EnrollmentResponse As HS.FHIR.Model.Resource.EnrollmentResponse(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "EnrollmentResponse", XMLREF = 1);

///  
Property EpisodeOfCare As HS.FHIR.Model.Resource.EpisodeOfCare(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "EpisodeOfCare", XMLREF = 1);

///  
Property ExplanationOfBenefit As HS.FHIR.Model.Resource.ExplanationOfBenefit(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "ExplanationOfBenefit", XMLREF = 1);

///  
Property FamilyMemberHistory As HS.FHIR.Model.Resource.FamilyMemberHistory(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "FamilyMemberHistory", XMLREF = 1);

///  
Property Flag As HS.FHIR.Model.Resource.Flag(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Flag", XMLREF = 1);

///  
Property Goal As HS.FHIR.Model.Resource.Goal(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Goal", XMLREF = 1);

///  
Property Group As HS.FHIR.Model.Resource.Group(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Group", XMLREF = 1) [ SqlFieldName = _Group ];

///  
Property HealthcareService As HS.FHIR.Model.Resource.HealthcareService(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "HealthcareService", XMLREF = 1);

///  
Property ImagingObjectSelection As HS.FHIR.Model.Resource.ImagingObjectSelection(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "ImagingObjectSelection", XMLREF = 1);

///  
Property ImagingStudy As HS.FHIR.Model.Resource.ImagingStudy(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "ImagingStudy", XMLREF = 1);

///  
Property Immunization As HS.FHIR.Model.Resource.Immunization(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Immunization", XMLREF = 1);

///  
Property ImmunizationRecommendation As HS.FHIR.Model.Resource.ImmunizationRecommendation(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "ImmunizationRecommendation", XMLREF = 1);

///  
Property ImplementationGuide As HS.FHIR.Model.Resource.ImplementationGuide(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "ImplementationGuide", XMLREF = 1);

///  
Property List As HS.FHIR.Model.Resource.List(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "List", XMLREF = 1);

///  
Property Location As HS.FHIR.Model.Resource.Location(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Location", XMLREF = 1);

///  
Property Media As HS.FHIR.Model.Resource.Media(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Media", XMLREF = 1);

///  
Property Medication As HS.FHIR.Model.Resource.Medication(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Medication", XMLREF = 1);

///  
Property MedicationAdministration As HS.FHIR.Model.Resource.MedicationAdministration(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "MedicationAdministration", XMLREF = 1);

///  
Property MedicationDispense As HS.FHIR.Model.Resource.MedicationDispense(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "MedicationDispense", XMLREF = 1);

///  
Property MedicationOrder As HS.FHIR.Model.Resource.MedicationOrder(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "MedicationOrder", XMLREF = 1);

///  
Property MedicationStatement As HS.FHIR.Model.Resource.MedicationStatement(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "MedicationStatement", XMLREF = 1);

///  
Property MessageHeader As HS.FHIR.Model.Resource.MessageHeader(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "MessageHeader", XMLREF = 1);

///  
Property NamingSystem As HS.FHIR.Model.Resource.NamingSystem(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "NamingSystem", XMLREF = 1);

///  
Property NutritionOrder As HS.FHIR.Model.Resource.NutritionOrder(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "NutritionOrder", XMLREF = 1);

///  
Property Observation As HS.FHIR.Model.Resource.Observation(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Observation", XMLREF = 1);

///  
Property OperationDefinition As HS.FHIR.Model.Resource.OperationDefinition(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "OperationDefinition", XMLREF = 1);

///  
Property OperationOutcome As HS.FHIR.Model.Resource.OperationOutcome(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "OperationOutcome", XMLREF = 1);

///  
Property Order As HS.FHIR.Model.Resource.Order(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Order", XMLREF = 1);

///  
Property OrderResponse As HS.FHIR.Model.Resource.OrderResponse(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "OrderResponse", XMLREF = 1);

///  
Property Organization As HS.FHIR.Model.Resource.Organization(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Organization", XMLREF = 1);

///  
Property Patient As HS.FHIR.Model.Resource.Patient(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Patient", XMLREF = 1);

///  
Property PaymentNotice As HS.FHIR.Model.Resource.PaymentNotice(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "PaymentNotice", XMLREF = 1);

///  
Property PaymentReconciliation As HS.FHIR.Model.Resource.PaymentReconciliation(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "PaymentReconciliation", XMLREF = 1);

///  
Property Person As HS.FHIR.Model.Resource.Person(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Person", XMLREF = 1);

///  
Property Practitioner As HS.FHIR.Model.Resource.Practitioner(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Practitioner", XMLREF = 1);

///  
Property Procedure As HS.FHIR.Model.Resource.Procedure(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Procedure", XMLREF = 1) [ SqlFieldName = _Procedure ];

///  
Property ProcedureRequest As HS.FHIR.Model.Resource.ProcedureRequest(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "ProcedureRequest", XMLREF = 1);

///  
Property ProcessRequest As HS.FHIR.Model.Resource.ProcessRequest(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "ProcessRequest", XMLREF = 1);

///  
Property ProcessResponse As HS.FHIR.Model.Resource.ProcessResponse(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "ProcessResponse", XMLREF = 1);

///  
Property Provenance As HS.FHIR.Model.Resource.Provenance(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Provenance", XMLREF = 1);

///  
Property Questionnaire As HS.FHIR.Model.Resource.Questionnaire(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Questionnaire", XMLREF = 1);

///  
Property QuestionnaireResponse As HS.FHIR.Model.Resource.QuestionnaireResponse(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "QuestionnaireResponse", XMLREF = 1);

///  
Property ReferralRequest As HS.FHIR.Model.Resource.ReferralRequest(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "ReferralRequest", XMLREF = 1);

///  
Property RelatedPerson As HS.FHIR.Model.Resource.RelatedPerson(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "RelatedPerson", XMLREF = 1);

///  
Property RiskAssessment As HS.FHIR.Model.Resource.RiskAssessment(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "RiskAssessment", XMLREF = 1);

///  
Property Schedule As HS.FHIR.Model.Resource.Schedule(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Schedule", XMLREF = 1);

///  
Property SearchParameter As HS.FHIR.Model.Resource.SearchParameter(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "SearchParameter", XMLREF = 1);

///  
Property Slot As HS.FHIR.Model.Resource.Slot(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Slot", XMLREF = 1);

///  
Property Specimen As HS.FHIR.Model.Resource.Specimen(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Specimen", XMLREF = 1);

///  
Property StructureDefinition As HS.FHIR.Model.Resource.StructureDefinition(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "StructureDefinition", XMLREF = 1);

///  
Property Subscription As HS.FHIR.Model.Resource.Subscription(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Subscription", XMLREF = 1);

///  
Property Substance As HS.FHIR.Model.Resource.Substance(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Substance", XMLREF = 1);

///  
Property SupplyDelivery As HS.FHIR.Model.Resource.SupplyDelivery(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "SupplyDelivery", XMLREF = 1);

///  
Property SupplyRequest As HS.FHIR.Model.Resource.SupplyRequest(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "SupplyRequest", XMLREF = 1);

///  
Property TestScript As HS.FHIR.Model.Resource.TestScript(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "TestScript", XMLREF = 1);

///  
Property ValueSet As HS.FHIR.Model.Resource.ValueSet(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "ValueSet", XMLREF = 1);

///  
Property VisionPrescription As HS.FHIR.Model.Resource.VisionPrescription(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "VisionPrescription", XMLREF = 1);

///  
Property Parameters As HS.FHIR.Model.Resource.Parameters(REFELEMENTQUALIFIED = 1, REFNAMESPACE = "http://hl7.org/fhir", XMLNAME = "Parameters", XMLREF = 1);

///  
Method %OnNew(pResource As HS.FHIR.Model.Base.Resource) As %Status
{
	Set tSC = $$$OK
	Try {
		If ($Data(pResource)=0) Quit
		Set tSC = ..SetResource(pResource)
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method SetResource(pResource As HS.FHIR.Model.Base.Resource) As %Status
{
	Set tSC = $$$OK
	Try {
		If ($Data(pResource)=0) Quit
		Set $Property($this, pResource.%ClassName()) = pResource
		Set tSC = ..%ValidateObject()
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  
Method GetResourceType() As %String [ CodeMode = objectgenerator ]
{
	Set tSkipList("%Concurrency") = 1
	
	#; Designate the more commonly used resource types to be checked first.
	Set i = 0
	If $i(i) Set tPreList(i) = "Patient"
	If $i(i) Set tPreList(i) = "Encounter"
	If $i(i) Set tPreList(i) = "Observation"
	If $i(i) Set tPreList(i) = "DiagnosticReport"
	If $i(i) Set tPreList(i) = "DiagnosticOrder"
	If $i(i) Set tPreList(i) = "AllergyIntolerance"
	If $i(i) Set tPreList(i) = "Condition"
	If $i(i) Set tPreList(i) = "Practitioner"
	If $i(i) Set tPreList(i) = "Medication"
	If $i(i) Set tPreList(i) = "MedicationOrder"
	If $i(i) Set tPreList(i) = "MedicationDispense"
	If $i(i) Set tPreList(i) = "DocumentReference"
	If $i(i) Set tPreList(i) = "DocumentManifest"
	If $i(i) Set tPreList(i) = "Binary"
	Set tPreList = i
	
	For i = 1:1:tPreList {
		Do %code.WriteLine(" If r%"_tPreList(i)_" Quit """_tPreList(i)_"""")
		Set tPreList(tPreList(i)) = ""
	}
	
	For i = 1:1:%compiledclass.Properties.Count() {
		Set tPropDef = %compiledclass.Properties.GetAt(i)
		If ('$D(tSkipList(tPropDef.Name))&&($E(tPropDef.Name,1,2)'="%%"))&&('$D(tPreList(tPropDef.Name))) {
			Do %code.WriteLine(" If r%"_tPropDef.Name_" Quit """_tPropDef.Name_"""")
		}
	}

	Do %code.WriteLine(" Quit """"")
	
	Quit $$$OK
}

///  
Method GetResource() As HS.FHIR.Model.Base.Resource
{
	Set tReturnResource = ""
	Set tResourceType = ..GetResourceType()
	If tResourceType'="" Set tReturnResource = $Property($this, tResourceType)
	Quit tReturnResource
}

}
