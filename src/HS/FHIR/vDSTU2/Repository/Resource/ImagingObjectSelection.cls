Class HS.FHIR.vDSTU2.Repository.Resource.ImagingObjectSelection Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-ImagingObjectSelection"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImagingObjectSelection-author"/>
    <resource>
      <SearchParameter>
        <id value="ImagingObjectSelection-author"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImagingObjectSelection-author"/>
        <name value="author"/>
        <publisher value="Health Level Seven International (Imaging Integration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/imagemgt/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="author"/>
        <base value="ImagingObjectSelection"/>
        <type value="reference"/>
        <description value="Author of key DICOM object selection"/>
        <xpath value="f:ImagingObjectSelection/f:author"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="Patient"/>
        <target value="Organization"/>
        <target value="Practitioner"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImagingObjectSelection-authoring-time"/>
    <resource>
      <SearchParameter>
        <id value="ImagingObjectSelection-authoring-time"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImagingObjectSelection-authoring-time"/>
        <name value="authoring-time"/>
        <publisher value="Health Level Seven International (Imaging Integration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/imagemgt/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="authoring-time"/>
        <base value="ImagingObjectSelection"/>
        <type value="date"/>
        <description value="Time of key DICOM object selection authoring"/>
        <xpath value="f:ImagingObjectSelection/f:authoringTime"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImagingObjectSelection-identifier"/>
    <resource>
      <SearchParameter>
        <id value="ImagingObjectSelection-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImagingObjectSelection-identifier"/>
        <name value="identifier"/>
        <publisher value="Health Level Seven International (Imaging Integration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/imagemgt/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="identifier"/>
        <base value="ImagingObjectSelection"/>
        <type value="uri"/>
        <description value="UID of key DICOM object selection"/>
        <xpath value="f:ImagingObjectSelection/f:uid"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImagingObjectSelection-patient"/>
    <resource>
      <SearchParameter>
        <id value="ImagingObjectSelection-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImagingObjectSelection-patient"/>
        <name value="patient"/>
        <publisher value="Health Level Seven International (Imaging Integration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/imagemgt/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="patient"/>
        <base value="ImagingObjectSelection"/>
        <type value="reference"/>
        <description value="Subject of key DICOM object selection"/>
        <xpath value="f:ImagingObjectSelection/f:patient"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImagingObjectSelection-selected-study"/>
    <resource>
      <SearchParameter>
        <id value="ImagingObjectSelection-selected-study"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImagingObjectSelection-selected-study"/>
        <name value="selected-study"/>
        <publisher value="Health Level Seven International (Imaging Integration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/imagemgt/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="selected-study"/>
        <base value="ImagingObjectSelection"/>
        <type value="uri"/>
        <description value="Study selected in key DICOM object selection"/>
        <xpath value="f:ImagingObjectSelection/f:study/f:uid"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImagingObjectSelection-title"/>
    <resource>
      <SearchParameter>
        <id value="ImagingObjectSelection-title"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImagingObjectSelection-title"/>
        <name value="title"/>
        <publisher value="Health Level Seven International (Imaging Integration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/imagemgt/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="title"/>
        <base value="ImagingObjectSelection"/>
        <type value="token"/>
        <description value="Title of key DICOM object selection"/>
        <xpath value="f:ImagingObjectSelection/f:title"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
