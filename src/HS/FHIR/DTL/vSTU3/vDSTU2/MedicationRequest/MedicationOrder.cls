/// Transforms vSTU3 MedicationRequest to vDSTU2 MedicationOrder
Class HS.FHIR.DTL.vSTU3.vDSTU2.MedicationRequest.MedicationOrder Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.MedicationRequest, HS.FHIR.DTL.vDSTU2.Model.Resource.MedicationOrder), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.MedicationRequest' targetClass='HS.FHIR.DTL.vDSTU2.Model.Resource.MedicationOrder' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms MedicationRequest (vSTU3) to MedicationOrder (vDSTU2) ]]>
  </annotation>
<if condition='source.contained&apos;=""'> 
<true>
<foreach property='source.contained()' key='st' >
<assign value='target.contained.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Resource).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.SubXFrm.vSTU3.vDSTU2.Resource.Resource' targetObj='tmp' sourceObj='source.contained.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.contained' action='set' key='index'  >
<annotation>
<![CDATA[ Contained, inline Resources ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.dispenseRequest&apos;=""'> 
<true>
<if condition='source.dispenseRequest.expectedSupplyDuration&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Duration).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Duration.Duration' targetObj='tmp' sourceObj='source.dispenseRequest.expectedSupplyDuration' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.dispenseRequest.expectedSupplyDuration' action='set'  >
<annotation>
<![CDATA[ Number of days supply per dispense ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.dispenseRequest&apos;=""'> 
<true>
<if condition='source.dispenseRequest.numberOfRepeatsAllowed&apos;=""'> 
<true>
<if condition='source.dispenseRequest.numberOfRepeatsAllowed&apos;=""'> 
<true> 
<assign value='source.dispenseRequest.numberOfRepeatsAllowed' property='target.dispenseRequest.numberOfRepeatsAllowed' action='set' >
<annotation>
<![CDATA[ Number of refills authorized ]]>
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
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.SimpleQuantity.SimpleQuantity' targetObj='tmp' sourceObj='source.dispenseRequest.quantity' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.dispenseRequest.quantity' action='set'  >
<annotation>
<![CDATA[ Amount of medication to supply per dispense ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.dispenseRequest&apos;=""'> 
<true>
<if condition='source.dispenseRequest.validityPeriod&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Period).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Period.Period' targetObj='tmp' sourceObj='source.dispenseRequest.validityPeriod' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.dispenseRequest.validityPeriod' action='set'  >
<annotation>
<![CDATA[ Time period supply is authorized for ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.dosageInstruction&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.dosageInstruction()' key='k1' >
<if condition='source.dosageInstruction.(k1).asNeededBoolean&apos;=""'> 
<true>
<if condition='source.dosageInstruction.(k1).asNeededBoolean&apos;=""'> 
<true> 
<assign value='source.dosageInstruction.(k1).asNeededBoolean' property='target.dosageInstruction.(j1).asNeededBoolean' action='set' >
<annotation>
<![CDATA[ Take "as needed" (for x) ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.dosageInstruction.(k1).asNeededCodeableConcept&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.dosageInstruction.(k1).asNeededCodeableConcept' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.dosageInstruction.(j1).asNeededCodeableConcept' action='set'  >
<annotation>
<![CDATA[ Take "as needed" (for x) ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.dosageInstruction.(k1).doseQuantity&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.SimpleQuantity.SimpleQuantity' targetObj='tmp' sourceObj='source.dosageInstruction.(k1).doseQuantity' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.dosageInstruction.(j1).doseQuantity' action='set'  >
<annotation>
<![CDATA[ Amount of medication per dose ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.dosageInstruction.(k1).doseRange&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Range).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Range.Range' targetObj='tmp' sourceObj='source.dosageInstruction.(k1).doseRange' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.dosageInstruction.(j1).doseRange' action='set'  >
<annotation>
<![CDATA[ Amount of medication per dose ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.dosageInstruction.(k1).extension&apos;=""'> 
<true>
<foreach property='source.dosageInstruction.(k1).extension()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.dosageInstruction&apos;="") &amp;&amp; (target.dosageInstruction.Count() &gt; 0)'> 
<true> 
<if condition='target.dosageInstruction.(j1)&apos;=""'> 
<true> 
<assign value='target.dosageInstruction.(j1).extension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.dosageInstruction.(k1).extension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.dosageInstruction.(j1).extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional Content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.dosageInstruction.(k1).id&apos;=""'> 
<true>
<if condition='source.dosageInstruction.(k1).id&apos;=""'> 
<true> 
<assign value='source.dosageInstruction.(k1).id' property='target.dosageInstruction.(j1).id' action='set' >
<annotation>
<![CDATA[ xml:id (or equivalent in JSON) ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.dosageInstruction.(k1).maxDosePerPeriod&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Ratio).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Ratio.Ratio' targetObj='tmp' sourceObj='source.dosageInstruction.(k1).maxDosePerPeriod' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.dosageInstruction.(j1).maxDosePerPeriod' action='set'  >
<annotation>
<![CDATA[ Upper limit on medication per unit of time ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.dosageInstruction.(k1).method&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.dosageInstruction.(k1).method' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.dosageInstruction.(j1).method' action='set'  >
<annotation>
<![CDATA[ Technique for administering medication ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.dosageInstruction.(k1).primitiveExtension&apos;=""'> 
<true>
<foreach property='source.dosageInstruction.(k1).primitiveExtension()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.dosageInstruction&apos;="") &amp;&amp; (target.dosageInstruction.Count() &gt; 0)'> 
<true> 
<if condition='target.dosageInstruction.(j1)&apos;=""'> 
<true> 
<assign value='target.dosageInstruction.(j1).primitiveExtension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.dosageInstruction.(k1).primitiveExtension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.dosageInstruction.(j1).primitiveExtension' action='set' key='index'  >
<annotation>
<![CDATA[ Generated property, not a FHIR element: Storage space for extensions of any elements that have a primitive data type. ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.dosageInstruction.(k1).rateRange&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Range).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Range.Range' targetObj='tmp' sourceObj='source.dosageInstruction.(k1).rateRange' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.dosageInstruction.(j1).rateRange' action='set'  >
<annotation>
<![CDATA[ Amount of medication per unit of time ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.dosageInstruction.(k1).rateRatio&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Ratio).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Ratio.Ratio' targetObj='tmp' sourceObj='source.dosageInstruction.(k1).rateRatio' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.dosageInstruction.(j1).rateRatio' action='set'  >
<annotation>
<![CDATA[ Amount of medication per unit of time ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.dosageInstruction.(k1).route&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.dosageInstruction.(k1).route' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.dosageInstruction.(j1).route' action='set'  >
<annotation>
<![CDATA[ How drug should enter body
 --- Note: The FHIR value set being used is (* route-codes) which means any FHIR2 code may be used; route-codes shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.dosageInstruction.(k1).text&apos;=""'> 
<true>
<if condition='source.dosageInstruction.(k1).text&apos;=""'> 
<true> 
<assign value='source.dosageInstruction.(k1).text' property='target.dosageInstruction.(j1).text' action='set' >
<annotation>
<![CDATA[ Dosage instructions expressed as text ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.dosageInstruction.(k1).timing&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Timing).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Timing.Timing' targetObj='tmp' sourceObj='source.dosageInstruction.(k1).timing' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.dosageInstruction.(j1).timing' action='set'  >
<annotation>
<![CDATA[ When medication should be administered ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='target.dosageInstruction.(j1) &apos;= ""'>
<true>
<assign value='j1+1' property='j1' action='set' />
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.extension&apos;=""'> 
<true>
<foreach property='source.extension()' key='st' >
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.extension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional Content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.id&apos;=""'> 
<true> 
<assign value='source.id' property='target.id' action='set' >
<annotation>
<![CDATA[ Logical id of this artifact ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.identifier&apos;=""'> 
<true>
<foreach property='source.identifier()' key='st' >
<assign value='target.identifier.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Identifier.Identifier' targetObj='tmp' sourceObj='source.identifier.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.identifier' action='set' key='index'  >
<annotation>
<![CDATA[ External identifier ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.implicitRules&apos;=""'> 
<true> 
<assign value='source.implicitRules' property='target.implicitRules' action='set' >
<annotation>
<![CDATA[ A set of rules under which this content was created ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.language&apos;=""'> 
<true> 
<assign value='source.language' property='target.language' action='set' >
<annotation>
<![CDATA[ Language of the resource content ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.medicationCodeableConcept&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.medicationCodeableConcept' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.medicationCodeableConcept' action='set'  >
<annotation>
<![CDATA[ Medication to be taken ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.medicationReference&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "MedicationOrder:medicationReference", source.medicationReference)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.medicationReference' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.medicationReference' action='set'  >
<annotation>
<![CDATA[ Medication to be taken
 --- Medication   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.meta&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Meta).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Meta.Meta' targetObj='tmp' sourceObj='source.meta' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.meta' action='set'  >
<annotation>
<![CDATA[ Metadata about the resource ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.modifierExtension&apos;=""'> 
<true>
<foreach property='source.modifierExtension()' key='st' >
<assign value='target.modifierExtension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.modifierExtension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.modifierExtension' action='set' key='index'  >
<annotation>
<![CDATA[ Extensions that cannot be ignored ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.note.Count()>0'> 
<true>
<if condition='source.note.(1).text&apos;=""'> 
<true>
<if condition='source.note.(1).text&apos;=""'> 
<true> 
<assign value='source.note.(1).text' property='target.note' action='set' >
<annotation>
<![CDATA[ Information about the prescription ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.primitiveExtension&apos;=""'> 
<true>
<foreach property='source.primitiveExtension()' key='st' >
<assign value='target.primitiveExtension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.primitiveExtension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.primitiveExtension' action='set' key='index'  >
<annotation>
<![CDATA[ Generated property, not a FHIR element: Storage space for extensions of any elements that have a primitive data type. ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.priorPrescription&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "MedicationOrder:priorPrescription", source.priorPrescription)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.priorPrescription' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.priorPrescription' action='set'  >
<annotation>
<![CDATA[ An order/prescription that this supersedes
 --- The source and target data types are FHIR Reference. The target Reference does not support all the types that the source Reference supports.   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.reasonReference&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "MedicationOrder:reasonReference", source.reasonReference)'> 
<true>
<if condition='source.reasonReference.Count()>0'> 
<true> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.reasonReference.(1)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.reasonReference' action='set'  >
<annotation>
<![CDATA[ Reason or indication for writing the prescription
 --- The source and target data types are FHIR Reference. The target Reference does not support all the types that the source Reference supports.
 --- FHIR STU3 MedicationRequest:reasonReference is a *List*, and FHIR DSTU2 MedicationOrder:reasonReference is *Single*. 
 --- For a list object mapped to a single FHIR object, the mapping table must contain 2 mapping entries for the source list: One maps only the first item from the list to the target object; the other maps the list to a FHIR extension that contains the full list.   ]]>
</annotation>
</assign></true> 
</if>
</true> 
</if> 
</true>
</if>
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","vDSTU2","medication-request-status","medication-order-status",source.status)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.status' action='set' >
<annotation>
<![CDATA[ active | on-hold | completed | entered-in-error | stopped | draft
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- The source and target use different value sets. FHIR STU3 MedicationRequest:status uses value set (medication-request-status) and FHIR DSTU2 MedicationOrder:status uses value set (medication-order-status). 
 --- The target value set is not flexible enough to accept all values. When there is no valid source data, the default value (if supplied) will be assigned to the field.    ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.subject&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "MedicationOrder:patient", source.subject)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.subject' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.patient' action='set'  >
<annotation>
<![CDATA[ Who prescription is for
 --- The source and target data types are FHIR Reference. The target Reference does not support all the types that the source Reference supports.   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.text&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Narrative).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Narrative.Narrative' targetObj='tmp' sourceObj='source.text' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.text' action='set'  >
<annotation>
<![CDATA[ Text summary of the resource, for human interpretation ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</transform>
}

}
