Class HS.FHIR.vSTU3.Repository.Resource.MeasureReport Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-MeasureReport"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MeasureReport-identifier"/>
    <resource>
      <SearchParameter>
        <id value="MeasureReport-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/MeasureReport-identifier"/>
        <name value="identifier"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Clinical Quality Information)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/cqi/index.cfm"/>
          </telecom>
        </contact>
        <code value="identifier"/>
        <base value="MeasureReport"/>
        <type value="token"/>
        <description value="External identifier of the measure report to be returned"/>
        <expression value="MeasureReport.identifier"/>
        <xpath value="f:MeasureReport/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MeasureReport-patient"/>
    <resource>
      <SearchParameter>
        <id value="MeasureReport-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/MeasureReport-patient"/>
        <name value="patient"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Clinical Quality Information)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/cqi/index.cfm"/>
          </telecom>
        </contact>
        <code value="patient"/>
        <base value="MeasureReport"/>
        <type value="reference"/>
        <description value="The identity of a patient to search for individual measure report results for"/>
        <expression value="MeasureReport.patient"/>
        <xpath value="f:MeasureReport/f:patient"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MeasureReport-status"/>
    <resource>
      <SearchParameter>
        <id value="MeasureReport-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/MeasureReport-status"/>
        <name value="status"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Clinical Quality Information)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/cqi/index.cfm"/>
          </telecom>
        </contact>
        <code value="status"/>
        <base value="MeasureReport"/>
        <type value="token"/>
        <description value="The status of the measure report"/>
        <expression value="MeasureReport.status"/>
        <xpath value="f:MeasureReport/f:status"/>
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
