/// Transforms SDA3 HS.SDA3.CodeTableTranslated to vSTU3 SimpleQuantity
Class HS.FHIR.DTL.SDA3.vSTU3.CodeTableTranslated.SimpleQuantity Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.CodeTableTranslated, HS.FHIR.DTL.vSTU3.Model.Datatype.SimpleQuantity), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.CodeTableTranslated' targetClass='HS.FHIR.DTL.vSTU3.Model.Datatype.SimpleQuantity' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms HS.SDA3.CodeTableTranslated (SDA3) to SimpleQuantity (vSTU3) ]]>
  </annotation>
<if condition='source.Code&apos;=""'> 
<true> 
<assign value='source.Code' property='target.code' action='set' >
<annotation>
<![CDATA[ Coded form of the unit ]]>
</annotation>
</assign></true> 
</if> 

<if condition='(##class(HS.FHIR.DTL.Util.Lookup).GetURIForCode(source.SDACodingStandard) = "")'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).GetURIForValueSet("vSTU3", "http://unitsofmeasure.org", source.Code)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.system' action='set' >
<annotation>
<![CDATA[ System that defines coded unit form ]]>
</annotation>
</assign></true> 
<false> 
<assign value='"http://www.intersystems.com/fhir/system"' property='target.system' action='set' />
</false> 
</if> 
</true>
</if>
<if condition='source.Description&apos;=""'> 
<true> 
<assign value='source.Description' property='target.unit' action='set' >
<annotation>
<![CDATA[ Unit representation ]]>
</annotation>
</assign></true> 
</if> 

<assign value='##class(HS.FHIR.DTL.Util.Lookup).GetURIForCode(source.SDACodingStandard)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.system' action='set' >
<annotation>
<![CDATA[ System that defines coded unit form ]]>
</annotation>
</assign></true> 
</if> 
<if condition='##class(%Dictionary.ClassDefinition).%ExistsId("HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.CodeTableTranslated.SimpleQuantity")'> 
<true>
<code><![CDATA[  lock +^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.CodeTableTranslated.SimpleQuantity") ]]></code>
<assign value='##class(HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.CodeTableTranslated.SimpleQuantity).Transform(source.Extension, .target, .aux)' property='target' action='set' />
<code><![CDATA[  lock -^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.CodeTableTranslated.SimpleQuantity") ]]></code>
</true>
</if>
</transform>
}

}
