Class HS.FHIR.vSTU3.Repository.Resource.ExpansionProfile Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-ExpansionProfile"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ExpansionProfile-date"/>
    <resource>
      <SearchParameter>
        <id value="ExpansionProfile-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/ExpansionProfile-date"/>
        <name value="date"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <code value="date"/>
        <base value="ExpansionProfile"/>
        <type value="date"/>
        <description value="The expansion profile publication date"/>
        <expression value="ExpansionProfile.date"/>
        <xpath value="f:ExpansionProfile/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ExpansionProfile-description"/>
    <resource>
      <SearchParameter>
        <id value="ExpansionProfile-description"/>
        <url value="http://hl7.org/fhir/SearchParameter/ExpansionProfile-description"/>
        <name value="description"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <code value="description"/>
        <base value="ExpansionProfile"/>
        <type value="string"/>
        <description value="The description of the expansion profile"/>
        <expression value="ExpansionProfile.description"/>
        <xpath value="f:ExpansionProfile/f:description"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ExpansionProfile-identifier"/>
    <resource>
      <SearchParameter>
        <id value="ExpansionProfile-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/ExpansionProfile-identifier"/>
        <name value="identifier"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <code value="identifier"/>
        <base value="ExpansionProfile"/>
        <type value="token"/>
        <description value="External identifier for the expansion profile"/>
        <expression value="ExpansionProfile.identifier"/>
        <xpath value="f:ExpansionProfile/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ExpansionProfile-jurisdiction"/>
    <resource>
      <SearchParameter>
        <id value="ExpansionProfile-jurisdiction"/>
        <url value="http://hl7.org/fhir/SearchParameter/ExpansionProfile-jurisdiction"/>
        <name value="jurisdiction"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <code value="jurisdiction"/>
        <base value="ExpansionProfile"/>
        <type value="token"/>
        <description value="Intended jurisdiction for the expansion profile"/>
        <expression value="ExpansionProfile.jurisdiction"/>
        <xpath value="f:ExpansionProfile/f:jurisdiction"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ExpansionProfile-name"/>
    <resource>
      <SearchParameter>
        <id value="ExpansionProfile-name"/>
        <url value="http://hl7.org/fhir/SearchParameter/ExpansionProfile-name"/>
        <name value="name"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <code value="name"/>
        <base value="ExpansionProfile"/>
        <type value="string"/>
        <description value="Computationally friendly name of the expansion profile"/>
        <expression value="ExpansionProfile.name"/>
        <xpath value="f:ExpansionProfile/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ExpansionProfile-publisher"/>
    <resource>
      <SearchParameter>
        <id value="ExpansionProfile-publisher"/>
        <url value="http://hl7.org/fhir/SearchParameter/ExpansionProfile-publisher"/>
        <name value="publisher"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <code value="publisher"/>
        <base value="ExpansionProfile"/>
        <type value="string"/>
        <description value="Name of the publisher of the expansion profile"/>
        <expression value="ExpansionProfile.publisher"/>
        <xpath value="f:ExpansionProfile/f:publisher"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ExpansionProfile-status"/>
    <resource>
      <SearchParameter>
        <id value="ExpansionProfile-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/ExpansionProfile-status"/>
        <name value="status"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <code value="status"/>
        <base value="ExpansionProfile"/>
        <type value="token"/>
        <description value="The current status of the expansion profile"/>
        <expression value="ExpansionProfile.status"/>
        <xpath value="f:ExpansionProfile/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ExpansionProfile-url"/>
    <resource>
      <SearchParameter>
        <id value="ExpansionProfile-url"/>
        <url value="http://hl7.org/fhir/SearchParameter/ExpansionProfile-url"/>
        <name value="url"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <code value="url"/>
        <base value="ExpansionProfile"/>
        <type value="uri"/>
        <description value="The uri that identifies the expansion profile"/>
        <expression value="ExpansionProfile.url"/>
        <xpath value="f:ExpansionProfile/f:url"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ExpansionProfile-version"/>
    <resource>
      <SearchParameter>
        <id value="ExpansionProfile-version"/>
        <url value="http://hl7.org/fhir/SearchParameter/ExpansionProfile-version"/>
        <name value="version"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Vocabulary)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/Vocab/index.cfm"/>
          </telecom>
        </contact>
        <code value="version"/>
        <base value="ExpansionProfile"/>
        <type value="token"/>
        <description value="The business version of the expansion profile"/>
        <expression value="ExpansionProfile.version"/>
        <xpath value="f:ExpansionProfile/f:version"/>
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
