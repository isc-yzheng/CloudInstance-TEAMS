/// This class exists solely as a container for the SearchParams common to all
/// FHIR resource types. It is abstract and cannot be instantiated or used to
/// store data. The name was chosen over other options (Abstract, Common,
/// BaseResource, etc.) because the FHIR ResourceType value set 
/// (http://www.hl7.org/fhir/valueset-resource-types.html) contains the value
/// "Resource" as the abstract resource type that is the base for all other
/// types. So for example, SearchParameter resources that are meant to apply
/// to all resource types will have base="Resource".
Class HS.FHIR.vDSTU2.Repository.Resource.Resource [ Abstract ]
{

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Resource"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Resource-content"/>
    <resource>
      <SearchParameter>
        <id value="Resource-content"/>
        <url value="http://hl7.org/fhir/SearchParameter/Resource-content"/>
        <name value="_content"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="_content"/>
        <base value="Resource"/>
        <type value="string"/>
        <description value="Search on the entire content of the resource"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Resource-id"/>
    <resource>
      <SearchParameter>
        <id value="Resource-id"/>
        <url value="http://hl7.org/fhir/SearchParameter/Resource-id"/>
        <name value="_id"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="_id"/>
        <base value="Resource"/>
        <type value="token"/>
        <description value="Logical id of this artifact"/>
        <xpath value="f:Resource/f:id"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Resource-lastUpdated"/>
    <resource>
      <SearchParameter>
        <id value="Resource-lastUpdated"/>
        <url value="http://hl7.org/fhir/SearchParameter/Resource-lastUpdated"/>
        <name value="_lastUpdated"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="_lastUpdated"/>
        <base value="Resource"/>
        <type value="date"/>
        <description value="When the resource version last changed"/>
        <xpath value="f:Resource/f:meta/f:lastUpdated"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Resource-profile"/>
    <resource>
      <SearchParameter>
        <id value="Resource-profile"/>
        <url value="http://hl7.org/fhir/SearchParameter/Resource-profile"/>
        <name value="_profile"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="_profile"/>
        <base value="Resource"/>
        <type value="uri"/>
        <description value="Profiles this resource claims to conform to"/>
        <xpath value="f:Resource/f:meta/f:profile"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Resource-query"/>
    <resource>
      <SearchParameter>
        <id value="Resource-query"/>
        <url value="http://hl7.org/fhir/SearchParameter/Resource-query"/>
        <name value="_query"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="_query"/>
        <base value="Resource"/>
        <type value="token"/>
        <description value="A custom search profile that describes a specific defined query operation"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Resource-security"/>
    <resource>
      <SearchParameter>
        <id value="Resource-security"/>
        <url value="http://hl7.org/fhir/SearchParameter/Resource-security"/>
        <name value="_security"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="_security"/>
        <base value="Resource"/>
        <type value="token"/>
        <description value="Security Labels applied to this resource"/>
        <xpath value="f:Resource/f:meta/f:security"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Resource-tag"/>
    <resource>
      <SearchParameter>
        <id value="Resource-tag"/>
        <url value="http://hl7.org/fhir/SearchParameter/Resource-tag"/>
        <name value="_tag"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="_tag"/>
        <base value="Resource"/>
        <type value="token"/>
        <description value="Tags applied to this resource"/>
        <xpath value="f:Resource/f:meta/f:tag"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Resource-text"/>
    <resource>
      <SearchParameter>
        <id value="Resource-text"/>
        <url value="http://hl7.org/fhir/SearchParameter/Resource-text"/>
        <name value="_text"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="_text"/>
        <base value="Resource"/>
        <type value="string"/>
        <description value="Search on the narrative of the resource"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
