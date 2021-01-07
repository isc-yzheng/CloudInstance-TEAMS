Class HS.FHIR.vDSTU2.Repository.Resource.CommunicationRequest Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-CommunicationRequest"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-category"/>
    <resource>
      <SearchParameter>
        <id value="CommunicationRequest-category"/>
        <url value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-category"/>
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
        <base value="CommunicationRequest"/>
        <type value="token"/>
        <description value="Message category"/>
        <xpath value="f:CommunicationRequest/f:category"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-encounter"/>
    <resource>
      <SearchParameter>
        <id value="CommunicationRequest-encounter"/>
        <url value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-encounter"/>
        <name value="encounter"/>
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
        <code value="encounter"/>
        <base value="CommunicationRequest"/>
        <type value="reference"/>
        <description value="Encounter leading to message"/>
        <xpath value="f:CommunicationRequest/f:encounter"/>
        <xpathUsage value="normal"/>
        <target value="Encounter"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-identifier"/>
    <resource>
      <SearchParameter>
        <id value="CommunicationRequest-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-identifier"/>
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
        <base value="CommunicationRequest"/>
        <type value="token"/>
        <description value="Unique identifier"/>
        <xpath value="f:CommunicationRequest/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-medium"/>
    <resource>
      <SearchParameter>
        <id value="CommunicationRequest-medium"/>
        <url value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-medium"/>
        <name value="medium"/>
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
        <code value="medium"/>
        <base value="CommunicationRequest"/>
        <type value="token"/>
        <description value="A channel of communication"/>
        <xpath value="f:CommunicationRequest/f:medium"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-patient"/>
    <resource>
      <SearchParameter>
        <id value="CommunicationRequest-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-patient"/>
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
        <base value="CommunicationRequest"/>
        <type value="reference"/>
        <description value="Focus of message"/>
        <xpath value="f:CommunicationRequest/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-priority"/>
    <resource>
      <SearchParameter>
        <id value="CommunicationRequest-priority"/>
        <url value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-priority"/>
        <name value="priority"/>
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
        <code value="priority"/>
        <base value="CommunicationRequest"/>
        <type value="token"/>
        <description value="Message urgency"/>
        <xpath value="f:CommunicationRequest/f:priority"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-recipient"/>
    <resource>
      <SearchParameter>
        <id value="CommunicationRequest-recipient"/>
        <url value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-recipient"/>
        <name value="recipient"/>
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
        <code value="recipient"/>
        <base value="CommunicationRequest"/>
        <type value="reference"/>
        <description value="Message recipient"/>
        <xpath value="f:CommunicationRequest/f:recipient"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-requested"/>
    <resource>
      <SearchParameter>
        <id value="CommunicationRequest-requested"/>
        <url value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-requested"/>
        <name value="requested"/>
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
        <code value="requested"/>
        <base value="CommunicationRequest"/>
        <type value="date"/>
        <description value="When ordered or proposed"/>
        <xpath value="f:CommunicationRequest/f:requestedOn"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-requester"/>
    <resource>
      <SearchParameter>
        <id value="CommunicationRequest-requester"/>
        <url value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-requester"/>
        <name value="requester"/>
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
        <code value="requester"/>
        <base value="CommunicationRequest"/>
        <type value="reference"/>
        <description value="An individual who requested a communication"/>
        <xpath value="f:CommunicationRequest/f:requester"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
        <target value="Practitioner"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-sender"/>
    <resource>
      <SearchParameter>
        <id value="CommunicationRequest-sender"/>
        <url value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-sender"/>
        <name value="sender"/>
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
        <code value="sender"/>
        <base value="CommunicationRequest"/>
        <type value="reference"/>
        <description value="Message sender"/>
        <xpath value="f:CommunicationRequest/f:sender"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-status"/>
    <resource>
      <SearchParameter>
        <id value="CommunicationRequest-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-status"/>
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
        <base value="CommunicationRequest"/>
        <type value="token"/>
        <description value="proposed | planned | requested | received | accepted | in-progress | completed | suspended | rejected | failed"/>
        <xpath value="f:CommunicationRequest/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-subject"/>
    <resource>
      <SearchParameter>
        <id value="CommunicationRequest-subject"/>
        <url value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-subject"/>
        <name value="subject"/>
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
        <code value="subject"/>
        <base value="CommunicationRequest"/>
        <type value="reference"/>
        <description value="Focus of message"/>
        <xpath value="f:CommunicationRequest/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-time"/>
    <resource>
      <SearchParameter>
        <id value="CommunicationRequest-time"/>
        <url value="http://hl7.org/fhir/SearchParameter/CommunicationRequest-time"/>
        <name value="time"/>
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
        <code value="time"/>
        <base value="CommunicationRequest"/>
        <type value="date"/>
        <description value="When scheduled"/>
        <xpath value="f:CommunicationRequest/f:scheduledDateTime"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
