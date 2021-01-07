Class HS.FHIR.vDSTU2.Repository.Resource.Coverage Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Coverage"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Coverage-dependent"/>
    <resource>
      <SearchParameter>
        <id value="Coverage-dependent"/>
        <url value="http://hl7.org/fhir/SearchParameter/Coverage-dependent"/>
        <name value="dependent"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="dependent"/>
        <base value="Coverage"/>
        <type value="token"/>
        <description value="Dependent number"/>
        <xpath value="f:Coverage/f:dependent"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Coverage-group"/>
    <resource>
      <SearchParameter>
        <id value="Coverage-group"/>
        <url value="http://hl7.org/fhir/SearchParameter/Coverage-group"/>
        <name value="group"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="group"/>
        <base value="Coverage"/>
        <type value="token"/>
        <description value="Group identifier"/>
        <xpath value="f:Coverage/f:group"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Coverage-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Coverage-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Coverage-identifier"/>
        <name value="identifier"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="identifier"/>
        <base value="Coverage"/>
        <type value="token"/>
        <description value="The primary identifier of the insured"/>
        <xpath value="f:Coverage/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Coverage-issuer"/>
    <resource>
      <SearchParameter>
        <id value="Coverage-issuer"/>
        <url value="http://hl7.org/fhir/SearchParameter/Coverage-issuer"/>
        <name value="issuer"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="issuer"/>
        <base value="Coverage"/>
        <type value="reference"/>
        <description value="The identity of the insurer"/>
        <xpath value="f:Coverage/f:issuer"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Coverage-plan"/>
    <resource>
      <SearchParameter>
        <id value="Coverage-plan"/>
        <url value="http://hl7.org/fhir/SearchParameter/Coverage-plan"/>
        <name value="plan"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="plan"/>
        <base value="Coverage"/>
        <type value="token"/>
        <description value="A plan or policy identifier"/>
        <xpath value="f:Coverage/f:plan"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Coverage-sequence"/>
    <resource>
      <SearchParameter>
        <id value="Coverage-sequence"/>
        <url value="http://hl7.org/fhir/SearchParameter/Coverage-sequence"/>
        <name value="sequence"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="sequence"/>
        <base value="Coverage"/>
        <type value="token"/>
        <description value="Sequence number"/>
        <xpath value="f:Coverage/f:sequence"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Coverage-subplan"/>
    <resource>
      <SearchParameter>
        <id value="Coverage-subplan"/>
        <url value="http://hl7.org/fhir/SearchParameter/Coverage-subplan"/>
        <name value="subplan"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="subplan"/>
        <base value="Coverage"/>
        <type value="token"/>
        <description value="Sub-plan identifier"/>
        <xpath value="f:Coverage/f:subPlan"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Coverage-type"/>
    <resource>
      <SearchParameter>
        <id value="Coverage-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/Coverage-type"/>
        <name value="type"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="type"/>
        <base value="Coverage"/>
        <type value="token"/>
        <description value="The kind of coverage"/>
        <xpath value="f:Coverage/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
