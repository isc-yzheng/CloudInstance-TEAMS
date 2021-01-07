/// Transforms vSTU3 Appointment to vDSTU2 Appointment
Class HS.FHIR.DTL.vSTU3.vDSTU2.Appointment.Appointment Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.Appointment, HS.FHIR.DTL.vDSTU2.Model.Resource.Appointment), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.Appointment' targetClass='HS.FHIR.DTL.vDSTU2.Model.Resource.Appointment' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Appointment (vSTU3) to Appointment (vDSTU2) ]]>
  </annotation>
<if condition='(source.end = "") &amp;&amp; (##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","vDSTU2","appointmentstatus","appointmentstatus",source.status) = "")'> 
<true>
<assign value='"booked"' property='target.status' action='set' >
<annotation>
<![CDATA[ proposed | pending | booked | arrived | fulfilled | cancelled | noshow
 --- This mapping entry assigns a literal value to a target field. A field-to-field mapping to this target field also exists. Be aware that literal value mappings execute first, then field-to-field mappings. The result is that if any field-to-field mapping is non-empty, it will overwrite any literal value mapped to the same target field. If this is not the desired result, the Condition to Set This Field for mappings to this target field must coordinate conditions to ensure that the literal value takes precedence when it should.   ]]>
</annotation>
</assign>
</true>
</if>
<if condition='(source.end &apos;= "") &amp;&amp; (##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","vDSTU2","appointmentstatus","appointmentstatus",source.status) = "")'> 
<true>
<assign value='"fulfilled"' property='target.status' action='set' >
<annotation>
<![CDATA[ proposed | pending | booked | arrived | fulfilled | cancelled | noshow
 --- This mapping entry assigns a literal value to a target field. A field-to-field mapping to this target field also exists. Be aware that literal value mappings execute first, then field-to-field mappings. The result is that if any field-to-field mapping is non-empty, it will overwrite any literal value mapped to the same target field. If this is not the desired result, the Condition to Set This Field for mappings to this target field must coordinate conditions to ensure that the literal value takes precedence when it should.   ]]>
</annotation>
</assign>
</true>
</if>
<if condition='source.comment&apos;=""'> 
<true> 
<assign value='source.comment' property='target.comment' action='set' >
<annotation>
<![CDATA[ Additional comments ]]>
</annotation>
</assign></true> 
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
<if condition='source.description&apos;=""'> 
<true> 
<assign value='source.description' property='target.description' action='set' >
<annotation>
<![CDATA[ Shown on a subject line in a meeting request, or appointment list ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.end&apos;=""'> 
<true> 
<assign value='source.end' property='target.end' action='set' >
<annotation>
<![CDATA[ When appointment is to conclude ]]>
</annotation>
</assign></true> 
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
<![CDATA[ External Ids for this item ]]>
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
<if condition='source.minutesDuration&apos;=""'> 
<true> 
<assign value='source.minutesDuration' property='target.minutesDuration' action='set' >
<annotation>
<![CDATA[ Can be less than start/end (e.g. estimate) ]]>
</annotation>
</assign></true> 
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
<if condition='source.participant&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.participant()' key='k1' >
<if condition='source.participant.(k1).actor&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Appointment:participant[n].actor", source.participant.(k1).actor)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.participant.(k1).actor' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.participant.(j1).actor' action='set'  >
<annotation>
<![CDATA[ Person, Location/HealthcareService or Device
 --- Patient | Practitioner | RelatedPerson | Device | HealthcareService | Location   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.participant.(k1).required&apos;=""'> 
<true>
<if condition='source.participant.(k1).required&apos;=""'> 
<true> 
<assign value='source.participant.(k1).required' property='target.participant.(j1).required' action='set' >
<annotation>
<![CDATA[ required | optional | information-only
 --- Note: The FHIR value set being used is (participantrequired) which means participantrequired is the *Required* FHIR2 ValueSet for codes; you may NOT extend participantrequired and you may NOT use codes from other ValueSets.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.participant.(k1).status&apos;=""'> 
<true>
<if condition='source.participant.(k1).status&apos;=""'> 
<true> 
<assign value='source.participant.(k1).status' property='target.participant.(j1).status' action='set' >
<annotation>
<![CDATA[ accepted | declined | tentative | needs-action
 --- Note: The FHIR value set being used is (participationstatus) which means participationstatus is the *Required* FHIR2 ValueSet for codes; you may NOT extend participationstatus and you may NOT use codes from other ValueSets.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.participant.(k1).type&apos;=""'> 
<true>
<foreach property='source.participant.(k1).type()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.participant&apos;="") &amp;&amp; (target.participant.Count() &gt; 0)'> 
<true> 
<if condition='target.participant.(j1)&apos;=""'> 
<true> 
<assign value='target.participant.(j1).type.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.participant.(k1).type.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.participant.(j1).type' action='set' key='index'  >
<annotation>
<![CDATA[ Role of participant in the appointment ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='target.participant.(j1) &apos;= ""'>
<true>
<assign value='j1+1' property='j1' action='set' />
</true>
</if>
</foreach>
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
<if condition='source.priority&apos;=""'> 
<true> 
<assign value='source.priority' property='target.priority' action='set' >
<annotation>
<![CDATA[ Used to make informed decisions if needing to re-prioritize ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.reason&apos;=""'> 
<true>
<if condition='(source.reason.Count() > 0) &amp;&amp; (source.reason.(1).coding &apos;= "") &amp;&amp; (source.reason.(1).coding.(1).system = "http://hl7.org/fhir/ValueSet/encounter-reason")'> 
<true>
<if condition='source.reason.Count()>0'> 
<true> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.reason.(1)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.reason' action='set'  >
<annotation>
<![CDATA[ Reason this appointment is scheduled
 --- FHIR STU3 Appointment:reason is a *List*, and FHIR DSTU2 Appointment:reason is *Single*. 
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
<if condition='source.serviceType&apos;=""'> 
<true>
<if condition='source.serviceType.Count()>0'> 
<true> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.serviceType.(1)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.type' action='set'  >
<annotation>
<![CDATA[ The type of appointment that is being booked
 --- FHIR STU3 Appointment:serviceType is a *List*, and FHIR DSTU2 Appointment:type is *Single*. 
 --- For a list object mapped to a single FHIR object, the mapping table must contain 2 mapping entries for the source list: One maps only the first item from the list to the target object; the other maps the list to a FHIR extension that contains the full list.   ]]>
</annotation>
</assign></true> 
</if>
</true> 
</if> 
</true>
</if>
<if condition='source.slot&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Appointment:slot", source.slot)'> 
<true>
<foreach property='source.slot()' key='st' >
<assign value='target.slot.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.slot.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.slot' action='set' key='index'  >
<annotation>
<![CDATA[ If provided, then no schedule and start/end values MUST match slot
 --- Slot   ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
<if condition='source.start&apos;=""'> 
<true> 
<assign value='source.start' property='target.start' action='set' >
<annotation>
<![CDATA[ When appointment is to take place ]]>
</annotation>
</assign></true> 
</if> 

<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","vDSTU2","appointmentstatus","appointmentstatus",source.status)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.status' action='set' >
<annotation>
<![CDATA[ proposed | pending | booked | arrived | fulfilled | cancelled | noshow
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- The source and target value set names are the same, but the target value set is missing some codes that are in the source value set. 
 --- The target value set is not flexible enough to accept all values. When there is no valid source data, the default value (if supplied) will be assigned to the field. 
 --- Note: The FHIR value set being used is (appointmentstatus) which means appointmentstatus is the *Required* FHIR2 ValueSet for codes; you may NOT extend appointmentstatus and you may NOT use codes from other ValueSets.    ]]>
</annotation>
</assign></true> 
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
