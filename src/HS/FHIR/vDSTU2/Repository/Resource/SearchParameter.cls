Class HS.FHIR.vDSTU2.Repository.Resource.SearchParameter Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-SearchParameter"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/SearchParameter-base"/>
    <resource>
      <SearchParameter>
        <id value="SearchParameter-base"/>
        <url value="http://hl7.org/fhir/SearchParameter/SearchParameter-base"/>
        <name value="base"/>
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
        <code value="base"/>
        <base value="SearchParameter"/>
        <type value="token"/>
        <description value="The resource type this search parameter applies to"/>
        <xpath value="f:SearchParameter/f:base"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/SearchParameter-code"/>
    <resource>
      <SearchParameter>
        <id value="SearchParameter-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/SearchParameter-code"/>
        <name value="code"/>
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
        <code value="code"/>
        <base value="SearchParameter"/>
        <type value="token"/>
        <description value="Code used in URL"/>
        <xpath value="f:SearchParameter/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/SearchParameter-description"/>
    <resource>
      <SearchParameter>
        <id value="SearchParameter-description"/>
        <url value="http://hl7.org/fhir/SearchParameter/SearchParameter-description"/>
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
        <base value="SearchParameter"/>
        <type value="string"/>
        <description value="Documentation for  search parameter"/>
        <xpath value="f:SearchParameter/f:description"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/SearchParameter-name"/>
    <resource>
      <SearchParameter>
        <id value="SearchParameter-name"/>
        <url value="http://hl7.org/fhir/SearchParameter/SearchParameter-name"/>
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
        <base value="SearchParameter"/>
        <type value="string"/>
        <description value="Informal name for this search parameter"/>
        <xpath value="f:SearchParameter/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/SearchParameter-target"/>
    <resource>
      <SearchParameter>
        <id value="SearchParameter-target"/>
        <url value="http://hl7.org/fhir/SearchParameter/SearchParameter-target"/>
        <name value="target"/>
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
        <code value="target"/>
        <base value="SearchParameter"/>
        <type value="token"/>
        <description value="Types of resource (if a resource reference)"/>
        <xpath value="f:SearchParameter/f:target"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/SearchParameter-type"/>
    <resource>
      <SearchParameter>
        <id value="SearchParameter-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/SearchParameter-type"/>
        <name value="type"/>
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
        <code value="type"/>
        <base value="SearchParameter"/>
        <type value="token"/>
        <description value="number | date | string | token | reference | composite | quantity | uri"/>
        <xpath value="f:SearchParameter/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/SearchParameter-url"/>
    <resource>
      <SearchParameter>
        <id value="SearchParameter-url"/>
        <url value="http://hl7.org/fhir/SearchParameter/SearchParameter-url"/>
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
        <base value="SearchParameter"/>
        <type value="uri"/>
        <description value="Absolute URL used to reference this search parameter"/>
        <xpath value="f:SearchParameter/f:url"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
