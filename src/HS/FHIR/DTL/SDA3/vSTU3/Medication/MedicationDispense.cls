/// Transforms SDA3 HS.SDA3.Medication to vSTU3 MedicationDispense
Class HS.FHIR.DTL.SDA3.vSTU3.Medication.MedicationDispense Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.Medication, HS.FHIR.DTL.vSTU3.Model.Resource.MedicationDispense), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.Medication' targetClass='HS.FHIR.DTL.vSTU3.Model.Resource.MedicationDispense' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms HS.SDA3.Medication (SDA3) to MedicationDispense (vSTU3) ]]>
  </annotation>
<assign value='target.authorizingPrescription.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Resource.MedicationRequest).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source, "HS.FHIR.DTL.SDA3.vSTU3.Medication.MedicationRequest")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='aux("transformer").AddResource(source, tmp)' property='reference' action='set' />
<if condition='reference&apos;=""'> 
<true>
<assign value='reference' property='target.authorizingPrescription' action='set' key='index'  >
<annotation>
<![CDATA[ Medication order that authorizes the dispense ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true>
</if>

<if condition='(source.DosageSteps.Count() = 0) &amp;&amp; (((&apos;##class(HS.FHIR.DTL.Util.Element.Object).Defined(source,"Frequency")) || (source.Frequency.Code &apos;= "PRN")) &amp;&amp; ((&apos;##class(HS.FHIR.DTL.Util.Element.Object).Defined(source,"Priority")) || (source.Priority.Code &apos;= "PRN")))'> 
<true>
<assign value='"0"' property='target.dosageInstruction.(1).asNeededBoolean' action='set' >
<annotation>
<![CDATA[ Take "as needed" (true or false, or for the reason given). ]]>
</annotation>
</assign>
</true>
</if>
<if condition='(source.DosageSteps.Count() = 0) &amp;&amp; (((##class(HS.FHIR.DTL.Util.Element.Object).Defined(source,"Frequency")) &amp;&amp; (source.Frequency.Code = "PRN")) || ((##class(HS.FHIR.DTL.Util.Element.Object).Defined(source,"Priority")) &amp;&amp; (source.Priority.Code = "PRN")))'> 
<true>
<assign value='"1"' property='target.dosageInstruction.(1).asNeededBoolean' action='set' >
<annotation>
<![CDATA[ Take "as needed" (true or false, or for the reason given). ]]>
</annotation>
</assign>
</true>
</if>
<assign value='aux("transformer").GetPatientReference()' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.subject' action='set' >
<annotation>
<![CDATA[ Who the dispense is for ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.Comments&apos;=""'> 
<true>
<assign value='target.note.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Datatype.Annotation).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Comments, "HS.FHIR.DTL.SubXFrm.SDA3.vSTU3.String.Annotation")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Comments, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.note' action='set' key='index'  >
<annotation>
<![CDATA[ Information about the dispense ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<foreach property='source.DosageSteps()' key='st' >
<assign value='target.dosageInstruction.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Element.Dosage).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.DosageSteps.(st), "HS.FHIR.DTL.SDA3.vSTU3.DosageStep.MedicationDispense.dosageInstruction")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.DosageSteps.(st), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.dosageInstruction' action='set' key='index'  >
<annotation>
<![CDATA[ How the medication is to be used by the patient or administered by the caregiver ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</foreach>
<if condition='source.DoseQuantity&apos;=""'> 
<true>
<if condition='(source.DosageSteps.Count() = 0)'> 
<true>
<if condition='source.DoseQuantity&apos;=""'> 
<true> 
<assign value='source.DoseQuantity' property='target.dosageInstruction.(1).doseQuantity.value' action='set' >
<annotation>
<![CDATA[ Numerical value (with implicit precision) ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.DoseQuantity = ""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "DoseUoM")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Datatype.SimpleQuantity).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.DoseUoM, "HS.FHIR.DTL.SDA3.vSTU3.CodeTableTranslated.SimpleQuantity")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.DoseUoM, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.dosageInstruction.(1).doseQuantity' action='set'  >
<annotation>
<![CDATA[ Amount of medication per dose. ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
</true>
</if>
<if condition='source.DoseQuantity &apos;= ""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "DoseUoM")'> 
<true>
<assign value='target.dosageInstruction.(1).doseQuantity' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.DoseUoM, "HS.FHIR.DTL.SDA3.vSTU3.CodeTableTranslated.SimpleQuantity")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.DoseUoM, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.dosageInstruction.(1).doseQuantity' action='set'  >
<annotation>
<![CDATA[ Amount of medication per dose. ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
</true>
</if>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "DrugProduct")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Resource.Medication).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.DrugProduct, "HS.FHIR.DTL.SDA3.vSTU3.CodeTableDetail.DrugProduct.Medication")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.DrugProduct, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='aux("transformer").AddResource(source.DrugProduct, tmp)' property='reference' action='set' />
<if condition='reference&apos;=""'> 
<true>
<assign value='reference' property='target.medicationReference' action='set'  >
<annotation>
<![CDATA[ What medication was supplied. ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true>
</if>
</true> 
</if>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source.DrugProduct, "Type")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.DrugProduct.Type, "HS.FHIR.DTL.SDA3.vSTU3.CodeTableTranslated.CodeableConcept")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.DrugProduct.Type, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.type' action='set'  >
<annotation>
<![CDATA[ Trial fill, partial fill, emergency fill, etc.
 --- In this case, any FHIR3 code may be used; v3-ActPharmacySupplyType shows Example codes, but you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
<assign value='aux("transformer").GetReference("Encounter",source.EncounterNumber)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.context' action='set' >
<annotation>
<![CDATA[ Encounter / Episode associated with event ]]>
</annotation>
</assign></true> 
</if> 
<assign value='##class(HS.FHIR.DTL.Util.SDA3.Handler.ExternalId).Identifier(source.ExternalId)' property='value' action='set' />
<assign value='target.identifier.Count()+1' property='index' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.identifier' action='set' key='index'  >
<annotation>
<![CDATA[ External identifier ]]>
</annotation>
</assign></true> 
</if> 
<if condition='(source.DosageSteps.Count() = 0)'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "Frequency")'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.SDA3.Handler.Dosage).Frequency(source.Frequency)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.dosageInstruction.(1).timing' action='set' >
<annotation>
<![CDATA[ When medication should be administered ]]>
</annotation>
</assign></true> 
</if> </true> 
</if>
</true>
</if>
<if condition='(source.DosageSteps.Count() = 0)'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "Route")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Route, "HS.FHIR.DTL.SDA3.vSTU3.CodeTableTranslated.CodeableConcept")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Route, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.dosageInstruction.(1).route' action='set'  >
<annotation>
<![CDATA[ How drug should enter body
 --- In this case, any FHIR3 code may be used; route-codes shows Example codes, but you may use codes from any ValueSet. 
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
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("SDA3","vSTU3","HS.SDA3.Medication:Status","medication-dispense-status",source.Status)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.status' action='set' >
<annotation>
<![CDATA[ preparation | in-progress | on-hold | completed | entered-in-error | stopped
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- If the mapping is SDA to FHIR, and the source field contains a non-empty value, then by convention there are two mapping entries for this source field. Both entries execute under the same Condition to Set this Field. One entry does the lookup to retrieve the value to assign to the target field. The other stores the original source field value in a FHIR extension.    ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.Status&apos;=""'> 
<true>
<if condition='(##class(HS.FHIR.DTL.Util.Lookup).Code("SDA3","vSTU3","HS.SDA3.Medication:Status","medication-dispense-status",source.Status) = "")'> 
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Status, "HS.FHIR.DTL.SubXFrm.SDA3.vSTU3.String.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Status, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/medication-status"' property='tmp.url' action='set' />
<assign value='tmp' property='target.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional Content defined by implementations
 --- This mapping supports a related mapping that does a table lookup to match the incoming source value with a value to place in the target field. This mapping has the same Condition to Set this Field as the table lookup. If the lookup successfully finds a value for target field, this mapping stores the original source field value in a FHIR extension.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
</true>
</if>
<if condition='source.TextInstruction&apos;=""'> 
<true>
<if condition='(source.DosageSteps.Count() = 0)'> 
<true>
<if condition='source.TextInstruction&apos;=""'> 
<true> 
<assign value='source.TextInstruction' property='target.dosageInstruction.(1).text' action='set' >
<annotation>
<![CDATA[ Free text dosage instructions e.g. SIG ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='##class(%Dictionary.ClassDefinition).%ExistsId("HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.Medication.MedicationDispense")'> 
<true>
<code><![CDATA[  lock +^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.Medication.MedicationDispense") ]]></code>
<assign value='##class(HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.Medication.MedicationDispense).Transform(source.Extension, .target, .aux)' property='target' action='set' />
<code><![CDATA[  lock -^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.Medication.MedicationDispense") ]]></code>
</true>
</if>
</transform>
}

}
