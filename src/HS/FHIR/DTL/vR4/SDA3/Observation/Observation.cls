/// Transforms vR4 Observation to SDA3 HS.SDA3.Observation
Class HS.FHIR.DTL.vR4.SDA3.Observation.Observation Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Resource.Observation, HS.SDA3.Observation), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.Observation' targetClass='HS.SDA3.Observation' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Observation (vR4) to HS.SDA3.Observation (SDA3) ]]>
  </annotation>
<if condition='source.code&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.Observation).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.code, "HS.FHIR.DTL.vR4.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.code, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.ObservationCode' action='set'  /></true> 
</if>
</true>
</if>

</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.effectiveDateTime)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.ObservationTime' action='set' /></true> 
</if> 
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.effectiveDateTime)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.FromTime' action='set' >
<annotation>
<![CDATA[ Start of time range
 --- The source is optional, but the target is *Required*. When there is no source data to assign to this field, there is no default value, so the FHIR resource fails validation and is not saved. For this field, this is the desired behavior.   ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.effectivePeriod&apos;=""'> 
<true>
<if condition='source.effectivePeriod.end&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.effectivePeriod.end)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.ToTime' action='set' >
<annotation>
<![CDATA[ End of time range ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
</true>
</if>
<if condition='source.effectivePeriod&apos;=""'> 
<true>
<if condition='source.effectivePeriod.start&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.effectivePeriod.start)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.FromTime' action='set' >
<annotation>
<![CDATA[ Start of time range
 --- The source is optional, but the target is *Required*. When there is no source data to assign to this field, there is no default value, so the FHIR resource fails validation and is not saved. For this field, this is the desired behavior.   ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
</true>
</if>
<if condition='source.encounter&apos;=""'> 
<true>
<assign value='""' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.encounter, .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.EncounterNumber' action='set' >
<annotation>
<![CDATA[ A string that uniquely identifies an Encounter within a patient record.
 --- SDA3 HS.SDA3.Observation:EncounterNumber is type %String with a maximum string length of *220*.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.issued)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.ObservationValueTime' action='set' /></true> 
</if> 
<if condition='source.method&apos;=""'> 
<true>
<assign value='target.ObservationMethods.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.CodeTableDetail.ObservationMethod).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.method, "HS.FHIR.DTL.vR4.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.method, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.ObservationMethods' action='set' key='index'  >
<annotation>
<![CDATA[ 
 --- In this case, any FHIR4 code may be used; observation-methods shows Example codes, but you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='source.note.Count()>0'> 
<true>
<if condition='source.note.(1).text&apos;=""'> 
<true>
<if condition='source.note.(1).text&apos;=""'> 
<true> 
<assign value='source.note.(1).text' property='target.Comments' action='set' >
<annotation>
<![CDATA[ 
 --- SDA3 HS.SDA3.Observation:Comments is type %String with a maximum string length of *999*.    ]]>
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
<assign value='##class(HS.SDA3.CodeTableDetail.CareProvider).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.performer.GetAt(1), .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Clinician' action='set' >
<annotation>
<![CDATA[ 
 --- FHIR4 Observation:performer is a *List*, and SDA3 HS.SDA3.Observation:Clinician is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.   ]]>
</annotation>
</assign></true> 
</if> </true> 
</if> 
</true>
</if>
<if condition='source.valueBoolean&apos;=""'> 
<true> 
<assign value='source.valueBoolean' property='target.ObservationValue' action='set' >
<annotation>
<![CDATA[ 
 --- SDA3 HS.SDA3.Observation:ObservationValue is type %String with a maximum string length of *999*.    ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.valueCodeableConcept&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.ObservationValueCode).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.valueCodeableConcept, "HS.FHIR.DTL.vR4.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.valueCodeableConcept, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.ObservationCodedValue' action='set'  /></true> 
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
<assign value='value' property='target.ObservationValue' action='set' >
<annotation>
<![CDATA[ 
 --- SDA3 HS.SDA3.Observation:ObservationValue is type %String with a maximum string length of *999*.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.valueQuantity&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.UoM).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.valueQuantity, "HS.FHIR.DTL.vR4.SDA3.Quantity.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.valueQuantity, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.ObservationCode.ObservationValueUnits' action='set'  /></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='source.valueString&apos;=""'> 
<true> 
<assign value='source.valueString' property='target.ObservationValue' action='set' >
<annotation>
<![CDATA[ 
 --- SDA3 HS.SDA3.Observation:ObservationValue is type %String with a maximum string length of *999*.    ]]>
</annotation>
</assign></true> 
</if> 

</transform>
}

}
