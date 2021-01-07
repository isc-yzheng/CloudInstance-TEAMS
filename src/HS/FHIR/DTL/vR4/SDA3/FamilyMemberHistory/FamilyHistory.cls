/// Transforms vR4 FamilyMemberHistory to SDA3 HS.SDA3.FamilyHistory
Class HS.FHIR.DTL.vR4.SDA3.FamilyMemberHistory.FamilyHistory Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Resource.FamilyMemberHistory, HS.SDA3.FamilyHistory), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.FamilyMemberHistory' targetClass='HS.SDA3.FamilyHistory' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms FamilyMemberHistory (vR4) to HS.SDA3.FamilyHistory (SDA3) ]]>
  </annotation>
<if condition='source.condition.Count()>0'> 
<true>
<if condition='source.condition.(1).code&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.Diagnosis).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.condition.(1).code, "HS.FHIR.DTL.vR4.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.condition.(1).code, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Diagnosis' action='set'  >
<annotation>
<![CDATA[ 
 --- In this case, any FHIR4 code may be used; condition-code shows Example codes, but you may use codes from any ValueSet. 
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
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.date)' property='value' action='set' />
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
<if condition='source.relationship&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.FamilyMember).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.relationship, "HS.FHIR.DTL.vR4.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.relationship, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.FamilyMember' action='set'  >
<annotation>
<![CDATA[ 
 --- In this case, any FHIR4 code may be used; v3-FamilyMember shows Example codes, but you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vR4","SDA3","history-status|4.0.1","HS.SDA3.FamilyHistory:Status",source.status)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Status' action='set' >
<annotation>
<![CDATA[ 
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- SDA3 HS.SDA3.FamilyHistory:Status is type %String and it has no MAXLEN value set, so its maximum string length is *50*.    ]]>
</annotation>
</assign></true> 
</if> 
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Code("vR4","SDA3","history-status|4.0.1","HS.SDA3.FamilyHistory:Status",source.status) = ""'> 
<true>
<if condition='source.status&apos;=""'> 
<true> 
<assign value='source.status' property='target.Status' action='set' >
<annotation>
<![CDATA[ 
 --- SDA3 HS.SDA3.FamilyHistory:Status is type %String and it has no MAXLEN value set, so its maximum string length is *50*. 
 --- This mapping operates only when a table lookup to match an incoming FHIR code value with an appropriate SDA Code value fails. In that case, this mapping maps the source FHIR code value (unchanged) into an SDA CodeTableDetail Code value, and if the FHIR code was inside a Coding or CodeableConcept, it maps the FHIR display, system, and version values into appropriate SDA CodeTableDetail fields.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</transform>
}

}
