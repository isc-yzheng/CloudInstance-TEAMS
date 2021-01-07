Class HS.FHIR.vSTU3.Repository.Resource.PaymentReconciliation Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-PaymentReconciliation"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/PaymentReconciliation-created"/>
    <resource>
      <SearchParameter>
        <id value="PaymentReconciliation-created"/>
        <url value="http://hl7.org/fhir/SearchParameter/PaymentReconciliation-created"/>
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
        <base value="PaymentReconciliation"/>
        <type value="date"/>
        <description value="The creation date"/>
        <expression value="PaymentReconciliation.created"/>
        <xpath value="f:PaymentReconciliation/f:created"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/PaymentReconciliation-disposition"/>
    <resource>
      <SearchParameter>
        <id value="PaymentReconciliation-disposition"/>
        <url value="http://hl7.org/fhir/SearchParameter/PaymentReconciliation-disposition"/>
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
        <base value="PaymentReconciliation"/>
        <type value="string"/>
        <description value="The contents of the disposition message"/>
        <expression value="PaymentReconciliation.disposition"/>
        <xpath value="f:PaymentReconciliation/f:disposition"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/PaymentReconciliation-identifier"/>
    <resource>
      <SearchParameter>
        <id value="PaymentReconciliation-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/PaymentReconciliation-identifier"/>
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
        <base value="PaymentReconciliation"/>
        <type value="token"/>
        <description value="The business identifier of the Explanation of Benefit"/>
        <expression value="PaymentReconciliation.identifier"/>
        <xpath value="f:PaymentReconciliation/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/PaymentReconciliation-organization"/>
    <resource>
      <SearchParameter>
        <id value="PaymentReconciliation-organization"/>
        <url value="http://hl7.org/fhir/SearchParameter/PaymentReconciliation-organization"/>
        <name value="organization"/>
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
        <code value="organization"/>
        <base value="PaymentReconciliation"/>
        <type value="reference"/>
        <description value="The organization who generated this resource"/>
        <expression value="PaymentReconciliation.organization"/>
        <xpath value="f:PaymentReconciliation/f:organization"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/PaymentReconciliation-outcome"/>
    <resource>
      <SearchParameter>
        <id value="PaymentReconciliation-outcome"/>
        <url value="http://hl7.org/fhir/SearchParameter/PaymentReconciliation-outcome"/>
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
        <base value="PaymentReconciliation"/>
        <type value="token"/>
        <description value="The processing outcome"/>
        <expression value="PaymentReconciliation.outcome"/>
        <xpath value="f:PaymentReconciliation/f:outcome"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/PaymentReconciliation-request"/>
    <resource>
      <SearchParameter>
        <id value="PaymentReconciliation-request"/>
        <url value="http://hl7.org/fhir/SearchParameter/PaymentReconciliation-request"/>
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
        <base value="PaymentReconciliation"/>
        <type value="reference"/>
        <description value="The reference to the claim"/>
        <expression value="PaymentReconciliation.request"/>
        <xpath value="f:PaymentReconciliation/f:request"/>
        <xpathUsage value="normal"/>
        <target value="ProcessRequest"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/PaymentReconciliation-request-organization"/>
    <resource>
      <SearchParameter>
        <id value="PaymentReconciliation-request-organization"/>
        <url value="http://hl7.org/fhir/SearchParameter/PaymentReconciliation-request-organization"/>
        <name value="request-organization"/>
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
        <code value="request-organization"/>
        <base value="PaymentReconciliation"/>
        <type value="reference"/>
        <description value="The organization who generated this resource"/>
        <expression value="PaymentReconciliation.requestOrganization"/>
        <xpath value="f:PaymentReconciliation/f:requestOrganization"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/PaymentReconciliation-request-provider"/>
    <resource>
      <SearchParameter>
        <id value="PaymentReconciliation-request-provider"/>
        <url value="http://hl7.org/fhir/SearchParameter/PaymentReconciliation-request-provider"/>
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
        <base value="PaymentReconciliation"/>
        <type value="reference"/>
        <description value="The reference to the provider who sumbitted the claim"/>
        <expression value="PaymentReconciliation.requestProvider"/>
        <xpath value="f:PaymentReconciliation/f:requestProvider"/>
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
