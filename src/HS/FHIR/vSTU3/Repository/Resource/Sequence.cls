Class HS.FHIR.vSTU3.Repository.Resource.Sequence Extends (HS.FHIR.vSTU3.Repository.Resource.Abstract, %Persistent) [ Inheritance = left, ProcedureBlock ]
{

XData SearchParameters
{
<Bundle xmlns="http://hl7.org/fhir">
  <id value="searchParams-Sequence"/>
  <meta>
    <lastUpdated value="2017-03-21T06:09:53.925+11:00"/>
  </meta>
  <type value="collection"/>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Sequence-chromosome"/>
    <resource>
      <SearchParameter>
        <id value="Sequence-chromosome"/>
        <url value="http://hl7.org/fhir/SearchParameter/Sequence-chromosome"/>
        <name value="chromosome"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Clinical Genomics)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/clingenomics/index.cfm"/>
          </telecom>
        </contact>
        <code value="chromosome"/>
        <base value="Sequence"/>
        <type value="token"/>
        <description value="Chromosome number of the reference sequence"/>
        <expression value="Sequence.referenceSeq.chromosome"/>
        <xpath value="f:Sequence/f:referenceSeq/f:chromosome"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Sequence-coordinate"/>
    <resource>
      <SearchParameter>
        <id value="Sequence-coordinate"/>
        <url value="http://hl7.org/fhir/SearchParameter/Sequence-coordinate"/>
        <name value="coordinate"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Clinical Genomics)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/clingenomics/index.cfm"/>
          </telecom>
        </contact>
        <code value="coordinate"/>
        <base value="Sequence"/>
        <type value="composite"/>
        <description value="Search parameter for region of the reference DNA sequence string. This will refer to part of a locus or part of a gene where search region will be represented in 1-based system. Since the coordinateSystem can either be 0-based or 1-based, this search query will include the result of both coordinateSystem that contains the equivalent segment of the gene or whole genome sequence. For example, a search for sequence can be represented as `coordinate=1$lt345$gt123`, this means it will search for the Sequence resource on chromosome 1 and with position &gt;123 and &lt;345, where in 1-based system resource, all strings within region 1:124-344 will be revealed, while in 0-based system resource, all strings within region 1:123-344 will be revealed. You may want to check detail about 0-based v.s. 1-based above."/>
        <expression value="Sequence.variant"/>
        <xpathUsage value="normal"/>
        <component>
          <definition>
            <reference value="http://hl7.org/fhir/SearchParameter/Sequence-chromosome"/>
          </definition>
          <expression value="%resource.referenceSeq.chromosome"/>
        </component>
        <component>
          <definition>
            <reference value="http://hl7.org/fhir/SearchParameter/Sequence-start"/>
          </definition>
          <expression value="start"/>
        </component>
        <component>
          <definition>
            <reference value="http://hl7.org/fhir/SearchParameter/Sequence-end"/>
          </definition>
          <expression value="end"/>
        </component>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Sequence-end"/>
    <resource>
      <SearchParameter>
        <id value="Sequence-end"/>
        <url value="http://hl7.org/fhir/SearchParameter/Sequence-end"/>
        <name value="end"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Clinical Genomics)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/clingenomics/index.cfm"/>
          </telecom>
        </contact>
        <code value="end"/>
        <base value="Sequence"/>
        <type value="number"/>
        <description value="End position (0-based exclusive, which menas the acid at this position will not be included, 1-based inclusive, which means the acid at this position will be included) of the reference sequence."/>
        <expression value="Sequence.referenceSeq.windowEnd"/>
        <xpath value="f:Sequence/f:referenceSeq/f:windowEnd"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Sequence-identifier"/>
    <resource>
      <SearchParameter>
        <id value="Sequence-identifier"/>
        <url value="http://hl7.org/fhir/SearchParameter/Sequence-identifier"/>
        <name value="identifier"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Clinical Genomics)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/clingenomics/index.cfm"/>
          </telecom>
        </contact>
        <code value="identifier"/>
        <base value="Sequence"/>
        <type value="token"/>
        <description value="The unique identity for a particular sequence"/>
        <expression value="Sequence.identifier"/>
        <xpath value="f:Sequence/f:identifier"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Sequence-patient"/>
    <resource>
      <SearchParameter>
        <id value="Sequence-patient"/>
        <url value="http://hl7.org/fhir/SearchParameter/Sequence-patient"/>
        <name value="patient"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Clinical Genomics)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/clingenomics/index.cfm"/>
          </telecom>
        </contact>
        <code value="patient"/>
        <base value="Sequence"/>
        <type value="reference"/>
        <description value="The subject that the observation is about"/>
        <expression value="Sequence.patient"/>
        <xpath value="f:Sequence/f:patient"/>
        <xpathUsage value="normal"/>
        <target value="Patient"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Sequence-start"/>
    <resource>
      <SearchParameter>
        <id value="Sequence-start"/>
        <url value="http://hl7.org/fhir/SearchParameter/Sequence-start"/>
        <name value="start"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Clinical Genomics)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/clingenomics/index.cfm"/>
          </telecom>
        </contact>
        <code value="start"/>
        <base value="Sequence"/>
        <type value="number"/>
        <description value="Start position (0-based inclusive, 1-based inclusive, that means the nucleic acid or amino acid at this position will be included) of the reference sequence."/>
        <expression value="Sequence.referenceSeq.windowStart"/>
        <xpath value="f:Sequence/f:referenceSeq/f:windowStart"/>
        <xpathUsage value="normal"/>
      </SearchParameter>
    </resource>
  </entry>
  <entry>
    <fullUrl value="http://hl7.org/fhir/SearchParameter/Sequence-type"/>
    <resource>
      <SearchParameter>
        <id value="Sequence-type"/>
        <url value="http://hl7.org/fhir/SearchParameter/Sequence-type"/>
        <name value="type"/>
        <status value="draft"/>
        <experimental value="false"/>
        <date value="2017-03-21T06:09:53+11:00"/>
        <publisher value="Health Level Seven International (Clinical Genomics)"/>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://hl7.org/fhir"/>
          </telecom>
        </contact>
        <contact>
          <telecom>
            <system value="url"/>
            <value value="http://www.hl7.org/Special/committees/clingenomics/index.cfm"/>
          </telecom>
        </contact>
        <code value="type"/>
        <base value="Sequence"/>
        <type value="token"/>
        <description value="Amino Acid Sequence/ DNA Sequence / RNA Sequence"/>
        <expression value="Sequence.type"/>
        <xpath value="f:Sequence/f:type"/>
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
