/// Transforms SDA3 HS.SDA3.Medication to vR4 Medication
Class HS.FHIR.DTL.SDA3.vR4.Medication.Medication Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.Medication, HS.FHIR.DTL.vR4.Model.Resource.Medication), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.Medication' targetClass='HS.FHIR.DTL.vR4.Model.Resource.Medication' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms HS.SDA3.Medication (SDA3) to Medication (vR4) ]]>
  </annotation>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "DosageForm")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.DosageForm, "HS.FHIR.DTL.SDA3.vR4.CodeTableTranslated.CodeableConcept")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.DosageForm, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.form' action='set'  >
<annotation>
<![CDATA[ powder | tablets | capsule +
 --- In this case, any FHIR4 code may be used; medication-form-codes shows Example codes, but you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "OrderItem")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.OrderItem, "HS.FHIR.DTL.SDA3.vR4.CodeTableTranslated.CodeableConcept")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.OrderItem, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.code' action='set'  >
<annotation>
<![CDATA[ Codes that identify this medication
 --- Although not required according to the HS.SDA3.Medication class definition, in practice, the OrderItem property always contains a value.
 --- In this case, any FHIR4 code may be used; medication-codes shows Example codes, but you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
<if condition='##class(%Dictionary.ClassDefinition).%ExistsId("HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.Medication.Medication")'> 
<true>
<code><![CDATA[  lock +^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.Medication.Medication") ]]></code>
<assign value='##class(HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.Medication.Medication).Transform(source.Extension, .target, .aux)' property='target' action='set' />
<code><![CDATA[  lock -^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.Medication.Medication") ]]></code>
</true>
</if>
</transform>
}

}
