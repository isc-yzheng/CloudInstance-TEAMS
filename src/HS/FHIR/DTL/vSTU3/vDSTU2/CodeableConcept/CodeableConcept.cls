/// Transforms vSTU3 CodeableConcept to vDSTU2 CodeableConcept
Class HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept, HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept' targetClass='HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms CodeableConcept (vSTU3) to CodeableConcept (vDSTU2) ]]>
  </annotation>
<if condition='source.coding&apos;=""'> 
<true>
<foreach property='source.coding()' key='st' >
<assign value='target.coding.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Coding.Coding' targetObj='tmp' sourceObj='source.coding.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.coding' action='set' key='index'  >
<annotation>
<![CDATA[ Code defined by a terminology system
 --- Note: The FHIR value set being used is (*) which means any FHIR2 code from any ValueSet may be used.    ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
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
<if condition='source.text&apos;=""'> 
<true> 
<assign value='source.text' property='target.text' action='set' >
<annotation>
<![CDATA[ Plain text representation of the concept ]]>
</annotation>
</assign></true> 
</if> 

</transform>
}

}
