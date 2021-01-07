Class HS.FHIR.vSTU3.Repository.Resource.CompartmentDefinition Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-CompartmentDefinition"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CompartmentDefinition-code"/>
    <resource>
      <SearchParameter>
        <id value="CompartmentDefinition-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/CompartmentDefinition-code"/>
        <name value="code"/>
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
        <code value="code"/>
        <base value="CompartmentDefinition"/>
        <type value="token"/>
        <description value="Patient | Encounter | RelatedPerson | Practitioner | Device"/>
        <expression value="CompartmentDefinition.code"/>
        <xpath value="f:CompartmentDefinition/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CompartmentDefinition-date"/>
    <resource>
      <SearchParameter>
        <id value="CompartmentDefinition-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/CompartmentDefinition-date"/>
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
        <base value="CompartmentDefinition"/>
        <type value="date"/>
        <description value="The compartment definition publication date"/>
        <expression value="CompartmentDefinition.date"/>
        <xpath value="f:CompartmentDefinition/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CompartmentDefinition-description"/>
    <resource>
      <SearchParameter>
        <id value="CompartmentDefinition-description"/>
        <url value="http://hl7.org/fhir/SearchParameter/CompartmentDefinition-description"/>
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
        <base value="CompartmentDefinition"/>
        <type value="string"/>
        <description value="The description of the compartment definition"/>
        <expression value="CompartmentDefinition.description"/>
        <xpath value="f:CompartmentDefinition/f:description"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CompartmentDefinition-jurisdiction"/>
    <resource>
      <SearchParameter>
        <id value="CompartmentDefinition-jurisdiction"/>
        <url value="http://hl7.org/fhir/SearchParameter/CompartmentDefinition-jurisdiction"/>
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
        <base value="CompartmentDefinition"/>
        <type value="token"/>
        <description value="Intended jurisdiction for the compartment definition"/>
        <expression value="CompartmentDefinition.jurisdiction"/>
        <xpath value="f:CompartmentDefinition/f:jurisdiction"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CompartmentDefinition-name"/>
    <resource>
      <SearchParameter>
        <id value="CompartmentDefinition-name"/>
        <url value="http://hl7.org/fhir/SearchParameter/CompartmentDefinition-name"/>
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
        <base value="CompartmentDefinition"/>
        <type value="string"/>
        <description value="Computationally friendly name of the compartment definition"/>
        <expression value="CompartmentDefinition.name"/>
        <xpath value="f:CompartmentDefinition/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CompartmentDefinition-publisher"/>
    <resource>
      <SearchParameter>
        <id value="CompartmentDefinition-publisher"/>
        <url value="http://hl7.org/fhir/SearchParameter/CompartmentDefinition-publisher"/>
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
        <base value="CompartmentDefinition"/>
        <type value="string"/>
        <description value="Name of the publisher of the compartment definition"/>
        <expression value="CompartmentDefinition.publisher"/>
        <xpath value="f:CompartmentDefinition/f:publisher"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CompartmentDefinition-resource"/>
    <resource>
      <SearchParameter>
        <id value="CompartmentDefinition-resource"/>
        <url value="http://hl7.org/fhir/SearchParameter/CompartmentDefinition-resource"/>
        <name value="resource"/>
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
        <code value="resource"/>
        <base value="CompartmentDefinition"/>
        <type value="token"/>
        <description value="Name of resource type"/>
        <expression value="CompartmentDefinition.resource.code"/>
        <xpath value="f:CompartmentDefinition/f:resource/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CompartmentDefinition-status"/>
    <resource>
      <SearchParameter>
        <id value="CompartmentDefinition-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/CompartmentDefinition-status"/>
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
        <base value="CompartmentDefinition"/>
        <type value="token"/>
        <description value="The current status of the compartment definition"/>
        <expression value="CompartmentDefinition.status"/>
        <xpath value="f:CompartmentDefinition/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CompartmentDefinition-title"/>
    <resource>
      <SearchParameter>
        <id value="CompartmentDefinition-title"/>
        <url value="http://hl7.org/fhir/SearchParameter/CompartmentDefinition-title"/>
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
        <base value="CompartmentDefinition"/>
        <type value="string"/>
        <description value="The human-friendly name of the compartment definition"/>
        <expression value="CompartmentDefinition.title"/>
        <xpath value="f:CompartmentDefinition/f:title"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CompartmentDefinition-url"/>
    <resource>
      <SearchParameter>
        <id value="CompartmentDefinition-url"/>
        <url value="http://hl7.org/fhir/SearchParameter/CompartmentDefinition-url"/>
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
        <base value="CompartmentDefinition"/>
        <type value="uri"/>
        <description value="The uri that identifies the compartment definition"/>
        <expression value="CompartmentDefinition.url"/>
        <xpath value="f:CompartmentDefinition/f:url"/>
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
