Class HS.FHIR.vDSTU2.Repository.Resource.Provenance Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Provenance"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Provenance-agent"/>
    <resource>
      <SearchParameter>
        <id value="Provenance-agent"/>
        <url value="http://hl7.org/fhir/SearchParameter/Provenance-agent"/>
        <name value="agent"/>
        <publisher value="Health Level Seven International (Security)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/secure/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="agent"/>
        <base value="Provenance"/>
        <type value="reference"/>
        <description value="Individual, device or organization playing role"/>
        <xpath value="f:Provenance/f:agent/f:actor"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="Organization"/>
        <target value="Patient"/>
        <target value="Practitioner"/>
        <target value="RelatedPerson"/>
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
        <publisher value="Health Level Seven International (Security)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/secure/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="end"/>
        <base value="Provenance"/>
        <type value="date"/>
        <description value="End time with inclusive boundary, if not ongoing"/>
        <xpath value="f:Provenance/f:period/f:end"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Provenance-entity"/>
    <resource>
      <SearchParameter>
        <id value="Provenance-entity"/>
        <url value="http://hl7.org/fhir/SearchParameter/Provenance-entity"/>
        <name value="entity"/>
        <publisher value="Health Level Seven International (Security)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/secure/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="entity"/>
        <base value="Provenance"/>
        <type value="uri"/>
        <description value="Identity of entity"/>
        <xpath value="f:Provenance/f:entity/f:reference"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Provenance-entitytype"/>
    <resource>
      <SearchParameter>
        <id value="Provenance-entitytype"/>
        <url value="http://hl7.org/fhir/SearchParameter/Provenance-entitytype"/>
        <name value="entitytype"/>
        <publisher value="Health Level Seven International (Security)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/secure/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="entitytype"/>
        <base value="Provenance"/>
        <type value="token"/>
        <description value="The type of resource in this entity"/>
        <xpath value="f:Provenance/f:entity/f:type"/>
        <xpathUsage value="normal"/>
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
        <publisher value="Health Level Seven International (Security)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/secure/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="location"/>
        <base value="Provenance"/>
        <type value="reference"/>
        <description value="Where the activity occurred, if relevant"/>
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
        <publisher value="Health Level Seven International (Security)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/secure/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="patient"/>
        <base value="Provenance"/>
        <type value="reference"/>
        <description value="Target Reference(s) (usually version specific)"/>
        <xpath value="f:Provenance/f:target"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Provenance-sigtype"/>
    <resource>
      <SearchParameter>
        <id value="Provenance-sigtype"/>
        <url value="http://hl7.org/fhir/SearchParameter/Provenance-sigtype"/>
        <name value="sigtype"/>
        <publisher value="Health Level Seven International (Security)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/secure/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="sigtype"/>
        <base value="Provenance"/>
        <type value="token"/>
        <description value="Indication of the reason the entity signed the object(s)"/>
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
        <publisher value="Health Level Seven International (Security)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/secure/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="start"/>
        <base value="Provenance"/>
        <type value="date"/>
        <description value="Starting time with inclusive boundary"/>
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
        <publisher value="Health Level Seven International (Security)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/secure/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="target"/>
        <base value="Provenance"/>
        <type value="reference"/>
        <description value="Target Reference(s) (usually version specific)"/>
        <xpath value="f:Provenance/f:target"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Provenance-userid"/>
    <resource>
      <SearchParameter>
        <id value="Provenance-userid"/>
        <url value="http://hl7.org/fhir/SearchParameter/Provenance-userid"/>
        <name value="userid"/>
        <publisher value="Health Level Seven International (Security)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/secure/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="userid"/>
        <base value="Provenance"/>
        <type value="token"/>
        <description value="Authorization-system identifier for the agent"/>
        <xpath value="f:Provenance/f:agent/f:userId"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
