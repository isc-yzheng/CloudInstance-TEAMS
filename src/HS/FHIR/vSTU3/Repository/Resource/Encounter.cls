Class HS.FHIR.vSTU3.Repository.Resource.Encounter Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

/// Excluded because we do not currently support searching on a collection of periods.
Parameter EXCLUDEPARAMS = ",location-period,";

Method length() As %Status
{
	// The length property of Encounter is a Duration, which has units and a value. However, the length search parameter is a number and refers
	// to the length of the encounter in days, so calculate length if possible, otherwise don't
	// index for it.
	try {
		if (..Format="JSON") {
			set tXPath = "f:Encounter/f:length/f:value/@value"
			Set tResults = 0
			Set tSC = ..EvaluateXPathDynamicObj(..ResourceObject, .tXPath, .tResults)
			If tResults'=1 quit
			set tVal = tResults(1)
			set tXPath = "f:Encounter/f:length/f:code/@value"
			Kill tResults
			Set tResults = 0
			Set tSC = ..EvaluateXPathDynamicObj(..ResourceObject, .tXPath, .tResults)
			if tResults'=1 quit
			set tUnitsCode = tResults(1)
			
			if (tVal'="")&&(tUnitsCode'="") {
				// Per the FHIR spec for duration (http://www.hl7.org/fhir/duration.profile.xml.html),
				//     "There SHALL be a code if there is a value and it SHALL be an expression of time.
				//      If system is present, it SHALL be UCUM."
				// "UCUM" is "Unified Code for Units of Measure". The codes for time are defined here:
				//      http://unitsofmeasure.org/ucum.html#para-31
				// Note that some values used here are approximate. A "year" is technically 365.25 days,
				// and a "month" is 30.4375 days (365.25/12), but that level of precision probably isn't
				// needed here.
				if (tUnitsCode = "a")       { set tLength = tVal*365 }		// years
				elseif (tUnitsCode = "mo")  { set tLength = tVal*30 }		// months
				elseif (tUnitsCode = "wk")  { set tLength = tVal*7 }		// weeks
				elseif (tUnitsCode = "d")   { set tLength = tVal }			// days
				elseif (tUnitsCode = "h")   { set tLength = tVal/24 }		// hours
				elseif (tUnitsCode = "min") { set tLength = tVal/1440 }		// minutes (60 min/hr * 24 hrs/day = 1440 min/day)
				else {
					$$$LOGWARNING("Unrecognized Encounter length units: "_tUnitsCode_"; length will not be indexed for search.")
					quit
				}
				set tSC = ..AddToSearchTableEntry("length", .tLength)
			}
			
			quit
		}
		
		// First get the value
		set tXPath = "f:Encounter/f:length/f:value/@value"
		set tSC = ##class(HS.FHIR.Utils).EvaluateXPathExpression(..XPathDoc, tXPath, ..ResourceSchema, /*ResultType*/, .tResults) quit:$$$ISERR(tSC)
		if (tResults.Count()'=1) { quit }
		set tVal = tResults.GetAt(1)
		// Then get the units ("code")
		kill tResults
		set tXPath = "f:Encounter/f:length/f:code/@value"
		set tSC = ##class(HS.FHIR.Utils).EvaluateXPathExpression(..XPathDoc, tXPath, ..ResourceSchema, /*ResultType*/, .tResults) quit:$$$ISERR(tSC)
		if (tResults.Count()'=1) { quit }
		set tUnitsCode = tResults.GetAt(1)
		
		if (tVal'="")&&(tUnitsCode'="") {
			// Per the FHIR spec for duration (http://www.hl7.org/fhir/duration.profile.xml.html),
			//     "There SHALL be a code if there is a value and it SHALL be an expression of time.
			//      If system is present, it SHALL be UCUM."
			// "UCUM" is "Unified Code for Units of Measure". The codes for time are defined here:
			//      http://unitsofmeasure.org/ucum.html#para-31
			// Note that some values used here are approximate. A "year" is technically 365.25 days,
			// and a "month" is 30.4375 days (365.25/12), but that level of precision probably isn't
			// needed here.
			if (tUnitsCode = "a")       { set tLength = tVal*365 }		// years
			elseif (tUnitsCode = "mo")  { set tLength = tVal*30 }		// months
			elseif (tUnitsCode = "wk")  { set tLength = tVal*7 }		// weeks
			elseif (tUnitsCode = "d")   { set tLength = tVal }			// days
			elseif (tUnitsCode = "h")   { set tLength = tVal/24 }		// hours
			elseif (tUnitsCode = "min") { set tLength = tVal/1440 }		// minutes (60 min/hr * 24 hrs/day = 1440 min/day)
			else {
				$$$LOGWARNING("Unrecognized Encounter length units: "_tUnitsCode_"; length will not be indexed for search.")
				quit
			}
			set tSC = ..AddToSearchTableEntry("length", tLength)
		}
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Encounter"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Encounter-appointment"/>
    <resource>
      <SearchParameter>
        <id value="Encounter-appointment"/>
        <url value="http://hl7.org/fhir/SearchParameter/Encounter-appointment"/>
        <name value="appointment"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="appointment"/>
        <base value="Encounter"/>
        <type value="reference"/>
        <description value="The appointment that scheduled this encounter"/>
        <expression value="Encounter.appointment"/>
        <xpath value="f:Encounter/f:appointment"/>
        <xpathUsage value="normal"/>
        <target value="Appointment"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Encounter-class"/>
    <resource>
      <SearchParameter>
        <id value="Encounter-class"/>
        <url value="http://hl7.org/fhir/SearchParameter/Encounter-class"/>
        <name value="class"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="class"/>
        <base value="Encounter"/>
        <type value="token"/>
        <description value="inpatient | outpatient | ambulatory | emergency +"/>
        <expression value="Encounter.class"/>
        <xpath value="f:Encounter/f:class"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Encounter-diagnosis"/>
    <resource>
      <SearchParameter>
        <id value="Encounter-diagnosis"/>
        <url value="http://hl7.org/fhir/SearchParameter/Encounter-diagnosis"/>
        <name value="diagnosis"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="diagnosis"/>
        <base value="Encounter"/>
        <type value="reference"/>
        <description value="Reason the encounter takes place (resource)"/>
        <expression value="Encounter.diagnosis.condition"/>
        <xpath value="f:Encounter/f:diagnosis/f:condition"/>
        <xpathUsage value="normal"/>
        <target value="Condition"/>
        <target value="Procedure"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Encounter-episodeofcare"/>
    <resource>
      <SearchParameter>
        <id value="Encounter-episodeofcare"/>
        <url value="http://hl7.org/fhir/SearchParameter/Encounter-episodeofcare"/>
        <name value="episodeofcare"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="episodeofcare"/>
        <base value="Encounter"/>
        <type value="reference"/>
        <description value="Episode(s) of care that this encounter should be recorded against"/>
        <expression value="Encounter.episodeOfCare"/>
        <xpath value="f:Encounter/f:episodeOfCare"/>
        <xpathUsage value="normal"/>
        <target value="EpisodeOfCare"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Encounter-incomingreferral"/>
    <resource>
      <SearchParameter>
        <id value="Encounter-incomingreferral"/>
        <url value="http://hl7.org/fhir/SearchParameter/Encounter-incomingreferral"/>
        <name value="incomingreferral"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="incomingreferral"/>
        <base value="Encounter"/>
        <type value="reference"/>
        <description value="The ReferralRequest that initiated this encounter"/>
        <expression value="Encounter.incomingReferral"/>
        <xpath value="f:Encounter/f:incomingReferral"/>
        <xpathUsage value="normal"/>
        <target value="ReferralRequest"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Encounter-length"/>
    <resource>
      <SearchParameter>
        <id value="Encounter-length"/>
        <url value="http://hl7.org/fhir/SearchParameter/Encounter-length"/>
        <name value="length"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="length"/>
        <base value="Encounter"/>
        <type value="number"/>
        <description value="Length of encounter in days"/>
        <expression value="Encounter.length"/>
        <xpath value="f:Encounter/f:length"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Encounter-location"/>
    <resource>
      <SearchParameter>
        <id value="Encounter-location"/>
        <url value="http://hl7.org/fhir/SearchParameter/Encounter-location"/>
        <name value="location"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="location"/>
        <base value="Encounter"/>
        <type value="reference"/>
        <description value="Location the encounter takes place"/>
        <expression value="Encounter.location.location"/>
        <xpath value="f:Encounter/f:location/f:location"/>
        <xpathUsage value="normal"/>
        <target value="Location"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Encounter-location-period"/>
    <resource>
      <SearchParameter>
        <id value="Encounter-location-period"/>
        <url value="http://hl7.org/fhir/SearchParameter/Encounter-location-period"/>
        <name value="location-period"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="location-period"/>
        <base value="Encounter"/>
        <type value="date"/>
        <description value="Time period during which the patient was present at the location"/>
        <expression value="Encounter.location.period"/>
        <xpath value="f:Encounter/f:location/f:period"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Encounter-part-of"/>
    <resource>
      <SearchParameter>
        <id value="Encounter-part-of"/>
        <url value="http://hl7.org/fhir/SearchParameter/Encounter-part-of"/>
        <name value="part-of"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="part-of"/>
        <base value="Encounter"/>
        <type value="reference"/>
        <description value="Another Encounter this encounter is part of"/>
        <expression value="Encounter.partOf"/>
        <xpath value="f:Encounter/f:partOf"/>
        <xpathUsage value="normal"/>
        <target value="Encounter"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Encounter-participant"/>
    <resource>
      <SearchParameter>
        <id value="Encounter-participant"/>
        <url value="http://hl7.org/fhir/SearchParameter/Encounter-participant"/>
        <name value="participant"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="participant"/>
        <base value="Encounter"/>
        <type value="reference"/>
        <description value="Persons involved in the encounter other than the patient"/>
        <expression value="Encounter.participant.individual"/>
        <xpath value="f:Encounter/f:participant/f:individual"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Encounter-participant-type"/>
    <resource>
      <SearchParameter>
        <id value="Encounter-participant-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/Encounter-participant-type"/>
        <name value="participant-type"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="participant-type"/>
        <base value="Encounter"/>
        <type value="token"/>
        <description value="Role of participant in encounter"/>
        <expression value="Encounter.participant.type"/>
        <xpath value="f:Encounter/f:participant/f:type"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Encounter-practitioner"/>
    <resource>
      <SearchParameter>
        <id value="Encounter-practitioner"/>
        <url value="http://hl7.org/fhir/SearchParameter/Encounter-practitioner"/>
        <name value="practitioner"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="practitioner"/>
        <base value="Encounter"/>
        <type value="reference"/>
        <description value="Persons involved in the encounter other than the patient"/>
        <expression value="Encounter.participant.individual"/>
        <xpath value="f:Encounter/f:participant/f:individual"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Encounter-reason"/>
    <resource>
      <SearchParameter>
        <id value="Encounter-reason"/>
        <url value="http://hl7.org/fhir/SearchParameter/Encounter-reason"/>
        <name value="reason"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="reason"/>
        <base value="Encounter"/>
        <type value="token"/>
        <description value="Reason the encounter takes place (code)"/>
        <expression value="Encounter.reason"/>
        <xpath value="f:Encounter/f:reason"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Encounter-service-provider"/>
    <resource>
      <SearchParameter>
        <id value="Encounter-service-provider"/>
        <url value="http://hl7.org/fhir/SearchParameter/Encounter-service-provider"/>
        <name value="service-provider"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="service-provider"/>
        <base value="Encounter"/>
        <type value="reference"/>
        <description value="The custodian organization of this Encounter record"/>
        <expression value="Encounter.serviceProvider"/>
        <xpath value="f:Encounter/f:serviceProvider"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Encounter-special-arrangement"/>
    <resource>
      <SearchParameter>
        <id value="Encounter-special-arrangement"/>
        <url value="http://hl7.org/fhir/SearchParameter/Encounter-special-arrangement"/>
        <name value="special-arrangement"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="special-arrangement"/>
        <base value="Encounter"/>
        <type value="token"/>
        <description value="Wheelchair, translator, stretcher, etc."/>
        <expression value="Encounter.hospitalization.specialArrangement"/>
        <xpath value="f:Encounter/f:hospitalization/f:specialArrangement"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Encounter-status"/>
    <resource>
      <SearchParameter>
        <id value="Encounter-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/Encounter-status"/>
        <name value="status"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="status"/>
        <base value="Encounter"/>
        <type value="token"/>
        <description value="planned | arrived | triaged | in-progress | onleave | finished | cancelled +"/>
        <expression value="Encounter.status"/>
        <xpath value="f:Encounter/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Encounter-subject"/>
    <resource>
      <SearchParameter>
        <id value="Encounter-subject"/>
        <url value="http://hl7.org/fhir/SearchParameter/Encounter-subject"/>
        <name value="subject"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="subject"/>
        <base value="Encounter"/>
        <type value="reference"/>
        <description value="The patient ro group present at the encounter"/>
        <expression value="Encounter.subject"/>
        <xpath value="f:Encounter/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Group"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/clinical-type"/>
    <resource>
      <SearchParameter>
        <id value="clinical-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/clinical-type"/>
        <name value="type"/>
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
        <code value="type"/>
        <base value="ReferralRequest"/>
        <base value="DocumentManifest"/>
        <base value="DocumentReference"/>
        <base value="Encounter"/>
        <base value="AllergyIntolerance"/>
        <base value="EpisodeOfCare"/>
        <base value="Composition"/>
        <type value="token"/>
        <description value="Multiple Resources: 

* [ReferralRequest](referralrequest.html): The type of the referral
* [DocumentManifest](documentmanifest.html): Kind of document set
* [DocumentReference](documentreference.html): Kind of document (LOINC if possible)
* [Encounter](encounter.html): Specific type of encounter
* [AllergyIntolerance](allergyintolerance.html): allergy | intolerance - Underlying mechanism (if known)
* [EpisodeOfCare](episodeofcare.html): Type/class  - e.g. specialist referral, disease management
* [Composition](composition.html): Kind of composition (LOINC if possible)
"/>
        <expression value="ReferralRequest.type | DocumentManifest.type | DocumentReference.type | Encounter.type | AllergyIntolerance.type | EpisodeOfCare.type | Composition.type"/>
        <xpath value="f:ReferralRequest/f:type | f:DocumentManifest/f:type | f:DocumentReference/f:type | f:Encounter/f:type | f:AllergyIntolerance/f:type | f:EpisodeOfCare/f:type | f:Composition/f:type"/>
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
