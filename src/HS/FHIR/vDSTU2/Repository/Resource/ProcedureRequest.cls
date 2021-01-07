Class HS.FHIR.vDSTU2.Repository.Resource.ProcedureRequest Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-ProcedureRequest"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-encounter"/>
    <resource>
      <SearchParameter>
        <id value="ProcedureRequest-encounter"/>
        <url value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-encounter"/>
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
        <base value="ProcedureRequest"/>
        <type value="reference"/>
        <description value="Encounter request created during"/>
        <xpath value="f:ProcedureRequest/f:encounter"/>
        <xpathUsage value="normal"/>
        <target value="Encounter"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-identifier"/>
    <resource>
      <SearchParameter>
        <id value="ProcedureRequest-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-identifier"/>
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
        <base value="ProcedureRequest"/>
        <type value="token"/>
        <description value="A unique identifier of the Procedure Request"/>
        <xpath value="f:ProcedureRequest/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-orderer"/>
    <resource>
      <SearchParameter>
        <id value="ProcedureRequest-orderer"/>
        <url value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-orderer"/>
        <name value="orderer"/>
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
        <code value="orderer"/>
        <base value="ProcedureRequest"/>
        <type value="reference"/>
        <description value="Who made request"/>
        <xpath value="f:ProcedureRequest/f:orderer"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="Patient"/>
        <target value="Practitioner"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-patient"/>
    <resource>
      <SearchParameter>
        <id value="ProcedureRequest-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-patient"/>
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
        <base value="ProcedureRequest"/>
        <type value="reference"/>
        <description value="Search by subject - a patient"/>
        <xpath value="f:ProcedureRequest/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
        <target value="Group"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-performer"/>
    <resource>
      <SearchParameter>
        <id value="ProcedureRequest-performer"/>
        <url value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-performer"/>
        <name value="performer"/>
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
        <code value="performer"/>
        <base value="ProcedureRequest"/>
        <type value="reference"/>
        <description value="Who should perform the procedure"/>
        <xpath value="f:ProcedureRequest/f:performer"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
        <target value="Organization"/>
        <target value="Practitioner"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-subject"/>
    <resource>
      <SearchParameter>
        <id value="ProcedureRequest-subject"/>
        <url value="http://hl7.org/fhir/SearchParameter/ProcedureRequest-subject"/>
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
        <base value="ProcedureRequest"/>
        <type value="reference"/>
        <description value="Search by subject"/>
        <xpath value="f:ProcedureRequest/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
        <target value="Group"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
