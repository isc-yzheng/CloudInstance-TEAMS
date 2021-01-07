Class HS.FHIR.vDSTU2.Repository.Resource.SupplyDelivery Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-SupplyDelivery"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/SupplyDelivery-identifier"/>
    <resource>
      <SearchParameter>
        <id value="SupplyDelivery-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/SupplyDelivery-identifier"/>
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
        <base value="SupplyDelivery"/>
        <type value="token"/>
        <description value="External identifier"/>
        <xpath value="f:SupplyDelivery/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/SupplyDelivery-patient"/>
    <resource>
      <SearchParameter>
        <id value="SupplyDelivery-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/SupplyDelivery-patient"/>
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
        <base value="SupplyDelivery"/>
        <type value="reference"/>
        <description value="Patient for whom the item is supplied"/>
        <xpath value="f:SupplyDelivery/f:patient"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/SupplyDelivery-receiver"/>
    <resource>
      <SearchParameter>
        <id value="SupplyDelivery-receiver"/>
        <url value="http://hl7.org/fhir/SearchParameter/SupplyDelivery-receiver"/>
        <name value="receiver"/>
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
        <code value="receiver"/>
        <base value="SupplyDelivery"/>
        <type value="reference"/>
        <description value="Who collected the Supply"/>
        <xpath value="f:SupplyDelivery/f:receiver"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/SupplyDelivery-status"/>
    <resource>
      <SearchParameter>
        <id value="SupplyDelivery-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/SupplyDelivery-status"/>
        <name value="status"/>
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
        <code value="status"/>
        <base value="SupplyDelivery"/>
        <type value="token"/>
        <description value="in-progress | completed | abandoned"/>
        <xpath value="f:SupplyDelivery/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/SupplyDelivery-supplier"/>
    <resource>
      <SearchParameter>
        <id value="SupplyDelivery-supplier"/>
        <url value="http://hl7.org/fhir/SearchParameter/SupplyDelivery-supplier"/>
        <name value="supplier"/>
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
        <code value="supplier"/>
        <base value="SupplyDelivery"/>
        <type value="reference"/>
        <description value="Dispenser"/>
        <xpath value="f:SupplyDelivery/f:supplier"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
