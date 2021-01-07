Class HS.FHIR.vDSTU2.Repository.Resource.Patient Extends (HS.FHIR.vDSTU2.Repository.Resource.Abstract, %Persistent)
{

Method deceased()
{
	// The xpath for this param is: "f:Patient/f:deceasedBoolean | f:Patient/f:deceasedDateTime"
	// However the indexed value supposed to be a boolean corresponding to the value of deceasedBoolean
	// if present, or "true" if deceasedDateTime is present, and otherwise null.
	try {
		if (..Format="JSON") {
			set tIsDeceased = ""
			set tXPath = "f:Patient/f:deceasedBoolean/@value"
			Set tResults = 0
			Set tSC = ..EvaluateXPathDynamicObj(..ResourceObject, .tXPath, .tResults)
			If tResults>0 {
				For tI = 1:1:tResults {
					set tIsDeceased = tResults(tI)
				}
			} Else {
				set tXPath = "f:Patient/f:deceasedBoolean/@value"
				Set tSC = ..EvaluateXPathDynamicObj(..ResourceObject, .tXPath, .tResults)
				If tResults>0 {
					Set tIsDeceased = "true"
				}
			}
			if (tIsDeceased'="") { set tSC = ..AddToSearchTableEntry("deceased", tIsDeceased) }
			quit
		}
		
		set tIsDeceased = ""
		set tXPath = "f:Patient/f:deceasedBoolean/@value"
		set tSC = ##class(HS.FHIR.Utils).EvaluateXPathExpression(..XPathDoc, tXPath, ..ResourceSchema, /*ResultType*/, .tResults) quit:$$$ISERR(tSC)
		if (tResults.Count()=1) { set tIsDeceased = tResults.GetAt(1) }
		else {
			set tXPath = "f:Patient/f:deceasedDateTime/@value"
			kill tResults
			set tSC = ##class(HS.FHIR.Utils).EvaluateXPathExpression(..XPathDoc, tXPath, ..ResourceSchema, /*ResultType*/, .tResults) quit:$$$ISERR(tSC)
			if (tResults.Count()=1)&&(tResults.GetAt(1)'="") { set tIsDeceased = "true" }
		}
		if (tIsDeceased'="") { set tSC = ..AddToSearchTableEntry("deceased", tIsDeceased) }
	}
	catch (ex) { set tSC = ex.AsStatus() }
	quit tSC
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData DSTU2SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Patient"/>
  <meta>
    <lastUpdated value="2015-10-24T07:41:03.495+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-active"/>
    <resource>
      <SearchParameter>
        <id value="Patient-active"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-active"/>
        <name value="active"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="active"/>
        <base value="Patient"/>
        <type value="token"/>
        <description value="Whether the patient record is active"/>
        <xpath value="f:Patient/f:active"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-address"/>
    <resource>
      <SearchParameter>
        <id value="Patient-address"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-address"/>
        <name value="address"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="address"/>
        <base value="Patient"/>
        <type value="string"/>
        <description value="An address in any kind of address/part of the patient"/>
        <xpath value="f:Patient/f:address"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-address-city"/>
    <resource>
      <SearchParameter>
        <id value="Patient-address-city"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-address-city"/>
        <name value="address-city"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="address-city"/>
        <base value="Patient"/>
        <type value="string"/>
        <description value="A city specified in an address"/>
        <xpath value="f:Patient/f:address/f:city"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-address-country"/>
    <resource>
      <SearchParameter>
        <id value="Patient-address-country"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-address-country"/>
        <name value="address-country"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="address-country"/>
        <base value="Patient"/>
        <type value="string"/>
        <description value="A country specified in an address"/>
        <xpath value="f:Patient/f:address/f:country"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-address-postalcode"/>
    <resource>
      <SearchParameter>
        <id value="Patient-address-postalcode"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-address-postalcode"/>
        <name value="address-postalcode"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="address-postalcode"/>
        <base value="Patient"/>
        <type value="string"/>
        <description value="A postalCode specified in an address"/>
        <xpath value="f:Patient/f:address/f:postalCode"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-address-state"/>
    <resource>
      <SearchParameter>
        <id value="Patient-address-state"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-address-state"/>
        <name value="address-state"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="address-state"/>
        <base value="Patient"/>
        <type value="string"/>
        <description value="A state specified in an address"/>
        <xpath value="f:Patient/f:address/f:state"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-address-use"/>
    <resource>
      <SearchParameter>
        <id value="Patient-address-use"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-address-use"/>
        <name value="address-use"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="address-use"/>
        <base value="Patient"/>
        <type value="token"/>
        <description value="A use code specified in an address"/>
        <xpath value="f:Patient/f:address/f:use"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-animal-breed"/>
    <resource>
      <SearchParameter>
        <id value="Patient-animal-breed"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-animal-breed"/>
        <name value="animal-breed"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="animal-breed"/>
        <base value="Patient"/>
        <type value="token"/>
        <description value="The breed for animal patients"/>
        <xpath value="f:Patient/f:animal/f:breed"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-animal-species"/>
    <resource>
      <SearchParameter>
        <id value="Patient-animal-species"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-animal-species"/>
        <name value="animal-species"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="animal-species"/>
        <base value="Patient"/>
        <type value="token"/>
        <description value="The species for animal patients"/>
        <xpath value="f:Patient/f:animal/f:species"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-birthdate"/>
    <resource>
      <SearchParameter>
        <id value="Patient-birthdate"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-birthdate"/>
        <name value="birthdate"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="birthdate"/>
        <base value="Patient"/>
        <type value="date"/>
        <description value="The patient&apos;s date of birth"/>
        <xpath value="f:Patient/f:birthDate"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-careprovider"/>
    <resource>
      <SearchParameter>
        <id value="Patient-careprovider"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-careprovider"/>
        <name value="careprovider"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="careprovider"/>
        <base value="Patient"/>
        <type value="reference"/>
        <description value="Patient&apos;s nominated care provider, could be a care manager, not the organization that manages the record"/>
        <xpath value="f:Patient/f:careProvider"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
        <target value="Practitioner"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-deathdate"/>
    <resource>
      <SearchParameter>
        <id value="Patient-deathdate"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-deathdate"/>
        <name value="deathdate"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="deathdate"/>
        <base value="Patient"/>
        <type value="date"/>
        <description value="The date of death has been provided and satisfies this search value"/>
        <xpath value="f:Patient/f:deceasedDateTime"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-deceased"/>
    <resource>
      <SearchParameter>
        <id value="Patient-deceased"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-deceased"/>
        <name value="deceased"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="deceased"/>
        <base value="Patient"/>
        <type value="token"/>
        <description value="This patient has been marked as deceased, or as a death date entered"/>
        <xpath value="f:Patient/f:deceasedBoolean | f:Patient/f:deceasedDateTime"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-email"/>
    <resource>
      <SearchParameter>
        <id value="Patient-email"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-email"/>
        <name value="email"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="email"/>
        <base value="Patient"/>
        <type value="token"/>
        <description value="A value in an email contact"/>
        <xpath value="f:Patient/f:telecom[system/@value=&apos;email&apos;]"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/us-core-Patient-ethnicity"/>
    <resource>
      <SearchParameter>
        <id value="us-core-Patient-ethnicity"/>
        <url value="http://hl7.org/fhir/SearchParameter/us-core-Patient-ethnicity"/>
        <name value="ethnicity"/>
        <code value="ethnicity"/>
        <base value="Patient"/>
        <type value="token"/>
        <description value="Returns patients with an ethnicity extension matching the specified code."/>
        <xpath value="f:Patient/f:extension[@url=&apos;http://hl7.org/fhir/StructureDefinition/us-core-ethnicity&apos;]/f:valueCodeableConcept"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-family"/>
    <resource>
      <SearchParameter>
        <id value="Patient-family"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-family"/>
        <name value="family"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="family"/>
        <base value="Patient"/>
        <type value="string"/>
        <description value="A portion of the family name of the patient"/>
        <xpath value="f:Patient/f:name/f:family"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-gender"/>
    <resource>
      <SearchParameter>
        <id value="Patient-gender"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-gender"/>
        <name value="gender"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="gender"/>
        <base value="Patient"/>
        <type value="token"/>
        <description value="Gender of the patient"/>
        <xpath value="f:Patient/f:gender"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-given"/>
    <resource>
      <SearchParameter>
        <id value="Patient-given"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-given"/>
        <name value="given"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="given"/>
        <base value="Patient"/>
        <type value="string"/>
        <description value="A portion of the given name of the patient"/>
        <xpath value="f:Patient/f:name/f:given"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Patient-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-identifier"/>
        <name value="identifier"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="identifier"/>
        <base value="Patient"/>
        <type value="token"/>
        <description value="A patient identifier"/>
        <xpath value="f:Patient/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-language"/>
    <resource>
      <SearchParameter>
        <id value="Patient-language"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-language"/>
        <name value="language"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="language"/>
        <base value="Patient"/>
        <type value="token"/>
        <description value="Language code (irrespective of use value)"/>
        <xpath value="f:Patient/f:communication/f:language"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-link"/>
    <resource>
      <SearchParameter>
        <id value="Patient-link"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-link"/>
        <name value="link"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="link"/>
        <base value="Patient"/>
        <type value="reference"/>
        <description value="All patients linked to the given patient"/>
        <xpath value="f:Patient/f:link/f:other"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-name"/>
    <resource>
      <SearchParameter>
        <id value="Patient-name"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-name"/>
        <name value="name"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="name"/>
        <base value="Patient"/>
        <type value="string"/>
        <description value="A portion of either family or given name of the patient"/>
        <xpath value="f:Patient/f:name"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-organization"/>
    <resource>
      <SearchParameter>
        <id value="Patient-organization"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-organization"/>
        <name value="organization"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="organization"/>
        <base value="Patient"/>
        <type value="reference"/>
        <description value="The organization at which this person is a patient"/>
        <xpath value="f:Patient/f:managingOrganization"/>
        <xpathUsage value="normal"/>
        <target value="Organization"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-phone"/>
    <resource>
      <SearchParameter>
        <id value="Patient-phone"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-phone"/>
        <name value="phone"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="phone"/>
        <base value="Patient"/>
        <type value="token"/>
        <description value="A value in a phone contact"/>
        <xpath value="f:Patient/f:telecom[system/@value=&apos;phone&apos;]"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/us-core-Patient-race"/>
    <resource>
      <SearchParameter>
        <id value="us-core-Patient-race"/>
        <url value="http://hl7.org/fhir/SearchParameter/us-core-Patient-race"/>
        <name value="race"/>
        <code value="race"/>
        <base value="Patient"/>
        <type value="token"/>
        <description value="Returns patients with a race extension matching the specified code."/>
        <xpath value="f:Patient/f:extension[@url=&apos;http://hl7.org/fhir/StructureDefinition/us-core-race&apos;]/f:valueCodeableConcept"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Patient-telecom"/>
    <resource>
      <SearchParameter>
        <id value="Patient-telecom"/>
        <url value="http://hl7.org/fhir/SearchParameter/Patient-telecom"/>
        <name value="telecom"/>
        <publisher value="Health Level Seven International (Patient Administration)"/>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="other"/>
            <value value="http://www.hl7.org/Special/committees/pafm/index.cfm"/>
          </telecom>
        </contact>
        <date value="2015-10-24T07:41:03+11:00"/>
        <code value="telecom"/>
        <base value="Patient"/>
        <type value="token"/>
        <description value="The value in any kind of telecom details of the patient"/>
        <xpath value="f:Patient/f:telecom"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
</Bundle>
}

}
