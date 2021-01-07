Class HS.FHIR.vDSTU2.Repository.Resource.DeviceComponent Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-DeviceComponent"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DeviceComponent-parent"/>
    <resource>
      <SearchParameter>
        <id value="DeviceComponent-parent"/>
        <url value="http://hl7.org/fhir/SearchParameter/DeviceComponent-parent"/>
        <name value="parent"/>
        <publisher value="Health Level Seven International (Health Care Devices)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/healthcaredevices/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="parent"/>
        <base value="DeviceComponent"/>
        <type value="reference"/>
        <description value="The parent DeviceComponent resource"/>
        <xpath value="f:DeviceComponent/f:parent"/>
        <xpathUsage value="normal"/>
        <target value="DeviceComponent"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DeviceComponent-source"/>
    <resource>
      <SearchParameter>
        <id value="DeviceComponent-source"/>
        <url value="http://hl7.org/fhir/SearchParameter/DeviceComponent-source"/>
        <name value="source"/>
        <publisher value="Health Level Seven International (Health Care Devices)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/healthcaredevices/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="source"/>
        <base value="DeviceComponent"/>
        <type value="reference"/>
        <description value="The device source"/>
        <xpath value="f:DeviceComponent/f:source"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DeviceComponent-type"/>
    <resource>
      <SearchParameter>
        <id value="DeviceComponent-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/DeviceComponent-type"/>
        <name value="type"/>
        <publisher value="Health Level Seven International (Health Care Devices)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/healthcaredevices/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="type"/>
        <base value="DeviceComponent"/>
        <type value="token"/>
        <description value="The device component type"/>
        <xpath value="f:DeviceComponent/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
