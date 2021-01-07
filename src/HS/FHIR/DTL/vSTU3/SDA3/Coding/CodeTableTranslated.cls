/// Transforms vSTU3 Coding to SDA3 HS.SDA3.CodeTableTranslated
Class HS.FHIR.DTL.vSTU3.SDA3.Coding.CodeTableTranslated Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Datatype.Coding, HS.SDA3.CodeTableTranslated), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Datatype.Coding' targetClass='HS.SDA3.CodeTableTranslated' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Coding (vSTU3) to HS.SDA3.CodeTableTranslated (SDA3) ]]>
  </annotation>
<if condition='source.code&apos;=""'> 
<true> 
<assign value='source.code' property='target.Code' action='set' >
<annotation>
<![CDATA[ The external code, e.g. "M" ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.display&apos;=""'> 
<true> 
<assign value='source.display' property='target.Description' action='set' >
<annotation>
<![CDATA[ The description, as displayed to the user, e.g. "Male" ]]>
</annotation>
</assign></true> 
</if> 

<assign value='##class(HS.FHIR.DTL.Util.Lookup).GetCodeForURI(source.system)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.SDACodingStandard' action='set' >
<annotation>
<![CDATA[ The coding standard. e.g. "3.2.45.7.34", "LOINC", etc. ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.version&apos;=""'> 
<true> 
<assign value='source.version' property='target.CodeSystemVersionId' action='set' >
<annotation>
<![CDATA[ The coding system version ID, e.g. piece 7 from an HL7v2.5 CNE or CWE ]]>
</annotation>
</assign></true> 
</if> 

</transform>
}

}
