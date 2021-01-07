Class HS.FHIR.vDSTU2.Repository.Resource.VisionPrescription Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-VisionPrescription"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/VisionPrescription-datewritten"/>
    <resource>
      <SearchParameter>
        <id value="VisionPrescription-datewritten"/>
        <url value="http://hl7.org/fhir/SearchParameter/VisionPrescription-datewritten"/>
        <name value="datewritten"/>
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
        <code value="datewritten"/>
        <base value="VisionPrescription"/>
        <type value="date"/>
        <description value="Return prescriptions written on this date"/>
        <xpath value="f:VisionPrescription/f:dateWritten"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/VisionPrescription-encounter"/>
    <resource>
      <SearchParameter>
        <id value="VisionPrescription-encounter"/>
        <url value="http://hl7.org/fhir/SearchParameter/VisionPrescription-encounter"/>
        <name value="encounter"/>
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
        <code value="encounter"/>
        <base value="VisionPrescription"/>
        <type value="reference"/>
        <description value="Return prescriptions with this encounter identifier"/>
        <xpath value="f:VisionPrescription/f:encounter"/>
        <xpathUsage value="normal"/>
        <target value="Encounter"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/VisionPrescription-identifier"/>
    <resource>
      <SearchParameter>
        <id value="VisionPrescription-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/VisionPrescription-identifier"/>
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
        <base value="VisionPrescription"/>
        <type value="token"/>
        <description value="Return prescriptions with this external identifier"/>
        <xpath value="f:VisionPrescription/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/VisionPrescription-patient"/>
    <resource>
      <SearchParameter>
        <id value="VisionPrescription-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/VisionPrescription-patient"/>
        <name value="patient"/>
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
        <code value="patient"/>
        <base value="VisionPrescription"/>
        <type value="reference"/>
        <description value="The identity of a patient to list dispenses for"/>
        <xpath value="f:VisionPrescription/f:patient"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/VisionPrescription-prescriber"/>
    <resource>
      <SearchParameter>
        <id value="VisionPrescription-prescriber"/>
        <url value="http://hl7.org/fhir/SearchParameter/VisionPrescription-prescriber"/>
        <name value="prescriber"/>
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
        <code value="prescriber"/>
        <base value="VisionPrescription"/>
        <type value="reference"/>
        <description value="Who authorizes the vision product"/>
        <xpath value="f:VisionPrescription/f:prescriber"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
