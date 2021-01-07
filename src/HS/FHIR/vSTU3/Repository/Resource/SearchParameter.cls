Class HS.FHIR.vSTU3.Repository.Resource.SearchParameter Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-SearchParameter"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/SearchParameter-base"/>
    <resource>
      <SearchParameter>
        <id value="SearchParameter-base"/>
        <url value="http://hl7.org/fhir/SearchParameter/SearchParameter-base"/>
        <name value="base"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="base"/>
        <base value="SearchParameter"/>
        <type value="token"/>
        <description value="The resource type(s) this search parameter applies to"/>
        <expression value="SearchParameter.base"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="code"/>
        <base value="SearchParameter"/>
        <type value="token"/>
        <description value="Code used in URL"/>
        <expression value="SearchParameter.code"/>
        <xpath value="f:SearchParameter/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/SearchParameter-component"/>
    <resource>
      <SearchParameter>
        <id value="SearchParameter-component"/>
        <url value="http://hl7.org/fhir/SearchParameter/SearchParameter-component"/>
        <name value="component"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="component"/>
        <base value="SearchParameter"/>
        <type value="reference"/>
        <description value="Defines how the part works"/>
        <expression value="SearchParameter.component.definition"/>
        <xpath value="f:SearchParameter/f:component/f:definition"/>
        <xpathUsage value="normal"/>
        <target value="SearchParameter"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/SearchParameter-date"/>
    <resource>
      <SearchParameter>
        <id value="SearchParameter-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/SearchParameter-date"/>
        <name value="date"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="date"/>
        <base value="SearchParameter"/>
        <type value="date"/>
        <description value="The search parameter publication date"/>
        <expression value="SearchParameter.date"/>
        <xpath value="f:SearchParameter/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/SearchParameter-derived-from"/>
    <resource>
      <SearchParameter>
        <id value="SearchParameter-derived-from"/>
        <url value="http://hl7.org/fhir/SearchParameter/SearchParameter-derived-from"/>
        <name value="derived-from"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="derived-from"/>
        <base value="SearchParameter"/>
        <type value="uri"/>
        <description value="Original Definition for the search parameter"/>
        <expression value="SearchParameter.derivedFrom"/>
        <xpath value="f:SearchParameter/f:derivedFrom"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="description"/>
        <base value="SearchParameter"/>
        <type value="string"/>
        <description value="The description of the search parameter"/>
        <expression value="SearchParameter.description"/>
        <xpath value="f:SearchParameter/f:description"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/SearchParameter-jurisdiction"/>
    <resource>
      <SearchParameter>
        <id value="SearchParameter-jurisdiction"/>
        <url value="http://hl7.org/fhir/SearchParameter/SearchParameter-jurisdiction"/>
        <name value="jurisdiction"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="jurisdiction"/>
        <base value="SearchParameter"/>
        <type value="token"/>
        <description value="Intended jurisdiction for the search parameter"/>
        <expression value="SearchParameter.jurisdiction"/>
        <xpath value="f:SearchParameter/f:jurisdiction"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="name"/>
        <base value="SearchParameter"/>
        <type value="string"/>
        <description value="Computationally friendly name of the search parameter"/>
        <expression value="SearchParameter.name"/>
        <xpath value="f:SearchParameter/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/SearchParameter-publisher"/>
    <resource>
      <SearchParameter>
        <id value="SearchParameter-publisher"/>
        <url value="http://hl7.org/fhir/SearchParameter/SearchParameter-publisher"/>
        <name value="publisher"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="publisher"/>
        <base value="SearchParameter"/>
        <type value="string"/>
        <description value="Name of the publisher of the search parameter"/>
        <expression value="SearchParameter.publisher"/>
        <xpath value="f:SearchParameter/f:publisher"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/SearchParameter-status"/>
    <resource>
      <SearchParameter>
        <id value="SearchParameter-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/SearchParameter-status"/>
        <name value="status"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="status"/>
        <base value="SearchParameter"/>
        <type value="token"/>
        <description value="The current status of the search parameter"/>
        <expression value="SearchParameter.status"/>
        <xpath value="f:SearchParameter/f:status"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="target"/>
        <base value="SearchParameter"/>
        <type value="token"/>
        <description value="Types of resource (if a resource reference)"/>
        <expression value="SearchParameter.target"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="type"/>
        <base value="SearchParameter"/>
        <type value="token"/>
        <description value="number | date | string | token | reference | composite | quantity | uri"/>
        <expression value="SearchParameter.type"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="url"/>
        <base value="SearchParameter"/>
        <type value="uri"/>
        <description value="The uri that identifies the search parameter"/>
        <expression value="SearchParameter.url"/>
        <xpath value="f:SearchParameter/f:url"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/SearchParameter-version"/>
    <resource>
      <SearchParameter>
        <id value="SearchParameter-version"/>
        <url value="http://hl7.org/fhir/SearchParameter/SearchParameter-version"/>
        <name value="version"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="version"/>
        <base value="SearchParameter"/>
        <type value="token"/>
        <description value="The business version of the search parameter"/>
        <expression value="SearchParameter.version"/>
        <xpath value="f:SearchParameter/f:version"/>
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
