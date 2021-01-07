Class HS.FHIR.vSTU3.Repository.Resource.Provenance Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

/// EXCLUDEPARAMS is a list of search parameters to NOT support. "agent" is on this list
/// because Provenance-agent is a reference type search parameter but its xpath
/// as specified by the FHIR spec itself includes at least one non-reference type data field.
/// Rather than give the appearance of supporting or partially supporting a faulty FHIR spec,
/// this removes any support for the search parameter at all.
Parameter EXCLUDEPARAMS = ",agent,";

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Provenance"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Provenance-agent"/>
    <resource>
      <SearchParameter>
        <id value="Provenance-agent"/>
        <url value="http://hl7.org/fhir/SearchParameter/Provenance-agent"/>
        <name value="agent"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Security)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/secure/index.cfm"/>
          </telecom>
        </contact>
        <code value="agent"/>
        <base value="Provenance"/>
        <type value="reference"/>
        <description value="Who participated"/>
        <expression value="Provenance.agent.who"/>
        <xpath value="f:Provenance/f:agent/f:whoUri | f:Provenance/f:agent/f:whoReference"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Provenance-agent-role"/>
    <resource>
      <SearchParameter>
        <id value="Provenance-agent-role"/>
        <url value="http://hl7.org/fhir/SearchParameter/Provenance-agent-role"/>
        <name value="agent-role"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Security)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/secure/index.cfm"/>
          </telecom>
        </contact>
        <code value="agent-role"/>
        <base value="Provenance"/>
        <type value="token"/>
        <description value="What the agents role was"/>
        <expression value="Provenance.agent.role"/>
        <xpath value="f:Provenance/f:agent/f:role"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Provenance-end"/>
    <resource>
      <SearchParameter>
        <id value="Provenance-end"/>
        <url value="http://hl7.org/fhir/SearchParameter/Provenance-end"/>
        <name value="end"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Security)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/secure/index.cfm"/>
          </telecom>
        </contact>
        <code value="end"/>
        <base value="Provenance"/>
        <type value="date"/>
        <description value="End time with inclusive boundary, if not ongoing"/>
        <expression value="Provenance.period.end"/>
        <xpath value="f:Provenance/f:period/f:end"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Provenance-entity-id"/>
    <resource>
      <SearchParameter>
        <id value="Provenance-entity-id"/>
        <url value="http://hl7.org/fhir/SearchParameter/Provenance-entity-id"/>
        <name value="entity-id"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Security)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/secure/index.cfm"/>
          </telecom>
        </contact>
        <code value="entity-id"/>
        <base value="Provenance"/>
        <type value="token"/>
        <description value="Identity of entity"/>
        <expression value="Provenance.entity.what.as(Identifier)"/>
        <xpath value="f:Provenance/f:entity/f:whatIdentifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Provenance-entity-ref"/>
    <resource>
      <SearchParameter>
        <id value="Provenance-entity-ref"/>
        <url value="http://hl7.org/fhir/SearchParameter/Provenance-entity-ref"/>
        <name value="entity-ref"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Security)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/secure/index.cfm"/>
          </telecom>
        </contact>
        <code value="entity-ref"/>
        <base value="Provenance"/>
        <type value="reference"/>
        <description value="Identity of entity"/>
        <expression value="Provenance.entity.what.as(Reference)"/>
        <xpath value="f:Provenance/f:entity/f:whatReference"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Provenance-location"/>
    <resource>
      <SearchParameter>
        <id value="Provenance-location"/>
        <url value="http://hl7.org/fhir/SearchParameter/Provenance-location"/>
        <name value="location"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Security)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/secure/index.cfm"/>
          </telecom>
        </contact>
        <code value="location"/>
        <base value="Provenance"/>
        <type value="reference"/>
        <description value="Where the activity occurred, if relevant"/>
        <expression value="Provenance.location"/>
        <xpath value="f:Provenance/f:location"/>
        <xpathUsage value="normal"/>
        <target value="Location"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Provenance-patient"/>
    <resource>
      <SearchParameter>
        <id value="Provenance-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/Provenance-patient"/>
        <name value="patient"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Security)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/secure/index.cfm"/>
          </telecom>
        </contact>
        <code value="patient"/>
        <base value="Provenance"/>
        <type value="reference"/>
        <description value="Target Reference(s) (usually version specific)"/>
        <expression value="Provenance.target"/>
        <xpath value="f:Provenance/f:target"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Provenance-recorded"/>
    <resource>
      <SearchParameter>
        <id value="Provenance-recorded"/>
        <url value="http://hl7.org/fhir/SearchParameter/Provenance-recorded"/>
        <name value="recorded"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Security)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/secure/index.cfm"/>
          </telecom>
        </contact>
        <code value="recorded"/>
        <base value="Provenance"/>
        <type value="date"/>
        <description value="When the activity was recorded / updated"/>
        <expression value="Provenance.recorded"/>
        <xpath value="f:Provenance/f:recorded"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Provenance-signature-type"/>
    <resource>
      <SearchParameter>
        <id value="Provenance-signature-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/Provenance-signature-type"/>
        <name value="signature-type"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Security)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/secure/index.cfm"/>
          </telecom>
        </contact>
        <code value="signature-type"/>
        <base value="Provenance"/>
        <type value="token"/>
        <description value="Indication of the reason the entity signed the object(s)"/>
        <expression value="Provenance.signature.type"/>
        <xpath value="f:Provenance/f:signature/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Provenance-start"/>
    <resource>
      <SearchParameter>
        <id value="Provenance-start"/>
        <url value="http://hl7.org/fhir/SearchParameter/Provenance-start"/>
        <name value="start"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Security)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/secure/index.cfm"/>
          </telecom>
        </contact>
        <code value="start"/>
        <base value="Provenance"/>
        <type value="date"/>
        <description value="Starting time with inclusive boundary"/>
        <expression value="Provenance.period.start"/>
        <xpath value="f:Provenance/f:period/f:start"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Provenance-target"/>
    <resource>
      <SearchParameter>
        <id value="Provenance-target"/>
        <url value="http://hl7.org/fhir/SearchParameter/Provenance-target"/>
        <name value="target"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Security)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/secure/index.cfm"/>
          </telecom>
        </contact>
        <code value="target"/>
        <base value="Provenance"/>
        <type value="reference"/>
        <description value="Target Reference(s) (usually version specific)"/>
        <expression value="Provenance.target"/>
        <xpath value="f:Provenance/f:target"/>
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
</Bundle>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
