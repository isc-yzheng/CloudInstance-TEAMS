/// If the element is present, it must have either a @value, an @id, or extensions
Class HS.FHIR.vSTU3.Model.Base.FHIRDefinedType Extends HS.FHIR.vSTU3.Model.Base.Element [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter XMLNAME = "FHIRDefinedType";

Parameter XMLSEQUENCE = 1;

Parameter JSONTYPEFIELD;

Property value As %String(VALUELIST = ",Address,Age,Annotation,Attachment,BackboneElement,CodeableConcept,Coding,ContactDetail,ContactPoint,Contributor,Count,DataRequirement,Distance,Dosage,Duration,Element,ElementDefinition,Extension,HumanName,Identifier,Meta,Money,Narrative,ParameterDefinition,Period,Quantity,Range,Ratio,Reference,RelatedArtifact,SampledData,Signature,SimpleQuantity,Timing,TriggerDefinition,UsageContext,base64Binary,boolean,code,date,dateTime,decimal,id,instant,integer,markdown,oid,positiveInt,string,time,unsignedInt,uri,uuid,xhtml,Account,ActivityDefinition,AdverseEvent,AllergyIntolerance,Appointment,AppointmentResponse,AuditEvent,Basic,Binary,BodySite,Bundle,CapabilityStatement,CarePlan,CareTeam,ChargeItem,Claim,ClaimResponse,ClinicalImpression,CodeSystem,Communication,CommunicationRequest,CompartmentDefinition,Composition,ConceptMap,Condition,Consent,Contract,Coverage,DataElement,DetectedIssue,Device,DeviceComponent,DeviceMetric,DeviceRequest,DeviceUseStatement,DiagnosticReport,DocumentManifest,DocumentReference,DomainResource,EligibilityRequest,EligibilityResponse,Encounter,Endpoint,EnrollmentRequest,EnrollmentResponse,EpisodeOfCare,ExpansionProfile,ExplanationOfBenefit,FamilyMemberHistory,Flag,Goal,GraphDefinition,Group,GuidanceResponse,HealthcareService,ImagingManifest,ImagingStudy,Immunization,ImmunizationRecommendation,ImplementationGuide,Library,Linkage,List,Location,Measure,MeasureReport,Media,Medication,MedicationAdministration,MedicationDispense,MedicationRequest,MedicationStatement,MessageDefinition,MessageHeader,NamingSystem,NutritionOrder,Observation,OperationDefinition,OperationOutcome,Organization,Parameters,Patient,PaymentNotice,PaymentReconciliation,Person,PlanDefinition,Practitioner,PractitionerRole,Procedure,ProcedureRequest,ProcessRequest,ProcessResponse,Provenance,Questionnaire,QuestionnaireResponse,ReferralRequest,RelatedPerson,RequestGroup,ResearchStudy,ResearchSubject,Resource,RiskAssessment,Schedule,SearchParameter,Sequence,ServiceDefinition,Slot,Specimen,StructureDefinition,StructureMap,Subscription,Substance,SupplyDelivery,SupplyRequest,Task,TestReport,TestScript,ValueSet,VisionPrescription", XMLNAME = "value", XMLPROJECTION = "ATTRIBUTE");

/// Get new object, populated with specified data.
Method %OnNew(pValue As %String, pExtension As %RegisteredObject, pId As %String) As %Status
{
	Set tSC = $$$OK
	Try {
		If ($Data(pValue)=0)&&($Data(pExtension)=0)&&($Data(pId)=0) Quit
		If $Get(pValue)'="" Set ..value = pValue
		If $Get(pId)'="" Set ..id = pId
		#; pExtension may be a single Extension object or a collection of Extension objects.
		If $IsObject($Get(pExtension)) {
			If (pExtension.%Extends("%Collection.ListOfObj")=0)&&(pExtension.%Extends("%Library.ListOfObjects")=0) {
				Set tSC = ..extension.Insert(pExtension) Quit:$$$ISERR(tSC)
			} ElseIf pExtension.Count()>0 {
				For i = 1:1:pExtension.Count() {
					Set tSC = ..extension.Insert(pExtension.GetAt(i)) Quit:$$$ISERR(tSC)
				}
			}
			Quit:$$$ISERR(tSC)
		}
		Set tSC = ..%ValidateObject()
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
