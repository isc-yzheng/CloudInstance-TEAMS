Class HS.FHIR.vSTU3.Repository.Resource.DeviceMetric Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-DeviceMetric"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DeviceMetric-category"/>
    <resource>
      <SearchParameter>
        <id value="DeviceMetric-category"/>
        <url value="http://hl7.org/fhir/SearchParameter/DeviceMetric-category"/>
        <name value="category"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Health Care Devices)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/healthcaredevices/index.cfm"/>
          </telecom>
        </contact>
        <code value="category"/>
        <base value="DeviceMetric"/>
        <type value="token"/>
        <description value="The category of the metric"/>
        <expression value="DeviceMetric.category"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Health Care Devices)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/healthcaredevices/index.cfm"/>
          </telecom>
        </contact>
        <code value="identifier"/>
        <base value="DeviceMetric"/>
        <type value="token"/>
        <description value="The identifier of the metric"/>
        <expression value="DeviceMetric.identifier"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Health Care Devices)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/healthcaredevices/index.cfm"/>
          </telecom>
        </contact>
        <code value="parent"/>
        <base value="DeviceMetric"/>
        <type value="reference"/>
        <description value="The parent DeviceMetric resource"/>
        <expression value="DeviceMetric.parent"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Health Care Devices)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/healthcaredevices/index.cfm"/>
          </telecom>
        </contact>
        <code value="source"/>
        <base value="DeviceMetric"/>
        <type value="reference"/>
        <description value="The device resource"/>
        <expression value="DeviceMetric.source"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Health Care Devices)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/healthcaredevices/index.cfm"/>
          </telecom>
        </contact>
        <code value="type"/>
        <base value="DeviceMetric"/>
        <type value="token"/>
        <description value="The component type"/>
        <expression value="DeviceMetric.type"/>
        <xpath value="f:DeviceMetric/f:type"/>
        <xpathUsage value="normal"/>
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
