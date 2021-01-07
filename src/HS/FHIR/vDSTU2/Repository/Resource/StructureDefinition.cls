Class HS.FHIR.vDSTU2.Repository.Resource.StructureDefinition Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

/// EXCLUDEPARAMS is a list of search parameters to NOT support. "valueset" is on this list
/// because StructureDefinition-valueset is a reference type search parameter but its xpath
/// as specified by the FHIR spec itself includes at least one non-reference type data field.
/// Rather than give the appearance of supporting or partially supporting a faulty FHIR spec,
/// this removes any support for the search parameter at all.
Parameter EXCLUDEPARAMS = ",valueset,";

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-StructureDefinition"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureDefinition-abstract"/>
    <resource>
      <SearchParameter>
        <id value="StructureDefinition-abstract"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureDefinition-abstract"/>
        <name value="abstract"/>
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
        <code value="abstract"/>
        <base value="StructureDefinition"/>
        <type value="token"/>
        <description value="Whether the structure is abstract"/>
        <xpath value="f:StructureDefinition/f:abstract"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureDefinition-base"/>
    <resource>
      <SearchParameter>
        <id value="StructureDefinition-base"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureDefinition-base"/>
        <name value="base"/>
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
        <code value="base"/>
        <base value="StructureDefinition"/>
        <type value="uri"/>
        <description value="Structure that this set of constraints applies to"/>
        <xpath value="f:StructureDefinition/f:base"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureDefinition-base-path"/>
    <resource>
      <SearchParameter>
        <id value="StructureDefinition-base-path"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureDefinition-base-path"/>
        <name value="base-path"/>
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
        <code value="base-path"/>
        <base value="StructureDefinition"/>
        <type value="token"/>
        <description value="Path that identifies the base element"/>
        <xpath value="f:StructureDefinition/f:snapshot/f:element/f:base/f:path"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureDefinition-code"/>
    <resource>
      <SearchParameter>
        <id value="StructureDefinition-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureDefinition-code"/>
        <name value="code"/>
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
        <code value="code"/>
        <base value="StructureDefinition"/>
        <type value="token"/>
        <description value="A code for the profile"/>
        <xpath value="f:StructureDefinition/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureDefinition-context"/>
    <resource>
      <SearchParameter>
        <id value="StructureDefinition-context"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureDefinition-context"/>
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
        <base value="StructureDefinition"/>
        <type value="token"/>
        <description value="A use context assigned to the structure"/>
        <xpath value="f:StructureDefinition/f:useContext"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureDefinition-context-type"/>
    <resource>
      <SearchParameter>
        <id value="StructureDefinition-context-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureDefinition-context-type"/>
        <name value="context-type"/>
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
        <code value="context-type"/>
        <base value="StructureDefinition"/>
        <type value="token"/>
        <description value="resource | datatype | mapping | extension"/>
        <xpath value="f:StructureDefinition/f:contextType"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureDefinition-date"/>
    <resource>
      <SearchParameter>
        <id value="StructureDefinition-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureDefinition-date"/>
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
        <base value="StructureDefinition"/>
        <type value="date"/>
        <description value="The profile publication date"/>
        <xpath value="f:StructureDefinition/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureDefinition-description"/>
    <resource>
      <SearchParameter>
        <id value="StructureDefinition-description"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureDefinition-description"/>
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
        <base value="StructureDefinition"/>
        <type value="string"/>
        <description value="Text search in the description of the profile"/>
        <xpath value="f:StructureDefinition/f:description"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureDefinition-display"/>
    <resource>
      <SearchParameter>
        <id value="StructureDefinition-display"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureDefinition-display"/>
        <name value="display"/>
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
        <code value="display"/>
        <base value="StructureDefinition"/>
        <type value="string"/>
        <description value="Use this name when displaying the value"/>
        <xpath value="f:StructureDefinition/f:display"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureDefinition-experimental"/>
    <resource>
      <SearchParameter>
        <id value="StructureDefinition-experimental"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureDefinition-experimental"/>
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
        <base value="StructureDefinition"/>
        <type value="token"/>
        <description value="If for testing purposes, not real usage"/>
        <xpath value="f:StructureDefinition/f:experimental"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureDefinition-ext-context"/>
    <resource>
      <SearchParameter>
        <id value="StructureDefinition-ext-context"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureDefinition-ext-context"/>
        <name value="ext-context"/>
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
        <code value="ext-context"/>
        <base value="StructureDefinition"/>
        <type value="string"/>
        <description value="Where the extension can be used in instances"/>
        <xpath value="f:StructureDefinition/f:context"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureDefinition-identifier"/>
    <resource>
      <SearchParameter>
        <id value="StructureDefinition-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureDefinition-identifier"/>
        <name value="identifier"/>
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
        <code value="identifier"/>
        <base value="StructureDefinition"/>
        <type value="token"/>
        <description value="The identifier of the profile"/>
        <xpath value="f:StructureDefinition/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureDefinition-kind"/>
    <resource>
      <SearchParameter>
        <id value="StructureDefinition-kind"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureDefinition-kind"/>
        <name value="kind"/>
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
        <code value="kind"/>
        <base value="StructureDefinition"/>
        <type value="token"/>
        <description value="datatype | resource | logical"/>
        <xpath value="f:StructureDefinition/f:kind"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureDefinition-name"/>
    <resource>
      <SearchParameter>
        <id value="StructureDefinition-name"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureDefinition-name"/>
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
        <base value="StructureDefinition"/>
        <type value="string"/>
        <description value="Name of the profile"/>
        <xpath value="f:StructureDefinition/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureDefinition-path"/>
    <resource>
      <SearchParameter>
        <id value="StructureDefinition-path"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureDefinition-path"/>
        <name value="path"/>
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
        <code value="path"/>
        <base value="StructureDefinition"/>
        <type value="token"/>
        <description value="A path that is constrained in the profile"/>
        <xpath value="f:StructureDefinition/f:snapshot/f:element/f:path"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureDefinition-publisher"/>
    <resource>
      <SearchParameter>
        <id value="StructureDefinition-publisher"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureDefinition-publisher"/>
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
        <base value="StructureDefinition"/>
        <type value="string"/>
        <description value="Name of the publisher of the profile"/>
        <xpath value="f:StructureDefinition/f:publisher"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureDefinition-status"/>
    <resource>
      <SearchParameter>
        <id value="StructureDefinition-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureDefinition-status"/>
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
        <base value="StructureDefinition"/>
        <type value="token"/>
        <description value="The current status of the profile"/>
        <xpath value="f:StructureDefinition/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureDefinition-type"/>
    <resource>
      <SearchParameter>
        <id value="StructureDefinition-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureDefinition-type"/>
        <name value="type"/>
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
        <code value="type"/>
        <base value="StructureDefinition"/>
        <type value="token"/>
        <description value="Any datatype or resource, including abstract ones"/>
        <xpath value="f:StructureDefinition/f:constrainedType"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureDefinition-url"/>
    <resource>
      <SearchParameter>
        <id value="StructureDefinition-url"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureDefinition-url"/>
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
        <base value="StructureDefinition"/>
        <type value="uri"/>
        <description value="Absolute URL used to reference this StructureDefinition"/>
        <xpath value="f:StructureDefinition/f:url"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureDefinition-valueset"/>
    <resource>
      <SearchParameter>
        <id value="StructureDefinition-valueset"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureDefinition-valueset"/>
        <name value="valueset"/>
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
        <code value="valueset"/>
        <base value="StructureDefinition"/>
        <type value="reference"/>
        <description value="A vocabulary binding reference"/>
        <xpath value="f:StructureDefinition/f:snapshot/f:element/f:binding/f:valueSetUri | f:StructureDefinition/f:snapshot/f:element/f:binding/f:valueSetReference"/>
        <xpathUsage value="normal"/>
        <target value="ValueSet"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureDefinition-version"/>
    <resource>
      <SearchParameter>
        <id value="StructureDefinition-version"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureDefinition-version"/>
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
        <base value="StructureDefinition"/>
        <type value="token"/>
        <description value="The version identifier of the profile"/>
        <xpath value="f:StructureDefinition/f:version"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
