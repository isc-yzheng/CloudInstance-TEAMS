Class HS.FHIR.vDSTU2.Repository.Resource.DataElement Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-DataElement"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DataElement-code"/>
    <resource>
      <SearchParameter>
        <id value="DataElement-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/DataElement-code"/>
        <name value="code"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="code"/>
        <base value="DataElement"/>
        <type value="token"/>
        <description value="A code for the data element (server may choose to do subsumption)"/>
        <xpath value="f:DataElement/f:element/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DataElement-context"/>
    <resource>
      <SearchParameter>
        <id value="DataElement-context"/>
        <url value="http://hl7.org/fhir/SearchParameter/DataElement-context"/>
        <name value="context"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="context"/>
        <base value="DataElement"/>
        <type value="token"/>
        <description value="A use context assigned to the data element"/>
        <xpath value="f:DataElement/f:useContext"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DataElement-date"/>
    <resource>
      <SearchParameter>
        <id value="DataElement-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/DataElement-date"/>
        <name value="date"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="date"/>
        <base value="DataElement"/>
        <type value="date"/>
        <description value="The data element publication date"/>
        <xpath value="f:DataElement/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DataElement-description"/>
    <resource>
      <SearchParameter>
        <id value="DataElement-description"/>
        <url value="http://hl7.org/fhir/SearchParameter/DataElement-description"/>
        <name value="description"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="description"/>
        <base value="DataElement"/>
        <type value="string"/>
        <description value="Text search in the description of the data element.  This corresponds to the definition of the first DataElement.element."/>
        <xpath value="f:DataElement/f:element/f:definition"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DataElement-identifier"/>
    <resource>
      <SearchParameter>
        <id value="DataElement-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/DataElement-identifier"/>
        <name value="identifier"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="identifier"/>
        <base value="DataElement"/>
        <type value="token"/>
        <description value="The identifier of the data element"/>
        <xpath value="f:DataElement/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DataElement-name"/>
    <resource>
      <SearchParameter>
        <id value="DataElement-name"/>
        <url value="http://hl7.org/fhir/SearchParameter/DataElement-name"/>
        <name value="name"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="name"/>
        <base value="DataElement"/>
        <type value="string"/>
        <description value="Name of the data element"/>
        <xpath value="f:DataElement/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/elementdefinition-11179-DataElement-objectClass"/>
    <resource>
      <SearchParameter>
        <id value="elementdefinition-11179-DataElement-objectClass"/>
        <url value="http://hl7.org/fhir/SearchParameter/elementdefinition-11179-DataElement-objectClass"/>
        <name value="objectClass"/>
        <code value="objectClass"/>
        <base value="DataElement"/>
        <type value="token"/>
        <description value="Matches on the 11179-objectClass extension value"/>
        <xpath value="f:DataElement/f:element/f:mapping/f:extension[@url=&apos;http://hl7.org/fhir/StructureDefinition/11179-objectClass&apos;]"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/elementdefinition-11179-DataElement-objectClassProperty"/>
    <resource>
      <SearchParameter>
        <id value="elementdefinition-11179-DataElement-objectClassProperty"/>
        <url value="http://hl7.org/fhir/SearchParameter/elementdefinition-11179-DataElement-objectClassProperty"/>
        <name value="objectClassProperty"/>
        <code value="objectClassProperty"/>
        <base value="DataElement"/>
        <type value="token"/>
        <description value="Matches on the 11179-objectClassProperty extension value"/>
        <xpath value="f:DataElement/f:element/f:mapping/f:extension[@url=&apos;http://hl7.org/fhir/StructureDefinition/11179-objectClassProperty&apos;]"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DataElement-publisher"/>
    <resource>
      <SearchParameter>
        <id value="DataElement-publisher"/>
        <url value="http://hl7.org/fhir/SearchParameter/DataElement-publisher"/>
        <name value="publisher"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="publisher"/>
        <base value="DataElement"/>
        <type value="string"/>
        <description value="Name of the publisher of the data element"/>
        <xpath value="f:DataElement/f:publisher"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DataElement-status"/>
    <resource>
      <SearchParameter>
        <id value="DataElement-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/DataElement-status"/>
        <name value="status"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="status"/>
        <base value="DataElement"/>
        <type value="token"/>
        <description value="The current status of the data element"/>
        <xpath value="f:DataElement/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DataElement-stringency"/>
    <resource>
      <SearchParameter>
        <id value="DataElement-stringency"/>
        <url value="http://hl7.org/fhir/SearchParameter/DataElement-stringency"/>
        <name value="stringency"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="stringency"/>
        <base value="DataElement"/>
        <type value="token"/>
        <description value="The stringency of the data element definition"/>
        <xpath value="f:DataElement/f:stringency"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DataElement-url"/>
    <resource>
      <SearchParameter>
        <id value="DataElement-url"/>
        <url value="http://hl7.org/fhir/SearchParameter/DataElement-url"/>
        <name value="url"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="url"/>
        <base value="DataElement"/>
        <type value="uri"/>
        <description value="The official URL for the data element"/>
        <xpath value="f:DataElement/f:url"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DataElement-version"/>
    <resource>
      <SearchParameter>
        <id value="DataElement-version"/>
        <url value="http://hl7.org/fhir/SearchParameter/DataElement-version"/>
        <name value="version"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="version"/>
        <base value="DataElement"/>
        <type value="string"/>
        <description value="The version identifier of the data element"/>
        <xpath value="f:DataElement/f:version"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
