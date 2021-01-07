Class HS.FHIR.vDSTU2.Repository.Resource.SupplyRequest Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-SupplyRequest"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/SupplyRequest-date"/>
    <resource>
      <SearchParameter>
        <id value="SupplyRequest-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/SupplyRequest-date"/>
        <name value="date"/>
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
        <code value="date"/>
        <base value="SupplyRequest"/>
        <type value="date"/>
        <description value="When the request was made"/>
        <xpath value="f:SupplyRequest/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/SupplyRequest-identifier"/>
    <resource>
      <SearchParameter>
        <id value="SupplyRequest-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/SupplyRequest-identifier"/>
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
        <base value="SupplyRequest"/>
        <type value="token"/>
        <description value="Unique identifier"/>
        <xpath value="f:SupplyRequest/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/SupplyRequest-kind"/>
    <resource>
      <SearchParameter>
        <id value="SupplyRequest-kind"/>
        <url value="http://hl7.org/fhir/SearchParameter/SupplyRequest-kind"/>
        <name value="kind"/>
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
        <code value="kind"/>
        <base value="SupplyRequest"/>
        <type value="token"/>
        <description value="The kind of supply (central, non-stock, etc.)"/>
        <xpath value="f:SupplyRequest/f:kind"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/SupplyRequest-patient"/>
    <resource>
      <SearchParameter>
        <id value="SupplyRequest-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/SupplyRequest-patient"/>
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
        <base value="SupplyRequest"/>
        <type value="reference"/>
        <description value="Patient for whom the item is supplied"/>
        <xpath value="f:SupplyRequest/f:patient"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/SupplyRequest-source"/>
    <resource>
      <SearchParameter>
        <id value="SupplyRequest-source"/>
        <url value="http://hl7.org/fhir/SearchParameter/SupplyRequest-source"/>
        <name value="source"/>
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
        <code value="source"/>
        <base value="SupplyRequest"/>
        <type value="reference"/>
        <description value="Who initiated this order"/>
        <xpath value="f:SupplyRequest/f:source"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
        <target value="Organization"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/SupplyRequest-status"/>
    <resource>
      <SearchParameter>
        <id value="SupplyRequest-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/SupplyRequest-status"/>
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
        <base value="SupplyRequest"/>
        <type value="token"/>
        <description value="requested | completed | failed | cancelled"/>
        <xpath value="f:SupplyRequest/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/SupplyRequest-supplier"/>
    <resource>
      <SearchParameter>
        <id value="SupplyRequest-supplier"/>
        <url value="http://hl7.org/fhir/SearchParameter/SupplyRequest-supplier"/>
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
        <base value="SupplyRequest"/>
        <type value="reference"/>
        <description value="Who is intended to fulfill the request"/>
        <xpath value="f:SupplyRequest/f:supplier"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
