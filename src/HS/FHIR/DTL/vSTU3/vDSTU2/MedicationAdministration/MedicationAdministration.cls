/// Transforms vSTU3 MedicationAdministration to vDSTU2 MedicationAdministration
Class HS.FHIR.DTL.vSTU3.vDSTU2.MedicationAdministration.MedicationAdministration Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.MedicationAdministration, HS.FHIR.DTL.vDSTU2.Model.Resource.MedicationAdministration), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.MedicationAdministration' targetClass='HS.FHIR.DTL.vDSTU2.Model.Resource.MedicationAdministration' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms MedicationAdministration (vSTU3) to MedicationAdministration (vDSTU2) ]]>
  </annotation>
<if condition='(((source.effectivePeriod &apos;= "") &amp;&amp; (source.effectivePeriod.end &apos;= "")) || (source.effectiveDateTime &apos;= "") || ((source.effectivePeriod = "") &amp;&amp; (source.effectiveDateTime = ""))) &amp;&amp; (##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","vDSTU2","medication-admin-status","medication-admin-status",source.status) = "")'> 
<true>
<assign value='"completed"' property='target.status' action='set' >
<annotation>
<![CDATA[ in-progress | on-hold | completed | entered-in-error | stopped
 --- This mapping entry assigns a literal value to a target field. A field-to-field mapping to this target field also exists. Be aware that literal value mappings execute first, then field-to-field mappings. The result is that if any field-to-field mapping is non-empty, it will overwrite any literal value mapped to the same target field. If this is not the desired result, the Condition to Set This Field for mappings to this target field must coordinate conditions to ensure that the literal value takes precedence when it should.   ]]>
</annotation>
</assign>
</true>
</if>
<if condition='(source.effectivePeriod &apos;= "") &amp;&amp; (source.effectivePeriod.end = "") &amp;&amp; (##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","vDSTU2","medication-admin-status","medication-admin-status",source.status) = "")'> 
<true>
<assign value='"in-progress"' property='target.status' action='set' >
<annotation>
<![CDATA[ in-progress | on-hold | completed | entered-in-error | stopped
 --- This mapping entry assigns a literal value to a target field. A field-to-field mapping to this target field also exists. Be aware that literal value mappings execute first, then field-to-field mappings. The result is that if any field-to-field mapping is non-empty, it will overwrite any literal value mapped to the same target field. If this is not the desired result, the Condition to Set This Field for mappings to this target field must coordinate conditions to ensure that the literal value takes precedence when it should.   ]]>
</annotation>
</assign>
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
<if condition='source.context&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "MedicationAdministration:encounter", source.context)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.context' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.encounter' action='set'  >
<annotation>
<![CDATA[ Encounter administered as part of
 --- The source and target data types are FHIR Reference. The target Reference does not support all the types that the source Reference supports.   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.device&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "MedicationAdministration:device", source.device)'> 
<true>
<foreach property='source.device()' key='st' >
<assign value='target.device.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.device.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.device' action='set' key='index'  >
<annotation>
<![CDATA[ Device used to administer
 --- Device   ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
<if condition='source.dosage&apos;=""'> 
<true>
<if condition='source.dosage.dose&apos;=""'> 
<true>
<if condition='source.dosage.dose&apos;=""'> 
<true> 
<assign value='source.dosage.dose' property='target.dosage.quantity' action='set' >
<annotation>
<![CDATA[ Amount administered in one dose ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.dosage&apos;=""'> 
<true>
<if condition='source.dosage.method&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.dosage.method' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.dosage.method' action='set'  >
<annotation>
<![CDATA[ How drug was administered ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.dosage&apos;=""'> 
<true>
<if condition='source.dosage.rateRatio&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Ratio).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Ratio.Ratio' targetObj='tmp' sourceObj='source.dosage.rateRatio' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.dosage.rateRatio' action='set'  >
<annotation>
<![CDATA[ Dose quantity per unit of time ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.dosage&apos;=""'> 
<true>
<if condition='source.dosage.route&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.dosage.route' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.dosage.route' action='set'  >
<annotation>
<![CDATA[ Path of substance into body
 --- Note: The FHIR value set being used is (* route-codes) which means any FHIR2 code may be used; route-codes shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.dosage&apos;=""'> 
<true>
<if condition='source.dosage.site&apos;=""'> 
<true>
<if condition='source.dosage.site&apos;=""'> 
<true> 
<assign value='source.dosage.site' property='target.dosage.siteCodeableConcept' action='set' >
<annotation>
<![CDATA[ Body site administered to
 --- Note: The FHIR value set being used is (* approach-site-codes) which means any FHIR2 code may be used; approach-site-codes shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.dosage&apos;=""'> 
<true>
<if condition='source.dosage.text&apos;=""'> 
<true>
<if condition='source.dosage.text&apos;=""'> 
<true> 
<assign value='source.dosage.text' property='target.dosage.text' action='set' >
<annotation>
<![CDATA[ Dosage Instructions ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.effectiveDateTime&apos;=""'> 
<true> 
<assign value='source.effectiveDateTime' property='target.effectiveTimeDateTime' action='set' >
<annotation>
<![CDATA[ Start and end time of administration ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.effectivePeriod&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Period).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Period.Period' targetObj='tmp' sourceObj='source.effectivePeriod' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.effectiveTimePeriod' action='set'  >
<annotation>
<![CDATA[ Start and end time of administration ]]>
</annotation>
</assign></true> 
</if>

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
<![CDATA[ What was administered ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.medicationReference&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "MedicationAdministration:medicationReference", source.medicationReference)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.medicationReference' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.medicationReference' action='set'  >
<annotation>
<![CDATA[ What was administered
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
<![CDATA[ Information about the administration ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.notGiven&apos;=""'> 
<true> 
<assign value='source.notGiven' property='target.wasNotGiven' action='set' >
<annotation>
<![CDATA[ True if medication not administered ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.performer&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.performer()' key='k1' >
<if condition='source.performer.(k1).actor&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "MedicationAdministration:practitioner", source.performer.(k1).actor)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.performer.(k1).actor' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.practitioner' action='set'  >
<annotation>
<![CDATA[ Who administered substance
 --- The source and target data types are FHIR Reference. The target Reference does not support all the types that the source Reference supports.   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.prescription&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "MedicationAdministration:prescription", source.prescription)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.prescription' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.prescription' action='set'  >
<annotation>
<![CDATA[ Order administration performed against
 --- The source and target data types are FHIR Reference. The target Reference does not support all the types that the source Reference supports.   ]]>
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
<if condition='source.reasonNotGiven&apos;=""'> 
<true>
<foreach property='source.reasonNotGiven()' key='st' >
<assign value='target.reasonNotGiven.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.reasonNotGiven.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.reasonNotGiven' action='set' key='index'  >
<annotation>
<![CDATA[ Reason administration not performed
 --- Note: The FHIR value set being used is (* reason-medication-not-given-codes) which means any FHIR2 code may be used; reason-medication-not-given-codes shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","vDSTU2","medication-admin-status","medication-admin-status",source.status)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.status' action='set' >
<annotation>
<![CDATA[ in-progress | on-hold | completed | entered-in-error | stopped
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- The source and target value set names are the same, but the target value set is missing some codes that are in the source value set. 
 --- The target value set is not flexible enough to accept all values. When there is no valid source data, the default value (if supplied) will be assigned to the field. 
 --- Note: The FHIR value set being used is (medication-admin-status) which means medication-admin-status is the *Required* FHIR2 ValueSet for codes; you may NOT extend medication-admin-status and you may NOT use codes from other ValueSets.    ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.subject&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "MedicationAdministration:patient", source.subject)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.subject' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.patient' action='set'  >
<annotation>
<![CDATA[ Who received medication
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
