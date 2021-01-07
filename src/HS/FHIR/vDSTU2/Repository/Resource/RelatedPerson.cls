Class HS.FHIR.vDSTU2.Repository.Resource.RelatedPerson Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-RelatedPerson"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/RelatedPerson-address"/>
    <resource>
      <SearchParameter>
        <id value="RelatedPerson-address"/>
        <url value="http://hl7.org/fhir/SearchParameter/RelatedPerson-address"/>
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
        <base value="RelatedPerson"/>
        <type value="string"/>
        <description value="An address in any kind of address/part"/>
        <xpath value="f:RelatedPerson/f:address"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/RelatedPerson-address-city"/>
    <resource>
      <SearchParameter>
        <id value="RelatedPerson-address-city"/>
        <url value="http://hl7.org/fhir/SearchParameter/RelatedPerson-address-city"/>
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
        <base value="RelatedPerson"/>
        <type value="string"/>
        <description value="A city specified in an address"/>
        <xpath value="f:RelatedPerson/f:address/f:city"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/RelatedPerson-address-country"/>
    <resource>
      <SearchParameter>
        <id value="RelatedPerson-address-country"/>
        <url value="http://hl7.org/fhir/SearchParameter/RelatedPerson-address-country"/>
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
        <base value="RelatedPerson"/>
        <type value="string"/>
        <description value="A country specified in an address"/>
        <xpath value="f:RelatedPerson/f:address/f:country"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/RelatedPerson-address-postalcode"/>
    <resource>
      <SearchParameter>
        <id value="RelatedPerson-address-postalcode"/>
        <url value="http://hl7.org/fhir/SearchParameter/RelatedPerson-address-postalcode"/>
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
        <base value="RelatedPerson"/>
        <type value="string"/>
        <description value="A postal code specified in an address"/>
        <xpath value="f:RelatedPerson/f:address/f:postalCode"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/RelatedPerson-address-state"/>
    <resource>
      <SearchParameter>
        <id value="RelatedPerson-address-state"/>
        <url value="http://hl7.org/fhir/SearchParameter/RelatedPerson-address-state"/>
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
        <base value="RelatedPerson"/>
        <type value="string"/>
        <description value="A state specified in an address"/>
        <xpath value="f:RelatedPerson/f:address/f:state"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/RelatedPerson-address-use"/>
    <resource>
      <SearchParameter>
        <id value="RelatedPerson-address-use"/>
        <url value="http://hl7.org/fhir/SearchParameter/RelatedPerson-address-use"/>
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
        <base value="RelatedPerson"/>
        <type value="token"/>
        <description value="A use code specified in an address"/>
        <xpath value="f:RelatedPerson/f:address/f:use"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/RelatedPerson-birthdate"/>
    <resource>
      <SearchParameter>
        <id value="RelatedPerson-birthdate"/>
        <url value="http://hl7.org/fhir/SearchParameter/RelatedPerson-birthdate"/>
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
        <base value="RelatedPerson"/>
        <type value="date"/>
        <description value="The Related Person&apos;s date of birth"/>
        <xpath value="f:RelatedPerson/f:birthDate"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/RelatedPerson-email"/>
    <resource>
      <SearchParameter>
        <id value="RelatedPerson-email"/>
        <url value="http://hl7.org/fhir/SearchParameter/RelatedPerson-email"/>
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
        <base value="RelatedPerson"/>
        <type value="token"/>
        <description value="A value in an email contact"/>
        <xpath value="f:RelatedPerson/f:telecom[system/@value=&apos;email&apos;]"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/RelatedPerson-gender"/>
    <resource>
      <SearchParameter>
        <id value="RelatedPerson-gender"/>
        <url value="http://hl7.org/fhir/SearchParameter/RelatedPerson-gender"/>
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
        <base value="RelatedPerson"/>
        <type value="token"/>
        <description value="Gender of the person"/>
        <xpath value="f:RelatedPerson/f:gender"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/RelatedPerson-identifier"/>
    <resource>
      <SearchParameter>
        <id value="RelatedPerson-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/RelatedPerson-identifier"/>
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
        <base value="RelatedPerson"/>
        <type value="token"/>
        <description value="A patient Identifier"/>
        <xpath value="f:RelatedPerson/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/RelatedPerson-name"/>
    <resource>
      <SearchParameter>
        <id value="RelatedPerson-name"/>
        <url value="http://hl7.org/fhir/SearchParameter/RelatedPerson-name"/>
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
        <base value="RelatedPerson"/>
        <type value="string"/>
        <description value="A portion of name in any name part"/>
        <xpath value="f:RelatedPerson/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/RelatedPerson-patient"/>
    <resource>
      <SearchParameter>
        <id value="RelatedPerson-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/RelatedPerson-patient"/>
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
        <base value="RelatedPerson"/>
        <type value="reference"/>
        <description value="The patient this person is related to"/>
        <xpath value="f:RelatedPerson/f:patient"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/RelatedPerson-phone"/>
    <resource>
      <SearchParameter>
        <id value="RelatedPerson-phone"/>
        <url value="http://hl7.org/fhir/SearchParameter/RelatedPerson-phone"/>
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
        <base value="RelatedPerson"/>
        <type value="token"/>
        <description value="A value in a phone contact"/>
        <xpath value="f:RelatedPerson/f:telecom[system/@value=&apos;phone&apos;]"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/RelatedPerson-telecom"/>
    <resource>
      <SearchParameter>
        <id value="RelatedPerson-telecom"/>
        <url value="http://hl7.org/fhir/SearchParameter/RelatedPerson-telecom"/>
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
        <base value="RelatedPerson"/>
        <type value="token"/>
        <description value="The value in any kind of contact"/>
        <xpath value="f:RelatedPerson/f:telecom"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
