Class HS.FHIR.vSTU3.Repository.Resource.DeviceComponent Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-DeviceComponent"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DeviceComponent-identifier"/>
    <resource>
      <SearchParameter>
        <id value="DeviceComponent-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/DeviceComponent-identifier"/>
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
        <base value="DeviceComponent"/>
        <type value="token"/>
        <description value="The identifier of the component"/>
        <expression value="DeviceComponent.identifier"/>
        <xpath value="f:DeviceComponent/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DeviceComponent-parent"/>
    <resource>
      <SearchParameter>
        <id value="DeviceComponent-parent"/>
        <url value="http://hl7.org/fhir/SearchParameter/DeviceComponent-parent"/>
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
        <base value="DeviceComponent"/>
        <type value="reference"/>
        <description value="The parent DeviceComponent resource"/>
        <expression value="DeviceComponent.parent"/>
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
        <base value="DeviceComponent"/>
        <type value="reference"/>
        <description value="The device source"/>
        <expression value="DeviceComponent.source"/>
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
        <base value="DeviceComponent"/>
        <type value="token"/>
        <description value="The device component type"/>
        <expression value="DeviceComponent.type"/>
        <xpath value="f:DeviceComponent/f:type"/>
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
