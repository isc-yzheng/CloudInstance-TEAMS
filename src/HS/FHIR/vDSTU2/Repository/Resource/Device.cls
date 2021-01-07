Class HS.FHIR.vDSTU2.Repository.Resource.Device Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Device"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Device-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Device-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Device-identifier"/>
        <name value="identifier"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="identifier"/>
        <base value="Device"/>
        <type value="token"/>
        <description value="Instance id from manufacturer, owner, and others"/>
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
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="location"/>
        <base value="Device"/>
        <type value="reference"/>
        <description value="A location, where the resource is found"/>
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
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="manufacturer"/>
        <base value="Device"/>
        <type value="string"/>
        <description value="The manufacturer of the device"/>
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
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="model"/>
        <base value="Device"/>
        <type value="string"/>
        <description value="The model of the device"/>
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
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="organization"/>
        <base value="Device"/>
        <type value="reference"/>
        <description value="The organization responsible for the device"/>
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
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="patient"/>
        <base value="Device"/>
        <type value="reference"/>
        <description value="Patient information, if the resource is affixed to a person"/>
        <xpath value="f:Device/f:patient"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
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
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="type"/>
        <base value="Device"/>
        <type value="token"/>
        <description value="The type of the device"/>
        <xpath value="f:Device/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Device-udi"/>
    <resource>
      <SearchParameter>
        <id value="Device-udi"/>
        <url value="http://hl7.org/fhir/SearchParameter/Device-udi"/>
        <name value="udi"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="udi"/>
        <base value="Device"/>
        <type value="string"/>
        <description value="FDA mandated Unique Device Identifier"/>
        <xpath value="f:Device/f:udi"/>
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
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="url"/>
        <base value="Device"/>
        <type value="uri"/>
        <description value="Network address to contact device"/>
        <xpath value="f:Device/f:url"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
