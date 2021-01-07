Class HS.FHIR.vDSTU2.Repository.Resource.NamingSystem Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

/// Excluded because we do not currently support searching on a collection of periods.
Parameter EXCLUDEPARAMS = ",period,";

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-NamingSystem"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/NamingSystem-contact"/>
    <resource>
      <SearchParameter>
        <id value="NamingSystem-contact"/>
        <url value="http://hl7.org/fhir/SearchParameter/NamingSystem-contact"/>
        <name value="contact"/>
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
        <code value="contact"/>
        <base value="NamingSystem"/>
        <type value="string"/>
        <description value="Name of a individual to contact"/>
        <xpath value="f:NamingSystem/f:contact/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/NamingSystem-context"/>
    <resource>
      <SearchParameter>
        <id value="NamingSystem-context"/>
        <url value="http://hl7.org/fhir/SearchParameter/NamingSystem-context"/>
        <name value="context"/>
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
        <code value="context"/>
        <base value="NamingSystem"/>
        <type value="token"/>
        <description value="Content intends to support these contexts"/>
        <xpath value="f:NamingSystem/f:useContext"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/NamingSystem-date"/>
    <resource>
      <SearchParameter>
        <id value="NamingSystem-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/NamingSystem-date"/>
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
        <base value="NamingSystem"/>
        <type value="date"/>
        <description value="Publication Date(/time)"/>
        <xpath value="f:NamingSystem/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/NamingSystem-id-type"/>
    <resource>
      <SearchParameter>
        <id value="NamingSystem-id-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/NamingSystem-id-type"/>
        <name value="id-type"/>
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
        <code value="id-type"/>
        <base value="NamingSystem"/>
        <type value="token"/>
        <description value="oid | uuid | uri | other"/>
        <xpath value="f:NamingSystem/f:uniqueId/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/NamingSystem-kind"/>
    <resource>
      <SearchParameter>
        <id value="NamingSystem-kind"/>
        <url value="http://hl7.org/fhir/SearchParameter/NamingSystem-kind"/>
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
        <base value="NamingSystem"/>
        <type value="token"/>
        <description value="codesystem | identifier | root"/>
        <xpath value="f:NamingSystem/f:kind"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/NamingSystem-name"/>
    <resource>
      <SearchParameter>
        <id value="NamingSystem-name"/>
        <url value="http://hl7.org/fhir/SearchParameter/NamingSystem-name"/>
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
        <base value="NamingSystem"/>
        <type value="string"/>
        <description value="Human-readable label"/>
        <xpath value="f:NamingSystem/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/NamingSystem-period"/>
    <resource>
      <SearchParameter>
        <id value="NamingSystem-period"/>
        <url value="http://hl7.org/fhir/SearchParameter/NamingSystem-period"/>
        <name value="period"/>
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
        <code value="period"/>
        <base value="NamingSystem"/>
        <type value="date"/>
        <description value="When is identifier valid?"/>
        <xpath value="f:NamingSystem/f:uniqueId/f:period"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/NamingSystem-publisher"/>
    <resource>
      <SearchParameter>
        <id value="NamingSystem-publisher"/>
        <url value="http://hl7.org/fhir/SearchParameter/NamingSystem-publisher"/>
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
        <base value="NamingSystem"/>
        <type value="string"/>
        <description value="Name of the publisher (Organization or individual)"/>
        <xpath value="f:NamingSystem/f:publisher"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/NamingSystem-replaced-by"/>
    <resource>
      <SearchParameter>
        <id value="NamingSystem-replaced-by"/>
        <url value="http://hl7.org/fhir/SearchParameter/NamingSystem-replaced-by"/>
        <name value="replaced-by"/>
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
        <code value="replaced-by"/>
        <base value="NamingSystem"/>
        <type value="reference"/>
        <description value="Use this instead"/>
        <xpath value="f:NamingSystem/f:replacedBy"/>
        <xpathUsage value="normal"/>
        <target value="NamingSystem"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/NamingSystem-responsible"/>
    <resource>
      <SearchParameter>
        <id value="NamingSystem-responsible"/>
        <url value="http://hl7.org/fhir/SearchParameter/NamingSystem-responsible"/>
        <name value="responsible"/>
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
        <code value="responsible"/>
        <base value="NamingSystem"/>
        <type value="string"/>
        <description value="Who maintains system namespace?"/>
        <xpath value="f:NamingSystem/f:responsible"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/NamingSystem-status"/>
    <resource>
      <SearchParameter>
        <id value="NamingSystem-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/NamingSystem-status"/>
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
        <base value="NamingSystem"/>
        <type value="token"/>
        <description value="draft | active | retired"/>
        <xpath value="f:NamingSystem/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/NamingSystem-telecom"/>
    <resource>
      <SearchParameter>
        <id value="NamingSystem-telecom"/>
        <url value="http://hl7.org/fhir/SearchParameter/NamingSystem-telecom"/>
        <name value="telecom"/>
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
        <code value="telecom"/>
        <base value="NamingSystem"/>
        <type value="token"/>
        <description value="Contact details for individual or publisher"/>
        <xpath value="f:NamingSystem/f:contact/f:telecom"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/NamingSystem-type"/>
    <resource>
      <SearchParameter>
        <id value="NamingSystem-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/NamingSystem-type"/>
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
        <base value="NamingSystem"/>
        <type value="token"/>
        <description value="e.g. driver,  provider,  patient, bank etc."/>
        <xpath value="f:NamingSystem/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/NamingSystem-value"/>
    <resource>
      <SearchParameter>
        <id value="NamingSystem-value"/>
        <url value="http://hl7.org/fhir/SearchParameter/NamingSystem-value"/>
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
        <base value="NamingSystem"/>
        <type value="string"/>
        <description value="The unique identifier"/>
        <xpath value="f:NamingSystem/f:uniqueId/f:value"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
