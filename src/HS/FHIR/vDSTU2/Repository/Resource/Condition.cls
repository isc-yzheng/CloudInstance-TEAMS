Class HS.FHIR.vDSTU2.Repository.Resource.Condition Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Condition"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/condition-daf-Condition-age"/>
    <resource>
      <SearchParameter>
        <id value="condition-daf-Condition-age"/>
        <url value="http://hl7.org/fhir/SearchParameter/condition-daf-Condition-age"/>
        <name value="age"/>
        <code value="age"/>
        <base value="Condition"/>
        <type value="number"/>
        <description value="Search based on Condition onsetAge"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Condition-asserter"/>
    <resource>
      <SearchParameter>
        <id value="Condition-asserter"/>
        <url value="http://hl7.org/fhir/SearchParameter/Condition-asserter"/>
        <name value="asserter"/>
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
        <code value="asserter"/>
        <base value="Condition"/>
        <type value="reference"/>
        <description value="Person who asserts this condition"/>
        <xpath value="f:Condition/f:asserter"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Condition-body-site"/>
    <resource>
      <SearchParameter>
        <id value="Condition-body-site"/>
        <url value="http://hl7.org/fhir/SearchParameter/Condition-body-site"/>
        <name value="body-site"/>
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
        <code value="body-site"/>
        <base value="Condition"/>
        <type value="token"/>
        <description value="Anatomical location, if relevant"/>
        <xpath value="f:Condition/f:bodySite"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Condition-category"/>
    <resource>
      <SearchParameter>
        <id value="Condition-category"/>
        <url value="http://hl7.org/fhir/SearchParameter/Condition-category"/>
        <name value="category"/>
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
        <code value="category"/>
        <base value="Condition"/>
        <type value="token"/>
        <description value="The category of the condition"/>
        <xpath value="f:Condition/f:category"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Condition-clinicalstatus"/>
    <resource>
      <SearchParameter>
        <id value="Condition-clinicalstatus"/>
        <url value="http://hl7.org/fhir/SearchParameter/Condition-clinicalstatus"/>
        <name value="clinicalstatus"/>
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
        <code value="clinicalstatus"/>
        <base value="Condition"/>
        <type value="token"/>
        <description value="The clinical status of the condition"/>
        <xpath value="f:Condition/f:clinicalStatus"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Condition-code"/>
    <resource>
      <SearchParameter>
        <id value="Condition-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/Condition-code"/>
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
        <base value="Condition"/>
        <type value="token"/>
        <description value="Code for the condition"/>
        <xpath value="f:Condition/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Condition-date-recorded"/>
    <resource>
      <SearchParameter>
        <id value="Condition-date-recorded"/>
        <url value="http://hl7.org/fhir/SearchParameter/Condition-date-recorded"/>
        <name value="date-recorded"/>
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
        <code value="date-recorded"/>
        <base value="Condition"/>
        <type value="date"/>
        <description value="A date, when the Condition statement was documented"/>
        <xpath value="f:Condition/f:dateRecorded"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Condition-encounter"/>
    <resource>
      <SearchParameter>
        <id value="Condition-encounter"/>
        <url value="http://hl7.org/fhir/SearchParameter/Condition-encounter"/>
        <name value="encounter"/>
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
        <code value="encounter"/>
        <base value="Condition"/>
        <type value="reference"/>
        <description value="Encounter when condition first asserted"/>
        <xpath value="f:Condition/f:encounter"/>
        <xpathUsage value="normal"/>
        <target value="Encounter"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Condition-evidence"/>
    <resource>
      <SearchParameter>
        <id value="Condition-evidence"/>
        <url value="http://hl7.org/fhir/SearchParameter/Condition-evidence"/>
        <name value="evidence"/>
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
        <code value="evidence"/>
        <base value="Condition"/>
        <type value="token"/>
        <description value="Manifestation/symptom"/>
        <xpath value="f:Condition/f:evidence/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Condition-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Condition-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Condition-identifier"/>
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
        <base value="Condition"/>
        <type value="token"/>
        <description value="A unique identifier of the condition record"/>
        <xpath value="f:Condition/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Condition-onset"/>
    <resource>
      <SearchParameter>
        <id value="Condition-onset"/>
        <url value="http://hl7.org/fhir/SearchParameter/Condition-onset"/>
        <name value="onset"/>
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
        <code value="onset"/>
        <base value="Condition"/>
        <type value="date"/>
        <description value="Date related onsets (dateTime and Period)"/>
        <xpath value="f:Condition/f:onsetDateTime | f:Condition/f:onsetPeriod"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Condition-onset-info"/>
    <resource>
      <SearchParameter>
        <id value="Condition-onset-info"/>
        <url value="http://hl7.org/fhir/SearchParameter/Condition-onset-info"/>
        <name value="onset-info"/>
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
        <code value="onset-info"/>
        <base value="Condition"/>
        <type value="string"/>
        <description value="Other onsets (boolean, age, range, string)"/>
        <xpath value="f:Condition/f:onsetString"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Condition-patient"/>
    <resource>
      <SearchParameter>
        <id value="Condition-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/Condition-patient"/>
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
        <base value="Condition"/>
        <type value="reference"/>
        <description value="Who has the condition?"/>
        <xpath value="f:Condition/f:patient"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Condition-severity"/>
    <resource>
      <SearchParameter>
        <id value="Condition-severity"/>
        <url value="http://hl7.org/fhir/SearchParameter/Condition-severity"/>
        <name value="severity"/>
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
        <code value="severity"/>
        <base value="Condition"/>
        <type value="token"/>
        <description value="The severity of the condition"/>
        <xpath value="f:Condition/f:severity"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Condition-stage"/>
    <resource>
      <SearchParameter>
        <id value="Condition-stage"/>
        <url value="http://hl7.org/fhir/SearchParameter/Condition-stage"/>
        <name value="stage"/>
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
        <code value="stage"/>
        <base value="Condition"/>
        <type value="token"/>
        <description value="Simple summary (disease specific)"/>
        <xpath value="f:Condition/f:stage/f:summary"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
