/// Transforms vSTU3 Composition to SDA3 HS.SDA3.IllnessHistory
Class HS.FHIR.DTL.vSTU3.SDA3.Composition.IllnessHistory Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.Composition, HS.SDA3.IllnessHistory), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.Composition' targetClass='HS.SDA3.IllnessHistory' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Composition (vSTU3) to HS.SDA3.IllnessHistory (SDA3) ]]>
  </annotation>
<if condition='source.author&apos;=""'> 
<true>
<if condition='source.author.Count()>0'> 
<true> 
<assign value='##class(HS.SDA3.CodeTableDetail.CareProvider).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.author.GetAt(1), .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Clinician' action='set' >
<annotation>
<![CDATA[ 
 --- FHIR STU3 Composition:author is a *List*, and SDA3 HS.SDA3.IllnessHistory:Clinician is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.   ]]>
</annotation>
</assign></true> 
</if> </true> 
</if> 
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.date)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.EnteredOn' action='set' >
<annotation>
<![CDATA[ Date/time updated or entered. For labs ]]>
</annotation>
</assign></true> 
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
 --- SDA3 HS.SDA3.IllnessHistory:EncounterNumber is type %String with a maximum string length of *220*.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.event.Count()>0'> 
<true>
<if condition='source.event.(1).code&apos;=""'> 
<true>
<if condition='source.event.(1).code.Count()>0'> 
<true> 
<assign value='##class(HS.SDA3.CodeTableDetail.PastHistoryCondition).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.event.(1).code.(1), "HS.FHIR.DTL.vSTU3.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.event.(1).code.(1), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Condition' action='set'  >
<annotation>
<![CDATA[ 
 --- FHIR STU3 Composition:event[n].code is a *List*, and SDA3 HS.SDA3.IllnessHistory:Condition is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.
 --- In this case, any FHIR3 code may be used; v3-ActCode shows Example codes, but you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if> 
</true>
</if>
</true>
</if>
<if condition='source.event.Count()>0'> 
<true>
<if condition='source.event.(1).period&apos;=""'> 
<true>
<if condition='source.event.(1).period.end&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.event.(1).period.end)' property='value' action='set' />
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
</true>
</if>
<if condition='source.event.Count()>0'> 
<true>
<if condition='source.event.(1).period&apos;=""'> 
<true>
<if condition='source.event.(1).period.start&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.event.(1).period.start)' property='value' action='set' />
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
</true>
</if>
<if condition='source.section.Count()>0'> 
<true>
<if condition='source.section.(1).text&apos;=""'> 
<true>
<if condition='source.section.(1).text.div&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FromDiv(source.section.(1).text.div)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.NoteText' action='set' /></true> 
</if> 
</true>
</if>
</true>
</if>
</true>
</if>
</transform>
}

}
