Class HS.FHIR.vDSTU2.Repository.Resource.Communication Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Communication"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Communication-category"/>
    <resource>
      <SearchParameter>
        <id value="Communication-category"/>
        <url value="http://hl7.org/fhir/SearchParameter/Communication-category"/>
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
        <base value="Communication"/>
        <type value="token"/>
        <description value="Message category"/>
        <xpath value="f:Communication/f:category"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Communication-encounter"/>
    <resource>
      <SearchParameter>
        <id value="Communication-encounter"/>
        <url value="http://hl7.org/fhir/SearchParameter/Communication-encounter"/>
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
        <base value="Communication"/>
        <type value="reference"/>
        <description value="Encounter leading to message"/>
        <xpath value="f:Communication/f:encounter"/>
        <xpathUsage value="normal"/>
        <target value="Encounter"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Communication-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Communication-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Communication-identifier"/>
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
        <base value="Communication"/>
        <type value="token"/>
        <description value="Unique identifier"/>
        <xpath value="f:Communication/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Communication-medium"/>
    <resource>
      <SearchParameter>
        <id value="Communication-medium"/>
        <url value="http://hl7.org/fhir/SearchParameter/Communication-medium"/>
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
        <base value="Communication"/>
        <type value="token"/>
        <description value="A channel of communication"/>
        <xpath value="f:Communication/f:medium"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Communication-patient"/>
    <resource>
      <SearchParameter>
        <id value="Communication-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/Communication-patient"/>
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
        <base value="Communication"/>
        <type value="reference"/>
        <description value="Focus of message"/>
        <xpath value="f:Communication/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Communication-received"/>
    <resource>
      <SearchParameter>
        <id value="Communication-received"/>
        <url value="http://hl7.org/fhir/SearchParameter/Communication-received"/>
        <name value="received"/>
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
        <code value="received"/>
        <base value="Communication"/>
        <type value="date"/>
        <description value="When received"/>
        <xpath value="f:Communication/f:received"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Communication-recipient"/>
    <resource>
      <SearchParameter>
        <id value="Communication-recipient"/>
        <url value="http://hl7.org/fhir/SearchParameter/Communication-recipient"/>
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
        <base value="Communication"/>
        <type value="reference"/>
        <description value="Message recipient"/>
        <xpath value="f:Communication/f:recipient"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="Patient"/>
        <target value="Organization"/>
        <target value="Practitioner"/>
        <target value="Group"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Communication-request"/>
    <resource>
      <SearchParameter>
        <id value="Communication-request"/>
        <url value="http://hl7.org/fhir/SearchParameter/Communication-request"/>
        <name value="request"/>
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
        <code value="request"/>
        <base value="Communication"/>
        <type value="reference"/>
        <description value="CommunicationRequest producing this message"/>
        <xpath value="f:Communication/f:requestDetail"/>
        <xpathUsage value="normal"/>
        <target value="CommunicationRequest"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Communication-sender"/>
    <resource>
      <SearchParameter>
        <id value="Communication-sender"/>
        <url value="http://hl7.org/fhir/SearchParameter/Communication-sender"/>
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
        <base value="Communication"/>
        <type value="reference"/>
        <description value="Message sender"/>
        <xpath value="f:Communication/f:sender"/>
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
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Communication-sent"/>
    <resource>
      <SearchParameter>
        <id value="Communication-sent"/>
        <url value="http://hl7.org/fhir/SearchParameter/Communication-sent"/>
        <name value="sent"/>
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
        <code value="sent"/>
        <base value="Communication"/>
        <type value="date"/>
        <description value="When sent"/>
        <xpath value="f:Communication/f:sent"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Communication-status"/>
    <resource>
      <SearchParameter>
        <id value="Communication-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/Communication-status"/>
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
        <base value="Communication"/>
        <type value="token"/>
        <description value="in-progress | completed | suspended | rejected | failed"/>
        <xpath value="f:Communication/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Communication-subject"/>
    <resource>
      <SearchParameter>
        <id value="Communication-subject"/>
        <url value="http://hl7.org/fhir/SearchParameter/Communication-subject"/>
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
        <base value="Communication"/>
        <type value="reference"/>
        <description value="Focus of message"/>
        <xpath value="f:Communication/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
