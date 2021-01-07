Class HS.FHIR.vDSTU2.Repository.Resource.Account Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Account"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Account-balance"/>
    <resource>
      <SearchParameter>
        <id value="Account-balance"/>
        <url value="http://hl7.org/fhir/SearchParameter/Account-balance"/>
        <name value="balance"/>
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
        <code value="balance"/>
        <base value="Account"/>
        <type value="quantity"/>
        <description value="How much is in account?"/>
        <xpath value="f:Account/f:balance"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Account-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Account-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Account-identifier"/>
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
        <base value="Account"/>
        <type value="token"/>
        <description value="Account number"/>
        <xpath value="f:Account/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Account-name"/>
    <resource>
      <SearchParameter>
        <id value="Account-name"/>
        <url value="http://hl7.org/fhir/SearchParameter/Account-name"/>
        <name value="name"/>
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
        <code value="name"/>
        <base value="Account"/>
        <type value="string"/>
        <description value="Human-readable label"/>
        <xpath value="f:Account/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Account-owner"/>
    <resource>
      <SearchParameter>
        <id value="Account-owner"/>
        <url value="http://hl7.org/fhir/SearchParameter/Account-owner"/>
        <name value="owner"/>
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
        <code value="owner"/>
        <base value="Account"/>
        <type value="reference"/>
        <description value="Who is responsible?"/>
        <xpath value="f:Account/f:owner"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Account-patient"/>
    <resource>
      <SearchParameter>
        <id value="Account-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/Account-patient"/>
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
        <base value="Account"/>
        <type value="reference"/>
        <description value="What is account tied to?"/>
        <xpath value="f:Account/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="Organization"/>
        <target value="HealthcareService"/>
        <target value="Location"/>
        <target value="Patient"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Account-period"/>
    <resource>
      <SearchParameter>
        <id value="Account-period"/>
        <url value="http://hl7.org/fhir/SearchParameter/Account-period"/>
        <name value="period"/>
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
        <code value="period"/>
        <base value="Account"/>
        <type value="date"/>
        <description value="Transaction window"/>
        <xpath value="f:Account/f:coveragePeriod"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Account-status"/>
    <resource>
      <SearchParameter>
        <id value="Account-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/Account-status"/>
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
        <base value="Account"/>
        <type value="token"/>
        <description value="active | inactive"/>
        <xpath value="f:Account/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Account-subject"/>
    <resource>
      <SearchParameter>
        <id value="Account-subject"/>
        <url value="http://hl7.org/fhir/SearchParameter/Account-subject"/>
        <name value="subject"/>
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
        <code value="subject"/>
        <base value="Account"/>
        <type value="reference"/>
        <description value="What is account tied to?"/>
        <xpath value="f:Account/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="Organization"/>
        <target value="HealthcareService"/>
        <target value="Location"/>
        <target value="Patient"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Account-type"/>
    <resource>
      <SearchParameter>
        <id value="Account-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/Account-type"/>
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
        <base value="Account"/>
        <type value="token"/>
        <description value="E.g. patient, expense, depreciation"/>
        <xpath value="f:Account/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
