Class HS.FHIR.vSTU3.Repository.Resource.TestReport Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-TestReport"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/TestReport-identifier"/>
    <resource>
      <SearchParameter>
        <id value="TestReport-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/TestReport-identifier"/>
        <name value="identifier"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="identifier"/>
        <base value="TestReport"/>
        <type value="token"/>
        <description value="An external identifier for the test report"/>
        <expression value="TestReport.identifier"/>
        <xpath value="f:TestReport/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/TestReport-issued"/>
    <resource>
      <SearchParameter>
        <id value="TestReport-issued"/>
        <url value="http://hl7.org/fhir/SearchParameter/TestReport-issued"/>
        <name value="issued"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="issued"/>
        <base value="TestReport"/>
        <type value="date"/>
        <description value="The test report generation date"/>
        <expression value="TestReport.issued"/>
        <xpath value="f:TestReport/f:issued"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/TestReport-participant"/>
    <resource>
      <SearchParameter>
        <id value="TestReport-participant"/>
        <url value="http://hl7.org/fhir/SearchParameter/TestReport-participant"/>
        <name value="participant"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="participant"/>
        <base value="TestReport"/>
        <type value="uri"/>
        <description value="The reference to a participant in the test execution"/>
        <expression value="TestReport.participant.uri"/>
        <xpath value="f:TestReport/f:participant/f:uri"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/TestReport-result"/>
    <resource>
      <SearchParameter>
        <id value="TestReport-result"/>
        <url value="http://hl7.org/fhir/SearchParameter/TestReport-result"/>
        <name value="result"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="result"/>
        <base value="TestReport"/>
        <type value="token"/>
        <description value="The result disposition of the test execution"/>
        <expression value="TestReport.result"/>
        <xpath value="f:TestReport/f:result"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/TestReport-tester"/>
    <resource>
      <SearchParameter>
        <id value="TestReport-tester"/>
        <url value="http://hl7.org/fhir/SearchParameter/TestReport-tester"/>
        <name value="tester"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="tester"/>
        <base value="TestReport"/>
        <type value="string"/>
        <description value="The name of the testing organization"/>
        <expression value="TestReport.tester"/>
        <xpath value="f:TestReport/f:tester"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/TestReport-testscript"/>
    <resource>
      <SearchParameter>
        <id value="TestReport-testscript"/>
        <url value="http://hl7.org/fhir/SearchParameter/TestReport-testscript"/>
        <name value="testscript"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="testscript"/>
        <base value="TestReport"/>
        <type value="reference"/>
        <description value="The test script executed to produce this report"/>
        <expression value="TestReport.testScript"/>
        <xpath value="f:TestReport/f:testScript"/>
        <xpathUsage value="normal"/>
        <target value="TestScript"/>
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
