Class HS.FHIR.vDSTU2.Repository.Resource.DiagnosticOrder Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-DiagnosticOrder"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-actor"/>
    <resource>
      <SearchParameter>
        <id value="DiagnosticOrder-actor"/>
        <url value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-actor"/>
        <name value="actor"/>
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
        <code value="actor"/>
        <base value="DiagnosticOrder"/>
        <type value="reference"/>
        <description value="Who recorded or did this"/>
        <xpath value="f:DiagnosticOrder/f:event/f:actor"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-bodysite"/>
    <resource>
      <SearchParameter>
        <id value="DiagnosticOrder-bodysite"/>
        <url value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-bodysite"/>
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
        <base value="DiagnosticOrder"/>
        <type value="token"/>
        <description value="Location of requested test (if applicable)"/>
        <xpath value="f:DiagnosticOrder/f:item/f:bodySite"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-code"/>
    <resource>
      <SearchParameter>
        <id value="DiagnosticOrder-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-code"/>
        <name value="code"/>
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
        <code value="code"/>
        <base value="DiagnosticOrder"/>
        <type value="token"/>
        <description value="Code to indicate the item (test or panel) being ordered"/>
        <xpath value="f:DiagnosticOrder/f:item/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-encounter"/>
    <resource>
      <SearchParameter>
        <id value="DiagnosticOrder-encounter"/>
        <url value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-encounter"/>
        <name value="encounter"/>
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
        <code value="encounter"/>
        <base value="DiagnosticOrder"/>
        <type value="reference"/>
        <description value="The encounter that this diagnostic order is associated with"/>
        <xpath value="f:DiagnosticOrder/f:encounter"/>
        <xpathUsage value="normal"/>
        <target value="Encounter"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-event-date"/>
    <resource>
      <SearchParameter>
        <id value="DiagnosticOrder-event-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-event-date"/>
        <name value="event-date"/>
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
        <code value="event-date"/>
        <base value="DiagnosticOrder"/>
        <type value="date"/>
        <description value="The date at which the event happened"/>
        <xpath value="f:DiagnosticOrder/f:event/f:dateTime"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-event-status"/>
    <resource>
      <SearchParameter>
        <id value="DiagnosticOrder-event-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-event-status"/>
        <name value="event-status"/>
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
        <code value="event-status"/>
        <base value="DiagnosticOrder"/>
        <type value="token"/>
        <description value="proposed | draft | planned | requested | received | accepted | in-progress | review | completed | cancelled | suspended | rejected | failed"/>
        <xpath value="f:DiagnosticOrder/f:event/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-event-status-date"/>
    <resource>
      <SearchParameter>
        <id value="DiagnosticOrder-event-status-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-event-status-date"/>
        <name value="event-status-date"/>
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
        <code value="event-status-date"/>
        <base value="DiagnosticOrder"/>
        <type value="composite"/>
        <description value="A combination of past-status and date"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-identifier"/>
    <resource>
      <SearchParameter>
        <id value="DiagnosticOrder-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-identifier"/>
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
        <base value="DiagnosticOrder"/>
        <type value="token"/>
        <description value="Identifiers assigned to this order"/>
        <xpath value="f:DiagnosticOrder/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-item-date"/>
    <resource>
      <SearchParameter>
        <id value="DiagnosticOrder-item-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-item-date"/>
        <name value="item-date"/>
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
        <code value="item-date"/>
        <base value="DiagnosticOrder"/>
        <type value="date"/>
        <description value="The date at which the event happened"/>
        <xpath value="f:DiagnosticOrder/f:item/f:event/f:dateTime"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-item-past-status"/>
    <resource>
      <SearchParameter>
        <id value="DiagnosticOrder-item-past-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-item-past-status"/>
        <name value="item-past-status"/>
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
        <code value="item-past-status"/>
        <base value="DiagnosticOrder"/>
        <type value="token"/>
        <description value="proposed | draft | planned | requested | received | accepted | in-progress | review | completed | cancelled | suspended | rejected | failed"/>
        <xpath value="f:DiagnosticOrder/f:item/f:event/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-item-status"/>
    <resource>
      <SearchParameter>
        <id value="DiagnosticOrder-item-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-item-status"/>
        <name value="item-status"/>
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
        <code value="item-status"/>
        <base value="DiagnosticOrder"/>
        <type value="token"/>
        <description value="proposed | draft | planned | requested | received | accepted | in-progress | review | completed | cancelled | suspended | rejected | failed"/>
        <xpath value="f:DiagnosticOrder/f:item/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-item-status-date"/>
    <resource>
      <SearchParameter>
        <id value="DiagnosticOrder-item-status-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-item-status-date"/>
        <name value="item-status-date"/>
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
        <code value="item-status-date"/>
        <base value="DiagnosticOrder"/>
        <type value="composite"/>
        <description value="A combination of item-past-status and item-date"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-orderer"/>
    <resource>
      <SearchParameter>
        <id value="DiagnosticOrder-orderer"/>
        <url value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-orderer"/>
        <name value="orderer"/>
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
        <code value="orderer"/>
        <base value="DiagnosticOrder"/>
        <type value="reference"/>
        <description value="Who ordered the test"/>
        <xpath value="f:DiagnosticOrder/f:orderer"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-patient"/>
    <resource>
      <SearchParameter>
        <id value="DiagnosticOrder-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-patient"/>
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
        <base value="DiagnosticOrder"/>
        <type value="reference"/>
        <description value="Who and/or what test is about"/>
        <xpath value="f:DiagnosticOrder/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="Location"/>
        <target value="Patient"/>
        <target value="Group"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-specimen"/>
    <resource>
      <SearchParameter>
        <id value="DiagnosticOrder-specimen"/>
        <url value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-specimen"/>
        <name value="specimen"/>
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
        <code value="specimen"/>
        <base value="DiagnosticOrder"/>
        <type value="reference"/>
        <description value="If the whole order relates to specific specimens"/>
        <xpath value="f:DiagnosticOrder/f:specimen"/>
        <xpathUsage value="normal"/>
        <target value="Specimen"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-status"/>
    <resource>
      <SearchParameter>
        <id value="DiagnosticOrder-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-status"/>
        <name value="status"/>
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
        <code value="status"/>
        <base value="DiagnosticOrder"/>
        <type value="token"/>
        <description value="proposed | draft | planned | requested | received | accepted | in-progress | review | completed | cancelled | suspended | rejected | failed"/>
        <xpath value="f:DiagnosticOrder/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-subject"/>
    <resource>
      <SearchParameter>
        <id value="DiagnosticOrder-subject"/>
        <url value="http://hl7.org/fhir/SearchParameter/DiagnosticOrder-subject"/>
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
        <base value="DiagnosticOrder"/>
        <type value="reference"/>
        <description value="Who and/or what test is about"/>
        <xpath value="f:DiagnosticOrder/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="Location"/>
        <target value="Patient"/>
        <target value="Group"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
