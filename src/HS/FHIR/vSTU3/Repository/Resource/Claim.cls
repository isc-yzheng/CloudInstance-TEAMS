Class HS.FHIR.vSTU3.Repository.Resource.Claim Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Claim"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Claim-care-team"/>
    <resource>
      <SearchParameter>
        <id value="Claim-care-team"/>
        <url value="http://hl7.org/fhir/SearchParameter/Claim-care-team"/>
        <name value="care-team"/>
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
        <code value="care-team"/>
        <base value="Claim"/>
        <type value="reference"/>
        <description value="Member of the CareTeam"/>
        <expression value="Claim.careTeam.provider"/>
        <xpath value="f:Claim/f:careTeam/f:provider"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Claim-created"/>
    <resource>
      <SearchParameter>
        <id value="Claim-created"/>
        <url value="http://hl7.org/fhir/SearchParameter/Claim-created"/>
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
        <base value="Claim"/>
        <type value="date"/>
        <description value="The creation date for the Claim"/>
        <expression value="Claim.created"/>
        <xpath value="f:Claim/f:created"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Claim-encounter"/>
    <resource>
      <SearchParameter>
        <id value="Claim-encounter"/>
        <url value="http://hl7.org/fhir/SearchParameter/Claim-encounter"/>
        <name value="encounter"/>
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
        <code value="encounter"/>
        <base value="Claim"/>
        <type value="reference"/>
        <description value="Encounters associated with a billed line item"/>
        <expression value="Claim.item.encounter"/>
        <xpath value="f:Claim/f:item/f:encounter"/>
        <xpathUsage value="normal"/>
        <target value="Encounter"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Claim-enterer"/>
    <resource>
      <SearchParameter>
        <id value="Claim-enterer"/>
        <url value="http://hl7.org/fhir/SearchParameter/Claim-enterer"/>
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
        <base value="Claim"/>
        <type value="reference"/>
        <description value="The party responsible for the entry of the Claim"/>
        <expression value="Claim.enterer"/>
        <xpath value="f:Claim/f:enterer"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Claim-facility"/>
    <resource>
      <SearchParameter>
        <id value="Claim-facility"/>
        <url value="http://hl7.org/fhir/SearchParameter/Claim-facility"/>
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
        <base value="Claim"/>
        <type value="reference"/>
        <description value="Facility responsible for the goods and services"/>
        <expression value="Claim.facility"/>
        <xpath value="f:Claim/f:facility"/>
        <xpathUsage value="normal"/>
        <target value="Location"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Claim-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Claim-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Claim-identifier"/>
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
        <base value="Claim"/>
        <type value="token"/>
        <description value="The primary identifier of the financial resource"/>
        <expression value="Claim.identifier"/>
        <xpath value="f:Claim/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Claim-insurer"/>
    <resource>
      <SearchParameter>
        <id value="Claim-insurer"/>
        <url value="http://hl7.org/fhir/SearchParameter/Claim-insurer"/>
        <name value="insurer"/>
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
        <code value="insurer"/>
        <base value="Claim"/>
        <type value="reference"/>
        <description value="The target payor/insurer for the Claim"/>
        <expression value="Claim.insurer"/>
        <xpath value="f:Claim/f:insurer"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Claim-organization"/>
    <resource>
      <SearchParameter>
        <id value="Claim-organization"/>
        <url value="http://hl7.org/fhir/SearchParameter/Claim-organization"/>
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
        <base value="Claim"/>
        <type value="reference"/>
        <description value="The reference to the providing organization"/>
        <expression value="Claim.organization"/>
        <xpath value="f:Claim/f:organization"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Claim-patient"/>
    <resource>
      <SearchParameter>
        <id value="Claim-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/Claim-patient"/>
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
        <base value="Claim"/>
        <type value="reference"/>
        <description value="Patient receiving the services"/>
        <expression value="Claim.patient"/>
        <xpath value="f:Claim/f:patient"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Claim-payee"/>
    <resource>
      <SearchParameter>
        <id value="Claim-payee"/>
        <url value="http://hl7.org/fhir/SearchParameter/Claim-payee"/>
        <name value="payee"/>
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
        <code value="payee"/>
        <base value="Claim"/>
        <type value="reference"/>
        <description value="The party receiving any payment for the Claim"/>
        <expression value="Claim.payee.party"/>
        <xpath value="f:Claim/f:payee/f:party"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="Organization"/>
        <target value="Patient"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Claim-priority"/>
    <resource>
      <SearchParameter>
        <id value="Claim-priority"/>
        <url value="http://hl7.org/fhir/SearchParameter/Claim-priority"/>
        <name value="priority"/>
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
        <code value="priority"/>
        <base value="Claim"/>
        <type value="token"/>
        <description value="Processing priority requested"/>
        <expression value="Claim.priority"/>
        <xpath value="f:Claim/f:priority"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Claim-provider"/>
    <resource>
      <SearchParameter>
        <id value="Claim-provider"/>
        <url value="http://hl7.org/fhir/SearchParameter/Claim-provider"/>
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
        <base value="Claim"/>
        <type value="reference"/>
        <description value="Provider responsible for the Claim"/>
        <expression value="Claim.provider"/>
        <xpath value="f:Claim/f:provider"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Claim-use"/>
    <resource>
      <SearchParameter>
        <id value="Claim-use"/>
        <url value="http://hl7.org/fhir/SearchParameter/Claim-use"/>
        <name value="use"/>
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
        <code value="use"/>
        <base value="Claim"/>
        <type value="token"/>
        <description value="The kind of financial resource"/>
        <expression value="Claim.use"/>
        <xpath value="f:Claim/f:use"/>
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
