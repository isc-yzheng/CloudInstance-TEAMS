Class HS.FHIR.vSTU3.Repository.Resource.MedicationDispense Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-MedicationDispense"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationDispense-context"/>
    <resource>
      <SearchParameter>
        <id value="MedicationDispense-context"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationDispense-context"/>
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
        <base value="MedicationDispense"/>
        <type value="reference"/>
        <description value="Returns dispenses with a specific context (episode or episode of care)"/>
        <expression value="MedicationDispense.context"/>
        <xpath value="f:MedicationDispense/f:context"/>
        <xpathUsage value="normal"/>
        <target value="EpisodeOfCare"/>
        <target value="Encounter"/>
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
        <code value="destination"/>
        <base value="MedicationDispense"/>
        <type value="reference"/>
        <description value="Return dispenses that should be sent to a specific destination"/>
        <expression value="MedicationDispense.destination"/>
        <xpath value="f:MedicationDispense/f:destination"/>
        <xpathUsage value="normal"/>
        <target value="Location"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationDispense-performer"/>
    <resource>
      <SearchParameter>
        <id value="MedicationDispense-performer"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationDispense-performer"/>
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
        <base value="MedicationDispense"/>
        <type value="reference"/>
        <description value="Return dispenses performed by a specific individual"/>
        <expression value="MedicationDispense.performer.actor"/>
        <xpath value="f:MedicationDispense/f:performer/f:actor"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="Organization"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationDispense-receiver"/>
    <resource>
      <SearchParameter>
        <id value="MedicationDispense-receiver"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationDispense-receiver"/>
        <name value="receiver"/>
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
        <code value="receiver"/>
        <base value="MedicationDispense"/>
        <type value="reference"/>
        <description value="The identity of a receiver to list dispenses for"/>
        <expression value="MedicationDispense.receiver"/>
        <xpath value="f:MedicationDispense/f:receiver"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="Patient"/>
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
        <code value="responsibleparty"/>
        <base value="MedicationDispense"/>
        <type value="reference"/>
        <description value="Return dispenses with the specified responsible party"/>
        <expression value="MedicationDispense.substitution.responsibleParty"/>
        <xpath value="f:MedicationDispense/f:substitution/f:responsibleParty"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationDispense-subject"/>
    <resource>
      <SearchParameter>
        <id value="MedicationDispense-subject"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationDispense-subject"/>
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
        <base value="MedicationDispense"/>
        <type value="reference"/>
        <description value="The identity of a patient to list dispenses  for"/>
        <expression value="MedicationDispense.subject"/>
        <xpath value="f:MedicationDispense/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Group"/>
        <target value="Patient"/>
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
        <code value="type"/>
        <base value="MedicationDispense"/>
        <type value="token"/>
        <description value="Return dispenses of a specific type"/>
        <expression value="MedicationDispense.type"/>
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
        <code value="whenhandedover"/>
        <base value="MedicationDispense"/>
        <type value="date"/>
        <description value="Returns dispenses handed over on this date"/>
        <expression value="MedicationDispense.whenHandedOver"/>
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
        <code value="whenprepared"/>
        <base value="MedicationDispense"/>
        <type value="date"/>
        <description value="Returns dispenses prepared on this date"/>
        <expression value="MedicationDispense.whenPrepared"/>
        <xpath value="f:MedicationDispense/f:whenPrepared"/>
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
