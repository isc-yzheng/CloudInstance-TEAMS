/// Transforms vR4 Medication to SDA3 HS.SDA3.CodeTableDetail.DrugProduct
Class HS.FHIR.DTL.vR4.SDA3.Medication.CodeTableDetail.DrugProduct Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Resource.Medication, HS.SDA3.CodeTableDetail.DrugProduct), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.Medication' targetClass='HS.SDA3.CodeTableDetail.DrugProduct' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Medication (vR4) to HS.SDA3.CodeTableDetail.DrugProduct (SDA3) ]]>
  </annotation>
<if condition='source.code&apos;=""'> 
<true>
<assign value='target' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.code, "HS.FHIR.DTL.vR4.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.code, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target' action='set'  >
<annotation>
<![CDATA[ 
 --- In this case, any FHIR4 code may be used; medication-codes shows Example codes, but you may use codes from any ValueSet. 
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
<assign value='##class(HS.SDA3.CodeTableDetail.DrugProductForm).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.form, "HS.FHIR.DTL.vR4.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.form, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Form' action='set'  >
<annotation>
<![CDATA[ 
 --- In this case, any FHIR4 code may be used; medication-form-codes shows Example codes, but you may use codes from any ValueSet. 
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
