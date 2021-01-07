/// Transforms vSTU3 Parameters:parameter to vDSTU2 Parameters:parameter
Class HS.FHIR.DTL.vSTU3.vDSTU2.Parameters.parameter.Parameters.parameter Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Element.Parameters.parameter, HS.FHIR.DTL.vDSTU2.Model.Element.Parameters.parameter), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Element.Parameters.parameter' targetClass='HS.FHIR.DTL.vDSTU2.Model.Element.Parameters.parameter' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Parameters:parameter (vSTU3) to Parameters:parameter (vDSTU2) ]]>
  </annotation>
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

<if condition='source.modifierExtension&apos;=""'> 
<true>
<foreach property='source.modifierExtension()' key='st' >
<assign value='target.modifierExtension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.modifierExtension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.modifierExtension' action='set' key='index'  >
<annotation>
<![CDATA[ Extensions that cannot be ignored ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.name&apos;=""'> 
<true> 
<assign value='source.name' property='target.name' action='set' >
<annotation>
<![CDATA[ Name from the definition ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.part&apos;=""'> 
<true>
<foreach property='source.part()' key='st' >
<assign value='target.part.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Element.Parameters.parameter).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Parameters.parameter.Parameters.parameter' targetObj='tmp' sourceObj='source.part.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.part' action='set' key='index'  >
<annotation>
<![CDATA[ Named part of a parameter (e.g. Tuple) A part must have a value or a resource, but not both ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
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
<if condition='source.resource&apos;=""'> 
<true>
<if condition='source.resource.id&apos;=""'> 
<true>
<if condition='source.resource.id&apos;=""'> 
<true> 
<assign value='source.resource.id' property='target.resource.id' action='set' >
<annotation>
<![CDATA[ Logical id of this artifact ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.resource&apos;=""'> 
<true>
<if condition='source.resource.implicitRules&apos;=""'> 
<true>
<if condition='source.resource.implicitRules&apos;=""'> 
<true> 
<assign value='source.resource.implicitRules' property='target.resource.implicitRules' action='set' >
<annotation>
<![CDATA[ A set of rules under which this content was created ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.resource&apos;=""'> 
<true>
<if condition='source.resource.language&apos;=""'> 
<true>
<if condition='source.resource.language&apos;=""'> 
<true> 
<assign value='source.resource.language' property='target.resource.language' action='set' >
<annotation>
<![CDATA[ Language of the resource content ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.resource&apos;=""'> 
<true>
<if condition='source.resource.meta&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Meta).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Meta.Meta' targetObj='tmp' sourceObj='source.resource.meta' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.resource.meta' action='set'  >
<annotation>
<![CDATA[ Metadata about the resource ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.resource&apos;=""'> 
<true>
<if condition='source.resource.primitiveExtension&apos;=""'> 
<true>
<foreach property='source.resource.primitiveExtension()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='target.resource&apos;=""'> 
<true> 
<assign value='target.resource.primitiveExtension.Count()+1' property='index' action='set' />
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.resource.primitiveExtension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.resource.primitiveExtension' action='set' key='index'  >
<annotation>
<![CDATA[ Generated property, not a FHIR element: Storage space for extensions of any elements that have a primitive data type. ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
<if condition='source.valueAddress&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Address).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Address.Address' targetObj='tmp' sourceObj='source.valueAddress' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valueAddress' action='set'  >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueAnnotation&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Annotation).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Annotation.Annotation' targetObj='tmp' sourceObj='source.valueAnnotation' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valueAnnotation' action='set'  >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueAttachment&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Attachment).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Attachment.Attachment' targetObj='tmp' sourceObj='source.valueAttachment' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valueAttachment' action='set'  >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueBase64Binary&apos;=""'> 
<true> 
<assign value='source.valueBase64Binary' property='target.valueBase64Binary' action='set' >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.valueBoolean&apos;=""'> 
<true> 
<assign value='source.valueBoolean' property='target.valueBoolean' action='set' >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.valueCode&apos;=""'> 
<true> 
<assign value='source.valueCode' property='target.valueCode' action='set' >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types
 --- Note: The FHIR value set being used is (*) which means any FHIR2 code from any ValueSet may be used.    ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.valueCodeableConcept&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.valueCodeableConcept' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valueCodeableConcept' action='set'  >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types
 --- Note: The FHIR value set being used is (*) which means any FHIR2 code from any ValueSet may be used.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueCoding&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Coding.Coding' targetObj='tmp' sourceObj='source.valueCoding' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valueCoding' action='set'  >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types
 --- Note: The FHIR value set being used is (*) which means any FHIR2 code from any ValueSet may be used.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueContactPoint&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.ContactPoint).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.ContactPoint.ContactPoint' targetObj='tmp' sourceObj='source.valueContactPoint' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valueContactPoint' action='set'  >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueDate&apos;=""'> 
<true> 
<assign value='source.valueDate' property='target.valueDate' action='set' >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.valueDateTime&apos;=""'> 
<true> 
<assign value='source.valueDateTime' property='target.valueDateTime' action='set' >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.valueDecimal&apos;=""'> 
<true> 
<assign value='source.valueDecimal' property='target.valueDecimal' action='set' >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.valueHumanName&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.HumanName).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.HumanName.HumanName' targetObj='tmp' sourceObj='source.valueHumanName' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valueHumanName' action='set'  >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueId&apos;=""'> 
<true> 
<assign value='source.valueId' property='target.valueId' action='set' >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.valueIdentifier&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Identifier.Identifier' targetObj='tmp' sourceObj='source.valueIdentifier' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valueIdentifier' action='set'  >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueInstant&apos;=""'> 
<true> 
<assign value='source.valueInstant' property='target.valueInstant' action='set' >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.valueInteger&apos;=""'> 
<true> 
<assign value='source.valueInteger' property='target.valueInteger' action='set' >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.valueMarkdown&apos;=""'> 
<true> 
<assign value='source.valueMarkdown' property='target.valueMarkdown' action='set' >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.valueMeta&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Meta).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Meta.Meta' targetObj='tmp' sourceObj='source.valueMeta' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valueMeta' action='set'  >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueOid&apos;=""'> 
<true> 
<assign value='source.valueOid' property='target.valueOid' action='set' >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.valuePeriod&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Period).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Period.Period' targetObj='tmp' sourceObj='source.valuePeriod' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valuePeriod' action='set'  >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valuePositiveInt&apos;=""'> 
<true> 
<assign value='source.valuePositiveInt' property='target.valuePositiveInt' action='set' >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.valueQuantity&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Quantity).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Quantity.Quantity' targetObj='tmp' sourceObj='source.valueQuantity' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valueQuantity' action='set'  >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueRange&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Range).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Range.Range' targetObj='tmp' sourceObj='source.valueRange' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valueRange' action='set'  >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueRatio&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Ratio).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Ratio.Ratio' targetObj='tmp' sourceObj='source.valueRatio' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valueRatio' action='set'  >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueReference&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.valueReference' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valueReference' action='set'  >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types
 --- Any FHIR3 Resource may be indicated by this Reference   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueSampledData&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.SampledData).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.SampledData.SampledData' targetObj='tmp' sourceObj='source.valueSampledData' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valueSampledData' action='set'  >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueSignature&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Signature).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Signature.Signature' targetObj='tmp' sourceObj='source.valueSignature' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valueSignature' action='set'  >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueString&apos;=""'> 
<true> 
<assign value='source.valueString' property='target.valueString' action='set' >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.valueTime&apos;=""'> 
<true> 
<assign value='source.valueTime' property='target.valueTime' action='set' >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.valueTiming&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Timing).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Timing.Timing' targetObj='tmp' sourceObj='source.valueTiming' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valueTiming' action='set'  >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueUnsignedInt&apos;=""'> 
<true> 
<assign value='source.valueUnsignedInt' property='target.valueUnsignedInt' action='set' >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.valueUri&apos;=""'> 
<true> 
<assign value='source.valueUri' property='target.valueUri' action='set' >
<annotation>
<![CDATA[ If parameter is a data type. One of these (primitive or complex) data types ]]>
</annotation>
</assign></true> 
</if> 

</transform>
}

}
