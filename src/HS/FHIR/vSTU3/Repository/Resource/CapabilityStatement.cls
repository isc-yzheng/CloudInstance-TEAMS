Class HS.FHIR.vSTU3.Repository.Resource.CapabilityStatement Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-CapabilityStatement"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-date"/>
    <resource>
      <SearchParameter>
        <id value="CapabilityStatement-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-date"/>
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
        <base value="CapabilityStatement"/>
        <type value="date"/>
        <description value="The capability statement publication date"/>
        <expression value="CapabilityStatement.date"/>
        <xpath value="f:CapabilityStatement/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-description"/>
    <resource>
      <SearchParameter>
        <id value="CapabilityStatement-description"/>
        <url value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-description"/>
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
        <base value="CapabilityStatement"/>
        <type value="string"/>
        <description value="The description of the capability statement"/>
        <expression value="CapabilityStatement.description"/>
        <xpath value="f:CapabilityStatement/f:description"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-event"/>
    <resource>
      <SearchParameter>
        <id value="CapabilityStatement-event"/>
        <url value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-event"/>
        <name value="event"/>
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
        <code value="event"/>
        <base value="CapabilityStatement"/>
        <type value="token"/>
        <description value="Event code in a capability statement"/>
        <expression value="CapabilityStatement.messaging.event.code"/>
        <xpath value="f:CapabilityStatement/f:messaging/f:event/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-fhirversion"/>
    <resource>
      <SearchParameter>
        <id value="CapabilityStatement-fhirversion"/>
        <url value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-fhirversion"/>
        <name value="fhirversion"/>
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
        <code value="fhirversion"/>
        <base value="CapabilityStatement"/>
        <type value="token"/>
        <description value="The version of FHIR"/>
        <expression value="CapabilityStatement.version"/>
        <xpath value="f:CapabilityStatement/f:version"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-format"/>
    <resource>
      <SearchParameter>
        <id value="CapabilityStatement-format"/>
        <url value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-format"/>
        <name value="format"/>
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
        <code value="format"/>
        <base value="CapabilityStatement"/>
        <type value="token"/>
        <description value="formats supported (xml | json | ttl | mime type)"/>
        <expression value="CapabilityStatement.format"/>
        <xpath value="f:CapabilityStatement/f:format"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-guide"/>
    <resource>
      <SearchParameter>
        <id value="CapabilityStatement-guide"/>
        <url value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-guide"/>
        <name value="guide"/>
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
        <code value="guide"/>
        <base value="CapabilityStatement"/>
        <type value="uri"/>
        <description value="Implementation guides supported"/>
        <expression value="CapabilityStatement.implementationGuide"/>
        <xpath value="f:CapabilityStatement/f:implementationGuide"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-jurisdiction"/>
    <resource>
      <SearchParameter>
        <id value="CapabilityStatement-jurisdiction"/>
        <url value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-jurisdiction"/>
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
        <base value="CapabilityStatement"/>
        <type value="token"/>
        <description value="Intended jurisdiction for the capability statement"/>
        <expression value="CapabilityStatement.jurisdiction"/>
        <xpath value="f:CapabilityStatement/f:jurisdiction"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-mode"/>
    <resource>
      <SearchParameter>
        <id value="CapabilityStatement-mode"/>
        <url value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-mode"/>
        <name value="mode"/>
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
        <code value="mode"/>
        <base value="CapabilityStatement"/>
        <type value="token"/>
        <description value="Mode - restful (server/client) or messaging (sender/receiver)"/>
        <expression value="CapabilityStatement.rest.mode"/>
        <xpath value="f:CapabilityStatement/f:rest/f:mode"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-name"/>
    <resource>
      <SearchParameter>
        <id value="CapabilityStatement-name"/>
        <url value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-name"/>
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
        <base value="CapabilityStatement"/>
        <type value="string"/>
        <description value="Computationally friendly name of the capability statement"/>
        <expression value="CapabilityStatement.name"/>
        <xpath value="f:CapabilityStatement/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-publisher"/>
    <resource>
      <SearchParameter>
        <id value="CapabilityStatement-publisher"/>
        <url value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-publisher"/>
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
        <base value="CapabilityStatement"/>
        <type value="string"/>
        <description value="Name of the publisher of the capability statement"/>
        <expression value="CapabilityStatement.publisher"/>
        <xpath value="f:CapabilityStatement/f:publisher"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-resource"/>
    <resource>
      <SearchParameter>
        <id value="CapabilityStatement-resource"/>
        <url value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-resource"/>
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
        <base value="CapabilityStatement"/>
        <type value="token"/>
        <description value="Name of a resource mentioned in a capability statement"/>
        <expression value="CapabilityStatement.rest.resource.type"/>
        <xpath value="f:CapabilityStatement/f:rest/f:resource/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-resource-profile"/>
    <resource>
      <SearchParameter>
        <id value="CapabilityStatement-resource-profile"/>
        <url value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-resource-profile"/>
        <name value="resource-profile"/>
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
        <code value="resource-profile"/>
        <base value="CapabilityStatement"/>
        <type value="reference"/>
        <description value="A profile id invoked in a capability statement"/>
        <expression value="CapabilityStatement.rest.resource.profile"/>
        <xpath value="f:CapabilityStatement/f:rest/f:resource/f:profile"/>
        <xpathUsage value="normal"/>
        <target value="StructureDefinition"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-security-service"/>
    <resource>
      <SearchParameter>
        <id value="CapabilityStatement-security-service"/>
        <url value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-security-service"/>
        <name value="security-service"/>
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
        <code value="security-service"/>
        <base value="CapabilityStatement"/>
        <type value="token"/>
        <description value="OAuth | SMART-on-FHIR | NTLM | Basic | Kerberos | Certificates"/>
        <expression value="CapabilityStatement.rest.security.service"/>
        <xpath value="f:CapabilityStatement/f:rest/f:security/f:service"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-software"/>
    <resource>
      <SearchParameter>
        <id value="CapabilityStatement-software"/>
        <url value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-software"/>
        <name value="software"/>
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
        <code value="software"/>
        <base value="CapabilityStatement"/>
        <type value="string"/>
        <description value="Part of a the name of a software application"/>
        <expression value="CapabilityStatement.software.name"/>
        <xpath value="f:CapabilityStatement/f:software/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-status"/>
    <resource>
      <SearchParameter>
        <id value="CapabilityStatement-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-status"/>
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
        <base value="CapabilityStatement"/>
        <type value="token"/>
        <description value="The current status of the capability statement"/>
        <expression value="CapabilityStatement.status"/>
        <xpath value="f:CapabilityStatement/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-supported-profile"/>
    <resource>
      <SearchParameter>
        <id value="CapabilityStatement-supported-profile"/>
        <url value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-supported-profile"/>
        <name value="supported-profile"/>
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
        <code value="supported-profile"/>
        <base value="CapabilityStatement"/>
        <type value="reference"/>
        <description value="Profiles for use cases supported"/>
        <expression value="CapabilityStatement.profile"/>
        <xpath value="f:CapabilityStatement/f:profile"/>
        <xpathUsage value="normal"/>
        <target value="StructureDefinition"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-title"/>
    <resource>
      <SearchParameter>
        <id value="CapabilityStatement-title"/>
        <url value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-title"/>
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
        <base value="CapabilityStatement"/>
        <type value="string"/>
        <description value="The human-friendly name of the capability statement"/>
        <expression value="CapabilityStatement.title"/>
        <xpath value="f:CapabilityStatement/f:title"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-url"/>
    <resource>
      <SearchParameter>
        <id value="CapabilityStatement-url"/>
        <url value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-url"/>
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
        <base value="CapabilityStatement"/>
        <type value="uri"/>
        <description value="The uri that identifies the capability statement"/>
        <expression value="CapabilityStatement.url"/>
        <xpath value="f:CapabilityStatement/f:url"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-version"/>
    <resource>
      <SearchParameter>
        <id value="CapabilityStatement-version"/>
        <url value="http://hl7.org/fhir/SearchParameter/CapabilityStatement-version"/>
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
        <base value="CapabilityStatement"/>
        <type value="token"/>
        <description value="The business version of the capability statement"/>
        <expression value="CapabilityStatement.version"/>
        <xpath value="f:CapabilityStatement/f:version"/>
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
