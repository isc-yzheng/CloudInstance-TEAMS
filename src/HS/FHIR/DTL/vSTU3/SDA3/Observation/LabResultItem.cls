/// Transforms vSTU3 Observation to SDA3 HS.SDA3.LabResultItem
Class HS.FHIR.DTL.vSTU3.SDA3.Observation.LabResultItem Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.Observation, HS.SDA3.LabResultItem), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.Observation' targetClass='HS.SDA3.LabResultItem' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Observation (vSTU3) to HS.SDA3.LabResultItem (SDA3) ]]>
  </annotation>
<if condition='source.code&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.LabTestItem).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.code, "HS.FHIR.DTL.vSTU3.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.code, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.TestItemCode' action='set'  /></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='source.comment&apos;=""'> 
<true> 
<assign value='source.comment' property='target.Comments' action='set' /></true> 
</if> 

<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.effectiveDateTime)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.ObservationTime' action='set' /></true> 
</if> 
<if condition='source.interpretation&apos;=""'> 
<true>
<if condition='source.interpretation.text&apos;=""'> 
<true>
<if condition='source.interpretation.text&apos;=""'> 
<true> 
<assign value='source.interpretation.text' property='target.ResultInterpretation' action='set' >
<annotation>
<![CDATA[ 
 --- SDA3 HS.SDA3.LabResultItem:ResultInterpretation is type %String with a maximum string length of *100*.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.issued)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.EnteredOn' action='set' >
<annotation>
<![CDATA[ Date/time updated or entered. For labs ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.method&apos;=""'> 
<true>
<assign value='target.ObservationMethods.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.CodeTableDetail.ObservationMethod).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.method, "HS.FHIR.DTL.vSTU3.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.method, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.ObservationMethods' action='set' key='index'  >
<annotation>
<![CDATA[ 
 --- In this case, any FHIR3 code may be used; observation-methods shows Example codes, but you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='source.performer&apos;=""'> 
<true>
<if condition='source.performer.Count()>0'> 
<true> 
<assign value='##class(HS.SDA3.CodeTableDetail.Organization).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.performer.GetAt(1), .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.PerformedAt' action='set' >
<annotation>
<![CDATA[ 
 --- FHIR STU3 Observation:performer is a *List*, and SDA3 HS.SDA3.LabResultItem:PerformedAt is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.   ]]>
</annotation>
</assign></true> 
</if> </true> 
</if> 
</true>
</if>
<if condition='source.referenceRange&apos;=""'> 
<true>
<if condition='source.referenceRange.Count()>0'> 
<true> 
<assign value='##class(HS.FHIR.DTL.Util.FHIR.Handler.ResultItem).ResultNormalRange(source.referenceRange.GetAt(1))' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.ResultNormalRange' action='set' >
<annotation>
<![CDATA[ 
 --- SDA3 HS.SDA3.LabResultItem:ResultNormalRange is type %String with a maximum string length of *220*. 
 --- FHIR STU3 Observation:referenceRange is a *List*, and SDA3 HS.SDA3.LabResultItem:ResultNormalRange is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.   ]]>
</annotation>
</assign></true> 
</if> </true> 
</if> 
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","observation-status","HS.SDA3.LabResultItem:TestItemStatus",source.status)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.TestItemStatus' action='set' >
<annotation>
<![CDATA[ 
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- SDA3 HS.SDA3.LabResultItem:TestItemStatus is type %String with a maximum string length of *100*.    ]]>
</annotation>
</assign></true> 
</if> 
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","observation-status","HS.SDA3.LabResultItem:TestItemStatus",source.status) = ""'> 
<true>
<if condition='source.status&apos;=""'> 
<true> 
<assign value='source.status' property='target.TestItemStatus' action='set' >
<annotation>
<![CDATA[ 
 --- SDA3 HS.SDA3.LabResultItem:TestItemStatus is type %String with a maximum string length of *100*. 
 --- This mapping operates only when a table lookup to match an incoming FHIR code value with an appropriate SDA Code value fails. In that case, this mapping maps the source FHIR code value (unchanged) into an SDA CodeTableDetail Code value, and if the FHIR code was inside a Coding or CodeableConcept, it maps the FHIR display, system, and version values into appropriate SDA CodeTableDetail fields.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.valueCodeableConcept&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.ObservationValueCode).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.valueCodeableConcept, "HS.FHIR.DTL.vSTU3.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.valueCodeableConcept, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.ResultCodedValue' action='set'  /></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='source.valueQuantity&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.FHIR.Handler.Quantity).String(source.valueQuantity)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.ResultValue' action='set' /></true> 
</if> 
</true>
</if>
<if condition='source.valueQuantity&apos;=""'> 
<true>
<if condition='source.valueQuantity.unit&apos;=""'> 
<true>
<if condition='source.valueQuantity.unit&apos;=""'> 
<true> 
<assign value='source.valueQuantity.unit' property='target.ResultValueUnits' action='set' >
<annotation>
<![CDATA[ 
 --- SDA3 HS.SDA3.LabResultItem:ResultValueUnits is type %String with a maximum string length of *30*.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.valueString&apos;=""'> 
<true> 
<assign value='source.valueString' property='target.ResultValue' action='set' /></true> 
</if> 

</transform>
}

}
