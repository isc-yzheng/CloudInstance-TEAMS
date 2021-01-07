/// Transforms vSTU3 SampledData to vDSTU2 SampledData
Class HS.FHIR.DTL.vSTU3.vDSTU2.SampledData.SampledData Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Datatype.SampledData, HS.FHIR.DTL.vDSTU2.Model.Datatype.SampledData), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Datatype.SampledData' targetClass='HS.FHIR.DTL.vDSTU2.Model.Datatype.SampledData' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms SampledData (vSTU3) to SampledData (vDSTU2) ]]>
  </annotation>
<if condition='source.data&apos;=""'> 
<true> 
<assign value='source.data' property='target.data' action='set' >
<annotation>
<![CDATA[ Decimal values with spaces, or "E" | "U" | "L" ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.dimensions&apos;=""'> 
<true> 
<assign value='source.dimensions' property='target.dimensions' action='set' >
<annotation>
<![CDATA[ Number of sample points at each time point ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.extension&apos;=""'> 
<true>
<foreach property='source.extension()' key='st' >
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.extension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional Content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.factor&apos;=""'> 
<true> 
<assign value='source.factor' property='target.factor' action='set' >
<annotation>
<![CDATA[ Multiply data by this before adding to origin ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.id&apos;=""'> 
<true> 
<assign value='source.id' property='target.id' action='set' >
<annotation>
<![CDATA[ xml:id (or equivalent in JSON) ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.lowerLimit&apos;=""'> 
<true> 
<assign value='source.lowerLimit' property='target.lowerLimit' action='set' >
<annotation>
<![CDATA[ Lower limit of detection ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.origin&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.SimpleQuantity.SimpleQuantity' targetObj='tmp' sourceObj='source.origin' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.origin' action='set'  >
<annotation>
<![CDATA[ Zero value and units ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.period&apos;=""'> 
<true> 
<assign value='source.period' property='target.period' action='set' >
<annotation>
<![CDATA[ Number of milliseconds between samples ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.primitiveExtension&apos;=""'> 
<true>
<foreach property='source.primitiveExtension()' key='st' >
<assign value='target.primitiveExtension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.primitiveExtension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.primitiveExtension' action='set' key='index'  >
<annotation>
<![CDATA[ Generated property, not a FHIR element: Storage space for extensions of any elements that have a primitive data type. ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.upperLimit&apos;=""'> 
<true> 
<assign value='source.upperLimit' property='target.upperLimit' action='set' >
<annotation>
<![CDATA[ Upper limit of detection ]]>
</annotation>
</assign></true> 
</if> 

</transform>
}

}
