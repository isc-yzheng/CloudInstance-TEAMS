Class HS.FHIR.vSTU3.Repository.Resource.ReferralRequest Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-ReferralRequest"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ReferralRequest-authored-on"/>
    <resource>
      <SearchParameter>
        <id value="ReferralRequest-authored-on"/>
        <url value="http://hl7.org/fhir/SearchParameter/ReferralRequest-authored-on"/>
        <name value="authored-on"/>
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
        <code value="authored-on"/>
        <base value="ReferralRequest"/>
        <type value="date"/>
        <description value="Creation or activation date"/>
        <expression value="ReferralRequest.authoredOn"/>
        <xpath value="f:ReferralRequest/f:authoredOn"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ReferralRequest-based-on"/>
    <resource>
      <SearchParameter>
        <id value="ReferralRequest-based-on"/>
        <url value="http://hl7.org/fhir/SearchParameter/ReferralRequest-based-on"/>
        <name value="based-on"/>
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
        <code value="based-on"/>
        <base value="ReferralRequest"/>
        <type value="reference"/>
        <description value="Request being fulfilled"/>
        <expression value="ReferralRequest.basedOn"/>
        <xpath value="f:ReferralRequest/f:basedOn"/>
        <xpathUsage value="normal"/>
        <target value="ReferralRequest"/>
        <target value="CarePlan"/>
        <target value="ProcedureRequest"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ReferralRequest-context"/>
    <resource>
      <SearchParameter>
        <id value="ReferralRequest-context"/>
        <url value="http://hl7.org/fhir/SearchParameter/ReferralRequest-context"/>
        <name value="context"/>
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
        <code value="context"/>
        <base value="ReferralRequest"/>
        <type value="reference"/>
        <description value="Part of encounter or episode of care"/>
        <expression value="ReferralRequest.context"/>
        <xpath value="f:ReferralRequest/f:context"/>
        <xpathUsage value="normal"/>
        <target value="EpisodeOfCare"/>
        <target value="Encounter"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ReferralRequest-definition"/>
    <resource>
      <SearchParameter>
        <id value="ReferralRequest-definition"/>
        <url value="http://hl7.org/fhir/SearchParameter/ReferralRequest-definition"/>
        <name value="definition"/>
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
        <code value="definition"/>
        <base value="ReferralRequest"/>
        <type value="reference"/>
        <description value="Instantiates protocol or definition"/>
        <expression value="ReferralRequest.definition"/>
        <xpath value="f:ReferralRequest/f:definition"/>
        <xpathUsage value="normal"/>
        <target value="PlanDefinition"/>
        <target value="ActivityDefinition"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ReferralRequest-encounter"/>
    <resource>
      <SearchParameter>
        <id value="ReferralRequest-encounter"/>
        <url value="http://hl7.org/fhir/SearchParameter/ReferralRequest-encounter"/>
        <name value="encounter"/>
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
        <code value="encounter"/>
        <base value="ReferralRequest"/>
        <type value="reference"/>
        <description value="Originating encounter"/>
        <expression value="ReferralRequest.context"/>
        <xpath value="f:ReferralRequest/f:context"/>
        <xpathUsage value="normal"/>
        <target value="Encounter"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ReferralRequest-group-identifier"/>
    <resource>
      <SearchParameter>
        <id value="ReferralRequest-group-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/ReferralRequest-group-identifier"/>
        <name value="group-identifier"/>
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
        <code value="group-identifier"/>
        <base value="ReferralRequest"/>
        <type value="token"/>
        <description value="Part of common request"/>
        <expression value="ReferralRequest.groupIdentifier"/>
        <xpath value="f:ReferralRequest/f:groupIdentifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ReferralRequest-identifier"/>
    <resource>
      <SearchParameter>
        <id value="ReferralRequest-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/ReferralRequest-identifier"/>
        <name value="identifier"/>
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
        <code value="identifier"/>
        <base value="ReferralRequest"/>
        <type value="token"/>
        <description value="Business identifier"/>
        <expression value="ReferralRequest.identifier"/>
        <xpath value="f:ReferralRequest/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ReferralRequest-intent"/>
    <resource>
      <SearchParameter>
        <id value="ReferralRequest-intent"/>
        <url value="http://hl7.org/fhir/SearchParameter/ReferralRequest-intent"/>
        <name value="intent"/>
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
        <code value="intent"/>
        <base value="ReferralRequest"/>
        <type value="token"/>
        <description value="Proposal, plan or order"/>
        <expression value="ReferralRequest.intent"/>
        <xpath value="f:ReferralRequest/f:intent"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ReferralRequest-occurrence-date"/>
    <resource>
      <SearchParameter>
        <id value="ReferralRequest-occurrence-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/ReferralRequest-occurrence-date"/>
        <name value="occurrence-date"/>
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
        <code value="occurrence-date"/>
        <base value="ReferralRequest"/>
        <type value="date"/>
        <description value="When the service(s) requested in the referral should occur"/>
        <expression value="ReferralRequest.occurrence"/>
        <xpath value="f:ReferralRequest/f:occurrenceDateTime | f:ReferralRequest/f:occurrencePeriod"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ReferralRequest-priority"/>
    <resource>
      <SearchParameter>
        <id value="ReferralRequest-priority"/>
        <url value="http://hl7.org/fhir/SearchParameter/ReferralRequest-priority"/>
        <name value="priority"/>
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
        <code value="priority"/>
        <base value="ReferralRequest"/>
        <type value="token"/>
        <description value="The priority assigned to the referral"/>
        <expression value="ReferralRequest.priority"/>
        <xpath value="f:ReferralRequest/f:priority"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ReferralRequest-recipient"/>
    <resource>
      <SearchParameter>
        <id value="ReferralRequest-recipient"/>
        <url value="http://hl7.org/fhir/SearchParameter/ReferralRequest-recipient"/>
        <name value="recipient"/>
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
        <code value="recipient"/>
        <base value="ReferralRequest"/>
        <type value="reference"/>
        <description value="The person that the referral was sent to"/>
        <expression value="ReferralRequest.recipient"/>
        <xpath value="f:ReferralRequest/f:recipient"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="Organization"/>
        <target value="HealthcareService"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ReferralRequest-replaces"/>
    <resource>
      <SearchParameter>
        <id value="ReferralRequest-replaces"/>
        <url value="http://hl7.org/fhir/SearchParameter/ReferralRequest-replaces"/>
        <name value="replaces"/>
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
        <code value="replaces"/>
        <base value="ReferralRequest"/>
        <type value="reference"/>
        <description value="Request(s) replaced by this request"/>
        <expression value="ReferralRequest.replaces"/>
        <xpath value="f:ReferralRequest/f:replaces"/>
        <xpathUsage value="normal"/>
        <target value="ReferralRequest"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ReferralRequest-requester"/>
    <resource>
      <SearchParameter>
        <id value="ReferralRequest-requester"/>
        <url value="http://hl7.org/fhir/SearchParameter/ReferralRequest-requester"/>
        <name value="requester"/>
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
        <code value="requester"/>
        <base value="ReferralRequest"/>
        <type value="reference"/>
        <description value="Individual making the request"/>
        <expression value="ReferralRequest.requester.agent"/>
        <xpath value="f:ReferralRequest/f:requester/f:agent"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="Organization"/>
        <target value="Device"/>
        <target value="Patient"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ReferralRequest-service"/>
    <resource>
      <SearchParameter>
        <id value="ReferralRequest-service"/>
        <url value="http://hl7.org/fhir/SearchParameter/ReferralRequest-service"/>
        <name value="service"/>
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
        <code value="service"/>
        <base value="ReferralRequest"/>
        <type value="token"/>
        <description value="Actions requested as part of the referral"/>
        <expression value="ReferralRequest.serviceRequested"/>
        <xpath value="f:ReferralRequest/f:serviceRequested"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ReferralRequest-specialty"/>
    <resource>
      <SearchParameter>
        <id value="ReferralRequest-specialty"/>
        <url value="http://hl7.org/fhir/SearchParameter/ReferralRequest-specialty"/>
        <name value="specialty"/>
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
        <code value="specialty"/>
        <base value="ReferralRequest"/>
        <type value="token"/>
        <description value="The specialty that the referral is for"/>
        <expression value="ReferralRequest.specialty"/>
        <xpath value="f:ReferralRequest/f:specialty"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ReferralRequest-status"/>
    <resource>
      <SearchParameter>
        <id value="ReferralRequest-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/ReferralRequest-status"/>
        <name value="status"/>
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
        <code value="status"/>
        <base value="ReferralRequest"/>
        <type value="token"/>
        <description value="The status of the referral"/>
        <expression value="ReferralRequest.status"/>
        <xpath value="f:ReferralRequest/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ReferralRequest-subject"/>
    <resource>
      <SearchParameter>
        <id value="ReferralRequest-subject"/>
        <url value="http://hl7.org/fhir/SearchParameter/ReferralRequest-subject"/>
        <name value="subject"/>
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
        <code value="subject"/>
        <base value="ReferralRequest"/>
        <type value="reference"/>
        <description value="Patient referred to care or transfer"/>
        <expression value="ReferralRequest.subject"/>
        <xpath value="f:ReferralRequest/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Group"/>
        <target value="Patient"/>
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
