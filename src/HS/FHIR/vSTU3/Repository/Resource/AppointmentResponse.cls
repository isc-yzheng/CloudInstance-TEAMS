Class HS.FHIR.vSTU3.Repository.Resource.AppointmentResponse Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-AppointmentResponse"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AppointmentResponse-actor"/>
    <resource>
      <SearchParameter>
        <id value="AppointmentResponse-actor"/>
        <url value="http://hl7.org/fhir/SearchParameter/AppointmentResponse-actor"/>
        <name value="actor"/>
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
        <code value="actor"/>
        <base value="AppointmentResponse"/>
        <type value="reference"/>
        <description value="The Person, Location/HealthcareService or Device that this appointment response replies for"/>
        <expression value="AppointmentResponse.actor"/>
        <xpath value="f:AppointmentResponse/f:actor"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="Device"/>
        <target value="Patient"/>
        <target value="HealthcareService"/>
        <target value="RelatedPerson"/>
        <target value="Location"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AppointmentResponse-appointment"/>
    <resource>
      <SearchParameter>
        <id value="AppointmentResponse-appointment"/>
        <url value="http://hl7.org/fhir/SearchParameter/AppointmentResponse-appointment"/>
        <name value="appointment"/>
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
        <code value="appointment"/>
        <base value="AppointmentResponse"/>
        <type value="reference"/>
        <description value="The appointment that the response is attached to"/>
        <expression value="AppointmentResponse.appointment"/>
        <xpath value="f:AppointmentResponse/f:appointment"/>
        <xpathUsage value="normal"/>
        <target value="Appointment"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AppointmentResponse-identifier"/>
    <resource>
      <SearchParameter>
        <id value="AppointmentResponse-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/AppointmentResponse-identifier"/>
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
        <base value="AppointmentResponse"/>
        <type value="token"/>
        <description value="An Identifier in this appointment response"/>
        <expression value="AppointmentResponse.identifier"/>
        <xpath value="f:AppointmentResponse/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AppointmentResponse-location"/>
    <resource>
      <SearchParameter>
        <id value="AppointmentResponse-location"/>
        <url value="http://hl7.org/fhir/SearchParameter/AppointmentResponse-location"/>
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
        <base value="AppointmentResponse"/>
        <type value="reference"/>
        <description value="This Response is for this Location"/>
        <expression value="AppointmentResponse.actor"/>
        <xpath value="f:AppointmentResponse/f:actor"/>
        <xpathUsage value="normal"/>
        <target value="Location"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AppointmentResponse-part-status"/>
    <resource>
      <SearchParameter>
        <id value="AppointmentResponse-part-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/AppointmentResponse-part-status"/>
        <name value="part-status"/>
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
        <code value="part-status"/>
        <base value="AppointmentResponse"/>
        <type value="token"/>
        <description value="The participants acceptance status for this appointment"/>
        <expression value="AppointmentResponse.participantStatus"/>
        <xpath value="f:AppointmentResponse/f:participantStatus"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AppointmentResponse-patient"/>
    <resource>
      <SearchParameter>
        <id value="AppointmentResponse-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/AppointmentResponse-patient"/>
        <name value="patient"/>
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
        <code value="patient"/>
        <base value="AppointmentResponse"/>
        <type value="reference"/>
        <description value="This Response is for this Patient"/>
        <expression value="AppointmentResponse.actor"/>
        <xpath value="f:AppointmentResponse/f:actor"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AppointmentResponse-practitioner"/>
    <resource>
      <SearchParameter>
        <id value="AppointmentResponse-practitioner"/>
        <url value="http://hl7.org/fhir/SearchParameter/AppointmentResponse-practitioner"/>
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
        <base value="AppointmentResponse"/>
        <type value="reference"/>
        <description value="This Response is for this Practitioner"/>
        <expression value="AppointmentResponse.actor"/>
        <xpath value="f:AppointmentResponse/f:actor"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
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
