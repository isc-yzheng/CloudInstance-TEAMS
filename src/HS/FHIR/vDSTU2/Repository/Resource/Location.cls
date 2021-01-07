Class HS.FHIR.vDSTU2.Repository.Resource.Location Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

/// These two parameters are intended to be used together. "near" is meant to
/// be latitude and longitude coordinates, and "near-distance" is meant to be
/// a search radius. The response is supposed to contain all Locations that are
/// within "near-distance" of the "near" coordinates. Support may be added for
/// these parameters in a future version. For now they are not supported.
Parameter EXCLUDEPARAMS = ",near,near-distance,";

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Location"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Location-address"/>
    <resource>
      <SearchParameter>
        <id value="Location-address"/>
        <url value="http://hl7.org/fhir/SearchParameter/Location-address"/>
        <name value="address"/>
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
        <code value="address"/>
        <base value="Location"/>
        <type value="string"/>
        <description value="A (part of the) address of the location"/>
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
        <code value="address-city"/>
        <base value="Location"/>
        <type value="string"/>
        <description value="A city specified in an address"/>
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
        <code value="address-country"/>
        <base value="Location"/>
        <type value="string"/>
        <description value="A country specified in an address"/>
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
        <code value="address-postalcode"/>
        <base value="Location"/>
        <type value="string"/>
        <description value="A postal code specified in an address"/>
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
        <code value="address-state"/>
        <base value="Location"/>
        <type value="string"/>
        <description value="A state specified in an address"/>
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
        <code value="address-use"/>
        <base value="Location"/>
        <type value="token"/>
        <description value="A use code specified in an address"/>
        <xpath value="f:Location/f:address/f:use"/>
        <xpathUsage value="normal"/>
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
        <base value="Location"/>
        <type value="token"/>
        <description value="Unique code or number identifying the location to its users"/>
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
        <code value="name"/>
        <base value="Location"/>
        <type value="string"/>
        <description value="A (portion of the) name of the location"/>
        <xpath value="f:Location/f:name"/>
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
        <code value="near"/>
        <base value="Location"/>
        <type value="token"/>
        <description value="The coordinates expressed as [lat],[long] (using the WGS84 datum, see notes) to find locations near to (servers may search using a square rather than a circle for efficiency)"/>
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
        <code value="near-distance"/>
        <base value="Location"/>
        <type value="token"/>
        <description value="A distance quantity to limit the near search to locations within a specific distance"/>
        <xpath value="f:Location/f:position"/>
        <xpathUsage value="distance"/>
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
        <code value="organization"/>
        <base value="Location"/>
        <type value="reference"/>
        <description value="Searches for locations that are managed by the provided organization"/>
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
        <code value="partof"/>
        <base value="Location"/>
        <type value="reference"/>
        <description value="The location of which this location is a part"/>
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
        <base value="Location"/>
        <type value="token"/>
        <description value="Searches for locations with a specific kind of status"/>
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
        <base value="Location"/>
        <type value="token"/>
        <description value="A code for the type of location"/>
        <xpath value="f:Location/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
