Class HS.FHIR.vSTU3.Repository.Resource.StructureDefinition Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

/// EXCLUDEPARAMS is a list of search parameters to NOT support. "valueset" is on this list
/// because StructureDefinition-valueset is a reference type search parameter but its xpath
/// as specified by the FHIR spec itself includes at least one non-reference type data field.
/// Rather than give the appearance of supporting or partially supporting a faulty FHIR spec,
/// this removes any support for the search parameter at all.
Parameter EXCLUDEPARAMS = ",valueset,";

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-StructureDefinition"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureDefinition-abstract"/>
    <resource>
      <SearchParameter>
        <id value="StructureDefinition-abstract"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureDefinition-abstract"/>
        <name value="abstract"/>
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
        <code value="abstract"/>
        <base value="StructureDefinition"/>
        <type value="token"/>
        <description value="Whether the structure is abstract"/>
        <expression value="StructureDefinition.abstract"/>
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
        <base value="StructureDefinition"/>
        <type value="uri"/>
        <description value="Definition that this type is constrained/specialized from"/>
        <expression value="StructureDefinition.baseDefinition"/>
        <xpath value="f:StructureDefinition/f:baseDefinition"/>
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
        <code value="base-path"/>
        <base value="StructureDefinition"/>
        <type value="token"/>
        <description value="Path that identifies the base element"/>
        <expression value="StructureDefinition.snapshot.element.base.path | StructureDefinition.differential.element.base.path"/>
        <xpath value="f:StructureDefinition/f:snapshot/f:element/f:base/f:path | f:StructureDefinition/f:differential/f:element/f:base/f:path"/>
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
        <code value="context-type"/>
        <base value="StructureDefinition"/>
        <type value="token"/>
        <description value="resource | datatype | extension"/>
        <expression value="StructureDefinition.contextType"/>
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
        <base value="StructureDefinition"/>
        <type value="date"/>
        <description value="The structure definition publication date"/>
        <expression value="StructureDefinition.date"/>
        <xpath value="f:StructureDefinition/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureDefinition-derivation"/>
    <resource>
      <SearchParameter>
        <id value="StructureDefinition-derivation"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureDefinition-derivation"/>
        <name value="derivation"/>
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
        <code value="derivation"/>
        <base value="StructureDefinition"/>
        <type value="token"/>
        <description value="specialization | constraint - How relates to base definition"/>
        <expression value="StructureDefinition.derivation"/>
        <xpath value="f:StructureDefinition/f:derivation"/>
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
        <base value="StructureDefinition"/>
        <type value="string"/>
        <description value="The description of the structure definition"/>
        <expression value="StructureDefinition.description"/>
        <xpath value="f:StructureDefinition/f:description"/>
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
        <code value="experimental"/>
        <base value="StructureDefinition"/>
        <type value="token"/>
        <description value="For testing purposes, not real usage"/>
        <expression value="StructureDefinition.experimental"/>
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
        <code value="ext-context"/>
        <base value="StructureDefinition"/>
        <type value="string"/>
        <description value="Where the extension can be used in instances"/>
        <expression value="StructureDefinition.context"/>
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
        <base value="StructureDefinition"/>
        <type value="token"/>
        <description value="External identifier for the structure definition"/>
        <expression value="StructureDefinition.identifier"/>
        <xpath value="f:StructureDefinition/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureDefinition-jurisdiction"/>
    <resource>
      <SearchParameter>
        <id value="StructureDefinition-jurisdiction"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureDefinition-jurisdiction"/>
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
        <base value="StructureDefinition"/>
        <type value="token"/>
        <description value="Intended jurisdiction for the structure definition"/>
        <expression value="StructureDefinition.jurisdiction"/>
        <xpath value="f:StructureDefinition/f:jurisdiction"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureDefinition-keyword"/>
    <resource>
      <SearchParameter>
        <id value="StructureDefinition-keyword"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureDefinition-keyword"/>
        <name value="keyword"/>
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
        <code value="keyword"/>
        <base value="StructureDefinition"/>
        <type value="token"/>
        <description value="A code for the profile"/>
        <expression value="StructureDefinition.keyword"/>
        <xpath value="f:StructureDefinition/f:keyword"/>
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
        <code value="kind"/>
        <base value="StructureDefinition"/>
        <type value="token"/>
        <description value="primitive-type | complex-type | resource | logical"/>
        <expression value="StructureDefinition.kind"/>
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
        <base value="StructureDefinition"/>
        <type value="string"/>
        <description value="Computationally friendly name of the structure definition"/>
        <expression value="StructureDefinition.name"/>
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
        <code value="path"/>
        <base value="StructureDefinition"/>
        <type value="token"/>
        <description value="A path that is constrained in the profile"/>
        <expression value="StructureDefinition.snapshot.element.path | StructureDefinition.differential.element.path"/>
        <xpath value="f:StructureDefinition/f:snapshot/f:element/f:path | f:StructureDefinition/f:differential/f:element/f:path"/>
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
        <base value="StructureDefinition"/>
        <type value="string"/>
        <description value="Name of the publisher of the structure definition"/>
        <expression value="StructureDefinition.publisher"/>
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
        <base value="StructureDefinition"/>
        <type value="token"/>
        <description value="The current status of the structure definition"/>
        <expression value="StructureDefinition.status"/>
        <xpath value="f:StructureDefinition/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/StructureDefinition-title"/>
    <resource>
      <SearchParameter>
        <id value="StructureDefinition-title"/>
        <url value="http://hl7.org/fhir/SearchParameter/StructureDefinition-title"/>
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
        <base value="StructureDefinition"/>
        <type value="string"/>
        <description value="The human-friendly name of the structure definition"/>
        <expression value="StructureDefinition.title"/>
        <xpath value="f:StructureDefinition/f:title"/>
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
        <base value="StructureDefinition"/>
        <type value="token"/>
        <description value="Type defined or constrained by this structure"/>
        <expression value="StructureDefinition.type"/>
        <xpath value="f:StructureDefinition/f:type"/>
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
        <base value="StructureDefinition"/>
        <type value="uri"/>
        <description value="The uri that identifies the structure definition"/>
        <expression value="StructureDefinition.url"/>
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
        <code value="valueset"/>
        <base value="StructureDefinition"/>
        <type value="reference"/>
        <description value="A vocabulary binding reference"/>
        <expression value="StructureDefinition.snapshot.element.binding.valueSet"/>
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
        <base value="StructureDefinition"/>
        <type value="token"/>
        <description value="The business version of the structure definition"/>
        <expression value="StructureDefinition.version"/>
        <xpath value="f:StructureDefinition/f:version"/>
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
