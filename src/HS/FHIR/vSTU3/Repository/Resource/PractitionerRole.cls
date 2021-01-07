Class HS.FHIR.vSTU3.Repository.Resource.PractitionerRole Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-PractitionerRole"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/PractitionerRole-active"/>
    <resource>
      <SearchParameter>
        <id value="PractitionerRole-active"/>
        <url value="http://hl7.org/fhir/SearchParameter/PractitionerRole-active"/>
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
        <base value="PractitionerRole"/>
        <type value="token"/>
        <description value="Whether this practitioner&apos;s record is in active use"/>
        <expression value="PractitionerRole.active"/>
        <xpath value="f:PractitionerRole/f:active"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/PractitionerRole-date"/>
    <resource>
      <SearchParameter>
        <id value="PractitionerRole-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/PractitionerRole-date"/>
        <name value="date"/>
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
        <code value="date"/>
        <base value="PractitionerRole"/>
        <type value="date"/>
        <description value="The period during which the practitioner is authorized to perform in these role(s)"/>
        <expression value="PractitionerRole.period"/>
        <xpath value="f:PractitionerRole/f:period"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/PractitionerRole-endpoint"/>
    <resource>
      <SearchParameter>
        <id value="PractitionerRole-endpoint"/>
        <url value="http://hl7.org/fhir/SearchParameter/PractitionerRole-endpoint"/>
        <name value="endpoint"/>
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
        <code value="endpoint"/>
        <base value="PractitionerRole"/>
        <type value="reference"/>
        <description value="Technical endpoints providing access to services operated for the practitioner with this role"/>
        <expression value="PractitionerRole.endpoint"/>
        <xpath value="f:PractitionerRole/f:endpoint"/>
        <xpathUsage value="normal"/>
        <target value="Endpoint"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/PractitionerRole-identifier"/>
    <resource>
      <SearchParameter>
        <id value="PractitionerRole-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/PractitionerRole-identifier"/>
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
        <base value="PractitionerRole"/>
        <type value="token"/>
        <description value="A practitioner&apos;s Identifier"/>
        <expression value="PractitionerRole.identifier"/>
        <xpath value="f:PractitionerRole/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/PractitionerRole-location"/>
    <resource>
      <SearchParameter>
        <id value="PractitionerRole-location"/>
        <url value="http://hl7.org/fhir/SearchParameter/PractitionerRole-location"/>
        <name value="location"/>
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
        <code value="location"/>
        <base value="PractitionerRole"/>
        <type value="reference"/>
        <description value="One of the locations at which this practitioner provides care"/>
        <expression value="PractitionerRole.location"/>
        <xpath value="f:PractitionerRole/f:location"/>
        <xpathUsage value="normal"/>
        <target value="Location"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/PractitionerRole-organization"/>
    <resource>
      <SearchParameter>
        <id value="PractitionerRole-organization"/>
        <url value="http://hl7.org/fhir/SearchParameter/PractitionerRole-organization"/>
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
        <base value="PractitionerRole"/>
        <type value="reference"/>
        <description value="The identity of the organization the practitioner represents / acts on behalf of"/>
        <expression value="PractitionerRole.organization"/>
        <xpath value="f:PractitionerRole/f:organization"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/PractitionerRole-practitioner"/>
    <resource>
      <SearchParameter>
        <id value="PractitionerRole-practitioner"/>
        <url value="http://hl7.org/fhir/SearchParameter/PractitionerRole-practitioner"/>
        <name value="practitioner"/>
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
        <code value="practitioner"/>
        <base value="PractitionerRole"/>
        <type value="reference"/>
        <description value="Practitioner that is able to provide the defined services for the organation"/>
        <expression value="PractitionerRole.practitioner"/>
        <xpath value="f:PractitionerRole/f:practitioner"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/PractitionerRole-role"/>
    <resource>
      <SearchParameter>
        <id value="PractitionerRole-role"/>
        <url value="http://hl7.org/fhir/SearchParameter/PractitionerRole-role"/>
        <name value="role"/>
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
        <code value="role"/>
        <base value="PractitionerRole"/>
        <type value="token"/>
        <description value="The practitioner can perform this role at for the organization"/>
        <expression value="PractitionerRole.code"/>
        <xpath value="f:PractitionerRole/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/PractitionerRole-service"/>
    <resource>
      <SearchParameter>
        <id value="PractitionerRole-service"/>
        <url value="http://hl7.org/fhir/SearchParameter/PractitionerRole-service"/>
        <name value="service"/>
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
        <code value="service"/>
        <base value="PractitionerRole"/>
        <type value="reference"/>
        <description value="The list of healthcare services that this worker provides for this role&apos;s Organization/Location(s)"/>
        <expression value="PractitionerRole.healthcareService"/>
        <xpath value="f:PractitionerRole/f:healthcareService"/>
        <xpathUsage value="normal"/>
        <target value="HealthcareService"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/PractitionerRole-specialty"/>
    <resource>
      <SearchParameter>
        <id value="PractitionerRole-specialty"/>
        <url value="http://hl7.org/fhir/SearchParameter/PractitionerRole-specialty"/>
        <name value="specialty"/>
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
        <code value="specialty"/>
        <base value="PractitionerRole"/>
        <type value="token"/>
        <description value="The practitioner has this specialty at an organization"/>
        <expression value="PractitionerRole.specialty"/>
        <xpath value="f:PractitionerRole/f:specialty"/>
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
