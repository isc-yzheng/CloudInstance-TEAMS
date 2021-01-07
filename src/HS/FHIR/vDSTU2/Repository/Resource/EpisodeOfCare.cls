Class HS.FHIR.vDSTU2.Repository.Resource.EpisodeOfCare Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-EpisodeOfCare"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EpisodeOfCare-care-manager"/>
    <resource>
      <SearchParameter>
        <id value="EpisodeOfCare-care-manager"/>
        <url value="http://hl7.org/fhir/SearchParameter/EpisodeOfCare-care-manager"/>
        <name value="care-manager"/>
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
        <code value="care-manager"/>
        <base value="EpisodeOfCare"/>
        <type value="reference"/>
        <description value="Care manager/care co-ordinator for the patient"/>
        <xpath value="f:EpisodeOfCare/f:careManager"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EpisodeOfCare-condition"/>
    <resource>
      <SearchParameter>
        <id value="EpisodeOfCare-condition"/>
        <url value="http://hl7.org/fhir/SearchParameter/EpisodeOfCare-condition"/>
        <name value="condition"/>
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
        <code value="condition"/>
        <base value="EpisodeOfCare"/>
        <type value="reference"/>
        <description value="Conditions/problems/diagnoses this episode of care is for"/>
        <xpath value="f:EpisodeOfCare/f:condition"/>
        <xpathUsage value="normal"/>
        <target value="Condition"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EpisodeOfCare-date"/>
    <resource>
      <SearchParameter>
        <id value="EpisodeOfCare-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/EpisodeOfCare-date"/>
        <name value="date"/>
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
        <code value="date"/>
        <base value="EpisodeOfCare"/>
        <type value="date"/>
        <description value="The provided date search value falls within the episode of care&apos;s period"/>
        <xpath value="f:EpisodeOfCare/f:period"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EpisodeOfCare-identifier"/>
    <resource>
      <SearchParameter>
        <id value="EpisodeOfCare-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/EpisodeOfCare-identifier"/>
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
        <base value="EpisodeOfCare"/>
        <type value="token"/>
        <description value="Identifier(s) for the EpisodeOfCare"/>
        <xpath value="f:EpisodeOfCare/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EpisodeOfCare-incomingreferral"/>
    <resource>
      <SearchParameter>
        <id value="EpisodeOfCare-incomingreferral"/>
        <url value="http://hl7.org/fhir/SearchParameter/EpisodeOfCare-incomingreferral"/>
        <name value="incomingreferral"/>
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
        <code value="incomingreferral"/>
        <base value="EpisodeOfCare"/>
        <type value="reference"/>
        <description value="Incoming Referral Request"/>
        <xpath value="f:EpisodeOfCare/f:referralRequest"/>
        <xpathUsage value="normal"/>
        <target value="ReferralRequest"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EpisodeOfCare-organization"/>
    <resource>
      <SearchParameter>
        <id value="EpisodeOfCare-organization"/>
        <url value="http://hl7.org/fhir/SearchParameter/EpisodeOfCare-organization"/>
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
        <base value="EpisodeOfCare"/>
        <type value="reference"/>
        <description value="The organization that has assumed the specific responsibilities of this EpisodeOfCare"/>
        <xpath value="f:EpisodeOfCare/f:managingOrganization"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EpisodeOfCare-patient"/>
    <resource>
      <SearchParameter>
        <id value="EpisodeOfCare-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/EpisodeOfCare-patient"/>
        <name value="patient"/>
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
        <code value="patient"/>
        <base value="EpisodeOfCare"/>
        <type value="reference"/>
        <description value="Patient for this episode of care"/>
        <xpath value="f:EpisodeOfCare/f:patient"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EpisodeOfCare-status"/>
    <resource>
      <SearchParameter>
        <id value="EpisodeOfCare-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/EpisodeOfCare-status"/>
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
        <base value="EpisodeOfCare"/>
        <type value="token"/>
        <description value="The current status of the Episode of Care as provided (does not check the status history collection)"/>
        <xpath value="f:EpisodeOfCare/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EpisodeOfCare-team-member"/>
    <resource>
      <SearchParameter>
        <id value="EpisodeOfCare-team-member"/>
        <url value="http://hl7.org/fhir/SearchParameter/EpisodeOfCare-team-member"/>
        <name value="team-member"/>
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
        <code value="team-member"/>
        <base value="EpisodeOfCare"/>
        <type value="reference"/>
        <description value="A Practitioner or Organization allocated to the care team for this EpisodeOfCare"/>
        <xpath value="f:EpisodeOfCare/f:careTeam/f:member"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EpisodeOfCare-type"/>
    <resource>
      <SearchParameter>
        <id value="EpisodeOfCare-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/EpisodeOfCare-type"/>
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
        <base value="EpisodeOfCare"/>
        <type value="token"/>
        <description value="Type/class  - e.g. specialist referral, disease management"/>
        <xpath value="f:EpisodeOfCare/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
