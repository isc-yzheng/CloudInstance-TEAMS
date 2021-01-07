Class HS.FHIR.vSTU3.Repository.Resource.Patient Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

Method deceased()
{
	// The xpath for this param is: "f:Patient/f:deceasedBoolean | f:Patient/f:deceasedDateTime"
	// However the indexed value supposed to be a boolean corresponding to the value of deceasedBoolean
	// if present, or "true" if deceasedDateTime is present, and otherwise null.
	try {
		if (..Format="JSON") {
			set tIsDeceased = ""
			set tXPath = "f:Patient/f:deceasedBoolean/@value"
			Set tResults = 0
			Set tSC = ..EvaluateXPathDynamicObj(..ResourceObject, .tXPath, .tResults)
			If tResults>0 {
				For tI = 1:1:tResults {
					set tIsDeceased = tResults(tI)
				}
			} Else {
				set tXPath = "f:Patient/f:deceasedBoolean/@value"
				Set tSC = ..EvaluateXPathDynamicObj(..ResourceObject, .tXPath, .tResults)
				If tResults>0 {
					Set tIsDeceased = "true"
				}
			}
			if (tIsDeceased'="") { set tSC = ..AddToSearchTableEntry("deceased", tIsDeceased) }
			quit
		}
		
		set tIsDeceased = ""
		set tXPath = "f:Patient/f:deceasedBoolean/@value"
		set tSC = ##class(HS.FHIR.Utils).EvaluateXPathExpression(..XPathDoc, tXPath, ..ResourceSchema, /*ResultType*/, .tResults) quit:$$$ISERR(tSC)
		if (tResults.Count()=1) { set tIsDeceased = tResults.GetAt(1) }
		else {
			set tXPath = "f:Patient/f:deceasedDateTime/@value"
			kill tResults
			set tSC = ##class(HS.FHIR.Utils).EvaluateXPathExpression(..XPathDoc, tXPath, ..ResourceSchema, /*ResultType*/, .tResults) quit:$$$ISERR(tSC)
			if (tResults.Count()=1)&&(tResults.GetAt(1)'="") { set tIsDeceased = "true" }
		}
		if (tIsDeceased'="") { set tSC = ..AddToSearchTableEntry("deceased", tIsDeceased) }
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Patient"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-active"/>
    <resource>
      <SearchParameter>
        <id value="Patient-active"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-active"/>
        <name value="active"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="active"/>
        <base value="Patient"/>
        <type value="token"/>
        <description value="Whether the patient record is active"/>
        <expression value="Patient.active"/>
        <xpath value="f:Patient/f:active"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/individual-address"/>
    <resource>
      <SearchParameter>
        <id value="individual-address"/>
        <url value="http://hl7.org/fhir/SearchParameter/individual-address"/>
        <name value="address"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="address"/>
        <base value="RelatedPerson"/>
        <base value="Practitioner"/>
        <base value="Person"/>
        <base value="Patient"/>
        <type value="string"/>
        <description value="Multiple Resources: 

* [RelatedPerson](relatedperson.html): A server defined search that may match any of the string fields in the Address, including line, city, state, country, postalCode, and/or text
* [Practitioner](practitioner.html): A server defined search that may match any of the string fields in the Address, including line, city, state, country, postalCode, and/or text
* [Person](person.html): A server defined search that may match any of the string fields in the Address, including line, city, state, country, postalCode, and/or text
* [Patient](patient.html): A server defined search that may match any of the string fields in the Address, including line, city, state, country, postalCode, and/or text
"/>
        <expression value="RelatedPerson.address | Practitioner.address | Person.address | Patient.address"/>
        <xpath value="f:RelatedPerson/f:address | f:Practitioner/f:address | f:Person/f:address | f:Patient/f:address"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/individual-address-city"/>
    <resource>
      <SearchParameter>
        <id value="individual-address-city"/>
        <url value="http://hl7.org/fhir/SearchParameter/individual-address-city"/>
        <name value="address-city"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="address-city"/>
        <base value="RelatedPerson"/>
        <base value="Practitioner"/>
        <base value="Person"/>
        <base value="Patient"/>
        <type value="string"/>
        <description value="Multiple Resources: 

* [RelatedPerson](relatedperson.html): A city specified in an address
* [Practitioner](practitioner.html): A city specified in an address
* [Person](person.html): A city specified in an address
* [Patient](patient.html): A city specified in an address
"/>
        <expression value="RelatedPerson.address.city | Practitioner.address.city | Person.address.city | Patient.address.city"/>
        <xpath value="f:RelatedPerson/f:address/f:city | f:Practitioner/f:address/f:city | f:Person/f:address/f:city | f:Patient/f:address/f:city"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/individual-address-country"/>
    <resource>
      <SearchParameter>
        <id value="individual-address-country"/>
        <url value="http://hl7.org/fhir/SearchParameter/individual-address-country"/>
        <name value="address-country"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="address-country"/>
        <base value="RelatedPerson"/>
        <base value="Practitioner"/>
        <base value="Person"/>
        <base value="Patient"/>
        <type value="string"/>
        <description value="Multiple Resources: 

* [RelatedPerson](relatedperson.html): A country specified in an address
* [Practitioner](practitioner.html): A country specified in an address
* [Person](person.html): A country specified in an address
* [Patient](patient.html): A country specified in an address
"/>
        <expression value="RelatedPerson.address.country | Practitioner.address.country | Person.address.country | Patient.address.country"/>
        <xpath value="f:RelatedPerson/f:address/f:country | f:Practitioner/f:address/f:country | f:Person/f:address/f:country | f:Patient/f:address/f:country"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/individual-address-postalcode"/>
    <resource>
      <SearchParameter>
        <id value="individual-address-postalcode"/>
        <url value="http://hl7.org/fhir/SearchParameter/individual-address-postalcode"/>
        <name value="address-postalcode"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="address-postalcode"/>
        <base value="RelatedPerson"/>
        <base value="Practitioner"/>
        <base value="Person"/>
        <base value="Patient"/>
        <type value="string"/>
        <description value="Multiple Resources: 

* [RelatedPerson](relatedperson.html): A postal code specified in an address
* [Practitioner](practitioner.html): A postalCode specified in an address
* [Person](person.html): A postal code specified in an address
* [Patient](patient.html): A postalCode specified in an address
"/>
        <expression value="RelatedPerson.address.postalCode | Practitioner.address.postalCode | Person.address.postalCode | Patient.address.postalCode"/>
        <xpath value="f:RelatedPerson/f:address/f:postalCode | f:Practitioner/f:address/f:postalCode | f:Person/f:address/f:postalCode | f:Patient/f:address/f:postalCode"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/individual-address-state"/>
    <resource>
      <SearchParameter>
        <id value="individual-address-state"/>
        <url value="http://hl7.org/fhir/SearchParameter/individual-address-state"/>
        <name value="address-state"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="address-state"/>
        <base value="RelatedPerson"/>
        <base value="Practitioner"/>
        <base value="Person"/>
        <base value="Patient"/>
        <type value="string"/>
        <description value="Multiple Resources: 

* [RelatedPerson](relatedperson.html): A state specified in an address
* [Practitioner](practitioner.html): A state specified in an address
* [Person](person.html): A state specified in an address
* [Patient](patient.html): A state specified in an address
"/>
        <expression value="RelatedPerson.address.state | Practitioner.address.state | Person.address.state | Patient.address.state"/>
        <xpath value="f:RelatedPerson/f:address/f:state | f:Practitioner/f:address/f:state | f:Person/f:address/f:state | f:Patient/f:address/f:state"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/individual-address-use"/>
    <resource>
      <SearchParameter>
        <id value="individual-address-use"/>
        <url value="http://hl7.org/fhir/SearchParameter/individual-address-use"/>
        <name value="address-use"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="address-use"/>
        <base value="RelatedPerson"/>
        <base value="Practitioner"/>
        <base value="Person"/>
        <base value="Patient"/>
        <type value="token"/>
        <description value="Multiple Resources: 

* [RelatedPerson](relatedperson.html): A use code specified in an address
* [Practitioner](practitioner.html): A use code specified in an address
* [Person](person.html): A use code specified in an address
* [Patient](patient.html): A use code specified in an address
"/>
        <expression value="RelatedPerson.address.use | Practitioner.address.use | Person.address.use | Patient.address.use"/>
        <xpath value="f:RelatedPerson/f:address/f:use | f:Practitioner/f:address/f:use | f:Person/f:address/f:use | f:Patient/f:address/f:use"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-animal-breed"/>
    <resource>
      <SearchParameter>
        <id value="Patient-animal-breed"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-animal-breed"/>
        <name value="animal-breed"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="animal-breed"/>
        <base value="Patient"/>
        <type value="token"/>
        <description value="The breed for animal patients"/>
        <expression value="Patient.animal.breed"/>
        <xpath value="f:Patient/f:animal/f:breed"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-animal-species"/>
    <resource>
      <SearchParameter>
        <id value="Patient-animal-species"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-animal-species"/>
        <name value="animal-species"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="animal-species"/>
        <base value="Patient"/>
        <type value="token"/>
        <description value="The species for animal patients"/>
        <expression value="Patient.animal.species"/>
        <xpath value="f:Patient/f:animal/f:species"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/individual-birthdate"/>
    <resource>
      <SearchParameter>
        <id value="individual-birthdate"/>
        <url value="http://hl7.org/fhir/SearchParameter/individual-birthdate"/>
        <name value="birthdate"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="birthdate"/>
        <base value="RelatedPerson"/>
        <base value="Person"/>
        <base value="Patient"/>
        <type value="date"/>
        <description value="Multiple Resources: 

* [RelatedPerson](relatedperson.html): The Related Person&apos;s date of birth
* [Person](person.html): The person&apos;s date of birth
* [Patient](patient.html): The patient&apos;s date of birth
"/>
        <expression value="RelatedPerson.birthDate | Person.birthDate | Patient.birthDate"/>
        <xpath value="f:RelatedPerson/f:birthDate | f:Person/f:birthDate | f:Patient/f:birthDate"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-death-date"/>
    <resource>
      <SearchParameter>
        <id value="Patient-death-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-death-date"/>
        <name value="death-date"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="death-date"/>
        <base value="Patient"/>
        <type value="date"/>
        <description value="The date of death has been provided and satisfies this search value"/>
        <expression value="Patient.deceased.as(DateTime)"/>
        <xpath value="f:Patient/f:deceasedDateTime"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-deceased"/>
    <resource>
      <SearchParameter>
        <id value="Patient-deceased"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-deceased"/>
        <name value="deceased"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="deceased"/>
        <base value="Patient"/>
        <type value="token"/>
        <description value="This patient has been marked as deceased, or as a death date entered"/>
        <expression value="Patient.deceased.exists()"/>
        <xpath value="f:Patient/f:deceasedBoolean | f:Patient/f:deceasedDateTime"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/individual-email"/>
    <resource>
      <SearchParameter>
        <id value="individual-email"/>
        <url value="http://hl7.org/fhir/SearchParameter/individual-email"/>
        <name value="email"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="email"/>
        <base value="PractitionerRole"/>
        <base value="RelatedPerson"/>
        <base value="Practitioner"/>
        <base value="Person"/>
        <base value="Patient"/>
        <type value="token"/>
        <description value="Multiple Resources: 

* [PractitionerRole](practitionerrole.html): A value in an email contact
* [RelatedPerson](relatedperson.html): A value in an email contact
* [Practitioner](practitioner.html): A value in an email contact
* [Person](person.html): A value in an email contact
* [Patient](patient.html): A value in an email contact
"/>
        <expression value="PractitionerRole.telecom.where(system=&apos;email&apos;) | RelatedPerson.telecom.where(system=&apos;email&apos;) | Practitioner.telecom.where(system=&apos;email&apos;) | Person.telecom.where(system=&apos;email&apos;) | Patient.telecom.where(system=&apos;email&apos;)"/>
        <xpath value="f:PractitionerRole/f:telecom[system/@value=&apos;email&apos;] | f:RelatedPerson/f:telecom[system/@value=&apos;email&apos;] | f:Practitioner/f:telecom[system/@value=&apos;email&apos;] | f:Person/f:telecom[system/@value=&apos;email&apos;] | f:Patient/f:telecom[system/@value=&apos;email&apos;]"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/individual-family"/>
    <resource>
      <SearchParameter>
        <id value="individual-family"/>
        <url value="http://hl7.org/fhir/SearchParameter/individual-family"/>
        <name value="family"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="family"/>
        <base value="Practitioner"/>
        <base value="Patient"/>
        <type value="string"/>
        <description value="Multiple Resources: 

* [Practitioner](practitioner.html): A portion of the family name
* [Patient](patient.html): A portion of the family name of the patient
"/>
        <expression value="Practitioner.name.family | Patient.name.family"/>
        <xpath value="f:Practitioner/f:name/f:family | f:Patient/f:name/f:family"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/individual-gender"/>
    <resource>
      <SearchParameter>
        <id value="individual-gender"/>
        <url value="http://hl7.org/fhir/SearchParameter/individual-gender"/>
        <name value="gender"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="gender"/>
        <base value="RelatedPerson"/>
        <base value="Practitioner"/>
        <base value="Person"/>
        <base value="Patient"/>
        <type value="token"/>
        <description value="Multiple Resources: 

* [RelatedPerson](relatedperson.html): Gender of the related person
* [Practitioner](practitioner.html): Gender of the practitioner
* [Person](person.html): The gender of the person
* [Patient](patient.html): Gender of the patient
"/>
        <expression value="RelatedPerson.gender | Practitioner.gender | Person.gender | Patient.gender"/>
        <xpath value="f:RelatedPerson/f:gender | f:Practitioner/f:gender | f:Person/f:gender | f:Patient/f:gender"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-general-practitioner"/>
    <resource>
      <SearchParameter>
        <id value="Patient-general-practitioner"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-general-practitioner"/>
        <name value="general-practitioner"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="general-practitioner"/>
        <base value="Patient"/>
        <type value="reference"/>
        <description value="Patient&apos;s nominated general practitioner, not the organization that manages the record"/>
        <expression value="Patient.generalPractitioner"/>
        <xpath value="f:Patient/f:generalPractitioner"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/individual-given"/>
    <resource>
      <SearchParameter>
        <id value="individual-given"/>
        <url value="http://hl7.org/fhir/SearchParameter/individual-given"/>
        <name value="given"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="given"/>
        <base value="Practitioner"/>
        <base value="Patient"/>
        <type value="string"/>
        <description value="Multiple Resources: 

* [Practitioner](practitioner.html): A portion of the given name
* [Patient](patient.html): A portion of the given name of the patient
"/>
        <expression value="Practitioner.name.given | Patient.name.given"/>
        <xpath value="f:Practitioner/f:name/f:given | f:Patient/f:name/f:given"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Patient-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-identifier"/>
        <name value="identifier"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="identifier"/>
        <base value="Patient"/>
        <type value="token"/>
        <description value="A patient identifier"/>
        <expression value="Patient.identifier"/>
        <xpath value="f:Patient/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-language"/>
    <resource>
      <SearchParameter>
        <id value="Patient-language"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-language"/>
        <name value="language"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="language"/>
        <base value="Patient"/>
        <type value="token"/>
        <description value="Language code (irrespective of use value)"/>
        <expression value="Patient.communication.language"/>
        <xpath value="f:Patient/f:communication/f:language"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-link"/>
    <resource>
      <SearchParameter>
        <id value="Patient-link"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-link"/>
        <name value="link"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="link"/>
        <base value="Patient"/>
        <type value="reference"/>
        <description value="All patients linked to the given patient"/>
        <expression value="Patient.link.other"/>
        <xpath value="f:Patient/f:link/f:other"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-name"/>
    <resource>
      <SearchParameter>
        <id value="Patient-name"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-name"/>
        <name value="name"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="name"/>
        <base value="Patient"/>
        <type value="string"/>
        <description value="A server defined search that may match any of the string fields in the HumanName, including family, give, prefix, suffix, suffix, and/or text"/>
        <expression value="Patient.name"/>
        <xpath value="f:Patient/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-organization"/>
    <resource>
      <SearchParameter>
        <id value="Patient-organization"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-organization"/>
        <name value="organization"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="organization"/>
        <base value="Patient"/>
        <type value="reference"/>
        <description value="The organization at which this person is a patient"/>
        <expression value="Patient.managingOrganization"/>
        <xpath value="f:Patient/f:managingOrganization"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/individual-phone"/>
    <resource>
      <SearchParameter>
        <id value="individual-phone"/>
        <url value="http://hl7.org/fhir/SearchParameter/individual-phone"/>
        <name value="phone"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="phone"/>
        <base value="PractitionerRole"/>
        <base value="RelatedPerson"/>
        <base value="Practitioner"/>
        <base value="Person"/>
        <base value="Patient"/>
        <type value="token"/>
        <description value="Multiple Resources: 

* [PractitionerRole](practitionerrole.html): A value in a phone contact
* [RelatedPerson](relatedperson.html): A value in a phone contact
* [Practitioner](practitioner.html): A value in a phone contact
* [Person](person.html): A value in a phone contact
* [Patient](patient.html): A value in a phone contact
"/>
        <expression value="PractitionerRole.telecom.where(system=&apos;phone&apos;) | RelatedPerson.telecom.where(system=&apos;phone&apos;) | Practitioner.telecom.where(system=&apos;phone&apos;) | Person.telecom.where(system=&apos;phone&apos;) | Patient.telecom.where(system=&apos;phone&apos;)"/>
        <xpath value="f:PractitionerRole/f:telecom[system/@value=&apos;phone&apos;] | f:RelatedPerson/f:telecom[system/@value=&apos;phone&apos;] | f:Practitioner/f:telecom[system/@value=&apos;phone&apos;] | f:Person/f:telecom[system/@value=&apos;phone&apos;] | f:Patient/f:telecom[system/@value=&apos;phone&apos;]"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/individual-telecom"/>
    <resource>
      <SearchParameter>
        <id value="individual-telecom"/>
        <url value="http://hl7.org/fhir/SearchParameter/individual-telecom"/>
        <name value="telecom"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="telecom"/>
        <base value="PractitionerRole"/>
        <base value="RelatedPerson"/>
        <base value="Practitioner"/>
        <base value="Person"/>
        <base value="Patient"/>
        <type value="token"/>
        <description value="Multiple Resources: 

* [PractitionerRole](practitionerrole.html): The value in any kind of contact
* [RelatedPerson](relatedperson.html): The value in any kind of contact
* [Practitioner](practitioner.html): The value in any kind of contact
* [Person](person.html): The value in any kind of contact
* [Patient](patient.html): The value in any kind of telecom details of the patient
"/>
        <expression value="PractitionerRole.telecom | RelatedPerson.telecom | Practitioner.telecom | Person.telecom | Patient.telecom"/>
        <xpath value="f:PractitionerRole/f:telecom | f:RelatedPerson/f:telecom | f:Practitioner/f:telecom | f:Person/f:telecom | f:Patient/f:telecom"/>
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
