Class HS.FHIR.vSTU3.Repository.Resource.ResearchSubject Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-ResearchSubject"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ResearchSubject-date"/>
    <resource>
      <SearchParameter>
        <id value="ResearchSubject-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/ResearchSubject-date"/>
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
        <base value="ResearchSubject"/>
        <type value="date"/>
        <description value="Start and end of participation"/>
        <expression value="ResearchSubject.period"/>
        <xpath value="f:ResearchSubject/f:period"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ResearchSubject-identifier"/>
    <resource>
      <SearchParameter>
        <id value="ResearchSubject-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/ResearchSubject-identifier"/>
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
        <base value="ResearchSubject"/>
        <type value="token"/>
        <description value="Business Identifier for research subject"/>
        <expression value="ResearchSubject.identifier"/>
        <xpath value="f:ResearchSubject/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ResearchSubject-individual"/>
    <resource>
      <SearchParameter>
        <id value="ResearchSubject-individual"/>
        <url value="http://hl7.org/fhir/SearchParameter/ResearchSubject-individual"/>
        <name value="individual"/>
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
        <code value="individual"/>
        <base value="ResearchSubject"/>
        <type value="reference"/>
        <description value="Who is part of study"/>
        <expression value="ResearchSubject.individual"/>
        <xpath value="f:ResearchSubject/f:individual"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ResearchSubject-patient"/>
    <resource>
      <SearchParameter>
        <id value="ResearchSubject-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/ResearchSubject-patient"/>
        <name value="patient"/>
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
        <code value="patient"/>
        <base value="ResearchSubject"/>
        <type value="reference"/>
        <description value="Who is part of study"/>
        <expression value="ResearchSubject.individual"/>
        <xpath value="f:ResearchSubject/f:individual"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ResearchSubject-status"/>
    <resource>
      <SearchParameter>
        <id value="ResearchSubject-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/ResearchSubject-status"/>
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
        <base value="ResearchSubject"/>
        <type value="token"/>
        <description value="candidate | enrolled | active | suspended | withdrawn | completed"/>
        <expression value="ResearchSubject.status"/>
        <xpath value="f:ResearchSubject/f:status"/>
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
