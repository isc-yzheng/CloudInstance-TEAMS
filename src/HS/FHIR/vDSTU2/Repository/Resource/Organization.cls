Class HS.FHIR.vDSTU2.Repository.Resource.Organization Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Organization"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Organization-active"/>
    <resource>
      <SearchParameter>
        <id value="Organization-active"/>
        <url value="http://hl7.org/fhir/SearchParameter/Organization-active"/>
        <name value="active"/>
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
        <code value="active"/>
        <base value="Organization"/>
        <type value="token"/>
        <description value="Whether the organization&apos;s record is active"/>
        <xpath value="f:Organization/f:active"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Organization-address"/>
    <resource>
      <SearchParameter>
        <id value="Organization-address"/>
        <url value="http://hl7.org/fhir/SearchParameter/Organization-address"/>
        <name value="address"/>
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
        <code value="address"/>
        <base value="Organization"/>
        <type value="string"/>
        <description value="A (part of the) address of the Organization"/>
        <xpath value="f:Organization/f:address"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Organization-address-city"/>
    <resource>
      <SearchParameter>
        <id value="Organization-address-city"/>
        <url value="http://hl7.org/fhir/SearchParameter/Organization-address-city"/>
        <name value="address-city"/>
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
        <code value="address-city"/>
        <base value="Organization"/>
        <type value="string"/>
        <description value="A city specified in an address"/>
        <xpath value="f:Organization/f:address/f:city"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Organization-address-country"/>
    <resource>
      <SearchParameter>
        <id value="Organization-address-country"/>
        <url value="http://hl7.org/fhir/SearchParameter/Organization-address-country"/>
        <name value="address-country"/>
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
        <code value="address-country"/>
        <base value="Organization"/>
        <type value="string"/>
        <description value="A country specified in an address"/>
        <xpath value="f:Organization/f:address/f:country"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Organization-address-postalcode"/>
    <resource>
      <SearchParameter>
        <id value="Organization-address-postalcode"/>
        <url value="http://hl7.org/fhir/SearchParameter/Organization-address-postalcode"/>
        <name value="address-postalcode"/>
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
        <code value="address-postalcode"/>
        <base value="Organization"/>
        <type value="string"/>
        <description value="A postal code specified in an address"/>
        <xpath value="f:Organization/f:address/f:postalCode"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Organization-address-state"/>
    <resource>
      <SearchParameter>
        <id value="Organization-address-state"/>
        <url value="http://hl7.org/fhir/SearchParameter/Organization-address-state"/>
        <name value="address-state"/>
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
        <code value="address-state"/>
        <base value="Organization"/>
        <type value="string"/>
        <description value="A state specified in an address"/>
        <xpath value="f:Organization/f:address/f:state"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Organization-address-use"/>
    <resource>
      <SearchParameter>
        <id value="Organization-address-use"/>
        <url value="http://hl7.org/fhir/SearchParameter/Organization-address-use"/>
        <name value="address-use"/>
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
        <code value="address-use"/>
        <base value="Organization"/>
        <type value="token"/>
        <description value="A use code specified in an address"/>
        <xpath value="f:Organization/f:address/f:use"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Organization-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Organization-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Organization-identifier"/>
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
        <base value="Organization"/>
        <type value="token"/>
        <description value="Any identifier for the organization (not the accreditation issuer&apos;s identifier)"/>
        <xpath value="f:Organization/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Organization-name"/>
    <resource>
      <SearchParameter>
        <id value="Organization-name"/>
        <url value="http://hl7.org/fhir/SearchParameter/Organization-name"/>
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
        <base value="Organization"/>
        <type value="string"/>
        <description value="A portion of the organization&apos;s name"/>
        <xpath value="f:Organization/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Organization-partof"/>
    <resource>
      <SearchParameter>
        <id value="Organization-partof"/>
        <url value="http://hl7.org/fhir/SearchParameter/Organization-partof"/>
        <name value="partof"/>
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
        <code value="partof"/>
        <base value="Organization"/>
        <type value="reference"/>
        <description value="Search all organizations that are part of the given organization"/>
        <xpath value="f:Organization/f:partOf"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Organization-type"/>
    <resource>
      <SearchParameter>
        <id value="Organization-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/Organization-type"/>
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
        <base value="Organization"/>
        <type value="token"/>
        <description value="A code for the type of organization"/>
        <xpath value="f:Organization/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
