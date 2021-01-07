Class HS.FHIR.vDSTU2.Repository.Resource.ImmunizationRecommendation Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-ImmunizationRecommendation"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImmunizationRecommendation-date"/>
    <resource>
      <SearchParameter>
        <id value="ImmunizationRecommendation-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImmunizationRecommendation-date"/>
        <name value="date"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="date"/>
        <base value="ImmunizationRecommendation"/>
        <type value="date"/>
        <description value="Date recommendation created"/>
        <xpath value="f:ImmunizationRecommendation/f:recommendation/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImmunizationRecommendation-dose-number"/>
    <resource>
      <SearchParameter>
        <id value="ImmunizationRecommendation-dose-number"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImmunizationRecommendation-dose-number"/>
        <name value="dose-number"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="dose-number"/>
        <base value="ImmunizationRecommendation"/>
        <type value="number"/>
        <description value="Recommended dose number"/>
        <xpath value="f:ImmunizationRecommendation/f:recommendation/f:doseNumber"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImmunizationRecommendation-dose-sequence"/>
    <resource>
      <SearchParameter>
        <id value="ImmunizationRecommendation-dose-sequence"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImmunizationRecommendation-dose-sequence"/>
        <name value="dose-sequence"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="dose-sequence"/>
        <base value="ImmunizationRecommendation"/>
        <type value="number"/>
        <description value="Dose number within sequence"/>
        <xpath value="f:ImmunizationRecommendation/f:recommendation/f:protocol/f:doseSequence"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImmunizationRecommendation-identifier"/>
    <resource>
      <SearchParameter>
        <id value="ImmunizationRecommendation-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImmunizationRecommendation-identifier"/>
        <name value="identifier"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="identifier"/>
        <base value="ImmunizationRecommendation"/>
        <type value="token"/>
        <description value="Business identifier"/>
        <xpath value="f:ImmunizationRecommendation/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImmunizationRecommendation-information"/>
    <resource>
      <SearchParameter>
        <id value="ImmunizationRecommendation-information"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImmunizationRecommendation-information"/>
        <name value="information"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="information"/>
        <base value="ImmunizationRecommendation"/>
        <type value="reference"/>
        <description value="Patient observations supporting recommendation"/>
        <xpath value="f:ImmunizationRecommendation/f:recommendation/f:supportingPatientInformation"/>
        <xpathUsage value="normal"/>
        <target value="AllergyIntolerance"/>
        <target value="Observation"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImmunizationRecommendation-patient"/>
    <resource>
      <SearchParameter>
        <id value="ImmunizationRecommendation-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImmunizationRecommendation-patient"/>
        <name value="patient"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="patient"/>
        <base value="ImmunizationRecommendation"/>
        <type value="reference"/>
        <description value="Who this profile is for"/>
        <xpath value="f:ImmunizationRecommendation/f:patient"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImmunizationRecommendation-status"/>
    <resource>
      <SearchParameter>
        <id value="ImmunizationRecommendation-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImmunizationRecommendation-status"/>
        <name value="status"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="status"/>
        <base value="ImmunizationRecommendation"/>
        <type value="token"/>
        <description value="Vaccine administration status"/>
        <xpath value="f:ImmunizationRecommendation/f:recommendation/f:forecastStatus"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImmunizationRecommendation-support"/>
    <resource>
      <SearchParameter>
        <id value="ImmunizationRecommendation-support"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImmunizationRecommendation-support"/>
        <name value="support"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="support"/>
        <base value="ImmunizationRecommendation"/>
        <type value="reference"/>
        <description value="Past immunizations supporting recommendation"/>
        <xpath value="f:ImmunizationRecommendation/f:recommendation/f:supportingImmunization"/>
        <xpathUsage value="normal"/>
        <target value="Immunization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImmunizationRecommendation-vaccine-type"/>
    <resource>
      <SearchParameter>
        <id value="ImmunizationRecommendation-vaccine-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImmunizationRecommendation-vaccine-type"/>
        <name value="vaccine-type"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="vaccine-type"/>
        <base value="ImmunizationRecommendation"/>
        <type value="token"/>
        <description value="Vaccine recommendation applies to"/>
        <xpath value="f:ImmunizationRecommendation/f:recommendation/f:vaccineCode"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
