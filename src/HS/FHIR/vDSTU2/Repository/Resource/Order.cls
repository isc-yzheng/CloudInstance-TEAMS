Class HS.FHIR.vDSTU2.Repository.Resource.Order Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Order"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Order-date"/>
    <resource>
      <SearchParameter>
        <id value="Order-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/Order-date"/>
        <name value="date"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="date"/>
        <base value="Order"/>
        <type value="date"/>
        <description value="When the order was made"/>
        <xpath value="f:Order/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Order-detail"/>
    <resource>
      <SearchParameter>
        <id value="Order-detail"/>
        <url value="http://hl7.org/fhir/SearchParameter/Order-detail"/>
        <name value="detail"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="detail"/>
        <base value="Order"/>
        <type value="reference"/>
        <description value="What action is being ordered"/>
        <xpath value="f:Order/f:detail"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Order-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Order-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Order-identifier"/>
        <name value="identifier"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="identifier"/>
        <base value="Order"/>
        <type value="token"/>
        <description value="Instance id from source, target, and/or  others"/>
        <xpath value="f:Order/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Order-patient"/>
    <resource>
      <SearchParameter>
        <id value="Order-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/Order-patient"/>
        <name value="patient"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="patient"/>
        <base value="Order"/>
        <type value="reference"/>
        <description value="Patient this order is about"/>
        <xpath value="f:Order/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="Patient"/>
        <target value="Substance"/>
        <target value="Group"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Order-source"/>
    <resource>
      <SearchParameter>
        <id value="Order-source"/>
        <url value="http://hl7.org/fhir/SearchParameter/Order-source"/>
        <name value="source"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="source"/>
        <base value="Order"/>
        <type value="reference"/>
        <description value="Who initiated the order"/>
        <xpath value="f:Order/f:source"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Order-subject"/>
    <resource>
      <SearchParameter>
        <id value="Order-subject"/>
        <url value="http://hl7.org/fhir/SearchParameter/Order-subject"/>
        <name value="subject"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="subject"/>
        <base value="Order"/>
        <type value="reference"/>
        <description value="Patient this order is about"/>
        <xpath value="f:Order/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="Patient"/>
        <target value="Substance"/>
        <target value="Group"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Order-target"/>
    <resource>
      <SearchParameter>
        <id value="Order-target"/>
        <url value="http://hl7.org/fhir/SearchParameter/Order-target"/>
        <name value="target"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="target"/>
        <base value="Order"/>
        <type value="reference"/>
        <description value="Who is intended to fulfill the order"/>
        <xpath value="f:Order/f:target"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="Organization"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Order-when"/>
    <resource>
      <SearchParameter>
        <id value="Order-when"/>
        <url value="http://hl7.org/fhir/SearchParameter/Order-when"/>
        <name value="when"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="when"/>
        <base value="Order"/>
        <type value="date"/>
        <description value="A formal schedule"/>
        <xpath value="f:Order/f:when/f:schedule"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Order-whencode"/>
    <resource>
      <SearchParameter>
        <id value="Order-whencode"/>
        <url value="http://hl7.org/fhir/SearchParameter/Order-whencode"/>
        <name value="when_code"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="when_code"/>
        <base value="Order"/>
        <type value="token"/>
        <description value="Code specifies when request should be done. The code may simply be a priority code"/>
        <xpath value="f:Order/f:when/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
