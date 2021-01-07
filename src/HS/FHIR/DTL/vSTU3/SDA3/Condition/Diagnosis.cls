/// Transforms vSTU3 Condition to SDA3 HS.SDA3.Diagnosis
Class HS.FHIR.DTL.vSTU3.SDA3.Condition.Diagnosis Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.Condition, HS.SDA3.Diagnosis), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.Condition' targetClass='HS.SDA3.Diagnosis' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Condition (vSTU3) to HS.SDA3.Diagnosis (SDA3) ]]>
  </annotation>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.abatementDateTime)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.ToTime' action='set' >
<annotation>
<![CDATA[ End of time range ]]>
</annotation>
</assign></true> 
</if> 
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.assertedDate)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.EnteredOn' action='set' >
<annotation>
<![CDATA[ Date/time updated or entered. For labs ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.asserter&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.CareProvider).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.asserter, .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.DiagnosingClinician' action='set' /></true> 
</if> 
</true>
</if>
<if condition='source.category&apos;=""'> 
<true>
<if condition='source.category.Count()>0'> 
<true> 
<assign value='##class(HS.SDA3.CodeTableDetail.DiagnosisType).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.category.(1), "HS.FHIR.DTL.vSTU3.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.category.(1), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.DiagnosisType' action='set'  >
<annotation>
<![CDATA[ The type of diagnosis (e.g. admitting, working, final, discharge)
 --- FHIR STU3 Condition:category is a *List*, and SDA3 HS.SDA3.Diagnosis:DiagnosisType is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.
 --- In this case, any FHIR3 code may be used; condition-category shows Example codes, but you may use codes from any ValueSet. 
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
<if condition='source.clinicalStatus&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","condition-clinical","HS.SDA3.CodeTableDetail.DiagnosisStatus",source.clinicalStatus)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Status.Code' action='set' >
<annotation>
<![CDATA[ The external code, e.g. "M"
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.clinicalStatus&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","condition-clinical","HS.SDA3.CodeTableDetail.DiagnosisStatus",source.clinicalStatus) = ""'> 
<true>
<if condition='source.clinicalStatus&apos;=""'> 
<true> 
<assign value='source.clinicalStatus' property='target.Status.Code' action='set' >
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
<if condition='source.code&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.Diagnosis).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.code, "HS.FHIR.DTL.vSTU3.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.code, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Diagnosis' action='set'  >
<annotation>
<![CDATA[ 
 --- In this case, any FHIR3 code may be used; condition-code shows Example codes, but you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='source.context&apos;=""'> 
<true>
<assign value='""' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.context, .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.EncounterNumber' action='set' >
<annotation>
<![CDATA[ A string that uniquely identifies an Encounter within a patient record.
 --- SDA3 HS.SDA3.Diagnosis:EncounterNumber is type %String with a maximum string length of *220*.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.onsetDateTime)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.OnsetTime' action='set' >
<annotation>
<![CDATA[ When the diagnosed condition began ]]>
</annotation>
</assign></true> 
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
</transform>
}

}
