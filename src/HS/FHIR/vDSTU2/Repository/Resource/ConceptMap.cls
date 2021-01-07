Class HS.FHIR.vDSTU2.Repository.Resource.ConceptMap Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

/// EXCLUDEPARAMS is a list of search parameters to NOT support. "target" is on this list
/// because ConceptMap-target is a reference type search parameter but its xpath
/// as specified by the FHIR spec itself includes at least one non-reference type data field.
/// Rather than give the appearance of supporting or partially supporting a faulty FHIR spec,
/// this removes any support for the search parameter at all.
Parameter EXCLUDEPARAMS = ",target,";

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-ConceptMap"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ConceptMap-context"/>
    <resource>
      <SearchParameter>
        <id value="ConceptMap-context"/>
        <url value="http://hl7.org/fhir/SearchParameter/ConceptMap-context"/>
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
        <base value="ConceptMap"/>
        <type value="token"/>
        <description value="A use context assigned to the concept map"/>
        <xpath value="f:ConceptMap/f:useContext"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ConceptMap-date"/>
    <resource>
      <SearchParameter>
        <id value="ConceptMap-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/ConceptMap-date"/>
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
        <base value="ConceptMap"/>
        <type value="date"/>
        <description value="The concept map publication date"/>
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
        <code value="dependson"/>
        <base value="ConceptMap"/>
        <type value="uri"/>
        <description value="Reference to element/field/ValueSet mapping depends on"/>
        <xpath value="f:ConceptMap/f:element/f:target/f:dependsOn/f:element"/>
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
        <base value="ConceptMap"/>
        <type value="string"/>
        <description value="Text search in the description of the concept map"/>
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
        <base value="ConceptMap"/>
        <type value="token"/>
        <description value="Additional identifier for the concept map"/>
        <xpath value="f:ConceptMap/f:identifier"/>
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
        <base value="ConceptMap"/>
        <type value="string"/>
        <description value="Name of the concept map"/>
        <xpath value="f:ConceptMap/f:name"/>
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
        <code value="product"/>
        <base value="ConceptMap"/>
        <type value="uri"/>
        <description value="Reference to element/field/ValueSet mapping depends on"/>
        <xpath value="f:ConceptMap/f:element/f:target/f:product/f:element"/>
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
        <base value="ConceptMap"/>
        <type value="string"/>
        <description value="Name of the publisher of the concept map"/>
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
        <code value="source"/>
        <base value="ConceptMap"/>
        <type value="reference"/>
        <description value="Identifies the source of the concepts which are being mapped"/>
        <xpath value="f:ConceptMap/f:sourceReference"/>
        <xpathUsage value="normal"/>
        <target value="ValueSet"/>
        <target value="StructureDefinition"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ConceptMap-sourcecode"/>
    <resource>
      <SearchParameter>
        <id value="ConceptMap-sourcecode"/>
        <url value="http://hl7.org/fhir/SearchParameter/ConceptMap-sourcecode"/>
        <name value="sourcecode"/>
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
        <code value="sourcecode"/>
        <base value="ConceptMap"/>
        <type value="token"/>
        <description value="Identifies element being mapped"/>
        <xpath value="f:ConceptMap/f:element/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ConceptMap-sourcesystem"/>
    <resource>
      <SearchParameter>
        <id value="ConceptMap-sourcesystem"/>
        <url value="http://hl7.org/fhir/SearchParameter/ConceptMap-sourcesystem"/>
        <name value="sourcesystem"/>
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
        <code value="sourcesystem"/>
        <base value="ConceptMap"/>
        <type value="uri"/>
        <description value="Code System (if value set crosses code systems)"/>
        <xpath value="f:ConceptMap/f:element/f:codeSystem"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ConceptMap-sourceuri"/>
    <resource>
      <SearchParameter>
        <id value="ConceptMap-sourceuri"/>
        <url value="http://hl7.org/fhir/SearchParameter/ConceptMap-sourceuri"/>
        <name value="sourceuri"/>
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
        <code value="sourceuri"/>
        <base value="ConceptMap"/>
        <type value="reference"/>
        <description value="Identifies the source of the concepts which are being mapped"/>
        <xpath value="f:ConceptMap/f:sourceUri"/>
        <xpathUsage value="normal"/>
        <target value="ValueSet"/>
        <target value="StructureDefinition"/>
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
        <base value="ConceptMap"/>
        <type value="token"/>
        <description value="Status of the concept map"/>
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
        <code value="target"/>
        <base value="ConceptMap"/>
        <type value="reference"/>
        <description value="Provides context to the mappings"/>
        <xpath value="f:ConceptMap/f:targetUri | f:ConceptMap/f:targetReference"/>
        <xpathUsage value="normal"/>
        <target value="ValueSet"/>
        <target value="StructureDefinition"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ConceptMap-targetcode"/>
    <resource>
      <SearchParameter>
        <id value="ConceptMap-targetcode"/>
        <url value="http://hl7.org/fhir/SearchParameter/ConceptMap-targetcode"/>
        <name value="targetcode"/>
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
        <code value="targetcode"/>
        <base value="ConceptMap"/>
        <type value="token"/>
        <description value="Code that identifies the target element"/>
        <xpath value="f:ConceptMap/f:element/f:target/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ConceptMap-targetsystem"/>
    <resource>
      <SearchParameter>
        <id value="ConceptMap-targetsystem"/>
        <url value="http://hl7.org/fhir/SearchParameter/ConceptMap-targetsystem"/>
        <name value="targetsystem"/>
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
        <code value="targetsystem"/>
        <base value="ConceptMap"/>
        <type value="uri"/>
        <description value="System of the target (if necessary)"/>
        <xpath value="f:ConceptMap/f:element/f:target/f:codeSystem"/>
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
        <base value="ConceptMap"/>
        <type value="uri"/>
        <description value="The URL of the concept map"/>
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
        <base value="ConceptMap"/>
        <type value="token"/>
        <description value="The version identifier of the concept map"/>
        <xpath value="f:ConceptMap/f:version"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
