Class HS.FHIR.vSTU3.Repository.Resource.AuditEvent Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-AuditEvent"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AuditEvent-action"/>
    <resource>
      <SearchParameter>
        <id value="AuditEvent-action"/>
        <url value="http://hl7.org/fhir/SearchParameter/AuditEvent-action"/>
        <name value="action"/>
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
        <code value="action"/>
        <base value="AuditEvent"/>
        <type value="token"/>
        <description value="Type of action performed during the event"/>
        <expression value="AuditEvent.action"/>
        <xpath value="f:AuditEvent/f:action"/>
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
        <code value="address"/>
        <base value="AuditEvent"/>
        <type value="string"/>
        <description value="Identifier for the network access point of the user device"/>
        <expression value="AuditEvent.agent.network.address"/>
        <xpath value="f:AuditEvent/f:agent/f:network/f:address"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AuditEvent-agent"/>
    <resource>
      <SearchParameter>
        <id value="AuditEvent-agent"/>
        <url value="http://hl7.org/fhir/SearchParameter/AuditEvent-agent"/>
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
        <base value="AuditEvent"/>
        <type value="reference"/>
        <description value="Direct reference to resource"/>
        <expression value="AuditEvent.agent.reference"/>
        <xpath value="f:AuditEvent/f:agent/f:reference"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AuditEvent-agent-name"/>
    <resource>
      <SearchParameter>
        <id value="AuditEvent-agent-name"/>
        <url value="http://hl7.org/fhir/SearchParameter/AuditEvent-agent-name"/>
        <name value="agent-name"/>
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
        <code value="agent-name"/>
        <base value="AuditEvent"/>
        <type value="string"/>
        <description value="Human-meaningful name for the agent"/>
        <expression value="AuditEvent.agent.name"/>
        <xpath value="f:AuditEvent/f:agent/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AuditEvent-agent-role"/>
    <resource>
      <SearchParameter>
        <id value="AuditEvent-agent-role"/>
        <url value="http://hl7.org/fhir/SearchParameter/AuditEvent-agent-role"/>
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
        <base value="AuditEvent"/>
        <type value="token"/>
        <description value="Agent role in the event"/>
        <expression value="AuditEvent.agent.role"/>
        <xpath value="f:AuditEvent/f:agent/f:role"/>
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
        <code value="altid"/>
        <base value="AuditEvent"/>
        <type value="token"/>
        <description value="Alternative User id e.g. authentication"/>
        <expression value="AuditEvent.agent.altId"/>
        <xpath value="f:AuditEvent/f:agent/f:altId"/>
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
        <code value="date"/>
        <base value="AuditEvent"/>
        <type value="date"/>
        <description value="Time when the event occurred on source"/>
        <expression value="AuditEvent.recorded"/>
        <xpath value="f:AuditEvent/f:recorded"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AuditEvent-entity"/>
    <resource>
      <SearchParameter>
        <id value="AuditEvent-entity"/>
        <url value="http://hl7.org/fhir/SearchParameter/AuditEvent-entity"/>
        <name value="entity"/>
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
        <code value="entity"/>
        <base value="AuditEvent"/>
        <type value="reference"/>
        <description value="Specific instance of resource"/>
        <expression value="AuditEvent.entity.reference"/>
        <xpath value="f:AuditEvent/f:entity/f:reference"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AuditEvent-entity-id"/>
    <resource>
      <SearchParameter>
        <id value="AuditEvent-entity-id"/>
        <url value="http://hl7.org/fhir/SearchParameter/AuditEvent-entity-id"/>
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
        <base value="AuditEvent"/>
        <type value="token"/>
        <description value="Specific instance of object"/>
        <expression value="AuditEvent.entity.identifier"/>
        <xpath value="f:AuditEvent/f:entity/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AuditEvent-entity-name"/>
    <resource>
      <SearchParameter>
        <id value="AuditEvent-entity-name"/>
        <url value="http://hl7.org/fhir/SearchParameter/AuditEvent-entity-name"/>
        <name value="entity-name"/>
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
        <code value="entity-name"/>
        <base value="AuditEvent"/>
        <type value="string"/>
        <description value="Descriptor for entity"/>
        <expression value="AuditEvent.entity.name"/>
        <xpath value="f:AuditEvent/f:entity/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AuditEvent-entity-role"/>
    <resource>
      <SearchParameter>
        <id value="AuditEvent-entity-role"/>
        <url value="http://hl7.org/fhir/SearchParameter/AuditEvent-entity-role"/>
        <name value="entity-role"/>
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
        <code value="entity-role"/>
        <base value="AuditEvent"/>
        <type value="token"/>
        <description value="What role the entity played"/>
        <expression value="AuditEvent.entity.role"/>
        <xpath value="f:AuditEvent/f:entity/f:role"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AuditEvent-entity-type"/>
    <resource>
      <SearchParameter>
        <id value="AuditEvent-entity-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/AuditEvent-entity-type"/>
        <name value="entity-type"/>
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
        <code value="entity-type"/>
        <base value="AuditEvent"/>
        <type value="token"/>
        <description value="Type of entity involved"/>
        <expression value="AuditEvent.entity.type"/>
        <xpath value="f:AuditEvent/f:entity/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AuditEvent-outcome"/>
    <resource>
      <SearchParameter>
        <id value="AuditEvent-outcome"/>
        <url value="http://hl7.org/fhir/SearchParameter/AuditEvent-outcome"/>
        <name value="outcome"/>
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
        <code value="outcome"/>
        <base value="AuditEvent"/>
        <type value="token"/>
        <description value="Whether the event succeeded or failed"/>
        <expression value="AuditEvent.outcome"/>
        <xpath value="f:AuditEvent/f:outcome"/>
        <xpathUsage value="normal"/>
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
        <base value="AuditEvent"/>
        <type value="reference"/>
        <description value="Direct reference to resource"/>
        <expression value="AuditEvent.agent.reference | AuditEvent.entity.reference"/>
        <xpath value="f:AuditEvent/f:agent/f:reference | f:AuditEvent/f:entity/f:reference"/>
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
        <code value="policy"/>
        <base value="AuditEvent"/>
        <type value="uri"/>
        <description value="Policy that authorized event"/>
        <expression value="AuditEvent.agent.policy"/>
        <xpath value="f:AuditEvent/f:agent/f:policy"/>
        <xpathUsage value="normal"/>
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
        <code value="site"/>
        <base value="AuditEvent"/>
        <type value="token"/>
        <description value="Logical source location within the enterprise"/>
        <expression value="AuditEvent.source.site"/>
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
        <code value="source"/>
        <base value="AuditEvent"/>
        <type value="token"/>
        <description value="The identity of source detecting the event"/>
        <expression value="AuditEvent.source.identifier"/>
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
        <code value="subtype"/>
        <base value="AuditEvent"/>
        <type value="token"/>
        <description value="More specific type/id for the event"/>
        <expression value="AuditEvent.subtype"/>
        <xpath value="f:AuditEvent/f:subtype"/>
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
        <code value="type"/>
        <base value="AuditEvent"/>
        <type value="token"/>
        <description value="Type/identifier of event"/>
        <expression value="AuditEvent.type"/>
        <xpath value="f:AuditEvent/f:type"/>
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
        <code value="user"/>
        <base value="AuditEvent"/>
        <type value="token"/>
        <description value="Unique identifier for the user"/>
        <expression value="AuditEvent.agent.userId"/>
        <xpath value="f:AuditEvent/f:agent/f:userId"/>
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
