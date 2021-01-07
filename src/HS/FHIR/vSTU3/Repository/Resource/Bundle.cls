Class HS.FHIR.vSTU3.Repository.Resource.Bundle Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

Parameter EXCLUDEPARAMS = ",composition,message,";

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Bundle"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Bundle-composition"/>
    <resource>
      <SearchParameter>
        <id value="Bundle-composition"/>
        <url value="http://hl7.org/fhir/SearchParameter/Bundle-composition"/>
        <name value="composition"/>
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
        <code value="composition"/>
        <base value="Bundle"/>
        <type value="reference"/>
        <description value="The first resource in the bundle, if the bundle type is &quot;document&quot; - this is a composition, and this parameter provides access to searches its contents"/>
        <expression value="Bundle.entry[0].resource"/>
        <xpath value="f:Bundle/f:entry[0]/f:resource"/>
        <xpathUsage value="normal"/>
        <target value="Composition"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Bundle-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Bundle-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Bundle-identifier"/>
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
        <base value="Bundle"/>
        <type value="token"/>
        <description value="Persistent identifier for the bundle"/>
        <expression value="Bundle.identifier"/>
        <xpath value="f:Bundle/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Bundle-message"/>
    <resource>
      <SearchParameter>
        <id value="Bundle-message"/>
        <url value="http://hl7.org/fhir/SearchParameter/Bundle-message"/>
        <name value="message"/>
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
        <code value="message"/>
        <base value="Bundle"/>
        <type value="reference"/>
        <description value="The first resource in the bundle, if the bundle type is &quot;message&quot; - this is a message header, and this parameter provides access to search its contents"/>
        <expression value="Bundle.entry[0].resource"/>
        <xpath value="f:Bundle/f:entry[0]/f:resource"/>
        <xpathUsage value="normal"/>
        <target value="MessageHeader"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Bundle-type"/>
    <resource>
      <SearchParameter>
        <id value="Bundle-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/Bundle-type"/>
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
        <base value="Bundle"/>
        <type value="token"/>
        <description value="document | message | transaction | transaction-response | batch | batch-response | history | searchset | collection"/>
        <expression value="Bundle.type"/>
        <xpath value="f:Bundle/f:type"/>
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
