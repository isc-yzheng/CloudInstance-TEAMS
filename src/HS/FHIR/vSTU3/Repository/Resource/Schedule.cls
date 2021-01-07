Class HS.FHIR.vSTU3.Repository.Resource.Schedule Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Schedule"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Schedule-active"/>
    <resource>
      <SearchParameter>
        <id value="Schedule-active"/>
        <url value="http://hl7.org/fhir/SearchParameter/Schedule-active"/>
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
        <base value="Schedule"/>
        <type value="token"/>
        <description value="Is the schedule in active use"/>
        <expression value="Schedule.active"/>
        <xpath value="f:Schedule/f:active"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Schedule-actor"/>
    <resource>
      <SearchParameter>
        <id value="Schedule-actor"/>
        <url value="http://hl7.org/fhir/SearchParameter/Schedule-actor"/>
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
        <base value="Schedule"/>
        <type value="reference"/>
        <description value="The individual(HealthcareService, Practitioner, Location, ...) to find a Schedule for"/>
        <expression value="Schedule.actor"/>
        <xpath value="f:Schedule/f:actor"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="Device"/>
        <target value="Patient"/>
        <target value="HealthcareService"/>
        <target value="PractitionerRole"/>
        <target value="RelatedPerson"/>
        <target value="Location"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Schedule-date"/>
    <resource>
      <SearchParameter>
        <id value="Schedule-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/Schedule-date"/>
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
        <base value="Schedule"/>
        <type value="date"/>
        <description value="Search for Schedule resources that have a period that contains this date specified"/>
        <expression value="Schedule.planningHorizon"/>
        <xpath value="f:Schedule/f:planningHorizon"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Schedule-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Schedule-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Schedule-identifier"/>
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
        <base value="Schedule"/>
        <type value="token"/>
        <description value="A Schedule Identifier"/>
        <expression value="Schedule.identifier"/>
        <xpath value="f:Schedule/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Schedule-type"/>
    <resource>
      <SearchParameter>
        <id value="Schedule-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/Schedule-type"/>
        <name value="type"/>
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
        <code value="type"/>
        <base value="Schedule"/>
        <type value="token"/>
        <description value="The type of appointments that can be booked into associated slot(s)"/>
        <expression value="Schedule.serviceType"/>
        <xpath value="f:Schedule/f:serviceType"/>
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
