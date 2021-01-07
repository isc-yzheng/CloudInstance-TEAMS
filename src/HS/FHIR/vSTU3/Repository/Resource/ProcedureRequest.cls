Class HS.FHIR.vSTU3.Repository.Resource.ProcedureRequest Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-ProcedureRequest"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-authored"/>
    <resource>
      <SearchParameter>
        <id value="ProcedureRequest-authored"/>
        <url value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-authored"/>
        <name value="authored"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="authored"/>
        <base value="ProcedureRequest"/>
        <type value="date"/>
        <description value="Date request signed"/>
        <expression value="ProcedureRequest.authoredOn"/>
        <xpath value="f:ProcedureRequest/f:authoredOn"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-based-on"/>
    <resource>
      <SearchParameter>
        <id value="ProcedureRequest-based-on"/>
        <url value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-based-on"/>
        <name value="based-on"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="based-on"/>
        <base value="ProcedureRequest"/>
        <type value="reference"/>
        <description value="What request fulfills"/>
        <expression value="ProcedureRequest.basedOn"/>
        <xpath value="f:ProcedureRequest/f:basedOn"/>
        <xpathUsage value="normal"/>
        <target value="Account"/>
        <target value="ActivityDefinition"/>
        <target value="AdverseEvent"/>
        <target value="AllergyIntolerance"/>
        <target value="Appointment"/>
        <target value="AppointmentResponse"/>
        <target value="AuditEvent"/>
        <target value="Basic"/>
        <target value="Binary"/>
        <target value="BodySite"/>
        <target value="Bundle"/>
        <target value="CapabilityStatement"/>
        <target value="CarePlan"/>
        <target value="CareTeam"/>
        <target value="ChargeItem"/>
        <target value="Claim"/>
        <target value="ClaimResponse"/>
        <target value="ClinicalImpression"/>
        <target value="CodeSystem"/>
        <target value="Communication"/>
        <target value="CommunicationRequest"/>
        <target value="CompartmentDefinition"/>
        <target value="Composition"/>
        <target value="ConceptMap"/>
        <target value="Condition"/>
        <target value="Consent"/>
        <target value="Contract"/>
        <target value="Coverage"/>
        <target value="DataElement"/>
        <target value="DetectedIssue"/>
        <target value="Device"/>
        <target value="DeviceComponent"/>
        <target value="DeviceMetric"/>
        <target value="DeviceRequest"/>
        <target value="DeviceUseStatement"/>
        <target value="DiagnosticReport"/>
        <target value="DocumentManifest"/>
        <target value="DocumentReference"/>
        <target value="EligibilityRequest"/>
        <target value="EligibilityResponse"/>
        <target value="Encounter"/>
        <target value="Endpoint"/>
        <target value="EnrollmentRequest"/>
        <target value="EnrollmentResponse"/>
        <target value="EpisodeOfCare"/>
        <target value="ExpansionProfile"/>
        <target value="ExplanationOfBenefit"/>
        <target value="FamilyMemberHistory"/>
        <target value="Flag"/>
        <target value="Goal"/>
        <target value="GraphDefinition"/>
        <target value="Group"/>
        <target value="GuidanceResponse"/>
        <target value="HealthcareService"/>
        <target value="ImagingManifest"/>
        <target value="ImagingStudy"/>
        <target value="Immunization"/>
        <target value="ImmunizationRecommendation"/>
        <target value="ImplementationGuide"/>
        <target value="Library"/>
        <target value="Linkage"/>
        <target value="List"/>
        <target value="Location"/>
        <target value="Measure"/>
        <target value="MeasureReport"/>
        <target value="Media"/>
        <target value="Medication"/>
        <target value="MedicationAdministration"/>
        <target value="MedicationDispense"/>
        <target value="MedicationRequest"/>
        <target value="MedicationStatement"/>
        <target value="MessageDefinition"/>
        <target value="MessageHeader"/>
        <target value="NamingSystem"/>
        <target value="NutritionOrder"/>
        <target value="Observation"/>
        <target value="OperationDefinition"/>
        <target value="OperationOutcome"/>
        <target value="Organization"/>
        <target value="Patient"/>
        <target value="PaymentNotice"/>
        <target value="PaymentReconciliation"/>
        <target value="Person"/>
        <target value="PlanDefinition"/>
        <target value="Practitioner"/>
        <target value="PractitionerRole"/>
        <target value="Procedure"/>
        <target value="ProcedureRequest"/>
        <target value="ProcessRequest"/>
        <target value="ProcessResponse"/>
        <target value="Provenance"/>
        <target value="Questionnaire"/>
        <target value="QuestionnaireResponse"/>
        <target value="ReferralRequest"/>
        <target value="RelatedPerson"/>
        <target value="RequestGroup"/>
        <target value="ResearchStudy"/>
        <target value="ResearchSubject"/>
        <target value="RiskAssessment"/>
        <target value="Schedule"/>
        <target value="SearchParameter"/>
        <target value="Sequence"/>
        <target value="ServiceDefinition"/>
        <target value="Slot"/>
        <target value="Specimen"/>
        <target value="StructureDefinition"/>
        <target value="StructureMap"/>
        <target value="Subscription"/>
        <target value="Substance"/>
        <target value="SupplyDelivery"/>
        <target value="SupplyRequest"/>
        <target value="Task"/>
        <target value="TestReport"/>
        <target value="TestScript"/>
        <target value="ValueSet"/>
        <target value="VisionPrescription"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-body-site"/>
    <resource>
      <SearchParameter>
        <id value="ProcedureRequest-body-site"/>
        <url value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-body-site"/>
        <name value="body-site"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="body-site"/>
        <base value="ProcedureRequest"/>
        <type value="token"/>
        <description value="Where procedure is going to be done"/>
        <expression value="ProcedureRequest.bodySite"/>
        <xpath value="f:ProcedureRequest/f:bodySite"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/clinical-code"/>
    <resource>
      <SearchParameter>
        <id value="clinical-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/clinical-code"/>
        <name value="code"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <code value="code"/>
        <base value="FamilyMemberHistory"/>
        <base value="DeviceRequest"/>
        <base value="AllergyIntolerance"/>
        <base value="Procedure"/>
        <base value="List"/>
        <base value="ProcedureRequest"/>
        <base value="Observation"/>
        <base value="DiagnosticReport"/>
        <base value="Condition"/>
        <type value="token"/>
        <description value="Multiple Resources: 

* [FamilyMemberHistory](familymemberhistory.html): A search by a condition code
* [DeviceRequest](devicerequest.html): Code for what is being requested/ordered
* [AllergyIntolerance](allergyintolerance.html): Code that identifies the allergy or intolerance
* [Procedure](procedure.html): A code to identify a  procedure
* [List](list.html): What the purpose of this list is
* [ProcedureRequest](procedurerequest.html): What is being requested/ordered
* [Observation](observation.html): The code of the observation type
* [DiagnosticReport](diagnosticreport.html): The code for the report as a whole, as opposed to codes for the atomic results, which are the names on the observation resource referred to from the result
* [Condition](condition.html): Code for the condition
"/>
        <expression value="FamilyMemberHistory.condition.code | DeviceRequest.code.as(CodeableConcept) | AllergyIntolerance.code | AllergyIntolerance.reaction.substance | Procedure.code | List.code | ProcedureRequest.code | Observation.code | DiagnosticReport.code | Condition.code"/>
        <xpath value="f:FamilyMemberHistory/f:condition/f:code | f:DeviceRequest/f:codeCodeableConcept | f:AllergyIntolerance/f:code | f:AllergyIntolerance/f:reaction/f:substance | f:Procedure/f:code | f:List/f:code | f:ProcedureRequest/f:code | f:Observation/f:code | f:DiagnosticReport/f:code | f:Condition/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-context"/>
    <resource>
      <SearchParameter>
        <id value="ProcedureRequest-context"/>
        <url value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-context"/>
        <name value="context"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="context"/>
        <base value="ProcedureRequest"/>
        <type value="reference"/>
        <description value="Encounter or Episode during which request was created"/>
        <expression value="ProcedureRequest.context"/>
        <xpath value="f:ProcedureRequest/f:context"/>
        <xpathUsage value="normal"/>
        <target value="EpisodeOfCare"/>
        <target value="Encounter"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-definition"/>
    <resource>
      <SearchParameter>
        <id value="ProcedureRequest-definition"/>
        <url value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-definition"/>
        <name value="definition"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="definition"/>
        <base value="ProcedureRequest"/>
        <type value="reference"/>
        <description value="Protocol or definition"/>
        <expression value="ProcedureRequest.definition"/>
        <xpath value="f:ProcedureRequest/f:definition"/>
        <xpathUsage value="normal"/>
        <target value="PlanDefinition"/>
        <target value="ActivityDefinition"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/clinical-encounter"/>
    <resource>
      <SearchParameter>
        <id value="clinical-encounter"/>
        <url value="http://hl7.org/fhir/SearchParameter/clinical-encounter"/>
        <name value="encounter"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Structured Documents)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/structure/index.cfm"/>
          </telecom>
        </contact>
        <code value="encounter"/>
        <base value="DocumentReference"/>
        <base value="RiskAssessment"/>
        <base value="DeviceRequest"/>
        <base value="Procedure"/>
        <base value="List"/>
        <base value="VisionPrescription"/>
        <base value="ProcedureRequest"/>
        <base value="Flag"/>
        <base value="Observation"/>
        <base value="DiagnosticReport"/>
        <base value="NutritionOrder"/>
        <base value="Composition"/>
        <type value="reference"/>
        <description value="Multiple Resources: 

* [DocumentReference](documentreference.html): Context of the document  content
* [RiskAssessment](riskassessment.html): Where was assessment performed?
* [DeviceRequest](devicerequest.html): Encounter or Episode during which request was created
* [Procedure](procedure.html): Search by encounter
* [List](list.html): Context in which list created
* [VisionPrescription](visionprescription.html): Return prescriptions with this encounter identifier
* [ProcedureRequest](procedurerequest.html): An encounter in which this request is made
* [Flag](flag.html): Alert relevant during encounter
* [Observation](observation.html): Encounter related to the observation
* [DiagnosticReport](diagnosticreport.html): The Encounter when the order was made
* [NutritionOrder](nutritionorder.html): Return nutrition orders with this encounter identifier
* [Composition](composition.html): Context of the Composition
"/>
        <expression value="DocumentReference.context.encounter | RiskAssessment.context | DeviceRequest.context | Procedure.context | List.encounter | VisionPrescription.encounter | ProcedureRequest.context | Flag.encounter | Observation.context | DiagnosticReport.context | NutritionOrder.encounter | Composition.encounter"/>
        <xpath value="f:DocumentReference/f:context/f:encounter | f:RiskAssessment/f:context | f:DeviceRequest/f:context | f:Procedure/f:context | f:List/f:encounter | f:VisionPrescription/f:encounter | f:ProcedureRequest/f:context | f:Flag/f:encounter | f:Observation/f:context | f:DiagnosticReport/f:context | f:NutritionOrder/f:encounter | f:Composition/f:encounter"/>
        <xpathUsage value="normal"/>
        <target value="Encounter"/>
        <target value="EpisodeOfCare"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/clinical-identifier"/>
    <resource>
      <SearchParameter>
        <id value="clinical-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/clinical-identifier"/>
        <name value="identifier"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Structured Documents)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/structure/index.cfm"/>
          </telecom>
        </contact>
        <code value="identifier"/>
        <base value="DocumentManifest"/>
        <base value="Goal"/>
        <base value="Consent"/>
        <base value="DocumentReference"/>
        <base value="SupplyRequest"/>
        <base value="RiskAssessment"/>
        <base value="CareTeam"/>
        <base value="ImagingStudy"/>
        <base value="FamilyMemberHistory"/>
        <base value="Encounter"/>
        <base value="DeviceRequest"/>
        <base value="AllergyIntolerance"/>
        <base value="CarePlan"/>
        <base value="EpisodeOfCare"/>
        <base value="Procedure"/>
        <base value="List"/>
        <base value="Immunization"/>
        <base value="VisionPrescription"/>
        <base value="ProcedureRequest"/>
        <base value="Observation"/>
        <base value="DiagnosticReport"/>
        <base value="NutritionOrder"/>
        <base value="Condition"/>
        <base value="Composition"/>
        <base value="DetectedIssue"/>
        <base value="SupplyDelivery"/>
        <type value="token"/>
        <description value="Multiple Resources: 

* [DocumentManifest](documentmanifest.html): Unique Identifier for the set of documents
* [Goal](goal.html): External Ids for this goal
* [Consent](consent.html): Identifier for this record (external references)
* [DocumentReference](documentreference.html): Master Version Specific Identifier
* [SupplyRequest](supplyrequest.html): Unique identifier
* [RiskAssessment](riskassessment.html): Unique identifier for the assessment
* [CareTeam](careteam.html): External Ids for this team
* [ImagingStudy](imagingstudy.html): Other identifiers for the Study
* [FamilyMemberHistory](familymemberhistory.html): A search by a record identifier
* [Encounter](encounter.html): Identifier(s) by which this encounter is known
* [DeviceRequest](devicerequest.html): Business identifier for request/order
* [AllergyIntolerance](allergyintolerance.html): External ids for this item
* [CarePlan](careplan.html): External Ids for this plan
* [EpisodeOfCare](episodeofcare.html): Business Identifier(s) relevant for this EpisodeOfCare
* [Procedure](procedure.html): A unique identifier for a procedure
* [List](list.html): Business identifier
* [Immunization](immunization.html): Business identifier
* [VisionPrescription](visionprescription.html): Return prescriptions with this external identifier
* [ProcedureRequest](procedurerequest.html): Identifiers assigned to this order
* [Observation](observation.html): The unique id for a particular observation
* [DiagnosticReport](diagnosticreport.html): An identifier for the report
* [NutritionOrder](nutritionorder.html): Return nutrition orders with this external identifier
* [Condition](condition.html): A unique identifier of the condition record
* [Composition](composition.html): Logical identifier of composition (version-independent)
* [DetectedIssue](detectedissue.html): Unique id for the detected issue
* [SupplyDelivery](supplydelivery.html): External identifier
"/>
        <expression value="DocumentManifest.masterIdentifier | DocumentManifest.identifier | Goal.identifier | Consent.identifier | DocumentReference.masterIdentifier | DocumentReference.identifier | SupplyRequest.identifier | RiskAssessment.identifier | CareTeam.identifier | ImagingStudy.identifier | FamilyMemberHistory.identifier | Encounter.identifier | DeviceRequest.identifier | AllergyIntolerance.identifier | CarePlan.identifier | EpisodeOfCare.identifier | Procedure.identifier | List.identifier | Immunization.identifier | VisionPrescription.identifier | ProcedureRequest.identifier | Observation.identifier | DiagnosticReport.identifier | NutritionOrder.identifier | Condition.identifier | Composition.identifier | DetectedIssue.identifier | SupplyDelivery.identifier"/>
        <xpath value="f:DocumentManifest/f:masterIdentifier | f:DocumentManifest/f:identifier | f:Goal/f:identifier | f:Consent/f:identifier | f:DocumentReference/f:masterIdentifier | f:DocumentReference/f:identifier | f:SupplyRequest/f:identifier | f:RiskAssessment/f:identifier | f:CareTeam/f:identifier | f:ImagingStudy/f:identifier | f:FamilyMemberHistory/f:identifier | f:Encounter/f:identifier | f:DeviceRequest/f:identifier | f:AllergyIntolerance/f:identifier | f:CarePlan/f:identifier | f:EpisodeOfCare/f:identifier | f:Procedure/f:identifier | f:List/f:identifier | f:Immunization/f:identifier | f:VisionPrescription/f:identifier | f:ProcedureRequest/f:identifier | f:Observation/f:identifier | f:DiagnosticReport/f:identifier | f:NutritionOrder/f:identifier | f:Condition/f:identifier | f:Composition/f:identifier | f:DetectedIssue/f:identifier | f:SupplyDelivery/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-intent"/>
    <resource>
      <SearchParameter>
        <id value="ProcedureRequest-intent"/>
        <url value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-intent"/>
        <name value="intent"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="intent"/>
        <base value="ProcedureRequest"/>
        <type value="token"/>
        <description value="proposal | plan | order +"/>
        <expression value="ProcedureRequest.intent"/>
        <xpath value="f:ProcedureRequest/f:intent"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-occurrence"/>
    <resource>
      <SearchParameter>
        <id value="ProcedureRequest-occurrence"/>
        <url value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-occurrence"/>
        <name value="occurrence"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="occurrence"/>
        <base value="ProcedureRequest"/>
        <type value="date"/>
        <description value="When procedure should occur"/>
        <expression value="ProcedureRequest.occurrence"/>
        <xpath value="f:ProcedureRequest/f:occurrenceDateTime | f:ProcedureRequest/f:occurrencePeriod | f:ProcedureRequest/f:occurrenceTiming"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/clinical-patient"/>
    <resource>
      <SearchParameter>
        <id value="clinical-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/clinical-patient"/>
        <name value="patient"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <code value="patient"/>
        <base value="ReferralRequest"/>
        <base value="DocumentManifest"/>
        <base value="Goal"/>
        <base value="Consent"/>
        <base value="DocumentReference"/>
        <base value="ImagingManifest"/>
        <base value="RiskAssessment"/>
        <base value="CareTeam"/>
        <base value="ImagingStudy"/>
        <base value="FamilyMemberHistory"/>
        <base value="Encounter"/>
        <base value="DeviceUseStatement"/>
        <base value="DeviceRequest"/>
        <base value="AllergyIntolerance"/>
        <base value="CarePlan"/>
        <base value="EpisodeOfCare"/>
        <base value="Procedure"/>
        <base value="List"/>
        <base value="Immunization"/>
        <base value="VisionPrescription"/>
        <base value="ProcedureRequest"/>
        <base value="Flag"/>
        <base value="Observation"/>
        <base value="DiagnosticReport"/>
        <base value="NutritionOrder"/>
        <base value="Condition"/>
        <base value="Composition"/>
        <base value="DetectedIssue"/>
        <base value="SupplyDelivery"/>
        <base value="ClinicalImpression"/>
        <type value="reference"/>
        <description value="Multiple Resources: 

* [ReferralRequest](referralrequest.html): Who the referral is about
* [DocumentManifest](documentmanifest.html): The subject of the set of documents
* [Goal](goal.html): Who this goal is intended for
* [Consent](consent.html): Who the consent applies to
* [DocumentReference](documentreference.html): Who/what is the subject of the document
* [ImagingManifest](imagingmanifest.html): Subject of the ImagingManifest (or a DICOM Key Object Selection which it represents)
* [RiskAssessment](riskassessment.html): Who/what does assessment apply to?
* [CareTeam](careteam.html): Who care team is for
* [ImagingStudy](imagingstudy.html): Who the study is about
* [FamilyMemberHistory](familymemberhistory.html): The identity of a subject to list family member history items for
* [Encounter](encounter.html): The patient ro group present at the encounter
* [DeviceUseStatement](deviceusestatement.html): Search by subject - a patient
* [DeviceRequest](devicerequest.html): Individual the service is ordered for
* [AllergyIntolerance](allergyintolerance.html): Who the sensitivity is for
* [CarePlan](careplan.html): Who care plan is for
* [EpisodeOfCare](episodeofcare.html): The patient who is the focus of this episode of care
* [Procedure](procedure.html): Search by subject - a patient
* [List](list.html): If all resources have the same subject
* [Immunization](immunization.html): The patient for the vaccination record
* [VisionPrescription](visionprescription.html): The identity of a patient to list dispenses for
* [ProcedureRequest](procedurerequest.html): Search by subject - a patient
* [Flag](flag.html): The identity of a subject to list flags for
* [Observation](observation.html): The subject that the observation is about (if patient)
* [DiagnosticReport](diagnosticreport.html): The subject of the report if a patient
* [NutritionOrder](nutritionorder.html): The identity of the person who requires the diet, formula or nutritional supplement
* [Condition](condition.html): Who has the condition?
* [Composition](composition.html): Who and/or what the composition is about
* [DetectedIssue](detectedissue.html): Associated patient
* [SupplyDelivery](supplydelivery.html): Patient for whom the item is supplied
* [ClinicalImpression](clinicalimpression.html): Patient or group assessed
"/>
        <expression value="ReferralRequest.subject | DocumentManifest.subject | Goal.subject | Consent.patient | DocumentReference.subject | ImagingManifest.patient | RiskAssessment.subject | CareTeam.subject | ImagingStudy.patient | FamilyMemberHistory.patient | Encounter.subject | DeviceUseStatement.subject | DeviceRequest.subject | AllergyIntolerance.patient | CarePlan.subject | EpisodeOfCare.patient | Procedure.subject | List.subject | Immunization.patient | VisionPrescription.patient | ProcedureRequest.subject | Flag.subject | Observation.subject | DiagnosticReport.subject | NutritionOrder.patient | Condition.subject | Composition.subject | DetectedIssue.patient | SupplyDelivery.patient | ClinicalImpression.subject"/>
        <xpath value="f:ReferralRequest/f:subject | f:DocumentManifest/f:subject | f:Goal/f:subject | f:Consent/f:patient | f:DocumentReference/f:subject | f:ImagingManifest/f:patient | f:RiskAssessment/f:subject | f:CareTeam/f:subject | f:ImagingStudy/f:patient | f:FamilyMemberHistory/f:patient | f:Encounter/f:subject | f:DeviceUseStatement/f:subject | f:DeviceRequest/f:subject | f:AllergyIntolerance/f:patient | f:CarePlan/f:subject | f:EpisodeOfCare/f:patient | f:Procedure/f:subject | f:List/f:subject | f:Immunization/f:patient | f:VisionPrescription/f:patient | f:ProcedureRequest/f:subject | f:Flag/f:subject | f:Observation/f:subject | f:DiagnosticReport/f:subject | f:NutritionOrder/f:patient | f:Condition/f:subject | f:Composition/f:subject | f:DetectedIssue/f:patient | f:SupplyDelivery/f:patient | f:ClinicalImpression/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
        <target value="Group"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-performer"/>
    <resource>
      <SearchParameter>
        <id value="ProcedureRequest-performer"/>
        <url value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-performer"/>
        <name value="performer"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="performer"/>
        <base value="ProcedureRequest"/>
        <type value="reference"/>
        <description value="Requested perfomer"/>
        <expression value="ProcedureRequest.performer"/>
        <xpath value="f:ProcedureRequest/f:performer"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="Organization"/>
        <target value="Device"/>
        <target value="Patient"/>
        <target value="HealthcareService"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-performer-type"/>
    <resource>
      <SearchParameter>
        <id value="ProcedureRequest-performer-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-performer-type"/>
        <name value="performer-type"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="performer-type"/>
        <base value="ProcedureRequest"/>
        <type value="token"/>
        <description value="Performer role"/>
        <expression value="ProcedureRequest.performerType"/>
        <xpath value="f:ProcedureRequest/f:performerType"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-priority"/>
    <resource>
      <SearchParameter>
        <id value="ProcedureRequest-priority"/>
        <url value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-priority"/>
        <name value="priority"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="priority"/>
        <base value="ProcedureRequest"/>
        <type value="token"/>
        <description value="routine | urgent | asap | stat"/>
        <expression value="ProcedureRequest.priority"/>
        <xpath value="f:ProcedureRequest/f:priority"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-replaces"/>
    <resource>
      <SearchParameter>
        <id value="ProcedureRequest-replaces"/>
        <url value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-replaces"/>
        <name value="replaces"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="replaces"/>
        <base value="ProcedureRequest"/>
        <type value="reference"/>
        <description value="What request replaces"/>
        <expression value="ProcedureRequest.replaces"/>
        <xpath value="f:ProcedureRequest/f:replaces"/>
        <xpathUsage value="normal"/>
        <target value="Account"/>
        <target value="ActivityDefinition"/>
        <target value="AdverseEvent"/>
        <target value="AllergyIntolerance"/>
        <target value="Appointment"/>
        <target value="AppointmentResponse"/>
        <target value="AuditEvent"/>
        <target value="Basic"/>
        <target value="Binary"/>
        <target value="BodySite"/>
        <target value="Bundle"/>
        <target value="CapabilityStatement"/>
        <target value="CarePlan"/>
        <target value="CareTeam"/>
        <target value="ChargeItem"/>
        <target value="Claim"/>
        <target value="ClaimResponse"/>
        <target value="ClinicalImpression"/>
        <target value="CodeSystem"/>
        <target value="Communication"/>
        <target value="CommunicationRequest"/>
        <target value="CompartmentDefinition"/>
        <target value="Composition"/>
        <target value="ConceptMap"/>
        <target value="Condition"/>
        <target value="Consent"/>
        <target value="Contract"/>
        <target value="Coverage"/>
        <target value="DataElement"/>
        <target value="DetectedIssue"/>
        <target value="Device"/>
        <target value="DeviceComponent"/>
        <target value="DeviceMetric"/>
        <target value="DeviceRequest"/>
        <target value="DeviceUseStatement"/>
        <target value="DiagnosticReport"/>
        <target value="DocumentManifest"/>
        <target value="DocumentReference"/>
        <target value="EligibilityRequest"/>
        <target value="EligibilityResponse"/>
        <target value="Encounter"/>
        <target value="Endpoint"/>
        <target value="EnrollmentRequest"/>
        <target value="EnrollmentResponse"/>
        <target value="EpisodeOfCare"/>
        <target value="ExpansionProfile"/>
        <target value="ExplanationOfBenefit"/>
        <target value="FamilyMemberHistory"/>
        <target value="Flag"/>
        <target value="Goal"/>
        <target value="GraphDefinition"/>
        <target value="Group"/>
        <target value="GuidanceResponse"/>
        <target value="HealthcareService"/>
        <target value="ImagingManifest"/>
        <target value="ImagingStudy"/>
        <target value="Immunization"/>
        <target value="ImmunizationRecommendation"/>
        <target value="ImplementationGuide"/>
        <target value="Library"/>
        <target value="Linkage"/>
        <target value="List"/>
        <target value="Location"/>
        <target value="Measure"/>
        <target value="MeasureReport"/>
        <target value="Media"/>
        <target value="Medication"/>
        <target value="MedicationAdministration"/>
        <target value="MedicationDispense"/>
        <target value="MedicationRequest"/>
        <target value="MedicationStatement"/>
        <target value="MessageDefinition"/>
        <target value="MessageHeader"/>
        <target value="NamingSystem"/>
        <target value="NutritionOrder"/>
        <target value="Observation"/>
        <target value="OperationDefinition"/>
        <target value="OperationOutcome"/>
        <target value="Organization"/>
        <target value="Patient"/>
        <target value="PaymentNotice"/>
        <target value="PaymentReconciliation"/>
        <target value="Person"/>
        <target value="PlanDefinition"/>
        <target value="Practitioner"/>
        <target value="PractitionerRole"/>
        <target value="Procedure"/>
        <target value="ProcedureRequest"/>
        <target value="ProcessRequest"/>
        <target value="ProcessResponse"/>
        <target value="Provenance"/>
        <target value="Questionnaire"/>
        <target value="QuestionnaireResponse"/>
        <target value="ReferralRequest"/>
        <target value="RelatedPerson"/>
        <target value="RequestGroup"/>
        <target value="ResearchStudy"/>
        <target value="ResearchSubject"/>
        <target value="RiskAssessment"/>
        <target value="Schedule"/>
        <target value="SearchParameter"/>
        <target value="Sequence"/>
        <target value="ServiceDefinition"/>
        <target value="Slot"/>
        <target value="Specimen"/>
        <target value="StructureDefinition"/>
        <target value="StructureMap"/>
        <target value="Subscription"/>
        <target value="Substance"/>
        <target value="SupplyDelivery"/>
        <target value="SupplyRequest"/>
        <target value="Task"/>
        <target value="TestReport"/>
        <target value="TestScript"/>
        <target value="ValueSet"/>
        <target value="VisionPrescription"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-requester"/>
    <resource>
      <SearchParameter>
        <id value="ProcedureRequest-requester"/>
        <url value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-requester"/>
        <name value="requester"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="requester"/>
        <base value="ProcedureRequest"/>
        <type value="reference"/>
        <description value="Individual making the request"/>
        <expression value="ProcedureRequest.requester.agent"/>
        <xpath value="f:ProcedureRequest/f:requester/f:agent"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="Organization"/>
        <target value="Device"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-requisition"/>
    <resource>
      <SearchParameter>
        <id value="ProcedureRequest-requisition"/>
        <url value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-requisition"/>
        <name value="requisition"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="requisition"/>
        <base value="ProcedureRequest"/>
        <type value="token"/>
        <description value="Composite Request ID"/>
        <expression value="ProcedureRequest.requisition"/>
        <xpath value="f:ProcedureRequest/f:requisition"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-specimen"/>
    <resource>
      <SearchParameter>
        <id value="ProcedureRequest-specimen"/>
        <url value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-specimen"/>
        <name value="specimen"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="specimen"/>
        <base value="ProcedureRequest"/>
        <type value="reference"/>
        <description value="Specimen to be tested"/>
        <expression value="ProcedureRequest.specimen"/>
        <xpath value="f:ProcedureRequest/f:specimen"/>
        <xpathUsage value="normal"/>
        <target value="Specimen"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-status"/>
    <resource>
      <SearchParameter>
        <id value="ProcedureRequest-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-status"/>
        <name value="status"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="status"/>
        <base value="ProcedureRequest"/>
        <type value="token"/>
        <description value="draft | active | suspended | completed | entered-in-error | cancelled"/>
        <expression value="ProcedureRequest.status"/>
        <xpath value="f:ProcedureRequest/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-subject"/>
    <resource>
      <SearchParameter>
        <id value="ProcedureRequest-subject"/>
        <url value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-subject"/>
        <name value="subject"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="subject"/>
        <base value="ProcedureRequest"/>
        <type value="reference"/>
        <description value="Search by subject"/>
        <expression value="ProcedureRequest.subject"/>
        <xpath value="f:ProcedureRequest/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Group"/>
        <target value="Device"/>
        <target value="Patient"/>
        <target value="Location"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
