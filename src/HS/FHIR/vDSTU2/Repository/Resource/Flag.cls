Class HS.FHIR.vDSTU2.Repository.Resource.Flag Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Flag"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Flag-author"/>
    <resource>
      <SearchParameter>
        <id value="Flag-author"/>
        <url value="http://hl7.org/fhir/SearchParameter/Flag-author"/>
        <name value="author"/>
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
        <code value="author"/>
        <base value="Flag"/>
        <type value="reference"/>
        <description value="Flag creator"/>
        <xpath value="f:Flag/f:author"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="Patient"/>
        <target value="Organization"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Flag-date"/>
    <resource>
      <SearchParameter>
        <id value="Flag-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/Flag-date"/>
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
        <base value="Flag"/>
        <type value="date"/>
        <description value="Time period when flag is active"/>
        <xpath value="f:Flag/f:period"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Flag-encounter"/>
    <resource>
      <SearchParameter>
        <id value="Flag-encounter"/>
        <url value="http://hl7.org/fhir/SearchParameter/Flag-encounter"/>
        <name value="encounter"/>
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
        <code value="encounter"/>
        <base value="Flag"/>
        <type value="reference"/>
        <description value="Alert relevant during encounter"/>
        <xpath value="f:Flag/f:encounter"/>
        <xpathUsage value="normal"/>
        <target value="Encounter"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Flag-patient"/>
    <resource>
      <SearchParameter>
        <id value="Flag-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/Flag-patient"/>
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
        <base value="Flag"/>
        <type value="reference"/>
        <description value="The identity of a subject to list flags for"/>
        <xpath value="f:Flag/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
        <target value="Location"/>
        <target value="Patient"/>
        <target value="Practitioner"/>
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
        <base value="Flag"/>
        <type value="reference"/>
        <description value="The identity of a subject to list flags for"/>
        <xpath value="f:Flag/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
        <target value="Location"/>
        <target value="Patient"/>
        <target value="Practitioner"/>
        <target value="Group"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
