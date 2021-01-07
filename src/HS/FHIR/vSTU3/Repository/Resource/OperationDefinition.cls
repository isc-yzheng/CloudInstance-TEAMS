Class HS.FHIR.vSTU3.Repository.Resource.OperationDefinition Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-OperationDefinition"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/OperationDefinition-base"/>
    <resource>
      <SearchParameter>
        <id value="OperationDefinition-base"/>
        <url value="http://hl7.org/fhir/SearchParameter/OperationDefinition-base"/>
        <name value="base"/>
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
        <code value="base"/>
        <base value="OperationDefinition"/>
        <type value="reference"/>
        <description value="Marks this as a profile of the base"/>
        <expression value="OperationDefinition.base"/>
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
        <base value="OperationDefinition"/>
        <type value="token"/>
        <description value="Name used to invoke the operation"/>
        <expression value="OperationDefinition.code"/>
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
        <code value="date"/>
        <base value="OperationDefinition"/>
        <type value="date"/>
        <description value="The operation definition publication date"/>
        <expression value="OperationDefinition.date"/>
        <xpath value="f:OperationDefinition/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/OperationDefinition-description"/>
    <resource>
      <SearchParameter>
        <id value="OperationDefinition-description"/>
        <url value="http://hl7.org/fhir/SearchParameter/OperationDefinition-description"/>
        <name value="description"/>
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
        <code value="description"/>
        <base value="OperationDefinition"/>
        <type value="string"/>
        <description value="The description of the operation definition"/>
        <expression value="OperationDefinition.description"/>
        <xpath value="f:OperationDefinition/f:description"/>
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
        <code value="instance"/>
        <base value="OperationDefinition"/>
        <type value="token"/>
        <description value="Invoke on an instance?"/>
        <expression value="OperationDefinition.instance"/>
        <xpath value="f:OperationDefinition/f:instance"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/OperationDefinition-jurisdiction"/>
    <resource>
      <SearchParameter>
        <id value="OperationDefinition-jurisdiction"/>
        <url value="http://hl7.org/fhir/SearchParameter/OperationDefinition-jurisdiction"/>
        <name value="jurisdiction"/>
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
        <code value="jurisdiction"/>
        <base value="OperationDefinition"/>
        <type value="token"/>
        <description value="Intended jurisdiction for the operation definition"/>
        <expression value="OperationDefinition.jurisdiction"/>
        <xpath value="f:OperationDefinition/f:jurisdiction"/>
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
        <code value="kind"/>
        <base value="OperationDefinition"/>
        <type value="token"/>
        <description value="operation | query"/>
        <expression value="OperationDefinition.kind"/>
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
        <code value="name"/>
        <base value="OperationDefinition"/>
        <type value="string"/>
        <description value="Computationally friendly name of the operation definition"/>
        <expression value="OperationDefinition.name"/>
        <xpath value="f:OperationDefinition/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/OperationDefinition-param-profile"/>
    <resource>
      <SearchParameter>
        <id value="OperationDefinition-param-profile"/>
        <url value="http://hl7.org/fhir/SearchParameter/OperationDefinition-param-profile"/>
        <name value="param-profile"/>
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
        <code value="param-profile"/>
        <base value="OperationDefinition"/>
        <type value="reference"/>
        <description value="Profile on the type"/>
        <expression value="OperationDefinition.parameter.profile"/>
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
        <code value="publisher"/>
        <base value="OperationDefinition"/>
        <type value="string"/>
        <description value="Name of the publisher of the operation definition"/>
        <expression value="OperationDefinition.publisher"/>
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
        <code value="status"/>
        <base value="OperationDefinition"/>
        <type value="token"/>
        <description value="The current status of the operation definition"/>
        <expression value="OperationDefinition.status"/>
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
        <code value="system"/>
        <base value="OperationDefinition"/>
        <type value="token"/>
        <description value="Invoke at the system level?"/>
        <expression value="OperationDefinition.system"/>
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
        <base value="OperationDefinition"/>
        <type value="token"/>
        <description value="Invole at the type level?"/>
        <expression value="OperationDefinition.type"/>
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
        <code value="url"/>
        <base value="OperationDefinition"/>
        <type value="uri"/>
        <description value="The uri that identifies the operation definition"/>
        <expression value="OperationDefinition.url"/>
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
        <code value="version"/>
        <base value="OperationDefinition"/>
        <type value="token"/>
        <description value="The business version of the operation definition"/>
        <expression value="OperationDefinition.version"/>
        <xpath value="f:OperationDefinition/f:version"/>
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
