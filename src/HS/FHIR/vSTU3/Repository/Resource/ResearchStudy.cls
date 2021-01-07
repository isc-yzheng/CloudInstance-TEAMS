Class HS.FHIR.vSTU3.Repository.Resource.ResearchStudy Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-ResearchStudy"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ResearchStudy-category"/>
    <resource>
      <SearchParameter>
        <id value="ResearchStudy-category"/>
        <url value="http://hl7.org/fhir/SearchParameter/ResearchStudy-category"/>
        <name value="category"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Regulated Clinical Research Information Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/rcrim/index.cfm"/>
          </telecom>
        </contact>
        <code value="category"/>
        <base value="ResearchStudy"/>
        <type value="token"/>
        <description value="Classifications for the study"/>
        <expression value="ResearchStudy.category"/>
        <xpath value="f:ResearchStudy/f:category"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ResearchStudy-date"/>
    <resource>
      <SearchParameter>
        <id value="ResearchStudy-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/ResearchStudy-date"/>
        <name value="date"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Regulated Clinical Research Information Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/rcrim/index.cfm"/>
          </telecom>
        </contact>
        <code value="date"/>
        <base value="ResearchStudy"/>
        <type value="date"/>
        <description value="When the study began and ended"/>
        <expression value="ResearchStudy.period"/>
        <xpath value="f:ResearchStudy/f:period"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ResearchStudy-focus"/>
    <resource>
      <SearchParameter>
        <id value="ResearchStudy-focus"/>
        <url value="http://hl7.org/fhir/SearchParameter/ResearchStudy-focus"/>
        <name value="focus"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Regulated Clinical Research Information Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/rcrim/index.cfm"/>
          </telecom>
        </contact>
        <code value="focus"/>
        <base value="ResearchStudy"/>
        <type value="token"/>
        <description value="Drugs, devices, conditions, etc. under study"/>
        <expression value="ResearchStudy.focus"/>
        <xpath value="f:ResearchStudy/f:focus"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ResearchStudy-identifier"/>
    <resource>
      <SearchParameter>
        <id value="ResearchStudy-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/ResearchStudy-identifier"/>
        <name value="identifier"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Regulated Clinical Research Information Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/rcrim/index.cfm"/>
          </telecom>
        </contact>
        <code value="identifier"/>
        <base value="ResearchStudy"/>
        <type value="token"/>
        <description value="Business Identifier for study"/>
        <expression value="ResearchStudy.identifier"/>
        <xpath value="f:ResearchStudy/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ResearchStudy-jurisdiction"/>
    <resource>
      <SearchParameter>
        <id value="ResearchStudy-jurisdiction"/>
        <url value="http://hl7.org/fhir/SearchParameter/ResearchStudy-jurisdiction"/>
        <name value="jurisdiction"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Regulated Clinical Research Information Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/rcrim/index.cfm"/>
          </telecom>
        </contact>
        <code value="jurisdiction"/>
        <base value="ResearchStudy"/>
        <type value="token"/>
        <description value="Geographic region(s) for study"/>
        <expression value="ResearchStudy.jurisdiction"/>
        <xpath value="f:ResearchStudy/f:jurisdiction"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ResearchStudy-keyword"/>
    <resource>
      <SearchParameter>
        <id value="ResearchStudy-keyword"/>
        <url value="http://hl7.org/fhir/SearchParameter/ResearchStudy-keyword"/>
        <name value="keyword"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Regulated Clinical Research Information Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/rcrim/index.cfm"/>
          </telecom>
        </contact>
        <code value="keyword"/>
        <base value="ResearchStudy"/>
        <type value="token"/>
        <description value="Used to search for the study"/>
        <expression value="ResearchStudy.keyword"/>
        <xpath value="f:ResearchStudy/f:keyword"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ResearchStudy-partof"/>
    <resource>
      <SearchParameter>
        <id value="ResearchStudy-partof"/>
        <url value="http://hl7.org/fhir/SearchParameter/ResearchStudy-partof"/>
        <name value="partof"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Regulated Clinical Research Information Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/rcrim/index.cfm"/>
          </telecom>
        </contact>
        <code value="partof"/>
        <base value="ResearchStudy"/>
        <type value="reference"/>
        <description value="Part of larger study"/>
        <expression value="ResearchStudy.partOf"/>
        <xpath value="f:ResearchStudy/f:partOf"/>
        <xpathUsage value="normal"/>
        <target value="ResearchStudy"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ResearchStudy-principalinvestigator"/>
    <resource>
      <SearchParameter>
        <id value="ResearchStudy-principalinvestigator"/>
        <url value="http://hl7.org/fhir/SearchParameter/ResearchStudy-principalinvestigator"/>
        <name value="principalinvestigator"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Regulated Clinical Research Information Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/rcrim/index.cfm"/>
          </telecom>
        </contact>
        <code value="principalinvestigator"/>
        <base value="ResearchStudy"/>
        <type value="reference"/>
        <description value="The individual responsible for the study"/>
        <expression value="ResearchStudy.principalInvestigator"/>
        <xpath value="f:ResearchStudy/f:principalInvestigator"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ResearchStudy-protocol"/>
    <resource>
      <SearchParameter>
        <id value="ResearchStudy-protocol"/>
        <url value="http://hl7.org/fhir/SearchParameter/ResearchStudy-protocol"/>
        <name value="protocol"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Regulated Clinical Research Information Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/rcrim/index.cfm"/>
          </telecom>
        </contact>
        <code value="protocol"/>
        <base value="ResearchStudy"/>
        <type value="reference"/>
        <description value="Steps followed in executing study"/>
        <expression value="ResearchStudy.protocol"/>
        <xpath value="f:ResearchStudy/f:protocol"/>
        <xpathUsage value="normal"/>
        <target value="PlanDefinition"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ResearchStudy-site"/>
    <resource>
      <SearchParameter>
        <id value="ResearchStudy-site"/>
        <url value="http://hl7.org/fhir/SearchParameter/ResearchStudy-site"/>
        <name value="site"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Regulated Clinical Research Information Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/rcrim/index.cfm"/>
          </telecom>
        </contact>
        <code value="site"/>
        <base value="ResearchStudy"/>
        <type value="reference"/>
        <description value="Location involved in study execution"/>
        <expression value="ResearchStudy.site"/>
        <xpath value="f:ResearchStudy/f:site"/>
        <xpathUsage value="normal"/>
        <target value="Location"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ResearchStudy-sponsor"/>
    <resource>
      <SearchParameter>
        <id value="ResearchStudy-sponsor"/>
        <url value="http://hl7.org/fhir/SearchParameter/ResearchStudy-sponsor"/>
        <name value="sponsor"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Regulated Clinical Research Information Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/rcrim/index.cfm"/>
          </telecom>
        </contact>
        <code value="sponsor"/>
        <base value="ResearchStudy"/>
        <type value="reference"/>
        <description value="Organization responsible for the study"/>
        <expression value="ResearchStudy.sponsor"/>
        <xpath value="f:ResearchStudy/f:sponsor"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ResearchStudy-status"/>
    <resource>
      <SearchParameter>
        <id value="ResearchStudy-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/ResearchStudy-status"/>
        <name value="status"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Regulated Clinical Research Information Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/rcrim/index.cfm"/>
          </telecom>
        </contact>
        <code value="status"/>
        <base value="ResearchStudy"/>
        <type value="token"/>
        <description value="draft | in-progress | suspended | stopped | completed | entered-in-error"/>
        <expression value="ResearchStudy.status"/>
        <xpath value="f:ResearchStudy/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ResearchStudy-title"/>
    <resource>
      <SearchParameter>
        <id value="ResearchStudy-title"/>
        <url value="http://hl7.org/fhir/SearchParameter/ResearchStudy-title"/>
        <name value="title"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Regulated Clinical Research Information Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/rcrim/index.cfm"/>
          </telecom>
        </contact>
        <code value="title"/>
        <base value="ResearchStudy"/>
        <type value="string"/>
        <description value="Name for this study"/>
        <expression value="ResearchStudy.title"/>
        <xpath value="f:ResearchStudy/f:title"/>
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
