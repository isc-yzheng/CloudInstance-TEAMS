Class HS.FHIR.vSTU3.Repository.Resource.Subscription Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Subscription"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Subscription-add-tag"/>
    <resource>
      <SearchParameter>
        <id value="Subscription-add-tag"/>
        <url value="http://hl7.org/fhir/SearchParameter/Subscription-add-tag"/>
        <name value="add-tag"/>
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
        <code value="add-tag"/>
        <base value="Subscription"/>
        <type value="token"/>
        <description value="A tag to be added to the resource matching the criteria"/>
        <expression value="Subscription.tag"/>
        <xpath value="f:Subscription/f:tag"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Subscription-contact"/>
    <resource>
      <SearchParameter>
        <id value="Subscription-contact"/>
        <url value="http://hl7.org/fhir/SearchParameter/Subscription-contact"/>
        <name value="contact"/>
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
        <code value="contact"/>
        <base value="Subscription"/>
        <type value="token"/>
        <description value="Contact details for the subscription"/>
        <expression value="Subscription.contact"/>
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
        <code value="criteria"/>
        <base value="Subscription"/>
        <type value="string"/>
        <description value="The search rules used to determine when to send a notification"/>
        <expression value="Subscription.criteria"/>
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
        <code value="payload"/>
        <base value="Subscription"/>
        <type value="string"/>
        <description value="The mime-type of the notification payload"/>
        <expression value="Subscription.channel.payload"/>
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
        <code value="status"/>
        <base value="Subscription"/>
        <type value="token"/>
        <description value="The current state of the subscription"/>
        <expression value="Subscription.status"/>
        <xpath value="f:Subscription/f:status"/>
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
        <base value="Subscription"/>
        <type value="token"/>
        <description value="The type of channel for the sent notifications"/>
        <expression value="Subscription.channel.type"/>
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
        <code value="url"/>
        <base value="Subscription"/>
        <type value="uri"/>
        <description value="The uri that will receive the notifications"/>
        <expression value="Subscription.channel.endpoint"/>
        <xpath value="f:Subscription/f:channel/f:endpoint"/>
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
