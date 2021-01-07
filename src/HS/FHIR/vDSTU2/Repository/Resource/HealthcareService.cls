Class HS.FHIR.vDSTU2.Repository.Resource.HealthcareService Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-HealthcareService"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/HealthcareService-characteristic"/>
    <resource>
      <SearchParameter>
        <id value="HealthcareService-characteristic"/>
        <url value="http://hl7.org/fhir/SearchParameter/HealthcareService-characteristic"/>
        <name value="characteristic"/>
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
        <code value="characteristic"/>
        <base value="HealthcareService"/>
        <type value="token"/>
        <description value="One of the HealthcareService&apos;s characteristics"/>
        <xpath value="f:HealthcareService/f:characteristic"/>
        <xpathUsage value="normal"/>
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
        <base value="HealthcareService"/>
        <type value="token"/>
        <description value="External identifiers for this item"/>
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
        <code value="location"/>
        <base value="HealthcareService"/>
        <type value="reference"/>
        <description value="The location of the Healthcare Service"/>
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
        <base value="HealthcareService"/>
        <type value="string"/>
        <description value="A portion of the Healthcare service name"/>
        <xpath value="f:HealthcareService/f:serviceName"/>
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
        <base value="HealthcareService"/>
        <type value="reference"/>
        <description value="The organization that provides this Healthcare Service"/>
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
        <code value="programname"/>
        <base value="HealthcareService"/>
        <type value="string"/>
        <description value="One of the Program Names serviced by this HealthcareService"/>
        <xpath value="f:HealthcareService/f:programName"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/HealthcareService-servicecategory"/>
    <resource>
      <SearchParameter>
        <id value="HealthcareService-servicecategory"/>
        <url value="http://hl7.org/fhir/SearchParameter/HealthcareService-servicecategory"/>
        <name value="servicecategory"/>
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
        <code value="servicecategory"/>
        <base value="HealthcareService"/>
        <type value="token"/>
        <description value="Service Category of the Healthcare Service"/>
        <xpath value="f:HealthcareService/f:serviceCategory"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/HealthcareService-servicetype"/>
    <resource>
      <SearchParameter>
        <id value="HealthcareService-servicetype"/>
        <url value="http://hl7.org/fhir/SearchParameter/HealthcareService-servicetype"/>
        <name value="servicetype"/>
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
        <code value="servicetype"/>
        <base value="HealthcareService"/>
        <type value="token"/>
        <description value="The type of service provided by this healthcare service"/>
        <xpath value="f:HealthcareService/f:serviceType/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
