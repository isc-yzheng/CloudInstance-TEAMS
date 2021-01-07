Class HS.FHIR.vSTU3.Repository.Resource.Linkage Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Linkage"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Linkage-author"/>
    <resource>
      <SearchParameter>
        <id value="Linkage-author"/>
        <url value="http://hl7.org/fhir/SearchParameter/Linkage-author"/>
        <name value="author"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <code value="author"/>
        <base value="Linkage"/>
        <type value="reference"/>
        <description value="Author of the Linkage"/>
        <expression value="Linkage.author"/>
        <xpath value="f:Linkage/f:author"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Linkage-item"/>
    <resource>
      <SearchParameter>
        <id value="Linkage-item"/>
        <url value="http://hl7.org/fhir/SearchParameter/Linkage-item"/>
        <name value="item"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <code value="item"/>
        <base value="Linkage"/>
        <type value="reference"/>
        <description value="Matches on any item in the Linkage"/>
        <expression value="Linkage.item.resource"/>
        <xpath value="f:Linkage/f:item/f:resource"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Linkage-source"/>
    <resource>
      <SearchParameter>
        <id value="Linkage-source"/>
        <url value="http://hl7.org/fhir/SearchParameter/Linkage-source"/>
        <name value="source"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <code value="source"/>
        <base value="Linkage"/>
        <type value="reference"/>
        <description value="Matches on any item in the Linkage with a type of &apos;source&apos;"/>
        <expression value="Linkage.item.resource"/>
        <xpath value="f:Linkage/f:item/f:resource"/>
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
