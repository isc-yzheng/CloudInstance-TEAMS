/// Transforms vSTU3 MedicationDispense to vDSTU2 MedicationDispense
Class HS.FHIR.DTL.vSTU3.vDSTU2.MedicationDispense.MedicationDispense Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.MedicationDispense, HS.FHIR.DTL.vDSTU2.Model.Resource.MedicationDispense), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.MedicationDispense' targetClass='HS.FHIR.DTL.vDSTU2.Model.Resource.MedicationDispense' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms MedicationDispense (vSTU3) to MedicationDispense (vDSTU2) ]]>
  </annotation>
<if condition='source.authorizingPrescription&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "MedicationDispense:authorizingPrescription", source.authorizingPrescription)'> 
<true>
<foreach property='source.authorizingPrescription()' key='st' >
<assign value='target.authorizingPrescription.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.authorizingPrescription.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.authorizingPrescription' action='set' key='index'  >
<annotation>
<![CDATA[ Medication order that authorizes the dispense
 --- The source and target data types are FHIR Reference. The target Reference does not support all the types that the source Reference supports.   ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
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
<if condition='source.daysSupply&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.SimpleQuantity.SimpleQuantity' targetObj='tmp' sourceObj='source.daysSupply' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.daysSupply' action='set'  >
<annotation>
<![CDATA[ Days Supply ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.destination&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "MedicationDispense:destination", source.destination)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.destination' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.destination' action='set'  >
<annotation>
<![CDATA[ Where the medication was sent
 --- Location   ]]>
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
<![CDATA[ Take "as needed" f(or x) ]]>
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
<![CDATA[ Take "as needed" f(or x) ]]>
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
<![CDATA[ Dosage Instructions ]]>
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
<if condition='source.identifier.Count()>0'> 
<true> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Identifier.Identifier' targetObj='tmp' sourceObj='source.identifier.(1)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.identifier' action='set'  >
<annotation>
<![CDATA[ External identifier
 --- FHIR STU3 MedicationDispense:identifier is a *List*, and FHIR DSTU2 MedicationDispense:identifier is *Single*. 
 --- For a list object mapped to a single FHIR object, the mapping table must contain 2 mapping entries for the source list: One maps only the first item from the list to the target object; the other maps the list to a FHIR extension that contains the full list.   ]]>
</annotation>
</assign></true> 
</if>
</true> 
</if> 
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
<![CDATA[ What medication was supplied ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.medicationReference&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "MedicationDispense:medicationReference", source.medicationReference)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.medicationReference' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.medicationReference' action='set'  >
<annotation>
<![CDATA[ What medication was supplied
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
<![CDATA[ Information about the dispense ]]>
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
<if condition='source.quantity&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.SimpleQuantity.SimpleQuantity' targetObj='tmp' sourceObj='source.quantity' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.quantity' action='set'  >
<annotation>
<![CDATA[ Amount dispensed ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.receiver&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "MedicationDispense:receiver", source.receiver)'> 
<true>
<foreach property='source.receiver()' key='st' >
<assign value='target.receiver.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.receiver.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.receiver' action='set' key='index'  >
<annotation>
<![CDATA[ Who collected the medication
 --- Patient | Practitioner   ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","vDSTU2","medication-dispense-status","medication-dispense-status",source.status)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.status' action='set' >
<annotation>
<![CDATA[ in-progress | on-hold | completed | entered-in-error | stopped
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- The source and target value set names are the same, but the target value set is missing some codes that are in the source value set. 
 --- The target value set is not flexible enough to accept all values. When there is no valid source data, the default value (if supplied) will be assigned to the field. 
 --- Note: The FHIR value set being used is (medication-dispense-status) which means medication-dispense-status is the *Required* FHIR2 ValueSet for codes; you may NOT extend medication-dispense-status and you may NOT use codes from other ValueSets.    ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.subject&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "MedicationDispense:patient", source.subject)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.subject' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.patient' action='set'  >
<annotation>
<![CDATA[ Who the dispense is for
 --- The source and target data types are FHIR Reference. The target Reference does not support all the types that the source Reference supports.   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.substitution&apos;=""'> 
<true>
<if condition='source.substitution.reason&apos;=""'> 
<true>
<foreach property='source.substitution.reason()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='target.substitution&apos;=""'> 
<true> 
<assign value='target.substitution.reason.Count()+1' property='index' action='set' />
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.substitution.reason.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.substitution.reason' action='set' key='index'  >
<annotation>
<![CDATA[ Why was substitution made
 --- Note: The FHIR value set being used is (* v3-SubstanceAdminSubstitutionReason) which means any FHIR2 code may be used; v3-SubstanceAdminSubstitutionReason shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
<if condition='source.substitution&apos;=""'> 
<true>
<if condition='source.substitution.responsibleParty&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "MedicationDispense:substitution.responsibleParty", source.substitution.responsibleParty)'> 
<true>
<foreach property='source.substitution.responsibleParty()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='target.substitution&apos;=""'> 
<true> 
<assign value='target.substitution.responsibleParty.Count()+1' property='index' action='set' />
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.substitution.responsibleParty.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.substitution.responsibleParty' action='set' key='index'  >
<annotation>
<![CDATA[ Who is responsible for the substitution
 --- Practitioner   ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
</true>
</if>
<if condition='source.substitution&apos;=""'> 
<true>
<if condition='source.substitution.type&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.substitution.type' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.substitution.type' action='set'  >
<annotation>
<![CDATA[ Type of substitution
 --- Note: The FHIR value set being used is (* v3-ActSubstanceAdminSubstitutionCode) which means any FHIR2 code may be used; v3-ActSubstanceAdminSubstitutionCode shows Example codes, but you may use codes from any ValueSet.    ]]>
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
<if condition='source.type&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.type' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.type' action='set'  >
<annotation>
<![CDATA[ Trial fill, partial fill, emergency fill, etc.
 --- Note: The FHIR value set being used is (* v3-ActPharmacySupplyType) which means any FHIR2 code may be used; v3-ActPharmacySupplyType shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.whenHandedOver&apos;=""'> 
<true> 
<assign value='source.whenHandedOver' property='target.whenHandedOver' action='set' >
<annotation>
<![CDATA[ When product was given out ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.whenPrepared&apos;=""'> 
<true> 
<assign value='source.whenPrepared' property='target.whenPrepared' action='set' >
<annotation>
<![CDATA[ Dispense processing time ]]>
</annotation>
</assign></true> 
</if> 

</transform>
}

}
