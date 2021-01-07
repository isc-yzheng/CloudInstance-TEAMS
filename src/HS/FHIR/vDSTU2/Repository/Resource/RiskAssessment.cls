Class HS.FHIR.vDSTU2.Repository.Resource.RiskAssessment Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-RiskAssessment"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/RiskAssessment-condition"/>
    <resource>
      <SearchParameter>
        <id value="RiskAssessment-condition"/>
        <url value="http://hl7.org/fhir/SearchParameter/RiskAssessment-condition"/>
        <name value="condition"/>
        <publisher value="Health Level Seven International (Clinical Decision Support)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/dss/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="condition"/>
        <base value="RiskAssessment"/>
        <type value="reference"/>
        <description value="Condition assessed"/>
        <xpath value="f:RiskAssessment/f:condition"/>
        <xpathUsage value="normal"/>
        <target value="Condition"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/RiskAssessment-date"/>
    <resource>
      <SearchParameter>
        <id value="RiskAssessment-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/RiskAssessment-date"/>
        <name value="date"/>
        <publisher value="Health Level Seven International (Clinical Decision Support)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/dss/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="date"/>
        <base value="RiskAssessment"/>
        <type value="date"/>
        <description value="When was assessment made?"/>
        <xpath value="f:RiskAssessment/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/RiskAssessment-encounter"/>
    <resource>
      <SearchParameter>
        <id value="RiskAssessment-encounter"/>
        <url value="http://hl7.org/fhir/SearchParameter/RiskAssessment-encounter"/>
        <name value="encounter"/>
        <publisher value="Health Level Seven International (Clinical Decision Support)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/dss/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="encounter"/>
        <base value="RiskAssessment"/>
        <type value="reference"/>
        <description value="Where was assessment performed?"/>
        <xpath value="f:RiskAssessment/f:encounter"/>
        <xpathUsage value="normal"/>
        <target value="Encounter"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/RiskAssessment-identifier"/>
    <resource>
      <SearchParameter>
        <id value="RiskAssessment-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/RiskAssessment-identifier"/>
        <name value="identifier"/>
        <publisher value="Health Level Seven International (Clinical Decision Support)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/dss/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="identifier"/>
        <base value="RiskAssessment"/>
        <type value="token"/>
        <description value="Unique identifier for the assessment"/>
        <xpath value="f:RiskAssessment/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/RiskAssessment-method"/>
    <resource>
      <SearchParameter>
        <id value="RiskAssessment-method"/>
        <url value="http://hl7.org/fhir/SearchParameter/RiskAssessment-method"/>
        <name value="method"/>
        <publisher value="Health Level Seven International (Clinical Decision Support)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/dss/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="method"/>
        <base value="RiskAssessment"/>
        <type value="token"/>
        <description value="Evaluation mechanism"/>
        <xpath value="f:RiskAssessment/f:method"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/RiskAssessment-patient"/>
    <resource>
      <SearchParameter>
        <id value="RiskAssessment-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/RiskAssessment-patient"/>
        <name value="patient"/>
        <publisher value="Health Level Seven International (Clinical Decision Support)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/dss/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="patient"/>
        <base value="RiskAssessment"/>
        <type value="reference"/>
        <description value="Who/what does assessment apply to?"/>
        <xpath value="f:RiskAssessment/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
        <target value="Group"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/RiskAssessment-performer"/>
    <resource>
      <SearchParameter>
        <id value="RiskAssessment-performer"/>
        <url value="http://hl7.org/fhir/SearchParameter/RiskAssessment-performer"/>
        <name value="performer"/>
        <publisher value="Health Level Seven International (Clinical Decision Support)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/dss/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="performer"/>
        <base value="RiskAssessment"/>
        <type value="reference"/>
        <description value="Who did assessment?"/>
        <xpath value="f:RiskAssessment/f:performer"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/RiskAssessment-subject"/>
    <resource>
      <SearchParameter>
        <id value="RiskAssessment-subject"/>
        <url value="http://hl7.org/fhir/SearchParameter/RiskAssessment-subject"/>
        <name value="subject"/>
        <publisher value="Health Level Seven International (Clinical Decision Support)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/dss/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="subject"/>
        <base value="RiskAssessment"/>
        <type value="reference"/>
        <description value="Who/what does assessment apply to?"/>
        <xpath value="f:RiskAssessment/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
        <target value="Group"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
