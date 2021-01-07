Class HS.FHIR.vDSTU2.Repository.Resource.Specimen Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Specimen"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Specimen-accession"/>
    <resource>
      <SearchParameter>
        <id value="Specimen-accession"/>
        <url value="http://hl7.org/fhir/SearchParameter/Specimen-accession"/>
        <name value="accession"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="accession"/>
        <base value="Specimen"/>
        <type value="token"/>
        <description value="The accession number associated with the specimen"/>
        <xpath value="f:Specimen/f:accessionIdentifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Specimen-bodysite"/>
    <resource>
      <SearchParameter>
        <id value="Specimen-bodysite"/>
        <url value="http://hl7.org/fhir/SearchParameter/Specimen-bodysite"/>
        <name value="bodysite"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="bodysite"/>
        <base value="Specimen"/>
        <type value="token"/>
        <description value="The code for the body site from where the specimen originated"/>
        <xpath value="f:Specimen/f:collection/f:bodySite"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Specimen-collected"/>
    <resource>
      <SearchParameter>
        <id value="Specimen-collected"/>
        <url value="http://hl7.org/fhir/SearchParameter/Specimen-collected"/>
        <name value="collected"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="collected"/>
        <base value="Specimen"/>
        <type value="date"/>
        <description value="The date the specimen was collected"/>
        <xpath value="f:Specimen/f:collection/f:collectedDateTime | f:Specimen/f:collection/f:collectedPeriod"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Specimen-collector"/>
    <resource>
      <SearchParameter>
        <id value="Specimen-collector"/>
        <url value="http://hl7.org/fhir/SearchParameter/Specimen-collector"/>
        <name value="collector"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="collector"/>
        <base value="Specimen"/>
        <type value="reference"/>
        <description value="Who collected the specimen"/>
        <xpath value="f:Specimen/f:collection/f:collector"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Specimen-container"/>
    <resource>
      <SearchParameter>
        <id value="Specimen-container"/>
        <url value="http://hl7.org/fhir/SearchParameter/Specimen-container"/>
        <name value="container"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="container"/>
        <base value="Specimen"/>
        <type value="token"/>
        <description value="The kind of specimen container"/>
        <xpath value="f:Specimen/f:container/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Specimen-container-id"/>
    <resource>
      <SearchParameter>
        <id value="Specimen-container-id"/>
        <url value="http://hl7.org/fhir/SearchParameter/Specimen-container-id"/>
        <name value="container-id"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="container-id"/>
        <base value="Specimen"/>
        <type value="token"/>
        <description value="The unique identifier associated with the specimen container"/>
        <xpath value="f:Specimen/f:container/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Specimen-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Specimen-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Specimen-identifier"/>
        <name value="identifier"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="identifier"/>
        <base value="Specimen"/>
        <type value="token"/>
        <description value="The unique identifier associated with the specimen"/>
        <xpath value="f:Specimen/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Specimen-parent"/>
    <resource>
      <SearchParameter>
        <id value="Specimen-parent"/>
        <url value="http://hl7.org/fhir/SearchParameter/Specimen-parent"/>
        <name value="parent"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="parent"/>
        <base value="Specimen"/>
        <type value="reference"/>
        <description value="The parent of the specimen"/>
        <xpath value="f:Specimen/f:parent"/>
        <xpathUsage value="normal"/>
        <target value="Specimen"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Specimen-patient"/>
    <resource>
      <SearchParameter>
        <id value="Specimen-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/Specimen-patient"/>
        <name value="patient"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="patient"/>
        <base value="Specimen"/>
        <type value="reference"/>
        <description value="The patient the specimen comes from"/>
        <xpath value="f:Specimen/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="Patient"/>
        <target value="Substance"/>
        <target value="Group"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Specimen-subject"/>
    <resource>
      <SearchParameter>
        <id value="Specimen-subject"/>
        <url value="http://hl7.org/fhir/SearchParameter/Specimen-subject"/>
        <name value="subject"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="subject"/>
        <base value="Specimen"/>
        <type value="reference"/>
        <description value="The subject of the specimen"/>
        <xpath value="f:Specimen/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="Patient"/>
        <target value="Substance"/>
        <target value="Group"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Specimen-type"/>
    <resource>
      <SearchParameter>
        <id value="Specimen-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/Specimen-type"/>
        <name value="type"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="type"/>
        <base value="Specimen"/>
        <type value="token"/>
        <description value="The specimen type"/>
        <xpath value="f:Specimen/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
