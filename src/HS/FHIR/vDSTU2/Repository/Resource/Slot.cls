Class HS.FHIR.vDSTU2.Repository.Resource.Slot Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Slot"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Slot-fb-type"/>
    <resource>
      <SearchParameter>
        <id value="Slot-fb-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/Slot-fb-type"/>
        <name value="fb-type"/>
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
        <code value="fb-type"/>
        <base value="Slot"/>
        <type value="token"/>
        <description value="The free/busy status of the appointment"/>
        <xpath value="f:Slot/f:freeBusyType"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Slot-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Slot-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Slot-identifier"/>
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
        <base value="Slot"/>
        <type value="token"/>
        <description value="A Slot Identifier"/>
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
        <code value="schedule"/>
        <base value="Slot"/>
        <type value="reference"/>
        <description value="The Schedule Resource that we are seeking a slot within"/>
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
        <code value="slot-type"/>
        <base value="Slot"/>
        <type value="token"/>
        <description value="The type of appointments that can be booked into the slot"/>
        <xpath value="f:Slot/f:type"/>
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
        <code value="start"/>
        <base value="Slot"/>
        <type value="date"/>
        <description value="Appointment date/time."/>
        <xpath value="f:Slot/f:start"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
