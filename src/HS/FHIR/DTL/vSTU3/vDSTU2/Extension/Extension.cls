/// Transforms vSTU3 Extension to vDSTU2 Extension
Class HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Base.Extension, HS.FHIR.DTL.vDSTU2.Model.Base.Extension), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Base.Extension' targetClass='HS.FHIR.DTL.vDSTU2.Model.Base.Extension' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Extension (vSTU3) to Extension (vDSTU2) ]]>
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
<if condition='source.url&apos;=""'> 
<true> 
<assign value='source.url' property='target.url' action='set' >
<annotation>
<![CDATA[ identifies the meaning of the extension ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.valueAddress&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Address).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Address.Address' targetObj='tmp' sourceObj='source.valueAddress' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valueAddress' action='set'  >
<annotation>
<![CDATA[ Value of extension ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueAge&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Age).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Age.Age' targetObj='tmp' sourceObj='source.valueAge' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valueAge' action='set'  >
<annotation>
<![CDATA[ Value of extension ]]>
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
<![CDATA[ Value of extension ]]>
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
<![CDATA[ Value of extension ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueBase64Binary&apos;=""'> 
<true> 
<assign value='source.valueBase64Binary' property='target.valueBase64Binary' action='set' >
<annotation>
<![CDATA[ Value of extension ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.valueBoolean&apos;=""'> 
<true> 
<assign value='source.valueBoolean' property='target.valueBoolean' action='set' >
<annotation>
<![CDATA[ Value of extension ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.valueCode&apos;=""'> 
<true> 
<assign value='source.valueCode' property='target.valueCode' action='set' >
<annotation>
<![CDATA[ Value of extension
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
<![CDATA[ Value of extension
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
<![CDATA[ Value of extension
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
<![CDATA[ Value of extension ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueCount&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Count).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Count.Count' targetObj='tmp' sourceObj='source.valueCount' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valueCount' action='set'  >
<annotation>
<![CDATA[ Value of extension ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueDate&apos;=""'> 
<true> 
<assign value='source.valueDate' property='target.valueDate' action='set' >
<annotation>
<![CDATA[ Value of extension ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.valueDateTime&apos;=""'> 
<true> 
<assign value='source.valueDateTime' property='target.valueDateTime' action='set' >
<annotation>
<![CDATA[ Value of extension ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.valueDecimal&apos;=""'> 
<true> 
<assign value='source.valueDecimal' property='target.valueDecimal' action='set' >
<annotation>
<![CDATA[ Value of extension ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.valueDistance&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Distance).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Distance.Distance' targetObj='tmp' sourceObj='source.valueDistance' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valueDistance' action='set'  >
<annotation>
<![CDATA[ Value of extension ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueDuration&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Duration).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Duration.Duration' targetObj='tmp' sourceObj='source.valueDuration' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valueDuration' action='set'  >
<annotation>
<![CDATA[ Value of extension ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueHumanName&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.HumanName).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.HumanName.HumanName' targetObj='tmp' sourceObj='source.valueHumanName' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valueHumanName' action='set'  >
<annotation>
<![CDATA[ Value of extension ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueId&apos;=""'> 
<true> 
<assign value='source.valueId' property='target.valueId' action='set' >
<annotation>
<![CDATA[ Value of extension ]]>
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
<![CDATA[ Value of extension ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueInstant&apos;=""'> 
<true> 
<assign value='source.valueInstant' property='target.valueInstant' action='set' >
<annotation>
<![CDATA[ Value of extension ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.valueInteger&apos;=""'> 
<true> 
<assign value='source.valueInteger' property='target.valueInteger' action='set' >
<annotation>
<![CDATA[ Value of extension ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.valueMarkdown&apos;=""'> 
<true> 
<assign value='source.valueMarkdown' property='target.valueMarkdown' action='set' >
<annotation>
<![CDATA[ Value of extension ]]>
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
<![CDATA[ Value of extension ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueMoney&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Money).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Money.Money' targetObj='tmp' sourceObj='source.valueMoney' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valueMoney' action='set'  >
<annotation>
<![CDATA[ Value of extension ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueOid&apos;=""'> 
<true> 
<assign value='source.valueOid' property='target.valueOid' action='set' >
<annotation>
<![CDATA[ Value of extension ]]>
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
<![CDATA[ Value of extension ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valuePositiveInt&apos;=""'> 
<true> 
<assign value='source.valuePositiveInt' property='target.valuePositiveInt' action='set' >
<annotation>
<![CDATA[ Value of extension ]]>
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
<![CDATA[ Value of extension ]]>
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
<![CDATA[ Value of extension ]]>
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
<![CDATA[ Value of extension ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueReference&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Extension:valueReference", source.valueReference)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.valueReference' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valueReference' action='set'  >
<annotation>
<![CDATA[ Value of extension
 --- Any FHIR3 Resource may be indicated by this Reference   ]]>
</annotation>
</assign></true> 
</if>

</true>
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
<![CDATA[ Value of extension ]]>
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
<![CDATA[ Value of extension ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueString&apos;=""'> 
<true> 
<assign value='source.valueString' property='target.valueString' action='set' >
<annotation>
<![CDATA[ Value of extension ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.valueTime&apos;=""'> 
<true> 
<assign value='source.valueTime' property='target.valueTime' action='set' >
<annotation>
<![CDATA[ Value of extension ]]>
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
<![CDATA[ Value of extension ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.valueUnsignedInt&apos;=""'> 
<true> 
<assign value='source.valueUnsignedInt' property='target.valueUnsignedInt' action='set' >
<annotation>
<![CDATA[ Value of extension ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.valueUri&apos;=""'> 
<true> 
<assign value='source.valueUri' property='target.valueUri' action='set' >
<annotation>
<![CDATA[ Value of extension ]]>
</annotation>
</assign></true> 
</if> 

</transform>
}

}
