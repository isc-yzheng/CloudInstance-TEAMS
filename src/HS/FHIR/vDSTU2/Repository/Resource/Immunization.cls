Class HS.FHIR.vDSTU2.Repository.Resource.Immunization Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Immunization"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Immunization-date"/>
    <resource>
      <SearchParameter>
        <id value="Immunization-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/Immunization-date"/>
        <name value="date"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="date"/>
        <base value="Immunization"/>
        <type value="date"/>
        <description value="Vaccination  (non)-Administration Date"/>
        <xpath value="f:Immunization/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Immunization-dose-sequence"/>
    <resource>
      <SearchParameter>
        <id value="Immunization-dose-sequence"/>
        <url value="http://hl7.org/fhir/SearchParameter/Immunization-dose-sequence"/>
        <name value="dose-sequence"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="dose-sequence"/>
        <base value="Immunization"/>
        <type value="number"/>
        <description value="Dose number within series"/>
        <xpath value="f:Immunization/f:vaccinationProtocol/f:doseSequence"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Immunization-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Immunization-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Immunization-identifier"/>
        <name value="identifier"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="identifier"/>
        <base value="Immunization"/>
        <type value="token"/>
        <description value="Business identifier"/>
        <xpath value="f:Immunization/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Immunization-location"/>
    <resource>
      <SearchParameter>
        <id value="Immunization-location"/>
        <url value="http://hl7.org/fhir/SearchParameter/Immunization-location"/>
        <name value="location"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="location"/>
        <base value="Immunization"/>
        <type value="reference"/>
        <description value="The service delivery location or facility in which the vaccine was / was to be administered"/>
        <xpath value="f:Immunization/f:location"/>
        <xpathUsage value="normal"/>
        <target value="Location"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Immunization-lot-number"/>
    <resource>
      <SearchParameter>
        <id value="Immunization-lot-number"/>
        <url value="http://hl7.org/fhir/SearchParameter/Immunization-lot-number"/>
        <name value="lot-number"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="lot-number"/>
        <base value="Immunization"/>
        <type value="string"/>
        <description value="Vaccine Lot Number"/>
        <xpath value="f:Immunization/f:lotNumber"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Immunization-manufacturer"/>
    <resource>
      <SearchParameter>
        <id value="Immunization-manufacturer"/>
        <url value="http://hl7.org/fhir/SearchParameter/Immunization-manufacturer"/>
        <name value="manufacturer"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="manufacturer"/>
        <base value="Immunization"/>
        <type value="reference"/>
        <description value="Vaccine Manufacturer"/>
        <xpath value="f:Immunization/f:manufacturer"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Immunization-notgiven"/>
    <resource>
      <SearchParameter>
        <id value="Immunization-notgiven"/>
        <url value="http://hl7.org/fhir/SearchParameter/Immunization-notgiven"/>
        <name value="notgiven"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="notgiven"/>
        <base value="Immunization"/>
        <type value="token"/>
        <description value="Administrations which were not given"/>
        <xpath value="f:Immunization/f:wasNotGiven"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Immunization-patient"/>
    <resource>
      <SearchParameter>
        <id value="Immunization-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/Immunization-patient"/>
        <name value="patient"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="patient"/>
        <base value="Immunization"/>
        <type value="reference"/>
        <description value="The patient for the vaccination record"/>
        <xpath value="f:Immunization/f:patient"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Immunization-performer"/>
    <resource>
      <SearchParameter>
        <id value="Immunization-performer"/>
        <url value="http://hl7.org/fhir/SearchParameter/Immunization-performer"/>
        <name value="performer"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="performer"/>
        <base value="Immunization"/>
        <type value="reference"/>
        <description value="The practitioner who administered the vaccination"/>
        <xpath value="f:Immunization/f:performer"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Immunization-reaction"/>
    <resource>
      <SearchParameter>
        <id value="Immunization-reaction"/>
        <url value="http://hl7.org/fhir/SearchParameter/Immunization-reaction"/>
        <name value="reaction"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="reaction"/>
        <base value="Immunization"/>
        <type value="reference"/>
        <description value="Additional information on reaction"/>
        <xpath value="f:Immunization/f:reaction/f:detail"/>
        <xpathUsage value="normal"/>
        <target value="Observation"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Immunization-reaction-date"/>
    <resource>
      <SearchParameter>
        <id value="Immunization-reaction-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/Immunization-reaction-date"/>
        <name value="reaction-date"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="reaction-date"/>
        <base value="Immunization"/>
        <type value="date"/>
        <description value="When reaction started"/>
        <xpath value="f:Immunization/f:reaction/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Immunization-reason"/>
    <resource>
      <SearchParameter>
        <id value="Immunization-reason"/>
        <url value="http://hl7.org/fhir/SearchParameter/Immunization-reason"/>
        <name value="reason"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="reason"/>
        <base value="Immunization"/>
        <type value="token"/>
        <description value="Why immunization occurred"/>
        <xpath value="f:Immunization/f:explanation/f:reason"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Immunization-reason-not-given"/>
    <resource>
      <SearchParameter>
        <id value="Immunization-reason-not-given"/>
        <url value="http://hl7.org/fhir/SearchParameter/Immunization-reason-not-given"/>
        <name value="reason-not-given"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="reason-not-given"/>
        <base value="Immunization"/>
        <type value="token"/>
        <description value="Explanation of reason vaccination was not administered"/>
        <xpath value="f:Immunization/f:explanation/f:reasonNotGiven"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Immunization-requester"/>
    <resource>
      <SearchParameter>
        <id value="Immunization-requester"/>
        <url value="http://hl7.org/fhir/SearchParameter/Immunization-requester"/>
        <name value="requester"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="requester"/>
        <base value="Immunization"/>
        <type value="reference"/>
        <description value="The practitioner who ordered the vaccination"/>
        <xpath value="f:Immunization/f:requester"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Immunization-status"/>
    <resource>
      <SearchParameter>
        <id value="Immunization-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/Immunization-status"/>
        <name value="status"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="status"/>
        <base value="Immunization"/>
        <type value="token"/>
        <description value="Immunization event status"/>
        <xpath value="f:Immunization/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Immunization-vaccine-code"/>
    <resource>
      <SearchParameter>
        <id value="Immunization-vaccine-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/Immunization-vaccine-code"/>
        <name value="vaccine-code"/>
        <publisher value="Health Level Seven International (Public Health and Emergency Response)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pher/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="vaccine-code"/>
        <base value="Immunization"/>
        <type value="token"/>
        <description value="Vaccine Product Administered"/>
        <xpath value="f:Immunization/f:vaccineCode"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
