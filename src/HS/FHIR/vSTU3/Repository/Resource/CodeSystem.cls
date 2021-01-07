Class HS.FHIR.vSTU3.Repository.Resource.CodeSystem Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-CodeSystem"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CodeSystem-code"/>
    <resource>
      <SearchParameter>
        <id value="CodeSystem-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/CodeSystem-code"/>
        <name value="code"/>
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
        <code value="code"/>
        <base value="CodeSystem"/>
        <type value="token"/>
        <description value="A code defined in the code system"/>
        <expression value="CodeSystem.concept.code"/>
        <xpath value="f:CodeSystem/f:concept/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CodeSystem-content-mode"/>
    <resource>
      <SearchParameter>
        <id value="CodeSystem-content-mode"/>
        <url value="http://hl7.org/fhir/SearchParameter/CodeSystem-content-mode"/>
        <name value="content-mode"/>
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
        <code value="content-mode"/>
        <base value="CodeSystem"/>
        <type value="token"/>
        <description value="not-present | example | fragment | complete"/>
        <expression value="CodeSystem.content"/>
        <xpath value="f:CodeSystem/f:content"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CodeSystem-date"/>
    <resource>
      <SearchParameter>
        <id value="CodeSystem-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/CodeSystem-date"/>
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
        <base value="CodeSystem"/>
        <type value="date"/>
        <description value="The code system publication date"/>
        <expression value="CodeSystem.date"/>
        <xpath value="f:CodeSystem/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CodeSystem-description"/>
    <resource>
      <SearchParameter>
        <id value="CodeSystem-description"/>
        <url value="http://hl7.org/fhir/SearchParameter/CodeSystem-description"/>
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
        <base value="CodeSystem"/>
        <type value="string"/>
        <description value="The description of the code system"/>
        <expression value="CodeSystem.description"/>
        <xpath value="f:CodeSystem/f:description"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CodeSystem-identifier"/>
    <resource>
      <SearchParameter>
        <id value="CodeSystem-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/CodeSystem-identifier"/>
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
        <base value="CodeSystem"/>
        <type value="token"/>
        <description value="External identifier for the code system"/>
        <expression value="CodeSystem.identifier"/>
        <xpath value="f:CodeSystem/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CodeSystem-jurisdiction"/>
    <resource>
      <SearchParameter>
        <id value="CodeSystem-jurisdiction"/>
        <url value="http://hl7.org/fhir/SearchParameter/CodeSystem-jurisdiction"/>
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
        <base value="CodeSystem"/>
        <type value="token"/>
        <description value="Intended jurisdiction for the code system"/>
        <expression value="CodeSystem.jurisdiction"/>
        <xpath value="f:CodeSystem/f:jurisdiction"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CodeSystem-language"/>
    <resource>
      <SearchParameter>
        <id value="CodeSystem-language"/>
        <url value="http://hl7.org/fhir/SearchParameter/CodeSystem-language"/>
        <name value="language"/>
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
        <code value="language"/>
        <base value="CodeSystem"/>
        <type value="token"/>
        <description value="A language in which a designation is provided"/>
        <expression value="CodeSystem.concept.designation.language"/>
        <xpath value="f:CodeSystem/f:concept/f:designation/f:language"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CodeSystem-name"/>
    <resource>
      <SearchParameter>
        <id value="CodeSystem-name"/>
        <url value="http://hl7.org/fhir/SearchParameter/CodeSystem-name"/>
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
        <base value="CodeSystem"/>
        <type value="string"/>
        <description value="Computationally friendly name of the code system"/>
        <expression value="CodeSystem.name"/>
        <xpath value="f:CodeSystem/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CodeSystem-publisher"/>
    <resource>
      <SearchParameter>
        <id value="CodeSystem-publisher"/>
        <url value="http://hl7.org/fhir/SearchParameter/CodeSystem-publisher"/>
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
        <base value="CodeSystem"/>
        <type value="string"/>
        <description value="Name of the publisher of the code system"/>
        <expression value="CodeSystem.publisher"/>
        <xpath value="f:CodeSystem/f:publisher"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CodeSystem-status"/>
    <resource>
      <SearchParameter>
        <id value="CodeSystem-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/CodeSystem-status"/>
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
        <base value="CodeSystem"/>
        <type value="token"/>
        <description value="The current status of the code system"/>
        <expression value="CodeSystem.status"/>
        <xpath value="f:CodeSystem/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CodeSystem-system"/>
    <resource>
      <SearchParameter>
        <id value="CodeSystem-system"/>
        <url value="http://hl7.org/fhir/SearchParameter/CodeSystem-system"/>
        <name value="system"/>
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
        <code value="system"/>
        <base value="CodeSystem"/>
        <type value="uri"/>
        <description value="The system for any codes defined by this code system (same as &apos;url&apos;)"/>
        <expression value="CodeSystem.url"/>
        <xpath value="f:CodeSystem/f:url"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CodeSystem-title"/>
    <resource>
      <SearchParameter>
        <id value="CodeSystem-title"/>
        <url value="http://hl7.org/fhir/SearchParameter/CodeSystem-title"/>
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
        <base value="CodeSystem"/>
        <type value="string"/>
        <description value="The human-friendly name of the code system"/>
        <expression value="CodeSystem.title"/>
        <xpath value="f:CodeSystem/f:title"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CodeSystem-url"/>
    <resource>
      <SearchParameter>
        <id value="CodeSystem-url"/>
        <url value="http://hl7.org/fhir/SearchParameter/CodeSystem-url"/>
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
        <base value="CodeSystem"/>
        <type value="uri"/>
        <description value="The uri that identifies the code system"/>
        <expression value="CodeSystem.url"/>
        <xpath value="f:CodeSystem/f:url"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CodeSystem-version"/>
    <resource>
      <SearchParameter>
        <id value="CodeSystem-version"/>
        <url value="http://hl7.org/fhir/SearchParameter/CodeSystem-version"/>
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
        <base value="CodeSystem"/>
        <type value="token"/>
        <description value="The business version of the code system"/>
        <expression value="CodeSystem.version"/>
        <xpath value="f:CodeSystem/f:version"/>
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
