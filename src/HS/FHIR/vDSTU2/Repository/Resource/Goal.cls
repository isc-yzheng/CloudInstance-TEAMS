Class HS.FHIR.vDSTU2.Repository.Resource.Goal Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Goal"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Goal-category"/>
    <resource>
      <SearchParameter>
        <id value="Goal-category"/>
        <url value="http://hl7.org/fhir/SearchParameter/Goal-category"/>
        <name value="category"/>
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
        <code value="category"/>
        <base value="Goal"/>
        <type value="token"/>
        <description value="E.g. Treatment, dietary, behavioral, etc."/>
        <xpath value="f:Goal/f:category"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Goal-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Goal-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Goal-identifier"/>
        <name value="identifier"/>
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
        <code value="identifier"/>
        <base value="Goal"/>
        <type value="token"/>
        <description value="External Ids for this goal"/>
        <xpath value="f:Goal/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Goal-patient"/>
    <resource>
      <SearchParameter>
        <id value="Goal-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/Goal-patient"/>
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
        <base value="Goal"/>
        <type value="reference"/>
        <description value="Who this goal is intended for"/>
        <xpath value="f:Goal/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
        <target value="Patient"/>
        <target value="Group"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Goal-status"/>
    <resource>
      <SearchParameter>
        <id value="Goal-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/Goal-status"/>
        <name value="status"/>
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
        <code value="status"/>
        <base value="Goal"/>
        <type value="token"/>
        <description value="proposed | planned | accepted | rejected | in-progress | achieved | sustaining | on-hold | cancelled"/>
        <xpath value="f:Goal/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Goal-subject"/>
    <resource>
      <SearchParameter>
        <id value="Goal-subject"/>
        <url value="http://hl7.org/fhir/SearchParameter/Goal-subject"/>
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
        <base value="Goal"/>
        <type value="reference"/>
        <description value="Who this goal is intended for"/>
        <xpath value="f:Goal/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
        <target value="Patient"/>
        <target value="Group"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Goal-targetdate"/>
    <resource>
      <SearchParameter>
        <id value="Goal-targetdate"/>
        <url value="http://hl7.org/fhir/SearchParameter/Goal-targetdate"/>
        <name value="targetdate"/>
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
        <code value="targetdate"/>
        <base value="Goal"/>
        <type value="date"/>
        <description value="Reach goal on or before"/>
        <xpath value="f:Goal/f:targetDate"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
