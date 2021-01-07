Class HS.FHIR.vDSTU2.Repository.Resource.Group Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Group"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Group-actual"/>
    <resource>
      <SearchParameter>
        <id value="Group-actual"/>
        <url value="http://hl7.org/fhir/SearchParameter/Group-actual"/>
        <name value="actual"/>
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
        <code value="actual"/>
        <base value="Group"/>
        <type value="token"/>
        <description value="Descriptive or actual"/>
        <xpath value="f:Group/f:actual"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Group-characteristic"/>
    <resource>
      <SearchParameter>
        <id value="Group-characteristic"/>
        <url value="http://hl7.org/fhir/SearchParameter/Group-characteristic"/>
        <name value="characteristic"/>
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
        <code value="characteristic"/>
        <base value="Group"/>
        <type value="token"/>
        <description value="Kind of characteristic"/>
        <xpath value="f:Group/f:characteristic/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Group-characteristic-value"/>
    <resource>
      <SearchParameter>
        <id value="Group-characteristic-value"/>
        <url value="http://hl7.org/fhir/SearchParameter/Group-characteristic-value"/>
        <name value="characteristic-value"/>
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
        <code value="characteristic-value"/>
        <base value="Group"/>
        <type value="composite"/>
        <description value="A composite of both characteristic and value"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Group-code"/>
    <resource>
      <SearchParameter>
        <id value="Group-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/Group-code"/>
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
        <base value="Group"/>
        <type value="token"/>
        <description value="The kind of resources contained"/>
        <xpath value="f:Group/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Group-exclude"/>
    <resource>
      <SearchParameter>
        <id value="Group-exclude"/>
        <url value="http://hl7.org/fhir/SearchParameter/Group-exclude"/>
        <name value="exclude"/>
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
        <code value="exclude"/>
        <base value="Group"/>
        <type value="token"/>
        <description value="Group includes or excludes"/>
        <xpath value="f:Group/f:characteristic/f:exclude"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Group-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Group-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Group-identifier"/>
        <name value="identifier"/>
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
        <code value="identifier"/>
        <base value="Group"/>
        <type value="token"/>
        <description value="Unique id"/>
        <xpath value="f:Group/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Group-member"/>
    <resource>
      <SearchParameter>
        <id value="Group-member"/>
        <url value="http://hl7.org/fhir/SearchParameter/Group-member"/>
        <name value="member"/>
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
        <code value="member"/>
        <base value="Group"/>
        <type value="reference"/>
        <description value="Reference to the group member"/>
        <xpath value="f:Group/f:member/f:entity"/>
        <xpathUsage value="normal"/>
        <target value="Medication"/>
        <target value="Device"/>
        <target value="Patient"/>
        <target value="Substance"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Group-type"/>
    <resource>
      <SearchParameter>
        <id value="Group-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/Group-type"/>
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
        <base value="Group"/>
        <type value="token"/>
        <description value="The type of resources the group contains"/>
        <xpath value="f:Group/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Group-value"/>
    <resource>
      <SearchParameter>
        <id value="Group-value"/>
        <url value="http://hl7.org/fhir/SearchParameter/Group-value"/>
        <name value="value"/>
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
        <code value="value"/>
        <base value="Group"/>
        <type value="token"/>
        <description value="Value held by characteristic"/>
        <xpath value="f:Group/f:characteristic/f:valueCodeableConcept | f:Group/f:characteristic/f:valueBoolean | f:Group/f:characteristic/f:valueQuantity | f:Group/f:characteristic/f:valueRange"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
