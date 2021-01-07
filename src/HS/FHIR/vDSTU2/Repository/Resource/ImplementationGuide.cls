Class HS.FHIR.vDSTU2.Repository.Resource.ImplementationGuide Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-ImplementationGuide"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImplementationGuide-context"/>
    <resource>
      <SearchParameter>
        <id value="ImplementationGuide-context"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImplementationGuide-context"/>
        <name value="context"/>
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
        <code value="context"/>
        <base value="ImplementationGuide"/>
        <type value="token"/>
        <description value="A use context assigned to the structure"/>
        <xpath value="f:ImplementationGuide/f:useContext"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImplementationGuide-date"/>
    <resource>
      <SearchParameter>
        <id value="ImplementationGuide-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImplementationGuide-date"/>
        <name value="date"/>
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
        <code value="date"/>
        <base value="ImplementationGuide"/>
        <type value="date"/>
        <description value="The implementation guide publication date"/>
        <xpath value="f:ImplementationGuide/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImplementationGuide-dependency"/>
    <resource>
      <SearchParameter>
        <id value="ImplementationGuide-dependency"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImplementationGuide-dependency"/>
        <name value="dependency"/>
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
        <code value="dependency"/>
        <base value="ImplementationGuide"/>
        <type value="uri"/>
        <description value="Where to find dependency"/>
        <xpath value="f:ImplementationGuide/f:dependency/f:uri"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImplementationGuide-description"/>
    <resource>
      <SearchParameter>
        <id value="ImplementationGuide-description"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImplementationGuide-description"/>
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
        <base value="ImplementationGuide"/>
        <type value="string"/>
        <description value="Text search in the description of the implementation guide"/>
        <xpath value="f:ImplementationGuide/f:description"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImplementationGuide-experimental"/>
    <resource>
      <SearchParameter>
        <id value="ImplementationGuide-experimental"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImplementationGuide-experimental"/>
        <name value="experimental"/>
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
        <code value="experimental"/>
        <base value="ImplementationGuide"/>
        <type value="token"/>
        <description value="If for testing purposes, not real usage"/>
        <xpath value="f:ImplementationGuide/f:experimental"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImplementationGuide-name"/>
    <resource>
      <SearchParameter>
        <id value="ImplementationGuide-name"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImplementationGuide-name"/>
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
        <base value="ImplementationGuide"/>
        <type value="string"/>
        <description value="Name of the implementation guide"/>
        <xpath value="f:ImplementationGuide/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImplementationGuide-publisher"/>
    <resource>
      <SearchParameter>
        <id value="ImplementationGuide-publisher"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImplementationGuide-publisher"/>
        <name value="publisher"/>
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
        <code value="publisher"/>
        <base value="ImplementationGuide"/>
        <type value="string"/>
        <description value="Name of the publisher of the implementation guide"/>
        <xpath value="f:ImplementationGuide/f:publisher"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImplementationGuide-status"/>
    <resource>
      <SearchParameter>
        <id value="ImplementationGuide-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImplementationGuide-status"/>
        <name value="status"/>
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
        <code value="status"/>
        <base value="ImplementationGuide"/>
        <type value="token"/>
        <description value="The current status of the implementation guide"/>
        <xpath value="f:ImplementationGuide/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImplementationGuide-url"/>
    <resource>
      <SearchParameter>
        <id value="ImplementationGuide-url"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImplementationGuide-url"/>
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
        <base value="ImplementationGuide"/>
        <type value="uri"/>
        <description value="Absolute URL used to reference this Implementation Guide"/>
        <xpath value="f:ImplementationGuide/f:url"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImplementationGuide-version"/>
    <resource>
      <SearchParameter>
        <id value="ImplementationGuide-version"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImplementationGuide-version"/>
        <name value="version"/>
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
        <code value="version"/>
        <base value="ImplementationGuide"/>
        <type value="token"/>
        <description value="The version identifier of the implementation guide"/>
        <xpath value="f:ImplementationGuide/f:version"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
