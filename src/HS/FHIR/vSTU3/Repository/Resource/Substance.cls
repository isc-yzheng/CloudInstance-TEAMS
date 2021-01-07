Class HS.FHIR.vSTU3.Repository.Resource.Substance Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Substance"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Substance-category"/>
    <resource>
      <SearchParameter>
        <id value="Substance-category"/>
        <url value="http://hl7.org/fhir/SearchParameter/Substance-category"/>
        <name value="category"/>
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
        <code value="category"/>
        <base value="Substance"/>
        <type value="token"/>
        <description value="The category of the substance"/>
        <expression value="Substance.category"/>
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
        <code value="code"/>
        <base value="Substance"/>
        <type value="token"/>
        <description value="The code of the substance or ingredient"/>
        <expression value="Substance.code | Substance.ingredient.substance.as(CodeableConcept)"/>
        <xpath value="f:Substance/f:code | f:Substance/f:ingredient/f:substanceCodeableConcept"/>
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
        <code value="container-identifier"/>
        <base value="Substance"/>
        <type value="token"/>
        <description value="Identifier of the package/container"/>
        <expression value="Substance.instance.identifier"/>
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
        <code value="expiry"/>
        <base value="Substance"/>
        <type value="date"/>
        <description value="Expiry date of package or container of substance"/>
        <expression value="Substance.instance.expiry"/>
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
        <base value="Substance"/>
        <type value="token"/>
        <description value="Unique identifier for the substance"/>
        <expression value="Substance.identifier"/>
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
        <code value="quantity"/>
        <base value="Substance"/>
        <type value="quantity"/>
        <description value="Amount of substance in the package"/>
        <expression value="Substance.instance.quantity"/>
        <xpath value="f:Substance/f:instance/f:quantity"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Substance-status"/>
    <resource>
      <SearchParameter>
        <id value="Substance-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/Substance-status"/>
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
        <base value="Substance"/>
        <type value="token"/>
        <description value="active | inactive | entered-in-error"/>
        <expression value="Substance.status"/>
        <xpath value="f:Substance/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Substance-substance-reference"/>
    <resource>
      <SearchParameter>
        <id value="Substance-substance-reference"/>
        <url value="http://hl7.org/fhir/SearchParameter/Substance-substance-reference"/>
        <name value="substance-reference"/>
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
        <code value="substance-reference"/>
        <base value="Substance"/>
        <type value="reference"/>
        <description value="A component of the substance"/>
        <expression value="Substance.ingredient.substance.as(Reference)"/>
        <xpath value="f:Substance/f:ingredient/f:substanceReference"/>
        <xpathUsage value="normal"/>
        <target value="Substance"/>
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
