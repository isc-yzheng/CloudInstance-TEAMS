Class HS.FHIR.vSTU3.Repository.Resource.Location Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

/// These two parameters are intended to be used together. "near" is meant to
/// be latitude and longitude coordinates, and "near-distance" is meant to be
/// a search radius. The response is supposed to contain all Locations that are
/// within "near-distance" of the "near" coordinates. Support may be added for
/// these parameters in a future version. For now they are not supported.
Parameter EXCLUDEPARAMS = ",near,near-distance,";

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Location"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Location-address"/>
    <resource>
      <SearchParameter>
        <id value="Location-address"/>
        <url value="http://hl7.org/fhir/SearchParameter/Location-address"/>
        <name value="address"/>
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
        <code value="address"/>
        <base value="Location"/>
        <type value="string"/>
        <description value="A (part of the) address of the location"/>
        <expression value="Location.address"/>
        <xpath value="f:Location/f:address"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Location-address-city"/>
    <resource>
      <SearchParameter>
        <id value="Location-address-city"/>
        <url value="http://hl7.org/fhir/SearchParameter/Location-address-city"/>
        <name value="address-city"/>
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
        <code value="address-city"/>
        <base value="Location"/>
        <type value="string"/>
        <description value="A city specified in an address"/>
        <expression value="Location.address.city"/>
        <xpath value="f:Location/f:address/f:city"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Location-address-country"/>
    <resource>
      <SearchParameter>
        <id value="Location-address-country"/>
        <url value="http://hl7.org/fhir/SearchParameter/Location-address-country"/>
        <name value="address-country"/>
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
        <code value="address-country"/>
        <base value="Location"/>
        <type value="string"/>
        <description value="A country specified in an address"/>
        <expression value="Location.address.country"/>
        <xpath value="f:Location/f:address/f:country"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Location-address-postalcode"/>
    <resource>
      <SearchParameter>
        <id value="Location-address-postalcode"/>
        <url value="http://hl7.org/fhir/SearchParameter/Location-address-postalcode"/>
        <name value="address-postalcode"/>
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
        <code value="address-postalcode"/>
        <base value="Location"/>
        <type value="string"/>
        <description value="A postal code specified in an address"/>
        <expression value="Location.address.postalCode"/>
        <xpath value="f:Location/f:address/f:postalCode"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Location-address-state"/>
    <resource>
      <SearchParameter>
        <id value="Location-address-state"/>
        <url value="http://hl7.org/fhir/SearchParameter/Location-address-state"/>
        <name value="address-state"/>
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
        <code value="address-state"/>
        <base value="Location"/>
        <type value="string"/>
        <description value="A state specified in an address"/>
        <expression value="Location.address.state"/>
        <xpath value="f:Location/f:address/f:state"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Location-address-use"/>
    <resource>
      <SearchParameter>
        <id value="Location-address-use"/>
        <url value="http://hl7.org/fhir/SearchParameter/Location-address-use"/>
        <name value="address-use"/>
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
        <code value="address-use"/>
        <base value="Location"/>
        <type value="token"/>
        <description value="A use code specified in an address"/>
        <expression value="Location.address.use"/>
        <xpath value="f:Location/f:address/f:use"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Location-endpoint"/>
    <resource>
      <SearchParameter>
        <id value="Location-endpoint"/>
        <url value="http://hl7.org/fhir/SearchParameter/Location-endpoint"/>
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
        <base value="Location"/>
        <type value="reference"/>
        <description value="Technical endpoints providing access to services operated for the location"/>
        <expression value="Location.endpoint"/>
        <xpath value="f:Location/f:endpoint"/>
        <xpathUsage value="normal"/>
        <target value="Endpoint"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Location-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Location-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Location-identifier"/>
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
        <base value="Location"/>
        <type value="token"/>
        <description value="An identifier for the location"/>
        <expression value="Location.identifier"/>
        <xpath value="f:Location/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Location-name"/>
    <resource>
      <SearchParameter>
        <id value="Location-name"/>
        <url value="http://hl7.org/fhir/SearchParameter/Location-name"/>
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
        <base value="Location"/>
        <type value="string"/>
        <description value="A portion of the location&apos;s name or alias"/>
        <expression value="Location.name | Location.alias"/>
        <xpath value="f:Location/f:name | f:Location/f:alias"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Location-near"/>
    <resource>
      <SearchParameter>
        <id value="Location-near"/>
        <url value="http://hl7.org/fhir/SearchParameter/Location-near"/>
        <name value="near"/>
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
        <code value="near"/>
        <base value="Location"/>
        <type value="token"/>
        <description value="The coordinates expressed as [latitude]:[longitude] (using the WGS84 datum, see notes) to find locations near to (servers may search using a square rather than a circle for efficiency)

Requires the near-distance parameter to be provided also"/>
        <expression value="Location.position"/>
        <xpath value="f:Location/f:position"/>
        <xpathUsage value="nearby"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Location-near-distance"/>
    <resource>
      <SearchParameter>
        <id value="Location-near-distance"/>
        <url value="http://hl7.org/fhir/SearchParameter/Location-near-distance"/>
        <name value="near-distance"/>
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
        <code value="near-distance"/>
        <base value="Location"/>
        <type value="quantity"/>
        <description value="A distance quantity to limit the near search to locations within a specific distance

Requires the near parameter to also be included"/>
        <expression value="Location.position"/>
        <xpath value="f:Location/f:position"/>
        <xpathUsage value="distance"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Location-operational-status"/>
    <resource>
      <SearchParameter>
        <id value="Location-operational-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/Location-operational-status"/>
        <name value="operational-status"/>
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
        <code value="operational-status"/>
        <base value="Location"/>
        <type value="token"/>
        <description value="Searches for locations (typically bed/room) that have an operational status (e.g. contaminated, housekeeping)"/>
        <expression value="Location.operationalStatus"/>
        <xpath value="f:Location/f:operationalStatus"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Location-organization"/>
    <resource>
      <SearchParameter>
        <id value="Location-organization"/>
        <url value="http://hl7.org/fhir/SearchParameter/Location-organization"/>
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
        <base value="Location"/>
        <type value="reference"/>
        <description value="Searches for locations that are managed by the provided organization"/>
        <expression value="Location.managingOrganization"/>
        <xpath value="f:Location/f:managingOrganization"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Location-partof"/>
    <resource>
      <SearchParameter>
        <id value="Location-partof"/>
        <url value="http://hl7.org/fhir/SearchParameter/Location-partof"/>
        <name value="partof"/>
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
        <code value="partof"/>
        <base value="Location"/>
        <type value="reference"/>
        <description value="A location of which this location is a part"/>
        <expression value="Location.partOf"/>
        <xpath value="f:Location/f:partOf"/>
        <xpathUsage value="normal"/>
        <target value="Location"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Location-status"/>
    <resource>
      <SearchParameter>
        <id value="Location-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/Location-status"/>
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
        <base value="Location"/>
        <type value="token"/>
        <description value="Searches for locations with a specific kind of status"/>
        <expression value="Location.status"/>
        <xpath value="f:Location/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Location-type"/>
    <resource>
      <SearchParameter>
        <id value="Location-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/Location-type"/>
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
        <base value="Location"/>
        <type value="token"/>
        <description value="A code for the type of location"/>
        <expression value="Location.type"/>
        <xpath value="f:Location/f:type"/>
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
