Class HS.FHIR.vSTU3.Repository.Resource.ExplanationOfBenefit Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-ExplanationOfBenefit"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ExplanationOfBenefit-care-team"/>
    <resource>
      <SearchParameter>
        <id value="ExplanationOfBenefit-care-team"/>
        <url value="http://hl7.org/fhir/SearchParameter/ExplanationOfBenefit-care-team"/>
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
        <base value="ExplanationOfBenefit"/>
        <type value="reference"/>
        <description value="Member of the CareTeam"/>
        <expression value="ExplanationOfBenefit.careTeam.provider"/>
        <xpath value="f:ExplanationOfBenefit/f:careTeam/f:provider"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ExplanationOfBenefit-claim"/>
    <resource>
      <SearchParameter>
        <id value="ExplanationOfBenefit-claim"/>
        <url value="http://hl7.org/fhir/SearchParameter/ExplanationOfBenefit-claim"/>
        <name value="claim"/>
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
        <code value="claim"/>
        <base value="ExplanationOfBenefit"/>
        <type value="reference"/>
        <description value="The reference to the claim"/>
        <expression value="ExplanationOfBenefit.claim"/>
        <xpath value="f:ExplanationOfBenefit/f:claim"/>
        <xpathUsage value="normal"/>
        <target value="Claim"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ExplanationOfBenefit-coverage"/>
    <resource>
      <SearchParameter>
        <id value="ExplanationOfBenefit-coverage"/>
        <url value="http://hl7.org/fhir/SearchParameter/ExplanationOfBenefit-coverage"/>
        <name value="coverage"/>
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
        <code value="coverage"/>
        <base value="ExplanationOfBenefit"/>
        <type value="reference"/>
        <description value="The plan under which the claim was adjudicated"/>
        <expression value="ExplanationOfBenefit.insurance.coverage"/>
        <xpath value="f:ExplanationOfBenefit/f:insurance/f:coverage"/>
        <xpathUsage value="normal"/>
        <target value="Coverage"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ExplanationOfBenefit-created"/>
    <resource>
      <SearchParameter>
        <id value="ExplanationOfBenefit-created"/>
        <url value="http://hl7.org/fhir/SearchParameter/ExplanationOfBenefit-created"/>
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
        <base value="ExplanationOfBenefit"/>
        <type value="date"/>
        <description value="The creation date for the EOB"/>
        <expression value="ExplanationOfBenefit.created"/>
        <xpath value="f:ExplanationOfBenefit/f:created"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ExplanationOfBenefit-disposition"/>
    <resource>
      <SearchParameter>
        <id value="ExplanationOfBenefit-disposition"/>
        <url value="http://hl7.org/fhir/SearchParameter/ExplanationOfBenefit-disposition"/>
        <name value="disposition"/>
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
        <code value="disposition"/>
        <base value="ExplanationOfBenefit"/>
        <type value="string"/>
        <description value="The contents of the disposition message"/>
        <expression value="ExplanationOfBenefit.disposition"/>
        <xpath value="f:ExplanationOfBenefit/f:disposition"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ExplanationOfBenefit-encounter"/>
    <resource>
      <SearchParameter>
        <id value="ExplanationOfBenefit-encounter"/>
        <url value="http://hl7.org/fhir/SearchParameter/ExplanationOfBenefit-encounter"/>
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
        <base value="ExplanationOfBenefit"/>
        <type value="reference"/>
        <description value="Encounters associated with a billed line item"/>
        <expression value="ExplanationOfBenefit.item.encounter"/>
        <xpath value="f:ExplanationOfBenefit/f:item/f:encounter"/>
        <xpathUsage value="normal"/>
        <target value="Encounter"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ExplanationOfBenefit-enterer"/>
    <resource>
      <SearchParameter>
        <id value="ExplanationOfBenefit-enterer"/>
        <url value="http://hl7.org/fhir/SearchParameter/ExplanationOfBenefit-enterer"/>
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
        <base value="ExplanationOfBenefit"/>
        <type value="reference"/>
        <description value="The party responsible for the entry of the Claim"/>
        <expression value="ExplanationOfBenefit.enterer"/>
        <xpath value="f:ExplanationOfBenefit/f:enterer"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ExplanationOfBenefit-facility"/>
    <resource>
      <SearchParameter>
        <id value="ExplanationOfBenefit-facility"/>
        <url value="http://hl7.org/fhir/SearchParameter/ExplanationOfBenefit-facility"/>
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
        <base value="ExplanationOfBenefit"/>
        <type value="reference"/>
        <description value="Facility responsible for the goods and services"/>
        <expression value="ExplanationOfBenefit.facility"/>
        <xpath value="f:ExplanationOfBenefit/f:facility"/>
        <xpathUsage value="normal"/>
        <target value="Location"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ExplanationOfBenefit-identifier"/>
    <resource>
      <SearchParameter>
        <id value="ExplanationOfBenefit-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/ExplanationOfBenefit-identifier"/>
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
        <base value="ExplanationOfBenefit"/>
        <type value="token"/>
        <description value="The business identifier of the Explanation of Benefit"/>
        <expression value="ExplanationOfBenefit.identifier"/>
        <xpath value="f:ExplanationOfBenefit/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ExplanationOfBenefit-organization"/>
    <resource>
      <SearchParameter>
        <id value="ExplanationOfBenefit-organization"/>
        <url value="http://hl7.org/fhir/SearchParameter/ExplanationOfBenefit-organization"/>
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
        <base value="ExplanationOfBenefit"/>
        <type value="reference"/>
        <description value="The reference to the providing organization"/>
        <expression value="ExplanationOfBenefit.organization"/>
        <xpath value="f:ExplanationOfBenefit/f:organization"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ExplanationOfBenefit-patient"/>
    <resource>
      <SearchParameter>
        <id value="ExplanationOfBenefit-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/ExplanationOfBenefit-patient"/>
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
        <base value="ExplanationOfBenefit"/>
        <type value="reference"/>
        <description value="The reference to the patient"/>
        <expression value="ExplanationOfBenefit.patient"/>
        <xpath value="f:ExplanationOfBenefit/f:patient"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ExplanationOfBenefit-payee"/>
    <resource>
      <SearchParameter>
        <id value="ExplanationOfBenefit-payee"/>
        <url value="http://hl7.org/fhir/SearchParameter/ExplanationOfBenefit-payee"/>
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
        <base value="ExplanationOfBenefit"/>
        <type value="reference"/>
        <description value="The party receiving any payment for the Claim"/>
        <expression value="ExplanationOfBenefit.payee.party"/>
        <xpath value="f:ExplanationOfBenefit/f:payee/f:party"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="Organization"/>
        <target value="Patient"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ExplanationOfBenefit-provider"/>
    <resource>
      <SearchParameter>
        <id value="ExplanationOfBenefit-provider"/>
        <url value="http://hl7.org/fhir/SearchParameter/ExplanationOfBenefit-provider"/>
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
        <base value="ExplanationOfBenefit"/>
        <type value="reference"/>
        <description value="The reference to the provider"/>
        <expression value="ExplanationOfBenefit.provider"/>
        <xpath value="f:ExplanationOfBenefit/f:provider"/>
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
