/// Transforms vR4 Observation to SDA3 HS.SDA3.PhysicalExam
Class HS.FHIR.DTL.vR4.SDA3.Observation.PhysicalExam Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Resource.Observation, HS.SDA3.PhysicalExam), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.Observation' targetClass='HS.SDA3.PhysicalExam' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Observation (vR4) to HS.SDA3.PhysicalExam (SDA3) ]]>
  </annotation>
<if condition='source.code&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.PhysExam).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.code, "HS.FHIR.DTL.vR4.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.code, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.PhysExamCode' action='set'  >
<annotation>
<![CDATA[ 
 --- In this case, any FHIR4 code may be used; observation-codes shows Example codes, but you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.effectiveDateTime)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.PhysExamTime' action='set' /></true> 
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
<![CDATA[ Start of time range ]]>
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
 --- SDA3 HS.SDA3.PhysicalExam:EncounterNumber is type %String with a maximum string length of *220*.    ]]>
</annotation>
</assign></true> 
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
<if condition='source.note.Count()>0'> 
<true>
<if condition='source.note.(1).text&apos;=""'> 
<true>
<if condition='source.note.(1).text&apos;=""'> 
<true> 
<assign value='source.note.(1).text' property='target.NoteText' action='set' /></true> 
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
<assign value='value' property='target.EnteredAt' action='set' >
<annotation>
<![CDATA[ Source System name
 --- FHIR4 Observation:performer is a *List*, and SDA3 HS.SDA3.PhysicalExam:EnteredAt is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.   ]]>
</annotation>
</assign></true> 
</if> </true> 
</if> 
</true>
</if>
<if condition='source.valueCodeableConcept&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.PhysExamObsValue).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.valueCodeableConcept, "HS.FHIR.DTL.vR4.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.valueCodeableConcept, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.PhysExamObsValue' action='set'  /></true> 
</if>
</true>
</if>

</true>
</if>
</transform>
}

}
