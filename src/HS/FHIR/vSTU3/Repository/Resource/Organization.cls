Class HS.FHIR.vSTU3.Repository.Resource.Organization Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Organization"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Organization-active"/>
    <resource>
      <SearchParameter>
        <id value="Organization-active"/>
        <url value="http://hl7.org/fhir/SearchParameter/Organization-active"/>
        <name value="active"/>
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
        <code value="active"/>
        <base value="Organization"/>
        <type value="token"/>
        <description value="A server defined search that may match any of the string fields in the Address, including line, city, state, country, postalCode, and/or text"/>
        <expression value="Organization.active"/>
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
        <code value="address"/>
        <base value="Organization"/>
        <type value="string"/>
        <description value="A (part of the) address of the organization"/>
        <expression value="Organization.address"/>
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
        <code value="address-city"/>
        <base value="Organization"/>
        <type value="string"/>
        <description value="A city specified in an address"/>
        <expression value="Organization.address.city"/>
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
        <code value="address-country"/>
        <base value="Organization"/>
        <type value="string"/>
        <description value="A country specified in an address"/>
        <expression value="Organization.address.country"/>
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
        <code value="address-postalcode"/>
        <base value="Organization"/>
        <type value="string"/>
        <description value="A postal code specified in an address"/>
        <expression value="Organization.address.postalCode"/>
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
        <code value="address-state"/>
        <base value="Organization"/>
        <type value="string"/>
        <description value="A state specified in an address"/>
        <expression value="Organization.address.state"/>
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
        <code value="address-use"/>
        <base value="Organization"/>
        <type value="token"/>
        <description value="A use code specified in an address"/>
        <expression value="Organization.address.use"/>
        <xpath value="f:Organization/f:address/f:use"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Organization-endpoint"/>
    <resource>
      <SearchParameter>
        <id value="Organization-endpoint"/>
        <url value="http://hl7.org/fhir/SearchParameter/Organization-endpoint"/>
        <name value="endpoint"/>
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
        <code value="endpoint"/>
        <base value="Organization"/>
        <type value="reference"/>
        <description value="Technical endpoints providing access to services operated for the organization"/>
        <expression value="Organization.endpoint"/>
        <xpath value="f:Organization/f:endpoint"/>
        <xpathUsage value="normal"/>
        <target value="Endpoint"/>
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
        <code value="identifier"/>
        <base value="Organization"/>
        <type value="token"/>
        <description value="Any identifier for the organization (not the accreditation issuer&apos;s identifier)"/>
        <expression value="Organization.identifier"/>
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
        <code value="name"/>
        <base value="Organization"/>
        <type value="string"/>
        <description value="A portion of the organization&apos;s name or alias"/>
        <expression value="Organization.name | Organization.alias"/>
        <xpath value="f:Organization/f:name | f:Organization/f:alias"/>
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
        <code value="partof"/>
        <base value="Organization"/>
        <type value="reference"/>
        <description value="An organization of which this organization forms a part"/>
        <expression value="Organization.partOf"/>
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
        <code value="type"/>
        <base value="Organization"/>
        <type value="token"/>
        <description value="A code for the type of organization"/>
        <expression value="Organization.type"/>
        <xpath value="f:Organization/f:type"/>
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
