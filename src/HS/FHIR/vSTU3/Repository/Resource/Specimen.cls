Class HS.FHIR.vSTU3.Repository.Resource.Specimen Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Specimen"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Specimen-accession"/>
    <resource>
      <SearchParameter>
        <id value="Specimen-accession"/>
        <url value="http://hl7.org/fhir/SearchParameter/Specimen-accession"/>
        <name value="accession"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="accession"/>
        <base value="Specimen"/>
        <type value="token"/>
        <description value="The accession number associated with the specimen"/>
        <expression value="Specimen.accessionIdentifier"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="bodysite"/>
        <base value="Specimen"/>
        <type value="token"/>
        <description value="The code for the body site from where the specimen originated"/>
        <expression value="Specimen.collection.bodySite"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="collected"/>
        <base value="Specimen"/>
        <type value="date"/>
        <description value="The date the specimen was collected"/>
        <expression value="Specimen.collection.collected"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="collector"/>
        <base value="Specimen"/>
        <type value="reference"/>
        <description value="Who collected the specimen"/>
        <expression value="Specimen.collection.collector"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="container"/>
        <base value="Specimen"/>
        <type value="token"/>
        <description value="The kind of specimen container"/>
        <expression value="Specimen.container.type"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="container-id"/>
        <base value="Specimen"/>
        <type value="token"/>
        <description value="The unique identifier associated with the specimen container"/>
        <expression value="Specimen.container.identifier"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="identifier"/>
        <base value="Specimen"/>
        <type value="token"/>
        <description value="The unique identifier associated with the specimen"/>
        <expression value="Specimen.identifier"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="parent"/>
        <base value="Specimen"/>
        <type value="reference"/>
        <description value="The parent of the specimen"/>
        <expression value="Specimen.parent"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="patient"/>
        <base value="Specimen"/>
        <type value="reference"/>
        <description value="The patient the specimen comes from"/>
        <expression value="Specimen.subject"/>
        <xpath value="f:Specimen/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Specimen-status"/>
    <resource>
      <SearchParameter>
        <id value="Specimen-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/Specimen-status"/>
        <name value="status"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="status"/>
        <base value="Specimen"/>
        <type value="token"/>
        <description value="available | unavailable | unsatisfactory | entered-in-error"/>
        <expression value="Specimen.status"/>
        <xpath value="f:Specimen/f:status"/>
        <xpathUsage value="normal"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="subject"/>
        <base value="Specimen"/>
        <type value="reference"/>
        <description value="The subject of the specimen"/>
        <expression value="Specimen.subject"/>
        <xpath value="f:Specimen/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Group"/>
        <target value="Device"/>
        <target value="Patient"/>
        <target value="Substance"/>
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
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="type"/>
        <base value="Specimen"/>
        <type value="token"/>
        <description value="The specimen type"/>
        <expression value="Specimen.type"/>
        <xpath value="f:Specimen/f:type"/>
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
