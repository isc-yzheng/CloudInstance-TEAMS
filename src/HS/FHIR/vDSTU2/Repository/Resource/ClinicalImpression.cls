Class HS.FHIR.vDSTU2.Repository.Resource.ClinicalImpression Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-ClinicalImpression"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ClinicalImpression-action"/>
    <resource>
      <SearchParameter>
        <id value="ClinicalImpression-action"/>
        <url value="http://hl7.org/fhir/SearchParameter/ClinicalImpression-action"/>
        <name value="action"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="action"/>
        <base value="ClinicalImpression"/>
        <type value="reference"/>
        <description value="Actions taken during assessment"/>
        <xpath value="f:ClinicalImpression/f:action"/>
        <xpathUsage value="normal"/>
        <target value="ReferralRequest"/>
        <target value="Appointment"/>
        <target value="ProcedureRequest"/>
        <target value="SupplyRequest"/>
        <target value="Procedure"/>
        <target value="MedicationOrder"/>
        <target value="NutritionOrder"/>
        <target value="DiagnosticOrder"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ClinicalImpression-assessor"/>
    <resource>
      <SearchParameter>
        <id value="ClinicalImpression-assessor"/>
        <url value="http://hl7.org/fhir/SearchParameter/ClinicalImpression-assessor"/>
        <name value="assessor"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="assessor"/>
        <base value="ClinicalImpression"/>
        <type value="reference"/>
        <description value="The clinician performing the assessment"/>
        <xpath value="f:ClinicalImpression/f:assessor"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ClinicalImpression-date"/>
    <resource>
      <SearchParameter>
        <id value="ClinicalImpression-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/ClinicalImpression-date"/>
        <name value="date"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="date"/>
        <base value="ClinicalImpression"/>
        <type value="date"/>
        <description value="When the assessment occurred"/>
        <xpath value="f:ClinicalImpression/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ClinicalImpression-finding"/>
    <resource>
      <SearchParameter>
        <id value="ClinicalImpression-finding"/>
        <url value="http://hl7.org/fhir/SearchParameter/ClinicalImpression-finding"/>
        <name value="finding"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="finding"/>
        <base value="ClinicalImpression"/>
        <type value="token"/>
        <description value="Specific text or code for finding"/>
        <xpath value="f:ClinicalImpression/f:finding/f:item"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ClinicalImpression-investigation"/>
    <resource>
      <SearchParameter>
        <id value="ClinicalImpression-investigation"/>
        <url value="http://hl7.org/fhir/SearchParameter/ClinicalImpression-investigation"/>
        <name value="investigation"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="investigation"/>
        <base value="ClinicalImpression"/>
        <type value="reference"/>
        <description value="Record of a specific investigation"/>
        <xpath value="f:ClinicalImpression/f:investigations/f:item"/>
        <xpathUsage value="normal"/>
        <target value="FamilyMemberHistory"/>
        <target value="Observation"/>
        <target value="QuestionnaireResponse"/>
        <target value="DiagnosticReport"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ClinicalImpression-patient"/>
    <resource>
      <SearchParameter>
        <id value="ClinicalImpression-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/ClinicalImpression-patient"/>
        <name value="patient"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="patient"/>
        <base value="ClinicalImpression"/>
        <type value="reference"/>
        <description value="The patient being assessed"/>
        <xpath value="f:ClinicalImpression/f:patient"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ClinicalImpression-plan"/>
    <resource>
      <SearchParameter>
        <id value="ClinicalImpression-plan"/>
        <url value="http://hl7.org/fhir/SearchParameter/ClinicalImpression-plan"/>
        <name value="plan"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="plan"/>
        <base value="ClinicalImpression"/>
        <type value="reference"/>
        <description value="Plan of action after assessment"/>
        <xpath value="f:ClinicalImpression/f:plan"/>
        <xpathUsage value="normal"/>
        <target value="CarePlan"/>
        <target value="ReferralRequest"/>
        <target value="ProcedureRequest"/>
        <target value="Appointment"/>
        <target value="CommunicationRequest"/>
        <target value="Order"/>
        <target value="SupplyRequest"/>
        <target value="VisionPrescription"/>
        <target value="MedicationOrder"/>
        <target value="ProcessRequest"/>
        <target value="DeviceUseRequest"/>
        <target value="NutritionOrder"/>
        <target value="DiagnosticOrder"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ClinicalImpression-previous"/>
    <resource>
      <SearchParameter>
        <id value="ClinicalImpression-previous"/>
        <url value="http://hl7.org/fhir/SearchParameter/ClinicalImpression-previous"/>
        <name value="previous"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="previous"/>
        <base value="ClinicalImpression"/>
        <type value="reference"/>
        <description value="Reference to last assessment"/>
        <xpath value="f:ClinicalImpression/f:previous"/>
        <xpathUsage value="normal"/>
        <target value="ClinicalImpression"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ClinicalImpression-problem"/>
    <resource>
      <SearchParameter>
        <id value="ClinicalImpression-problem"/>
        <url value="http://hl7.org/fhir/SearchParameter/ClinicalImpression-problem"/>
        <name value="problem"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="problem"/>
        <base value="ClinicalImpression"/>
        <type value="reference"/>
        <description value="General assessment of patient state"/>
        <xpath value="f:ClinicalImpression/f:problem"/>
        <xpathUsage value="normal"/>
        <target value="Condition"/>
        <target value="AllergyIntolerance"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ClinicalImpression-resolved"/>
    <resource>
      <SearchParameter>
        <id value="ClinicalImpression-resolved"/>
        <url value="http://hl7.org/fhir/SearchParameter/ClinicalImpression-resolved"/>
        <name value="resolved"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="resolved"/>
        <base value="ClinicalImpression"/>
        <type value="token"/>
        <description value="Diagnoses/conditions resolved since previous assessment"/>
        <xpath value="f:ClinicalImpression/f:resolved"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ClinicalImpression-ruledout"/>
    <resource>
      <SearchParameter>
        <id value="ClinicalImpression-ruledout"/>
        <url value="http://hl7.org/fhir/SearchParameter/ClinicalImpression-ruledout"/>
        <name value="ruledout"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="ruledout"/>
        <base value="ClinicalImpression"/>
        <type value="token"/>
        <description value="Specific text of code for diagnosis"/>
        <xpath value="f:ClinicalImpression/f:ruledOut/f:item"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ClinicalImpression-status"/>
    <resource>
      <SearchParameter>
        <id value="ClinicalImpression-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/ClinicalImpression-status"/>
        <name value="status"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="status"/>
        <base value="ClinicalImpression"/>
        <type value="token"/>
        <description value="in-progress | completed | entered-in-error"/>
        <xpath value="f:ClinicalImpression/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ClinicalImpression-trigger"/>
    <resource>
      <SearchParameter>
        <id value="ClinicalImpression-trigger"/>
        <url value="http://hl7.org/fhir/SearchParameter/ClinicalImpression-trigger"/>
        <name value="trigger"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="trigger"/>
        <base value="ClinicalImpression"/>
        <type value="reference"/>
        <description value="Request or event that necessitated this assessment"/>
        <xpath value="f:ClinicalImpression/f:triggerReference"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ClinicalImpression-trigger-code"/>
    <resource>
      <SearchParameter>
        <id value="ClinicalImpression-trigger-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/ClinicalImpression-trigger-code"/>
        <name value="trigger-code"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="trigger-code"/>
        <base value="ClinicalImpression"/>
        <type value="token"/>
        <description value="Request or event that necessitated this assessment"/>
        <xpath value="f:ClinicalImpression/f:triggerCodeableConcept"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
