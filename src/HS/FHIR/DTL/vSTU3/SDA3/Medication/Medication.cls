/// Transforms vSTU3 Medication to SDA3 HS.SDA3.Medication
Class HS.FHIR.DTL.vSTU3.SDA3.Medication.Medication Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.Medication, HS.SDA3.Medication), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.Medication' targetClass='HS.SDA3.Medication' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Medication (vSTU3) to HS.SDA3.Medication (SDA3) ]]>
  </annotation>
<if condition='source.code&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.Order).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.code, "HS.FHIR.DTL.vSTU3.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.code, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.OrderItem' action='set'  >
<annotation>
<![CDATA[ 
 --- FHIR STU3 Medication:code is optional, and SDA3 HS.SDA3.Medication:OrderItem is required. No source value is mapped unconditionally to the target and *No Default Value* is supplied in case of no data received. This can be a serious gap. 
 --- This case might be fine, if there exists another mapping to the same target with a non-empty Condition to Set This Field. For example, two mappings could be defined to the same target, each with a Condition to Set This Field, in order to specify mutually exclusive cases. 
 --- In this case, any FHIR3 code may be used; medication-codes shows Example codes, but you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='source.form&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.DosageForm).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.form, "HS.FHIR.DTL.vSTU3.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.form, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.DosageForm' action='set'  >
<annotation>
<![CDATA[ 
 --- In this case, any FHIR3 code may be used; medication-form-codes shows Example codes, but you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
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
