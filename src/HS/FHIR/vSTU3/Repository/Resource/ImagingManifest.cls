Class HS.FHIR.vSTU3.Repository.Resource.ImagingManifest Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-ImagingManifest"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImagingManifest-author"/>
    <resource>
      <SearchParameter>
        <id value="ImagingManifest-author"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImagingManifest-author"/>
        <name value="author"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Imaging Integration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/imagemgt/index.cfm"/>
          </telecom>
        </contact>
        <code value="author"/>
        <base value="ImagingManifest"/>
        <type value="reference"/>
        <description value="Author of the ImagingManifest (or a DICOM Key Object Selection which it represents)"/>
        <expression value="ImagingManifest.author"/>
        <xpath value="f:ImagingManifest/f:author"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImagingManifest-authoring-time"/>
    <resource>
      <SearchParameter>
        <id value="ImagingManifest-authoring-time"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImagingManifest-authoring-time"/>
        <name value="authoring-time"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Imaging Integration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/imagemgt/index.cfm"/>
          </telecom>
        </contact>
        <code value="authoring-time"/>
        <base value="ImagingManifest"/>
        <type value="date"/>
        <description value="Time of the ImagingManifest (or a DICOM Key Object Selection which it represents) authoring"/>
        <expression value="ImagingManifest.authoringTime"/>
        <xpath value="f:ImagingManifest/f:authoringTime"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImagingManifest-endpoint"/>
    <resource>
      <SearchParameter>
        <id value="ImagingManifest-endpoint"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImagingManifest-endpoint"/>
        <name value="endpoint"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Imaging Integration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/imagemgt/index.cfm"/>
          </telecom>
        </contact>
        <code value="endpoint"/>
        <base value="ImagingManifest"/>
        <type value="reference"/>
        <description value="The endpoint for the study or series"/>
        <expression value="ImagingManifest.study.endpoint | ImagingManifest.study.series.endpoint"/>
        <xpath value="f:ImagingManifest/f:study/f:endpoint | f:ImagingManifest/f:study/f:series/f:endpoint"/>
        <xpathUsage value="normal"/>
        <target value="Endpoint"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImagingManifest-identifier"/>
    <resource>
      <SearchParameter>
        <id value="ImagingManifest-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImagingManifest-identifier"/>
        <name value="identifier"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Imaging Integration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/imagemgt/index.cfm"/>
          </telecom>
        </contact>
        <code value="identifier"/>
        <base value="ImagingManifest"/>
        <type value="token"/>
        <description value="UID of the ImagingManifest (or a DICOM Key Object Selection which it represents)"/>
        <expression value="ImagingManifest.identifier"/>
        <xpath value="f:ImagingManifest/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImagingManifest-imaging-study"/>
    <resource>
      <SearchParameter>
        <id value="ImagingManifest-imaging-study"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImagingManifest-imaging-study"/>
        <name value="imaging-study"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Imaging Integration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/imagemgt/index.cfm"/>
          </telecom>
        </contact>
        <code value="imaging-study"/>
        <base value="ImagingManifest"/>
        <type value="reference"/>
        <description value="ImagingStudy resource selected in the ImagingManifest (or a DICOM Key Object Selection which it represents)"/>
        <expression value="ImagingManifest.study.imagingStudy"/>
        <xpath value="f:ImagingManifest/f:study/f:imagingStudy"/>
        <xpathUsage value="normal"/>
        <target value="ImagingStudy"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImagingManifest-selected-study"/>
    <resource>
      <SearchParameter>
        <id value="ImagingManifest-selected-study"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImagingManifest-selected-study"/>
        <name value="selected-study"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Imaging Integration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/imagemgt/index.cfm"/>
          </telecom>
        </contact>
        <code value="selected-study"/>
        <base value="ImagingManifest"/>
        <type value="uri"/>
        <description value="Study selected in the ImagingManifest (or a DICOM Key Object Selection which it represents)"/>
        <expression value="ImagingManifest.study.uid"/>
        <xpath value="f:ImagingManifest/f:study/f:uid"/>
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
