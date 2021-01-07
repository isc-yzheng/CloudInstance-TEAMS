Class HS.FHIR.vSTU3.Repository.Resource.EligibilityResponse Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-EligibilityResponse"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EligibilityResponse-created"/>
    <resource>
      <SearchParameter>
        <id value="EligibilityResponse-created"/>
        <url value="http://hl7.org/fhir/SearchParameter/EligibilityResponse-created"/>
        <name value="created"/>
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
        <code value="created"/>
        <base value="EligibilityResponse"/>
        <type value="date"/>
        <description value="The creation date"/>
        <expression value="EligibilityResponse.created"/>
        <xpath value="f:EligibilityResponse/f:created"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EligibilityResponse-disposition"/>
    <resource>
      <SearchParameter>
        <id value="EligibilityResponse-disposition"/>
        <url value="http://hl7.org/fhir/SearchParameter/EligibilityResponse-disposition"/>
        <name value="disposition"/>
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
        <code value="disposition"/>
        <base value="EligibilityResponse"/>
        <type value="string"/>
        <description value="The contents of the disposition message"/>
        <expression value="EligibilityResponse.disposition"/>
        <xpath value="f:EligibilityResponse/f:disposition"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EligibilityResponse-identifier"/>
    <resource>
      <SearchParameter>
        <id value="EligibilityResponse-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/EligibilityResponse-identifier"/>
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
        <base value="EligibilityResponse"/>
        <type value="token"/>
        <description value="The business identifier"/>
        <expression value="EligibilityResponse.identifier"/>
        <xpath value="f:EligibilityResponse/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EligibilityResponse-insurer"/>
    <resource>
      <SearchParameter>
        <id value="EligibilityResponse-insurer"/>
        <url value="http://hl7.org/fhir/SearchParameter/EligibilityResponse-insurer"/>
        <name value="insurer"/>
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
        <code value="insurer"/>
        <base value="EligibilityResponse"/>
        <type value="reference"/>
        <description value="The organization which generated this resource"/>
        <expression value="EligibilityResponse.insurer"/>
        <xpath value="f:EligibilityResponse/f:insurer"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EligibilityResponse-outcome"/>
    <resource>
      <SearchParameter>
        <id value="EligibilityResponse-outcome"/>
        <url value="http://hl7.org/fhir/SearchParameter/EligibilityResponse-outcome"/>
        <name value="outcome"/>
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
        <code value="outcome"/>
        <base value="EligibilityResponse"/>
        <type value="token"/>
        <description value="The processing outcome"/>
        <expression value="EligibilityResponse.outcome"/>
        <xpath value="f:EligibilityResponse/f:outcome"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EligibilityResponse-request"/>
    <resource>
      <SearchParameter>
        <id value="EligibilityResponse-request"/>
        <url value="http://hl7.org/fhir/SearchParameter/EligibilityResponse-request"/>
        <name value="request"/>
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
        <code value="request"/>
        <base value="EligibilityResponse"/>
        <type value="reference"/>
        <description value="The EligibilityRequest reference"/>
        <expression value="EligibilityResponse.request"/>
        <xpath value="f:EligibilityResponse/f:request"/>
        <xpathUsage value="normal"/>
        <target value="EligibilityRequest"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EligibilityResponse-request-organization"/>
    <resource>
      <SearchParameter>
        <id value="EligibilityResponse-request-organization"/>
        <url value="http://hl7.org/fhir/SearchParameter/EligibilityResponse-request-organization"/>
        <name value="request-organization"/>
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
        <code value="request-organization"/>
        <base value="EligibilityResponse"/>
        <type value="reference"/>
        <description value="The EligibilityRequest organization"/>
        <expression value="EligibilityResponse.requestOrganization"/>
        <xpath value="f:EligibilityResponse/f:requestOrganization"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EligibilityResponse-request-provider"/>
    <resource>
      <SearchParameter>
        <id value="EligibilityResponse-request-provider"/>
        <url value="http://hl7.org/fhir/SearchParameter/EligibilityResponse-request-provider"/>
        <name value="request-provider"/>
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
        <code value="request-provider"/>
        <base value="EligibilityResponse"/>
        <type value="reference"/>
        <description value="The EligibilityRequest provider"/>
        <expression value="EligibilityResponse.requestProvider"/>
        <xpath value="f:EligibilityResponse/f:requestProvider"/>
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
