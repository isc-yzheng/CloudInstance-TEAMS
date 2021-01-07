Class HS.FHIR.vDSTU2.Repository.Resource.MedicationOrder Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-MedicationOrder"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationOrder-code"/>
    <resource>
      <SearchParameter>
        <id value="MedicationOrder-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationOrder-code"/>
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
        <base value="MedicationOrder"/>
        <type value="token"/>
        <description value="Return administrations of this medication code"/>
        <xpath value="f:MedicationOrder/f:medicationCodeableConcept"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationOrder-datewritten"/>
    <resource>
      <SearchParameter>
        <id value="MedicationOrder-datewritten"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationOrder-datewritten"/>
        <name value="datewritten"/>
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
        <code value="datewritten"/>
        <base value="MedicationOrder"/>
        <type value="date"/>
        <description value="Return prescriptions written on this date"/>
        <xpath value="f:MedicationOrder/f:dateWritten"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationOrder-encounter"/>
    <resource>
      <SearchParameter>
        <id value="MedicationOrder-encounter"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationOrder-encounter"/>
        <name value="encounter"/>
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
        <code value="encounter"/>
        <base value="MedicationOrder"/>
        <type value="reference"/>
        <description value="Return prescriptions with this encounter identifier"/>
        <xpath value="f:MedicationOrder/f:encounter"/>
        <xpathUsage value="normal"/>
        <target value="Encounter"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationOrder-identifier"/>
    <resource>
      <SearchParameter>
        <id value="MedicationOrder-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationOrder-identifier"/>
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
        <base value="MedicationOrder"/>
        <type value="token"/>
        <description value="Return prescriptions with this external identifier"/>
        <xpath value="f:MedicationOrder/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationOrder-medication"/>
    <resource>
      <SearchParameter>
        <id value="MedicationOrder-medication"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationOrder-medication"/>
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
        <base value="MedicationOrder"/>
        <type value="reference"/>
        <description value="Return administrations of this medication reference"/>
        <xpath value="f:MedicationOrder/f:medicationReference"/>
        <xpathUsage value="normal"/>
        <target value="Medication"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationOrder-patient"/>
    <resource>
      <SearchParameter>
        <id value="MedicationOrder-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationOrder-patient"/>
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
        <base value="MedicationOrder"/>
        <type value="reference"/>
        <description value="The identity of a patient to list orders  for"/>
        <xpath value="f:MedicationOrder/f:patient"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationOrder-prescriber"/>
    <resource>
      <SearchParameter>
        <id value="MedicationOrder-prescriber"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationOrder-prescriber"/>
        <name value="prescriber"/>
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
        <code value="prescriber"/>
        <base value="MedicationOrder"/>
        <type value="reference"/>
        <description value="Who ordered the medication(s)"/>
        <xpath value="f:MedicationOrder/f:prescriber"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationOrder-status"/>
    <resource>
      <SearchParameter>
        <id value="MedicationOrder-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationOrder-status"/>
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
        <base value="MedicationOrder"/>
        <type value="token"/>
        <description value="Status of the prescription"/>
        <xpath value="f:MedicationOrder/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
