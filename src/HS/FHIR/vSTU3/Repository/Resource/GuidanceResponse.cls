Class HS.FHIR.vSTU3.Repository.Resource.GuidanceResponse Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-GuidanceResponse"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/GuidanceResponse-identifier"/>
    <resource>
      <SearchParameter>
        <id value="GuidanceResponse-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/GuidanceResponse-identifier"/>
        <name value="identifier"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Clinical Decision Support)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/dss/index.cfm"/>
          </telecom>
        </contact>
        <code value="identifier"/>
        <base value="GuidanceResponse"/>
        <type value="token"/>
        <description value="The identifier of the guidance response"/>
        <expression value="GuidanceResponse.identifier"/>
        <xpath value="f:GuidanceResponse/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/GuidanceResponse-patient"/>
    <resource>
      <SearchParameter>
        <id value="GuidanceResponse-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/GuidanceResponse-patient"/>
        <name value="patient"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Clinical Decision Support)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/dss/index.cfm"/>
          </telecom>
        </contact>
        <code value="patient"/>
        <base value="GuidanceResponse"/>
        <type value="reference"/>
        <description value="The identity of a patient to search for guidance response results"/>
        <expression value="GuidanceResponse.subject"/>
        <xpath value="f:GuidanceResponse/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/GuidanceResponse-request"/>
    <resource>
      <SearchParameter>
        <id value="GuidanceResponse-request"/>
        <url value="http://hl7.org/fhir/SearchParameter/GuidanceResponse-request"/>
        <name value="request"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Clinical Decision Support)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/dss/index.cfm"/>
          </telecom>
        </contact>
        <code value="request"/>
        <base value="GuidanceResponse"/>
        <type value="token"/>
        <description value="The identifier of the request associated with the response"/>
        <expression value="GuidanceResponse.requestId"/>
        <xpath value="f:GuidanceResponse/f:requestId"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/GuidanceResponse-subject"/>
    <resource>
      <SearchParameter>
        <id value="GuidanceResponse-subject"/>
        <url value="http://hl7.org/fhir/SearchParameter/GuidanceResponse-subject"/>
        <name value="subject"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Clinical Decision Support)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/dss/index.cfm"/>
          </telecom>
        </contact>
        <code value="subject"/>
        <base value="GuidanceResponse"/>
        <type value="reference"/>
        <description value="The subject that the guidance response is about"/>
        <expression value="GuidanceResponse.subject"/>
        <xpath value="f:GuidanceResponse/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Group"/>
        <target value="Patient"/>
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
