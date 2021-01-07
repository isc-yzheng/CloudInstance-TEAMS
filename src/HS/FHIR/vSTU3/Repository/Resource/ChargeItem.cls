Class HS.FHIR.vSTU3.Repository.Resource.ChargeItem Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-ChargeItem"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ChargeItem-account"/>
    <resource>
      <SearchParameter>
        <id value="ChargeItem-account"/>
        <url value="http://hl7.org/fhir/SearchParameter/ChargeItem-account"/>
        <name value="account"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="account"/>
        <base value="ChargeItem"/>
        <type value="reference"/>
        <description value="Account to place this charge"/>
        <expression value="ChargeItem.account"/>
        <xpath value="f:ChargeItem/f:account"/>
        <xpathUsage value="normal"/>
        <target value="Account"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ChargeItem-code"/>
    <resource>
      <SearchParameter>
        <id value="ChargeItem-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/ChargeItem-code"/>
        <name value="code"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="code"/>
        <base value="ChargeItem"/>
        <type value="token"/>
        <description value="A code that identifies the charge, like a billing code"/>
        <expression value="ChargeItem.code"/>
        <xpath value="f:ChargeItem/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ChargeItem-context"/>
    <resource>
      <SearchParameter>
        <id value="ChargeItem-context"/>
        <url value="http://hl7.org/fhir/SearchParameter/ChargeItem-context"/>
        <name value="context"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="context"/>
        <base value="ChargeItem"/>
        <type value="reference"/>
        <description value="Encounter / Episode associated with event"/>
        <expression value="ChargeItem.context"/>
        <xpath value="f:ChargeItem/f:context"/>
        <xpathUsage value="normal"/>
        <target value="EpisodeOfCare"/>
        <target value="Encounter"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ChargeItem-entered-date"/>
    <resource>
      <SearchParameter>
        <id value="ChargeItem-entered-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/ChargeItem-entered-date"/>
        <name value="entered-date"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="entered-date"/>
        <base value="ChargeItem"/>
        <type value="date"/>
        <description value="Date the charge item was entered"/>
        <expression value="ChargeItem.enteredDate"/>
        <xpath value="f:ChargeItem/f:enteredDate"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ChargeItem-enterer"/>
    <resource>
      <SearchParameter>
        <id value="ChargeItem-enterer"/>
        <url value="http://hl7.org/fhir/SearchParameter/ChargeItem-enterer"/>
        <name value="enterer"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="enterer"/>
        <base value="ChargeItem"/>
        <type value="reference"/>
        <description value="Individual who was entering"/>
        <expression value="ChargeItem.enterer"/>
        <xpath value="f:ChargeItem/f:enterer"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="Organization"/>
        <target value="Device"/>
        <target value="Patient"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ChargeItem-factor-override"/>
    <resource>
      <SearchParameter>
        <id value="ChargeItem-factor-override"/>
        <url value="http://hl7.org/fhir/SearchParameter/ChargeItem-factor-override"/>
        <name value="factor-override"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="factor-override"/>
        <base value="ChargeItem"/>
        <type value="number"/>
        <description value="Factor overriding the associated rules"/>
        <expression value="ChargeItem.factorOverride"/>
        <xpath value="f:ChargeItem/f:factorOverride"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ChargeItem-identifier"/>
    <resource>
      <SearchParameter>
        <id value="ChargeItem-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/ChargeItem-identifier"/>
        <name value="identifier"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="identifier"/>
        <base value="ChargeItem"/>
        <type value="token"/>
        <description value="Business Identifier for item"/>
        <expression value="ChargeItem.identifier"/>
        <xpath value="f:ChargeItem/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ChargeItem-occurrence"/>
    <resource>
      <SearchParameter>
        <id value="ChargeItem-occurrence"/>
        <url value="http://hl7.org/fhir/SearchParameter/ChargeItem-occurrence"/>
        <name value="occurrence"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="occurrence"/>
        <base value="ChargeItem"/>
        <type value="date"/>
        <description value="When the charged service was applied"/>
        <expression value="ChargeItem.occurrence"/>
        <xpath value="f:ChargeItem/f:occurrenceDateTime | f:ChargeItem/f:occurrencePeriod | f:ChargeItem/f:occurrenceTiming"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ChargeItem-participant-actor"/>
    <resource>
      <SearchParameter>
        <id value="ChargeItem-participant-actor"/>
        <url value="http://hl7.org/fhir/SearchParameter/ChargeItem-participant-actor"/>
        <name value="participant-actor"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="participant-actor"/>
        <base value="ChargeItem"/>
        <type value="reference"/>
        <description value="Individual who was performing"/>
        <expression value="ChargeItem.participant.actor"/>
        <xpath value="f:ChargeItem/f:participant/f:actor"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="Organization"/>
        <target value="Device"/>
        <target value="Patient"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ChargeItem-participant-role"/>
    <resource>
      <SearchParameter>
        <id value="ChargeItem-participant-role"/>
        <url value="http://hl7.org/fhir/SearchParameter/ChargeItem-participant-role"/>
        <name value="participant-role"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="participant-role"/>
        <base value="ChargeItem"/>
        <type value="token"/>
        <description value="What type of performance was done"/>
        <expression value="ChargeItem.participant.role"/>
        <xpath value="f:ChargeItem/f:participant/f:role"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ChargeItem-patient"/>
    <resource>
      <SearchParameter>
        <id value="ChargeItem-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/ChargeItem-patient"/>
        <name value="patient"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="patient"/>
        <base value="ChargeItem"/>
        <type value="reference"/>
        <description value="Individual service was done for/to"/>
        <expression value="ChargeItem.subject"/>
        <xpath value="f:ChargeItem/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ChargeItem-performing-organization"/>
    <resource>
      <SearchParameter>
        <id value="ChargeItem-performing-organization"/>
        <url value="http://hl7.org/fhir/SearchParameter/ChargeItem-performing-organization"/>
        <name value="performing-organization"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="performing-organization"/>
        <base value="ChargeItem"/>
        <type value="reference"/>
        <description value="Organization providing the charged sevice"/>
        <expression value="ChargeItem.performingOrganization"/>
        <xpath value="f:ChargeItem/f:performingOrganization"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ChargeItem-price-override"/>
    <resource>
      <SearchParameter>
        <id value="ChargeItem-price-override"/>
        <url value="http://hl7.org/fhir/SearchParameter/ChargeItem-price-override"/>
        <name value="price-override"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="price-override"/>
        <base value="ChargeItem"/>
        <type value="quantity"/>
        <description value="Price overriding the associated rules"/>
        <expression value="ChargeItem.priceOverride"/>
        <xpath value="f:ChargeItem/f:priceOverride"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ChargeItem-quantity"/>
    <resource>
      <SearchParameter>
        <id value="ChargeItem-quantity"/>
        <url value="http://hl7.org/fhir/SearchParameter/ChargeItem-quantity"/>
        <name value="quantity"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="quantity"/>
        <base value="ChargeItem"/>
        <type value="quantity"/>
        <description value="Quantity of which the charge item has been serviced"/>
        <expression value="ChargeItem.quantity"/>
        <xpath value="f:ChargeItem/f:quantity"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ChargeItem-requesting-organization"/>
    <resource>
      <SearchParameter>
        <id value="ChargeItem-requesting-organization"/>
        <url value="http://hl7.org/fhir/SearchParameter/ChargeItem-requesting-organization"/>
        <name value="requesting-organization"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="requesting-organization"/>
        <base value="ChargeItem"/>
        <type value="reference"/>
        <description value="Organization requesting the charged service"/>
        <expression value="ChargeItem.requestingOrganization"/>
        <xpath value="f:ChargeItem/f:requestingOrganization"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ChargeItem-service"/>
    <resource>
      <SearchParameter>
        <id value="ChargeItem-service"/>
        <url value="http://hl7.org/fhir/SearchParameter/ChargeItem-service"/>
        <name value="service"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="service"/>
        <base value="ChargeItem"/>
        <type value="reference"/>
        <description value="Which rendered service is being charged?"/>
        <expression value="ChargeItem.service"/>
        <xpath value="f:ChargeItem/f:service"/>
        <xpathUsage value="normal"/>
        <target value="Immunization"/>
        <target value="MedicationDispense"/>
        <target value="SupplyDelivery"/>
        <target value="Observation"/>
        <target value="DiagnosticReport"/>
        <target value="ImagingStudy"/>
        <target value="MedicationAdministration"/>
        <target value="Procedure"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ChargeItem-subject"/>
    <resource>
      <SearchParameter>
        <id value="ChargeItem-subject"/>
        <url value="http://hl7.org/fhir/SearchParameter/ChargeItem-subject"/>
        <name value="subject"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <code value="subject"/>
        <base value="ChargeItem"/>
        <type value="reference"/>
        <description value="Individual service was done for/to"/>
        <expression value="ChargeItem.subject"/>
        <xpath value="f:ChargeItem/f:subject"/>
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
