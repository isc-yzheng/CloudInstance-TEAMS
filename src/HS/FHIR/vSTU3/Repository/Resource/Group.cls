Class HS.FHIR.vSTU3.Repository.Resource.Group Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Group"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Group-actual"/>
    <resource>
      <SearchParameter>
        <id value="Group-actual"/>
        <url value="http://hl7.org/fhir/SearchParameter/Group-actual"/>
        <name value="actual"/>
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
        <code value="actual"/>
        <base value="Group"/>
        <type value="token"/>
        <description value="Descriptive or actual"/>
        <expression value="Group.actual"/>
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
        <code value="characteristic"/>
        <base value="Group"/>
        <type value="token"/>
        <description value="Kind of characteristic"/>
        <expression value="Group.characteristic.code"/>
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
        <code value="characteristic-value"/>
        <base value="Group"/>
        <type value="composite"/>
        <description value="A composite of both characteristic and value"/>
        <expression value="Group.characteristic"/>
        <xpathUsage value="normal"/>
        <component>
          <definition>
            <reference value="http://hl7.org/fhir/SearchParameter/Group-characteristic"/>
          </definition>
          <expression value="code"/>
        </component>
        <component>
          <definition>
            <reference value="http://hl7.org/fhir/SearchParameter/Group-value"/>
          </definition>
          <expression value="value"/>
        </component>
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
        <code value="code"/>
        <base value="Group"/>
        <type value="token"/>
        <description value="The kind of resources contained"/>
        <expression value="Group.code"/>
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
        <code value="exclude"/>
        <base value="Group"/>
        <type value="token"/>
        <description value="Group includes or excludes"/>
        <expression value="Group.characteristic.exclude"/>
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
        <base value="Group"/>
        <type value="token"/>
        <description value="Unique id"/>
        <expression value="Group.identifier"/>
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
        <code value="member"/>
        <base value="Group"/>
        <type value="reference"/>
        <description value="Reference to the group member"/>
        <expression value="Group.member.entity"/>
        <xpath value="f:Group/f:member/f:entity"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="Device"/>
        <target value="Medication"/>
        <target value="Patient"/>
        <target value="Substance"/>
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
        <code value="type"/>
        <base value="Group"/>
        <type value="token"/>
        <description value="The type of resources the group contains"/>
        <expression value="Group.type"/>
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
        <code value="value"/>
        <base value="Group"/>
        <type value="token"/>
        <description value="Value held by characteristic"/>
        <expression value="Group.characteristic.value"/>
        <xpath value="f:Group/f:characteristic/f:valueCodeableConcept | f:Group/f:characteristic/f:valueBoolean | f:Group/f:characteristic/f:valueQuantity | f:Group/f:characteristic/f:valueRange"/>
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
