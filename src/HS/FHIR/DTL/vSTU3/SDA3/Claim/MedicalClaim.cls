/// Transforms vSTU3 Claim to SDA3 HS.SDA3.MedicalClaim
Class HS.FHIR.DTL.vSTU3.SDA3.Claim.MedicalClaim Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.Claim, HS.SDA3.MedicalClaim), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.Claim' targetClass='HS.SDA3.MedicalClaim' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Claim (vSTU3) to HS.SDA3.MedicalClaim (SDA3) ]]>
  </annotation>
<if condition='source.diagnosis&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.diagnosis()' key='k1' >
<if condition='source.diagnosis.(k1).diagnosisCodeableConcept&apos;=""'> 
<true>
<if condition='source.diagnosis.(k1).sequence = 1'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.Diagnosis).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.diagnosis.(k1).diagnosisCodeableConcept, "HS.FHIR.DTL.vSTU3.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.diagnosis.(k1).diagnosisCodeableConcept, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.PrincipalDiagnosis' action='set'  >
<annotation>
<![CDATA[ 
 --- In this case, any FHIR3 code may be used; icd-10 shows Example codes, but you may use codes from any ValueSet. 
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
<if condition='source.diagnosis.(k1).diagnosisCodeableConcept&apos;=""'> 
<true>
<if condition='source.diagnosis.(k1).sequence &apos;= 1'> 
<true>
<assign value='target.OtherDiagnoses.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.CodeTableDetail.Diagnosis).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.diagnosis.(k1).diagnosisCodeableConcept, "HS.FHIR.DTL.vSTU3.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.diagnosis.(k1).diagnosisCodeableConcept, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.OtherDiagnoses' action='set' key='index'  >
<annotation>
<![CDATA[ 
 --- In this case, any FHIR3 code may be used; icd-10 shows Example codes, but you may use codes from any ValueSet. 
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
</foreach>
</true>
</if>
<if condition='source.hospitalization&apos;=""'> 
<true>
<if condition='source.hospitalization.start&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.hospitalization.start)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.AdmissionDate' action='set' /></true> 
</if> 
</true>
</if>
</true>
</if>
<if condition='source.item&apos;=""'> 
<true>
<foreach property='source.item()' key='st' >
<assign value='target.MedicalClaimLines.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.MedicalClaimLine).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.item.(st), "HS.FHIR.DTL.vSTU3.SDA3.Claim.item.MedicalClaimLine")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.item.(st), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.MedicalClaimLines' action='set' key='index'  /></true> 
</if>
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.organization&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.Organization).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.organization, .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.EnteredAt' action='set' >
<annotation>
<![CDATA[ Source System name ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.procedure&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.procedure()' key='k1' >
<if condition='source.procedure.(k1).procedureCodeableConcept&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.Procedure).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.procedure.(k1).procedureCodeableConcept, "HS.FHIR.DTL.vSTU3.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.procedure.(k1).procedureCodeableConcept, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.MedicalClaimLines.(j1).ProcedureCode' action='set'  >
<annotation>
<![CDATA[ The procedure code reported for this claim line.
 --- In this case, any FHIR3 code may be used; icd-10-procedures shows Example codes, but you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='target.MedicalClaimLines.(j1) &apos;= ""'>
<true>
<assign value='j1+1' property='j1' action='set' />
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.provider&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.CareProvider).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.provider, .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.AttendingProvider' action='set' /></true> 
</if> 
</true>
</if>
<if condition='source.status&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","fm-status","HS.SDA3.CodeTableDetail.ClaimStatus",source.status)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.ClaimStatus.Code' action='set' >
<annotation>
<![CDATA[ The external code, e.g. "M"
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.status&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","fm-status","HS.SDA3.CodeTableDetail.ClaimStatus",source.status) = ""'> 
<true>
<if condition='source.status&apos;=""'> 
<true> 
<assign value='source.status' property='target.ClaimStatus.Code' action='set' >
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
<if condition='source.type&apos;=""'> 
<true>
<if condition='source.type.coding.Count()>0'> 
<true>
<if condition='source.type.coding.(1).code&apos;=""'> 
<true>
<if condition='source.type.coding.(1).code&apos;=""'> 
<true> 
<assign value='source.type.coding.(1).code' property='target.RecordType' action='set' >
<annotation>
<![CDATA[ The APCD filing-type identifier that defines the data contained within the file.
 --- SDA3 HS.SDA3.MedicalClaim:RecordType is type %String and it has no MAXLEN value set, so its maximum string length is *50*.    ]]>
</annotation>
</assign></true> 
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
