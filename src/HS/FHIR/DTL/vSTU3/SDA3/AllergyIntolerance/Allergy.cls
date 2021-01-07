/// Transforms vSTU3 AllergyIntolerance to SDA3 HS.SDA3.Allergy
Class HS.FHIR.DTL.vSTU3.SDA3.AllergyIntolerance.Allergy Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.AllergyIntolerance, HS.SDA3.Allergy), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.AllergyIntolerance' targetClass='HS.SDA3.Allergy' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms AllergyIntolerance (vSTU3) to HS.SDA3.Allergy (SDA3) ]]>
  </annotation>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.assertedDate)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.EnteredOn' action='set' >
<annotation>
<![CDATA[ Date/time updated or entered. For labs ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.category&apos;=""'> 
<true>
<if condition='source.category.Count()>0'> 
<true> 
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","allergy-intolerance-category","HS.SDA3.CodeTableDetail.AllergyCategory",source.category.GetAt(1))' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.AllergyCategory.Code' action='set' >
<annotation>
<![CDATA[ The external code, e.g. "M"
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- FHIR STU3 AllergyIntolerance:category is a *List*, and SDA3 HS.SDA3.Allergy:AllergyCategory.Code is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.   ]]>
</annotation>
</assign></true> 
</if> </true> 
</if> 
</true>
</if>
<if condition='source.category&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","allergy-intolerance-category","HS.SDA3.CodeTableDetail.AllergyCategory",source.category) = ""'> 
<true>
<foreach property='source.category()' key='ls1' >
<if condition='ls1=1' >
<true>
<assign value='source.category.(ls1)' property='target.AllergyCategory.Code' action='set' >
<annotation>
<![CDATA[ The external code, e.g. "M"
 --- FHIR STU3 AllergyIntolerance:category is a *List*, and SDA3 HS.SDA3.Allergy:AllergyCategory.Code is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.
 --- This mapping operates only when a table lookup to match an incoming FHIR code value with an appropriate SDA Code value fails. In that case, this mapping maps the source FHIR code value (unchanged) into an SDA CodeTableDetail Code value, and if the FHIR code was inside a Coding or CodeableConcept, it maps the FHIR display, system, and version values into appropriate SDA CodeTableDetail fields.    ]]>
</annotation>
</assign></true>
<false>
<assign value='target.AllergyCategory.Code _ "; " _ source.category.(ls1)' property='target.AllergyCategory.Code' action='set' />
</false>
</if>
</foreach>
</true>
</if>
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","allergy-clinical-status","HS.SDA3.Allergy:Status",source.clinicalStatus)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Status' action='set' >
<annotation>
<![CDATA[ 
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- SDA3 HS.SDA3.Allergy:Status is type %String and it has no MAXLEN value set, so its maximum string length is *50*.    ]]>
</annotation>
</assign></true> 
</if> 
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","allergy-clinical-status","HS.SDA3.Allergy:Status",source.clinicalStatus) = ""'> 
<true>
<if condition='source.clinicalStatus&apos;=""'> 
<true> 
<assign value='source.clinicalStatus' property='target.Status' action='set' >
<annotation>
<![CDATA[ 
 --- SDA3 HS.SDA3.Allergy:Status is type %String and it has no MAXLEN value set, so its maximum string length is *50*. 
 --- This mapping operates only when a table lookup to match an incoming FHIR code value with an appropriate SDA Code value fails. In that case, this mapping maps the source FHIR code value (unchanged) into an SDA CodeTableDetail Code value, and if the FHIR code was inside a Coding or CodeableConcept, it maps the FHIR display, system, and version values into appropriate SDA CodeTableDetail fields.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.code&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.Allergy).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.code, "HS.FHIR.DTL.vSTU3.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.code, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Allergy' action='set'  >
<annotation>
<![CDATA[ 
 --- FHIR STU3 AllergyIntolerance:code is optional, and SDA3 HS.SDA3.Allergy:Allergy is required. No source value is mapped unconditionally to the target and *No Default Value* is supplied in case of no data received. This can be a serious gap. 
 --- This case might be fine, if there exists another mapping to the same target with a non-empty Condition to Set This Field. For example, two mappings could be defined to the same target, each with a Condition to Set This Field, in order to specify mutually exclusive cases. 
 --- In this case, any FHIR3 code may be used; allergyintolerance-code shows Example codes, but you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.lastOccurrence)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.ToTime' action='set' >
<annotation>
<![CDATA[ End of time range ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.note.Count()>0'> 
<true>
<if condition='source.note.(1).text&apos;=""'> 
<true>
<if condition='source.note.(1).text&apos;=""'> 
<true> 
<assign value='source.note.(1).text' property='target.Comments' action='set' /></true> 
</if> 

</true>
</if>
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.onsetDateTime)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.FromTime' action='set' >
<annotation>
<![CDATA[ Start of time range ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.reaction.Count()>0'> 
<true>
<if condition='source.reaction.(1).manifestation&apos;=""'> 
<true>
<if condition='source.reaction.(1).manifestation.Count()>0'> 
<true> 
<assign value='##class(HS.SDA3.CodeTableDetail.Reaction).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.reaction.(1).manifestation.(1), "HS.FHIR.DTL.vSTU3.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.reaction.(1).manifestation.(1), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Reaction' action='set'  >
<annotation>
<![CDATA[ 
 --- FHIR STU3 AllergyIntolerance:reaction[n].manifestation is a *List*, and SDA3 HS.SDA3.Allergy:Reaction is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.
 --- In this case, any FHIR3 code may be used; clinical-findings shows Example codes, but you may use codes from any ValueSet. 
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
<if condition='source.reaction.Count()>0'> 
<true>
<if condition='source.reaction.(1).severity&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","reaction-event-severity","HS.SDA3.CodeTableDetail.Severity",source.reaction.(1).severity)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Severity.Code' action='set' >
<annotation>
<![CDATA[ The external code, e.g. "M"
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
</true>
</if>
<if condition='source.reaction&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.reaction()' key='k1' >
<if condition='source.reaction.(k1).severity&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","reaction-event-severity","HS.SDA3.CodeTableDetail.Severity",source.reaction.(k1).severity) = ""'> 
<true>
<if condition='source.reaction.(k1).severity&apos;=""'> 
<true> 
<assign value='source.reaction.(k1).severity' property='target.Severity.Code' action='set' >
<annotation>
<![CDATA[ The external code, e.g. "M"
 --- This mapping operates only when a table lookup to match an incoming FHIR code value with an appropriate SDA Code value fails. In that case, this mapping maps the source FHIR code value (unchanged) into an SDA CodeTableDetail Code value, and if the FHIR code was inside a Coding or CodeableConcept, it maps the FHIR display, system, and version values into appropriate SDA CodeTableDetail fields.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.recorder&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.CareProvider).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.recorder, .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Clinician' action='set' /></true> 
</if> 
</true>
</if>
<if condition='source.verificationStatus&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","allergy-verification-status","HS.SDA3.CodeTableDetail.Certainty",source.verificationStatus)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Certainty.Code' action='set' >
<annotation>
<![CDATA[ The external code, e.g. "M"
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.verificationStatus&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","allergy-verification-status","HS.SDA3.CodeTableDetail.Certainty",source.verificationStatus) = ""'> 
<true>
<if condition='source.verificationStatus&apos;=""'> 
<true> 
<assign value='source.verificationStatus' property='target.Certainty.Code' action='set' >
<annotation>
<![CDATA[ The external code, e.g. "M"
 --- This mapping operates only when a table lookup to match an incoming FHIR code value with an appropriate SDA Code value fails. In that case, this mapping maps the source FHIR code value (unchanged) into an SDA CodeTableDetail Code value, and if the FHIR code was inside a Coding or CodeableConcept, it maps the FHIR display, system, and version values into appropriate SDA CodeTableDetail fields.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
</transform>
}

}
