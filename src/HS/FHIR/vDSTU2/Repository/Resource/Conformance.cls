Class HS.FHIR.vDSTU2.Repository.Resource.Conformance Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Conformance"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Conformance-date"/>
    <resource>
      <SearchParameter>
        <id value="Conformance-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/Conformance-date"/>
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
        <base value="Conformance"/>
        <type value="date"/>
        <description value="The conformance statement publication date"/>
        <xpath value="f:Conformance/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Conformance-description"/>
    <resource>
      <SearchParameter>
        <id value="Conformance-description"/>
        <url value="http://hl7.org/fhir/SearchParameter/Conformance-description"/>
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
        <base value="Conformance"/>
        <type value="string"/>
        <description value="Text search in the description of the conformance statement"/>
        <xpath value="f:Conformance/f:description"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Conformance-event"/>
    <resource>
      <SearchParameter>
        <id value="Conformance-event"/>
        <url value="http://hl7.org/fhir/SearchParameter/Conformance-event"/>
        <name value="event"/>
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
        <code value="event"/>
        <base value="Conformance"/>
        <type value="token"/>
        <description value="Event code in a conformance statement"/>
        <xpath value="f:Conformance/f:messaging/f:event/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Conformance-fhirversion"/>
    <resource>
      <SearchParameter>
        <id value="Conformance-fhirversion"/>
        <url value="http://hl7.org/fhir/SearchParameter/Conformance-fhirversion"/>
        <name value="fhirversion"/>
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
        <code value="fhirversion"/>
        <base value="Conformance"/>
        <type value="token"/>
        <description value="The version of FHIR"/>
        <xpath value="f:Conformance/f:version"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Conformance-format"/>
    <resource>
      <SearchParameter>
        <id value="Conformance-format"/>
        <url value="http://hl7.org/fhir/SearchParameter/Conformance-format"/>
        <name value="format"/>
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
        <code value="format"/>
        <base value="Conformance"/>
        <type value="token"/>
        <description value="formats supported (xml | json | mime type)"/>
        <xpath value="f:Conformance/f:format"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Conformance-mode"/>
    <resource>
      <SearchParameter>
        <id value="Conformance-mode"/>
        <url value="http://hl7.org/fhir/SearchParameter/Conformance-mode"/>
        <name value="mode"/>
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
        <code value="mode"/>
        <base value="Conformance"/>
        <type value="token"/>
        <description value="Mode - restful (server/client) or messaging (sender/receiver)"/>
        <xpath value="f:Conformance/f:rest/f:mode"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Conformance-name"/>
    <resource>
      <SearchParameter>
        <id value="Conformance-name"/>
        <url value="http://hl7.org/fhir/SearchParameter/Conformance-name"/>
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
        <base value="Conformance"/>
        <type value="string"/>
        <description value="Name of the conformance statement"/>
        <xpath value="f:Conformance/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Conformance-profile"/>
    <resource>
      <SearchParameter>
        <id value="Conformance-profile"/>
        <url value="http://hl7.org/fhir/SearchParameter/Conformance-profile"/>
        <name value="profile"/>
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
        <code value="profile"/>
        <base value="Conformance"/>
        <type value="reference"/>
        <description value="A profile id invoked in a conformance statement"/>
        <xpath value="f:Conformance/f:rest/f:resource/f:profile"/>
        <xpathUsage value="normal"/>
        <target value="StructureDefinition"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Conformance-publisher"/>
    <resource>
      <SearchParameter>
        <id value="Conformance-publisher"/>
        <url value="http://hl7.org/fhir/SearchParameter/Conformance-publisher"/>
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
        <base value="Conformance"/>
        <type value="string"/>
        <description value="Name of the publisher of the conformance statement"/>
        <xpath value="f:Conformance/f:publisher"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Conformance-resource"/>
    <resource>
      <SearchParameter>
        <id value="Conformance-resource"/>
        <url value="http://hl7.org/fhir/SearchParameter/Conformance-resource"/>
        <name value="resource"/>
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
        <code value="resource"/>
        <base value="Conformance"/>
        <type value="token"/>
        <description value="Name of a resource mentioned in a conformance statement"/>
        <xpath value="f:Conformance/f:rest/f:resource/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Conformance-security"/>
    <resource>
      <SearchParameter>
        <id value="Conformance-security"/>
        <url value="http://hl7.org/fhir/SearchParameter/Conformance-security"/>
        <name value="security"/>
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
        <code value="security"/>
        <base value="Conformance"/>
        <type value="token"/>
        <description value="OAuth | SMART-on-FHIR | NTLM | Basic | Kerberos | Certificates"/>
        <xpath value="f:Conformance/f:rest/f:security/f:service"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Conformance-software"/>
    <resource>
      <SearchParameter>
        <id value="Conformance-software"/>
        <url value="http://hl7.org/fhir/SearchParameter/Conformance-software"/>
        <name value="software"/>
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
        <code value="software"/>
        <base value="Conformance"/>
        <type value="string"/>
        <description value="Part of a the name of a software application"/>
        <xpath value="f:Conformance/f:software/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Conformance-status"/>
    <resource>
      <SearchParameter>
        <id value="Conformance-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/Conformance-status"/>
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
        <base value="Conformance"/>
        <type value="token"/>
        <description value="The current status of the conformance statement"/>
        <xpath value="f:Conformance/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Conformance-supported-profile"/>
    <resource>
      <SearchParameter>
        <id value="Conformance-supported-profile"/>
        <url value="http://hl7.org/fhir/SearchParameter/Conformance-supported-profile"/>
        <name value="supported-profile"/>
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
        <code value="supported-profile"/>
        <base value="Conformance"/>
        <type value="reference"/>
        <description value="Profiles for use cases supported"/>
        <xpath value="f:Conformance/f:profile"/>
        <xpathUsage value="normal"/>
        <target value="StructureDefinition"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Conformance-url"/>
    <resource>
      <SearchParameter>
        <id value="Conformance-url"/>
        <url value="http://hl7.org/fhir/SearchParameter/Conformance-url"/>
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
        <base value="Conformance"/>
        <type value="uri"/>
        <description value="The uri that identifies the conformance statement"/>
        <xpath value="f:Conformance/f:url"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Conformance-version"/>
    <resource>
      <SearchParameter>
        <id value="Conformance-version"/>
        <url value="http://hl7.org/fhir/SearchParameter/Conformance-version"/>
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
        <base value="Conformance"/>
        <type value="token"/>
        <description value="The version identifier of the conformance statement"/>
        <xpath value="f:Conformance/f:version"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
