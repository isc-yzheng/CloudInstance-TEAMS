Class HS.FHIR.vDSTU2.Repository.Resource.Bundle Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Parameter EXCLUDEPARAMS = ",composition,message,";

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Bundle"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Bundle-composition"/>
    <resource>
      <SearchParameter>
        <id value="Bundle-composition"/>
        <url value="http://hl7.org/fhir/SearchParameter/Bundle-composition"/>
        <name value="composition"/>
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
        <code value="composition"/>
        <base value="Bundle"/>
        <type value="reference"/>
        <description value="The first resource in the bundle, if the bundle type is &quot;document&quot; - this is a composition, and this parameter provides access to searches its contents"/>
        <xpath value="f:Bundle/f:entry/f:resource[0]"/>
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
        <code value="message"/>
        <base value="Bundle"/>
        <type value="reference"/>
        <description value="The first resource in the bundle, if the bundle type is &quot;message&quot; - this is a message header, and this parameter provides access to search its contents"/>
        <xpath value="f:Bundle/f:entry/f:resource[0]"/>
        <xpathUsage value="normal"/>
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
        <base value="Bundle"/>
        <type value="token"/>
        <description value="document | message | transaction | transaction-response | batch | batch-response | history | searchset | collection"/>
        <xpath value="f:Bundle/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
