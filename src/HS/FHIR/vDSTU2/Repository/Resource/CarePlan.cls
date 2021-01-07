Class HS.FHIR.vDSTU2.Repository.Resource.CarePlan Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Method activitydate()
{
	/*
		  activity-date is of type "date". The property to be indexed is an "[x]" property:
		     CarePlan.activity.detail.scheduled[x]
		  "scheduled[x]" can be one of:
		     scheduledTiming
		     scheduledPeriod
		     scheduledString
		  Right now we do not index scheduledPeriod because CarePlan.activity is a collection,
		  and we don't support searching collections of periods. We do not index scheduledString
		  because, while it technically could be a properly formatted timestamp, a properly
		  formatted timestamp shouldn't go there, it should go in scheduledTiming.
		  scheduledTiming will be indexed, specifically the value of the "event" property.
	*/
	
	try {
		set tParamName = "activitydate"
		set tXPath = "f:CarePlan/f:activity/f:detail/f:scheduledTiming/f:event"
		set tSC = ..IndexDate(tParamName, tXPath)
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
  <id value="searchParams-CarePlan"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CarePlan-activitycode"/>
    <resource>
      <SearchParameter>
        <id value="CarePlan-activitycode"/>
        <url value="http://hl7.org/fhir/SearchParameter/CarePlan-activitycode"/>
        <name value="activitycode"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="activitycode"/>
        <base value="CarePlan"/>
        <type value="token"/>
        <description value="Detail type of activity"/>
        <xpath value="f:CarePlan/f:activity/f:detail/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CarePlan-activitydate"/>
    <resource>
      <SearchParameter>
        <id value="CarePlan-activitydate"/>
        <url value="http://hl7.org/fhir/SearchParameter/CarePlan-activitydate"/>
        <name value="activitydate"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="activitydate"/>
        <base value="CarePlan"/>
        <type value="date"/>
        <description value="Specified date occurs within period specified by CarePlan.activity.timingSchedule"/>
        <xpath value="f:CarePlan/f:activity/f:detail/f:scheduledTiming | f:CarePlan/f:activity/f:detail/f:scheduledPeriod | f:CarePlan/f:activity/f:detail/f:scheduledString"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CarePlan-activityreference"/>
    <resource>
      <SearchParameter>
        <id value="CarePlan-activityreference"/>
        <url value="http://hl7.org/fhir/SearchParameter/CarePlan-activityreference"/>
        <name value="activityreference"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="activityreference"/>
        <base value="CarePlan"/>
        <type value="reference"/>
        <description value="Activity details defined in specific resource"/>
        <xpath value="f:CarePlan/f:activity/f:reference"/>
        <xpathUsage value="normal"/>
        <target value="ReferralRequest"/>
        <target value="ProcedureRequest"/>
        <target value="Appointment"/>
        <target value="CommunicationRequest"/>
        <target value="Order"/>
        <target value="SupplyRequest"/>
        <target value="VisionPrescription"/>
        <target value="MedicationOrder"/>
        <target value="ProcessRequest"/>
        <target value="DeviceUseRequest"/>
        <target value="NutritionOrder"/>
        <target value="DiagnosticOrder"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CarePlan-condition"/>
    <resource>
      <SearchParameter>
        <id value="CarePlan-condition"/>
        <url value="http://hl7.org/fhir/SearchParameter/CarePlan-condition"/>
        <name value="condition"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="condition"/>
        <base value="CarePlan"/>
        <type value="reference"/>
        <description value="Health issues this plan addresses"/>
        <xpath value="f:CarePlan/f:addresses"/>
        <xpathUsage value="normal"/>
        <target value="Condition"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CarePlan-date"/>
    <resource>
      <SearchParameter>
        <id value="CarePlan-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/CarePlan-date"/>
        <name value="date"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="date"/>
        <base value="CarePlan"/>
        <type value="date"/>
        <description value="Time period plan covers"/>
        <xpath value="f:CarePlan/f:period"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CarePlan-goal"/>
    <resource>
      <SearchParameter>
        <id value="CarePlan-goal"/>
        <url value="http://hl7.org/fhir/SearchParameter/CarePlan-goal"/>
        <name value="goal"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="goal"/>
        <base value="CarePlan"/>
        <type value="reference"/>
        <description value="Desired outcome of plan"/>
        <xpath value="f:CarePlan/f:goal"/>
        <xpathUsage value="normal"/>
        <target value="Goal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CarePlan-participant"/>
    <resource>
      <SearchParameter>
        <id value="CarePlan-participant"/>
        <url value="http://hl7.org/fhir/SearchParameter/CarePlan-participant"/>
        <name value="participant"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="participant"/>
        <base value="CarePlan"/>
        <type value="reference"/>
        <description value="Who is involved"/>
        <xpath value="f:CarePlan/f:participant/f:member"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
        <target value="Patient"/>
        <target value="Practitioner"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CarePlan-patient"/>
    <resource>
      <SearchParameter>
        <id value="CarePlan-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/CarePlan-patient"/>
        <name value="patient"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="patient"/>
        <base value="CarePlan"/>
        <type value="reference"/>
        <description value="Who care plan is for"/>
        <xpath value="f:CarePlan/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
        <target value="Group"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CarePlan-performer"/>
    <resource>
      <SearchParameter>
        <id value="CarePlan-performer"/>
        <url value="http://hl7.org/fhir/SearchParameter/CarePlan-performer"/>
        <name value="performer"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="performer"/>
        <base value="CarePlan"/>
        <type value="reference"/>
        <description value="Matches if the practitioner is listed as a performer in any of the &quot;simple&quot; activities.  (For performers of the detailed activities, chain through the activitydetail search parameter.)"/>
        <xpath value="f:CarePlan/f:activity/f:detail/f:performer"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
        <target value="Organization"/>
        <target value="Practitioner"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CarePlan-related"/>
    <resource>
      <SearchParameter>
        <id value="CarePlan-related"/>
        <url value="http://hl7.org/fhir/SearchParameter/CarePlan-related"/>
        <name value="related"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="related"/>
        <base value="CarePlan"/>
        <type value="composite"/>
        <description value="A combination of the type of relationship and the related plan"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CarePlan-relatedcode"/>
    <resource>
      <SearchParameter>
        <id value="CarePlan-relatedcode"/>
        <url value="http://hl7.org/fhir/SearchParameter/CarePlan-relatedcode"/>
        <name value="relatedcode"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="relatedcode"/>
        <base value="CarePlan"/>
        <type value="token"/>
        <description value="includes | replaces | fulfills"/>
        <xpath value="f:CarePlan/f:relatedPlan/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CarePlan-relatedplan"/>
    <resource>
      <SearchParameter>
        <id value="CarePlan-relatedplan"/>
        <url value="http://hl7.org/fhir/SearchParameter/CarePlan-relatedplan"/>
        <name value="relatedplan"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="relatedplan"/>
        <base value="CarePlan"/>
        <type value="reference"/>
        <description value="Plan relationship exists with"/>
        <xpath value="f:CarePlan/f:relatedPlan/f:plan"/>
        <xpathUsage value="normal"/>
        <target value="CarePlan"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CarePlan-subject"/>
    <resource>
      <SearchParameter>
        <id value="CarePlan-subject"/>
        <url value="http://hl7.org/fhir/SearchParameter/CarePlan-subject"/>
        <name value="subject"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="subject"/>
        <base value="CarePlan"/>
        <type value="reference"/>
        <description value="Who care plan is for"/>
        <xpath value="f:CarePlan/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
        <target value="Group"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
