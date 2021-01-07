Class HS.FHIR.vSTU3.Repository.Resource.EnrollmentRequest Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-EnrollmentRequest"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EnrollmentRequest-identifier"/>
    <resource>
      <SearchParameter>
        <id value="EnrollmentRequest-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/EnrollmentRequest-identifier"/>
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
        <base value="EnrollmentRequest"/>
        <type value="token"/>
        <description value="The business identifier of the Enrollment"/>
        <expression value="EnrollmentRequest.identifier"/>
        <xpath value="f:EnrollmentRequest/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EnrollmentRequest-organization"/>
    <resource>
      <SearchParameter>
        <id value="EnrollmentRequest-organization"/>
        <url value="http://hl7.org/fhir/SearchParameter/EnrollmentRequest-organization"/>
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
        <base value="EnrollmentRequest"/>
        <type value="reference"/>
        <description value="The organization who generated this resource"/>
        <expression value="EnrollmentRequest.organization"/>
        <xpath value="f:EnrollmentRequest/f:organization"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EnrollmentRequest-patient"/>
    <resource>
      <SearchParameter>
        <id value="EnrollmentRequest-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/EnrollmentRequest-patient"/>
        <name value="patient"/>
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
        <code value="patient"/>
        <base value="EnrollmentRequest"/>
        <type value="reference"/>
        <description value="The party to be enrolled"/>
        <expression value="EnrollmentRequest.subject"/>
        <xpath value="f:EnrollmentRequest/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EnrollmentRequest-subject"/>
    <resource>
      <SearchParameter>
        <id value="EnrollmentRequest-subject"/>
        <url value="http://hl7.org/fhir/SearchParameter/EnrollmentRequest-subject"/>
        <name value="subject"/>
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
        <code value="subject"/>
        <base value="EnrollmentRequest"/>
        <type value="reference"/>
        <description value="The party to be enrolled"/>
        <expression value="EnrollmentRequest.subject"/>
        <xpath value="f:EnrollmentRequest/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
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
