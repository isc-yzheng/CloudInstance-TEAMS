Class HS.FHIR.vDSTU2.Repository.Resource.ImagingStudy Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-ImagingStudy"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImagingStudy-accession"/>
    <resource>
      <SearchParameter>
        <id value="ImagingStudy-accession"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImagingStudy-accession"/>
        <name value="accession"/>
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
        <code value="accession"/>
        <base value="ImagingStudy"/>
        <type value="token"/>
        <description value="The accession identifier for the study"/>
        <xpath value="f:ImagingStudy/f:accession"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImagingStudy-bodysite"/>
    <resource>
      <SearchParameter>
        <id value="ImagingStudy-bodysite"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImagingStudy-bodysite"/>
        <name value="bodysite"/>
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
        <code value="bodysite"/>
        <base value="ImagingStudy"/>
        <type value="token"/>
        <description value="The body site studied"/>
        <xpath value="f:ImagingStudy/f:series/f:bodySite"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImagingStudy-dicom-class"/>
    <resource>
      <SearchParameter>
        <id value="ImagingStudy-dicom-class"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImagingStudy-dicom-class"/>
        <name value="dicom-class"/>
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
        <code value="dicom-class"/>
        <base value="ImagingStudy"/>
        <type value="uri"/>
        <description value="The type of the instance"/>
        <xpath value="f:ImagingStudy/f:series/f:instance/f:sopClass"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImagingStudy-modality"/>
    <resource>
      <SearchParameter>
        <id value="ImagingStudy-modality"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImagingStudy-modality"/>
        <name value="modality"/>
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
        <code value="modality"/>
        <base value="ImagingStudy"/>
        <type value="token"/>
        <description value="The modality of the series"/>
        <xpath value="f:ImagingStudy/f:series/f:modality"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImagingStudy-order"/>
    <resource>
      <SearchParameter>
        <id value="ImagingStudy-order"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImagingStudy-order"/>
        <name value="order"/>
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
        <code value="order"/>
        <base value="ImagingStudy"/>
        <type value="reference"/>
        <description value="The order for the image"/>
        <xpath value="f:ImagingStudy/f:order"/>
        <xpathUsage value="normal"/>
        <target value="DiagnosticOrder"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImagingStudy-patient"/>
    <resource>
      <SearchParameter>
        <id value="ImagingStudy-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImagingStudy-patient"/>
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
        <base value="ImagingStudy"/>
        <type value="reference"/>
        <description value="Who the study is about"/>
        <xpath value="f:ImagingStudy/f:patient"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImagingStudy-series"/>
    <resource>
      <SearchParameter>
        <id value="ImagingStudy-series"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImagingStudy-series"/>
        <name value="series"/>
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
        <code value="series"/>
        <base value="ImagingStudy"/>
        <type value="uri"/>
        <description value="The identifier of the series of images"/>
        <xpath value="f:ImagingStudy/f:series/f:uid"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImagingStudy-started"/>
    <resource>
      <SearchParameter>
        <id value="ImagingStudy-started"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImagingStudy-started"/>
        <name value="started"/>
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
        <code value="started"/>
        <base value="ImagingStudy"/>
        <type value="date"/>
        <description value="When the study was started"/>
        <xpath value="f:ImagingStudy/f:started"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImagingStudy-study"/>
    <resource>
      <SearchParameter>
        <id value="ImagingStudy-study"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImagingStudy-study"/>
        <name value="study"/>
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
        <code value="study"/>
        <base value="ImagingStudy"/>
        <type value="uri"/>
        <description value="The study identifier for the image"/>
        <xpath value="f:ImagingStudy/f:uid"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ImagingStudy-uid"/>
    <resource>
      <SearchParameter>
        <id value="ImagingStudy-uid"/>
        <url value="http://hl7.org/fhir/SearchParameter/ImagingStudy-uid"/>
        <name value="uid"/>
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
        <code value="uid"/>
        <base value="ImagingStudy"/>
        <type value="uri"/>
        <description value="The instance unique identifier"/>
        <xpath value="f:ImagingStudy/f:series/f:instance/f:uid"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
