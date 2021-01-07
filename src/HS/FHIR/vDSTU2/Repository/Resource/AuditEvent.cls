Class HS.FHIR.vDSTU2.Repository.Resource.AuditEvent Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-AuditEvent"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AuditEvent-action"/>
    <resource>
      <SearchParameter>
        <id value="AuditEvent-action"/>
        <url value="http://hl7.org/fhir/SearchParameter/AuditEvent-action"/>
        <name value="action"/>
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
        <code value="action"/>
        <base value="AuditEvent"/>
        <type value="token"/>
        <description value="Type of action performed during the event"/>
        <xpath value="f:AuditEvent/f:event/f:action"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AuditEvent-address"/>
    <resource>
      <SearchParameter>
        <id value="AuditEvent-address"/>
        <url value="http://hl7.org/fhir/SearchParameter/AuditEvent-address"/>
        <name value="address"/>
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
        <code value="address"/>
        <base value="AuditEvent"/>
        <type value="token"/>
        <description value="Identifier for the network access point of the user device"/>
        <xpath value="f:AuditEvent/f:participant/f:network/f:address"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AuditEvent-altid"/>
    <resource>
      <SearchParameter>
        <id value="AuditEvent-altid"/>
        <url value="http://hl7.org/fhir/SearchParameter/AuditEvent-altid"/>
        <name value="altid"/>
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
        <code value="altid"/>
        <base value="AuditEvent"/>
        <type value="token"/>
        <description value="Alternative User id e.g. authentication"/>
        <xpath value="f:AuditEvent/f:participant/f:altId"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AuditEvent-date"/>
    <resource>
      <SearchParameter>
        <id value="AuditEvent-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/AuditEvent-date"/>
        <name value="date"/>
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
        <code value="date"/>
        <base value="AuditEvent"/>
        <type value="date"/>
        <description value="Time when the event occurred on source"/>
        <xpath value="f:AuditEvent/f:event/f:dateTime"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AuditEvent-desc"/>
    <resource>
      <SearchParameter>
        <id value="AuditEvent-desc"/>
        <url value="http://hl7.org/fhir/SearchParameter/AuditEvent-desc"/>
        <name value="desc"/>
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
        <code value="desc"/>
        <base value="AuditEvent"/>
        <type value="string"/>
        <description value="Instance-specific descriptor for Object"/>
        <xpath value="f:AuditEvent/f:object/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AuditEvent-identity"/>
    <resource>
      <SearchParameter>
        <id value="AuditEvent-identity"/>
        <url value="http://hl7.org/fhir/SearchParameter/AuditEvent-identity"/>
        <name value="identity"/>
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
        <code value="identity"/>
        <base value="AuditEvent"/>
        <type value="token"/>
        <description value="Specific instance of object (e.g. versioned)"/>
        <xpath value="f:AuditEvent/f:object/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AuditEvent-name"/>
    <resource>
      <SearchParameter>
        <id value="AuditEvent-name"/>
        <url value="http://hl7.org/fhir/SearchParameter/AuditEvent-name"/>
        <name value="name"/>
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
        <code value="name"/>
        <base value="AuditEvent"/>
        <type value="string"/>
        <description value="Human-meaningful name for the user"/>
        <xpath value="f:AuditEvent/f:participant/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AuditEvent-object-type"/>
    <resource>
      <SearchParameter>
        <id value="AuditEvent-object-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/AuditEvent-object-type"/>
        <name value="object-type"/>
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
        <code value="object-type"/>
        <base value="AuditEvent"/>
        <type value="token"/>
        <description value="Type of object involved"/>
        <xpath value="f:AuditEvent/f:object/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AuditEvent-participant"/>
    <resource>
      <SearchParameter>
        <id value="AuditEvent-participant"/>
        <url value="http://hl7.org/fhir/SearchParameter/AuditEvent-participant"/>
        <name value="participant"/>
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
        <code value="participant"/>
        <base value="AuditEvent"/>
        <type value="reference"/>
        <description value="Direct reference to resource"/>
        <xpath value="f:AuditEvent/f:participant/f:reference"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="Patient"/>
        <target value="Organization"/>
        <target value="Practitioner"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AuditEvent-patient"/>
    <resource>
      <SearchParameter>
        <id value="AuditEvent-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/AuditEvent-patient"/>
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
        <base value="AuditEvent"/>
        <type value="reference"/>
        <description value="Direct reference to resource"/>
        <xpath value="f:AuditEvent/f:participant/f:reference | f:AuditEvent/f:object/f:reference"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AuditEvent-policy"/>
    <resource>
      <SearchParameter>
        <id value="AuditEvent-policy"/>
        <url value="http://hl7.org/fhir/SearchParameter/AuditEvent-policy"/>
        <name value="policy"/>
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
        <code value="policy"/>
        <base value="AuditEvent"/>
        <type value="uri"/>
        <description value="Policy that authorized event"/>
        <xpath value="f:AuditEvent/f:participant/f:policy"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AuditEvent-reference"/>
    <resource>
      <SearchParameter>
        <id value="AuditEvent-reference"/>
        <url value="http://hl7.org/fhir/SearchParameter/AuditEvent-reference"/>
        <name value="reference"/>
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
        <code value="reference"/>
        <base value="AuditEvent"/>
        <type value="reference"/>
        <description value="Specific instance of resource (e.g. versioned)"/>
        <xpath value="f:AuditEvent/f:object/f:reference"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AuditEvent-site"/>
    <resource>
      <SearchParameter>
        <id value="AuditEvent-site"/>
        <url value="http://hl7.org/fhir/SearchParameter/AuditEvent-site"/>
        <name value="site"/>
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
        <code value="site"/>
        <base value="AuditEvent"/>
        <type value="token"/>
        <description value="Logical source location within the enterprise"/>
        <xpath value="f:AuditEvent/f:source/f:site"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AuditEvent-source"/>
    <resource>
      <SearchParameter>
        <id value="AuditEvent-source"/>
        <url value="http://hl7.org/fhir/SearchParameter/AuditEvent-source"/>
        <name value="source"/>
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
        <code value="source"/>
        <base value="AuditEvent"/>
        <type value="token"/>
        <description value="The identity of source detecting the event"/>
        <xpath value="f:AuditEvent/f:source/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AuditEvent-subtype"/>
    <resource>
      <SearchParameter>
        <id value="AuditEvent-subtype"/>
        <url value="http://hl7.org/fhir/SearchParameter/AuditEvent-subtype"/>
        <name value="subtype"/>
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
        <code value="subtype"/>
        <base value="AuditEvent"/>
        <type value="token"/>
        <description value="More specific type/id for the event"/>
        <xpath value="f:AuditEvent/f:event/f:subtype"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AuditEvent-type"/>
    <resource>
      <SearchParameter>
        <id value="AuditEvent-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/AuditEvent-type"/>
        <name value="type"/>
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
        <code value="type"/>
        <base value="AuditEvent"/>
        <type value="token"/>
        <description value="Type/identifier of event"/>
        <xpath value="f:AuditEvent/f:event/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AuditEvent-user"/>
    <resource>
      <SearchParameter>
        <id value="AuditEvent-user"/>
        <url value="http://hl7.org/fhir/SearchParameter/AuditEvent-user"/>
        <name value="user"/>
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
        <code value="user"/>
        <base value="AuditEvent"/>
        <type value="token"/>
        <description value="Unique identifier for the user"/>
        <xpath value="f:AuditEvent/f:participant/f:userId"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
