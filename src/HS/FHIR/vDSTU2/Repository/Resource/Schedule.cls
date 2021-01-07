Class HS.FHIR.vDSTU2.Repository.Resource.Schedule Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Schedule"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Schedule-actor"/>
    <resource>
      <SearchParameter>
        <id value="Schedule-actor"/>
        <url value="http://hl7.org/fhir/SearchParameter/Schedule-actor"/>
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
        <base value="Schedule"/>
        <type value="reference"/>
        <description value="The individual(HealthcareService, Practitioner, Location, ...) to find a Schedule for"/>
        <xpath value="f:Schedule/f:actor"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Schedule-date"/>
    <resource>
      <SearchParameter>
        <id value="Schedule-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/Schedule-date"/>
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
        <base value="Schedule"/>
        <type value="date"/>
        <description value="Search for Schedule resources that have a period that contains this date specified"/>
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
        <base value="Schedule"/>
        <type value="token"/>
        <description value="A Schedule Identifier"/>
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
        <code value="type"/>
        <base value="Schedule"/>
        <type value="token"/>
        <description value="The type of appointments that can be booked into associated slot(s)"/>
        <xpath value="f:Schedule/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
