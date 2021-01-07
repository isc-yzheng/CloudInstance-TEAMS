Class HS.FHIR.vDSTU2.Repository.Resource.EnrollmentRequest Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-EnrollmentRequest"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EnrollmentRequest-identifier"/>
    <resource>
      <SearchParameter>
        <id value="EnrollmentRequest-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/EnrollmentRequest-identifier"/>
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
        <base value="EnrollmentRequest"/>
        <type value="token"/>
        <description value="The business identifier of the Enrollment"/>
        <xpath value="f:EnrollmentRequest/f:identifier"/>
        <xpathUsage value="normal"/>
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
        <code value="patient"/>
        <base value="EnrollmentRequest"/>
        <type value="reference"/>
        <description value="The party to be enrolled"/>
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
        <code value="subject"/>
        <base value="EnrollmentRequest"/>
        <type value="reference"/>
        <description value="The party to be enrolled"/>
        <xpath value="f:EnrollmentRequest/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
