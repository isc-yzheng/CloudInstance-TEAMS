Class HS.FHIR.vDSTU2.Repository.Resource.MedicationDispense Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-MedicationDispense"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationDispense-code"/>
    <resource>
      <SearchParameter>
        <id value="MedicationDispense-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationDispense-code"/>
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
        <base value="MedicationDispense"/>
        <type value="token"/>
        <description value="Return dispenses of this medicine code"/>
        <xpath value="f:MedicationDispense/f:medicationCodeableConcept"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationDispense-destination"/>
    <resource>
      <SearchParameter>
        <id value="MedicationDispense-destination"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationDispense-destination"/>
        <name value="destination"/>
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
        <code value="destination"/>
        <base value="MedicationDispense"/>
        <type value="reference"/>
        <description value="Return dispenses that should be sent to a specific destination"/>
        <xpath value="f:MedicationDispense/f:destination"/>
        <xpathUsage value="normal"/>
        <target value="Location"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationDispense-dispenser"/>
    <resource>
      <SearchParameter>
        <id value="MedicationDispense-dispenser"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationDispense-dispenser"/>
        <name value="dispenser"/>
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
        <code value="dispenser"/>
        <base value="MedicationDispense"/>
        <type value="reference"/>
        <description value="Return all dispenses performed by a specific individual"/>
        <xpath value="f:MedicationDispense/f:dispenser"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationDispense-identifier"/>
    <resource>
      <SearchParameter>
        <id value="MedicationDispense-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationDispense-identifier"/>
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
        <base value="MedicationDispense"/>
        <type value="token"/>
        <description value="Return dispenses with this external identifier"/>
        <xpath value="f:MedicationDispense/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationDispense-medication"/>
    <resource>
      <SearchParameter>
        <id value="MedicationDispense-medication"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationDispense-medication"/>
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
        <base value="MedicationDispense"/>
        <type value="reference"/>
        <description value="Return dispenses of this medicine resource"/>
        <xpath value="f:MedicationDispense/f:medicationReference"/>
        <xpathUsage value="normal"/>
        <target value="Medication"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationDispense-patient"/>
    <resource>
      <SearchParameter>
        <id value="MedicationDispense-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationDispense-patient"/>
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
        <base value="MedicationDispense"/>
        <type value="reference"/>
        <description value="The identity of a patient to list dispenses  for"/>
        <xpath value="f:MedicationDispense/f:patient"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationDispense-prescription"/>
    <resource>
      <SearchParameter>
        <id value="MedicationDispense-prescription"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationDispense-prescription"/>
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
        <base value="MedicationDispense"/>
        <type value="reference"/>
        <description value="The identity of a prescription to list dispenses from"/>
        <xpath value="f:MedicationDispense/f:authorizingPrescription"/>
        <xpathUsage value="normal"/>
        <target value="MedicationOrder"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationDispense-receiver"/>
    <resource>
      <SearchParameter>
        <id value="MedicationDispense-receiver"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationDispense-receiver"/>
        <name value="receiver"/>
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
        <code value="receiver"/>
        <base value="MedicationDispense"/>
        <type value="reference"/>
        <description value="Who collected the medication"/>
        <xpath value="f:MedicationDispense/f:receiver"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationDispense-responsibleparty"/>
    <resource>
      <SearchParameter>
        <id value="MedicationDispense-responsibleparty"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationDispense-responsibleparty"/>
        <name value="responsibleparty"/>
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
        <code value="responsibleparty"/>
        <base value="MedicationDispense"/>
        <type value="reference"/>
        <description value="Return all dispenses with the specified responsible party"/>
        <xpath value="f:MedicationDispense/f:substitution/f:responsibleParty"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationDispense-status"/>
    <resource>
      <SearchParameter>
        <id value="MedicationDispense-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationDispense-status"/>
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
        <base value="MedicationDispense"/>
        <type value="token"/>
        <description value="Status of the dispense"/>
        <xpath value="f:MedicationDispense/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationDispense-type"/>
    <resource>
      <SearchParameter>
        <id value="MedicationDispense-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationDispense-type"/>
        <name value="type"/>
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
        <code value="type"/>
        <base value="MedicationDispense"/>
        <type value="token"/>
        <description value="Return all dispenses of a specific type"/>
        <xpath value="f:MedicationDispense/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationDispense-whenhandedover"/>
    <resource>
      <SearchParameter>
        <id value="MedicationDispense-whenhandedover"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationDispense-whenhandedover"/>
        <name value="whenhandedover"/>
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
        <code value="whenhandedover"/>
        <base value="MedicationDispense"/>
        <type value="date"/>
        <description value="Date when medication handed over to patient (outpatient setting), or supplied to ward or clinic (inpatient setting)"/>
        <xpath value="f:MedicationDispense/f:whenHandedOver"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationDispense-whenprepared"/>
    <resource>
      <SearchParameter>
        <id value="MedicationDispense-whenprepared"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationDispense-whenprepared"/>
        <name value="whenprepared"/>
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
        <code value="whenprepared"/>
        <base value="MedicationDispense"/>
        <type value="date"/>
        <description value="Date when medication prepared"/>
        <xpath value="f:MedicationDispense/f:whenPrepared"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
