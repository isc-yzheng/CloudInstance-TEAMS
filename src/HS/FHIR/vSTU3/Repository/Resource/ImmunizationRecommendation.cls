Class HS.FHIR.vSTU3.Repository.Resource.ImmunizationRecommendation Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-ImmunizationRecommendation"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImmunizationRecommendation-date"/>
    <resource>
      <SearchParameter>
        <id value="ImmunizationRecommendation-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImmunizationRecommendation-date"/>
        <name value="date"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <code value="date"/>
        <base value="ImmunizationRecommendation"/>
        <type value="date"/>
        <description value="Date recommendation created"/>
        <expression value="ImmunizationRecommendation.recommendation.date"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <code value="dose-number"/>
        <base value="ImmunizationRecommendation"/>
        <type value="number"/>
        <description value="Recommended dose number"/>
        <expression value="ImmunizationRecommendation.recommendation.doseNumber"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <code value="dose-sequence"/>
        <base value="ImmunizationRecommendation"/>
        <type value="number"/>
        <description value="Dose number within sequence"/>
        <expression value="ImmunizationRecommendation.recommendation.protocol.doseSequence"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <code value="identifier"/>
        <base value="ImmunizationRecommendation"/>
        <type value="token"/>
        <description value="Business identifier"/>
        <expression value="ImmunizationRecommendation.identifier"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <code value="information"/>
        <base value="ImmunizationRecommendation"/>
        <type value="reference"/>
        <description value="Patient observations supporting recommendation"/>
        <expression value="ImmunizationRecommendation.recommendation.supportingPatientInformation"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <code value="patient"/>
        <base value="ImmunizationRecommendation"/>
        <type value="reference"/>
        <description value="Who this profile is for"/>
        <expression value="ImmunizationRecommendation.patient"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <code value="status"/>
        <base value="ImmunizationRecommendation"/>
        <type value="token"/>
        <description value="Vaccine administration status"/>
        <expression value="ImmunizationRecommendation.recommendation.forecastStatus"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <code value="support"/>
        <base value="ImmunizationRecommendation"/>
        <type value="reference"/>
        <description value="Past immunizations supporting recommendation"/>
        <expression value="ImmunizationRecommendation.recommendation.supportingImmunization"/>
        <xpath value="f:ImmunizationRecommendation/f:recommendation/f:supportingImmunization"/>
        <xpathUsage value="normal"/>
        <target value="Immunization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImmunizationRecommendation-target-disease"/>
    <resource>
      <SearchParameter>
        <id value="ImmunizationRecommendation-target-disease"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImmunizationRecommendation-target-disease"/>
        <name value="target-disease"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <code value="target-disease"/>
        <base value="ImmunizationRecommendation"/>
        <type value="token"/>
        <description value="Disease to be immunized against"/>
        <expression value="ImmunizationRecommendation.recommendation.targetDisease"/>
        <xpath value="f:ImmunizationRecommendation/f:recommendation/f:targetDisease"/>
        <xpathUsage value="normal"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <code value="vaccine-type"/>
        <base value="ImmunizationRecommendation"/>
        <type value="token"/>
        <description value="Vaccine recommendation applies to"/>
        <expression value="ImmunizationRecommendation.recommendation.vaccineCode"/>
        <xpath value="f:ImmunizationRecommendation/f:recommendation/f:vaccineCode"/>
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
