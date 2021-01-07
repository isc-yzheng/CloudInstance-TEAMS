Class HS.FHIR.vSTU3.Repository.Resource.Coverage Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Coverage"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Coverage-beneficiary"/>
    <resource>
      <SearchParameter>
        <id value="Coverage-beneficiary"/>
        <url value="http://hl7.org/fhir/SearchParameter/Coverage-beneficiary"/>
        <name value="beneficiary"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="beneficiary"/>
        <base value="Coverage"/>
        <type value="reference"/>
        <description value="Covered party"/>
        <expression value="Coverage.beneficiary"/>
        <xpath value="f:Coverage/f:beneficiary"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Coverage-class"/>
    <resource>
      <SearchParameter>
        <id value="Coverage-class"/>
        <url value="http://hl7.org/fhir/SearchParameter/Coverage-class"/>
        <name value="class"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="class"/>
        <base value="Coverage"/>
        <type value="string"/>
        <description value="Class identifier"/>
        <expression value="Coverage.grouping.class"/>
        <xpath value="f:Coverage/f:grouping/f:class"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Coverage-dependent"/>
    <resource>
      <SearchParameter>
        <id value="Coverage-dependent"/>
        <url value="http://hl7.org/fhir/SearchParameter/Coverage-dependent"/>
        <name value="dependent"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="dependent"/>
        <base value="Coverage"/>
        <type value="string"/>
        <description value="Dependent number"/>
        <expression value="Coverage.dependent"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="group"/>
        <base value="Coverage"/>
        <type value="string"/>
        <description value="Group identifier"/>
        <expression value="Coverage.grouping.group"/>
        <xpath value="f:Coverage/f:grouping/f:group"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="identifier"/>
        <base value="Coverage"/>
        <type value="token"/>
        <description value="The primary identifier of the insured and the coverage"/>
        <expression value="Coverage.identifier"/>
        <xpath value="f:Coverage/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Coverage-payor"/>
    <resource>
      <SearchParameter>
        <id value="Coverage-payor"/>
        <url value="http://hl7.org/fhir/SearchParameter/Coverage-payor"/>
        <name value="payor"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="payor"/>
        <base value="Coverage"/>
        <type value="reference"/>
        <description value="The identity of the insurer or party paying for services"/>
        <expression value="Coverage.payor"/>
        <xpath value="f:Coverage/f:payor"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
        <target value="Patient"/>
        <target value="RelatedPerson"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="plan"/>
        <base value="Coverage"/>
        <type value="string"/>
        <description value="A plan or policy identifier"/>
        <expression value="Coverage.grouping.plan"/>
        <xpath value="f:Coverage/f:grouping/f:plan"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Coverage-policy-holder"/>
    <resource>
      <SearchParameter>
        <id value="Coverage-policy-holder"/>
        <url value="http://hl7.org/fhir/SearchParameter/Coverage-policy-holder"/>
        <name value="policy-holder"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="policy-holder"/>
        <base value="Coverage"/>
        <type value="reference"/>
        <description value="Reference to the policyholder"/>
        <expression value="Coverage.policyHolder"/>
        <xpath value="f:Coverage/f:policyHolder"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
        <target value="Patient"/>
        <target value="RelatedPerson"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="sequence"/>
        <base value="Coverage"/>
        <type value="string"/>
        <description value="Sequence number"/>
        <expression value="Coverage.sequence"/>
        <xpath value="f:Coverage/f:sequence"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Coverage-subclass"/>
    <resource>
      <SearchParameter>
        <id value="Coverage-subclass"/>
        <url value="http://hl7.org/fhir/SearchParameter/Coverage-subclass"/>
        <name value="subclass"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="subclass"/>
        <base value="Coverage"/>
        <type value="string"/>
        <description value="Sub-class identifier"/>
        <expression value="Coverage.grouping.subClass"/>
        <xpath value="f:Coverage/f:grouping/f:subClass"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Coverage-subgroup"/>
    <resource>
      <SearchParameter>
        <id value="Coverage-subgroup"/>
        <url value="http://hl7.org/fhir/SearchParameter/Coverage-subgroup"/>
        <name value="subgroup"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="subgroup"/>
        <base value="Coverage"/>
        <type value="string"/>
        <description value="Sub-group identifier"/>
        <expression value="Coverage.grouping.subGroup"/>
        <xpath value="f:Coverage/f:grouping/f:subGroup"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="subplan"/>
        <base value="Coverage"/>
        <type value="string"/>
        <description value="Sub-plan identifier"/>
        <expression value="Coverage.grouping.subPlan"/>
        <xpath value="f:Coverage/f:grouping/f:subPlan"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Coverage-subscriber"/>
    <resource>
      <SearchParameter>
        <id value="Coverage-subscriber"/>
        <url value="http://hl7.org/fhir/SearchParameter/Coverage-subscriber"/>
        <name value="subscriber"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="subscriber"/>
        <base value="Coverage"/>
        <type value="reference"/>
        <description value="Reference to the subscriber"/>
        <expression value="Coverage.subscriber"/>
        <xpath value="f:Coverage/f:subscriber"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
        <target value="RelatedPerson"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="type"/>
        <base value="Coverage"/>
        <type value="token"/>
        <description value="The kind of coverage (health plan, auto, Workers Compensation)"/>
        <expression value="Coverage.type"/>
        <xpath value="f:Coverage/f:type"/>
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
