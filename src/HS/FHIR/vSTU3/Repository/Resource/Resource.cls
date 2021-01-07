Class HS.FHIR.vSTU3.Repository.Resource.Resource Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Resource"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Resource-content"/>
    <resource>
      <SearchParameter>
        <id value="Resource-content"/>
        <url value="http://hl7.org/fhir/SearchParameter/Resource-content"/>
        <name value="_content"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="_content"/>
        <base value="Resource"/>
        <type value="string"/>
        <description value="Search on the entire content of the resource"/>
        <xpathUsage value="normal"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="_id"/>
        <base value="Resource"/>
        <type value="token"/>
        <description value="Logical id of this artifact"/>
        <expression value="Resource.id"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="_lastUpdated"/>
        <base value="Resource"/>
        <type value="date"/>
        <description value="When the resource version last changed"/>
        <expression value="Resource.meta.lastUpdated"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="_profile"/>
        <base value="Resource"/>
        <type value="uri"/>
        <description value="Profiles this resource claims to conform to"/>
        <expression value="Resource.meta.profile"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="_query"/>
        <base value="Resource"/>
        <type value="token"/>
        <description value="A custom search profile that describes a specific defined query operation"/>
        <xpathUsage value="normal"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="_security"/>
        <base value="Resource"/>
        <type value="token"/>
        <description value="Security Labels applied to this resource"/>
        <expression value="Resource.meta.security"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="_tag"/>
        <base value="Resource"/>
        <type value="token"/>
        <description value="Tags applied to this resource"/>
        <expression value="Resource.meta.tag"/>
        <xpath value="f:Resource/f:meta/f:tag"/>
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
