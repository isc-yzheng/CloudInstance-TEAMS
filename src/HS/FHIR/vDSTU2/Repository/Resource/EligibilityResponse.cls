Class HS.FHIR.vDSTU2.Repository.Resource.EligibilityResponse Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-EligibilityResponse"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/EligibilityResponse-identifier"/>
    <resource>
      <SearchParameter>
        <id value="EligibilityResponse-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/EligibilityResponse-identifier"/>
        <name value="identifier"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="identifier"/>
        <base value="EligibilityResponse"/>
        <type value="token"/>
        <description value="The business identifier of the Explanation of Benefit"/>
        <xpath value="f:EligibilityResponse/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
