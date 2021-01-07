Class HS.FHIR.vSTU3.Repository.Resource.Endpoint Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Endpoint"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Endpoint-connection-type"/>
    <resource>
      <SearchParameter>
        <id value="Endpoint-connection-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/Endpoint-connection-type"/>
        <name value="connection-type"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="connection-type"/>
        <base value="Endpoint"/>
        <type value="token"/>
        <description value="Protocol/Profile/Standard to be used with this endpoint connection"/>
        <expression value="Endpoint.connectionType"/>
        <xpath value="f:Endpoint/f:connectionType"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Endpoint-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Endpoint-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Endpoint-identifier"/>
        <name value="identifier"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="identifier"/>
        <base value="Endpoint"/>
        <type value="token"/>
        <description value="Identifies this endpoint across multiple systems"/>
        <expression value="Endpoint.identifier"/>
        <xpath value="f:Endpoint/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Endpoint-name"/>
    <resource>
      <SearchParameter>
        <id value="Endpoint-name"/>
        <url value="http://hl7.org/fhir/SearchParameter/Endpoint-name"/>
        <name value="name"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="name"/>
        <base value="Endpoint"/>
        <type value="string"/>
        <description value="A name that this endpoint can be identified by"/>
        <expression value="Endpoint.name"/>
        <xpath value="f:Endpoint/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Endpoint-organization"/>
    <resource>
      <SearchParameter>
        <id value="Endpoint-organization"/>
        <url value="http://hl7.org/fhir/SearchParameter/Endpoint-organization"/>
        <name value="organization"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="organization"/>
        <base value="Endpoint"/>
        <type value="reference"/>
        <description value="The organization that is managing the endpoint"/>
        <expression value="Endpoint.managingOrganization"/>
        <xpath value="f:Endpoint/f:managingOrganization"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Endpoint-payload-type"/>
    <resource>
      <SearchParameter>
        <id value="Endpoint-payload-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/Endpoint-payload-type"/>
        <name value="payload-type"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="payload-type"/>
        <base value="Endpoint"/>
        <type value="token"/>
        <description value="The type of content that may be used at this endpoint (e.g. XDS Discharge summaries)"/>
        <expression value="Endpoint.payloadType"/>
        <xpath value="f:Endpoint/f:payloadType"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Endpoint-status"/>
    <resource>
      <SearchParameter>
        <id value="Endpoint-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/Endpoint-status"/>
        <name value="status"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="status"/>
        <base value="Endpoint"/>
        <type value="token"/>
        <description value="The current status of the Endpoint (usually expected to be active)"/>
        <expression value="Endpoint.status"/>
        <xpath value="f:Endpoint/f:status"/>
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
