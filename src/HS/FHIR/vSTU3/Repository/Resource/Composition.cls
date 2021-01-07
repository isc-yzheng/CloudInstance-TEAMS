Class HS.FHIR.vSTU3.Repository.Resource.Composition Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

/// Excluded because we do not currently support searching on a collection of periods.
Parameter EXCLUDEPARAMS = ",period,";

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Composition"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Composition-attester"/>
    <resource>
      <SearchParameter>
        <id value="Composition-attester"/>
        <url value="http://hl7.org/fhir/SearchParameter/Composition-attester"/>
        <name value="attester"/>
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
        <code value="attester"/>
        <base value="Composition"/>
        <type value="reference"/>
        <description value="Who attested the composition"/>
        <expression value="Composition.attester.party"/>
        <xpath value="f:Composition/f:attester/f:party"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="Organization"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Composition-author"/>
    <resource>
      <SearchParameter>
        <id value="Composition-author"/>
        <url value="http://hl7.org/fhir/SearchParameter/Composition-author"/>
        <name value="author"/>
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
        <code value="author"/>
        <base value="Composition"/>
        <type value="reference"/>
        <description value="Who and/or what authored the composition"/>
        <expression value="Composition.author"/>
        <xpath value="f:Composition/f:author"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="Device"/>
        <target value="Patient"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Composition-class"/>
    <resource>
      <SearchParameter>
        <id value="Composition-class"/>
        <url value="http://hl7.org/fhir/SearchParameter/Composition-class"/>
        <name value="class"/>
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
        <code value="class"/>
        <base value="Composition"/>
        <type value="token"/>
        <description value="Categorization of Composition"/>
        <expression value="Composition.class"/>
        <xpath value="f:Composition/f:class"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Composition-confidentiality"/>
    <resource>
      <SearchParameter>
        <id value="Composition-confidentiality"/>
        <url value="http://hl7.org/fhir/SearchParameter/Composition-confidentiality"/>
        <name value="confidentiality"/>
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
        <code value="confidentiality"/>
        <base value="Composition"/>
        <type value="token"/>
        <description value="As defined by affinity domain"/>
        <expression value="Composition.confidentiality"/>
        <xpath value="f:Composition/f:confidentiality"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Composition-context"/>
    <resource>
      <SearchParameter>
        <id value="Composition-context"/>
        <url value="http://hl7.org/fhir/SearchParameter/Composition-context"/>
        <name value="context"/>
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
        <code value="context"/>
        <base value="Composition"/>
        <type value="token"/>
        <description value="Code(s) that apply to the event being documented"/>
        <expression value="Composition.event.code"/>
        <xpath value="f:Composition/f:event/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/clinical-date"/>
    <resource>
      <SearchParameter>
        <id value="clinical-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/clinical-date"/>
        <name value="date"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Community Based Collaborative Care)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/cbcc/index.cfm"/>
          </telecom>
        </contact>
        <code value="date"/>
        <base value="Consent"/>
        <base value="SupplyRequest"/>
        <base value="RiskAssessment"/>
        <base value="CareTeam"/>
        <base value="FamilyMemberHistory"/>
        <base value="Encounter"/>
        <base value="AllergyIntolerance"/>
        <base value="CarePlan"/>
        <base value="EpisodeOfCare"/>
        <base value="Procedure"/>
        <base value="List"/>
        <base value="Immunization"/>
        <base value="Flag"/>
        <base value="Observation"/>
        <base value="DiagnosticReport"/>
        <base value="Composition"/>
        <base value="DetectedIssue"/>
        <base value="ClinicalImpression"/>
        <type value="date"/>
        <description value="Multiple Resources: 

* [Consent](consent.html): When this Consent was created or indexed
* [SupplyRequest](supplyrequest.html): When the request was made
* [RiskAssessment](riskassessment.html): When was assessment made?
* [CareTeam](careteam.html): Time period team covers
* [FamilyMemberHistory](familymemberhistory.html): When history was captured/updated
* [Encounter](encounter.html): A date within the period the Encounter lasted
* [AllergyIntolerance](allergyintolerance.html): Date record was believed accurate
* [CarePlan](careplan.html): Time period plan covers
* [EpisodeOfCare](episodeofcare.html): The provided date search value falls within the episode of care&apos;s period
* [Procedure](procedure.html): Date/Period the procedure was performed
* [List](list.html): When the list was prepared
* [Immunization](immunization.html): Vaccination  (non)-Administration Date
* [Flag](flag.html): Time period when flag is active
* [Observation](observation.html): Obtained date/time. If the obtained element is a period, a date that falls in the period
* [DiagnosticReport](diagnosticreport.html): The clinically relevant time of the report
* [Composition](composition.html): Composition editing time
* [DetectedIssue](detectedissue.html): When identified
* [ClinicalImpression](clinicalimpression.html): When the assessment was documented
"/>
        <expression value="Consent.dateTime | SupplyRequest.authoredOn | RiskAssessment.occurrence.as(DateTime) | CareTeam.period | FamilyMemberHistory.date | Encounter.period | AllergyIntolerance.assertedDate | CarePlan.period | EpisodeOfCare.period | Procedure.performed | List.date | Immunization.date | Flag.period | Observation.effective | DiagnosticReport.effective | Composition.date | DetectedIssue.date | ClinicalImpression.date"/>
        <xpath value="f:Consent/f:dateTime | f:SupplyRequest/f:authoredOn | f:RiskAssessment/f:occurrenceDateTime | f:CareTeam/f:period | f:FamilyMemberHistory/f:date | f:Encounter/f:period | f:AllergyIntolerance/f:assertedDate | f:CarePlan/f:period | f:EpisodeOfCare/f:period | f:Procedure/f:performedDateTime | f:Procedure/f:performedPeriod | f:List/f:date | f:Immunization/f:date | f:Flag/f:period | f:Observation/f:effectiveDateTime | f:Observation/f:effectivePeriod | f:DiagnosticReport/f:effectiveDateTime | f:DiagnosticReport/f:effectivePeriod | f:Composition/f:date | f:DetectedIssue/f:date | f:ClinicalImpression/f:date"/>
        <xpathUsage value="normal"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Composition-entry"/>
    <resource>
      <SearchParameter>
        <id value="Composition-entry"/>
        <url value="http://hl7.org/fhir/SearchParameter/Composition-entry"/>
        <name value="entry"/>
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
        <code value="entry"/>
        <base value="Composition"/>
        <type value="reference"/>
        <description value="A reference to data that supports this section"/>
        <expression value="Composition.section.entry"/>
        <xpath value="f:Composition/f:section/f:entry"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Composition-period"/>
    <resource>
      <SearchParameter>
        <id value="Composition-period"/>
        <url value="http://hl7.org/fhir/SearchParameter/Composition-period"/>
        <name value="period"/>
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
        <code value="period"/>
        <base value="Composition"/>
        <type value="date"/>
        <description value="The period covered by the documentation"/>
        <expression value="Composition.event.period"/>
        <xpath value="f:Composition/f:event/f:period"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Composition-related-id"/>
    <resource>
      <SearchParameter>
        <id value="Composition-related-id"/>
        <url value="http://hl7.org/fhir/SearchParameter/Composition-related-id"/>
        <name value="related-id"/>
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
        <code value="related-id"/>
        <base value="Composition"/>
        <type value="token"/>
        <description value="Target of the relationship"/>
        <expression value="Composition.relatesTo.target.as(Identifier)"/>
        <xpath value="f:Composition/f:relatesTo/f:targetIdentifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Composition-related-ref"/>
    <resource>
      <SearchParameter>
        <id value="Composition-related-ref"/>
        <url value="http://hl7.org/fhir/SearchParameter/Composition-related-ref"/>
        <name value="related-ref"/>
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
        <code value="related-ref"/>
        <base value="Composition"/>
        <type value="reference"/>
        <description value="Target of the relationship"/>
        <expression value="Composition.relatesTo.target.as(Reference)"/>
        <xpath value="f:Composition/f:relatesTo/f:targetReference"/>
        <xpathUsage value="normal"/>
        <target value="Composition"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Composition-section"/>
    <resource>
      <SearchParameter>
        <id value="Composition-section"/>
        <url value="http://hl7.org/fhir/SearchParameter/Composition-section"/>
        <name value="section"/>
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
        <code value="section"/>
        <base value="Composition"/>
        <type value="token"/>
        <description value="Classification of section (recommended)"/>
        <expression value="Composition.section.code"/>
        <xpath value="f:Composition/f:section/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Composition-status"/>
    <resource>
      <SearchParameter>
        <id value="Composition-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/Composition-status"/>
        <name value="status"/>
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
        <code value="status"/>
        <base value="Composition"/>
        <type value="token"/>
        <description value="preliminary | final | amended | entered-in-error"/>
        <expression value="Composition.status"/>
        <xpath value="f:Composition/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Composition-subject"/>
    <resource>
      <SearchParameter>
        <id value="Composition-subject"/>
        <url value="http://hl7.org/fhir/SearchParameter/Composition-subject"/>
        <name value="subject"/>
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
        <code value="subject"/>
        <base value="Composition"/>
        <type value="reference"/>
        <description value="Who and/or what the composition is about"/>
        <expression value="Composition.subject"/>
        <xpath value="f:Composition/f:subject"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Composition-title"/>
    <resource>
      <SearchParameter>
        <id value="Composition-title"/>
        <url value="http://hl7.org/fhir/SearchParameter/Composition-title"/>
        <name value="title"/>
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
        <code value="title"/>
        <base value="Composition"/>
        <type value="string"/>
        <description value="Human Readable name/title"/>
        <expression value="Composition.title"/>
        <xpath value="f:Composition/f:title"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/clinical-type"/>
    <resource>
      <SearchParameter>
        <id value="clinical-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/clinical-type"/>
        <name value="type"/>
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
        <code value="type"/>
        <base value="ReferralRequest"/>
        <base value="DocumentManifest"/>
        <base value="DocumentReference"/>
        <base value="Encounter"/>
        <base value="AllergyIntolerance"/>
        <base value="EpisodeOfCare"/>
        <base value="Composition"/>
        <type value="token"/>
        <description value="Multiple Resources: 

* [ReferralRequest](referralrequest.html): The type of the referral
* [DocumentManifest](documentmanifest.html): Kind of document set
* [DocumentReference](documentreference.html): Kind of document (LOINC if possible)
* [Encounter](encounter.html): Specific type of encounter
* [AllergyIntolerance](allergyintolerance.html): allergy | intolerance - Underlying mechanism (if known)
* [EpisodeOfCare](episodeofcare.html): Type/class  - e.g. specialist referral, disease management
* [Composition](composition.html): Kind of composition (LOINC if possible)
"/>
        <expression value="ReferralRequest.type | DocumentManifest.type | DocumentReference.type | Encounter.type | AllergyIntolerance.type | EpisodeOfCare.type | Composition.type"/>
        <xpath value="f:ReferralRequest/f:type | f:DocumentManifest/f:type | f:DocumentReference/f:type | f:Encounter/f:type | f:AllergyIntolerance/f:type | f:EpisodeOfCare/f:type | f:Composition/f:type"/>
        <xpathUsage value="normal"/>
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
