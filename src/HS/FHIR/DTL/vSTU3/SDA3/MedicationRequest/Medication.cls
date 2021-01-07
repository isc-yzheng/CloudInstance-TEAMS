/// Transforms vSTU3 MedicationRequest to SDA3 HS.SDA3.Medication
Class HS.FHIR.DTL.vSTU3.SDA3.MedicationRequest.Medication Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.MedicationRequest, HS.SDA3.Medication), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.MedicationRequest' targetClass='HS.SDA3.Medication' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms MedicationRequest (vSTU3) to HS.SDA3.Medication (SDA3) ]]>
  </annotation>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.authoredOn)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.EnteredOn' action='set' >
<annotation>
<![CDATA[ Date/time updated or entered. For labs ]]>
</annotation>
</assign></true> 
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
 --- SDA3 HS.SDA3.Medication:EncounterNumber is type %String with a maximum string length of *220*.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.dispenseRequest&apos;=""'> 
<true>
<if condition='source.dispenseRequest.numberOfRepeatsAllowed&apos;=""'> 
<true>
<if condition='source.dispenseRequest.numberOfRepeatsAllowed&apos;=""'> 
<true> 
<assign value='source.dispenseRequest.numberOfRepeatsAllowed' property='target.NumberOfRefills' action='set' >
<annotation>
<![CDATA[ 
 --- FHIR STU3 MedicationRequest:dispenseRequest.numberOfRepeatsAllowed is type positiveInt; this is not a good match for SDA3 HS.SDA3.Medication:NumberOfRefills, which is type %String. 
 --- SDA3 HS.SDA3.Medication:NumberOfRefills is type %String and it has no MAXLEN value set, so its maximum string length is *50*.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.dispenseRequest&apos;=""'> 
<true>
<if condition='source.dispenseRequest.quantity&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.RateUnits).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.dispenseRequest.quantity, "HS.FHIR.DTL.vSTU3.SDA3.Quantity.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.dispenseRequest.quantity, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.RateUnits' action='set'  >
<annotation>
<![CDATA[ Units for Rate (e.g. the ml in 100 ml/hour) ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
</true>
</if>
<if condition='source.dispenseRequest&apos;=""'> 
<true>
<if condition='source.dispenseRequest.quantity&apos;=""'> 
<true>
<if condition='source.dispenseRequest.quantity.value&apos;=""'> 
<true>
<if condition='source.dispenseRequest.quantity.value&apos;=""'> 
<true> 
<assign value='source.dispenseRequest.quantity.value' property='target.OrderQuantity' action='set' >
<annotation>
<![CDATA[ 
 --- FHIR STU3 MedicationRequest:dispenseRequest.quantity.value is type decimal; this is not a good match for SDA3 HS.SDA3.Medication:OrderQuantity, which is type %String. 
 --- SDA3 HS.SDA3.Medication:OrderQuantity is type %String and it has no MAXLEN value set, so its maximum string length is *50*.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
</true>
</if>
<if condition='source.dosageInstruction&apos;=""'> 
<true>
<if condition='target.DosageSteps.Count() = 0'> 
<true>
<foreach property='source.dosageInstruction()' key='st' >
<assign value='target.DosageSteps.Count()+1' property='index' action='set' />
<assign value='##class(HS.SDA3.DosageStep).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.dosageInstruction.(st), "HS.FHIR.DTL.vSTU3.SDA3.Dosage.DosageStep")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.dosageInstruction.(st), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.DosageSteps' action='set' key='index'  /></true> 
</if>
</true>
</if>
</foreach>
</true>
</if>
</true>
</if>
<if condition='source.identifier&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.identifier()' key='k1' >
<if condition='source.identifier.(k1).value&apos;=""'> 
<true>
<if condition='(source.identifier.(k1).type &apos;= "") &amp;&amp; (source.identifier.(k1).type.coding.Count() > 0) &amp;&amp; (source.identifier.(k1).type.coding.(1).code = "PLAC")'> 
<true>
<if condition='source.identifier.(k1).value&apos;=""'> 
<true> 
<assign value='source.identifier.(k1).value' property='target.PlacerId' action='set' >
<annotation>
<![CDATA[ 
 --- SDA3 HS.SDA3.Medication:PlacerId is type %String with a maximum string length of *220*.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.identifier.(k1).value&apos;=""'> 
<true>
<if condition='(source.identifier.(k1).type &apos;= "") &amp;&amp; (source.identifier.(k1).type.coding.Count() > 0) &amp;&amp; (source.identifier.(k1).type.coding.(1).code = "FILL")'> 
<true>
<if condition='source.identifier.(k1).value&apos;=""'> 
<true> 
<assign value='source.identifier.(k1).value' property='target.FillerId' action='set' /></true> 
</if> 

</true>
</if>
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.medicationReference&apos;=""'> 
<true>
<assign value='target' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.medicationReference, .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target' action='set' /></true> 
</if> 
</true>
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
<if condition='source.priority&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","medication-request-priority","HS.SDA3.CodeTableDetail.Priority",source.priority)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Priority.Code' action='set' >
<annotation>
<![CDATA[ The external code, e.g. "M"
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.priority&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","medication-request-priority","HS.SDA3.CodeTableDetail.Priority",source.priority) = ""'> 
<true>
<if condition='source.priority&apos;=""'> 
<true> 
<assign value='source.priority' property='target.Priority.Code' action='set' >
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
<if condition='source.reasonCode.Count()>0'> 
<true>
<if condition='source.reasonCode.(1).text&apos;=""'> 
<true>
<if condition='source.reasonCode.(1).text&apos;=""'> 
<true> 
<assign value='source.reasonCode.(1).text' property='target.Indication' action='set' >
<annotation>
<![CDATA[ 
 --- SDA3 HS.SDA3.Medication:Indication is type %String with a maximum string length of *512*.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.recorder&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.CareProvider).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.recorder, .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.OrderedBy' action='set' /></true> 
</if> 
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","medication-request-status","HS.SDA3.Medication:Status",source.status)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Status' action='set' >
<annotation>
<![CDATA[ 
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping.    ]]>
</annotation>
</assign></true> 
</if> 
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","medication-request-status","HS.SDA3.Medication:Status",source.status) = ""'> 
<true>
<if condition='source.status&apos;=""'> 
<true> 
<assign value='source.status' property='target.Status' action='set' >
<annotation>
<![CDATA[ 
 --- This mapping operates only when a table lookup to match an incoming FHIR code value with an appropriate SDA Code value fails. In that case, this mapping maps the source FHIR code value (unchanged) into an SDA CodeTableDetail Code value, and if the FHIR code was inside a Coding or CodeableConcept, it maps the FHIR display, system, and version values into appropriate SDA CodeTableDetail fields.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</transform>
}

}
