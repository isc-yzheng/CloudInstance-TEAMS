Class HS.FHIR.vDSTU2.Repository.Resource.Binary Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Binary"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Binary-contenttype"/>
    <resource>
      <SearchParameter>
        <id value="Binary-contenttype"/>
        <url value="http://hl7.org/fhir/SearchParameter/Binary-contenttype"/>
        <name value="contenttype"/>
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
        <code value="contenttype"/>
        <base value="Binary"/>
        <type value="token"/>
        <description value="MimeType of the binary content"/>
        <xpath value="f:Binary/f:contentType"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
