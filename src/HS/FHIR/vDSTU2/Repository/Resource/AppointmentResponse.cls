Class HS.FHIR.vDSTU2.Repository.Resource.AppointmentResponse Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-AppointmentResponse"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AppointmentResponse-actor"/>
    <resource>
      <SearchParameter>
        <id value="AppointmentResponse-actor"/>
        <url value="http://hl7.org/fhir/SearchParameter/AppointmentResponse-actor"/>
        <name value="actor"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="actor"/>
        <base value="AppointmentResponse"/>
        <type value="reference"/>
        <description value="The Person, Location/HealthcareService or Device that this appointment response replies for"/>
        <xpath value="f:AppointmentResponse/f:actor"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="Location"/>
        <target value="HealthcareService"/>
        <target value="Patient"/>
        <target value="Practitioner"/>
        <target value="RelatedPerson"/>
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
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="appointment"/>
        <base value="AppointmentResponse"/>
        <type value="reference"/>
        <description value="The appointment that the response is attached to"/>
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
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="identifier"/>
        <base value="AppointmentResponse"/>
        <type value="token"/>
        <description value="An Identifier in this appointment response"/>
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
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="location"/>
        <base value="AppointmentResponse"/>
        <type value="reference"/>
        <description value="This Response is for this Location"/>
        <xpath value="f:AppointmentResponse/f:actor"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="Location"/>
        <target value="HealthcareService"/>
        <target value="Patient"/>
        <target value="Practitioner"/>
        <target value="RelatedPerson"/>
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
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="part-status"/>
        <base value="AppointmentResponse"/>
        <type value="token"/>
        <description value="The participants acceptance status for this appointment"/>
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
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="patient"/>
        <base value="AppointmentResponse"/>
        <type value="reference"/>
        <description value="This Response is for this Patient"/>
        <xpath value="f:AppointmentResponse/f:actor"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="Location"/>
        <target value="HealthcareService"/>
        <target value="Patient"/>
        <target value="Practitioner"/>
        <target value="RelatedPerson"/>
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
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="practitioner"/>
        <base value="AppointmentResponse"/>
        <type value="reference"/>
        <description value="This Response is for this Practitioner"/>
        <xpath value="f:AppointmentResponse/f:actor"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="Location"/>
        <target value="HealthcareService"/>
        <target value="Patient"/>
        <target value="Practitioner"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
