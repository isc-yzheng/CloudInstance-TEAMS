Class HS.FHIR.vSTU3.Repository.Resource.Medication Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Medication"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/medications-code"/>
    <resource>
      <SearchParameter>
        <id value="medications-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/medications-code"/>
        <name value="code"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Pharmacy)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/medication/index.cfm"/>
          </telecom>
        </contact>
        <code value="code"/>
        <base value="Medication"/>
        <base value="MedicationRequest"/>
        <base value="MedicationAdministration"/>
        <base value="MedicationStatement"/>
        <base value="MedicationDispense"/>
        <type value="token"/>
        <description value="Multiple Resources: 

* [Medication](medication.html): Codes that identify this medication
* [MedicationRequest](medicationrequest.html): Return prescriptions of this medication code
* [MedicationAdministration](medicationadministration.html): Return administrations of this medication code
* [MedicationStatement](medicationstatement.html): Return statements of this medication code
* [MedicationDispense](medicationdispense.html): Return dispenses of this medicine code
"/>
        <expression value="Medication.code | MedicationRequest.medication.as(CodeableConcept) | MedicationAdministration.medication.as(CodeableConcept) | MedicationStatement.medication.as(CodeableConcept) | MedicationDispense.medication.as(CodeableConcept)"/>
        <xpath value="f:Medication/f:code | f:MedicationRequest/f:medicationCodeableConcept | f:MedicationAdministration/f:medicationCodeableConcept | f:MedicationStatement/f:medicationCodeableConcept | f:MedicationDispense/f:medicationCodeableConcept"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Pharmacy)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/medication/index.cfm"/>
          </telecom>
        </contact>
        <code value="container"/>
        <base value="Medication"/>
        <type value="token"/>
        <description value="E.g. box, vial, blister-pack"/>
        <expression value="Medication.package.container"/>
        <xpath value="f:Medication/f:package/f:container"/>
        <xpathUsage value="normal"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Pharmacy)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/medication/index.cfm"/>
          </telecom>
        </contact>
        <code value="form"/>
        <base value="Medication"/>
        <type value="token"/>
        <description value="powder | tablets | capsule +"/>
        <expression value="Medication.form"/>
        <xpath value="f:Medication/f:form"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Pharmacy)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/medication/index.cfm"/>
          </telecom>
        </contact>
        <code value="ingredient"/>
        <base value="Medication"/>
        <type value="reference"/>
        <description value="The product contained"/>
        <expression value="Medication.ingredient.item.as(Reference)"/>
        <xpath value="f:Medication/f:ingredient/f:itemReference"/>
        <xpathUsage value="normal"/>
        <target value="Medication"/>
        <target value="Substance"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Medication-ingredient-code"/>
    <resource>
      <SearchParameter>
        <id value="Medication-ingredient-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/Medication-ingredient-code"/>
        <name value="ingredient-code"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Pharmacy)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/medication/index.cfm"/>
          </telecom>
        </contact>
        <code value="ingredient-code"/>
        <base value="Medication"/>
        <type value="token"/>
        <description value="The product contained"/>
        <expression value="Medication.ingredient.item.as(CodeableConcept)"/>
        <xpath value="f:Medication/f:ingredient/f:itemCodeableConcept"/>
        <xpathUsage value="normal"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Pharmacy)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/medication/index.cfm"/>
          </telecom>
        </contact>
        <code value="manufacturer"/>
        <base value="Medication"/>
        <type value="reference"/>
        <description value="Manufacturer of the item"/>
        <expression value="Medication.manufacturer"/>
        <xpath value="f:Medication/f:manufacturer"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Medication-over-the-counter"/>
    <resource>
      <SearchParameter>
        <id value="Medication-over-the-counter"/>
        <url value="http://hl7.org/fhir/SearchParameter/Medication-over-the-counter"/>
        <name value="over-the-counter"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Pharmacy)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/medication/index.cfm"/>
          </telecom>
        </contact>
        <code value="over-the-counter"/>
        <base value="Medication"/>
        <type value="token"/>
        <description value="True if medication does not require a prescription"/>
        <expression value="Medication.isOverTheCounter"/>
        <xpath value="f:Medication/f:isOverTheCounter"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Medication-package-item"/>
    <resource>
      <SearchParameter>
        <id value="Medication-package-item"/>
        <url value="http://hl7.org/fhir/SearchParameter/Medication-package-item"/>
        <name value="package-item"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Pharmacy)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/medication/index.cfm"/>
          </telecom>
        </contact>
        <code value="package-item"/>
        <base value="Medication"/>
        <type value="reference"/>
        <description value="The item in the package"/>
        <expression value="Medication.package.content.item.as(Reference)"/>
        <xpath value="f:Medication/f:package/f:content/f:itemReference"/>
        <xpathUsage value="normal"/>
        <target value="Medication"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Medication-package-item-code"/>
    <resource>
      <SearchParameter>
        <id value="Medication-package-item-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/Medication-package-item-code"/>
        <name value="package-item-code"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Pharmacy)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/medication/index.cfm"/>
          </telecom>
        </contact>
        <code value="package-item-code"/>
        <base value="Medication"/>
        <type value="token"/>
        <description value="The item in the package"/>
        <expression value="Medication.package.content.item.as(CodeableConcept)"/>
        <xpath value="f:Medication/f:package/f:content/f:itemCodeableConcept"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Medication-status"/>
    <resource>
      <SearchParameter>
        <id value="Medication-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/Medication-status"/>
        <name value="status"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Pharmacy)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/medication/index.cfm"/>
          </telecom>
        </contact>
        <code value="status"/>
        <base value="Medication"/>
        <type value="token"/>
        <description value="active | inactive | entered-in-error"/>
        <expression value="Medication.status"/>
        <xpath value="f:Medication/f:status"/>
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
