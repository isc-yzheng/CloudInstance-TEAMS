Class HS.FHIR.vSTU3.Repository.Resource.Observation Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Observation"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-based-on"/>
    <resource>
      <SearchParameter>
        <id value="Observation-based-on"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-based-on"/>
        <name value="based-on"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="based-on"/>
        <base value="Observation"/>
        <type value="reference"/>
        <description value="Reference to the test or procedure request."/>
        <expression value="Observation.basedOn"/>
        <xpath value="f:Observation/f:basedOn"/>
        <xpathUsage value="normal"/>
        <target value="ReferralRequest"/>
        <target value="CarePlan"/>
        <target value="MedicationRequest"/>
        <target value="NutritionOrder"/>
        <target value="ProcedureRequest"/>
        <target value="DeviceRequest"/>
        <target value="ImmunizationRecommendation"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-category"/>
    <resource>
      <SearchParameter>
        <id value="Observation-category"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-category"/>
        <name value="category"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="category"/>
        <base value="Observation"/>
        <type value="token"/>
        <description value="The classification of the type of observation"/>
        <expression value="Observation.category"/>
        <xpath value="f:Observation/f:category"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/clinical-code"/>
    <resource>
      <SearchParameter>
        <id value="clinical-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/clinical-code"/>
        <name value="code"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <code value="code"/>
        <base value="FamilyMemberHistory"/>
        <base value="DeviceRequest"/>
        <base value="AllergyIntolerance"/>
        <base value="Procedure"/>
        <base value="List"/>
        <base value="ProcedureRequest"/>
        <base value="Observation"/>
        <base value="DiagnosticReport"/>
        <base value="Condition"/>
        <type value="token"/>
        <description value="Multiple Resources: 

* [FamilyMemberHistory](familymemberhistory.html): A search by a condition code
* [DeviceRequest](devicerequest.html): Code for what is being requested/ordered
* [AllergyIntolerance](allergyintolerance.html): Code that identifies the allergy or intolerance
* [Procedure](procedure.html): A code to identify a  procedure
* [List](list.html): What the purpose of this list is
* [ProcedureRequest](procedurerequest.html): What is being requested/ordered
* [Observation](observation.html): The code of the observation type
* [DiagnosticReport](diagnosticreport.html): The code for the report as a whole, as opposed to codes for the atomic results, which are the names on the observation resource referred to from the result
* [Condition](condition.html): Code for the condition
"/>
        <expression value="FamilyMemberHistory.condition.code | DeviceRequest.code.as(CodeableConcept) | AllergyIntolerance.code | AllergyIntolerance.reaction.substance | Procedure.code | List.code | ProcedureRequest.code | Observation.code | DiagnosticReport.code | Condition.code"/>
        <xpath value="f:FamilyMemberHistory/f:condition/f:code | f:DeviceRequest/f:codeCodeableConcept | f:AllergyIntolerance/f:code | f:AllergyIntolerance/f:reaction/f:substance | f:Procedure/f:code | f:List/f:code | f:ProcedureRequest/f:code | f:Observation/f:code | f:DiagnosticReport/f:code | f:Condition/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-code-value-concept"/>
    <resource>
      <SearchParameter>
        <id value="Observation-code-value-concept"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-code-value-concept"/>
        <name value="code-value-concept"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="code-value-concept"/>
        <base value="Observation"/>
        <type value="composite"/>
        <description value="Code and coded value parameter pair"/>
        <expression value="Observation"/>
        <xpathUsage value="normal"/>
        <component>
          <definition>
            <reference value="http://hl7.org/fhir/SearchParameter/Observation-code"/>
          </definition>
          <expression value="code"/>
        </component>
        <component>
          <definition>
            <reference value="http://hl7.org/fhir/SearchParameter/Observation-value-concept"/>
          </definition>
          <expression value="value.as(CodeableConcept)"/>
        </component>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-code-value-date"/>
    <resource>
      <SearchParameter>
        <id value="Observation-code-value-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-code-value-date"/>
        <name value="code-value-date"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="code-value-date"/>
        <base value="Observation"/>
        <type value="composite"/>
        <description value="Code and date/time value parameter pair"/>
        <expression value="Observation"/>
        <xpathUsage value="normal"/>
        <component>
          <definition>
            <reference value="http://hl7.org/fhir/SearchParameter/Observation-code"/>
          </definition>
          <expression value="code"/>
        </component>
        <component>
          <definition>
            <reference value="http://hl7.org/fhir/SearchParameter/Observation-value-date"/>
          </definition>
          <expression value="value.as(DateTime) | value.as(Period)"/>
        </component>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-code-value-quantity"/>
    <resource>
      <SearchParameter>
        <id value="Observation-code-value-quantity"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-code-value-quantity"/>
        <name value="code-value-quantity"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="code-value-quantity"/>
        <base value="Observation"/>
        <type value="composite"/>
        <description value="Code and quantity value parameter pair"/>
        <expression value="Observation"/>
        <xpathUsage value="normal"/>
        <component>
          <definition>
            <reference value="http://hl7.org/fhir/SearchParameter/Observation-code"/>
          </definition>
          <expression value="code"/>
        </component>
        <component>
          <definition>
            <reference value="http://hl7.org/fhir/SearchParameter/Observation-value-quantity"/>
          </definition>
          <expression value="value.as(Quantity)"/>
        </component>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-code-value-string"/>
    <resource>
      <SearchParameter>
        <id value="Observation-code-value-string"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-code-value-string"/>
        <name value="code-value-string"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="code-value-string"/>
        <base value="Observation"/>
        <type value="composite"/>
        <description value="Code and string value parameter pair"/>
        <expression value="Observation"/>
        <xpathUsage value="normal"/>
        <component>
          <definition>
            <reference value="http://hl7.org/fhir/SearchParameter/Observation-code"/>
          </definition>
          <expression value="code"/>
        </component>
        <component>
          <definition>
            <reference value="http://hl7.org/fhir/SearchParameter/Observation-value-string"/>
          </definition>
          <expression value="value.as(string)"/>
        </component>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-combo-code"/>
    <resource>
      <SearchParameter>
        <id value="Observation-combo-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-combo-code"/>
        <name value="combo-code"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="combo-code"/>
        <base value="Observation"/>
        <type value="token"/>
        <description value="The code of the observation type or component type"/>
        <expression value="Observation.code | Observation.component.code"/>
        <xpath value="f:Observation/f:code | f:Observation/f:component/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-combo-code-value-concept"/>
    <resource>
      <SearchParameter>
        <id value="Observation-combo-code-value-concept"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-combo-code-value-concept"/>
        <name value="combo-code-value-concept"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="combo-code-value-concept"/>
        <base value="Observation"/>
        <type value="composite"/>
        <description value="Code and coded value parameter pair, including in components"/>
        <expression value="Observation | Observation.component"/>
        <xpathUsage value="normal"/>
        <component>
          <definition>
            <reference value="http://hl7.org/fhir/SearchParameter/Observation-combo-code"/>
          </definition>
          <expression value="code"/>
        </component>
        <component>
          <definition>
            <reference value="http://hl7.org/fhir/SearchParameter/Observation-combo-value-concept"/>
          </definition>
          <expression value="value.as(CodeableConcept)"/>
        </component>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-combo-code-value-quantity"/>
    <resource>
      <SearchParameter>
        <id value="Observation-combo-code-value-quantity"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-combo-code-value-quantity"/>
        <name value="combo-code-value-quantity"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="combo-code-value-quantity"/>
        <base value="Observation"/>
        <type value="composite"/>
        <description value="Code and quantity value parameter pair, including in components"/>
        <expression value="Observation | Observation.component"/>
        <xpathUsage value="normal"/>
        <component>
          <definition>
            <reference value="http://hl7.org/fhir/SearchParameter/Observation-combo-code"/>
          </definition>
          <expression value="code"/>
        </component>
        <component>
          <definition>
            <reference value="http://hl7.org/fhir/SearchParameter/Observation-combo-value-quantity"/>
          </definition>
          <expression value="value.as(Quantity)"/>
        </component>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-combo-data-absent-reason"/>
    <resource>
      <SearchParameter>
        <id value="Observation-combo-data-absent-reason"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-combo-data-absent-reason"/>
        <name value="combo-data-absent-reason"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="combo-data-absent-reason"/>
        <base value="Observation"/>
        <type value="token"/>
        <description value="The reason why the expected value in the element Observation.value[x] or Observation.component.value[x] is missing."/>
        <expression value="Observation.dataAbsentReason | Observation.component.dataAbsentReason"/>
        <xpath value="f:Observation/f:dataAbsentReason | f:Observation/f:component/f:dataAbsentReason"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-combo-value-concept"/>
    <resource>
      <SearchParameter>
        <id value="Observation-combo-value-concept"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-combo-value-concept"/>
        <name value="combo-value-concept"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="combo-value-concept"/>
        <base value="Observation"/>
        <type value="token"/>
        <description value="The value or component value of the observation, if the value is a CodeableConcept"/>
        <expression value="Observation.value.as(CodeableConcept) | Observation.component.value.as(CodeableConcept)"/>
        <xpath value="f:Observation/f:valueCodeableConcept | f:Observation/f:component/f:valueCodeableConcept"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-combo-value-quantity"/>
    <resource>
      <SearchParameter>
        <id value="Observation-combo-value-quantity"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-combo-value-quantity"/>
        <name value="combo-value-quantity"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="combo-value-quantity"/>
        <base value="Observation"/>
        <type value="quantity"/>
        <description value="The value or component value of the observation, if the value is a Quantity, or a SampledData (just search on the bounds of the values in sampled data)"/>
        <expression value="Observation.value.as(Quantity) | Observation.component.value.as(Quantity)"/>
        <xpath value="f:Observation/f:valueQuantity | f:Observation/f:component/f:valueQuantity"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-component-code"/>
    <resource>
      <SearchParameter>
        <id value="Observation-component-code"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-component-code"/>
        <name value="component-code"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="component-code"/>
        <base value="Observation"/>
        <type value="token"/>
        <description value="The component code of the observation type"/>
        <expression value="Observation.component.code"/>
        <xpath value="f:Observation/f:component/f:code"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-component-code-value-concept"/>
    <resource>
      <SearchParameter>
        <id value="Observation-component-code-value-concept"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-component-code-value-concept"/>
        <name value="component-code-value-concept"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="component-code-value-concept"/>
        <base value="Observation"/>
        <type value="composite"/>
        <description value="Component code and component coded value parameter pair"/>
        <expression value="Observation.component"/>
        <xpathUsage value="normal"/>
        <component>
          <definition>
            <reference value="http://hl7.org/fhir/SearchParameter/Observation-component-code"/>
          </definition>
          <expression value="code"/>
        </component>
        <component>
          <definition>
            <reference value="http://hl7.org/fhir/SearchParameter/Observation-component-value-concept"/>
          </definition>
          <expression value="value.as(CodeableConcept)"/>
        </component>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-component-code-value-quantity"/>
    <resource>
      <SearchParameter>
        <id value="Observation-component-code-value-quantity"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-component-code-value-quantity"/>
        <name value="component-code-value-quantity"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="component-code-value-quantity"/>
        <base value="Observation"/>
        <type value="composite"/>
        <description value="Component code and component quantity value parameter pair"/>
        <expression value="Observation.component"/>
        <xpathUsage value="normal"/>
        <component>
          <definition>
            <reference value="http://hl7.org/fhir/SearchParameter/Observation-component-code"/>
          </definition>
          <expression value="code"/>
        </component>
        <component>
          <definition>
            <reference value="http://hl7.org/fhir/SearchParameter/Observation-component-value-quantity"/>
          </definition>
          <expression value="value.as(Quantity)"/>
        </component>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-component-data-absent-reason"/>
    <resource>
      <SearchParameter>
        <id value="Observation-component-data-absent-reason"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-component-data-absent-reason"/>
        <name value="component-data-absent-reason"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="component-data-absent-reason"/>
        <base value="Observation"/>
        <type value="token"/>
        <description value="The reason why the expected value in the element Observation.component.value[x] is missing."/>
        <expression value="Observation.component.dataAbsentReason"/>
        <xpath value="f:Observation/f:component/f:dataAbsentReason"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-component-value-concept"/>
    <resource>
      <SearchParameter>
        <id value="Observation-component-value-concept"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-component-value-concept"/>
        <name value="component-value-concept"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="component-value-concept"/>
        <base value="Observation"/>
        <type value="token"/>
        <description value="The value of the component observation, if the value is a CodeableConcept"/>
        <expression value="Observation.component.value.as(CodeableConcept)"/>
        <xpath value="f:Observation/f:component/f:valueCodeableConcept"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-component-value-quantity"/>
    <resource>
      <SearchParameter>
        <id value="Observation-component-value-quantity"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-component-value-quantity"/>
        <name value="component-value-quantity"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="component-value-quantity"/>
        <base value="Observation"/>
        <type value="quantity"/>
        <description value="The value of the component observation, if the value is a Quantity, or a SampledData (just search on the bounds of the values in sampled data)"/>
        <expression value="Observation.component.value.as(Quantity)"/>
        <xpath value="f:Observation/f:component/f:valueQuantity"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-context"/>
    <resource>
      <SearchParameter>
        <id value="Observation-context"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-context"/>
        <name value="context"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="context"/>
        <base value="Observation"/>
        <type value="reference"/>
        <description value="Healthcare event  (Episode-of-care or Encounter) related to the observation"/>
        <expression value="Observation.context"/>
        <xpath value="f:Observation/f:context"/>
        <xpathUsage value="normal"/>
        <target value="EpisodeOfCare"/>
        <target value="Encounter"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-data-absent-reason"/>
    <resource>
      <SearchParameter>
        <id value="Observation-data-absent-reason"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-data-absent-reason"/>
        <name value="data-absent-reason"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="data-absent-reason"/>
        <base value="Observation"/>
        <type value="token"/>
        <description value="The reason why the expected value in the element Observation.value[x] is missing."/>
        <expression value="Observation.dataAbsentReason"/>
        <xpath value="f:Observation/f:dataAbsentReason"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/clinical-date"/>
    <resource>
      <SearchParameter>
        <id value="clinical-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/clinical-date"/>
        <name value="date"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Community Based Collaborative Care)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/cbcc/index.cfm"/>
          </telecom>
        </contact>
        <code value="date"/>
        <base value="Consent"/>
        <base value="SupplyRequest"/>
        <base value="RiskAssessment"/>
        <base value="CareTeam"/>
        <base value="FamilyMemberHistory"/>
        <base value="Encounter"/>
        <base value="AllergyIntolerance"/>
        <base value="CarePlan"/>
        <base value="EpisodeOfCare"/>
        <base value="Procedure"/>
        <base value="List"/>
        <base value="Immunization"/>
        <base value="Flag"/>
        <base value="Observation"/>
        <base value="DiagnosticReport"/>
        <base value="Composition"/>
        <base value="DetectedIssue"/>
        <base value="ClinicalImpression"/>
        <type value="date"/>
        <description value="Multiple Resources: 

* [Consent](consent.html): When this Consent was created or indexed
* [SupplyRequest](supplyrequest.html): When the request was made
* [RiskAssessment](riskassessment.html): When was assessment made?
* [CareTeam](careteam.html): Time period team covers
* [FamilyMemberHistory](familymemberhistory.html): When history was captured/updated
* [Encounter](encounter.html): A date within the period the Encounter lasted
* [AllergyIntolerance](allergyintolerance.html): Date record was believed accurate
* [CarePlan](careplan.html): Time period plan covers
* [EpisodeOfCare](episodeofcare.html): The provided date search value falls within the episode of care&apos;s period
* [Procedure](procedure.html): Date/Period the procedure was performed
* [List](list.html): When the list was prepared
* [Immunization](immunization.html): Vaccination  (non)-Administration Date
* [Flag](flag.html): Time period when flag is active
* [Observation](observation.html): Obtained date/time. If the obtained element is a period, a date that falls in the period
* [DiagnosticReport](diagnosticreport.html): The clinically relevant time of the report
* [Composition](composition.html): Composition editing time
* [DetectedIssue](detectedissue.html): When identified
* [ClinicalImpression](clinicalimpression.html): When the assessment was documented
"/>
        <expression value="Consent.dateTime | SupplyRequest.authoredOn | RiskAssessment.occurrence.as(DateTime) | CareTeam.period | FamilyMemberHistory.date | Encounter.period | AllergyIntolerance.assertedDate | CarePlan.period | EpisodeOfCare.period | Procedure.performed | List.date | Immunization.date | Flag.period | Observation.effective | DiagnosticReport.effective | Composition.date | DetectedIssue.date | ClinicalImpression.date"/>
        <xpath value="f:Consent/f:dateTime | f:SupplyRequest/f:authoredOn | f:RiskAssessment/f:occurrenceDateTime | f:CareTeam/f:period | f:FamilyMemberHistory/f:date | f:Encounter/f:period | f:AllergyIntolerance/f:assertedDate | f:CarePlan/f:period | f:EpisodeOfCare/f:period | f:Procedure/f:performedDateTime | f:Procedure/f:performedPeriod | f:List/f:date | f:Immunization/f:date | f:Flag/f:period | f:Observation/f:effectiveDateTime | f:Observation/f:effectivePeriod | f:DiagnosticReport/f:effectiveDateTime | f:DiagnosticReport/f:effectivePeriod | f:Composition/f:date | f:DetectedIssue/f:date | f:ClinicalImpression/f:date"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-device"/>
    <resource>
      <SearchParameter>
        <id value="Observation-device"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-device"/>
        <name value="device"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="device"/>
        <base value="Observation"/>
        <type value="reference"/>
        <description value="The Device that generated the observation data."/>
        <expression value="Observation.device"/>
        <xpath value="f:Observation/f:device"/>
        <xpathUsage value="normal"/>
        <target value="Device"/>
        <target value="DeviceMetric"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/clinical-encounter"/>
    <resource>
      <SearchParameter>
        <id value="clinical-encounter"/>
        <url value="http://hl7.org/fhir/SearchParameter/clinical-encounter"/>
        <name value="encounter"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Structured Documents)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/structure/index.cfm"/>
          </telecom>
        </contact>
        <code value="encounter"/>
        <base value="DocumentReference"/>
        <base value="RiskAssessment"/>
        <base value="DeviceRequest"/>
        <base value="Procedure"/>
        <base value="List"/>
        <base value="VisionPrescription"/>
        <base value="ProcedureRequest"/>
        <base value="Flag"/>
        <base value="Observation"/>
        <base value="DiagnosticReport"/>
        <base value="NutritionOrder"/>
        <base value="Composition"/>
        <type value="reference"/>
        <description value="Multiple Resources: 

* [DocumentReference](documentreference.html): Context of the document  content
* [RiskAssessment](riskassessment.html): Where was assessment performed?
* [DeviceRequest](devicerequest.html): Encounter or Episode during which request was created
* [Procedure](procedure.html): Search by encounter
* [List](list.html): Context in which list created
* [VisionPrescription](visionprescription.html): Return prescriptions with this encounter identifier
* [ProcedureRequest](procedurerequest.html): An encounter in which this request is made
* [Flag](flag.html): Alert relevant during encounter
* [Observation](observation.html): Encounter related to the observation
* [DiagnosticReport](diagnosticreport.html): The Encounter when the order was made
* [NutritionOrder](nutritionorder.html): Return nutrition orders with this encounter identifier
* [Composition](composition.html): Context of the Composition
"/>
        <expression value="DocumentReference.context.encounter | RiskAssessment.context | DeviceRequest.context | Procedure.context | List.encounter | VisionPrescription.encounter | ProcedureRequest.context | Flag.encounter | Observation.context | DiagnosticReport.context | NutritionOrder.encounter | Composition.encounter"/>
        <xpath value="f:DocumentReference/f:context/f:encounter | f:RiskAssessment/f:context | f:DeviceRequest/f:context | f:Procedure/f:context | f:List/f:encounter | f:VisionPrescription/f:encounter | f:ProcedureRequest/f:context | f:Flag/f:encounter | f:Observation/f:context | f:DiagnosticReport/f:context | f:NutritionOrder/f:encounter | f:Composition/f:encounter"/>
        <xpathUsage value="normal"/>
        <target value="Encounter"/>
        <target value="EpisodeOfCare"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/clinical-identifier"/>
    <resource>
      <SearchParameter>
        <id value="clinical-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/clinical-identifier"/>
        <name value="identifier"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Structured Documents)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/structure/index.cfm"/>
          </telecom>
        </contact>
        <code value="identifier"/>
        <base value="DocumentManifest"/>
        <base value="Goal"/>
        <base value="Consent"/>
        <base value="DocumentReference"/>
        <base value="SupplyRequest"/>
        <base value="RiskAssessment"/>
        <base value="CareTeam"/>
        <base value="ImagingStudy"/>
        <base value="FamilyMemberHistory"/>
        <base value="Encounter"/>
        <base value="DeviceRequest"/>
        <base value="AllergyIntolerance"/>
        <base value="CarePlan"/>
        <base value="EpisodeOfCare"/>
        <base value="Procedure"/>
        <base value="List"/>
        <base value="Immunization"/>
        <base value="VisionPrescription"/>
        <base value="ProcedureRequest"/>
        <base value="Observation"/>
        <base value="DiagnosticReport"/>
        <base value="NutritionOrder"/>
        <base value="Condition"/>
        <base value="Composition"/>
        <base value="DetectedIssue"/>
        <base value="SupplyDelivery"/>
        <type value="token"/>
        <description value="Multiple Resources: 

* [DocumentManifest](documentmanifest.html): Unique Identifier for the set of documents
* [Goal](goal.html): External Ids for this goal
* [Consent](consent.html): Identifier for this record (external references)
* [DocumentReference](documentreference.html): Master Version Specific Identifier
* [SupplyRequest](supplyrequest.html): Unique identifier
* [RiskAssessment](riskassessment.html): Unique identifier for the assessment
* [CareTeam](careteam.html): External Ids for this team
* [ImagingStudy](imagingstudy.html): Other identifiers for the Study
* [FamilyMemberHistory](familymemberhistory.html): A search by a record identifier
* [Encounter](encounter.html): Identifier(s) by which this encounter is known
* [DeviceRequest](devicerequest.html): Business identifier for request/order
* [AllergyIntolerance](allergyintolerance.html): External ids for this item
* [CarePlan](careplan.html): External Ids for this plan
* [EpisodeOfCare](episodeofcare.html): Business Identifier(s) relevant for this EpisodeOfCare
* [Procedure](procedure.html): A unique identifier for a procedure
* [List](list.html): Business identifier
* [Immunization](immunization.html): Business identifier
* [VisionPrescription](visionprescription.html): Return prescriptions with this external identifier
* [ProcedureRequest](procedurerequest.html): Identifiers assigned to this order
* [Observation](observation.html): The unique id for a particular observation
* [DiagnosticReport](diagnosticreport.html): An identifier for the report
* [NutritionOrder](nutritionorder.html): Return nutrition orders with this external identifier
* [Condition](condition.html): A unique identifier of the condition record
* [Composition](composition.html): Logical identifier of composition (version-independent)
* [DetectedIssue](detectedissue.html): Unique id for the detected issue
* [SupplyDelivery](supplydelivery.html): External identifier
"/>
        <expression value="DocumentManifest.masterIdentifier | DocumentManifest.identifier | Goal.identifier | Consent.identifier | DocumentReference.masterIdentifier | DocumentReference.identifier | SupplyRequest.identifier | RiskAssessment.identifier | CareTeam.identifier | ImagingStudy.identifier | FamilyMemberHistory.identifier | Encounter.identifier | DeviceRequest.identifier | AllergyIntolerance.identifier | CarePlan.identifier | EpisodeOfCare.identifier | Procedure.identifier | List.identifier | Immunization.identifier | VisionPrescription.identifier | ProcedureRequest.identifier | Observation.identifier | DiagnosticReport.identifier | NutritionOrder.identifier | Condition.identifier | Composition.identifier | DetectedIssue.identifier | SupplyDelivery.identifier"/>
        <xpath value="f:DocumentManifest/f:masterIdentifier | f:DocumentManifest/f:identifier | f:Goal/f:identifier | f:Consent/f:identifier | f:DocumentReference/f:masterIdentifier | f:DocumentReference/f:identifier | f:SupplyRequest/f:identifier | f:RiskAssessment/f:identifier | f:CareTeam/f:identifier | f:ImagingStudy/f:identifier | f:FamilyMemberHistory/f:identifier | f:Encounter/f:identifier | f:DeviceRequest/f:identifier | f:AllergyIntolerance/f:identifier | f:CarePlan/f:identifier | f:EpisodeOfCare/f:identifier | f:Procedure/f:identifier | f:List/f:identifier | f:Immunization/f:identifier | f:VisionPrescription/f:identifier | f:ProcedureRequest/f:identifier | f:Observation/f:identifier | f:DiagnosticReport/f:identifier | f:NutritionOrder/f:identifier | f:Condition/f:identifier | f:Composition/f:identifier | f:DetectedIssue/f:identifier | f:SupplyDelivery/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-method"/>
    <resource>
      <SearchParameter>
        <id value="Observation-method"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-method"/>
        <name value="method"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="method"/>
        <base value="Observation"/>
        <type value="token"/>
        <description value="The method used for the observation"/>
        <expression value="Observation.method"/>
        <xpath value="f:Observation/f:method"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/clinical-patient"/>
    <resource>
      <SearchParameter>
        <id value="clinical-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/clinical-patient"/>
        <name value="patient"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Patient Care)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/patientcare/index.cfm"/>
          </telecom>
        </contact>
        <code value="patient"/>
        <base value="ReferralRequest"/>
        <base value="DocumentManifest"/>
        <base value="Goal"/>
        <base value="Consent"/>
        <base value="DocumentReference"/>
        <base value="ImagingManifest"/>
        <base value="RiskAssessment"/>
        <base value="CareTeam"/>
        <base value="ImagingStudy"/>
        <base value="FamilyMemberHistory"/>
        <base value="Encounter"/>
        <base value="DeviceUseStatement"/>
        <base value="DeviceRequest"/>
        <base value="AllergyIntolerance"/>
        <base value="CarePlan"/>
        <base value="EpisodeOfCare"/>
        <base value="Procedure"/>
        <base value="List"/>
        <base value="Immunization"/>
        <base value="VisionPrescription"/>
        <base value="ProcedureRequest"/>
        <base value="Flag"/>
        <base value="Observation"/>
        <base value="DiagnosticReport"/>
        <base value="NutritionOrder"/>
        <base value="Condition"/>
        <base value="Composition"/>
        <base value="DetectedIssue"/>
        <base value="SupplyDelivery"/>
        <base value="ClinicalImpression"/>
        <type value="reference"/>
        <description value="Multiple Resources: 

* [ReferralRequest](referralrequest.html): Who the referral is about
* [DocumentManifest](documentmanifest.html): The subject of the set of documents
* [Goal](goal.html): Who this goal is intended for
* [Consent](consent.html): Who the consent applies to
* [DocumentReference](documentreference.html): Who/what is the subject of the document
* [ImagingManifest](imagingmanifest.html): Subject of the ImagingManifest (or a DICOM Key Object Selection which it represents)
* [RiskAssessment](riskassessment.html): Who/what does assessment apply to?
* [CareTeam](careteam.html): Who care team is for
* [ImagingStudy](imagingstudy.html): Who the study is about
* [FamilyMemberHistory](familymemberhistory.html): The identity of a subject to list family member history items for
* [Encounter](encounter.html): The patient ro group present at the encounter
* [DeviceUseStatement](deviceusestatement.html): Search by subject - a patient
* [DeviceRequest](devicerequest.html): Individual the service is ordered for
* [AllergyIntolerance](allergyintolerance.html): Who the sensitivity is for
* [CarePlan](careplan.html): Who care plan is for
* [EpisodeOfCare](episodeofcare.html): The patient who is the focus of this episode of care
* [Procedure](procedure.html): Search by subject - a patient
* [List](list.html): If all resources have the same subject
* [Immunization](immunization.html): The patient for the vaccination record
* [VisionPrescription](visionprescription.html): The identity of a patient to list dispenses for
* [ProcedureRequest](procedurerequest.html): Search by subject - a patient
* [Flag](flag.html): The identity of a subject to list flags for
* [Observation](observation.html): The subject that the observation is about (if patient)
* [DiagnosticReport](diagnosticreport.html): The subject of the report if a patient
* [NutritionOrder](nutritionorder.html): The identity of the person who requires the diet, formula or nutritional supplement
* [Condition](condition.html): Who has the condition?
* [Composition](composition.html): Who and/or what the composition is about
* [DetectedIssue](detectedissue.html): Associated patient
* [SupplyDelivery](supplydelivery.html): Patient for whom the item is supplied
* [ClinicalImpression](clinicalimpression.html): Patient or group assessed
"/>
        <expression value="ReferralRequest.subject | DocumentManifest.subject | Goal.subject | Consent.patient | DocumentReference.subject | ImagingManifest.patient | RiskAssessment.subject | CareTeam.subject | ImagingStudy.patient | FamilyMemberHistory.patient | Encounter.subject | DeviceUseStatement.subject | DeviceRequest.subject | AllergyIntolerance.patient | CarePlan.subject | EpisodeOfCare.patient | Procedure.subject | List.subject | Immunization.patient | VisionPrescription.patient | ProcedureRequest.subject | Flag.subject | Observation.subject | DiagnosticReport.subject | NutritionOrder.patient | Condition.subject | Composition.subject | DetectedIssue.patient | SupplyDelivery.patient | ClinicalImpression.subject"/>
        <xpath value="f:ReferralRequest/f:subject | f:DocumentManifest/f:subject | f:Goal/f:subject | f:Consent/f:patient | f:DocumentReference/f:subject | f:ImagingManifest/f:patient | f:RiskAssessment/f:subject | f:CareTeam/f:subject | f:ImagingStudy/f:patient | f:FamilyMemberHistory/f:patient | f:Encounter/f:subject | f:DeviceUseStatement/f:subject | f:DeviceRequest/f:subject | f:AllergyIntolerance/f:patient | f:CarePlan/f:subject | f:EpisodeOfCare/f:patient | f:Procedure/f:subject | f:List/f:subject | f:Immunization/f:patient | f:VisionPrescription/f:patient | f:ProcedureRequest/f:subject | f:Flag/f:subject | f:Observation/f:subject | f:DiagnosticReport/f:subject | f:NutritionOrder/f:patient | f:Condition/f:subject | f:Composition/f:subject | f:DetectedIssue/f:patient | f:SupplyDelivery/f:patient | f:ClinicalImpression/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
        <target value="Group"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-performer"/>
    <resource>
      <SearchParameter>
        <id value="Observation-performer"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-performer"/>
        <name value="performer"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="performer"/>
        <base value="Observation"/>
        <type value="reference"/>
        <description value="Who performed the observation"/>
        <expression value="Observation.performer"/>
        <xpath value="f:Observation/f:performer"/>
        <xpathUsage value="normal"/>
        <target value="Practitioner"/>
        <target value="Organization"/>
        <target value="Patient"/>
        <target value="RelatedPerson"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-related"/>
    <resource>
      <SearchParameter>
        <id value="Observation-related"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-related"/>
        <name value="related"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="related"/>
        <base value="Observation"/>
        <type value="composite"/>
        <description value="Related Observations - search on related-type and related-target together"/>
        <expression value="Observation.related"/>
        <xpathUsage value="normal"/>
        <component>
          <definition>
            <reference value="http://hl7.org/fhir/SearchParameter/Observation-related-target"/>
          </definition>
          <expression value="target"/>
        </component>
        <component>
          <definition>
            <reference value="http://hl7.org/fhir/SearchParameter/Observation-related-type"/>
          </definition>
          <expression value="type"/>
        </component>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-related-target"/>
    <resource>
      <SearchParameter>
        <id value="Observation-related-target"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-related-target"/>
        <name value="related-target"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="related-target"/>
        <base value="Observation"/>
        <type value="reference"/>
        <description value="Resource that is related to this one"/>
        <expression value="Observation.related.target"/>
        <xpath value="f:Observation/f:related/f:target"/>
        <xpathUsage value="normal"/>
        <target value="Observation"/>
        <target value="Sequence"/>
        <target value="QuestionnaireResponse"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-related-type"/>
    <resource>
      <SearchParameter>
        <id value="Observation-related-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-related-type"/>
        <name value="related-type"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="related-type"/>
        <base value="Observation"/>
        <type value="token"/>
        <description value="has-member | derived-from | sequel-to | replaces | qualified-by | interfered-by"/>
        <expression value="Observation.related.type"/>
        <xpath value="f:Observation/f:related/f:type"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-specimen"/>
    <resource>
      <SearchParameter>
        <id value="Observation-specimen"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-specimen"/>
        <name value="specimen"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="specimen"/>
        <base value="Observation"/>
        <type value="reference"/>
        <description value="Specimen used for this observation"/>
        <expression value="Observation.specimen"/>
        <xpath value="f:Observation/f:specimen"/>
        <xpathUsage value="normal"/>
        <target value="Specimen"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-status"/>
    <resource>
      <SearchParameter>
        <id value="Observation-status"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-status"/>
        <name value="status"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="status"/>
        <base value="Observation"/>
        <type value="token"/>
        <description value="The status of the observation"/>
        <expression value="Observation.status"/>
        <xpath value="f:Observation/f:status"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-subject"/>
    <resource>
      <SearchParameter>
        <id value="Observation-subject"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-subject"/>
        <name value="subject"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="subject"/>
        <base value="Observation"/>
        <type value="reference"/>
        <description value="The subject that the observation is about"/>
        <expression value="Observation.subject"/>
        <xpath value="f:Observation/f:subject"/>
        <xpathUsage value="normal"/>
        <target value="Group"/>
        <target value="Device"/>
        <target value="Patient"/>
        <target value="Location"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-value-concept"/>
    <resource>
      <SearchParameter>
        <id value="Observation-value-concept"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-value-concept"/>
        <name value="value-concept"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="value-concept"/>
        <base value="Observation"/>
        <type value="token"/>
        <description value="The value of the observation, if the value is a CodeableConcept"/>
        <expression value="Observation.value.as(CodeableConcept)"/>
        <xpath value="f:Observation/f:valueCodeableConcept"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-value-date"/>
    <resource>
      <SearchParameter>
        <id value="Observation-value-date"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-value-date"/>
        <name value="value-date"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="value-date"/>
        <base value="Observation"/>
        <type value="date"/>
        <description value="The value of the observation, if the value is a date or period of time"/>
        <expression value="Observation.value.as(DateTime) | Observation.value.as(Period)"/>
        <xpath value="f:Observation/f:valueDateTime | f:Observation/f:valuePeriod"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-value-quantity"/>
    <resource>
      <SearchParameter>
        <id value="Observation-value-quantity"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-value-quantity"/>
        <name value="value-quantity"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="value-quantity"/>
        <base value="Observation"/>
        <type value="quantity"/>
        <description value="The value of the observation, if the value is a Quantity, or a SampledData (just search on the bounds of the values in sampled data)"/>
        <expression value="Observation.value.as(Quantity)"/>
        <xpath value="f:Observation/f:valueQuantity"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <!--
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Observation-value-string"/>
    <resource>
      <SearchParameter>
        <id value="Observation-value-string"/>
        <url value="http://hl7.org/fhir/SearchParameter/Observation-value-string"/>
        <name value="value-string"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Orders and Observations)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/orders/index.cfm"/>
          </telecom>
        </contact>
        <code value="value-string"/>
        <base value="Observation"/>
        <type value="string"/>
        <description value="The value of the observation, if the value is a string, and also searches in CodeableConcept.text"/>
        <expression value="Observation.value.as(String)"/>
        <xpath value="f:Observation/f:valueString"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  -->
</Bundle>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
