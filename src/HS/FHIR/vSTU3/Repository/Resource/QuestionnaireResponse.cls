Class HS.FHIR.vSTU3.Repository.Resource.QuestionnaireResponse Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-QuestionnaireResponse"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/QuestionnaireResponse-author"/>
    <resource>
      <SearchParameter>
        <id value="QuestionnaireResponse-author"/>
        <url value="http://hl7.org/fhir/SearchParameter/QuestionnaireResponse-author"/>
        <name value="author"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="author"/>
        <base value="QuestionnaireResponse"/>
        <type value="reference"/>
        <description value="The author of the questionnaire response"/>
        <expression value="QuestionnaireResponse.author"/>
        <xpath value="f:QuestionnaireResponse/f:author"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="Device"/>
        <target value="Patient"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/QuestionnaireResponse-authored"/>
    <resource>
      <SearchParameter>
        <id value="QuestionnaireResponse-authored"/>
        <url value="http://hl7.org/fhir/SearchParameter/QuestionnaireResponse-authored"/>
        <name value="authored"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="authored"/>
        <base value="QuestionnaireResponse"/>
        <type value="date"/>
        <description value="When the questionnaire response was last changed"/>
        <expression value="QuestionnaireResponse.authored"/>
        <xpath value="f:QuestionnaireResponse/f:authored"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/QuestionnaireResponse-based-on"/>
    <resource>
      <SearchParameter>
        <id value="QuestionnaireResponse-based-on"/>
        <url value="http://hl7.org/fhir/SearchParameter/QuestionnaireResponse-based-on"/>
        <name value="based-on"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="based-on"/>
        <base value="QuestionnaireResponse"/>
        <type value="reference"/>
        <description value="Plan/proposal/order fulfilled by this questionnaire response"/>
        <expression value="QuestionnaireResponse.basedOn"/>
        <xpath value="f:QuestionnaireResponse/f:basedOn"/>
        <xpathUsage value="normal"/>
        <target value="ReferralRequest"/>
        <target value="CarePlan"/>
        <target value="ProcedureRequest"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/QuestionnaireResponse-context"/>
    <resource>
      <SearchParameter>
        <id value="QuestionnaireResponse-context"/>
        <url value="http://hl7.org/fhir/SearchParameter/QuestionnaireResponse-context"/>
        <name value="context"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="context"/>
        <base value="QuestionnaireResponse"/>
        <type value="reference"/>
        <description value="Encounter or episode associated with the questionnaire response"/>
        <expression value="QuestionnaireResponse.context"/>
        <xpath value="f:QuestionnaireResponse/f:context"/>
        <xpathUsage value="normal"/>
        <target value="EpisodeOfCare"/>
        <target value="Encounter"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/QuestionnaireResponse-identifier"/>
    <resource>
      <SearchParameter>
        <id value="QuestionnaireResponse-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/QuestionnaireResponse-identifier"/>
        <name value="identifier"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="identifier"/>
        <base value="QuestionnaireResponse"/>
        <type value="token"/>
        <description value="The unique identifier for the questionnaire response"/>
        <expression value="QuestionnaireResponse.identifier"/>
        <xpath value="f:QuestionnaireResponse/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/QuestionnaireResponse-parent"/>
    <resource>
      <SearchParameter>
        <id value="QuestionnaireResponse-parent"/>
        <url value="http://hl7.org/fhir/SearchParameter/QuestionnaireResponse-parent"/>
        <name value="parent"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="parent"/>
        <base value="QuestionnaireResponse"/>
        <type value="reference"/>
        <description value="Procedure or observation this questionnaire response was performed as a part of"/>
        <expression value="QuestionnaireResponse.parent"/>
        <xpath value="f:QuestionnaireResponse/f:parent"/>
        <xpathUsage value="normal"/>
        <target value="Observation"/>
        <target value="Procedure"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/QuestionnaireResponse-patient"/>
    <resource>
      <SearchParameter>
        <id value="QuestionnaireResponse-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/QuestionnaireResponse-patient"/>
        <name value="patient"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="patient"/>
        <base value="QuestionnaireResponse"/>
        <type value="reference"/>
        <description value="The patient that is the subject of the questionnaire response"/>
        <expression value="QuestionnaireResponse.subject"/>
        <xpath value="f:QuestionnaireResponse/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/QuestionnaireResponse-questionnaire"/>
    <resource>
      <SearchParameter>
        <id value="QuestionnaireResponse-questionnaire"/>
        <url value="http://hl7.org/fhir/SearchParameter/QuestionnaireResponse-questionnaire"/>
        <name value="questionnaire"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="questionnaire"/>
        <base value="QuestionnaireResponse"/>
        <type value="reference"/>
        <description value="The questionnaire the answers are provided for"/>
        <expression value="QuestionnaireResponse.questionnaire"/>
        <xpath value="f:QuestionnaireResponse/f:questionnaire"/>
        <xpathUsage value="normal"/>
        <target value="Questionnaire"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/QuestionnaireResponse-source"/>
    <resource>
      <SearchParameter>
        <id value="QuestionnaireResponse-source"/>
        <url value="http://hl7.org/fhir/SearchParameter/QuestionnaireResponse-source"/>
        <name value="source"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="source"/>
        <base value="QuestionnaireResponse"/>
        <type value="reference"/>
        <description value="The individual providing the information reflected in the questionnaire respose"/>
        <expression value="QuestionnaireResponse.source"/>
        <xpath value="f:QuestionnaireResponse/f:source"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="Patient"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/QuestionnaireResponse-status"/>
    <resource>
      <SearchParameter>
        <id value="QuestionnaireResponse-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/QuestionnaireResponse-status"/>
        <name value="status"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="status"/>
        <base value="QuestionnaireResponse"/>
        <type value="token"/>
        <description value="The status of the questionnaire response"/>
        <expression value="QuestionnaireResponse.status"/>
        <xpath value="f:QuestionnaireResponse/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/QuestionnaireResponse-subject"/>
    <resource>
      <SearchParameter>
        <id value="QuestionnaireResponse-subject"/>
        <url value="http://hl7.org/fhir/SearchParameter/QuestionnaireResponse-subject"/>
        <name value="subject"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="subject"/>
        <base value="QuestionnaireResponse"/>
        <type value="reference"/>
        <description value="The subject of the questionnaire response"/>
        <expression value="QuestionnaireResponse.subject"/>
        <xpath value="f:QuestionnaireResponse/f:subject"/>
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
