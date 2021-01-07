Class HS.FHIR.vDSTU2.Repository.Resource.MedicationStatement Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-MedicationStatement"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationStatement-code"/>
    <resource>
      <SearchParameter>
        <id value="MedicationStatement-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationStatement-code"/>
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
        <base value="MedicationStatement"/>
        <type value="token"/>
        <description value="Return administrations of this medication code"/>
        <xpath value="f:MedicationStatement/f:medicationCodeableConcept"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationStatement-effectivedate"/>
    <resource>
      <SearchParameter>
        <id value="MedicationStatement-effectivedate"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationStatement-effectivedate"/>
        <name value="effectivedate"/>
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
        <code value="effectivedate"/>
        <base value="MedicationStatement"/>
        <type value="date"/>
        <description value="Date when patient was taking (or not taking) the medication"/>
        <xpath value="f:MedicationStatement/f:effectiveDateTime | f:MedicationStatement/f:effectivePeriod"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationStatement-identifier"/>
    <resource>
      <SearchParameter>
        <id value="MedicationStatement-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationStatement-identifier"/>
        <name value="identifier"/>
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
        <code value="identifier"/>
        <base value="MedicationStatement"/>
        <type value="token"/>
        <description value="Return statements with this external identifier"/>
        <xpath value="f:MedicationStatement/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationStatement-medication"/>
    <resource>
      <SearchParameter>
        <id value="MedicationStatement-medication"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationStatement-medication"/>
        <name value="medication"/>
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
        <code value="medication"/>
        <base value="MedicationStatement"/>
        <type value="reference"/>
        <description value="Return administrations of this medication reference"/>
        <xpath value="f:MedicationStatement/f:medicationReference"/>
        <xpathUsage value="normal"/>
        <target value="Medication"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationStatement-patient"/>
    <resource>
      <SearchParameter>
        <id value="MedicationStatement-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationStatement-patient"/>
        <name value="patient"/>
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
        <code value="patient"/>
        <base value="MedicationStatement"/>
        <type value="reference"/>
        <description value="The identity of a patient to list statements  for"/>
        <xpath value="f:MedicationStatement/f:patient"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationStatement-source"/>
    <resource>
      <SearchParameter>
        <id value="MedicationStatement-source"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationStatement-source"/>
        <name value="source"/>
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
        <code value="source"/>
        <base value="MedicationStatement"/>
        <type value="reference"/>
        <description value="Who the information in the statement came from"/>
        <xpath value="f:MedicationStatement/f:informationSource"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
        <target value="Practitioner"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationStatement-status"/>
    <resource>
      <SearchParameter>
        <id value="MedicationStatement-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationStatement-status"/>
        <name value="status"/>
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
        <code value="status"/>
        <base value="MedicationStatement"/>
        <type value="token"/>
        <description value="Return statements that match the given status"/>
        <xpath value="f:MedicationStatement/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
