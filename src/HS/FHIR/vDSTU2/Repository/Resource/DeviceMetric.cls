Class HS.FHIR.vDSTU2.Repository.Resource.DeviceMetric Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-DeviceMetric"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DeviceMetric-category"/>
    <resource>
      <SearchParameter>
        <id value="DeviceMetric-category"/>
        <url value="http://hl7.org/fhir/SearchParameter/DeviceMetric-category"/>
        <name value="category"/>
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
        <code value="category"/>
        <base value="DeviceMetric"/>
        <type value="token"/>
        <description value="The category of the metric"/>
        <xpath value="f:DeviceMetric/f:category"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DeviceMetric-identifier"/>
    <resource>
      <SearchParameter>
        <id value="DeviceMetric-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/DeviceMetric-identifier"/>
        <name value="identifier"/>
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
        <code value="identifier"/>
        <base value="DeviceMetric"/>
        <type value="token"/>
        <description value="The identifier of the metric"/>
        <xpath value="f:DeviceMetric/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DeviceMetric-parent"/>
    <resource>
      <SearchParameter>
        <id value="DeviceMetric-parent"/>
        <url value="http://hl7.org/fhir/SearchParameter/DeviceMetric-parent"/>
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
        <base value="DeviceMetric"/>
        <type value="reference"/>
        <description value="The parent DeviceMetric resource"/>
        <xpath value="f:DeviceMetric/f:parent"/>
        <xpathUsage value="normal"/>
        <target value="DeviceComponent"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DeviceMetric-source"/>
    <resource>
      <SearchParameter>
        <id value="DeviceMetric-source"/>
        <url value="http://hl7.org/fhir/SearchParameter/DeviceMetric-source"/>
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
        <base value="DeviceMetric"/>
        <type value="reference"/>
        <description value="The device resource"/>
        <xpath value="f:DeviceMetric/f:source"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DeviceMetric-type"/>
    <resource>
      <SearchParameter>
        <id value="DeviceMetric-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/DeviceMetric-type"/>
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
        <base value="DeviceMetric"/>
        <type value="token"/>
        <description value="The component type"/>
        <xpath value="f:DeviceMetric/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
