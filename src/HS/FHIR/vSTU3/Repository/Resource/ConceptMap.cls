Class HS.FHIR.vSTU3.Repository.Resource.ConceptMap Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

/// TO DO: Attempting to create indices for the source-uri and target-uri parameters is always
///  going to log errors in the Event Log because the xpaths point to URI properties,
///  but the params are of type "reference". This may be a problem with the STU3 standard.
XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-ConceptMap"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ConceptMap-date"/>
    <resource>
      <SearchParameter>
        <id value="ConceptMap-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/ConceptMap-date"/>
        <name value="date"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <code value="date"/>
        <base value="ConceptMap"/>
        <type value="date"/>
        <description value="The concept map publication date"/>
        <expression value="ConceptMap.date"/>
        <xpath value="f:ConceptMap/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ConceptMap-dependson"/>
    <resource>
      <SearchParameter>
        <id value="ConceptMap-dependson"/>
        <url value="http://hl7.org/fhir/SearchParameter/ConceptMap-dependson"/>
        <name value="dependson"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <code value="dependson"/>
        <base value="ConceptMap"/>
        <type value="uri"/>
        <description value="Reference to property mapping depends on"/>
        <expression value="ConceptMap.group.element.target.dependsOn.property"/>
        <xpath value="f:ConceptMap/f:group/f:element/f:target/f:dependsOn/f:property"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ConceptMap-description"/>
    <resource>
      <SearchParameter>
        <id value="ConceptMap-description"/>
        <url value="http://hl7.org/fhir/SearchParameter/ConceptMap-description"/>
        <name value="description"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <code value="description"/>
        <base value="ConceptMap"/>
        <type value="string"/>
        <description value="The description of the concept map"/>
        <expression value="ConceptMap.description"/>
        <xpath value="f:ConceptMap/f:description"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ConceptMap-identifier"/>
    <resource>
      <SearchParameter>
        <id value="ConceptMap-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/ConceptMap-identifier"/>
        <name value="identifier"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <code value="identifier"/>
        <base value="ConceptMap"/>
        <type value="token"/>
        <description value="External identifier for the concept map"/>
        <expression value="ConceptMap.identifier"/>
        <xpath value="f:ConceptMap/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ConceptMap-jurisdiction"/>
    <resource>
      <SearchParameter>
        <id value="ConceptMap-jurisdiction"/>
        <url value="http://hl7.org/fhir/SearchParameter/ConceptMap-jurisdiction"/>
        <name value="jurisdiction"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <code value="jurisdiction"/>
        <base value="ConceptMap"/>
        <type value="token"/>
        <description value="Intended jurisdiction for the concept map"/>
        <expression value="ConceptMap.jurisdiction"/>
        <xpath value="f:ConceptMap/f:jurisdiction"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ConceptMap-name"/>
    <resource>
      <SearchParameter>
        <id value="ConceptMap-name"/>
        <url value="http://hl7.org/fhir/SearchParameter/ConceptMap-name"/>
        <name value="name"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <code value="name"/>
        <base value="ConceptMap"/>
        <type value="string"/>
        <description value="Computationally friendly name of the concept map"/>
        <expression value="ConceptMap.name"/>
        <xpath value="f:ConceptMap/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ConceptMap-other"/>
    <resource>
      <SearchParameter>
        <id value="ConceptMap-other"/>
        <url value="http://hl7.org/fhir/SearchParameter/ConceptMap-other"/>
        <name value="other"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <code value="other"/>
        <base value="ConceptMap"/>
        <type value="uri"/>
        <description value="Canonical URL for other concept map"/>
        <expression value="ConceptMap.group.unmapped.url"/>
        <xpath value="f:ConceptMap/f:group/f:unmapped/f:url"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ConceptMap-product"/>
    <resource>
      <SearchParameter>
        <id value="ConceptMap-product"/>
        <url value="http://hl7.org/fhir/SearchParameter/ConceptMap-product"/>
        <name value="product"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <code value="product"/>
        <base value="ConceptMap"/>
        <type value="uri"/>
        <description value="Reference to property mapping depends on"/>
        <expression value="ConceptMap.group.element.target.product.property"/>
        <xpath value="f:ConceptMap/f:group/f:element/f:target/f:product/f:property"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ConceptMap-publisher"/>
    <resource>
      <SearchParameter>
        <id value="ConceptMap-publisher"/>
        <url value="http://hl7.org/fhir/SearchParameter/ConceptMap-publisher"/>
        <name value="publisher"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <code value="publisher"/>
        <base value="ConceptMap"/>
        <type value="string"/>
        <description value="Name of the publisher of the concept map"/>
        <expression value="ConceptMap.publisher"/>
        <xpath value="f:ConceptMap/f:publisher"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ConceptMap-source"/>
    <resource>
      <SearchParameter>
        <id value="ConceptMap-source"/>
        <url value="http://hl7.org/fhir/SearchParameter/ConceptMap-source"/>
        <name value="source"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <code value="source"/>
        <base value="ConceptMap"/>
        <type value="reference"/>
        <description value="Identifies the source of the concepts which are being mapped"/>
        <expression value="ConceptMap.source.as(Reference)"/>
        <xpath value="f:ConceptMap/f:sourceReference"/>
        <xpathUsage value="normal"/>
        <target value="ValueSet"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ConceptMap-source-code"/>
    <resource>
      <SearchParameter>
        <id value="ConceptMap-source-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/ConceptMap-source-code"/>
        <name value="source-code"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <code value="source-code"/>
        <base value="ConceptMap"/>
        <type value="token"/>
        <description value="Identifies element being mapped"/>
        <expression value="ConceptMap.group.element.code"/>
        <xpath value="f:ConceptMap/f:group/f:element/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ConceptMap-source-system"/>
    <resource>
      <SearchParameter>
        <id value="ConceptMap-source-system"/>
        <url value="http://hl7.org/fhir/SearchParameter/ConceptMap-source-system"/>
        <name value="source-system"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <code value="source-system"/>
        <base value="ConceptMap"/>
        <type value="uri"/>
        <description value="Code System (if value set crosses code systems)"/>
        <expression value="ConceptMap.group.source"/>
        <xpath value="f:ConceptMap/f:group/f:source"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ConceptMap-source-uri"/>
    <resource>
      <SearchParameter>
        <id value="ConceptMap-source-uri"/>
        <url value="http://hl7.org/fhir/SearchParameter/ConceptMap-source-uri"/>
        <name value="source-uri"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <code value="source-uri"/>
        <base value="ConceptMap"/>
        <type value="reference"/>
        <description value="Identifies the source of the concepts which are being mapped"/>
        <expression value="ConceptMap.source.as(Uri)"/>
        <xpath value="f:ConceptMap/f:sourceUri"/>
        <xpathUsage value="normal"/>
        <target value="ValueSet"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ConceptMap-status"/>
    <resource>
      <SearchParameter>
        <id value="ConceptMap-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/ConceptMap-status"/>
        <name value="status"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <code value="status"/>
        <base value="ConceptMap"/>
        <type value="token"/>
        <description value="The current status of the concept map"/>
        <expression value="ConceptMap.status"/>
        <xpath value="f:ConceptMap/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ConceptMap-target"/>
    <resource>
      <SearchParameter>
        <id value="ConceptMap-target"/>
        <url value="http://hl7.org/fhir/SearchParameter/ConceptMap-target"/>
        <name value="target"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <code value="target"/>
        <base value="ConceptMap"/>
        <type value="reference"/>
        <description value="Provides context to the mappings"/>
        <expression value="ConceptMap.target.as(Reference)"/>
        <xpath value="f:ConceptMap/f:targetReference"/>
        <xpathUsage value="normal"/>
        <target value="ValueSet"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ConceptMap-target-code"/>
    <resource>
      <SearchParameter>
        <id value="ConceptMap-target-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/ConceptMap-target-code"/>
        <name value="target-code"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <code value="target-code"/>
        <base value="ConceptMap"/>
        <type value="token"/>
        <description value="Code that identifies the target element"/>
        <expression value="ConceptMap.group.element.target.code"/>
        <xpath value="f:ConceptMap/f:group/f:element/f:target/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ConceptMap-target-system"/>
    <resource>
      <SearchParameter>
        <id value="ConceptMap-target-system"/>
        <url value="http://hl7.org/fhir/SearchParameter/ConceptMap-target-system"/>
        <name value="target-system"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <code value="target-system"/>
        <base value="ConceptMap"/>
        <type value="uri"/>
        <description value="System of the target (if necessary)"/>
        <expression value="ConceptMap.group.target"/>
        <xpath value="f:ConceptMap/f:group/f:target"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ConceptMap-target-uri"/>
    <resource>
      <SearchParameter>
        <id value="ConceptMap-target-uri"/>
        <url value="http://hl7.org/fhir/SearchParameter/ConceptMap-target-uri"/>
        <name value="target-uri"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <code value="target-uri"/>
        <base value="ConceptMap"/>
        <type value="reference"/>
        <description value="Provides context to the mappings"/>
        <expression value="ConceptMap.target.as(Uri)"/>
        <xpath value="f:ConceptMap/f:targetUri"/>
        <xpathUsage value="normal"/>
        <target value="ValueSet"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ConceptMap-title"/>
    <resource>
      <SearchParameter>
        <id value="ConceptMap-title"/>
        <url value="http://hl7.org/fhir/SearchParameter/ConceptMap-title"/>
        <name value="title"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <code value="title"/>
        <base value="ConceptMap"/>
        <type value="string"/>
        <description value="The human-friendly name of the concept map"/>
        <expression value="ConceptMap.title"/>
        <xpath value="f:ConceptMap/f:title"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ConceptMap-url"/>
    <resource>
      <SearchParameter>
        <id value="ConceptMap-url"/>
        <url value="http://hl7.org/fhir/SearchParameter/ConceptMap-url"/>
        <name value="url"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <code value="url"/>
        <base value="ConceptMap"/>
        <type value="uri"/>
        <description value="The uri that identifies the concept map"/>
        <expression value="ConceptMap.url"/>
        <xpath value="f:ConceptMap/f:url"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ConceptMap-version"/>
    <resource>
      <SearchParameter>
        <id value="ConceptMap-version"/>
        <url value="http://hl7.org/fhir/SearchParameter/ConceptMap-version"/>
        <name value="version"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <code value="version"/>
        <base value="ConceptMap"/>
        <type value="token"/>
        <description value="The business version of the concept map"/>
        <expression value="ConceptMap.version"/>
        <xpath value="f:ConceptMap/f:version"/>
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
