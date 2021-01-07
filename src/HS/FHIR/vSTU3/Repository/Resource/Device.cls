Class HS.FHIR.vSTU3.Repository.Resource.Device Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Device"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Device-device-name"/>
    <resource>
      <SearchParameter>
        <id value="Device-device-name"/>
        <url value="http://hl7.org/fhir/SearchParameter/Device-device-name"/>
        <name value="device-name"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="device-name"/>
        <base value="Device"/>
        <type value="string"/>
        <description value="A server defined search that may match any of the string fields in the Device.udi.name  or Device.type.coding.display or  Device.type.text"/>
        <expression value="Device.udi.name | Device.type.text | Device.type.coding.display"/>
        <xpath value="f:Device/f:udi/f:name | f:Device/f:type/f:text | f:Device/f:type/f:coding/f:display"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Device-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Device-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Device-identifier"/>
        <name value="identifier"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="identifier"/>
        <base value="Device"/>
        <type value="token"/>
        <description value="Instance id from manufacturer, owner, and others"/>
        <expression value="Device.identifier"/>
        <xpath value="f:Device/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Device-location"/>
    <resource>
      <SearchParameter>
        <id value="Device-location"/>
        <url value="http://hl7.org/fhir/SearchParameter/Device-location"/>
        <name value="location"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="location"/>
        <base value="Device"/>
        <type value="reference"/>
        <description value="A location, where the resource is found"/>
        <expression value="Device.location"/>
        <xpath value="f:Device/f:location"/>
        <xpathUsage value="normal"/>
        <target value="Location"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Device-manufacturer"/>
    <resource>
      <SearchParameter>
        <id value="Device-manufacturer"/>
        <url value="http://hl7.org/fhir/SearchParameter/Device-manufacturer"/>
        <name value="manufacturer"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="manufacturer"/>
        <base value="Device"/>
        <type value="string"/>
        <description value="The manufacturer of the device"/>
        <expression value="Device.manufacturer"/>
        <xpath value="f:Device/f:manufacturer"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Device-model"/>
    <resource>
      <SearchParameter>
        <id value="Device-model"/>
        <url value="http://hl7.org/fhir/SearchParameter/Device-model"/>
        <name value="model"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="model"/>
        <base value="Device"/>
        <type value="string"/>
        <description value="The model of the device"/>
        <expression value="Device.model"/>
        <xpath value="f:Device/f:model"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Device-organization"/>
    <resource>
      <SearchParameter>
        <id value="Device-organization"/>
        <url value="http://hl7.org/fhir/SearchParameter/Device-organization"/>
        <name value="organization"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="organization"/>
        <base value="Device"/>
        <type value="reference"/>
        <description value="The organization responsible for the device"/>
        <expression value="Device.owner"/>
        <xpath value="f:Device/f:owner"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Device-patient"/>
    <resource>
      <SearchParameter>
        <id value="Device-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/Device-patient"/>
        <name value="patient"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="patient"/>
        <base value="Device"/>
        <type value="reference"/>
        <description value="Patient information, if the resource is affixed to a person"/>
        <expression value="Device.patient"/>
        <xpath value="f:Device/f:patient"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Device-status"/>
    <resource>
      <SearchParameter>
        <id value="Device-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/Device-status"/>
        <name value="status"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="status"/>
        <base value="Device"/>
        <type value="token"/>
        <description value="active | inactive | entered-in-error | unknown"/>
        <expression value="Device.status"/>
        <xpath value="f:Device/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Device-type"/>
    <resource>
      <SearchParameter>
        <id value="Device-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/Device-type"/>
        <name value="type"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="type"/>
        <base value="Device"/>
        <type value="token"/>
        <description value="The type of the device"/>
        <expression value="Device.type"/>
        <xpath value="f:Device/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Device-udi-carrier"/>
    <resource>
      <SearchParameter>
        <id value="Device-udi-carrier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Device-udi-carrier"/>
        <name value="udi-carrier"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="udi-carrier"/>
        <base value="Device"/>
        <type value="string"/>
        <description value="UDI Barcode (RFID or other technology) string either in HRF format or AIDC format converted to base64 string."/>
        <expression value="Device.udi.carrierHRF | Device.udi.carrierAIDC"/>
        <xpath value="f:Device/f:udi/f:carrierHRF | f:Device/f:udi/f:carrierAIDC"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Device-udi-di"/>
    <resource>
      <SearchParameter>
        <id value="Device-udi-di"/>
        <url value="http://hl7.org/fhir/SearchParameter/Device-udi-di"/>
        <name value="udi-di"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="udi-di"/>
        <base value="Device"/>
        <type value="string"/>
        <description value="The udi Device Identifier (DI)"/>
        <expression value="Device.udi.deviceIdentifier"/>
        <xpath value="f:Device/f:udi/f:deviceIdentifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Device-url"/>
    <resource>
      <SearchParameter>
        <id value="Device-url"/>
        <url value="http://hl7.org/fhir/SearchParameter/Device-url"/>
        <name value="url"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="url"/>
        <base value="Device"/>
        <type value="uri"/>
        <description value="Network address to contact device"/>
        <expression value="Device.url"/>
        <xpath value="f:Device/f:url"/>
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
