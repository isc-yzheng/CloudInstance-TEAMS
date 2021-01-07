Class HS.FHIR.vDSTU2.Repository.Resource.Appointment Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Appointment"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Appointment-actor"/>
    <resource>
      <SearchParameter>
        <id value="Appointment-actor"/>
        <url value="http://hl7.org/fhir/SearchParameter/Appointment-actor"/>
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
        <base value="Appointment"/>
        <type value="reference"/>
        <description value="Any one of the individuals participating in the appointment"/>
        <xpath value="f:Appointment/f:participant/f:actor"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Appointment-date"/>
    <resource>
      <SearchParameter>
        <id value="Appointment-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/Appointment-date"/>
        <name value="date"/>
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
        <code value="date"/>
        <base value="Appointment"/>
        <type value="date"/>
        <description value="Appointment date/time."/>
        <xpath value="f:Appointment/f:start"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Appointment-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Appointment-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Appointment-identifier"/>
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
        <base value="Appointment"/>
        <type value="token"/>
        <description value="An Identifier of the Appointment"/>
        <xpath value="f:Appointment/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Appointment-location"/>
    <resource>
      <SearchParameter>
        <id value="Appointment-location"/>
        <url value="http://hl7.org/fhir/SearchParameter/Appointment-location"/>
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
        <base value="Appointment"/>
        <type value="reference"/>
        <description value="This location is listed in the participants of the appointment"/>
        <xpath value="f:Appointment/f:participant/f:actor"/>
        <xpathUsage value="normal"/>
        <target value="Location"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Appointment-part-status"/>
    <resource>
      <SearchParameter>
        <id value="Appointment-part-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/Appointment-part-status"/>
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
        <base value="Appointment"/>
        <type value="token"/>
        <description value="The Participation status of the subject, or other participant on the appointment. Can be used to locate participants that have not responded to meeting requests."/>
        <xpath value="f:Appointment/f:participant/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Appointment-patient"/>
    <resource>
      <SearchParameter>
        <id value="Appointment-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/Appointment-patient"/>
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
        <base value="Appointment"/>
        <type value="reference"/>
        <description value="One of the individuals of the appointment is this patient"/>
        <xpath value="f:Appointment/f:participant/f:actor"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Appointment-practitioner"/>
    <resource>
      <SearchParameter>
        <id value="Appointment-practitioner"/>
        <url value="http://hl7.org/fhir/SearchParameter/Appointment-practitioner"/>
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
        <base value="Appointment"/>
        <type value="reference"/>
        <description value="One of the individuals of the appointment is this practitioner"/>
        <xpath value="f:Appointment/f:participant/f:actor"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Appointment-status"/>
    <resource>
      <SearchParameter>
        <id value="Appointment-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/Appointment-status"/>
        <name value="status"/>
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
        <code value="status"/>
        <base value="Appointment"/>
        <type value="token"/>
        <description value="The overall status of the appointment"/>
        <xpath value="f:Appointment/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
