Class HS.FHIR.vDSTU2.Repository.Resource.DiagnosticReport Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-DiagnosticReport"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DiagnosticReport-category"/>
    <resource>
      <SearchParameter>
        <id value="DiagnosticReport-category"/>
        <url value="http://hl7.org/fhir/SearchParameter/DiagnosticReport-category"/>
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
        <base value="DiagnosticReport"/>
        <type value="token"/>
        <description value="Which diagnostic discipline/department created the report"/>
        <xpath value="f:DiagnosticReport/f:category"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DiagnosticReport-code"/>
    <resource>
      <SearchParameter>
        <id value="DiagnosticReport-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/DiagnosticReport-code"/>
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
        <base value="DiagnosticReport"/>
        <type value="token"/>
        <description value="The code for the report as a whole, as opposed to codes for the atomic results, which are the names on the observation resource referred to from the result"/>
        <xpath value="f:DiagnosticReport/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DiagnosticReport-date"/>
    <resource>
      <SearchParameter>
        <id value="DiagnosticReport-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/DiagnosticReport-date"/>
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
        <base value="DiagnosticReport"/>
        <type value="date"/>
        <description value="The clinically relevant time of the report"/>
        <xpath value="f:DiagnosticReport/f:effectiveDateTime | f:DiagnosticReport/f:effectivePeriod"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DiagnosticReport-diagnosis"/>
    <resource>
      <SearchParameter>
        <id value="DiagnosticReport-diagnosis"/>
        <url value="http://hl7.org/fhir/SearchParameter/DiagnosticReport-diagnosis"/>
        <name value="diagnosis"/>
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
        <code value="diagnosis"/>
        <base value="DiagnosticReport"/>
        <type value="token"/>
        <description value="A coded diagnosis on the report"/>
        <xpath value="f:DiagnosticReport/f:codedDiagnosis"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DiagnosticReport-encounter"/>
    <resource>
      <SearchParameter>
        <id value="DiagnosticReport-encounter"/>
        <url value="http://hl7.org/fhir/SearchParameter/DiagnosticReport-encounter"/>
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
        <base value="DiagnosticReport"/>
        <type value="reference"/>
        <description value="The Encounter when the order was made"/>
        <xpath value="f:DiagnosticReport/f:encounter"/>
        <xpathUsage value="normal"/>
        <target value="Encounter"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DiagnosticReport-identifier"/>
    <resource>
      <SearchParameter>
        <id value="DiagnosticReport-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/DiagnosticReport-identifier"/>
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
        <base value="DiagnosticReport"/>
        <type value="token"/>
        <description value="An identifier for the report"/>
        <xpath value="f:DiagnosticReport/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DiagnosticReport-image"/>
    <resource>
      <SearchParameter>
        <id value="DiagnosticReport-image"/>
        <url value="http://hl7.org/fhir/SearchParameter/DiagnosticReport-image"/>
        <name value="image"/>
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
        <code value="image"/>
        <base value="DiagnosticReport"/>
        <type value="reference"/>
        <description value="A reference to the image source."/>
        <xpath value="f:DiagnosticReport/f:image/f:link"/>
        <xpathUsage value="normal"/>
        <target value="Media"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DiagnosticReport-issued"/>
    <resource>
      <SearchParameter>
        <id value="DiagnosticReport-issued"/>
        <url value="http://hl7.org/fhir/SearchParameter/DiagnosticReport-issued"/>
        <name value="issued"/>
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
        <code value="issued"/>
        <base value="DiagnosticReport"/>
        <type value="date"/>
        <description value="When the report was issued"/>
        <xpath value="f:DiagnosticReport/f:issued"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DiagnosticReport-patient"/>
    <resource>
      <SearchParameter>
        <id value="DiagnosticReport-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/DiagnosticReport-patient"/>
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
        <base value="DiagnosticReport"/>
        <type value="reference"/>
        <description value="The subject of the report if a patient"/>
        <xpath value="f:DiagnosticReport/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="Location"/>
        <target value="Patient"/>
        <target value="Group"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DiagnosticReport-performer"/>
    <resource>
      <SearchParameter>
        <id value="DiagnosticReport-performer"/>
        <url value="http://hl7.org/fhir/SearchParameter/DiagnosticReport-performer"/>
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
        <base value="DiagnosticReport"/>
        <type value="reference"/>
        <description value="Who was the source of the report (organization)"/>
        <xpath value="f:DiagnosticReport/f:performer"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DiagnosticReport-request"/>
    <resource>
      <SearchParameter>
        <id value="DiagnosticReport-request"/>
        <url value="http://hl7.org/fhir/SearchParameter/DiagnosticReport-request"/>
        <name value="request"/>
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
        <code value="request"/>
        <base value="DiagnosticReport"/>
        <type value="reference"/>
        <description value="Reference to the test or procedure request."/>
        <xpath value="f:DiagnosticReport/f:request"/>
        <xpathUsage value="normal"/>
        <target value="ReferralRequest"/>
        <target value="ProcedureRequest"/>
        <target value="DiagnosticOrder"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DiagnosticReport-result"/>
    <resource>
      <SearchParameter>
        <id value="DiagnosticReport-result"/>
        <url value="http://hl7.org/fhir/SearchParameter/DiagnosticReport-result"/>
        <name value="result"/>
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
        <code value="result"/>
        <base value="DiagnosticReport"/>
        <type value="reference"/>
        <description value="Link to an atomic result (observation resource)"/>
        <xpath value="f:DiagnosticReport/f:result"/>
        <xpathUsage value="normal"/>
        <target value="Observation"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DiagnosticReport-specimen"/>
    <resource>
      <SearchParameter>
        <id value="DiagnosticReport-specimen"/>
        <url value="http://hl7.org/fhir/SearchParameter/DiagnosticReport-specimen"/>
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
        <base value="DiagnosticReport"/>
        <type value="reference"/>
        <description value="The specimen details"/>
        <xpath value="f:DiagnosticReport/f:specimen"/>
        <xpathUsage value="normal"/>
        <target value="Specimen"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DiagnosticReport-status"/>
    <resource>
      <SearchParameter>
        <id value="DiagnosticReport-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/DiagnosticReport-status"/>
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
        <base value="DiagnosticReport"/>
        <type value="token"/>
        <description value="The status of the report"/>
        <xpath value="f:DiagnosticReport/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DiagnosticReport-subject"/>
    <resource>
      <SearchParameter>
        <id value="DiagnosticReport-subject"/>
        <url value="http://hl7.org/fhir/SearchParameter/DiagnosticReport-subject"/>
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
        <base value="DiagnosticReport"/>
        <type value="reference"/>
        <description value="The subject of the report"/>
        <xpath value="f:DiagnosticReport/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="Location"/>
        <target value="Patient"/>
        <target value="Group"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
