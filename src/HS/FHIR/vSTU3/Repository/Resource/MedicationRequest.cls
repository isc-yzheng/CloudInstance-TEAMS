Class HS.FHIR.vSTU3.Repository.Resource.MedicationRequest Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-MedicationRequest"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationRequest-authoredon"/>
    <resource>
      <SearchParameter>
        <id value="MedicationRequest-authoredon"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationRequest-authoredon"/>
        <name value="authoredon"/>
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
        <code value="authoredon"/>
        <base value="MedicationRequest"/>
        <type value="date"/>
        <description value="Return prescriptions written on this date"/>
        <expression value="MedicationRequest.authoredOn"/>
        <xpath value="f:MedicationRequest/f:authoredOn"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationRequest-category"/>
    <resource>
      <SearchParameter>
        <id value="MedicationRequest-category"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationRequest-category"/>
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
        <base value="MedicationRequest"/>
        <type value="token"/>
        <description value="Returns prescriptions with different categories"/>
        <expression value="MedicationRequest.category"/>
        <xpath value="f:MedicationRequest/f:category"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationRequest-context"/>
    <resource>
      <SearchParameter>
        <id value="MedicationRequest-context"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationRequest-context"/>
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
        <base value="MedicationRequest"/>
        <type value="reference"/>
        <description value="Return prescriptions with this encounter or episode of care identifier"/>
        <expression value="MedicationRequest.context"/>
        <xpath value="f:MedicationRequest/f:context"/>
        <xpathUsage value="normal"/>
        <target value="EpisodeOfCare"/>
        <target value="Encounter"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/medications-date"/>
    <resource>
      <SearchParameter>
        <id value="medications-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/medications-date"/>
        <name value="date"/>
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
        <code value="date"/>
        <base value="MedicationRequest"/>
        <type value="date"/>
        <description value="Multiple Resources: 

* [MedicationRequest](medicationrequest.html): Returns medication request to be administered on a specific date
"/>
        <expression value="MedicationRequest.dosageInstruction.timing.event"/>
        <xpath value="f:MedicationRequest/f:dosageInstruction/f:timing/f:event"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationRequest-intended-dispenser"/>
    <resource>
      <SearchParameter>
        <id value="MedicationRequest-intended-dispenser"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationRequest-intended-dispenser"/>
        <name value="intended-dispenser"/>
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
        <code value="intended-dispenser"/>
        <base value="MedicationRequest"/>
        <type value="reference"/>
        <description value="Returns prescriptions intended to be dispensed by this Organization"/>
        <expression value="MedicationRequest.dispenseRequest.performer"/>
        <xpath value="f:MedicationRequest/f:dispenseRequest/f:performer"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationRequest-intent"/>
    <resource>
      <SearchParameter>
        <id value="MedicationRequest-intent"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationRequest-intent"/>
        <name value="intent"/>
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
        <code value="intent"/>
        <base value="MedicationRequest"/>
        <type value="token"/>
        <description value="Returns prescriptions with different intents"/>
        <expression value="MedicationRequest.intent"/>
        <xpath value="f:MedicationRequest/f:intent"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationRequest-priority"/>
    <resource>
      <SearchParameter>
        <id value="MedicationRequest-priority"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationRequest-priority"/>
        <name value="priority"/>
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
        <code value="priority"/>
        <base value="MedicationRequest"/>
        <type value="token"/>
        <description value="Returns prescriptions with different priorities"/>
        <expression value="MedicationRequest.priority"/>
        <xpath value="f:MedicationRequest/f:priority"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationRequest-requester"/>
    <resource>
      <SearchParameter>
        <id value="MedicationRequest-requester"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationRequest-requester"/>
        <name value="requester"/>
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
        <code value="requester"/>
        <base value="MedicationRequest"/>
        <type value="reference"/>
        <description value="Returns prescriptions prescribed by this prescriber"/>
        <expression value="MedicationRequest.requester.agent"/>
        <xpath value="f:MedicationRequest/f:requester/f:agent"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MedicationRequest-subject"/>
    <resource>
      <SearchParameter>
        <id value="MedicationRequest-subject"/>
        <url value="http://hl7.org/fhir/SearchParameter/MedicationRequest-subject"/>
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
        <base value="MedicationRequest"/>
        <type value="reference"/>
        <description value="The identity of a patient to list orders  for"/>
        <expression value="MedicationRequest.subject"/>
        <xpath value="f:MedicationRequest/f:subject"/>
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
