/// Transforms vSTU3 SimpleQuantity to vDSTU2 SimpleQuantity
Class HS.FHIR.DTL.vSTU3.vDSTU2.SimpleQuantity.SimpleQuantity Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Datatype.SimpleQuantity, HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Datatype.SimpleQuantity' targetClass='HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms SimpleQuantity (vSTU3) to SimpleQuantity (vDSTU2) ]]>
  </annotation>
<if condition='source.code&apos;=""'> 
<true> 
<assign value='source.code' property='target.code' action='set' >
<annotation>
<![CDATA[ Coded form of the unit
 --- Note: The FHIR value set being used is (*) which means any FHIR2 code from any ValueSet may be used.    ]]>
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
<if condition='source.id&apos;=""'> 
<true> 
<assign value='source.id' property='target.id' action='set' >
<annotation>
<![CDATA[ xml:id (or equivalent in JSON) ]]>
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
<if condition='source.system&apos;=""'> 
<true> 
<assign value='source.system' property='target.system' action='set' >
<annotation>
<![CDATA[ System that defines coded unit form ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.unit&apos;=""'> 
<true> 
<assign value='source.unit' property='target.unit' action='set' >
<annotation>
<![CDATA[ Unit representation ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.value&apos;=""'> 
<true> 
<assign value='source.value' property='target.value' action='set' >
<annotation>
<![CDATA[ Numerical value (with implicit precision) ]]>
</annotation>
</assign></true> 
</if> 

</transform>
}

}
