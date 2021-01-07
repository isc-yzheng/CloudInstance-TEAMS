Class HS.FHIR.vDSTU2.Repository.Resource.Questionnaire Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Questionnaire"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Questionnaire-code"/>
    <resource>
      <SearchParameter>
        <id value="Questionnaire-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/Questionnaire-code"/>
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
        <base value="Questionnaire"/>
        <type value="token"/>
        <description value="A code that corresponds to the questionnaire or one of its groups"/>
        <xpath value="f:Questionnaire/f:group/f:concept"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Questionnaire-date"/>
    <resource>
      <SearchParameter>
        <id value="Questionnaire-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/Questionnaire-date"/>
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
        <base value="Questionnaire"/>
        <type value="date"/>
        <description value="When the questionnaire was last changed"/>
        <xpath value="f:Questionnaire/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Questionnaire-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Questionnaire-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Questionnaire-identifier"/>
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
        <base value="Questionnaire"/>
        <type value="token"/>
        <description value="An identifier for the questionnaire"/>
        <xpath value="f:Questionnaire/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Questionnaire-publisher"/>
    <resource>
      <SearchParameter>
        <id value="Questionnaire-publisher"/>
        <url value="http://hl7.org/fhir/SearchParameter/Questionnaire-publisher"/>
        <name value="publisher"/>
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
        <code value="publisher"/>
        <base value="Questionnaire"/>
        <type value="string"/>
        <description value="The author of the questionnaire"/>
        <xpath value="f:Questionnaire/f:publisher"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Questionnaire-status"/>
    <resource>
      <SearchParameter>
        <id value="Questionnaire-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/Questionnaire-status"/>
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
        <base value="Questionnaire"/>
        <type value="token"/>
        <description value="The status of the questionnaire"/>
        <xpath value="f:Questionnaire/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Questionnaire-title"/>
    <resource>
      <SearchParameter>
        <id value="Questionnaire-title"/>
        <url value="http://hl7.org/fhir/SearchParameter/Questionnaire-title"/>
        <name value="title"/>
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
        <code value="title"/>
        <base value="Questionnaire"/>
        <type value="string"/>
        <description value="All or part of the name of the questionnaire (title for the root group of the questionnaire)"/>
        <xpath value="f:Questionnaire/f:group/f:title"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Questionnaire-version"/>
    <resource>
      <SearchParameter>
        <id value="Questionnaire-version"/>
        <url value="http://hl7.org/fhir/SearchParameter/Questionnaire-version"/>
        <name value="version"/>
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
        <code value="version"/>
        <base value="Questionnaire"/>
        <type value="string"/>
        <description value="The business version of the questionnaire"/>
        <xpath value="f:Questionnaire/f:version"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
