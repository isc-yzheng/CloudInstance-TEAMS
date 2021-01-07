Class HS.FHIR.vDSTU2.Repository.Resource.ProcessRequest Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-ProcessRequest"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ProcessRequest-action"/>
    <resource>
      <SearchParameter>
        <id value="ProcessRequest-action"/>
        <url value="http://hl7.org/fhir/SearchParameter/ProcessRequest-action"/>
        <name value="action"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="action"/>
        <base value="ProcessRequest"/>
        <type value="token"/>
        <description value="The action requested by this resource"/>
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
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="identifier"/>
        <base value="ProcessRequest"/>
        <type value="token"/>
        <description value="The business identifier of the ProcessRequest"/>
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
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="organization"/>
        <base value="ProcessRequest"/>
        <type value="reference"/>
        <description value="The organization who generated this request"/>
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
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="provider"/>
        <base value="ProcessRequest"/>
        <type value="reference"/>
        <description value="The provider who regenerated this request"/>
        <xpath value="f:ProcessRequest/f:provider"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
