Class HS.FHIR.vSTU3.Repository.Resource.CommunicationRequest Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-CommunicationRequest"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-authored"/>
    <resource>
      <SearchParameter>
        <id value="CommunicationRequest-authored"/>
        <url value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-authored"/>
        <name value="authored"/>
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
        <code value="authored"/>
        <base value="CommunicationRequest"/>
        <type value="date"/>
        <description value="When request transitioned to being actionable"/>
        <expression value="CommunicationRequest.authoredOn"/>
        <xpath value="f:CommunicationRequest/f:authoredOn"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-based-on"/>
    <resource>
      <SearchParameter>
        <id value="CommunicationRequest-based-on"/>
        <url value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-based-on"/>
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
        <base value="CommunicationRequest"/>
        <type value="reference"/>
        <description value="Fulfills plan or proposal"/>
        <expression value="CommunicationRequest.basedOn"/>
        <xpath value="f:CommunicationRequest/f:basedOn"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-category"/>
    <resource>
      <SearchParameter>
        <id value="CommunicationRequest-category"/>
        <url value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-category"/>
        <name value="category"/>
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
        <code value="category"/>
        <base value="CommunicationRequest"/>
        <type value="token"/>
        <description value="Message category"/>
        <expression value="CommunicationRequest.category"/>
        <xpath value="f:CommunicationRequest/f:category"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-context"/>
    <resource>
      <SearchParameter>
        <id value="CommunicationRequest-context"/>
        <url value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-context"/>
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
        <base value="CommunicationRequest"/>
        <type value="reference"/>
        <description value="Encounter or episode leading to message"/>
        <expression value="CommunicationRequest.context"/>
        <xpath value="f:CommunicationRequest/f:context"/>
        <xpathUsage value="normal"/>
        <target value="EpisodeOfCare"/>
        <target value="Encounter"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-encounter"/>
    <resource>
      <SearchParameter>
        <id value="CommunicationRequest-encounter"/>
        <url value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-encounter"/>
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
        <base value="CommunicationRequest"/>
        <type value="reference"/>
        <description value="Encounter leading to message"/>
        <expression value="CommunicationRequest.context"/>
        <xpath value="f:CommunicationRequest/f:context"/>
        <xpathUsage value="normal"/>
        <target value="Encounter"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-group-identifier"/>
    <resource>
      <SearchParameter>
        <id value="CommunicationRequest-group-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-group-identifier"/>
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
        <base value="CommunicationRequest"/>
        <type value="token"/>
        <description value="Composite request this is part of"/>
        <expression value="CommunicationRequest.groupIdentifier"/>
        <xpath value="f:CommunicationRequest/f:groupIdentifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-identifier"/>
    <resource>
      <SearchParameter>
        <id value="CommunicationRequest-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-identifier"/>
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
        <base value="CommunicationRequest"/>
        <type value="token"/>
        <description value="Unique identifier"/>
        <expression value="CommunicationRequest.identifier"/>
        <xpath value="f:CommunicationRequest/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-medium"/>
    <resource>
      <SearchParameter>
        <id value="CommunicationRequest-medium"/>
        <url value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-medium"/>
        <name value="medium"/>
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
        <code value="medium"/>
        <base value="CommunicationRequest"/>
        <type value="token"/>
        <description value="A channel of communication"/>
        <expression value="CommunicationRequest.medium"/>
        <xpath value="f:CommunicationRequest/f:medium"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-occurrence"/>
    <resource>
      <SearchParameter>
        <id value="CommunicationRequest-occurrence"/>
        <url value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-occurrence"/>
        <name value="occurrence"/>
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
        <code value="occurrence"/>
        <base value="CommunicationRequest"/>
        <type value="date"/>
        <description value="When scheduled"/>
        <expression value="CommunicationRequest.occurrence.as(DateTime)"/>
        <xpath value="f:CommunicationRequest/f:occurrenceDateTime"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-patient"/>
    <resource>
      <SearchParameter>
        <id value="CommunicationRequest-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-patient"/>
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
        <base value="CommunicationRequest"/>
        <type value="reference"/>
        <description value="Focus of message"/>
        <expression value="CommunicationRequest.subject"/>
        <xpath value="f:CommunicationRequest/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-priority"/>
    <resource>
      <SearchParameter>
        <id value="CommunicationRequest-priority"/>
        <url value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-priority"/>
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
        <base value="CommunicationRequest"/>
        <type value="token"/>
        <description value="Message urgency"/>
        <expression value="CommunicationRequest.priority"/>
        <xpath value="f:CommunicationRequest/f:priority"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-recipient"/>
    <resource>
      <SearchParameter>
        <id value="CommunicationRequest-recipient"/>
        <url value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-recipient"/>
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
        <base value="CommunicationRequest"/>
        <type value="reference"/>
        <description value="Message recipient"/>
        <expression value="CommunicationRequest.recipient"/>
        <xpath value="f:CommunicationRequest/f:recipient"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="Group"/>
        <target value="Organization"/>
        <target value="CareTeam"/>
        <target value="Device"/>
        <target value="Patient"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-replaces"/>
    <resource>
      <SearchParameter>
        <id value="CommunicationRequest-replaces"/>
        <url value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-replaces"/>
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
        <base value="CommunicationRequest"/>
        <type value="reference"/>
        <description value="Request(s) replaced by this request"/>
        <expression value="CommunicationRequest.replaces"/>
        <xpath value="f:CommunicationRequest/f:replaces"/>
        <xpathUsage value="normal"/>
        <target value="CommunicationRequest"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-requester"/>
    <resource>
      <SearchParameter>
        <id value="CommunicationRequest-requester"/>
        <url value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-requester"/>
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
        <base value="CommunicationRequest"/>
        <type value="reference"/>
        <description value="Individual making the request"/>
        <expression value="CommunicationRequest.requester.agent"/>
        <xpath value="f:CommunicationRequest/f:requester/f:agent"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-sender"/>
    <resource>
      <SearchParameter>
        <id value="CommunicationRequest-sender"/>
        <url value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-sender"/>
        <name value="sender"/>
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
        <code value="sender"/>
        <base value="CommunicationRequest"/>
        <type value="reference"/>
        <description value="Message sender"/>
        <expression value="CommunicationRequest.sender"/>
        <xpath value="f:CommunicationRequest/f:sender"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-status"/>
    <resource>
      <SearchParameter>
        <id value="CommunicationRequest-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-status"/>
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
        <base value="CommunicationRequest"/>
        <type value="token"/>
        <description value="draft | active | suspended | cancelled | completed | entered-in-error | unknown"/>
        <expression value="CommunicationRequest.status"/>
        <xpath value="f:CommunicationRequest/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-subject"/>
    <resource>
      <SearchParameter>
        <id value="CommunicationRequest-subject"/>
        <url value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-subject"/>
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
        <base value="CommunicationRequest"/>
        <type value="reference"/>
        <description value="Focus of message"/>
        <expression value="CommunicationRequest.subject"/>
        <xpath value="f:CommunicationRequest/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Group"/>
        <target value="Patient"/>
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
