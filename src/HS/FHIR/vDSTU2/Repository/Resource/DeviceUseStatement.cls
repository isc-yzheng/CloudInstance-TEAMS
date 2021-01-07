Class HS.FHIR.vDSTU2.Repository.Resource.DeviceUseStatement Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-DeviceUseStatement"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DeviceUseStatement-device"/>
    <resource>
      <SearchParameter>
        <id value="DeviceUseStatement-device"/>
        <url value="http://hl7.org/fhir/SearchParameter/DeviceUseStatement-device"/>
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
        <base value="DeviceUseStatement"/>
        <type value="reference"/>
        <description value="Search by device"/>
        <xpath value="f:DeviceUseStatement/f:device"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DeviceUseStatement-patient"/>
    <resource>
      <SearchParameter>
        <id value="DeviceUseStatement-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/DeviceUseStatement-patient"/>
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
        <base value="DeviceUseStatement"/>
        <type value="reference"/>
        <description value="Search by subject - a patient"/>
        <xpath value="f:DeviceUseStatement/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DeviceUseStatement-subject"/>
    <resource>
      <SearchParameter>
        <id value="DeviceUseStatement-subject"/>
        <url value="http://hl7.org/fhir/SearchParameter/DeviceUseStatement-subject"/>
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
        <base value="DeviceUseStatement"/>
        <type value="reference"/>
        <description value="Search by subject"/>
        <xpath value="f:DeviceUseStatement/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
