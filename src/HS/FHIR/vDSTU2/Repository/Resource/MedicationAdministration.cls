Class HS.FHIR.vDSTU2.Repository.Resource.MedicationAdministration Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-MedicationAdministration"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-code"/>
    <resource>
      <SearchParameter>
        <id value="MedicationAdministration-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-code"/>
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
        <base value="MedicationAdministration"/>
        <type value="token"/>
        <description value="Return administrations of this medication code"/>
        <xpath value="f:MedicationAdministration/f:medicationCodeableConcept"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-device"/>
    <resource>
      <SearchParameter>
        <id value="MedicationAdministration-device"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-device"/>
        <name value="device"/>
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
        <code value="device"/>
        <base value="MedicationAdministration"/>
        <type value="reference"/>
        <description value="Return administrations with this administration device identity"/>
        <xpath value="f:MedicationAdministration/f:device"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-effectivetime"/>
    <resource>
      <SearchParameter>
        <id value="MedicationAdministration-effectivetime"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-effectivetime"/>
        <name value="effectivetime"/>
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
        <code value="effectivetime"/>
        <base value="MedicationAdministration"/>
        <type value="date"/>
        <description value="Date administration happened (or did not happen)"/>
        <xpath value="f:MedicationAdministration/f:effectiveTimeDateTime | f:MedicationAdministration/f:effectiveTimePeriod"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-encounter"/>
    <resource>
      <SearchParameter>
        <id value="MedicationAdministration-encounter"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-encounter"/>
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
        <base value="MedicationAdministration"/>
        <type value="reference"/>
        <description value="Return administrations that share this encounter"/>
        <xpath value="f:MedicationAdministration/f:encounter"/>
        <xpathUsage value="normal"/>
        <target value="Encounter"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-identifier"/>
    <resource>
      <SearchParameter>
        <id value="MedicationAdministration-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-identifier"/>
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
        <base value="MedicationAdministration"/>
        <type value="token"/>
        <description value="Return administrations with this external identifier"/>
        <xpath value="f:MedicationAdministration/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-medication"/>
    <resource>
      <SearchParameter>
        <id value="MedicationAdministration-medication"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-medication"/>
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
        <base value="MedicationAdministration"/>
        <type value="reference"/>
        <description value="Return administrations of this medication resource"/>
        <xpath value="f:MedicationAdministration/f:medicationReference"/>
        <xpathUsage value="normal"/>
        <target value="Medication"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-notgiven"/>
    <resource>
      <SearchParameter>
        <id value="MedicationAdministration-notgiven"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-notgiven"/>
        <name value="notgiven"/>
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
        <code value="notgiven"/>
        <base value="MedicationAdministration"/>
        <type value="token"/>
        <description value="Administrations that were not made"/>
        <xpath value="f:MedicationAdministration/f:wasNotGiven"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-patient"/>
    <resource>
      <SearchParameter>
        <id value="MedicationAdministration-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-patient"/>
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
        <base value="MedicationAdministration"/>
        <type value="reference"/>
        <description value="The identity of a patient to list administrations  for"/>
        <xpath value="f:MedicationAdministration/f:patient"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-practitioner"/>
    <resource>
      <SearchParameter>
        <id value="MedicationAdministration-practitioner"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-practitioner"/>
        <name value="practitioner"/>
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
        <code value="practitioner"/>
        <base value="MedicationAdministration"/>
        <type value="reference"/>
        <description value="Who administered substance"/>
        <xpath value="f:MedicationAdministration/f:practitioner"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
        <target value="Practitioner"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-prescription"/>
    <resource>
      <SearchParameter>
        <id value="MedicationAdministration-prescription"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-prescription"/>
        <name value="prescription"/>
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
        <code value="prescription"/>
        <base value="MedicationAdministration"/>
        <type value="reference"/>
        <description value="The identity of a prescription to list administrations from"/>
        <xpath value="f:MedicationAdministration/f:prescription"/>
        <xpathUsage value="normal"/>
        <target value="MedicationOrder"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-status"/>
    <resource>
      <SearchParameter>
        <id value="MedicationAdministration-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-status"/>
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
        <base value="MedicationAdministration"/>
        <type value="token"/>
        <description value="MedicationAdministration event status (for example one of active/paused/completed/nullified)"/>
        <xpath value="f:MedicationAdministration/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
