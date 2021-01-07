Class HS.FHIR.vDSTU2.Repository.Resource.Person Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Person"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Person-address"/>
    <resource>
      <SearchParameter>
        <id value="Person-address"/>
        <url value="http://hl7.org/fhir/SearchParameter/Person-address"/>
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
        <base value="Person"/>
        <type value="string"/>
        <description value="An address in any kind of address/part"/>
        <xpath value="f:Person/f:address"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Person-address-city"/>
    <resource>
      <SearchParameter>
        <id value="Person-address-city"/>
        <url value="http://hl7.org/fhir/SearchParameter/Person-address-city"/>
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
        <base value="Person"/>
        <type value="string"/>
        <description value="A city specified in an address"/>
        <xpath value="f:Person/f:address/f:city"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Person-address-country"/>
    <resource>
      <SearchParameter>
        <id value="Person-address-country"/>
        <url value="http://hl7.org/fhir/SearchParameter/Person-address-country"/>
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
        <base value="Person"/>
        <type value="string"/>
        <description value="A country specified in an address"/>
        <xpath value="f:Person/f:address/f:country"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Person-address-postalcode"/>
    <resource>
      <SearchParameter>
        <id value="Person-address-postalcode"/>
        <url value="http://hl7.org/fhir/SearchParameter/Person-address-postalcode"/>
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
        <base value="Person"/>
        <type value="string"/>
        <description value="A postal code specified in an address"/>
        <xpath value="f:Person/f:address/f:postalCode"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Person-address-state"/>
    <resource>
      <SearchParameter>
        <id value="Person-address-state"/>
        <url value="http://hl7.org/fhir/SearchParameter/Person-address-state"/>
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
        <base value="Person"/>
        <type value="string"/>
        <description value="A state specified in an address"/>
        <xpath value="f:Person/f:address/f:state"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Person-address-use"/>
    <resource>
      <SearchParameter>
        <id value="Person-address-use"/>
        <url value="http://hl7.org/fhir/SearchParameter/Person-address-use"/>
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
        <base value="Person"/>
        <type value="token"/>
        <description value="A use code specified in an address"/>
        <xpath value="f:Person/f:address/f:use"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Person-birthdate"/>
    <resource>
      <SearchParameter>
        <id value="Person-birthdate"/>
        <url value="http://hl7.org/fhir/SearchParameter/Person-birthdate"/>
        <name value="birthdate"/>
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
        <code value="birthdate"/>
        <base value="Person"/>
        <type value="date"/>
        <description value="The person&apos;s date of birth"/>
        <xpath value="f:Person/f:birthDate"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Person-email"/>
    <resource>
      <SearchParameter>
        <id value="Person-email"/>
        <url value="http://hl7.org/fhir/SearchParameter/Person-email"/>
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
        <base value="Person"/>
        <type value="token"/>
        <description value="A value in an email contact"/>
        <xpath value="f:Person/f:telecom[system/@value=&apos;email&apos;]"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Person-gender"/>
    <resource>
      <SearchParameter>
        <id value="Person-gender"/>
        <url value="http://hl7.org/fhir/SearchParameter/Person-gender"/>
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
        <base value="Person"/>
        <type value="token"/>
        <description value="The gender of the person"/>
        <xpath value="f:Person/f:gender"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Person-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Person-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Person-identifier"/>
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
        <base value="Person"/>
        <type value="token"/>
        <description value="A person Identifier"/>
        <xpath value="f:Person/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Person-link"/>
    <resource>
      <SearchParameter>
        <id value="Person-link"/>
        <url value="http://hl7.org/fhir/SearchParameter/Person-link"/>
        <name value="link"/>
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
        <code value="link"/>
        <base value="Person"/>
        <type value="reference"/>
        <description value="Any link has this Patient, Person, RelatedPerson or Practitioner reference"/>
        <xpath value="f:Person/f:link/f:target"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
        <target value="Practitioner"/>
        <target value="Person"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Person-name"/>
    <resource>
      <SearchParameter>
        <id value="Person-name"/>
        <url value="http://hl7.org/fhir/SearchParameter/Person-name"/>
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
        <base value="Person"/>
        <type value="string"/>
        <description value="A portion of name in any name part"/>
        <xpath value="f:Person/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Person-organization"/>
    <resource>
      <SearchParameter>
        <id value="Person-organization"/>
        <url value="http://hl7.org/fhir/SearchParameter/Person-organization"/>
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
        <base value="Person"/>
        <type value="reference"/>
        <description value="The organization at which this person record is being managed"/>
        <xpath value="f:Person/f:managingOrganization"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Person-patient"/>
    <resource>
      <SearchParameter>
        <id value="Person-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/Person-patient"/>
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
        <base value="Person"/>
        <type value="reference"/>
        <description value="The Person links to this Patient"/>
        <xpath value="f:Person/f:link/f:target"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
        <target value="Practitioner"/>
        <target value="Person"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Person-phone"/>
    <resource>
      <SearchParameter>
        <id value="Person-phone"/>
        <url value="http://hl7.org/fhir/SearchParameter/Person-phone"/>
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
        <base value="Person"/>
        <type value="token"/>
        <description value="A value in a phone contact"/>
        <xpath value="f:Person/f:telecom[system/@value=&apos;phone&apos;]"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Person-practitioner"/>
    <resource>
      <SearchParameter>
        <id value="Person-practitioner"/>
        <url value="http://hl7.org/fhir/SearchParameter/Person-practitioner"/>
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
        <base value="Person"/>
        <type value="reference"/>
        <description value="The Person links to this Practitioner"/>
        <xpath value="f:Person/f:link/f:target"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
        <target value="Practitioner"/>
        <target value="Person"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Person-relatedperson"/>
    <resource>
      <SearchParameter>
        <id value="Person-relatedperson"/>
        <url value="http://hl7.org/fhir/SearchParameter/Person-relatedperson"/>
        <name value="relatedperson"/>
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
        <code value="relatedperson"/>
        <base value="Person"/>
        <type value="reference"/>
        <description value="The Person links to this RelatedPerson"/>
        <xpath value="f:Person/f:link/f:target"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
        <target value="Practitioner"/>
        <target value="Person"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Person-telecom"/>
    <resource>
      <SearchParameter>
        <id value="Person-telecom"/>
        <url value="http://hl7.org/fhir/SearchParameter/Person-telecom"/>
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
        <base value="Person"/>
        <type value="token"/>
        <description value="The value in any kind of contact"/>
        <xpath value="f:Person/f:telecom"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
