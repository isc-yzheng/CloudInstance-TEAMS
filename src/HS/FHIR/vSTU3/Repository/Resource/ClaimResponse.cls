Class HS.FHIR.vSTU3.Repository.Resource.ClaimResponse Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-ClaimResponse"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ClaimResponse-created"/>
    <resource>
      <SearchParameter>
        <id value="ClaimResponse-created"/>
        <url value="http://hl7.org/fhir/SearchParameter/ClaimResponse-created"/>
        <name value="created"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="created"/>
        <base value="ClaimResponse"/>
        <type value="date"/>
        <description value="The creation date"/>
        <expression value="ClaimResponse.created"/>
        <xpath value="f:ClaimResponse/f:created"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ClaimResponse-disposition"/>
    <resource>
      <SearchParameter>
        <id value="ClaimResponse-disposition"/>
        <url value="http://hl7.org/fhir/SearchParameter/ClaimResponse-disposition"/>
        <name value="disposition"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="disposition"/>
        <base value="ClaimResponse"/>
        <type value="string"/>
        <description value="The contents of the disposition message"/>
        <expression value="ClaimResponse.disposition"/>
        <xpath value="f:ClaimResponse/f:disposition"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ClaimResponse-identifier"/>
    <resource>
      <SearchParameter>
        <id value="ClaimResponse-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/ClaimResponse-identifier"/>
        <name value="identifier"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="identifier"/>
        <base value="ClaimResponse"/>
        <type value="token"/>
        <description value="The identity of the claimresponse"/>
        <expression value="ClaimResponse.identifier"/>
        <xpath value="f:ClaimResponse/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ClaimResponse-insurer"/>
    <resource>
      <SearchParameter>
        <id value="ClaimResponse-insurer"/>
        <url value="http://hl7.org/fhir/SearchParameter/ClaimResponse-insurer"/>
        <name value="insurer"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="insurer"/>
        <base value="ClaimResponse"/>
        <type value="reference"/>
        <description value="The organization who generated this resource"/>
        <expression value="ClaimResponse.insurer"/>
        <xpath value="f:ClaimResponse/f:insurer"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ClaimResponse-outcome"/>
    <resource>
      <SearchParameter>
        <id value="ClaimResponse-outcome"/>
        <url value="http://hl7.org/fhir/SearchParameter/ClaimResponse-outcome"/>
        <name value="outcome"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="outcome"/>
        <base value="ClaimResponse"/>
        <type value="token"/>
        <description value="The processing outcome"/>
        <expression value="ClaimResponse.outcome"/>
        <xpath value="f:ClaimResponse/f:outcome"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ClaimResponse-patient"/>
    <resource>
      <SearchParameter>
        <id value="ClaimResponse-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/ClaimResponse-patient"/>
        <name value="patient"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="patient"/>
        <base value="ClaimResponse"/>
        <type value="reference"/>
        <description value="The subject of care."/>
        <expression value="ClaimResponse.patient"/>
        <xpath value="f:ClaimResponse/f:patient"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ClaimResponse-payment-date"/>
    <resource>
      <SearchParameter>
        <id value="ClaimResponse-payment-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/ClaimResponse-payment-date"/>
        <name value="payment-date"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="payment-date"/>
        <base value="ClaimResponse"/>
        <type value="date"/>
        <description value="The expected paymentDate"/>
        <expression value="ClaimResponse.payment.date"/>
        <xpath value="f:ClaimResponse/f:payment/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ClaimResponse-request"/>
    <resource>
      <SearchParameter>
        <id value="ClaimResponse-request"/>
        <url value="http://hl7.org/fhir/SearchParameter/ClaimResponse-request"/>
        <name value="request"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="request"/>
        <base value="ClaimResponse"/>
        <type value="reference"/>
        <description value="The claim reference"/>
        <expression value="ClaimResponse.request"/>
        <xpath value="f:ClaimResponse/f:request"/>
        <xpathUsage value="normal"/>
        <target value="Claim"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/ClaimResponse-request-provider"/>
    <resource>
      <SearchParameter>
        <id value="ClaimResponse-request-provider"/>
        <url value="http://hl7.org/fhir/SearchParameter/ClaimResponse-request-provider"/>
        <name value="request-provider"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Financial Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/fm/index.cfm"/>
          </telecom>
        </contact>
        <code value="request-provider"/>
        <base value="ClaimResponse"/>
        <type value="reference"/>
        <description value="The Provider of the claim"/>
        <expression value="ClaimResponse.requestProvider"/>
        <xpath value="f:ClaimResponse/f:requestProvider"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
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
