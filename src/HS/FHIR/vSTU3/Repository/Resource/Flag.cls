Class HS.FHIR.vSTU3.Repository.Resource.Flag Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Flag"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Flag-author"/>
    <resource>
      <SearchParameter>
        <id value="Flag-author"/>
        <url value="http://hl7.org/fhir/SearchParameter/Flag-author"/>
        <name value="author"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <code value="author"/>
        <base value="Flag"/>
        <type value="reference"/>
        <description value="Flag creator"/>
        <expression value="Flag.author"/>
        <xpath value="f:Flag/f:author"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="Organization"/>
        <target value="Device"/>
        <target value="Patient"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/clinical-encounter"/>
    <resource>
      <SearchParameter>
        <id value="clinical-encounter"/>
        <url value="http://hl7.org/fhir/SearchParameter/clinical-encounter"/>
        <name value="encounter"/>
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
        <code value="encounter"/>
        <base value="DocumentReference"/>
        <base value="RiskAssessment"/>
        <base value="DeviceRequest"/>
        <base value="Procedure"/>
        <base value="List"/>
        <base value="VisionPrescription"/>
        <base value="ProcedureRequest"/>
        <base value="Flag"/>
        <base value="Observation"/>
        <base value="DiagnosticReport"/>
        <base value="NutritionOrder"/>
        <base value="Composition"/>
        <type value="reference"/>
        <description value="Multiple Resources: 

* [DocumentReference](documentreference.html): Context of the document  content
* [RiskAssessment](riskassessment.html): Where was assessment performed?
* [DeviceRequest](devicerequest.html): Encounter or Episode during which request was created
* [Procedure](procedure.html): Search by encounter
* [List](list.html): Context in which list created
* [VisionPrescription](visionprescription.html): Return prescriptions with this encounter identifier
* [ProcedureRequest](procedurerequest.html): An encounter in which this request is made
* [Flag](flag.html): Alert relevant during encounter
* [Observation](observation.html): Encounter related to the observation
* [DiagnosticReport](diagnosticreport.html): The Encounter when the order was made
* [NutritionOrder](nutritionorder.html): Return nutrition orders with this encounter identifier
* [Composition](composition.html): Context of the Composition
"/>
        <expression value="DocumentReference.context.encounter | RiskAssessment.context | DeviceRequest.context | Procedure.context | List.encounter | VisionPrescription.encounter | ProcedureRequest.context | Flag.encounter | Observation.context | DiagnosticReport.context | NutritionOrder.encounter | Composition.encounter"/>
        <xpath value="f:DocumentReference/f:context/f:encounter | f:RiskAssessment/f:context | f:DeviceRequest/f:context | f:Procedure/f:context | f:List/f:encounter | f:VisionPrescription/f:encounter | f:ProcedureRequest/f:context | f:Flag/f:encounter | f:Observation/f:context | f:DiagnosticReport/f:context | f:NutritionOrder/f:encounter | f:Composition/f:encounter"/>
        <xpathUsage value="normal"/>
        <target value="Encounter"/>
        <target value="EpisodeOfCare"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Flag-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Flag-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Flag-identifier"/>
        <name value="identifier"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <code value="identifier"/>
        <base value="Flag"/>
        <type value="token"/>
        <description value="Business identifier"/>
        <expression value="Flag.identifier"/>
        <xpath value="f:Flag/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/clinical-patient"/>
    <resource>
      <SearchParameter>
        <id value="clinical-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/clinical-patient"/>
        <name value="patient"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <code value="patient"/>
        <base value="ReferralRequest"/>
        <base value="DocumentManifest"/>
        <base value="Goal"/>
        <base value="Consent"/>
        <base value="DocumentReference"/>
        <base value="ImagingManifest"/>
        <base value="RiskAssessment"/>
        <base value="CareTeam"/>
        <base value="ImagingStudy"/>
        <base value="FamilyMemberHistory"/>
        <base value="Encounter"/>
        <base value="DeviceUseStatement"/>
        <base value="DeviceRequest"/>
        <base value="AllergyIntolerance"/>
        <base value="CarePlan"/>
        <base value="EpisodeOfCare"/>
        <base value="Procedure"/>
        <base value="List"/>
        <base value="Immunization"/>
        <base value="VisionPrescription"/>
        <base value="ProcedureRequest"/>
        <base value="Flag"/>
        <base value="Observation"/>
        <base value="DiagnosticReport"/>
        <base value="NutritionOrder"/>
        <base value="Condition"/>
        <base value="Composition"/>
        <base value="DetectedIssue"/>
        <base value="SupplyDelivery"/>
        <base value="ClinicalImpression"/>
        <type value="reference"/>
        <description value="Multiple Resources: 

* [ReferralRequest](referralrequest.html): Who the referral is about
* [DocumentManifest](documentmanifest.html): The subject of the set of documents
* [Goal](goal.html): Who this goal is intended for
* [Consent](consent.html): Who the consent applies to
* [DocumentReference](documentreference.html): Who/what is the subject of the document
* [ImagingManifest](imagingmanifest.html): Subject of the ImagingManifest (or a DICOM Key Object Selection which it represents)
* [RiskAssessment](riskassessment.html): Who/what does assessment apply to?
* [CareTeam](careteam.html): Who care team is for
* [ImagingStudy](imagingstudy.html): Who the study is about
* [FamilyMemberHistory](familymemberhistory.html): The identity of a subject to list family member history items for
* [Encounter](encounter.html): The patient ro group present at the encounter
* [DeviceUseStatement](deviceusestatement.html): Search by subject - a patient
* [DeviceRequest](devicerequest.html): Individual the service is ordered for
* [AllergyIntolerance](allergyintolerance.html): Who the sensitivity is for
* [CarePlan](careplan.html): Who care plan is for
* [EpisodeOfCare](episodeofcare.html): The patient who is the focus of this episode of care
* [Procedure](procedure.html): Search by subject - a patient
* [List](list.html): If all resources have the same subject
* [Immunization](immunization.html): The patient for the vaccination record
* [VisionPrescription](visionprescription.html): The identity of a patient to list dispenses for
* [ProcedureRequest](procedurerequest.html): Search by subject - a patient
* [Flag](flag.html): The identity of a subject to list flags for
* [Observation](observation.html): The subject that the observation is about (if patient)
* [DiagnosticReport](diagnosticreport.html): The subject of the report if a patient
* [NutritionOrder](nutritionorder.html): The identity of the person who requires the diet, formula or nutritional supplement
* [Condition](condition.html): Who has the condition?
* [Composition](composition.html): Who and/or what the composition is about
* [DetectedIssue](detectedissue.html): Associated patient
* [SupplyDelivery](supplydelivery.html): Patient for whom the item is supplied
* [ClinicalImpression](clinicalimpression.html): Patient or group assessed
"/>
        <expression value="ReferralRequest.subject | DocumentManifest.subject | Goal.subject | Consent.patient | DocumentReference.subject | ImagingManifest.patient | RiskAssessment.subject | CareTeam.subject | ImagingStudy.patient | FamilyMemberHistory.patient | Encounter.subject | DeviceUseStatement.subject | DeviceRequest.subject | AllergyIntolerance.patient | CarePlan.subject | EpisodeOfCare.patient | Procedure.subject | List.subject | Immunization.patient | VisionPrescription.patient | ProcedureRequest.subject | Flag.subject | Observation.subject | DiagnosticReport.subject | NutritionOrder.patient | Condition.subject | Composition.subject | DetectedIssue.patient | SupplyDelivery.patient | ClinicalImpression.subject"/>
        <xpath value="f:ReferralRequest/f:subject | f:DocumentManifest/f:subject | f:Goal/f:subject | f:Consent/f:patient | f:DocumentReference/f:subject | f:ImagingManifest/f:patient | f:RiskAssessment/f:subject | f:CareTeam/f:subject | f:ImagingStudy/f:patient | f:FamilyMemberHistory/f:patient | f:Encounter/f:subject | f:DeviceUseStatement/f:subject | f:DeviceRequest/f:subject | f:AllergyIntolerance/f:patient | f:CarePlan/f:subject | f:EpisodeOfCare/f:patient | f:Procedure/f:subject | f:List/f:subject | f:Immunization/f:patient | f:VisionPrescription/f:patient | f:ProcedureRequest/f:subject | f:Flag/f:subject | f:Observation/f:subject | f:DiagnosticReport/f:subject | f:NutritionOrder/f:patient | f:Condition/f:subject | f:Composition/f:subject | f:DetectedIssue/f:patient | f:SupplyDelivery/f:patient | f:ClinicalImpression/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
        <target value="Group"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Flag-subject"/>
    <resource>
      <SearchParameter>
        <id value="Flag-subject"/>
        <url value="http://hl7.org/fhir/SearchParameter/Flag-subject"/>
        <name value="subject"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <code value="subject"/>
        <base value="Flag"/>
        <type value="reference"/>
        <description value="The identity of a subject to list flags for"/>
        <expression value="Flag.subject"/>
        <xpath value="f:Flag/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="Group"/>
        <target value="Organization"/>
        <target value="Medication"/>
        <target value="Patient"/>
        <target value="PlanDefinition"/>
        <target value="Procedure"/>
        <target value="Location"/>
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
