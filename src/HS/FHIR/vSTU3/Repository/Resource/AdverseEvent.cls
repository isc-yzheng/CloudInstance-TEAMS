Class HS.FHIR.vSTU3.Repository.Resource.AdverseEvent Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-AdverseEvent"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AdverseEvent-category"/>
    <resource>
      <SearchParameter>
        <id value="AdverseEvent-category"/>
        <url value="http://hl7.org/fhir/SearchParameter/AdverseEvent-category"/>
        <name value="category"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Regulated Clinical Research Information Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/rcrim/index.cfm"/>
          </telecom>
        </contact>
        <code value="category"/>
        <base value="AdverseEvent"/>
        <type value="token"/>
        <description value="AE | PAE 
An adverse event is an event that caused harm to a patient,  an adverse reaction is a something that is a subject-specific event that is a result of an exposure to a medication, food, device or environmental substance, a potential adverse event is something that occurred and that could have caused harm to a patient but did not"/>
        <expression value="AdverseEvent.category"/>
        <xpath value="f:AdverseEvent/f:category"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AdverseEvent-date"/>
    <resource>
      <SearchParameter>
        <id value="AdverseEvent-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/AdverseEvent-date"/>
        <name value="date"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Regulated Clinical Research Information Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/rcrim/index.cfm"/>
          </telecom>
        </contact>
        <code value="date"/>
        <base value="AdverseEvent"/>
        <type value="date"/>
        <description value="When the event occurred"/>
        <expression value="AdverseEvent.date"/>
        <xpath value="f:AdverseEvent/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AdverseEvent-location"/>
    <resource>
      <SearchParameter>
        <id value="AdverseEvent-location"/>
        <url value="http://hl7.org/fhir/SearchParameter/AdverseEvent-location"/>
        <name value="location"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Regulated Clinical Research Information Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/rcrim/index.cfm"/>
          </telecom>
        </contact>
        <code value="location"/>
        <base value="AdverseEvent"/>
        <type value="reference"/>
        <description value="Location where adverse event occurred"/>
        <expression value="AdverseEvent.location"/>
        <xpath value="f:AdverseEvent/f:location"/>
        <xpathUsage value="normal"/>
        <target value="Location"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AdverseEvent-reaction"/>
    <resource>
      <SearchParameter>
        <id value="AdverseEvent-reaction"/>
        <url value="http://hl7.org/fhir/SearchParameter/AdverseEvent-reaction"/>
        <name value="reaction"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Regulated Clinical Research Information Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/rcrim/index.cfm"/>
          </telecom>
        </contact>
        <code value="reaction"/>
        <base value="AdverseEvent"/>
        <type value="reference"/>
        <description value="Adverse Reaction Events linked to exposure to substance"/>
        <expression value="AdverseEvent.reaction"/>
        <xpath value="f:AdverseEvent/f:reaction"/>
        <xpathUsage value="normal"/>
        <target value="Condition"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AdverseEvent-recorder"/>
    <resource>
      <SearchParameter>
        <id value="AdverseEvent-recorder"/>
        <url value="http://hl7.org/fhir/SearchParameter/AdverseEvent-recorder"/>
        <name value="recorder"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Regulated Clinical Research Information Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/rcrim/index.cfm"/>
          </telecom>
        </contact>
        <code value="recorder"/>
        <base value="AdverseEvent"/>
        <type value="reference"/>
        <description value="Who recorded the adverse event"/>
        <expression value="AdverseEvent.recorder"/>
        <xpath value="f:AdverseEvent/f:recorder"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="Patient"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AdverseEvent-seriousness"/>
    <resource>
      <SearchParameter>
        <id value="AdverseEvent-seriousness"/>
        <url value="http://hl7.org/fhir/SearchParameter/AdverseEvent-seriousness"/>
        <name value="seriousness"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Regulated Clinical Research Information Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/rcrim/index.cfm"/>
          </telecom>
        </contact>
        <code value="seriousness"/>
        <base value="AdverseEvent"/>
        <type value="token"/>
        <description value="Mild | Moderate | Severe"/>
        <expression value="AdverseEvent.seriousness"/>
        <xpath value="f:AdverseEvent/f:seriousness"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AdverseEvent-study"/>
    <resource>
      <SearchParameter>
        <id value="AdverseEvent-study"/>
        <url value="http://hl7.org/fhir/SearchParameter/AdverseEvent-study"/>
        <name value="study"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Regulated Clinical Research Information Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/rcrim/index.cfm"/>
          </telecom>
        </contact>
        <code value="study"/>
        <base value="AdverseEvent"/>
        <type value="reference"/>
        <description value="AdverseEvent.study"/>
        <expression value="AdverseEvent.study"/>
        <xpath value="f:AdverseEvent/f:study"/>
        <xpathUsage value="normal"/>
        <target value="ResearchStudy"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AdverseEvent-subject"/>
    <resource>
      <SearchParameter>
        <id value="AdverseEvent-subject"/>
        <url value="http://hl7.org/fhir/SearchParameter/AdverseEvent-subject"/>
        <name value="subject"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Regulated Clinical Research Information Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/rcrim/index.cfm"/>
          </telecom>
        </contact>
        <code value="subject"/>
        <base value="AdverseEvent"/>
        <type value="reference"/>
        <description value="Subject or group impacted by event"/>
        <expression value="AdverseEvent.subject"/>
        <xpath value="f:AdverseEvent/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="Medication"/>
        <target value="Patient"/>
        <target value="ResearchSubject"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AdverseEvent-substance"/>
    <resource>
      <SearchParameter>
        <id value="AdverseEvent-substance"/>
        <url value="http://hl7.org/fhir/SearchParameter/AdverseEvent-substance"/>
        <name value="substance"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Regulated Clinical Research Information Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/rcrim/index.cfm"/>
          </telecom>
        </contact>
        <code value="substance"/>
        <base value="AdverseEvent"/>
        <type value="reference"/>
        <description value="Refers to the specific entity that caused the adverse event"/>
        <expression value="AdverseEvent.suspectEntity.instance"/>
        <xpath value="f:AdverseEvent/f:suspectEntity/f:instance"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="Medication"/>
        <target value="Substance"/>
        <target value="MedicationAdministration"/>
        <target value="MedicationStatement"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/AdverseEvent-type"/>
    <resource>
      <SearchParameter>
        <id value="AdverseEvent-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/AdverseEvent-type"/>
        <name value="type"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Regulated Clinical Research Information Management)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/rcrim/index.cfm"/>
          </telecom>
        </contact>
        <code value="type"/>
        <base value="AdverseEvent"/>
        <type value="token"/>
        <description value="actual | potential"/>
        <expression value="AdverseEvent.type"/>
        <xpath value="f:AdverseEvent/f:type"/>
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
