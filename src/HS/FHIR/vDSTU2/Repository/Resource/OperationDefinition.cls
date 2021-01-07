Class HS.FHIR.vDSTU2.Repository.Resource.OperationDefinition Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-OperationDefinition"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/OperationDefinition-base"/>
    <resource>
      <SearchParameter>
        <id value="OperationDefinition-base"/>
        <url value="http://hl7.org/fhir/SearchParameter/OperationDefinition-base"/>
        <name value="base"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="base"/>
        <base value="OperationDefinition"/>
        <type value="reference"/>
        <description value="Marks this as a profile of the base"/>
        <xpath value="f:OperationDefinition/f:base"/>
        <xpathUsage value="normal"/>
        <target value="OperationDefinition"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/OperationDefinition-code"/>
    <resource>
      <SearchParameter>
        <id value="OperationDefinition-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/OperationDefinition-code"/>
        <name value="code"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="code"/>
        <base value="OperationDefinition"/>
        <type value="token"/>
        <description value="Name used to invoke the operation"/>
        <xpath value="f:OperationDefinition/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/OperationDefinition-date"/>
    <resource>
      <SearchParameter>
        <id value="OperationDefinition-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/OperationDefinition-date"/>
        <name value="date"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="date"/>
        <base value="OperationDefinition"/>
        <type value="date"/>
        <description value="Date for this version of the operation definition"/>
        <xpath value="f:OperationDefinition/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/OperationDefinition-instance"/>
    <resource>
      <SearchParameter>
        <id value="OperationDefinition-instance"/>
        <url value="http://hl7.org/fhir/SearchParameter/OperationDefinition-instance"/>
        <name value="instance"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="instance"/>
        <base value="OperationDefinition"/>
        <type value="token"/>
        <description value="Invoke on an instance?"/>
        <xpath value="f:OperationDefinition/f:instance"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/OperationDefinition-kind"/>
    <resource>
      <SearchParameter>
        <id value="OperationDefinition-kind"/>
        <url value="http://hl7.org/fhir/SearchParameter/OperationDefinition-kind"/>
        <name value="kind"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="kind"/>
        <base value="OperationDefinition"/>
        <type value="token"/>
        <description value="operation | query"/>
        <xpath value="f:OperationDefinition/f:kind"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/OperationDefinition-name"/>
    <resource>
      <SearchParameter>
        <id value="OperationDefinition-name"/>
        <url value="http://hl7.org/fhir/SearchParameter/OperationDefinition-name"/>
        <name value="name"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="name"/>
        <base value="OperationDefinition"/>
        <type value="string"/>
        <description value="Informal name for this operation"/>
        <xpath value="f:OperationDefinition/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/OperationDefinition-profile"/>
    <resource>
      <SearchParameter>
        <id value="OperationDefinition-profile"/>
        <url value="http://hl7.org/fhir/SearchParameter/OperationDefinition-profile"/>
        <name value="profile"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="profile"/>
        <base value="OperationDefinition"/>
        <type value="reference"/>
        <description value="Profile on the type"/>
        <xpath value="f:OperationDefinition/f:parameter/f:profile"/>
        <xpathUsage value="normal"/>
        <target value="StructureDefinition"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/OperationDefinition-publisher"/>
    <resource>
      <SearchParameter>
        <id value="OperationDefinition-publisher"/>
        <url value="http://hl7.org/fhir/SearchParameter/OperationDefinition-publisher"/>
        <name value="publisher"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="publisher"/>
        <base value="OperationDefinition"/>
        <type value="string"/>
        <description value="Name of the publisher (Organization or individual)"/>
        <xpath value="f:OperationDefinition/f:publisher"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/OperationDefinition-status"/>
    <resource>
      <SearchParameter>
        <id value="OperationDefinition-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/OperationDefinition-status"/>
        <name value="status"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="status"/>
        <base value="OperationDefinition"/>
        <type value="token"/>
        <description value="draft | active | retired"/>
        <xpath value="f:OperationDefinition/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/OperationDefinition-system"/>
    <resource>
      <SearchParameter>
        <id value="OperationDefinition-system"/>
        <url value="http://hl7.org/fhir/SearchParameter/OperationDefinition-system"/>
        <name value="system"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="system"/>
        <base value="OperationDefinition"/>
        <type value="token"/>
        <description value="Invoke at the system level?"/>
        <xpath value="f:OperationDefinition/f:system"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/OperationDefinition-type"/>
    <resource>
      <SearchParameter>
        <id value="OperationDefinition-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/OperationDefinition-type"/>
        <name value="type"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="type"/>
        <base value="OperationDefinition"/>
        <type value="token"/>
        <description value="Invoke at resource level for these type"/>
        <xpath value="f:OperationDefinition/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/OperationDefinition-url"/>
    <resource>
      <SearchParameter>
        <id value="OperationDefinition-url"/>
        <url value="http://hl7.org/fhir/SearchParameter/OperationDefinition-url"/>
        <name value="url"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="url"/>
        <base value="OperationDefinition"/>
        <type value="uri"/>
        <description value="Logical URL to reference this operation definition"/>
        <xpath value="f:OperationDefinition/f:url"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/OperationDefinition-version"/>
    <resource>
      <SearchParameter>
        <id value="OperationDefinition-version"/>
        <url value="http://hl7.org/fhir/SearchParameter/OperationDefinition-version"/>
        <name value="version"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="version"/>
        <base value="OperationDefinition"/>
        <type value="token"/>
        <description value="Logical id for this version of the operation definition"/>
        <xpath value="f:OperationDefinition/f:version"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
