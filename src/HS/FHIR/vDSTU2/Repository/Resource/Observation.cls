Class HS.FHIR.vDSTU2.Repository.Resource.Observation Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Observation"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-category"/>
    <resource>
      <SearchParameter>
        <id value="Observation-category"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-category"/>
        <name value="category"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="category"/>
        <base value="Observation"/>
        <type value="token"/>
        <description value="The classification of the type of observation"/>
        <xpath value="f:Observation/f:category"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-code"/>
    <resource>
      <SearchParameter>
        <id value="Observation-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-code"/>
        <name value="code"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="code"/>
        <base value="Observation"/>
        <type value="token"/>
        <description value="The code of the observation type"/>
        <xpath value="f:Observation/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-code-value-x"/>
    <resource>
      <SearchParameter>
        <id value="Observation-code-value-x"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-code-value-x"/>
        <name value="code-value-[x]"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="code-value-[x]"/>
        <base value="Observation"/>
        <type value="composite"/>
        <description value="Both code and one of the value parameters"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-component-code"/>
    <resource>
      <SearchParameter>
        <id value="Observation-component-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-component-code"/>
        <name value="component-code"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="component-code"/>
        <base value="Observation"/>
        <type value="token"/>
        <description value="The component code of the observation type"/>
        <xpath value="f:Observation/f:component/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-component-code-value-x"/>
    <resource>
      <SearchParameter>
        <id value="Observation-component-code-value-x"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-component-code-value-x"/>
        <name value="component-code-value-[x]"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="component-code-value-[x]"/>
        <base value="Observation"/>
        <type value="composite"/>
        <description value="Both component code and one of the component value parameters"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-component-data-absent-reason"/>
    <resource>
      <SearchParameter>
        <id value="Observation-component-data-absent-reason"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-component-data-absent-reason"/>
        <name value="component-data-absent-reason"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="component-data-absent-reason"/>
        <base value="Observation"/>
        <type value="token"/>
        <description value="The reason why the expected value in the element Observation.component.value[x] is missing."/>
        <xpath value="f:Observation/f:component/f:dataAbsentReason"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-component-value-concept"/>
    <resource>
      <SearchParameter>
        <id value="Observation-component-value-concept"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-component-value-concept"/>
        <name value="component-value-concept"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="component-value-concept"/>
        <base value="Observation"/>
        <type value="token"/>
        <description value="The value of the component observation, if the value is a CodeableConcept"/>
        <xpath value="f:Observation/f:component/f:valueCodeableConcept"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-component-value-quantity"/>
    <resource>
      <SearchParameter>
        <id value="Observation-component-value-quantity"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-component-value-quantity"/>
        <name value="component-value-quantity"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="component-value-quantity"/>
        <base value="Observation"/>
        <type value="quantity"/>
        <description value="The value of the component observation, if the value is a Quantity, or a SampledData (just search on the bounds of the values in sampled data)"/>
        <xpath value="f:Observation/f:component/f:valueQuantity"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-component-value-string"/>
    <resource>
      <SearchParameter>
        <id value="Observation-component-value-string"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-component-value-string"/>
        <name value="component-value-string"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="component-value-string"/>
        <base value="Observation"/>
        <type value="string"/>
        <description value="The value of the component observation, if the value is a string, and also searches in CodeableConcept.text"/>
        <xpath value="f:Observation/f:component/f:valueString"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-data-absent-reason"/>
    <resource>
      <SearchParameter>
        <id value="Observation-data-absent-reason"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-data-absent-reason"/>
        <name value="data-absent-reason"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="data-absent-reason"/>
        <base value="Observation"/>
        <type value="token"/>
        <description value="The reason why the expected value in the element Observation.value[x] is missing."/>
        <xpath value="f:Observation/f:dataAbsentReason"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-date"/>
    <resource>
      <SearchParameter>
        <id value="Observation-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-date"/>
        <name value="date"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="date"/>
        <base value="Observation"/>
        <type value="date"/>
        <description value="Obtained date/time. If the obtained element is a period, a date that falls in the period"/>
        <xpath value="f:Observation/f:effectiveDateTime | f:Observation/f:effectivePeriod"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-device"/>
    <resource>
      <SearchParameter>
        <id value="Observation-device"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-device"/>
        <name value="device"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="device"/>
        <base value="Observation"/>
        <type value="reference"/>
        <description value="The Device that generated the observation data."/>
        <xpath value="f:Observation/f:device"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="DeviceMetric"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-encounter"/>
    <resource>
      <SearchParameter>
        <id value="Observation-encounter"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-encounter"/>
        <name value="encounter"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="encounter"/>
        <base value="Observation"/>
        <type value="reference"/>
        <description value="Healthcare event related to the observation"/>
        <xpath value="f:Observation/f:encounter"/>
        <xpathUsage value="normal"/>
        <target value="Encounter"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Observation-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-identifier"/>
        <name value="identifier"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="identifier"/>
        <base value="Observation"/>
        <type value="token"/>
        <description value="The unique id for a particular observation"/>
        <xpath value="f:Observation/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-patient"/>
    <resource>
      <SearchParameter>
        <id value="Observation-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-patient"/>
        <name value="patient"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="patient"/>
        <base value="Observation"/>
        <type value="reference"/>
        <description value="The subject that the observation is about (if patient)"/>
        <xpath value="f:Observation/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="Location"/>
        <target value="Patient"/>
        <target value="Group"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-performer"/>
    <resource>
      <SearchParameter>
        <id value="Observation-performer"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-performer"/>
        <name value="performer"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="performer"/>
        <base value="Observation"/>
        <type value="reference"/>
        <description value="Who performed the observation"/>
        <xpath value="f:Observation/f:performer"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
        <target value="Organization"/>
        <target value="Practitioner"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-related"/>
    <resource>
      <SearchParameter>
        <id value="Observation-related"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-related"/>
        <name value="related"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="related"/>
        <base value="Observation"/>
        <type value="composite"/>
        <description value="Related Observations - search on related-type and related-target together"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-related-target"/>
    <resource>
      <SearchParameter>
        <id value="Observation-related-target"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-related-target"/>
        <name value="related-target"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="related-target"/>
        <base value="Observation"/>
        <type value="reference"/>
        <description value="Resource that is related to this one"/>
        <xpath value="f:Observation/f:related/f:target"/>
        <xpathUsage value="normal"/>
        <target value="Observation"/>
        <target value="QuestionnaireResponse"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-related-type"/>
    <resource>
      <SearchParameter>
        <id value="Observation-related-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-related-type"/>
        <name value="related-type"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="related-type"/>
        <base value="Observation"/>
        <type value="token"/>
        <description value="has-member | derived-from | sequel-to | replaces | qualified-by | interfered-by"/>
        <xpath value="f:Observation/f:related/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-specimen"/>
    <resource>
      <SearchParameter>
        <id value="Observation-specimen"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-specimen"/>
        <name value="specimen"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="specimen"/>
        <base value="Observation"/>
        <type value="reference"/>
        <description value="Specimen used for this observation"/>
        <xpath value="f:Observation/f:specimen"/>
        <xpathUsage value="normal"/>
        <target value="Specimen"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-status"/>
    <resource>
      <SearchParameter>
        <id value="Observation-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-status"/>
        <name value="status"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="status"/>
        <base value="Observation"/>
        <type value="token"/>
        <description value="The status of the observation"/>
        <xpath value="f:Observation/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-subject"/>
    <resource>
      <SearchParameter>
        <id value="Observation-subject"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-subject"/>
        <name value="subject"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="subject"/>
        <base value="Observation"/>
        <type value="reference"/>
        <description value="The subject that the observation is about"/>
        <xpath value="f:Observation/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="Location"/>
        <target value="Patient"/>
        <target value="Group"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-value-concept"/>
    <resource>
      <SearchParameter>
        <id value="Observation-value-concept"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-value-concept"/>
        <name value="value-concept"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="value-concept"/>
        <base value="Observation"/>
        <type value="token"/>
        <description value="The value of the observation, if the value is a CodeableConcept"/>
        <xpath value="f:Observation/f:valueCodeableConcept"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-value-date"/>
    <resource>
      <SearchParameter>
        <id value="Observation-value-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-value-date"/>
        <name value="value-date"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="value-date"/>
        <base value="Observation"/>
        <type value="date"/>
        <description value="The value of the observation, if the value is a date or period of time"/>
        <xpath value="f:Observation/f:valueDateTime"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-value-quantity"/>
    <resource>
      <SearchParameter>
        <id value="Observation-value-quantity"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-value-quantity"/>
        <name value="value-quantity"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="value-quantity"/>
        <base value="Observation"/>
        <type value="quantity"/>
        <description value="The value of the observation, if the value is a Quantity, or a SampledData (just search on the bounds of the values in sampled data)"/>
        <xpath value="f:Observation/f:valueQuantity"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <!--
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-value-string"/>
    <resource>
      <SearchParameter>
        <id value="Observation-value-string"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-value-string"/>
        <name value="value-string"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="value-string"/>
        <base value="Observation"/>
        <type value="string"/>
        <description value="The value of the observation, if the value is a string, and also searches in CodeableConcept.text"/>
        <xpath value="f:Observation/f:valueString"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  -->
</Bundle>
}

}
