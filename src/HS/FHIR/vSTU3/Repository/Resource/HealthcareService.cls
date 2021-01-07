Class HS.FHIR.vSTU3.Repository.Resource.HealthcareService Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-HealthcareService"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/HealthcareService-active"/>
    <resource>
      <SearchParameter>
        <id value="HealthcareService-active"/>
        <url value="http://hl7.org/fhir/SearchParameter/HealthcareService-active"/>
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
        <base value="HealthcareService"/>
        <type value="token"/>
        <description value="The Healthcare Service is currently marked as active"/>
        <expression value="HealthcareService.active"/>
        <xpath value="f:HealthcareService/f:active"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/HealthcareService-category"/>
    <resource>
      <SearchParameter>
        <id value="HealthcareService-category"/>
        <url value="http://hl7.org/fhir/SearchParameter/HealthcareService-category"/>
        <name value="category"/>
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
        <code value="category"/>
        <base value="HealthcareService"/>
        <type value="token"/>
        <description value="Service Category of the Healthcare Service"/>
        <expression value="HealthcareService.category"/>
        <xpath value="f:HealthcareService/f:category"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/HealthcareService-characteristic"/>
    <resource>
      <SearchParameter>
        <id value="HealthcareService-characteristic"/>
        <url value="http://hl7.org/fhir/SearchParameter/HealthcareService-characteristic"/>
        <name value="characteristic"/>
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
        <code value="characteristic"/>
        <base value="HealthcareService"/>
        <type value="token"/>
        <description value="One of the HealthcareService&apos;s characteristics"/>
        <expression value="HealthcareService.characteristic"/>
        <xpath value="f:HealthcareService/f:characteristic"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/HealthcareService-endpoint"/>
    <resource>
      <SearchParameter>
        <id value="HealthcareService-endpoint"/>
        <url value="http://hl7.org/fhir/SearchParameter/HealthcareService-endpoint"/>
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
        <base value="HealthcareService"/>
        <type value="reference"/>
        <description value="Technical endpoints providing access to services operated for the location"/>
        <expression value="HealthcareService.endpoint"/>
        <xpath value="f:HealthcareService/f:endpoint"/>
        <xpathUsage value="normal"/>
        <target value="Endpoint"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/HealthcareService-identifier"/>
    <resource>
      <SearchParameter>
        <id value="HealthcareService-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/HealthcareService-identifier"/>
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
        <base value="HealthcareService"/>
        <type value="token"/>
        <description value="External identifiers for this item"/>
        <expression value="HealthcareService.identifier"/>
        <xpath value="f:HealthcareService/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/HealthcareService-location"/>
    <resource>
      <SearchParameter>
        <id value="HealthcareService-location"/>
        <url value="http://hl7.org/fhir/SearchParameter/HealthcareService-location"/>
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
        <base value="HealthcareService"/>
        <type value="reference"/>
        <description value="The location of the Healthcare Service"/>
        <expression value="HealthcareService.location"/>
        <xpath value="f:HealthcareService/f:location"/>
        <xpathUsage value="normal"/>
        <target value="Location"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/HealthcareService-name"/>
    <resource>
      <SearchParameter>
        <id value="HealthcareService-name"/>
        <url value="http://hl7.org/fhir/SearchParameter/HealthcareService-name"/>
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
        <base value="HealthcareService"/>
        <type value="string"/>
        <description value="A portion of the Healthcare service name"/>
        <expression value="HealthcareService.name"/>
        <xpath value="f:HealthcareService/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/HealthcareService-organization"/>
    <resource>
      <SearchParameter>
        <id value="HealthcareService-organization"/>
        <url value="http://hl7.org/fhir/SearchParameter/HealthcareService-organization"/>
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
        <base value="HealthcareService"/>
        <type value="reference"/>
        <description value="The organization that provides this Healthcare Service"/>
        <expression value="HealthcareService.providedBy"/>
        <xpath value="f:HealthcareService/f:providedBy"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/HealthcareService-programname"/>
    <resource>
      <SearchParameter>
        <id value="HealthcareService-programname"/>
        <url value="http://hl7.org/fhir/SearchParameter/HealthcareService-programname"/>
        <name value="programname"/>
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
        <code value="programname"/>
        <base value="HealthcareService"/>
        <type value="string"/>
        <description value="One of the Program Names serviced by this HealthcareService"/>
        <expression value="HealthcareService.programName"/>
        <xpath value="f:HealthcareService/f:programName"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/HealthcareService-type"/>
    <resource>
      <SearchParameter>
        <id value="HealthcareService-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/HealthcareService-type"/>
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
        <base value="HealthcareService"/>
        <type value="token"/>
        <description value="The type of service provided by this healthcare service"/>
        <expression value="HealthcareService.type"/>
        <xpath value="f:HealthcareService/f:type"/>
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
