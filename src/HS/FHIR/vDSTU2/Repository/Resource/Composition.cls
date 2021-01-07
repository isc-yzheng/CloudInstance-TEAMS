Class HS.FHIR.vDSTU2.Repository.Resource.Composition Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

/// Excluded because we do not currently support searching on a collection of periods.
Parameter EXCLUDEPARAMS = ",period,";

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Composition"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Composition-attester"/>
    <resource>
      <SearchParameter>
        <id value="Composition-attester"/>
        <url value="http://hl7.org/fhir/SearchParameter/Composition-attester"/>
        <name value="attester"/>
        <publisher value="Health Level Seven International (Structured Documents)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/structure/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="attester"/>
        <base value="Composition"/>
        <type value="reference"/>
        <description value="Who attested the composition"/>
        <xpath value="f:Composition/f:attester/f:party"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
        <target value="Patient"/>
        <target value="Practitioner"/>
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
        <publisher value="Health Level Seven International (Structured Documents)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/structure/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="author"/>
        <base value="Composition"/>
        <type value="reference"/>
        <description value="Who and/or what authored the composition"/>
        <xpath value="f:Composition/f:author"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="Patient"/>
        <target value="Practitioner"/>
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
        <publisher value="Health Level Seven International (Structured Documents)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/structure/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="class"/>
        <base value="Composition"/>
        <type value="token"/>
        <description value="Categorization of Composition"/>
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
        <publisher value="Health Level Seven International (Structured Documents)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/structure/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="confidentiality"/>
        <base value="Composition"/>
        <type value="token"/>
        <description value="As defined by affinity domain"/>
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
        <publisher value="Health Level Seven International (Structured Documents)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/structure/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="context"/>
        <base value="Composition"/>
        <type value="token"/>
        <description value="Code(s) that apply to the event being documented"/>
        <xpath value="f:Composition/f:event/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Composition-date"/>
    <resource>
      <SearchParameter>
        <id value="Composition-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/Composition-date"/>
        <name value="date"/>
        <publisher value="Health Level Seven International (Structured Documents)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/structure/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="date"/>
        <base value="Composition"/>
        <type value="date"/>
        <description value="Composition editing time"/>
        <xpath value="f:Composition/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Composition-encounter"/>
    <resource>
      <SearchParameter>
        <id value="Composition-encounter"/>
        <url value="http://hl7.org/fhir/SearchParameter/Composition-encounter"/>
        <name value="encounter"/>
        <publisher value="Health Level Seven International (Structured Documents)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/structure/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="encounter"/>
        <base value="Composition"/>
        <type value="reference"/>
        <description value="Context of the Composition"/>
        <xpath value="f:Composition/f:encounter"/>
        <xpathUsage value="normal"/>
        <target value="Encounter"/>
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
        <publisher value="Health Level Seven International (Structured Documents)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/structure/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="entry"/>
        <base value="Composition"/>
        <type value="reference"/>
        <description value="A reference to data that supports this section"/>
        <xpath value="f:Composition/f:section/f:entry"/>
        <xpathUsage value="normal"/>
        <target value="Account"/>
        <target value="AllergyIntolerance"/>
        <target value="Appointment"/>
        <target value="AppointmentResponse"/>
        <target value="AuditEvent"/>
        <target value="Basic"/>
        <target value="Binary"/>
        <target value="BodySite"/>
        <target value="Bundle"/>
        <target value="CarePlan"/>
        <target value="Claim"/>
        <target value="ClaimResponse"/>
        <target value="ClinicalImpression"/>
        <target value="Communication"/>
        <target value="CommunicationRequest"/>
        <target value="Composition"/>
        <target value="ConceptMap"/>
        <target value="Condition"/>
        <target value="Conformance"/>
        <target value="Contract"/>
        <target value="Coverage"/>
        <target value="DataElement"/>
        <target value="DetectedIssue"/>
        <target value="Device"/>
        <target value="DeviceComponent"/>
        <target value="DeviceMetric"/>
        <target value="DeviceUseRequest"/>
        <target value="DeviceUseStatement"/>
        <target value="DiagnosticOrder"/>
        <target value="DiagnosticReport"/>
        <target value="DocumentManifest"/>
        <target value="DocumentReference"/>
        <target value="EligibilityRequest"/>
        <target value="EligibilityResponse"/>
        <target value="Encounter"/>
        <target value="EnrollmentRequest"/>
        <target value="EnrollmentResponse"/>
        <target value="EpisodeOfCare"/>
        <target value="ExplanationOfBenefit"/>
        <target value="FamilyMemberHistory"/>
        <target value="Flag"/>
        <target value="Goal"/>
        <target value="Group"/>
        <target value="HealthcareService"/>
        <target value="ImagingObjectSelection"/>
        <target value="ImagingStudy"/>
        <target value="Immunization"/>
        <target value="ImmunizationRecommendation"/>
        <target value="ImplementationGuide"/>
        <target value="List"/>
        <target value="Location"/>
        <target value="Media"/>
        <target value="Medication"/>
        <target value="MedicationAdministration"/>
        <target value="MedicationDispense"/>
        <target value="MedicationOrder"/>
        <target value="MedicationStatement"/>
        <target value="MessageHeader"/>
        <target value="NamingSystem"/>
        <target value="NutritionOrder"/>
        <target value="Observation"/>
        <target value="OperationDefinition"/>
        <target value="OperationOutcome"/>
        <target value="Order"/>
        <target value="OrderResponse"/>
        <target value="Organization"/>
        <target value="Patient"/>
        <target value="PaymentNotice"/>
        <target value="PaymentReconciliation"/>
        <target value="Person"/>
        <target value="Practitioner"/>
        <target value="Procedure"/>
        <target value="ProcedureRequest"/>
        <target value="ProcessRequest"/>
        <target value="ProcessResponse"/>
        <target value="Provenance"/>
        <target value="Questionnaire"/>
        <target value="QuestionnaireResponse"/>
        <target value="ReferralRequest"/>
        <target value="RelatedPerson"/>
        <target value="RiskAssessment"/>
        <target value="Schedule"/>
        <target value="SearchParameter"/>
        <target value="Slot"/>
        <target value="Specimen"/>
        <target value="StructureDefinition"/>
        <target value="Subscription"/>
        <target value="Substance"/>
        <target value="SupplyDelivery"/>
        <target value="SupplyRequest"/>
        <target value="TestScript"/>
        <target value="ValueSet"/>
        <target value="VisionPrescription"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Composition-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Composition-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Composition-identifier"/>
        <name value="identifier"/>
        <publisher value="Health Level Seven International (Structured Documents)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/structure/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="identifier"/>
        <base value="Composition"/>
        <type value="token"/>
        <description value="Logical identifier of composition (version-independent)"/>
        <xpath value="f:Composition/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Composition-patient"/>
    <resource>
      <SearchParameter>
        <id value="Composition-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/Composition-patient"/>
        <name value="patient"/>
        <publisher value="Health Level Seven International (Structured Documents)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/structure/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="patient"/>
        <base value="Composition"/>
        <type value="reference"/>
        <description value="Who and/or what the composition is about"/>
        <xpath value="f:Composition/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Account"/>
        <target value="AllergyIntolerance"/>
        <target value="Appointment"/>
        <target value="AppointmentResponse"/>
        <target value="AuditEvent"/>
        <target value="Basic"/>
        <target value="Binary"/>
        <target value="BodySite"/>
        <target value="Bundle"/>
        <target value="CarePlan"/>
        <target value="Claim"/>
        <target value="ClaimResponse"/>
        <target value="ClinicalImpression"/>
        <target value="Communication"/>
        <target value="CommunicationRequest"/>
        <target value="Composition"/>
        <target value="ConceptMap"/>
        <target value="Condition"/>
        <target value="Conformance"/>
        <target value="Contract"/>
        <target value="Coverage"/>
        <target value="DataElement"/>
        <target value="DetectedIssue"/>
        <target value="Device"/>
        <target value="DeviceComponent"/>
        <target value="DeviceMetric"/>
        <target value="DeviceUseRequest"/>
        <target value="DeviceUseStatement"/>
        <target value="DiagnosticOrder"/>
        <target value="DiagnosticReport"/>
        <target value="DocumentManifest"/>
        <target value="DocumentReference"/>
        <target value="EligibilityRequest"/>
        <target value="EligibilityResponse"/>
        <target value="Encounter"/>
        <target value="EnrollmentRequest"/>
        <target value="EnrollmentResponse"/>
        <target value="EpisodeOfCare"/>
        <target value="ExplanationOfBenefit"/>
        <target value="FamilyMemberHistory"/>
        <target value="Flag"/>
        <target value="Goal"/>
        <target value="Group"/>
        <target value="HealthcareService"/>
        <target value="ImagingObjectSelection"/>
        <target value="ImagingStudy"/>
        <target value="Immunization"/>
        <target value="ImmunizationRecommendation"/>
        <target value="ImplementationGuide"/>
        <target value="List"/>
        <target value="Location"/>
        <target value="Media"/>
        <target value="Medication"/>
        <target value="MedicationAdministration"/>
        <target value="MedicationDispense"/>
        <target value="MedicationOrder"/>
        <target value="MedicationStatement"/>
        <target value="MessageHeader"/>
        <target value="NamingSystem"/>
        <target value="NutritionOrder"/>
        <target value="Observation"/>
        <target value="OperationDefinition"/>
        <target value="OperationOutcome"/>
        <target value="Order"/>
        <target value="OrderResponse"/>
        <target value="Organization"/>
        <target value="Patient"/>
        <target value="PaymentNotice"/>
        <target value="PaymentReconciliation"/>
        <target value="Person"/>
        <target value="Practitioner"/>
        <target value="Procedure"/>
        <target value="ProcedureRequest"/>
        <target value="ProcessRequest"/>
        <target value="ProcessResponse"/>
        <target value="Provenance"/>
        <target value="Questionnaire"/>
        <target value="QuestionnaireResponse"/>
        <target value="ReferralRequest"/>
        <target value="RelatedPerson"/>
        <target value="RiskAssessment"/>
        <target value="Schedule"/>
        <target value="SearchParameter"/>
        <target value="Slot"/>
        <target value="Specimen"/>
        <target value="StructureDefinition"/>
        <target value="Subscription"/>
        <target value="Substance"/>
        <target value="SupplyDelivery"/>
        <target value="SupplyRequest"/>
        <target value="TestScript"/>
        <target value="ValueSet"/>
        <target value="VisionPrescription"/>
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
        <publisher value="Health Level Seven International (Structured Documents)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/structure/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="period"/>
        <base value="Composition"/>
        <type value="date"/>
        <description value="The period covered by the documentation"/>
        <xpath value="f:Composition/f:event/f:period"/>
        <xpathUsage value="normal"/>
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
        <publisher value="Health Level Seven International (Structured Documents)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/structure/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="section"/>
        <base value="Composition"/>
        <type value="token"/>
        <description value="Classification of section (recommended)"/>
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
        <publisher value="Health Level Seven International (Structured Documents)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/structure/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="status"/>
        <base value="Composition"/>
        <type value="token"/>
        <description value="preliminary | final | amended | entered-in-error"/>
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
        <publisher value="Health Level Seven International (Structured Documents)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/structure/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="subject"/>
        <base value="Composition"/>
        <type value="reference"/>
        <description value="Who and/or what the composition is about"/>
        <xpath value="f:Composition/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Account"/>
        <target value="AllergyIntolerance"/>
        <target value="Appointment"/>
        <target value="AppointmentResponse"/>
        <target value="AuditEvent"/>
        <target value="Basic"/>
        <target value="Binary"/>
        <target value="BodySite"/>
        <target value="Bundle"/>
        <target value="CarePlan"/>
        <target value="Claim"/>
        <target value="ClaimResponse"/>
        <target value="ClinicalImpression"/>
        <target value="Communication"/>
        <target value="CommunicationRequest"/>
        <target value="Composition"/>
        <target value="ConceptMap"/>
        <target value="Condition"/>
        <target value="Conformance"/>
        <target value="Contract"/>
        <target value="Coverage"/>
        <target value="DataElement"/>
        <target value="DetectedIssue"/>
        <target value="Device"/>
        <target value="DeviceComponent"/>
        <target value="DeviceMetric"/>
        <target value="DeviceUseRequest"/>
        <target value="DeviceUseStatement"/>
        <target value="DiagnosticOrder"/>
        <target value="DiagnosticReport"/>
        <target value="DocumentManifest"/>
        <target value="DocumentReference"/>
        <target value="EligibilityRequest"/>
        <target value="EligibilityResponse"/>
        <target value="Encounter"/>
        <target value="EnrollmentRequest"/>
        <target value="EnrollmentResponse"/>
        <target value="EpisodeOfCare"/>
        <target value="ExplanationOfBenefit"/>
        <target value="FamilyMemberHistory"/>
        <target value="Flag"/>
        <target value="Goal"/>
        <target value="Group"/>
        <target value="HealthcareService"/>
        <target value="ImagingObjectSelection"/>
        <target value="ImagingStudy"/>
        <target value="Immunization"/>
        <target value="ImmunizationRecommendation"/>
        <target value="ImplementationGuide"/>
        <target value="List"/>
        <target value="Location"/>
        <target value="Media"/>
        <target value="Medication"/>
        <target value="MedicationAdministration"/>
        <target value="MedicationDispense"/>
        <target value="MedicationOrder"/>
        <target value="MedicationStatement"/>
        <target value="MessageHeader"/>
        <target value="NamingSystem"/>
        <target value="NutritionOrder"/>
        <target value="Observation"/>
        <target value="OperationDefinition"/>
        <target value="OperationOutcome"/>
        <target value="Order"/>
        <target value="OrderResponse"/>
        <target value="Organization"/>
        <target value="Patient"/>
        <target value="PaymentNotice"/>
        <target value="PaymentReconciliation"/>
        <target value="Person"/>
        <target value="Practitioner"/>
        <target value="Procedure"/>
        <target value="ProcedureRequest"/>
        <target value="ProcessRequest"/>
        <target value="ProcessResponse"/>
        <target value="Provenance"/>
        <target value="Questionnaire"/>
        <target value="QuestionnaireResponse"/>
        <target value="ReferralRequest"/>
        <target value="RelatedPerson"/>
        <target value="RiskAssessment"/>
        <target value="Schedule"/>
        <target value="SearchParameter"/>
        <target value="Slot"/>
        <target value="Specimen"/>
        <target value="StructureDefinition"/>
        <target value="Subscription"/>
        <target value="Substance"/>
        <target value="SupplyDelivery"/>
        <target value="SupplyRequest"/>
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
        <publisher value="Health Level Seven International (Structured Documents)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/structure/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="title"/>
        <base value="Composition"/>
        <type value="string"/>
        <description value="Human Readable name/title"/>
        <xpath value="f:Composition/f:title"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Composition-type"/>
    <resource>
      <SearchParameter>
        <id value="Composition-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/Composition-type"/>
        <name value="type"/>
        <publisher value="Health Level Seven International (Structured Documents)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/structure/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="type"/>
        <base value="Composition"/>
        <type value="token"/>
        <description value="Kind of composition (LOINC if possible)"/>
        <xpath value="f:Composition/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
