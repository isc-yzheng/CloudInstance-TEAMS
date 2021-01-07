Class HS.FHIR.vSTU3.Repository.Resource.MedicationAdministration Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-MedicationAdministration"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-context"/>
    <resource>
      <SearchParameter>
        <id value="MedicationAdministration-context"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-context"/>
        <name value="context"/>
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
        <code value="context"/>
        <base value="MedicationAdministration"/>
        <type value="reference"/>
        <description value="Return administrations that share this encounter or episode of care"/>
        <expression value="MedicationAdministration.context"/>
        <xpath value="f:MedicationAdministration/f:context"/>
        <xpathUsage value="normal"/>
        <target value="EpisodeOfCare"/>
        <target value="Encounter"/>
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
        <code value="device"/>
        <base value="MedicationAdministration"/>
        <type value="reference"/>
        <description value="Return administrations with this administration device identity"/>
        <expression value="MedicationAdministration.device"/>
        <xpath value="f:MedicationAdministration/f:device"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-effective-time"/>
    <resource>
      <SearchParameter>
        <id value="MedicationAdministration-effective-time"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-effective-time"/>
        <name value="effective-time"/>
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
        <code value="effective-time"/>
        <base value="MedicationAdministration"/>
        <type value="date"/>
        <description value="Date administration happened (or did not happen)"/>
        <expression value="MedicationAdministration.effective"/>
        <xpath value="f:MedicationAdministration/f:effectiveDateTime | f:MedicationAdministration/f:effectivePeriod"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/medications-identifier"/>
    <resource>
      <SearchParameter>
        <id value="medications-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/medications-identifier"/>
        <name value="identifier"/>
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
        <code value="identifier"/>
        <base value="MedicationRequest"/>
        <base value="MedicationAdministration"/>
        <base value="MedicationStatement"/>
        <base value="MedicationDispense"/>
        <type value="token"/>
        <description value="Multiple Resources: 

* [MedicationRequest](medicationrequest.html): Return prescriptions with this external identifier
* [MedicationAdministration](medicationadministration.html): Return administrations with this external identifier
* [MedicationStatement](medicationstatement.html): Return statements with this external identifier
* [MedicationDispense](medicationdispense.html): Return dispenses with this external identifier
"/>
        <expression value="MedicationRequest.identifier | MedicationAdministration.identifier | MedicationStatement.identifier | MedicationDispense.identifier"/>
        <xpath value="f:MedicationRequest/f:identifier | f:MedicationAdministration/f:identifier | f:MedicationStatement/f:identifier | f:MedicationDispense/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/medications-medication"/>
    <resource>
      <SearchParameter>
        <id value="medications-medication"/>
        <url value="http://hl7.org/fhir/SearchParameter/medications-medication"/>
        <name value="medication"/>
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
        <code value="medication"/>
        <base value="MedicationRequest"/>
        <base value="MedicationAdministration"/>
        <base value="MedicationStatement"/>
        <base value="MedicationDispense"/>
        <type value="reference"/>
        <description value="Multiple Resources: 

* [MedicationRequest](medicationrequest.html): Return prescriptions of this medication reference
* [MedicationAdministration](medicationadministration.html): Return administrations of this medication resource
* [MedicationStatement](medicationstatement.html): Return statements of this medication reference
* [MedicationDispense](medicationdispense.html): Return dispenses of this medicine resource
"/>
        <expression value="MedicationRequest.medication.as(Reference) | MedicationAdministration.medication.as(Reference) | MedicationStatement.medication.as(Reference) | MedicationDispense.medication.as(Reference)"/>
        <xpath value="f:MedicationRequest/f:medicationReference | f:MedicationAdministration/f:medicationReference | f:MedicationStatement/f:medicationReference | f:MedicationDispense/f:medicationReference"/>
        <xpathUsage value="normal"/>
        <target value="Medication"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-not-given"/>
    <resource>
      <SearchParameter>
        <id value="MedicationAdministration-not-given"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-not-given"/>
        <name value="not-given"/>
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
        <code value="not-given"/>
        <base value="MedicationAdministration"/>
        <type value="token"/>
        <description value="Administrations that were not made"/>
        <expression value="MedicationAdministration.notGiven"/>
        <xpath value="f:MedicationAdministration/f:notGiven"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/medications-patient"/>
    <resource>
      <SearchParameter>
        <id value="medications-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/medications-patient"/>
        <name value="patient"/>
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
        <code value="patient"/>
        <base value="MedicationRequest"/>
        <base value="MedicationAdministration"/>
        <base value="MedicationStatement"/>
        <base value="MedicationDispense"/>
        <type value="reference"/>
        <description value="Multiple Resources: 

* [MedicationRequest](medicationrequest.html): Returns prescriptions for a specific patient
* [MedicationAdministration](medicationadministration.html): The identity of a patient to list administrations  for
* [MedicationStatement](medicationstatement.html): Returns statements for a specific patient.
* [MedicationDispense](medicationdispense.html): The identity of a patient to list dispenses  for
"/>
        <expression value="MedicationRequest.subject | MedicationAdministration.subject | MedicationStatement.subject | MedicationDispense.subject"/>
        <xpath value="f:MedicationRequest/f:subject | f:MedicationAdministration/f:subject | f:MedicationStatement/f:subject | f:MedicationDispense/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-performer"/>
    <resource>
      <SearchParameter>
        <id value="MedicationAdministration-performer"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-performer"/>
        <name value="performer"/>
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
        <code value="performer"/>
        <base value="MedicationAdministration"/>
        <type value="reference"/>
        <description value="The identify of the individual who administered the medication"/>
        <expression value="MedicationAdministration.performer.actor"/>
        <xpath value="f:MedicationAdministration/f:performer/f:actor"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="Device"/>
        <target value="Patient"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/medications-prescription"/>
    <resource>
      <SearchParameter>
        <id value="medications-prescription"/>
        <url value="http://hl7.org/fhir/SearchParameter/medications-prescription"/>
        <name value="prescription"/>
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
        <code value="prescription"/>
        <base value="MedicationAdministration"/>
        <base value="MedicationDispense"/>
        <type value="reference"/>
        <description value="Multiple Resources: 

* [MedicationAdministration](medicationadministration.html): The identity of a prescription to list administrations from
* [MedicationDispense](medicationdispense.html): The identity of a prescription to list dispenses from
"/>
        <expression value="MedicationAdministration.prescription | MedicationDispense.authorizingPrescription"/>
        <xpath value="f:MedicationAdministration/f:prescription | f:MedicationDispense/f:authorizingPrescription"/>
        <xpathUsage value="normal"/>
        <target value="MedicationRequest"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-reason-given"/>
    <resource>
      <SearchParameter>
        <id value="MedicationAdministration-reason-given"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-reason-given"/>
        <name value="reason-given"/>
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
        <code value="reason-given"/>
        <base value="MedicationAdministration"/>
        <type value="token"/>
        <description value="Reasons for administering the medication"/>
        <expression value="MedicationAdministration.reasonCode"/>
        <xpath value="f:MedicationAdministration/f:reasonCode"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-reason-not-given"/>
    <resource>
      <SearchParameter>
        <id value="MedicationAdministration-reason-not-given"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-reason-not-given"/>
        <name value="reason-not-given"/>
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
        <code value="reason-not-given"/>
        <base value="MedicationAdministration"/>
        <type value="token"/>
        <description value="Reasons for not administering the medication"/>
        <expression value="MedicationAdministration.reasonNotGiven"/>
        <xpath value="f:MedicationAdministration/f:reasonNotGiven"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/medications-status"/>
    <resource>
      <SearchParameter>
        <id value="medications-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/medications-status"/>
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
        <base value="MedicationRequest"/>
        <base value="MedicationAdministration"/>
        <base value="MedicationStatement"/>
        <base value="MedicationDispense"/>
        <type value="token"/>
        <description value="Multiple Resources: 

* [MedicationRequest](medicationrequest.html): Status of the prescription
* [MedicationAdministration](medicationadministration.html): MedicationAdministration event status (for example one of active/paused/completed/nullified)
* [MedicationStatement](medicationstatement.html): Return statements that match the given status
* [MedicationDispense](medicationdispense.html): Return dispenses with a specified dispense status
"/>
        <expression value="MedicationRequest.status | MedicationAdministration.status | MedicationStatement.status | MedicationDispense.status"/>
        <xpath value="f:MedicationRequest/f:status | f:MedicationAdministration/f:status | f:MedicationStatement/f:status | f:MedicationDispense/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-subject"/>
    <resource>
      <SearchParameter>
        <id value="MedicationAdministration-subject"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationAdministration-subject"/>
        <name value="subject"/>
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
        <code value="subject"/>
        <base value="MedicationAdministration"/>
        <type value="reference"/>
        <description value="The identify of the individual or group to list administrations for"/>
        <expression value="MedicationAdministration.subject"/>
        <xpath value="f:MedicationAdministration/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Group"/>
        <target value="Patient"/>
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
