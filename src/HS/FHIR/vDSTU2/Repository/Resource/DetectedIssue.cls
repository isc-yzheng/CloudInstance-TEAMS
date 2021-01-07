Class HS.FHIR.vDSTU2.Repository.Resource.DetectedIssue Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-DetectedIssue"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DetectedIssue-author"/>
    <resource>
      <SearchParameter>
        <id value="DetectedIssue-author"/>
        <url value="http://hl7.org/fhir/SearchParameter/DetectedIssue-author"/>
        <name value="author"/>
        <publisher value="Health Level Seven International (Clinical Decision Support)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/dss/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="author"/>
        <base value="DetectedIssue"/>
        <type value="reference"/>
        <description value="The provider or device that identified the issue"/>
        <xpath value="f:DetectedIssue/f:author"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DetectedIssue-category"/>
    <resource>
      <SearchParameter>
        <id value="DetectedIssue-category"/>
        <url value="http://hl7.org/fhir/SearchParameter/DetectedIssue-category"/>
        <name value="category"/>
        <publisher value="Health Level Seven International (Clinical Decision Support)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/dss/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="category"/>
        <base value="DetectedIssue"/>
        <type value="token"/>
        <description value="Issue Category, e.g. drug-drug, duplicate therapy, etc."/>
        <xpath value="f:DetectedIssue/f:category"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DetectedIssue-date"/>
    <resource>
      <SearchParameter>
        <id value="DetectedIssue-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/DetectedIssue-date"/>
        <name value="date"/>
        <publisher value="Health Level Seven International (Clinical Decision Support)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/dss/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="date"/>
        <base value="DetectedIssue"/>
        <type value="date"/>
        <description value="When identified"/>
        <xpath value="f:DetectedIssue/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DetectedIssue-identifier"/>
    <resource>
      <SearchParameter>
        <id value="DetectedIssue-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/DetectedIssue-identifier"/>
        <name value="identifier"/>
        <publisher value="Health Level Seven International (Clinical Decision Support)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/dss/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="identifier"/>
        <base value="DetectedIssue"/>
        <type value="token"/>
        <description value="Unique id for the detected issue"/>
        <xpath value="f:DetectedIssue/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DetectedIssue-implicated"/>
    <resource>
      <SearchParameter>
        <id value="DetectedIssue-implicated"/>
        <url value="http://hl7.org/fhir/SearchParameter/DetectedIssue-implicated"/>
        <name value="implicated"/>
        <publisher value="Health Level Seven International (Clinical Decision Support)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/dss/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="implicated"/>
        <base value="DetectedIssue"/>
        <type value="reference"/>
        <description value="Problem resource"/>
        <xpath value="f:DetectedIssue/f:implicated"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DetectedIssue-patient"/>
    <resource>
      <SearchParameter>
        <id value="DetectedIssue-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/DetectedIssue-patient"/>
        <name value="patient"/>
        <publisher value="Health Level Seven International (Clinical Decision Support)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/dss/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="patient"/>
        <base value="DetectedIssue"/>
        <type value="reference"/>
        <description value="Associated patient"/>
        <xpath value="f:DetectedIssue/f:patient"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
