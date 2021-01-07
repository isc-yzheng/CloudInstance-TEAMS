Class HS.FHIR.vDSTU2.Repository.Resource.TestScript Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-TestScript"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/TestScript-description"/>
    <resource>
      <SearchParameter>
        <id value="TestScript-description"/>
        <url value="http://hl7.org/fhir/SearchParameter/TestScript-description"/>
        <name value="description"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="description"/>
        <base value="TestScript"/>
        <type value="string"/>
        <description value="Natural language description of the TestScript"/>
        <xpath value="f:TestScript/f:description"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/TestScript-identifier"/>
    <resource>
      <SearchParameter>
        <id value="TestScript-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/TestScript-identifier"/>
        <name value="identifier"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="identifier"/>
        <base value="TestScript"/>
        <type value="token"/>
        <description value="External identifier"/>
        <xpath value="f:TestScript/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/TestScript-name"/>
    <resource>
      <SearchParameter>
        <id value="TestScript-name"/>
        <url value="http://hl7.org/fhir/SearchParameter/TestScript-name"/>
        <name value="name"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="name"/>
        <base value="TestScript"/>
        <type value="string"/>
        <description value="Informal name for this TestScript"/>
        <xpath value="f:TestScript/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/TestScript-testscript-capability"/>
    <resource>
      <SearchParameter>
        <id value="TestScript-testscript-capability"/>
        <url value="http://hl7.org/fhir/SearchParameter/TestScript-testscript-capability"/>
        <name value="testscript-capability"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="testscript-capability"/>
        <base value="TestScript"/>
        <type value="string"/>
        <description value="TestScript required and validated capability"/>
        <xpath value="f:TestScript/f:metadata/f:capability/f:description"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/TestScript-testscript-setup-capability"/>
    <resource>
      <SearchParameter>
        <id value="TestScript-testscript-setup-capability"/>
        <url value="http://hl7.org/fhir/SearchParameter/TestScript-testscript-setup-capability"/>
        <name value="testscript-setup-capability"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="testscript-setup-capability"/>
        <base value="TestScript"/>
        <type value="string"/>
        <description value="TestScript setup required and validated capability"/>
        <xpath value="f:TestScript/f:setup/f:metadata/f:capability/f:description"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/TestScript-testscript-test-capability"/>
    <resource>
      <SearchParameter>
        <id value="TestScript-testscript-test-capability"/>
        <url value="http://hl7.org/fhir/SearchParameter/TestScript-testscript-test-capability"/>
        <name value="testscript-test-capability"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="testscript-test-capability"/>
        <base value="TestScript"/>
        <type value="string"/>
        <description value="TestScript test required and validated capability"/>
        <xpath value="f:TestScript/f:test/f:metadata/f:capability/f:description"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/TestScript-url"/>
    <resource>
      <SearchParameter>
        <id value="TestScript-url"/>
        <url value="http://hl7.org/fhir/SearchParameter/TestScript-url"/>
        <name value="url"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="url"/>
        <base value="TestScript"/>
        <type value="uri"/>
        <description value="Absolute URL used to reference this TestScript"/>
        <xpath value="f:TestScript/f:url"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
