Class HS.FHIR.vDSTU2.Repository.Resource.DocumentReference Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-DocumentReference"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DocumentReference-authenticator"/>
    <resource>
      <SearchParameter>
        <id value="DocumentReference-authenticator"/>
        <url value="http://hl7.org/fhir/SearchParameter/DocumentReference-authenticator"/>
        <name value="authenticator"/>
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
        <code value="authenticator"/>
        <base value="DocumentReference"/>
        <type value="reference"/>
        <description value="Who/what authenticated the document"/>
        <xpath value="f:DocumentReference/f:authenticator"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DocumentReference-author"/>
    <resource>
      <SearchParameter>
        <id value="DocumentReference-author"/>
        <url value="http://hl7.org/fhir/SearchParameter/DocumentReference-author"/>
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
        <base value="DocumentReference"/>
        <type value="reference"/>
        <description value="Who and/or what authored the document"/>
        <xpath value="f:DocumentReference/f:author"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DocumentReference-class"/>
    <resource>
      <SearchParameter>
        <id value="DocumentReference-class"/>
        <url value="http://hl7.org/fhir/SearchParameter/DocumentReference-class"/>
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
        <base value="DocumentReference"/>
        <type value="token"/>
        <description value="Categorization of document"/>
        <xpath value="f:DocumentReference/f:class"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DocumentReference-created"/>
    <resource>
      <SearchParameter>
        <id value="DocumentReference-created"/>
        <url value="http://hl7.org/fhir/SearchParameter/DocumentReference-created"/>
        <name value="created"/>
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
        <code value="created"/>
        <base value="DocumentReference"/>
        <type value="date"/>
        <description value="Document creation time"/>
        <xpath value="f:DocumentReference/f:created"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DocumentReference-custodian"/>
    <resource>
      <SearchParameter>
        <id value="DocumentReference-custodian"/>
        <url value="http://hl7.org/fhir/SearchParameter/DocumentReference-custodian"/>
        <name value="custodian"/>
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
        <code value="custodian"/>
        <base value="DocumentReference"/>
        <type value="reference"/>
        <description value="Organization which maintains the document"/>
        <xpath value="f:DocumentReference/f:custodian"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DocumentReference-description"/>
    <resource>
      <SearchParameter>
        <id value="DocumentReference-description"/>
        <url value="http://hl7.org/fhir/SearchParameter/DocumentReference-description"/>
        <name value="description"/>
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
        <code value="description"/>
        <base value="DocumentReference"/>
        <type value="string"/>
        <description value="Human-readable description (title)"/>
        <xpath value="f:DocumentReference/f:description"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DocumentReference-encounter"/>
    <resource>
      <SearchParameter>
        <id value="DocumentReference-encounter"/>
        <url value="http://hl7.org/fhir/SearchParameter/DocumentReference-encounter"/>
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
        <base value="DocumentReference"/>
        <type value="reference"/>
        <description value="Context of the document  content"/>
        <xpath value="f:DocumentReference/f:context/f:encounter"/>
        <xpathUsage value="normal"/>
        <target value="Encounter"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DocumentReference-event"/>
    <resource>
      <SearchParameter>
        <id value="DocumentReference-event"/>
        <url value="http://hl7.org/fhir/SearchParameter/DocumentReference-event"/>
        <name value="event"/>
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
        <code value="event"/>
        <base value="DocumentReference"/>
        <type value="token"/>
        <description value="Main Clinical Acts Documented"/>
        <xpath value="f:DocumentReference/f:context/f:event"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DocumentReference-facility"/>
    <resource>
      <SearchParameter>
        <id value="DocumentReference-facility"/>
        <url value="http://hl7.org/fhir/SearchParameter/DocumentReference-facility"/>
        <name value="facility"/>
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
        <code value="facility"/>
        <base value="DocumentReference"/>
        <type value="token"/>
        <description value="Kind of facility where patient was seen"/>
        <xpath value="f:DocumentReference/f:context/f:facilityType"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DocumentReference-format"/>
    <resource>
      <SearchParameter>
        <id value="DocumentReference-format"/>
        <url value="http://hl7.org/fhir/SearchParameter/DocumentReference-format"/>
        <name value="format"/>
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
        <code value="format"/>
        <base value="DocumentReference"/>
        <type value="token"/>
        <description value="Format/content rules for the document"/>
        <xpath value="f:DocumentReference/f:content/f:format"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DocumentReference-identifier"/>
    <resource>
      <SearchParameter>
        <id value="DocumentReference-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/DocumentReference-identifier"/>
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
        <base value="DocumentReference"/>
        <type value="token"/>
        <description value="Master Version Specific Identifier"/>
        <xpath value="f:DocumentReference/f:masterIdentifier | f:DocumentReference/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DocumentReference-indexed"/>
    <resource>
      <SearchParameter>
        <id value="DocumentReference-indexed"/>
        <url value="http://hl7.org/fhir/SearchParameter/DocumentReference-indexed"/>
        <name value="indexed"/>
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
        <code value="indexed"/>
        <base value="DocumentReference"/>
        <type value="date"/>
        <description value="When this document reference created"/>
        <xpath value="f:DocumentReference/f:indexed"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DocumentReference-language"/>
    <resource>
      <SearchParameter>
        <id value="DocumentReference-language"/>
        <url value="http://hl7.org/fhir/SearchParameter/DocumentReference-language"/>
        <name value="language"/>
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
        <code value="language"/>
        <base value="DocumentReference"/>
        <type value="token"/>
        <description value="Human language of the content (BCP-47)"/>
        <xpath value="f:DocumentReference/f:content/f:attachment/f:language"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DocumentReference-location"/>
    <resource>
      <SearchParameter>
        <id value="DocumentReference-location"/>
        <url value="http://hl7.org/fhir/SearchParameter/DocumentReference-location"/>
        <name value="location"/>
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
        <code value="location"/>
        <base value="DocumentReference"/>
        <type value="uri"/>
        <description value="Uri where the data can be found"/>
        <xpath value="f:DocumentReference/f:content/f:attachment/f:url"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DocumentReference-patient"/>
    <resource>
      <SearchParameter>
        <id value="DocumentReference-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/DocumentReference-patient"/>
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
        <base value="DocumentReference"/>
        <type value="reference"/>
        <description value="Who/what is the subject of the document"/>
        <xpath value="f:DocumentReference/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="Patient"/>
        <target value="Practitioner"/>
        <target value="Group"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DocumentReference-period"/>
    <resource>
      <SearchParameter>
        <id value="DocumentReference-period"/>
        <url value="http://hl7.org/fhir/SearchParameter/DocumentReference-period"/>
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
        <base value="DocumentReference"/>
        <type value="date"/>
        <description value="Time of service that is being documented"/>
        <xpath value="f:DocumentReference/f:context/f:period"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DocumentReference-related-id"/>
    <resource>
      <SearchParameter>
        <id value="DocumentReference-related-id"/>
        <url value="http://hl7.org/fhir/SearchParameter/DocumentReference-related-id"/>
        <name value="related-id"/>
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
        <code value="related-id"/>
        <base value="DocumentReference"/>
        <type value="token"/>
        <description value="Identifier of related objects or events"/>
        <xpath value="f:DocumentReference/f:context/f:related/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DocumentReference-related-ref"/>
    <resource>
      <SearchParameter>
        <id value="DocumentReference-related-ref"/>
        <url value="http://hl7.org/fhir/SearchParameter/DocumentReference-related-ref"/>
        <name value="related-ref"/>
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
        <code value="related-ref"/>
        <base value="DocumentReference"/>
        <type value="reference"/>
        <description value="Related Resource"/>
        <xpath value="f:DocumentReference/f:context/f:related/f:ref"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DocumentReference-relatesto"/>
    <resource>
      <SearchParameter>
        <id value="DocumentReference-relatesto"/>
        <url value="http://hl7.org/fhir/SearchParameter/DocumentReference-relatesto"/>
        <name value="relatesto"/>
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
        <code value="relatesto"/>
        <base value="DocumentReference"/>
        <type value="reference"/>
        <description value="Target of the relationship"/>
        <xpath value="f:DocumentReference/f:relatesTo/f:target"/>
        <xpathUsage value="normal"/>
        <target value="DocumentReference"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DocumentReference-relation"/>
    <resource>
      <SearchParameter>
        <id value="DocumentReference-relation"/>
        <url value="http://hl7.org/fhir/SearchParameter/DocumentReference-relation"/>
        <name value="relation"/>
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
        <code value="relation"/>
        <base value="DocumentReference"/>
        <type value="token"/>
        <description value="replaces | transforms | signs | appends"/>
        <xpath value="f:DocumentReference/f:relatesTo/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DocumentReference-relationship"/>
    <resource>
      <SearchParameter>
        <id value="DocumentReference-relationship"/>
        <url value="http://hl7.org/fhir/SearchParameter/DocumentReference-relationship"/>
        <name value="relationship"/>
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
        <code value="relationship"/>
        <base value="DocumentReference"/>
        <type value="composite"/>
        <description value="Combination of relation and relatesTo"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DocumentReference-securitylabel"/>
    <resource>
      <SearchParameter>
        <id value="DocumentReference-securitylabel"/>
        <url value="http://hl7.org/fhir/SearchParameter/DocumentReference-securitylabel"/>
        <name value="securitylabel"/>
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
        <code value="securitylabel"/>
        <base value="DocumentReference"/>
        <type value="token"/>
        <description value="Document security-tags"/>
        <xpath value="f:DocumentReference/f:securityLabel"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DocumentReference-setting"/>
    <resource>
      <SearchParameter>
        <id value="DocumentReference-setting"/>
        <url value="http://hl7.org/fhir/SearchParameter/DocumentReference-setting"/>
        <name value="setting"/>
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
        <code value="setting"/>
        <base value="DocumentReference"/>
        <type value="token"/>
        <description value="Additional details about where the content was created (e.g. clinical specialty)"/>
        <xpath value="f:DocumentReference/f:context/f:practiceSetting"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DocumentReference-status"/>
    <resource>
      <SearchParameter>
        <id value="DocumentReference-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/DocumentReference-status"/>
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
        <base value="DocumentReference"/>
        <type value="token"/>
        <description value="current | superseded | entered-in-error"/>
        <xpath value="f:DocumentReference/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DocumentReference-subject"/>
    <resource>
      <SearchParameter>
        <id value="DocumentReference-subject"/>
        <url value="http://hl7.org/fhir/SearchParameter/DocumentReference-subject"/>
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
        <base value="DocumentReference"/>
        <type value="reference"/>
        <description value="Who/what is the subject of the document"/>
        <xpath value="f:DocumentReference/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="Patient"/>
        <target value="Practitioner"/>
        <target value="Group"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DocumentReference-type"/>
    <resource>
      <SearchParameter>
        <id value="DocumentReference-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/DocumentReference-type"/>
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
        <base value="DocumentReference"/>
        <type value="token"/>
        <description value="Kind of document (LOINC if possible)"/>
        <xpath value="f:DocumentReference/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
