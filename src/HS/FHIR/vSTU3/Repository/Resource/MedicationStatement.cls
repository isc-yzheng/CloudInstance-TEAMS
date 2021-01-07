Class HS.FHIR.vSTU3.Repository.Resource.MedicationStatement Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-MedicationStatement"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationStatement-category"/>
    <resource>
      <SearchParameter>
        <id value="MedicationStatement-category"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationStatement-category"/>
        <name value="category"/>
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
        <code value="category"/>
        <base value="MedicationStatement"/>
        <type value="token"/>
        <description value="Returns statements of this category of medicationstatement"/>
        <expression value="MedicationStatement.category"/>
        <xpath value="f:MedicationStatement/f:category"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationStatement-context"/>
    <resource>
      <SearchParameter>
        <id value="MedicationStatement-context"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationStatement-context"/>
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
        <base value="MedicationStatement"/>
        <type value="reference"/>
        <description value="Returns statements for a specific context (episode or episode of Care)."/>
        <expression value="MedicationStatement.context"/>
        <xpath value="f:MedicationStatement/f:context"/>
        <xpathUsage value="normal"/>
        <target value="EpisodeOfCare"/>
        <target value="Encounter"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationStatement-effective"/>
    <resource>
      <SearchParameter>
        <id value="MedicationStatement-effective"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationStatement-effective"/>
        <name value="effective"/>
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
        <code value="effective"/>
        <base value="MedicationStatement"/>
        <type value="date"/>
        <description value="Date when patient was taking (or not taking) the medication"/>
        <expression value="MedicationStatement.effective"/>
        <xpath value="f:MedicationStatement/f:effectiveDateTime | f:MedicationStatement/f:effectivePeriod"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationStatement-part-of"/>
    <resource>
      <SearchParameter>
        <id value="MedicationStatement-part-of"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationStatement-part-of"/>
        <name value="part-of"/>
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
        <code value="part-of"/>
        <base value="MedicationStatement"/>
        <type value="reference"/>
        <description value="Returns statements that are part of another event."/>
        <expression value="MedicationStatement.partOf"/>
        <xpath value="f:MedicationStatement/f:partOf"/>
        <xpathUsage value="normal"/>
        <target value="MedicationDispense"/>
        <target value="Observation"/>
        <target value="MedicationAdministration"/>
        <target value="Procedure"/>
        <target value="MedicationStatement"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationStatement-source"/>
    <resource>
      <SearchParameter>
        <id value="MedicationStatement-source"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationStatement-source"/>
        <name value="source"/>
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
        <code value="source"/>
        <base value="MedicationStatement"/>
        <type value="reference"/>
        <description value="Who or where the information in the statement came from"/>
        <expression value="MedicationStatement.informationSource"/>
        <xpath value="f:MedicationStatement/f:informationSource"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="Organization"/>
        <target value="Patient"/>
        <target value="RelatedPerson"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationStatement-subject"/>
    <resource>
      <SearchParameter>
        <id value="MedicationStatement-subject"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationStatement-subject"/>
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
        <base value="MedicationStatement"/>
        <type value="reference"/>
        <description value="The identity of a patient, animal or group to list statements for"/>
        <expression value="MedicationStatement.subject"/>
        <xpath value="f:MedicationStatement/f:subject"/>
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
