Class HS.FHIR.vDSTU2.Repository.Resource.Encounter Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
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

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Encounter"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Encounter-appointment"/>
    <resource>
      <SearchParameter>
        <id value="Encounter-appointment"/>
        <url value="http://hl7.org/fhir/SearchParameter/Encounter-appointment"/>
        <name value="appointment"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="appointment"/>
        <base value="Encounter"/>
        <type value="reference"/>
        <description value="The appointment that scheduled this encounter"/>
        <xpath value="f:Encounter/f:appointment"/>
        <xpathUsage value="normal"/>
        <target value="Appointment"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Encounter-condition"/>
    <resource>
      <SearchParameter>
        <id value="Encounter-condition"/>
        <url value="http://hl7.org/fhir/SearchParameter/Encounter-condition"/>
        <name value="condition"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="condition"/>
        <base value="Encounter"/>
        <type value="reference"/>
        <description value="Reason the encounter takes place (resource)"/>
        <xpath value="f:Encounter/f:indication"/>
        <xpathUsage value="normal"/>
        <target value="Condition"/>
        <target value="Procedure"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Encounter-date"/>
    <resource>
      <SearchParameter>
        <id value="Encounter-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/Encounter-date"/>
        <name value="date"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="date"/>
        <base value="Encounter"/>
        <type value="date"/>
        <description value="A date within the period the Encounter lasted"/>
        <xpath value="f:Encounter/f:period"/>
        <xpathUsage value="normal"/>
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
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="episodeofcare"/>
        <base value="Encounter"/>
        <type value="reference"/>
        <description value="Episode(s) of care that this encounter should be recorded against"/>
        <xpath value="f:Encounter/f:episodeOfCare"/>
        <xpathUsage value="normal"/>
        <target value="EpisodeOfCare"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Encounter-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Encounter-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Encounter-identifier"/>
        <name value="identifier"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="identifier"/>
        <base value="Encounter"/>
        <type value="token"/>
        <description value="Identifier(s) by which this encounter is known"/>
        <xpath value="f:Encounter/f:identifier"/>
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
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="incomingreferral"/>
        <base value="Encounter"/>
        <type value="reference"/>
        <description value="The ReferralRequest that initiated this encounter"/>
        <xpath value="f:Encounter/f:incomingReferral"/>
        <xpathUsage value="normal"/>
        <target value="ReferralRequest"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Encounter-indication"/>
    <resource>
      <SearchParameter>
        <id value="Encounter-indication"/>
        <url value="http://hl7.org/fhir/SearchParameter/Encounter-indication"/>
        <name value="indication"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="indication"/>
        <base value="Encounter"/>
        <type value="reference"/>
        <description value="Reason the encounter takes place (resource)"/>
        <xpath value="f:Encounter/f:indication"/>
        <xpathUsage value="normal"/>
        <target value="Condition"/>
        <target value="Procedure"/>
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
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="length"/>
        <base value="Encounter"/>
        <type value="number"/>
        <description value="Length of encounter in days"/>
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
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="location"/>
        <base value="Encounter"/>
        <type value="reference"/>
        <description value="Location the encounter takes place"/>
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
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="location-period"/>
        <base value="Encounter"/>
        <type value="date"/>
        <description value="Time period during which the patient was present at the location"/>
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
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="part-of"/>
        <base value="Encounter"/>
        <type value="reference"/>
        <description value="Another Encounter this encounter is part of"/>
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
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="participant"/>
        <base value="Encounter"/>
        <type value="reference"/>
        <description value="Persons involved in the encounter other than the patient"/>
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
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="participant-type"/>
        <base value="Encounter"/>
        <type value="token"/>
        <description value="Role of participant in encounter"/>
        <xpath value="f:Encounter/f:participant/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Encounter-patient"/>
    <resource>
      <SearchParameter>
        <id value="Encounter-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/Encounter-patient"/>
        <name value="patient"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="patient"/>
        <base value="Encounter"/>
        <type value="reference"/>
        <description value="The patient present at the encounter"/>
        <xpath value="f:Encounter/f:patient"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
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
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="practitioner"/>
        <base value="Encounter"/>
        <type value="reference"/>
        <description value="Persons involved in the encounter other than the patient"/>
        <xpath value="f:Encounter/f:participant/f:individual"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Encounter-procedure"/>
    <resource>
      <SearchParameter>
        <id value="Encounter-procedure"/>
        <url value="http://hl7.org/fhir/SearchParameter/Encounter-procedure"/>
        <name value="procedure"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="procedure"/>
        <base value="Encounter"/>
        <type value="reference"/>
        <description value="Reason the encounter takes place (resource)"/>
        <xpath value="f:Encounter/f:indication"/>
        <xpathUsage value="normal"/>
        <target value="Condition"/>
        <target value="Procedure"/>
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
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="reason"/>
        <base value="Encounter"/>
        <type value="token"/>
        <description value="Reason the encounter takes place (code)"/>
        <xpath value="f:Encounter/f:reason"/>
        <xpathUsage value="normal"/>
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
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="special-arrangement"/>
        <base value="Encounter"/>
        <type value="token"/>
        <description value="Wheelchair, translator, stretcher, etc."/>
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
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="status"/>
        <base value="Encounter"/>
        <type value="token"/>
        <description value="planned | arrived | in-progress | onleave | finished | cancelled"/>
        <xpath value="f:Encounter/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Encounter-type"/>
    <resource>
      <SearchParameter>
        <id value="Encounter-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/Encounter-type"/>
        <name value="type"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="type"/>
        <base value="Encounter"/>
        <type value="token"/>
        <description value="Specific type of encounter"/>
        <xpath value="f:Encounter/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
