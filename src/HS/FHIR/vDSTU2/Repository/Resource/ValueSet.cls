Class HS.FHIR.vDSTU2.Repository.Resource.ValueSet Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-ValueSet"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ValueSet-code"/>
    <resource>
      <SearchParameter>
        <id value="ValueSet-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/ValueSet-code"/>
        <name value="code"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="code"/>
        <base value="ValueSet"/>
        <type value="token"/>
        <description value="A code defined in the value set"/>
        <xpath value="f:ValueSet/f:codeSystem/f:concept/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ValueSet-context"/>
    <resource>
      <SearchParameter>
        <id value="ValueSet-context"/>
        <url value="http://hl7.org/fhir/SearchParameter/ValueSet-context"/>
        <name value="context"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="context"/>
        <base value="ValueSet"/>
        <type value="token"/>
        <description value="A use context assigned to the value set"/>
        <xpath value="f:ValueSet/f:useContext"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ValueSet-date"/>
    <resource>
      <SearchParameter>
        <id value="ValueSet-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/ValueSet-date"/>
        <name value="date"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="date"/>
        <base value="ValueSet"/>
        <type value="date"/>
        <description value="The value set publication date"/>
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
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="description"/>
        <base value="ValueSet"/>
        <type value="string"/>
        <description value="Text search in the description of the value set"/>
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
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="expansion"/>
        <base value="ValueSet"/>
        <type value="uri"/>
        <description value="Uniquely identifies this expansion"/>
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
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="identifier"/>
        <base value="ValueSet"/>
        <type value="token"/>
        <description value="The identifier for the value set"/>
        <xpath value="f:ValueSet/f:identifier"/>
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
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="name"/>
        <base value="ValueSet"/>
        <type value="string"/>
        <description value="The name of the value set"/>
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
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="publisher"/>
        <base value="ValueSet"/>
        <type value="string"/>
        <description value="Name of the publisher of the value set"/>
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
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="reference"/>
        <base value="ValueSet"/>
        <type value="uri"/>
        <description value="A code system included or excluded in the value set or an imported value set"/>
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
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="status"/>
        <base value="ValueSet"/>
        <type value="token"/>
        <description value="The status of the value set"/>
        <xpath value="f:ValueSet/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ValueSet-system"/>
    <resource>
      <SearchParameter>
        <id value="ValueSet-system"/>
        <url value="http://hl7.org/fhir/SearchParameter/ValueSet-system"/>
        <name value="system"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="system"/>
        <base value="ValueSet"/>
        <type value="uri"/>
        <description value="The system for any codes defined by this value set"/>
        <xpath value="f:ValueSet/f:codeSystem/f:system"/>
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
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="url"/>
        <base value="ValueSet"/>
        <type value="uri"/>
        <description value="The logical URL for the value set"/>
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
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="version"/>
        <base value="ValueSet"/>
        <type value="token"/>
        <description value="The version identifier of the value set"/>
        <xpath value="f:ValueSet/f:version"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
