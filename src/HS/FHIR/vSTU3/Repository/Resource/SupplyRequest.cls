Class HS.FHIR.vSTU3.Repository.Resource.SupplyRequest Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-SupplyRequest"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/SupplyRequest-category"/>
    <resource>
      <SearchParameter>
        <id value="SupplyRequest-category"/>
        <url value="http://hl7.org/fhir/SearchParameter/SupplyRequest-category"/>
        <name value="category"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="category"/>
        <base value="SupplyRequest"/>
        <type value="token"/>
        <description value="The kind of supply (central, non-stock, etc.)"/>
        <expression value="SupplyRequest.category"/>
        <xpath value="f:SupplyRequest/f:category"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/clinical-date"/>
    <resource>
      <SearchParameter>
        <id value="clinical-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/clinical-date"/>
        <name value="date"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Community Based Collaborative Care)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/cbcc/index.cfm"/>
          </telecom>
        </contact>
        <code value="date"/>
        <base value="Consent"/>
        <base value="SupplyRequest"/>
        <base value="RiskAssessment"/>
        <base value="CareTeam"/>
        <base value="FamilyMemberHistory"/>
        <base value="Encounter"/>
        <base value="AllergyIntolerance"/>
        <base value="CarePlan"/>
        <base value="EpisodeOfCare"/>
        <base value="Procedure"/>
        <base value="List"/>
        <base value="Immunization"/>
        <base value="Flag"/>
        <base value="Observation"/>
        <base value="DiagnosticReport"/>
        <base value="Composition"/>
        <base value="DetectedIssue"/>
        <base value="ClinicalImpression"/>
        <type value="date"/>
        <description value="Multiple Resources: 

* [Consent](consent.html): When this Consent was created or indexed
* [SupplyRequest](supplyrequest.html): When the request was made
* [RiskAssessment](riskassessment.html): When was assessment made?
* [CareTeam](careteam.html): Time period team covers
* [FamilyMemberHistory](familymemberhistory.html): When history was captured/updated
* [Encounter](encounter.html): A date within the period the Encounter lasted
* [AllergyIntolerance](allergyintolerance.html): Date record was believed accurate
* [CarePlan](careplan.html): Time period plan covers
* [EpisodeOfCare](episodeofcare.html): The provided date search value falls within the episode of care&apos;s period
* [Procedure](procedure.html): Date/Period the procedure was performed
* [List](list.html): When the list was prepared
* [Immunization](immunization.html): Vaccination  (non)-Administration Date
* [Flag](flag.html): Time period when flag is active
* [Observation](observation.html): Obtained date/time. If the obtained element is a period, a date that falls in the period
* [DiagnosticReport](diagnosticreport.html): The clinically relevant time of the report
* [Composition](composition.html): Composition editing time
* [DetectedIssue](detectedissue.html): When identified
* [ClinicalImpression](clinicalimpression.html): When the assessment was documented
"/>
        <expression value="Consent.dateTime | SupplyRequest.authoredOn | RiskAssessment.occurrence.as(DateTime) | CareTeam.period | FamilyMemberHistory.date | Encounter.period | AllergyIntolerance.assertedDate | CarePlan.period | EpisodeOfCare.period | Procedure.performed | List.date | Immunization.date | Flag.period | Observation.effective | DiagnosticReport.effective | Composition.date | DetectedIssue.date | ClinicalImpression.date"/>
        <xpath value="f:Consent/f:dateTime | f:SupplyRequest/f:authoredOn | f:RiskAssessment/f:occurrenceDateTime | f:CareTeam/f:period | f:FamilyMemberHistory/f:date | f:Encounter/f:period | f:AllergyIntolerance/f:assertedDate | f:CarePlan/f:period | f:EpisodeOfCare/f:period | f:Procedure/f:performedDateTime | f:Procedure/f:performedPeriod | f:List/f:date | f:Immunization/f:date | f:Flag/f:period | f:Observation/f:effectiveDateTime | f:Observation/f:effectivePeriod | f:DiagnosticReport/f:effectiveDateTime | f:DiagnosticReport/f:effectivePeriod | f:Composition/f:date | f:DetectedIssue/f:date | f:ClinicalImpression/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/clinical-identifier"/>
    <resource>
      <SearchParameter>
        <id value="clinical-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/clinical-identifier"/>
        <name value="identifier"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Structured Documents)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/structure/index.cfm"/>
          </telecom>
        </contact>
        <code value="identifier"/>
        <base value="DocumentManifest"/>
        <base value="Goal"/>
        <base value="Consent"/>
        <base value="DocumentReference"/>
        <base value="SupplyRequest"/>
        <base value="RiskAssessment"/>
        <base value="CareTeam"/>
        <base value="ImagingStudy"/>
        <base value="FamilyMemberHistory"/>
        <base value="Encounter"/>
        <base value="DeviceRequest"/>
        <base value="AllergyIntolerance"/>
        <base value="CarePlan"/>
        <base value="EpisodeOfCare"/>
        <base value="Procedure"/>
        <base value="List"/>
        <base value="Immunization"/>
        <base value="VisionPrescription"/>
        <base value="ProcedureRequest"/>
        <base value="Observation"/>
        <base value="DiagnosticReport"/>
        <base value="NutritionOrder"/>
        <base value="Condition"/>
        <base value="Composition"/>
        <base value="DetectedIssue"/>
        <base value="SupplyDelivery"/>
        <type value="token"/>
        <description value="Multiple Resources: 

* [DocumentManifest](documentmanifest.html): Unique Identifier for the set of documents
* [Goal](goal.html): External Ids for this goal
* [Consent](consent.html): Identifier for this record (external references)
* [DocumentReference](documentreference.html): Master Version Specific Identifier
* [SupplyRequest](supplyrequest.html): Unique identifier
* [RiskAssessment](riskassessment.html): Unique identifier for the assessment
* [CareTeam](careteam.html): External Ids for this team
* [ImagingStudy](imagingstudy.html): Other identifiers for the Study
* [FamilyMemberHistory](familymemberhistory.html): A search by a record identifier
* [Encounter](encounter.html): Identifier(s) by which this encounter is known
* [DeviceRequest](devicerequest.html): Business identifier for request/order
* [AllergyIntolerance](allergyintolerance.html): External ids for this item
* [CarePlan](careplan.html): External Ids for this plan
* [EpisodeOfCare](episodeofcare.html): Business Identifier(s) relevant for this EpisodeOfCare
* [Procedure](procedure.html): A unique identifier for a procedure
* [List](list.html): Business identifier
* [Immunization](immunization.html): Business identifier
* [VisionPrescription](visionprescription.html): Return prescriptions with this external identifier
* [ProcedureRequest](procedurerequest.html): Identifiers assigned to this order
* [Observation](observation.html): The unique id for a particular observation
* [DiagnosticReport](diagnosticreport.html): An identifier for the report
* [NutritionOrder](nutritionorder.html): Return nutrition orders with this external identifier
* [Condition](condition.html): A unique identifier of the condition record
* [Composition](composition.html): Logical identifier of composition (version-independent)
* [DetectedIssue](detectedissue.html): Unique id for the detected issue
* [SupplyDelivery](supplydelivery.html): External identifier
"/>
        <expression value="DocumentManifest.masterIdentifier | DocumentManifest.identifier | Goal.identifier | Consent.identifier | DocumentReference.masterIdentifier | DocumentReference.identifier | SupplyRequest.identifier | RiskAssessment.identifier | CareTeam.identifier | ImagingStudy.identifier | FamilyMemberHistory.identifier | Encounter.identifier | DeviceRequest.identifier | AllergyIntolerance.identifier | CarePlan.identifier | EpisodeOfCare.identifier | Procedure.identifier | List.identifier | Immunization.identifier | VisionPrescription.identifier | ProcedureRequest.identifier | Observation.identifier | DiagnosticReport.identifier | NutritionOrder.identifier | Condition.identifier | Composition.identifier | DetectedIssue.identifier | SupplyDelivery.identifier"/>
        <xpath value="f:DocumentManifest/f:masterIdentifier | f:DocumentManifest/f:identifier | f:Goal/f:identifier | f:Consent/f:identifier | f:DocumentReference/f:masterIdentifier | f:DocumentReference/f:identifier | f:SupplyRequest/f:identifier | f:RiskAssessment/f:identifier | f:CareTeam/f:identifier | f:ImagingStudy/f:identifier | f:FamilyMemberHistory/f:identifier | f:Encounter/f:identifier | f:DeviceRequest/f:identifier | f:AllergyIntolerance/f:identifier | f:CarePlan/f:identifier | f:EpisodeOfCare/f:identifier | f:Procedure/f:identifier | f:List/f:identifier | f:Immunization/f:identifier | f:VisionPrescription/f:identifier | f:ProcedureRequest/f:identifier | f:Observation/f:identifier | f:DiagnosticReport/f:identifier | f:NutritionOrder/f:identifier | f:Condition/f:identifier | f:Composition/f:identifier | f:DetectedIssue/f:identifier | f:SupplyDelivery/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/SupplyRequest-requester"/>
    <resource>
      <SearchParameter>
        <id value="SupplyRequest-requester"/>
        <url value="http://hl7.org/fhir/SearchParameter/SupplyRequest-requester"/>
        <name value="requester"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="requester"/>
        <base value="SupplyRequest"/>
        <type value="reference"/>
        <description value="Individual making the request"/>
        <expression value="SupplyRequest.requester.agent"/>
        <xpath value="f:SupplyRequest/f:requester/f:agent"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/SupplyRequest-status"/>
    <resource>
      <SearchParameter>
        <id value="SupplyRequest-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/SupplyRequest-status"/>
        <name value="status"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="status"/>
        <base value="SupplyRequest"/>
        <type value="token"/>
        <description value="draft | active | suspended +"/>
        <expression value="SupplyRequest.status"/>
        <xpath value="f:SupplyRequest/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/SupplyRequest-supplier"/>
    <resource>
      <SearchParameter>
        <id value="SupplyRequest-supplier"/>
        <url value="http://hl7.org/fhir/SearchParameter/SupplyRequest-supplier"/>
        <name value="supplier"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="supplier"/>
        <base value="SupplyRequest"/>
        <type value="reference"/>
        <description value="Who is intended to fulfill the request"/>
        <expression value="SupplyRequest.supplier"/>
        <xpath value="f:SupplyRequest/f:supplier"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
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
