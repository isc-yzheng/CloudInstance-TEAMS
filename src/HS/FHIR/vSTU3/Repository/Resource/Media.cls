Class HS.FHIR.vSTU3.Repository.Resource.Media Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Media"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Media-based-on"/>
    <resource>
      <SearchParameter>
        <id value="Media-based-on"/>
        <url value="http://hl7.org/fhir/SearchParameter/Media-based-on"/>
        <name value="based-on"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="based-on"/>
        <base value="Media"/>
        <type value="reference"/>
        <description value="Procedure that caused this media to be created"/>
        <expression value="Media.basedOn"/>
        <xpath value="f:Media/f:basedOn"/>
        <xpathUsage value="normal"/>
        <target value="ProcedureRequest"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Media-context"/>
    <resource>
      <SearchParameter>
        <id value="Media-context"/>
        <url value="http://hl7.org/fhir/SearchParameter/Media-context"/>
        <name value="context"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="context"/>
        <base value="Media"/>
        <type value="reference"/>
        <description value="Encounter / Episode associated with media"/>
        <expression value="Media.context"/>
        <xpath value="f:Media/f:context"/>
        <xpathUsage value="normal"/>
        <target value="EpisodeOfCare"/>
        <target value="Encounter"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Media-created"/>
    <resource>
      <SearchParameter>
        <id value="Media-created"/>
        <url value="http://hl7.org/fhir/SearchParameter/Media-created"/>
        <name value="created"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="created"/>
        <base value="Media"/>
        <type value="date"/>
        <description value="Date attachment was first created"/>
        <expression value="Media.content.creation"/>
        <xpath value="f:Media/f:content/f:creation"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Media-date"/>
    <resource>
      <SearchParameter>
        <id value="Media-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/Media-date"/>
        <name value="date"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="date"/>
        <base value="Media"/>
        <type value="date"/>
        <description value="When Media was collected"/>
        <expression value="Media.occurrence"/>
        <xpath value="f:Media/f:occurrenceDateTime | f:Media/f:occurrencePeriod"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Media-device"/>
    <resource>
      <SearchParameter>
        <id value="Media-device"/>
        <url value="http://hl7.org/fhir/SearchParameter/Media-device"/>
        <name value="device"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="device"/>
        <base value="Media"/>
        <type value="reference"/>
        <description value="Observing Device"/>
        <expression value="Media.device"/>
        <xpath value="f:Media/f:device"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="DeviceMetric"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Media-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Media-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Media-identifier"/>
        <name value="identifier"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="identifier"/>
        <base value="Media"/>
        <type value="token"/>
        <description value="Identifier(s) for the image"/>
        <expression value="Media.identifier"/>
        <xpath value="f:Media/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Media-operator"/>
    <resource>
      <SearchParameter>
        <id value="Media-operator"/>
        <url value="http://hl7.org/fhir/SearchParameter/Media-operator"/>
        <name value="operator"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="operator"/>
        <base value="Media"/>
        <type value="reference"/>
        <description value="The person who generated the image"/>
        <expression value="Media.operator"/>
        <xpath value="f:Media/f:operator"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Media-patient"/>
    <resource>
      <SearchParameter>
        <id value="Media-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/Media-patient"/>
        <name value="patient"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="patient"/>
        <base value="Media"/>
        <type value="reference"/>
        <description value="Who/What this Media is a record of"/>
        <expression value="Media.subject"/>
        <xpath value="f:Media/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Media-site"/>
    <resource>
      <SearchParameter>
        <id value="Media-site"/>
        <url value="http://hl7.org/fhir/SearchParameter/Media-site"/>
        <name value="site"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="site"/>
        <base value="Media"/>
        <type value="token"/>
        <description value="Body part in media"/>
        <expression value="Media.bodySite"/>
        <xpath value="f:Media/f:bodySite"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Media-subject"/>
    <resource>
      <SearchParameter>
        <id value="Media-subject"/>
        <url value="http://hl7.org/fhir/SearchParameter/Media-subject"/>
        <name value="subject"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="subject"/>
        <base value="Media"/>
        <type value="reference"/>
        <description value="Who/What this Media is a record of"/>
        <expression value="Media.subject"/>
        <xpath value="f:Media/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="Group"/>
        <target value="Specimen"/>
        <target value="Device"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Media-subtype"/>
    <resource>
      <SearchParameter>
        <id value="Media-subtype"/>
        <url value="http://hl7.org/fhir/SearchParameter/Media-subtype"/>
        <name value="subtype"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="subtype"/>
        <base value="Media"/>
        <type value="token"/>
        <description value="The type of acquisition equipment/process"/>
        <expression value="Media.subtype"/>
        <xpath value="f:Media/f:subtype"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Media-type"/>
    <resource>
      <SearchParameter>
        <id value="Media-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/Media-type"/>
        <name value="type"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="type"/>
        <base value="Media"/>
        <type value="token"/>
        <description value="photo | video | audio"/>
        <expression value="Media.type"/>
        <xpath value="f:Media/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Media-view"/>
    <resource>
      <SearchParameter>
        <id value="Media-view"/>
        <url value="http://hl7.org/fhir/SearchParameter/Media-view"/>
        <name value="view"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <code value="view"/>
        <base value="Media"/>
        <type value="token"/>
        <description value="Imaging view, e.g. Lateral or Antero-posterior"/>
        <expression value="Media.view"/>
        <xpath value="f:Media/f:view"/>
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
