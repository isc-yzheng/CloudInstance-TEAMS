Class HS.FHIR.vSTU3.Repository.Resource.ValueSet Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-ValueSet"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ValueSet-date"/>
    <resource>
      <SearchParameter>
        <id value="ValueSet-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/ValueSet-date"/>
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
        <base value="ValueSet"/>
        <type value="date"/>
        <description value="The value set publication date"/>
        <expression value="ValueSet.date"/>
        <xpath value="f:ValueSet/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ValueSet-description"/>
    <resource>
      <SearchParameter>
        <id value="ValueSet-description"/>
        <url value="http://hl7.org/fhir/SearchParameter/ValueSet-description"/>
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
        <base value="ValueSet"/>
        <type value="string"/>
        <description value="The description of the value set"/>
        <expression value="ValueSet.description"/>
        <xpath value="f:ValueSet/f:description"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ValueSet-expansion"/>
    <resource>
      <SearchParameter>
        <id value="ValueSet-expansion"/>
        <url value="http://hl7.org/fhir/SearchParameter/ValueSet-expansion"/>
        <name value="expansion"/>
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
        <code value="expansion"/>
        <base value="ValueSet"/>
        <type value="uri"/>
        <description value="Uniquely identifies this expansion"/>
        <expression value="ValueSet.expansion.identifier"/>
        <xpath value="f:ValueSet/f:expansion/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ValueSet-identifier"/>
    <resource>
      <SearchParameter>
        <id value="ValueSet-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/ValueSet-identifier"/>
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
        <base value="ValueSet"/>
        <type value="token"/>
        <description value="External identifier for the value set"/>
        <expression value="ValueSet.identifier"/>
        <xpath value="f:ValueSet/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ValueSet-jurisdiction"/>
    <resource>
      <SearchParameter>
        <id value="ValueSet-jurisdiction"/>
        <url value="http://hl7.org/fhir/SearchParameter/ValueSet-jurisdiction"/>
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
        <base value="ValueSet"/>
        <type value="token"/>
        <description value="Intended jurisdiction for the value set"/>
        <expression value="ValueSet.jurisdiction"/>
        <xpath value="f:ValueSet/f:jurisdiction"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ValueSet-name"/>
    <resource>
      <SearchParameter>
        <id value="ValueSet-name"/>
        <url value="http://hl7.org/fhir/SearchParameter/ValueSet-name"/>
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
        <base value="ValueSet"/>
        <type value="string"/>
        <description value="Computationally friendly name of the value set"/>
        <expression value="ValueSet.name"/>
        <xpath value="f:ValueSet/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ValueSet-publisher"/>
    <resource>
      <SearchParameter>
        <id value="ValueSet-publisher"/>
        <url value="http://hl7.org/fhir/SearchParameter/ValueSet-publisher"/>
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
        <base value="ValueSet"/>
        <type value="string"/>
        <description value="Name of the publisher of the value set"/>
        <expression value="ValueSet.publisher"/>
        <xpath value="f:ValueSet/f:publisher"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ValueSet-reference"/>
    <resource>
      <SearchParameter>
        <id value="ValueSet-reference"/>
        <url value="http://hl7.org/fhir/SearchParameter/ValueSet-reference"/>
        <name value="reference"/>
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
        <code value="reference"/>
        <base value="ValueSet"/>
        <type value="uri"/>
        <description value="A code system included or excluded in the value set or an imported value set"/>
        <expression value="ValueSet.compose.include.system"/>
        <xpath value="f:ValueSet/f:compose/f:include/f:system"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ValueSet-status"/>
    <resource>
      <SearchParameter>
        <id value="ValueSet-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/ValueSet-status"/>
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
        <base value="ValueSet"/>
        <type value="token"/>
        <description value="The current status of the value set"/>
        <expression value="ValueSet.status"/>
        <xpath value="f:ValueSet/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ValueSet-title"/>
    <resource>
      <SearchParameter>
        <id value="ValueSet-title"/>
        <url value="http://hl7.org/fhir/SearchParameter/ValueSet-title"/>
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
        <base value="ValueSet"/>
        <type value="string"/>
        <description value="The human-friendly name of the value set"/>
        <expression value="ValueSet.title"/>
        <xpath value="f:ValueSet/f:title"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ValueSet-url"/>
    <resource>
      <SearchParameter>
        <id value="ValueSet-url"/>
        <url value="http://hl7.org/fhir/SearchParameter/ValueSet-url"/>
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
        <base value="ValueSet"/>
        <type value="uri"/>
        <description value="The uri that identifies the value set"/>
        <expression value="ValueSet.url"/>
        <xpath value="f:ValueSet/f:url"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ValueSet-version"/>
    <resource>
      <SearchParameter>
        <id value="ValueSet-version"/>
        <url value="http://hl7.org/fhir/SearchParameter/ValueSet-version"/>
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
        <base value="ValueSet"/>
        <type value="token"/>
        <description value="The business version of the value set"/>
        <expression value="ValueSet.version"/>
        <xpath value="f:ValueSet/f:version"/>
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
