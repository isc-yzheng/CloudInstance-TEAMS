Class HS.FHIR.vSTU3.Repository.Resource.ProcessRequest Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-ProcessRequest"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ProcessRequest-action"/>
    <resource>
      <SearchParameter>
        <id value="ProcessRequest-action"/>
        <url value="http://hl7.org/fhir/SearchParameter/ProcessRequest-action"/>
        <name value="action"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="action"/>
        <base value="ProcessRequest"/>
        <type value="token"/>
        <description value="The action requested by this resource"/>
        <expression value="ProcessRequest.action"/>
        <xpath value="f:ProcessRequest/f:action"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ProcessRequest-identifier"/>
    <resource>
      <SearchParameter>
        <id value="ProcessRequest-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/ProcessRequest-identifier"/>
        <name value="identifier"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="identifier"/>
        <base value="ProcessRequest"/>
        <type value="token"/>
        <description value="The business identifier of the ProcessRequest"/>
        <expression value="ProcessRequest.identifier"/>
        <xpath value="f:ProcessRequest/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ProcessRequest-organization"/>
    <resource>
      <SearchParameter>
        <id value="ProcessRequest-organization"/>
        <url value="http://hl7.org/fhir/SearchParameter/ProcessRequest-organization"/>
        <name value="organization"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="organization"/>
        <base value="ProcessRequest"/>
        <type value="reference"/>
        <description value="The organization who generated this request"/>
        <expression value="ProcessRequest.organization"/>
        <xpath value="f:ProcessRequest/f:organization"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ProcessRequest-provider"/>
    <resource>
      <SearchParameter>
        <id value="ProcessRequest-provider"/>
        <url value="http://hl7.org/fhir/SearchParameter/ProcessRequest-provider"/>
        <name value="provider"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="provider"/>
        <base value="ProcessRequest"/>
        <type value="reference"/>
        <description value="The provider who regenerated this request"/>
        <expression value="ProcessRequest.provider"/>
        <xpath value="f:ProcessRequest/f:provider"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
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
