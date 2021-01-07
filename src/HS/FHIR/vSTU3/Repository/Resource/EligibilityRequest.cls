Class HS.FHIR.vSTU3.Repository.Resource.EligibilityRequest Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-EligibilityRequest"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EligibilityRequest-created"/>
    <resource>
      <SearchParameter>
        <id value="EligibilityRequest-created"/>
        <url value="http://hl7.org/fhir/SearchParameter/EligibilityRequest-created"/>
        <name value="created"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="created"/>
        <base value="EligibilityRequest"/>
        <type value="date"/>
        <description value="The creation date for the EOB"/>
        <expression value="EligibilityRequest.created"/>
        <xpath value="f:EligibilityRequest/f:created"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EligibilityRequest-enterer"/>
    <resource>
      <SearchParameter>
        <id value="EligibilityRequest-enterer"/>
        <url value="http://hl7.org/fhir/SearchParameter/EligibilityRequest-enterer"/>
        <name value="enterer"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="enterer"/>
        <base value="EligibilityRequest"/>
        <type value="reference"/>
        <description value="The party who is responsible for the request"/>
        <expression value="EligibilityRequest.enterer"/>
        <xpath value="f:EligibilityRequest/f:enterer"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EligibilityRequest-facility"/>
    <resource>
      <SearchParameter>
        <id value="EligibilityRequest-facility"/>
        <url value="http://hl7.org/fhir/SearchParameter/EligibilityRequest-facility"/>
        <name value="facility"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="facility"/>
        <base value="EligibilityRequest"/>
        <type value="reference"/>
        <description value="Facility responsible for the goods and services"/>
        <expression value="EligibilityRequest.facility"/>
        <xpath value="f:EligibilityRequest/f:facility"/>
        <xpathUsage value="normal"/>
        <target value="Location"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EligibilityRequest-identifier"/>
    <resource>
      <SearchParameter>
        <id value="EligibilityRequest-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/EligibilityRequest-identifier"/>
        <name value="identifier"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="identifier"/>
        <base value="EligibilityRequest"/>
        <type value="token"/>
        <description value="The business identifier of the Eligibility"/>
        <expression value="EligibilityRequest.identifier"/>
        <xpath value="f:EligibilityRequest/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EligibilityRequest-organization"/>
    <resource>
      <SearchParameter>
        <id value="EligibilityRequest-organization"/>
        <url value="http://hl7.org/fhir/SearchParameter/EligibilityRequest-organization"/>
        <name value="organization"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="organization"/>
        <base value="EligibilityRequest"/>
        <type value="reference"/>
        <description value="The reference to the providing organization"/>
        <expression value="EligibilityRequest.organization"/>
        <xpath value="f:EligibilityRequest/f:organization"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EligibilityRequest-patient"/>
    <resource>
      <SearchParameter>
        <id value="EligibilityRequest-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/EligibilityRequest-patient"/>
        <name value="patient"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="patient"/>
        <base value="EligibilityRequest"/>
        <type value="reference"/>
        <description value="The reference to the patient"/>
        <expression value="EligibilityRequest.patient"/>
        <xpath value="f:EligibilityRequest/f:patient"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EligibilityRequest-provider"/>
    <resource>
      <SearchParameter>
        <id value="EligibilityRequest-provider"/>
        <url value="http://hl7.org/fhir/SearchParameter/EligibilityRequest-provider"/>
        <name value="provider"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="provider"/>
        <base value="EligibilityRequest"/>
        <type value="reference"/>
        <description value="The reference to the provider"/>
        <expression value="EligibilityRequest.provider"/>
        <xpath value="f:EligibilityRequest/f:provider"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
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
