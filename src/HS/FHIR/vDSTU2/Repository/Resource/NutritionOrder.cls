Class HS.FHIR.vDSTU2.Repository.Resource.NutritionOrder Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-NutritionOrder"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/NutritionOrder-additive"/>
    <resource>
      <SearchParameter>
        <id value="NutritionOrder-additive"/>
        <url value="http://hl7.org/fhir/SearchParameter/NutritionOrder-additive"/>
        <name value="additive"/>
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
        <code value="additive"/>
        <base value="NutritionOrder"/>
        <type value="token"/>
        <description value="Type of module component to add to the feeding"/>
        <xpath value="f:NutritionOrder/f:enteralFormula/f:additiveType"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/NutritionOrder-datetime"/>
    <resource>
      <SearchParameter>
        <id value="NutritionOrder-datetime"/>
        <url value="http://hl7.org/fhir/SearchParameter/NutritionOrder-datetime"/>
        <name value="datetime"/>
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
        <code value="datetime"/>
        <base value="NutritionOrder"/>
        <type value="date"/>
        <description value="Return nutrition orders requested on this date"/>
        <xpath value="f:NutritionOrder/f:dateTime"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/NutritionOrder-encounter"/>
    <resource>
      <SearchParameter>
        <id value="NutritionOrder-encounter"/>
        <url value="http://hl7.org/fhir/SearchParameter/NutritionOrder-encounter"/>
        <name value="encounter"/>
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
        <code value="encounter"/>
        <base value="NutritionOrder"/>
        <type value="reference"/>
        <description value="Return nutrition orders with this encounter identifier"/>
        <xpath value="f:NutritionOrder/f:encounter"/>
        <xpathUsage value="normal"/>
        <target value="Encounter"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/NutritionOrder-formula"/>
    <resource>
      <SearchParameter>
        <id value="NutritionOrder-formula"/>
        <url value="http://hl7.org/fhir/SearchParameter/NutritionOrder-formula"/>
        <name value="formula"/>
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
        <code value="formula"/>
        <base value="NutritionOrder"/>
        <type value="token"/>
        <description value="Type of enteral or infant formula"/>
        <xpath value="f:NutritionOrder/f:enteralFormula/f:baseFormulaType"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/NutritionOrder-identifier"/>
    <resource>
      <SearchParameter>
        <id value="NutritionOrder-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/NutritionOrder-identifier"/>
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
        <base value="NutritionOrder"/>
        <type value="token"/>
        <description value="Return nutrition orders with this external identifier"/>
        <xpath value="f:NutritionOrder/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/NutritionOrder-oraldiet"/>
    <resource>
      <SearchParameter>
        <id value="NutritionOrder-oraldiet"/>
        <url value="http://hl7.org/fhir/SearchParameter/NutritionOrder-oraldiet"/>
        <name value="oraldiet"/>
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
        <code value="oraldiet"/>
        <base value="NutritionOrder"/>
        <type value="token"/>
        <description value="Type of diet that can be consumed orally (i.e., take via the mouth)."/>
        <xpath value="f:NutritionOrder/f:oralDiet/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/NutritionOrder-patient"/>
    <resource>
      <SearchParameter>
        <id value="NutritionOrder-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/NutritionOrder-patient"/>
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
        <base value="NutritionOrder"/>
        <type value="reference"/>
        <description value="The identity of the person who requires the diet, formula or nutritional supplement"/>
        <xpath value="f:NutritionOrder/f:patient"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/NutritionOrder-provider"/>
    <resource>
      <SearchParameter>
        <id value="NutritionOrder-provider"/>
        <url value="http://hl7.org/fhir/SearchParameter/NutritionOrder-provider"/>
        <name value="provider"/>
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
        <code value="provider"/>
        <base value="NutritionOrder"/>
        <type value="reference"/>
        <description value="The identify of the provider who placed the nutrition order"/>
        <xpath value="f:NutritionOrder/f:orderer"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/NutritionOrder-status"/>
    <resource>
      <SearchParameter>
        <id value="NutritionOrder-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/NutritionOrder-status"/>
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
        <base value="NutritionOrder"/>
        <type value="token"/>
        <description value="Status of the nutrition order."/>
        <xpath value="f:NutritionOrder/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/NutritionOrder-supplement"/>
    <resource>
      <SearchParameter>
        <id value="NutritionOrder-supplement"/>
        <url value="http://hl7.org/fhir/SearchParameter/NutritionOrder-supplement"/>
        <name value="supplement"/>
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
        <code value="supplement"/>
        <base value="NutritionOrder"/>
        <type value="token"/>
        <description value="Type of supplement product requested"/>
        <xpath value="f:NutritionOrder/f:supplement/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
