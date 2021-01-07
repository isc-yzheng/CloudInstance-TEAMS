Class HS.FHIR.vDSTU2.Repository.Resource.DeviceUseRequest Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-DeviceUseRequest"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DeviceUseRequest-device"/>
    <resource>
      <SearchParameter>
        <id value="DeviceUseRequest-device"/>
        <url value="http://hl7.org/fhir/SearchParameter/DeviceUseRequest-device"/>
        <name value="device"/>
        <publisher value="Health Level Seven International (Clinical Decision Support)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/dss/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="device"/>
        <base value="DeviceUseRequest"/>
        <type value="reference"/>
        <description value="Device requested"/>
        <xpath value="f:DeviceUseRequest/f:device"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DeviceUseRequest-patient"/>
    <resource>
      <SearchParameter>
        <id value="DeviceUseRequest-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/DeviceUseRequest-patient"/>
        <name value="patient"/>
        <publisher value="Health Level Seven International (Clinical Decision Support)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/dss/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="patient"/>
        <base value="DeviceUseRequest"/>
        <type value="reference"/>
        <description value="Search by subject - a patient"/>
        <xpath value="f:DeviceUseRequest/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DeviceUseRequest-subject"/>
    <resource>
      <SearchParameter>
        <id value="DeviceUseRequest-subject"/>
        <url value="http://hl7.org/fhir/SearchParameter/DeviceUseRequest-subject"/>
        <name value="subject"/>
        <publisher value="Health Level Seven International (Clinical Decision Support)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/dss/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="subject"/>
        <base value="DeviceUseRequest"/>
        <type value="reference"/>
        <description value="Search by subject"/>
        <xpath value="f:DeviceUseRequest/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
