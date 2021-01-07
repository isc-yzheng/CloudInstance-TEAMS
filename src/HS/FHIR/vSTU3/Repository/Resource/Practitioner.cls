Class HS.FHIR.vSTU3.Repository.Resource.Practitioner Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Practitioner"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Practitioner-active"/>
    <resource>
      <SearchParameter>
        <id value="Practitioner-active"/>
        <url value="http://hl7.org/fhir/SearchParameter/Practitioner-active"/>
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
        <base value="Practitioner"/>
        <type value="token"/>
        <description value="Whether the practitioner record is active"/>
        <expression value="Practitioner.active"/>
        <xpath value="f:Practitioner/f:active"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Practitioner-communication"/>
    <resource>
      <SearchParameter>
        <id value="Practitioner-communication"/>
        <url value="http://hl7.org/fhir/SearchParameter/Practitioner-communication"/>
        <name value="communication"/>
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
        <code value="communication"/>
        <base value="Practitioner"/>
        <type value="token"/>
        <description value="One of the languages that the practitioner can communicate with"/>
        <expression value="Practitioner.communication"/>
        <xpath value="f:Practitioner/f:communication"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Practitioner-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Practitioner-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Practitioner-identifier"/>
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
        <base value="Practitioner"/>
        <type value="token"/>
        <description value="A practitioner&apos;s Identifier"/>
        <expression value="Practitioner.identifier"/>
        <xpath value="f:Practitioner/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Practitioner-name"/>
    <resource>
      <SearchParameter>
        <id value="Practitioner-name"/>
        <url value="http://hl7.org/fhir/SearchParameter/Practitioner-name"/>
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
        <base value="Practitioner"/>
        <type value="string"/>
        <description value="A server defined search that may match any of the string fields in the HumanName, including family, give, prefix, suffix, suffix, and/or text"/>
        <expression value="Practitioner.name"/>
        <xpath value="f:Practitioner/f:name"/>
        <xpathUsage value="normal"/>
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
