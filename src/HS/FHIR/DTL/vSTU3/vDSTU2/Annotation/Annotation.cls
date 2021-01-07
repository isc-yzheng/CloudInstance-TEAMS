/// Transforms vSTU3 Annotation to vDSTU2 Annotation
Class HS.FHIR.DTL.vSTU3.vDSTU2.Annotation.Annotation Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation, HS.FHIR.DTL.vDSTU2.Model.Datatype.Annotation), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation' targetClass='HS.FHIR.DTL.vDSTU2.Model.Datatype.Annotation' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Annotation (vSTU3) to Annotation (vDSTU2) ]]>
  </annotation>
<if condition='source.authorReference&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Annotation:authorReference", source.authorReference)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.authorReference' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.authorReference' action='set'  >
<annotation>
<![CDATA[ Individual responsible for the Annotation: 
 --- Practitioner | Patient | RelatedPerson   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.authorString&apos;=""'> 
<true> 
<assign value='source.authorString' property='target.authorString' action='set' >
<annotation>
<![CDATA[ Individual responsible for the Annotation:  ]]>
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
<if condition='source.text&apos;=""'> 
<true> 
<assign value='source.text' property='target.text' action='set' >
<annotation>
<![CDATA[ The annotation  - text content ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.time&apos;=""'> 
<true> 
<assign value='source.time' property='target.time' action='set' >
<annotation>
<![CDATA[ When the annotation was made ]]>
</annotation>
</assign></true> 
</if> 

</transform>
}

}
