Class HS.FHIR.vDSTU2.Repository.Resource.Substance Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Substance"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Substance-category"/>
    <resource>
      <SearchParameter>
        <id value="Substance-category"/>
        <url value="http://hl7.org/fhir/SearchParameter/Substance-category"/>
        <name value="category"/>
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
        <code value="category"/>
        <base value="Substance"/>
        <type value="token"/>
        <description value="The category of the substance"/>
        <xpath value="f:Substance/f:category"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Substance-code"/>
    <resource>
      <SearchParameter>
        <id value="Substance-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/Substance-code"/>
        <name value="code"/>
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
        <code value="code"/>
        <base value="Substance"/>
        <type value="token"/>
        <description value="The code of the substance"/>
        <xpath value="f:Substance/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Substance-container-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Substance-container-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Substance-container-identifier"/>
        <name value="container-identifier"/>
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
        <code value="container-identifier"/>
        <base value="Substance"/>
        <type value="token"/>
        <description value="Identifier of the package/container"/>
        <xpath value="f:Substance/f:instance/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Substance-expiry"/>
    <resource>
      <SearchParameter>
        <id value="Substance-expiry"/>
        <url value="http://hl7.org/fhir/SearchParameter/Substance-expiry"/>
        <name value="expiry"/>
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
        <code value="expiry"/>
        <base value="Substance"/>
        <type value="date"/>
        <description value="Expiry date of package or container of substance"/>
        <xpath value="f:Substance/f:instance/f:expiry"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Substance-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Substance-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Substance-identifier"/>
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
        <base value="Substance"/>
        <type value="token"/>
        <description value="Unique identifier for the substance"/>
        <xpath value="f:Substance/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Substance-quantity"/>
    <resource>
      <SearchParameter>
        <id value="Substance-quantity"/>
        <url value="http://hl7.org/fhir/SearchParameter/Substance-quantity"/>
        <name value="quantity"/>
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
        <code value="quantity"/>
        <base value="Substance"/>
        <type value="quantity"/>
        <description value="Amount of substance in the package"/>
        <xpath value="f:Substance/f:instance/f:quantity"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Substance-substance"/>
    <resource>
      <SearchParameter>
        <id value="Substance-substance"/>
        <url value="http://hl7.org/fhir/SearchParameter/Substance-substance"/>
        <name value="substance"/>
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
        <code value="substance"/>
        <base value="Substance"/>
        <type value="reference"/>
        <description value="A component of the substance"/>
        <xpath value="f:Substance/f:ingredient/f:substance"/>
        <xpathUsage value="normal"/>
        <target value="Substance"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
