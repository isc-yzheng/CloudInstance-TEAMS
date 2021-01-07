Class HS.FHIR.vSTU3.Repository.Resource.Appointment Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Appointment"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Appointment-actor"/>
    <resource>
      <SearchParameter>
        <id value="Appointment-actor"/>
        <url value="http://hl7.org/fhir/SearchParameter/Appointment-actor"/>
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
        <base value="Appointment"/>
        <type value="reference"/>
        <description value="Any one of the individuals participating in the appointment"/>
        <expression value="Appointment.participant.actor"/>
        <xpath value="f:Appointment/f:participant/f:actor"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Appointment-appointment-type"/>
    <resource>
      <SearchParameter>
        <id value="Appointment-appointment-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/Appointment-appointment-type"/>
        <name value="appointment-type"/>
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
        <code value="appointment-type"/>
        <base value="Appointment"/>
        <type value="token"/>
        <description value="The style of appointment or patient that has been booked in the slot (not service type)"/>
        <expression value="Appointment.appointmentType"/>
        <xpath value="f:Appointment/f:appointmentType"/>
        <xpathUsage value="normal"/>
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
        <base value="Appointment"/>
        <type value="date"/>
        <description value="Appointment date/time."/>
        <expression value="Appointment.start"/>
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
        <base value="Appointment"/>
        <type value="token"/>
        <description value="An Identifier of the Appointment"/>
        <expression value="Appointment.identifier"/>
        <xpath value="f:Appointment/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Appointment-incomingreferral"/>
    <resource>
      <SearchParameter>
        <id value="Appointment-incomingreferral"/>
        <url value="http://hl7.org/fhir/SearchParameter/Appointment-incomingreferral"/>
        <name value="incomingreferral"/>
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
        <code value="incomingreferral"/>
        <base value="Appointment"/>
        <type value="reference"/>
        <description value="The ReferralRequest provided as information to allocate to the Encounter"/>
        <expression value="Appointment.incomingReferral"/>
        <xpath value="f:Appointment/f:incomingReferral"/>
        <xpathUsage value="normal"/>
        <target value="ReferralRequest"/>
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
        <base value="Appointment"/>
        <type value="reference"/>
        <description value="This location is listed in the participants of the appointment"/>
        <expression value="Appointment.participant.actor"/>
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
        <base value="Appointment"/>
        <type value="token"/>
        <description value="The Participation status of the subject, or other participant on the appointment. Can be used to locate participants that have not responded to meeting requests."/>
        <expression value="Appointment.participant.status"/>
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
        <base value="Appointment"/>
        <type value="reference"/>
        <description value="One of the individuals of the appointment is this patient"/>
        <expression value="Appointment.participant.actor"/>
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
        <base value="Appointment"/>
        <type value="reference"/>
        <description value="One of the individuals of the appointment is this practitioner"/>
        <expression value="Appointment.participant.actor"/>
        <xpath value="f:Appointment/f:participant/f:actor"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Appointment-service-type"/>
    <resource>
      <SearchParameter>
        <id value="Appointment-service-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/Appointment-service-type"/>
        <name value="service-type"/>
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
        <code value="service-type"/>
        <base value="Appointment"/>
        <type value="token"/>
        <description value="The specific service that is to be performed during this appointment"/>
        <expression value="Appointment.serviceType"/>
        <xpath value="f:Appointment/f:serviceType"/>
        <xpathUsage value="normal"/>
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
        <code value="status"/>
        <base value="Appointment"/>
        <type value="token"/>
        <description value="The overall status of the appointment"/>
        <expression value="Appointment.status"/>
        <xpath value="f:Appointment/f:status"/>
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
