Class HS.FHIR.vSTU3.Repository.Resource.StructureMap Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-StructureMap"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureMap-date"/>
    <resource>
      <SearchParameter>
        <id value="StructureMap-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureMap-date"/>
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
        <base value="StructureMap"/>
        <type value="date"/>
        <description value="The structure map publication date"/>
        <expression value="StructureMap.date"/>
        <xpath value="f:StructureMap/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureMap-description"/>
    <resource>
      <SearchParameter>
        <id value="StructureMap-description"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureMap-description"/>
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
        <base value="StructureMap"/>
        <type value="string"/>
        <description value="The description of the structure map"/>
        <expression value="StructureMap.description"/>
        <xpath value="f:StructureMap/f:description"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureMap-identifier"/>
    <resource>
      <SearchParameter>
        <id value="StructureMap-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureMap-identifier"/>
        <name value="identifier"/>
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
        <code value="identifier"/>
        <base value="StructureMap"/>
        <type value="token"/>
        <description value="External identifier for the structure map"/>
        <expression value="StructureMap.identifier"/>
        <xpath value="f:StructureMap/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureMap-jurisdiction"/>
    <resource>
      <SearchParameter>
        <id value="StructureMap-jurisdiction"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureMap-jurisdiction"/>
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
        <base value="StructureMap"/>
        <type value="token"/>
        <description value="Intended jurisdiction for the structure map"/>
        <expression value="StructureMap.jurisdiction"/>
        <xpath value="f:StructureMap/f:jurisdiction"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureMap-name"/>
    <resource>
      <SearchParameter>
        <id value="StructureMap-name"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureMap-name"/>
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
        <base value="StructureMap"/>
        <type value="string"/>
        <description value="Computationally friendly name of the structure map"/>
        <expression value="StructureMap.name"/>
        <xpath value="f:StructureMap/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureMap-publisher"/>
    <resource>
      <SearchParameter>
        <id value="StructureMap-publisher"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureMap-publisher"/>
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
        <base value="StructureMap"/>
        <type value="string"/>
        <description value="Name of the publisher of the structure map"/>
        <expression value="StructureMap.publisher"/>
        <xpath value="f:StructureMap/f:publisher"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureMap-status"/>
    <resource>
      <SearchParameter>
        <id value="StructureMap-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureMap-status"/>
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
        <base value="StructureMap"/>
        <type value="token"/>
        <description value="The current status of the structure map"/>
        <expression value="StructureMap.status"/>
        <xpath value="f:StructureMap/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureMap-title"/>
    <resource>
      <SearchParameter>
        <id value="StructureMap-title"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureMap-title"/>
        <name value="title"/>
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
        <code value="title"/>
        <base value="StructureMap"/>
        <type value="string"/>
        <description value="The human-friendly name of the structure map"/>
        <expression value="StructureMap.title"/>
        <xpath value="f:StructureMap/f:title"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureMap-url"/>
    <resource>
      <SearchParameter>
        <id value="StructureMap-url"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureMap-url"/>
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
        <base value="StructureMap"/>
        <type value="uri"/>
        <description value="The uri that identifies the structure map"/>
        <expression value="StructureMap.url"/>
        <xpath value="f:StructureMap/f:url"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureMap-version"/>
    <resource>
      <SearchParameter>
        <id value="StructureMap-version"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureMap-version"/>
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
        <base value="StructureMap"/>
        <type value="token"/>
        <description value="The business version of the structure map"/>
        <expression value="StructureMap.version"/>
        <xpath value="f:StructureMap/f:version"/>
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
