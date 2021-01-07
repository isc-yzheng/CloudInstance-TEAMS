Class HS.FHIR.vDSTU2.Repository.Resource.ReferralRequest Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-ReferralRequest"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ReferralRequest-date"/>
    <resource>
      <SearchParameter>
        <id value="ReferralRequest-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/ReferralRequest-date"/>
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
        <base value="ReferralRequest"/>
        <type value="date"/>
        <description value="Creation or activation date"/>
        <xpath value="f:ReferralRequest/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ReferralRequest-patient"/>
    <resource>
      <SearchParameter>
        <id value="ReferralRequest-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/ReferralRequest-patient"/>
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
        <base value="ReferralRequest"/>
        <type value="reference"/>
        <description value="Who the referral is about"/>
        <xpath value="f:ReferralRequest/f:patient"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ReferralRequest-priority"/>
    <resource>
      <SearchParameter>
        <id value="ReferralRequest-priority"/>
        <url value="http://hl7.org/fhir/SearchParameter/ReferralRequest-priority"/>
        <name value="priority"/>
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
        <code value="priority"/>
        <base value="ReferralRequest"/>
        <type value="token"/>
        <description value="The priority assigned to the referral"/>
        <xpath value="f:ReferralRequest/f:priority"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ReferralRequest-recipient"/>
    <resource>
      <SearchParameter>
        <id value="ReferralRequest-recipient"/>
        <url value="http://hl7.org/fhir/SearchParameter/ReferralRequest-recipient"/>
        <name value="recipient"/>
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
        <code value="recipient"/>
        <base value="ReferralRequest"/>
        <type value="reference"/>
        <description value="The person that the referral was sent to"/>
        <xpath value="f:ReferralRequest/f:recipient"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ReferralRequest-requester"/>
    <resource>
      <SearchParameter>
        <id value="ReferralRequest-requester"/>
        <url value="http://hl7.org/fhir/SearchParameter/ReferralRequest-requester"/>
        <name value="requester"/>
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
        <code value="requester"/>
        <base value="ReferralRequest"/>
        <type value="reference"/>
        <description value="Requester of referral / transfer of care"/>
        <xpath value="f:ReferralRequest/f:requester"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
        <target value="Organization"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ReferralRequest-specialty"/>
    <resource>
      <SearchParameter>
        <id value="ReferralRequest-specialty"/>
        <url value="http://hl7.org/fhir/SearchParameter/ReferralRequest-specialty"/>
        <name value="specialty"/>
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
        <code value="specialty"/>
        <base value="ReferralRequest"/>
        <type value="token"/>
        <description value="The specialty that the referral is for"/>
        <xpath value="f:ReferralRequest/f:specialty"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ReferralRequest-status"/>
    <resource>
      <SearchParameter>
        <id value="ReferralRequest-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/ReferralRequest-status"/>
        <name value="status"/>
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
        <code value="status"/>
        <base value="ReferralRequest"/>
        <type value="token"/>
        <description value="The status of the referral"/>
        <xpath value="f:ReferralRequest/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ReferralRequest-type"/>
    <resource>
      <SearchParameter>
        <id value="ReferralRequest-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/ReferralRequest-type"/>
        <name value="type"/>
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
        <code value="type"/>
        <base value="ReferralRequest"/>
        <type value="token"/>
        <description value="The type of the referral"/>
        <xpath value="f:ReferralRequest/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
