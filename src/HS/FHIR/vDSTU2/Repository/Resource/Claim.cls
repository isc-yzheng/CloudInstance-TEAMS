Class HS.FHIR.vDSTU2.Repository.Resource.Claim Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Claim"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Claim-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Claim-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Claim-identifier"/>
        <name value="identifier"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="identifier"/>
        <base value="Claim"/>
        <type value="token"/>
        <description value="The primary identifier of the financial resource"/>
        <xpath value="f:Claim/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Claim-patient"/>
    <resource>
      <SearchParameter>
        <id value="Claim-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/Claim-patient"/>
        <name value="patient"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="patient"/>
        <base value="Claim"/>
        <type value="reference"/>
        <description value="Patient"/>
        <xpath value="f:Claim/f:patient"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Claim-priority"/>
    <resource>
      <SearchParameter>
        <id value="Claim-priority"/>
        <url value="http://hl7.org/fhir/SearchParameter/Claim-priority"/>
        <name value="priority"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="priority"/>
        <base value="Claim"/>
        <type value="token"/>
        <description value="Processing priority requested"/>
        <xpath value="f:Claim/f:priority"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Claim-provider"/>
    <resource>
      <SearchParameter>
        <id value="Claim-provider"/>
        <url value="http://hl7.org/fhir/SearchParameter/Claim-provider"/>
        <name value="provider"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="provider"/>
        <base value="Claim"/>
        <type value="reference"/>
        <description value="Provider responsible for the claim"/>
        <xpath value="f:Claim/f:provider"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Claim-use"/>
    <resource>
      <SearchParameter>
        <id value="Claim-use"/>
        <url value="http://hl7.org/fhir/SearchParameter/Claim-use"/>
        <name value="use"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="use"/>
        <base value="Claim"/>
        <type value="token"/>
        <description value="The kind of financial resource"/>
        <xpath value="f:Claim/f:use"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
