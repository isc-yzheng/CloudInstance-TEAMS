Class HS.FHIR.vDSTU2.Repository.Resource.Practitioner Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Practitioner"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Practitioner-address"/>
    <resource>
      <SearchParameter>
        <id value="Practitioner-address"/>
        <url value="http://hl7.org/fhir/SearchParameter/Practitioner-address"/>
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
        <base value="Practitioner"/>
        <type value="string"/>
        <description value="An address in any kind of address/part"/>
        <xpath value="f:Practitioner/f:address"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Practitioner-address-city"/>
    <resource>
      <SearchParameter>
        <id value="Practitioner-address-city"/>
        <url value="http://hl7.org/fhir/SearchParameter/Practitioner-address-city"/>
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
        <base value="Practitioner"/>
        <type value="string"/>
        <description value="A city specified in an address"/>
        <xpath value="f:Practitioner/f:address/f:city"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Practitioner-address-country"/>
    <resource>
      <SearchParameter>
        <id value="Practitioner-address-country"/>
        <url value="http://hl7.org/fhir/SearchParameter/Practitioner-address-country"/>
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
        <base value="Practitioner"/>
        <type value="string"/>
        <description value="A country specified in an address"/>
        <xpath value="f:Practitioner/f:address/f:country"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Practitioner-address-postalcode"/>
    <resource>
      <SearchParameter>
        <id value="Practitioner-address-postalcode"/>
        <url value="http://hl7.org/fhir/SearchParameter/Practitioner-address-postalcode"/>
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
        <base value="Practitioner"/>
        <type value="string"/>
        <description value="A postalCode specified in an address"/>
        <xpath value="f:Practitioner/f:address/f:postalCode"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Practitioner-address-state"/>
    <resource>
      <SearchParameter>
        <id value="Practitioner-address-state"/>
        <url value="http://hl7.org/fhir/SearchParameter/Practitioner-address-state"/>
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
        <base value="Practitioner"/>
        <type value="string"/>
        <description value="A state specified in an address"/>
        <xpath value="f:Practitioner/f:address/f:state"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Practitioner-address-use"/>
    <resource>
      <SearchParameter>
        <id value="Practitioner-address-use"/>
        <url value="http://hl7.org/fhir/SearchParameter/Practitioner-address-use"/>
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
        <base value="Practitioner"/>
        <type value="token"/>
        <description value="A use code specified in an address"/>
        <xpath value="f:Practitioner/f:address/f:use"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Practitioner-communication"/>
    <resource>
      <SearchParameter>
        <id value="Practitioner-communication"/>
        <url value="http://hl7.org/fhir/SearchParameter/Practitioner-communication"/>
        <name value="communication"/>
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
        <code value="communication"/>
        <base value="Practitioner"/>
        <type value="token"/>
        <description value="One of the languages that the practitioner can communicate with"/>
        <xpath value="f:Practitioner/f:communication"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Practitioner-email"/>
    <resource>
      <SearchParameter>
        <id value="Practitioner-email"/>
        <url value="http://hl7.org/fhir/SearchParameter/Practitioner-email"/>
        <name value="email"/>
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
        <code value="email"/>
        <base value="Practitioner"/>
        <type value="token"/>
        <description value="A value in an email contact"/>
        <xpath value="f:Practitioner/f:telecom[system/@value=&apos;email&apos;]"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Practitioner-family"/>
    <resource>
      <SearchParameter>
        <id value="Practitioner-family"/>
        <url value="http://hl7.org/fhir/SearchParameter/Practitioner-family"/>
        <name value="family"/>
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
        <code value="family"/>
        <base value="Practitioner"/>
        <type value="string"/>
        <description value="A portion of the family name"/>
        <xpath value="f:Practitioner/f:name/f:family"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Practitioner-gender"/>
    <resource>
      <SearchParameter>
        <id value="Practitioner-gender"/>
        <url value="http://hl7.org/fhir/SearchParameter/Practitioner-gender"/>
        <name value="gender"/>
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
        <code value="gender"/>
        <base value="Practitioner"/>
        <type value="token"/>
        <description value="Gender of the practitioner"/>
        <xpath value="f:Practitioner/f:gender"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Practitioner-given"/>
    <resource>
      <SearchParameter>
        <id value="Practitioner-given"/>
        <url value="http://hl7.org/fhir/SearchParameter/Practitioner-given"/>
        <name value="given"/>
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
        <code value="given"/>
        <base value="Practitioner"/>
        <type value="string"/>
        <description value="A portion of the given name"/>
        <xpath value="f:Practitioner/f:name/f:given"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Practitioner-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Practitioner-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Practitioner-identifier"/>
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
        <base value="Practitioner"/>
        <type value="token"/>
        <description value="A practitioner&apos;s Identifier"/>
        <xpath value="f:Practitioner/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Practitioner-location"/>
    <resource>
      <SearchParameter>
        <id value="Practitioner-location"/>
        <url value="http://hl7.org/fhir/SearchParameter/Practitioner-location"/>
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
        <base value="Practitioner"/>
        <type value="reference"/>
        <description value="One of the locations at which this practitioner provides care"/>
        <xpath value="f:Practitioner/f:practitionerRole/f:location"/>
        <xpathUsage value="normal"/>
        <target value="Location"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Practitioner-name"/>
    <resource>
      <SearchParameter>
        <id value="Practitioner-name"/>
        <url value="http://hl7.org/fhir/SearchParameter/Practitioner-name"/>
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
        <base value="Practitioner"/>
        <type value="string"/>
        <description value="A portion of either family or given name"/>
        <xpath value="f:Practitioner/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Practitioner-organization"/>
    <resource>
      <SearchParameter>
        <id value="Practitioner-organization"/>
        <url value="http://hl7.org/fhir/SearchParameter/Practitioner-organization"/>
        <name value="organization"/>
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
        <code value="organization"/>
        <base value="Practitioner"/>
        <type value="reference"/>
        <description value="The identity of the organization the practitioner represents / acts on behalf of"/>
        <xpath value="f:Practitioner/f:practitionerRole/f:managingOrganization"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Practitioner-phone"/>
    <resource>
      <SearchParameter>
        <id value="Practitioner-phone"/>
        <url value="http://hl7.org/fhir/SearchParameter/Practitioner-phone"/>
        <name value="phone"/>
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
        <code value="phone"/>
        <base value="Practitioner"/>
        <type value="token"/>
        <description value="A value in a phone contact"/>
        <xpath value="f:Practitioner/f:telecom[system/@value=&apos;phone&apos;]"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Practitioner-role"/>
    <resource>
      <SearchParameter>
        <id value="Practitioner-role"/>
        <url value="http://hl7.org/fhir/SearchParameter/Practitioner-role"/>
        <name value="role"/>
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
        <code value="role"/>
        <base value="Practitioner"/>
        <type value="token"/>
        <description value="The practitioner can perform this role at for the organization"/>
        <xpath value="f:Practitioner/f:practitionerRole/f:role"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Practitioner-specialty"/>
    <resource>
      <SearchParameter>
        <id value="Practitioner-specialty"/>
        <url value="http://hl7.org/fhir/SearchParameter/Practitioner-specialty"/>
        <name value="specialty"/>
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
        <code value="specialty"/>
        <base value="Practitioner"/>
        <type value="token"/>
        <description value="The practitioner has this specialty at an organization"/>
        <xpath value="f:Practitioner/f:practitionerRole/f:specialty"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Practitioner-telecom"/>
    <resource>
      <SearchParameter>
        <id value="Practitioner-telecom"/>
        <url value="http://hl7.org/fhir/SearchParameter/Practitioner-telecom"/>
        <name value="telecom"/>
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
        <code value="telecom"/>
        <base value="Practitioner"/>
        <type value="token"/>
        <description value="The value in any kind of contact"/>
        <xpath value="f:Practitioner/f:telecom"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
