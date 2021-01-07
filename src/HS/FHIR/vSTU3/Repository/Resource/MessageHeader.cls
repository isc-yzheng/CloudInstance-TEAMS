Class HS.FHIR.vSTU3.Repository.Resource.MessageHeader Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-MessageHeader"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MessageHeader-author"/>
    <resource>
      <SearchParameter>
        <id value="MessageHeader-author"/>
        <url value="http://hl7.org/fhir/SearchParameter/MessageHeader-author"/>
        <name value="author"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Infrastructure And Messaging)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/special/committees/inm/index.cfm"/>
          </telecom>
        </contact>
        <code value="author"/>
        <base value="MessageHeader"/>
        <type value="reference"/>
        <description value="The source of the decision"/>
        <expression value="MessageHeader.author"/>
        <xpath value="f:MessageHeader/f:author"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MessageHeader-code"/>
    <resource>
      <SearchParameter>
        <id value="MessageHeader-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/MessageHeader-code"/>
        <name value="code"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Infrastructure And Messaging)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/special/committees/inm/index.cfm"/>
          </telecom>
        </contact>
        <code value="code"/>
        <base value="MessageHeader"/>
        <type value="token"/>
        <description value="ok | transient-error | fatal-error"/>
        <expression value="MessageHeader.response.code"/>
        <xpath value="f:MessageHeader/f:response/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MessageHeader-destination"/>
    <resource>
      <SearchParameter>
        <id value="MessageHeader-destination"/>
        <url value="http://hl7.org/fhir/SearchParameter/MessageHeader-destination"/>
        <name value="destination"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Infrastructure And Messaging)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/special/committees/inm/index.cfm"/>
          </telecom>
        </contact>
        <code value="destination"/>
        <base value="MessageHeader"/>
        <type value="string"/>
        <description value="Name of system"/>
        <expression value="MessageHeader.destination.name"/>
        <xpath value="f:MessageHeader/f:destination/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MessageHeader-destination-uri"/>
    <resource>
      <SearchParameter>
        <id value="MessageHeader-destination-uri"/>
        <url value="http://hl7.org/fhir/SearchParameter/MessageHeader-destination-uri"/>
        <name value="destination-uri"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Infrastructure And Messaging)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/special/committees/inm/index.cfm"/>
          </telecom>
        </contact>
        <code value="destination-uri"/>
        <base value="MessageHeader"/>
        <type value="uri"/>
        <description value="Actual destination address or id"/>
        <expression value="MessageHeader.destination.endpoint"/>
        <xpath value="f:MessageHeader/f:destination/f:endpoint"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MessageHeader-enterer"/>
    <resource>
      <SearchParameter>
        <id value="MessageHeader-enterer"/>
        <url value="http://hl7.org/fhir/SearchParameter/MessageHeader-enterer"/>
        <name value="enterer"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Infrastructure And Messaging)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/special/committees/inm/index.cfm"/>
          </telecom>
        </contact>
        <code value="enterer"/>
        <base value="MessageHeader"/>
        <type value="reference"/>
        <description value="The source of the data entry"/>
        <expression value="MessageHeader.enterer"/>
        <xpath value="f:MessageHeader/f:enterer"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MessageHeader-event"/>
    <resource>
      <SearchParameter>
        <id value="MessageHeader-event"/>
        <url value="http://hl7.org/fhir/SearchParameter/MessageHeader-event"/>
        <name value="event"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Infrastructure And Messaging)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/special/committees/inm/index.cfm"/>
          </telecom>
        </contact>
        <code value="event"/>
        <base value="MessageHeader"/>
        <type value="token"/>
        <description value="Code for the event this message represents"/>
        <expression value="MessageHeader.event"/>
        <xpath value="f:MessageHeader/f:event"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MessageHeader-focus"/>
    <resource>
      <SearchParameter>
        <id value="MessageHeader-focus"/>
        <url value="http://hl7.org/fhir/SearchParameter/MessageHeader-focus"/>
        <name value="focus"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Infrastructure And Messaging)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/special/committees/inm/index.cfm"/>
          </telecom>
        </contact>
        <code value="focus"/>
        <base value="MessageHeader"/>
        <type value="reference"/>
        <description value="The actual content of the message"/>
        <expression value="MessageHeader.focus"/>
        <xpath value="f:MessageHeader/f:focus"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MessageHeader-receiver"/>
    <resource>
      <SearchParameter>
        <id value="MessageHeader-receiver"/>
        <url value="http://hl7.org/fhir/SearchParameter/MessageHeader-receiver"/>
        <name value="receiver"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Infrastructure And Messaging)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/special/committees/inm/index.cfm"/>
          </telecom>
        </contact>
        <code value="receiver"/>
        <base value="MessageHeader"/>
        <type value="reference"/>
        <description value="Intended &quot;real-world&quot; recipient for the data"/>
        <expression value="MessageHeader.receiver"/>
        <xpath value="f:MessageHeader/f:receiver"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MessageHeader-response-id"/>
    <resource>
      <SearchParameter>
        <id value="MessageHeader-response-id"/>
        <url value="http://hl7.org/fhir/SearchParameter/MessageHeader-response-id"/>
        <name value="response-id"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Infrastructure And Messaging)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/special/committees/inm/index.cfm"/>
          </telecom>
        </contact>
        <code value="response-id"/>
        <base value="MessageHeader"/>
        <type value="token"/>
        <description value="Id of original message"/>
        <expression value="MessageHeader.response.identifier"/>
        <xpath value="f:MessageHeader/f:response/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MessageHeader-responsible"/>
    <resource>
      <SearchParameter>
        <id value="MessageHeader-responsible"/>
        <url value="http://hl7.org/fhir/SearchParameter/MessageHeader-responsible"/>
        <name value="responsible"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Infrastructure And Messaging)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/special/committees/inm/index.cfm"/>
          </telecom>
        </contact>
        <code value="responsible"/>
        <base value="MessageHeader"/>
        <type value="reference"/>
        <description value="Final responsibility for event"/>
        <expression value="MessageHeader.responsible"/>
        <xpath value="f:MessageHeader/f:responsible"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MessageHeader-sender"/>
    <resource>
      <SearchParameter>
        <id value="MessageHeader-sender"/>
        <url value="http://hl7.org/fhir/SearchParameter/MessageHeader-sender"/>
        <name value="sender"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Infrastructure And Messaging)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/special/committees/inm/index.cfm"/>
          </telecom>
        </contact>
        <code value="sender"/>
        <base value="MessageHeader"/>
        <type value="reference"/>
        <description value="Real world sender of the message"/>
        <expression value="MessageHeader.sender"/>
        <xpath value="f:MessageHeader/f:sender"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MessageHeader-source"/>
    <resource>
      <SearchParameter>
        <id value="MessageHeader-source"/>
        <url value="http://hl7.org/fhir/SearchParameter/MessageHeader-source"/>
        <name value="source"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Infrastructure And Messaging)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/special/committees/inm/index.cfm"/>
          </telecom>
        </contact>
        <code value="source"/>
        <base value="MessageHeader"/>
        <type value="string"/>
        <description value="Name of system"/>
        <expression value="MessageHeader.source.name"/>
        <xpath value="f:MessageHeader/f:source/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MessageHeader-source-uri"/>
    <resource>
      <SearchParameter>
        <id value="MessageHeader-source-uri"/>
        <url value="http://hl7.org/fhir/SearchParameter/MessageHeader-source-uri"/>
        <name value="source-uri"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Infrastructure And Messaging)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/special/committees/inm/index.cfm"/>
          </telecom>
        </contact>
        <code value="source-uri"/>
        <base value="MessageHeader"/>
        <type value="uri"/>
        <description value="Actual message source address or id"/>
        <expression value="MessageHeader.source.endpoint"/>
        <xpath value="f:MessageHeader/f:source/f:endpoint"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MessageHeader-target"/>
    <resource>
      <SearchParameter>
        <id value="MessageHeader-target"/>
        <url value="http://hl7.org/fhir/SearchParameter/MessageHeader-target"/>
        <name value="target"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Infrastructure And Messaging)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/special/committees/inm/index.cfm"/>
          </telecom>
        </contact>
        <code value="target"/>
        <base value="MessageHeader"/>
        <type value="reference"/>
        <description value="Particular delivery destination within the destination"/>
        <expression value="MessageHeader.destination.target"/>
        <xpath value="f:MessageHeader/f:destination/f:target"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MessageHeader-timestamp"/>
    <resource>
      <SearchParameter>
        <id value="MessageHeader-timestamp"/>
        <url value="http://hl7.org/fhir/SearchParameter/MessageHeader-timestamp"/>
        <name value="timestamp"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Infrastructure And Messaging)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/special/committees/inm/index.cfm"/>
          </telecom>
        </contact>
        <code value="timestamp"/>
        <base value="MessageHeader"/>
        <type value="date"/>
        <description value="Time that the message was sent"/>
        <expression value="MessageHeader.timestamp"/>
        <xpath value="f:MessageHeader/f:timestamp"/>
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
