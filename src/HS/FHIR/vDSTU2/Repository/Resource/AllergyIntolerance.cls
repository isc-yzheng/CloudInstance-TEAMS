Class HS.FHIR.vDSTU2.Repository.Resource.AllergyIntolerance Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-AllergyIntolerance"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AllergyIntolerance-category"/>
    <resource>
      <SearchParameter>
        <id value="AllergyIntolerance-category"/>
        <url value="http://hl7.org/fhir/SearchParameter/AllergyIntolerance-category"/>
        <name value="category"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="category"/>
        <base value="AllergyIntolerance"/>
        <type value="token"/>
        <description value="food | medication | environment | other - Category of Substance"/>
        <xpath value="f:AllergyIntolerance/f:category"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AllergyIntolerance-criticality"/>
    <resource>
      <SearchParameter>
        <id value="AllergyIntolerance-criticality"/>
        <url value="http://hl7.org/fhir/SearchParameter/AllergyIntolerance-criticality"/>
        <name value="criticality"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="criticality"/>
        <base value="AllergyIntolerance"/>
        <type value="token"/>
        <description value="CRITL | CRITH | CRITU"/>
        <xpath value="f:AllergyIntolerance/f:criticality"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AllergyIntolerance-date"/>
    <resource>
      <SearchParameter>
        <id value="AllergyIntolerance-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/AllergyIntolerance-date"/>
        <name value="date"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="date"/>
        <base value="AllergyIntolerance"/>
        <type value="date"/>
        <description value="When recorded"/>
        <xpath value="f:AllergyIntolerance/f:recordedDate"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AllergyIntolerance-identifier"/>
    <resource>
      <SearchParameter>
        <id value="AllergyIntolerance-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/AllergyIntolerance-identifier"/>
        <name value="identifier"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="identifier"/>
        <base value="AllergyIntolerance"/>
        <type value="token"/>
        <description value="External ids for this item"/>
        <xpath value="f:AllergyIntolerance/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AllergyIntolerance-last-date"/>
    <resource>
      <SearchParameter>
        <id value="AllergyIntolerance-last-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/AllergyIntolerance-last-date"/>
        <name value="last-date"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="last-date"/>
        <base value="AllergyIntolerance"/>
        <type value="date"/>
        <description value="Date(/time) of last known occurrence of a reaction"/>
        <xpath value="f:AllergyIntolerance/f:lastOccurence"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AllergyIntolerance-manifestation"/>
    <resource>
      <SearchParameter>
        <id value="AllergyIntolerance-manifestation"/>
        <url value="http://hl7.org/fhir/SearchParameter/AllergyIntolerance-manifestation"/>
        <name value="manifestation"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="manifestation"/>
        <base value="AllergyIntolerance"/>
        <type value="token"/>
        <description value="Clinical symptoms/signs associated with the Event"/>
        <xpath value="f:AllergyIntolerance/f:reaction/f:manifestation"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AllergyIntolerance-onset"/>
    <resource>
      <SearchParameter>
        <id value="AllergyIntolerance-onset"/>
        <url value="http://hl7.org/fhir/SearchParameter/AllergyIntolerance-onset"/>
        <name value="onset"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="onset"/>
        <base value="AllergyIntolerance"/>
        <type value="date"/>
        <description value="Date(/time) when manifestations showed"/>
        <xpath value="f:AllergyIntolerance/f:reaction/f:onset"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AllergyIntolerance-patient"/>
    <resource>
      <SearchParameter>
        <id value="AllergyIntolerance-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/AllergyIntolerance-patient"/>
        <name value="patient"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="patient"/>
        <base value="AllergyIntolerance"/>
        <type value="reference"/>
        <description value="Who the sensitivity is for"/>
        <xpath value="f:AllergyIntolerance/f:patient"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AllergyIntolerance-recorder"/>
    <resource>
      <SearchParameter>
        <id value="AllergyIntolerance-recorder"/>
        <url value="http://hl7.org/fhir/SearchParameter/AllergyIntolerance-recorder"/>
        <name value="recorder"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="recorder"/>
        <base value="AllergyIntolerance"/>
        <type value="reference"/>
        <description value="Who recorded the sensitivity"/>
        <xpath value="f:AllergyIntolerance/f:recorder"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AllergyIntolerance-reporter"/>
    <resource>
      <SearchParameter>
        <id value="AllergyIntolerance-reporter"/>
        <url value="http://hl7.org/fhir/SearchParameter/AllergyIntolerance-reporter"/>
        <name value="reporter"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="reporter"/>
        <base value="AllergyIntolerance"/>
        <type value="reference"/>
        <description value="Source of the information about the allergy"/>
        <xpath value="f:AllergyIntolerance/f:reporter"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
        <target value="Practitioner"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AllergyIntolerance-route"/>
    <resource>
      <SearchParameter>
        <id value="AllergyIntolerance-route"/>
        <url value="http://hl7.org/fhir/SearchParameter/AllergyIntolerance-route"/>
        <name value="route"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="route"/>
        <base value="AllergyIntolerance"/>
        <type value="token"/>
        <description value="How the subject was exposed to the substance"/>
        <xpath value="f:AllergyIntolerance/f:reaction/f:exposureRoute"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AllergyIntolerance-severity"/>
    <resource>
      <SearchParameter>
        <id value="AllergyIntolerance-severity"/>
        <url value="http://hl7.org/fhir/SearchParameter/AllergyIntolerance-severity"/>
        <name value="severity"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="severity"/>
        <base value="AllergyIntolerance"/>
        <type value="token"/>
        <description value="mild | moderate | severe (of event as a whole)"/>
        <xpath value="f:AllergyIntolerance/f:reaction/f:severity"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AllergyIntolerance-status"/>
    <resource>
      <SearchParameter>
        <id value="AllergyIntolerance-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/AllergyIntolerance-status"/>
        <name value="status"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="status"/>
        <base value="AllergyIntolerance"/>
        <type value="token"/>
        <description value="active | unconfirmed | confirmed | inactive | resolved | refuted | entered-in-error"/>
        <xpath value="f:AllergyIntolerance/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AllergyIntolerance-substance"/>
    <resource>
      <SearchParameter>
        <id value="AllergyIntolerance-substance"/>
        <url value="http://hl7.org/fhir/SearchParameter/AllergyIntolerance-substance"/>
        <name value="substance"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="substance"/>
        <base value="AllergyIntolerance"/>
        <type value="token"/>
        <description value="Substance, (or class) considered to be responsible for risk"/>
        <xpath value="f:AllergyIntolerance/f:substance"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AllergyIntolerance-type"/>
    <resource>
      <SearchParameter>
        <id value="AllergyIntolerance-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/AllergyIntolerance-type"/>
        <name value="type"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="type"/>
        <base value="AllergyIntolerance"/>
        <type value="token"/>
        <description value="allergy | intolerance - Underlying mechanism (if known)"/>
        <xpath value="f:AllergyIntolerance/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
