Class HS.FHIR.vSTU3.Repository.Resource.Slot Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Slot"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Slot-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Slot-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Slot-identifier"/>
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
        <base value="Slot"/>
        <type value="token"/>
        <description value="A Slot Identifier"/>
        <expression value="Slot.identifier"/>
        <xpath value="f:Slot/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Slot-schedule"/>
    <resource>
      <SearchParameter>
        <id value="Slot-schedule"/>
        <url value="http://hl7.org/fhir/SearchParameter/Slot-schedule"/>
        <name value="schedule"/>
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
        <code value="schedule"/>
        <base value="Slot"/>
        <type value="reference"/>
        <description value="The Schedule Resource that we are seeking a slot within"/>
        <expression value="Slot.schedule"/>
        <xpath value="f:Slot/f:schedule"/>
        <xpathUsage value="normal"/>
        <target value="Schedule"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Slot-slot-type"/>
    <resource>
      <SearchParameter>
        <id value="Slot-slot-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/Slot-slot-type"/>
        <name value="slot-type"/>
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
        <code value="slot-type"/>
        <base value="Slot"/>
        <type value="token"/>
        <description value="The type of appointments that can be booked into the slot"/>
        <expression value="Slot.serviceType"/>
        <xpath value="f:Slot/f:serviceType"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Slot-start"/>
    <resource>
      <SearchParameter>
        <id value="Slot-start"/>
        <url value="http://hl7.org/fhir/SearchParameter/Slot-start"/>
        <name value="start"/>
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
        <code value="start"/>
        <base value="Slot"/>
        <type value="date"/>
        <description value="Appointment date/time."/>
        <expression value="Slot.start"/>
        <xpath value="f:Slot/f:start"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Slot-status"/>
    <resource>
      <SearchParameter>
        <id value="Slot-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/Slot-status"/>
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
        <base value="Slot"/>
        <type value="token"/>
        <description value="The free/busy status of the appointment"/>
        <expression value="Slot.status"/>
        <xpath value="f:Slot/f:status"/>
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
