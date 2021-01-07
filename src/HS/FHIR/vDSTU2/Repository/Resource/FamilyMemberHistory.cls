Class HS.FHIR.vDSTU2.Repository.Resource.FamilyMemberHistory Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-FamilyMemberHistory"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/FamilyMemberHistory-code"/>
    <resource>
      <SearchParameter>
        <id value="FamilyMemberHistory-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/FamilyMemberHistory-code"/>
        <name value="code"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="code"/>
        <base value="FamilyMemberHistory"/>
        <type value="token"/>
        <description value="A search by a condition code"/>
        <xpath value="f:FamilyMemberHistory/f:condition/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/FamilyMemberHistory-date"/>
    <resource>
      <SearchParameter>
        <id value="FamilyMemberHistory-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/FamilyMemberHistory-date"/>
        <name value="date"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="date"/>
        <base value="FamilyMemberHistory"/>
        <type value="date"/>
        <description value="When history was captured/updated"/>
        <xpath value="f:FamilyMemberHistory/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/FamilyMemberHistory-gender"/>
    <resource>
      <SearchParameter>
        <id value="FamilyMemberHistory-gender"/>
        <url value="http://hl7.org/fhir/SearchParameter/FamilyMemberHistory-gender"/>
        <name value="gender"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="gender"/>
        <base value="FamilyMemberHistory"/>
        <type value="token"/>
        <description value="A search by a gender code of a family member"/>
        <xpath value="f:FamilyMemberHistory/f:gender"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/FamilyMemberHistory-identifier"/>
    <resource>
      <SearchParameter>
        <id value="FamilyMemberHistory-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/FamilyMemberHistory-identifier"/>
        <name value="identifier"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="identifier"/>
        <base value="FamilyMemberHistory"/>
        <type value="token"/>
        <description value="A search by a record identifier"/>
        <xpath value="f:FamilyMemberHistory/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/FamilyMemberHistory-patient"/>
    <resource>
      <SearchParameter>
        <id value="FamilyMemberHistory-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/FamilyMemberHistory-patient"/>
        <name value="patient"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="patient"/>
        <base value="FamilyMemberHistory"/>
        <type value="reference"/>
        <description value="The identity of a subject to list family member history items for"/>
        <xpath value="f:FamilyMemberHistory/f:patient"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/FamilyMemberHistory-relationship"/>
    <resource>
      <SearchParameter>
        <id value="FamilyMemberHistory-relationship"/>
        <url value="http://hl7.org/fhir/SearchParameter/FamilyMemberHistory-relationship"/>
        <name value="relationship"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="relationship"/>
        <base value="FamilyMemberHistory"/>
        <type value="token"/>
        <description value="A search by a relationship type"/>
        <xpath value="f:FamilyMemberHistory/f:relationship"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
