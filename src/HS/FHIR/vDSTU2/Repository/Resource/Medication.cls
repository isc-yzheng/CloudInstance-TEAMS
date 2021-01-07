Class HS.FHIR.vDSTU2.Repository.Resource.Medication Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Medication"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Medication-code"/>
    <resource>
      <SearchParameter>
        <id value="Medication-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/Medication-code"/>
        <name value="code"/>
        <publisher value="Health Level Seven International (Pharmacy)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/medication/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="code"/>
        <base value="Medication"/>
        <type value="token"/>
        <description value="Codes that identify this medication"/>
        <xpath value="f:Medication/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Medication-container"/>
    <resource>
      <SearchParameter>
        <id value="Medication-container"/>
        <url value="http://hl7.org/fhir/SearchParameter/Medication-container"/>
        <name value="container"/>
        <publisher value="Health Level Seven International (Pharmacy)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/medication/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="container"/>
        <base value="Medication"/>
        <type value="token"/>
        <description value="E.g. box, vial, blister-pack"/>
        <xpath value="f:Medication/f:package/f:container"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Medication-content"/>
    <resource>
      <SearchParameter>
        <id value="Medication-content"/>
        <url value="http://hl7.org/fhir/SearchParameter/Medication-content"/>
        <name value="content"/>
        <publisher value="Health Level Seven International (Pharmacy)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/medication/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="content"/>
        <base value="Medication"/>
        <type value="reference"/>
        <description value="A product in the package"/>
        <xpath value="f:Medication/f:package/f:content/f:item"/>
        <xpathUsage value="normal"/>
        <target value="Medication"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Medication-form"/>
    <resource>
      <SearchParameter>
        <id value="Medication-form"/>
        <url value="http://hl7.org/fhir/SearchParameter/Medication-form"/>
        <name value="form"/>
        <publisher value="Health Level Seven International (Pharmacy)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/medication/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="form"/>
        <base value="Medication"/>
        <type value="token"/>
        <description value="powder | tablets | carton +"/>
        <xpath value="f:Medication/f:product/f:form"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Medication-ingredient"/>
    <resource>
      <SearchParameter>
        <id value="Medication-ingredient"/>
        <url value="http://hl7.org/fhir/SearchParameter/Medication-ingredient"/>
        <name value="ingredient"/>
        <publisher value="Health Level Seven International (Pharmacy)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/medication/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="ingredient"/>
        <base value="Medication"/>
        <type value="reference"/>
        <description value="The product contained"/>
        <xpath value="f:Medication/f:product/f:ingredient/f:item"/>
        <xpathUsage value="normal"/>
        <target value="Medication"/>
        <target value="Substance"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Medication-manufacturer"/>
    <resource>
      <SearchParameter>
        <id value="Medication-manufacturer"/>
        <url value="http://hl7.org/fhir/SearchParameter/Medication-manufacturer"/>
        <name value="manufacturer"/>
        <publisher value="Health Level Seven International (Pharmacy)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/medication/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="manufacturer"/>
        <base value="Medication"/>
        <type value="reference"/>
        <description value="Manufacturer of the item"/>
        <xpath value="f:Medication/f:manufacturer"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
