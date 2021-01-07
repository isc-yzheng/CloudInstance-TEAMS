Class HS.FHIR.vSTU3.Repository.Resource.MessageDefinition Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-MessageDefinition"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MessageDefinition-category"/>
    <resource>
      <SearchParameter>
        <id value="MessageDefinition-category"/>
        <url value="http://hl7.org/fhir/SearchParameter/MessageDefinition-category"/>
        <name value="category"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Infrastructure And Messaging)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/special/committees/inm/index.cfm"/>
          </telecom>
        </contact>
        <code value="category"/>
        <base value="MessageDefinition"/>
        <type value="token"/>
        <description value="The behavior associated with the message"/>
        <expression value="MessageDefinition.category"/>
        <xpath value="f:MessageDefinition/f:category"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MessageDefinition-date"/>
    <resource>
      <SearchParameter>
        <id value="MessageDefinition-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/MessageDefinition-date"/>
        <name value="date"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Infrastructure And Messaging)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/special/committees/inm/index.cfm"/>
          </telecom>
        </contact>
        <code value="date"/>
        <base value="MessageDefinition"/>
        <type value="date"/>
        <description value="The message definition publication date"/>
        <expression value="MessageDefinition.date"/>
        <xpath value="f:MessageDefinition/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MessageDefinition-description"/>
    <resource>
      <SearchParameter>
        <id value="MessageDefinition-description"/>
        <url value="http://hl7.org/fhir/SearchParameter/MessageDefinition-description"/>
        <name value="description"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Infrastructure And Messaging)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/special/committees/inm/index.cfm"/>
          </telecom>
        </contact>
        <code value="description"/>
        <base value="MessageDefinition"/>
        <type value="string"/>
        <description value="The description of the message definition"/>
        <expression value="MessageDefinition.description"/>
        <xpath value="f:MessageDefinition/f:description"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MessageDefinition-event"/>
    <resource>
      <SearchParameter>
        <id value="MessageDefinition-event"/>
        <url value="http://hl7.org/fhir/SearchParameter/MessageDefinition-event"/>
        <name value="event"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Infrastructure And Messaging)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/special/committees/inm/index.cfm"/>
          </telecom>
        </contact>
        <code value="event"/>
        <base value="MessageDefinition"/>
        <type value="token"/>
        <description value="The event that triggers the message"/>
        <expression value="MessageDefinition.event"/>
        <xpath value="f:MessageDefinition/f:event"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MessageDefinition-focus"/>
    <resource>
      <SearchParameter>
        <id value="MessageDefinition-focus"/>
        <url value="http://hl7.org/fhir/SearchParameter/MessageDefinition-focus"/>
        <name value="focus"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Infrastructure And Messaging)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/special/committees/inm/index.cfm"/>
          </telecom>
        </contact>
        <code value="focus"/>
        <base value="MessageDefinition"/>
        <type value="token"/>
        <description value="A resource that is a permitted focus of the message"/>
        <expression value="MessageDefinition.focus.code"/>
        <xpath value="f:MessageDefinition/f:focus/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MessageDefinition-identifier"/>
    <resource>
      <SearchParameter>
        <id value="MessageDefinition-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/MessageDefinition-identifier"/>
        <name value="identifier"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Infrastructure And Messaging)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/special/committees/inm/index.cfm"/>
          </telecom>
        </contact>
        <code value="identifier"/>
        <base value="MessageDefinition"/>
        <type value="token"/>
        <description value="External identifier for the message definition"/>
        <expression value="MessageDefinition.identifier"/>
        <xpath value="f:MessageDefinition/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MessageDefinition-jurisdiction"/>
    <resource>
      <SearchParameter>
        <id value="MessageDefinition-jurisdiction"/>
        <url value="http://hl7.org/fhir/SearchParameter/MessageDefinition-jurisdiction"/>
        <name value="jurisdiction"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Infrastructure And Messaging)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/special/committees/inm/index.cfm"/>
          </telecom>
        </contact>
        <code value="jurisdiction"/>
        <base value="MessageDefinition"/>
        <type value="token"/>
        <description value="Intended jurisdiction for the message definition"/>
        <expression value="MessageDefinition.jurisdiction"/>
        <xpath value="f:MessageDefinition/f:jurisdiction"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MessageDefinition-name"/>
    <resource>
      <SearchParameter>
        <id value="MessageDefinition-name"/>
        <url value="http://hl7.org/fhir/SearchParameter/MessageDefinition-name"/>
        <name value="name"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Infrastructure And Messaging)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/special/committees/inm/index.cfm"/>
          </telecom>
        </contact>
        <code value="name"/>
        <base value="MessageDefinition"/>
        <type value="string"/>
        <description value="Computationally friendly name of the message definition"/>
        <expression value="MessageDefinition.name"/>
        <xpath value="f:MessageDefinition/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MessageDefinition-publisher"/>
    <resource>
      <SearchParameter>
        <id value="MessageDefinition-publisher"/>
        <url value="http://hl7.org/fhir/SearchParameter/MessageDefinition-publisher"/>
        <name value="publisher"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Infrastructure And Messaging)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/special/committees/inm/index.cfm"/>
          </telecom>
        </contact>
        <code value="publisher"/>
        <base value="MessageDefinition"/>
        <type value="string"/>
        <description value="Name of the publisher of the message definition"/>
        <expression value="MessageDefinition.publisher"/>
        <xpath value="f:MessageDefinition/f:publisher"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MessageDefinition-status"/>
    <resource>
      <SearchParameter>
        <id value="MessageDefinition-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/MessageDefinition-status"/>
        <name value="status"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Infrastructure And Messaging)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/special/committees/inm/index.cfm"/>
          </telecom>
        </contact>
        <code value="status"/>
        <base value="MessageDefinition"/>
        <type value="token"/>
        <description value="The current status of the message definition"/>
        <expression value="MessageDefinition.status"/>
        <xpath value="f:MessageDefinition/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MessageDefinition-title"/>
    <resource>
      <SearchParameter>
        <id value="MessageDefinition-title"/>
        <url value="http://hl7.org/fhir/SearchParameter/MessageDefinition-title"/>
        <name value="title"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Infrastructure And Messaging)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/special/committees/inm/index.cfm"/>
          </telecom>
        </contact>
        <code value="title"/>
        <base value="MessageDefinition"/>
        <type value="string"/>
        <description value="The human-friendly name of the message definition"/>
        <expression value="MessageDefinition.title"/>
        <xpath value="f:MessageDefinition/f:title"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MessageDefinition-url"/>
    <resource>
      <SearchParameter>
        <id value="MessageDefinition-url"/>
        <url value="http://hl7.org/fhir/SearchParameter/MessageDefinition-url"/>
        <name value="url"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Infrastructure And Messaging)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/special/committees/inm/index.cfm"/>
          </telecom>
        </contact>
        <code value="url"/>
        <base value="MessageDefinition"/>
        <type value="uri"/>
        <description value="The uri that identifies the message definition"/>
        <expression value="MessageDefinition.url"/>
        <xpath value="f:MessageDefinition/f:url"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/MessageDefinition-version"/>
    <resource>
      <SearchParameter>
        <id value="MessageDefinition-version"/>
        <url value="http://hl7.org/fhir/SearchParameter/MessageDefinition-version"/>
        <name value="version"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Infrastructure And Messaging)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/special/committees/inm/index.cfm"/>
          </telecom>
        </contact>
        <code value="version"/>
        <base value="MessageDefinition"/>
        <type value="token"/>
        <description value="The business version of the message definition"/>
        <expression value="MessageDefinition.version"/>
        <xpath value="f:MessageDefinition/f:version"/>
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
