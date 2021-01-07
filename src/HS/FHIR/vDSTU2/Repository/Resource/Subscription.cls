Class HS.FHIR.vDSTU2.Repository.Resource.Subscription Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Subscription"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Subscription-contact"/>
    <resource>
      <SearchParameter>
        <id value="Subscription-contact"/>
        <url value="http://hl7.org/fhir/SearchParameter/Subscription-contact"/>
        <name value="contact"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="contact"/>
        <base value="Subscription"/>
        <type value="token"/>
        <description value="Contact details for source (e.g. troubleshooting)"/>
        <xpath value="f:Subscription/f:contact"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Subscription-criteria"/>
    <resource>
      <SearchParameter>
        <id value="Subscription-criteria"/>
        <url value="http://hl7.org/fhir/SearchParameter/Subscription-criteria"/>
        <name value="criteria"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="criteria"/>
        <base value="Subscription"/>
        <type value="string"/>
        <description value="Rule for server push criteria"/>
        <xpath value="f:Subscription/f:criteria"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Subscription-payload"/>
    <resource>
      <SearchParameter>
        <id value="Subscription-payload"/>
        <url value="http://hl7.org/fhir/SearchParameter/Subscription-payload"/>
        <name value="payload"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="payload"/>
        <base value="Subscription"/>
        <type value="string"/>
        <description value="Mimetype to send, or blank for no payload"/>
        <xpath value="f:Subscription/f:channel/f:payload"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Subscription-status"/>
    <resource>
      <SearchParameter>
        <id value="Subscription-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/Subscription-status"/>
        <name value="status"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="status"/>
        <base value="Subscription"/>
        <type value="token"/>
        <description value="requested | active | error | off"/>
        <xpath value="f:Subscription/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Subscription-tag"/>
    <resource>
      <SearchParameter>
        <id value="Subscription-tag"/>
        <url value="http://hl7.org/fhir/SearchParameter/Subscription-tag"/>
        <name value="tag"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="tag"/>
        <base value="Subscription"/>
        <type value="token"/>
        <description value="A tag to add to matching resources"/>
        <xpath value="f:Subscription/f:tag"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Subscription-type"/>
    <resource>
      <SearchParameter>
        <id value="Subscription-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/Subscription-type"/>
        <name value="type"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="type"/>
        <base value="Subscription"/>
        <type value="token"/>
        <description value="rest-hook | websocket | email | sms | message"/>
        <xpath value="f:Subscription/f:channel/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Subscription-url"/>
    <resource>
      <SearchParameter>
        <id value="Subscription-url"/>
        <url value="http://hl7.org/fhir/SearchParameter/Subscription-url"/>
        <name value="url"/>
        <publisher value="Health Level Seven International (FHIR Infrastructure)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/fiwg/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="url"/>
        <base value="Subscription"/>
        <type value="uri"/>
        <description value="Where the channel points to"/>
        <xpath value="f:Subscription/f:channel/f:endpoint"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
