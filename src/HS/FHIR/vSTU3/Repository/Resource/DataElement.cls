Class HS.FHIR.vSTU3.Repository.Resource.DataElement Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-DataElement"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DataElement-code"/>
    <resource>
      <SearchParameter>
        <id value="DataElement-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/DataElement-code"/>
        <name value="code"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="code"/>
        <base value="DataElement"/>
        <type value="token"/>
        <description value="A code for the data element (server may choose to do subsumption)"/>
        <expression value="DataElement.element.code"/>
        <xpath value="f:DataElement/f:element/f:code"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="date"/>
        <base value="DataElement"/>
        <type value="date"/>
        <description value="The data element publication date"/>
        <expression value="DataElement.date"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="description"/>
        <base value="DataElement"/>
        <type value="string"/>
        <description value="Text search in the description of the data element.  This corresponds to the definition of the first DataElement.element."/>
        <expression value="DataElement.element.definition"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="identifier"/>
        <base value="DataElement"/>
        <type value="token"/>
        <description value="External identifier for the data element"/>
        <expression value="DataElement.identifier"/>
        <xpath value="f:DataElement/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DataElement-jurisdiction"/>
    <resource>
      <SearchParameter>
        <id value="DataElement-jurisdiction"/>
        <url value="http://hl7.org/fhir/SearchParameter/DataElement-jurisdiction"/>
        <name value="jurisdiction"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="jurisdiction"/>
        <base value="DataElement"/>
        <type value="token"/>
        <description value="Intended jurisdiction for the data element"/>
        <expression value="DataElement.jurisdiction"/>
        <xpath value="f:DataElement/f:jurisdiction"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="name"/>
        <base value="DataElement"/>
        <type value="string"/>
        <description value="Computationally friendly name of the data element"/>
        <expression value="DataElement.name"/>
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
        <status value="draft"/>
        <experimental value="true"/>
        <code value="objectClass"/>
        <base value="DataElement"/>
        <type value="token"/>
        <description value="Matches on the 11179-objectClass extension value"/>
        <xpath value="f:DataElement/f:element/f:mapping/f:extension[@url=&apos;http://hl7.org/fhir/StructureDefinition/11179-objectClass&apos;] | f:DataElement/f:element/f:mapping/f:extension[@url=&apos;http://hl7.org/fhir/StructureDefinition/11179-objectClass&apos;]"/>
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
        <status value="draft"/>
        <experimental value="true"/>
        <code value="objectClassProperty"/>
        <base value="DataElement"/>
        <type value="token"/>
        <description value="Matches on the 11179-objectClassProperty extension value"/>
        <xpath value="f:DataElement/f:element/f:mapping/f:extension[@url=&apos;http://hl7.org/fhir/StructureDefinition/11179-objectClassProperty&apos;] | f:DataElement/f:element/f:mapping/f:extension[@url=&apos;http://hl7.org/fhir/StructureDefinition/11179-objectClassProperty&apos;]"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="publisher"/>
        <base value="DataElement"/>
        <type value="string"/>
        <description value="Name of the publisher of the data element"/>
        <expression value="DataElement.publisher"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="status"/>
        <base value="DataElement"/>
        <type value="token"/>
        <description value="The current status of the data element"/>
        <expression value="DataElement.status"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="stringency"/>
        <base value="DataElement"/>
        <type value="token"/>
        <description value="The stringency of the data element definition"/>
        <expression value="DataElement.stringency"/>
        <xpath value="f:DataElement/f:stringency"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DataElement-title"/>
    <resource>
      <SearchParameter>
        <id value="DataElement-title"/>
        <url value="http://hl7.org/fhir/SearchParameter/DataElement-title"/>
        <name value="title"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="title"/>
        <base value="DataElement"/>
        <type value="string"/>
        <description value="The human-friendly name of the data element"/>
        <expression value="DataElement.title"/>
        <xpath value="f:DataElement/f:title"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="url"/>
        <base value="DataElement"/>
        <type value="uri"/>
        <description value="The uri that identifies the data element"/>
        <expression value="DataElement.url"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="version"/>
        <base value="DataElement"/>
        <type value="token"/>
        <description value="The business version of the data element"/>
        <expression value="DataElement.version"/>
        <xpath value="f:DataElement/f:version"/>
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
