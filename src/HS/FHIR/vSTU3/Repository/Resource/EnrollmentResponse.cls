Class HS.FHIR.vSTU3.Repository.Resource.EnrollmentResponse Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-EnrollmentResponse"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EnrollmentResponse-identifier"/>
    <resource>
      <SearchParameter>
        <id value="EnrollmentResponse-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/EnrollmentResponse-identifier"/>
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
        <base value="EnrollmentResponse"/>
        <type value="token"/>
        <description value="The business identifier of the EnrollmentResponse"/>
        <expression value="EnrollmentResponse.identifier"/>
        <xpath value="f:EnrollmentResponse/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EnrollmentResponse-organization"/>
    <resource>
      <SearchParameter>
        <id value="EnrollmentResponse-organization"/>
        <url value="http://hl7.org/fhir/SearchParameter/EnrollmentResponse-organization"/>
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
        <base value="EnrollmentResponse"/>
        <type value="reference"/>
        <description value="The organization who generated this resource"/>
        <expression value="EnrollmentResponse.organization"/>
        <xpath value="f:EnrollmentResponse/f:organization"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EnrollmentResponse-request"/>
    <resource>
      <SearchParameter>
        <id value="EnrollmentResponse-request"/>
        <url value="http://hl7.org/fhir/SearchParameter/EnrollmentResponse-request"/>
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
        <base value="EnrollmentResponse"/>
        <type value="reference"/>
        <description value="The reference to the claim"/>
        <expression value="EnrollmentResponse.request"/>
        <xpath value="f:EnrollmentResponse/f:request"/>
        <xpathUsage value="normal"/>
        <target value="EnrollmentRequest"/>
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
