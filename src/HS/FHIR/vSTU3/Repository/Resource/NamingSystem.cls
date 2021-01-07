Class HS.FHIR.vSTU3.Repository.Resource.NamingSystem Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

/// Excluded because we do not currently support searching on a collection of periods.
Parameter EXCLUDEPARAMS = ",period,";

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-NamingSystem"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/NamingSystem-contact"/>
    <resource>
      <SearchParameter>
        <id value="NamingSystem-contact"/>
        <url value="http://hl7.org/fhir/SearchParameter/NamingSystem-contact"/>
        <name value="contact"/>
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
        <code value="contact"/>
        <base value="NamingSystem"/>
        <type value="string"/>
        <description value="Name of an individual to contact"/>
        <expression value="NamingSystem.contact.name"/>
        <xpath value="f:NamingSystem/f:contact/f:name"/>
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
        <base value="NamingSystem"/>
        <type value="date"/>
        <description value="The naming system publication date"/>
        <expression value="NamingSystem.date"/>
        <xpath value="f:NamingSystem/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/NamingSystem-description"/>
    <resource>
      <SearchParameter>
        <id value="NamingSystem-description"/>
        <url value="http://hl7.org/fhir/SearchParameter/NamingSystem-description"/>
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
        <base value="NamingSystem"/>
        <type value="string"/>
        <description value="The description of the naming system"/>
        <expression value="NamingSystem.description"/>
        <xpath value="f:NamingSystem/f:description"/>
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
        <code value="id-type"/>
        <base value="NamingSystem"/>
        <type value="token"/>
        <description value="oid | uuid | uri | other"/>
        <expression value="NamingSystem.uniqueId.type"/>
        <xpath value="f:NamingSystem/f:uniqueId/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/NamingSystem-jurisdiction"/>
    <resource>
      <SearchParameter>
        <id value="NamingSystem-jurisdiction"/>
        <url value="http://hl7.org/fhir/SearchParameter/NamingSystem-jurisdiction"/>
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
        <base value="NamingSystem"/>
        <type value="token"/>
        <description value="Intended jurisdiction for the naming system"/>
        <expression value="NamingSystem.jurisdiction"/>
        <xpath value="f:NamingSystem/f:jurisdiction"/>
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
        <base value="NamingSystem"/>
        <type value="token"/>
        <description value="codesystem | identifier | root"/>
        <expression value="NamingSystem.kind"/>
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
        <base value="NamingSystem"/>
        <type value="string"/>
        <description value="Computationally friendly name of the naming system"/>
        <expression value="NamingSystem.name"/>
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
        <code value="period"/>
        <base value="NamingSystem"/>
        <type value="date"/>
        <description value="When is identifier valid?"/>
        <expression value="NamingSystem.uniqueId.period"/>
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
        <base value="NamingSystem"/>
        <type value="string"/>
        <description value="Name of the publisher of the naming system"/>
        <expression value="NamingSystem.publisher"/>
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
        <code value="replaced-by"/>
        <base value="NamingSystem"/>
        <type value="reference"/>
        <description value="Use this instead"/>
        <expression value="NamingSystem.replacedBy"/>
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
        <code value="responsible"/>
        <base value="NamingSystem"/>
        <type value="string"/>
        <description value="Who maintains system namespace?"/>
        <expression value="NamingSystem.responsible"/>
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
        <base value="NamingSystem"/>
        <type value="token"/>
        <description value="The current status of the naming system"/>
        <expression value="NamingSystem.status"/>
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
        <code value="telecom"/>
        <base value="NamingSystem"/>
        <type value="token"/>
        <description value="Contact details for individual or organization"/>
        <expression value="NamingSystem.contact.telecom"/>
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
        <base value="NamingSystem"/>
        <type value="token"/>
        <description value="e.g. driver,  provider,  patient, bank etc."/>
        <expression value="NamingSystem.type"/>
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
        <base value="NamingSystem"/>
        <type value="string"/>
        <description value="The unique identifier"/>
        <expression value="NamingSystem.uniqueId.value"/>
        <xpath value="f:NamingSystem/f:uniqueId/f:value"/>
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
