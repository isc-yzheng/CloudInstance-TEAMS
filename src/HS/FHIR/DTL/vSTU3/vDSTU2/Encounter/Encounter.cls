/// Transforms vSTU3 Encounter to vDSTU2 Encounter
Class HS.FHIR.DTL.vSTU3.vDSTU2.Encounter.Encounter Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.Encounter, HS.FHIR.DTL.vDSTU2.Model.Resource.Encounter), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.Encounter' targetClass='HS.FHIR.DTL.vDSTU2.Model.Resource.Encounter' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Encounter (vSTU3) to Encounter (vDSTU2) ]]>
  </annotation>
<if condition='source.appointment&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Encounter:appointment", source.appointment)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.appointment' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.appointment' action='set'  >
<annotation>
<![CDATA[ The appointment that scheduled this encounter
 --- Appointment   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.class&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","vDSTU2","v3-ActEncounterCode","encounter-class",source.class)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.class' action='set' >
<annotation>
<![CDATA[ inpatient | outpatient | ambulatory | emergency +
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- The source and target use different value sets. FHIR STU3 Encounter:class uses value set (v3-ActEncounterCode +) and FHIR DSTU2 Encounter:class uses value set (encounter-class). 
 --- The target value set is not flexible enough to accept all values. When there is no valid source data, the default value (if supplied) will be assigned to the field.    ]]>
</annotation>
</assign></true> 
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
<if condition='source.episodeOfCare&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Encounter:episodeOfCare", source.episodeOfCare)'> 
<true>
<foreach property='source.episodeOfCare()' key='st' >
<assign value='target.episodeOfCare.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.episodeOfCare.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.episodeOfCare' action='set' key='index'  >
<annotation>
<![CDATA[ Episode(s) of care that this encounter should be recorded against
 --- EpisodeOfCare   ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
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
<if condition='source.hospitalization&apos;=""'> 
<true>
<if condition='source.hospitalization.admitSource&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.hospitalization.admitSource' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.hospitalization.admitSource' action='set'  >
<annotation>
<![CDATA[ From where patient was admitted (physician referral, transfer)
 --- Note: The FHIR value set being used is (encounter-admit-source *) which means encounter-admit-source is the Preferred FHIR2 ValueSet for codes, but if you need to express meanings not found in encounter-admit-source, you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.hospitalization&apos;=""'> 
<true>
<if condition='source.hospitalization.destination&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Encounter:hospitalization.destination", source.hospitalization.destination)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.hospitalization.destination' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.hospitalization.destination' action='set'  >
<annotation>
<![CDATA[ Location to which the patient is discharged
 --- Location   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
</true>
</if>
<if condition='source.hospitalization&apos;=""'> 
<true>
<if condition='source.hospitalization.dietPreference&apos;=""'> 
<true>
<foreach property='source.hospitalization.dietPreference()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='target.hospitalization&apos;=""'> 
<true> 
<assign value='target.hospitalization.dietPreference.Count()+1' property='index' action='set' />
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.hospitalization.dietPreference.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.hospitalization.dietPreference' action='set' key='index'  >
<annotation>
<![CDATA[ Diet preferences reported by the patient
 --- Note: The FHIR value set being used is (* encounter-diet) which means any FHIR2 code may be used; encounter-diet shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
<if condition='source.hospitalization&apos;=""'> 
<true>
<if condition='source.hospitalization.dischargeDisposition&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.hospitalization.dischargeDisposition' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.hospitalization.dischargeDisposition' action='set'  >
<annotation>
<![CDATA[ Category or kind of location after discharge ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.hospitalization&apos;=""'> 
<true>
<if condition='source.hospitalization.origin&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Encounter:hospitalization.origin", source.hospitalization.origin)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.hospitalization.origin' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.hospitalization.origin' action='set'  >
<annotation>
<![CDATA[ The location from which the patient came before admission
 --- Location   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
</true>
</if>
<if condition='source.hospitalization&apos;=""'> 
<true>
<if condition='source.hospitalization.preAdmissionIdentifier&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Identifier).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Identifier.Identifier' targetObj='tmp' sourceObj='source.hospitalization.preAdmissionIdentifier' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.hospitalization.preAdmissionIdentifier' action='set'  >
<annotation>
<![CDATA[ Pre-admission identifier ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.hospitalization&apos;=""'> 
<true>
<if condition='source.hospitalization.reAdmission&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.hospitalization.reAdmission' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.hospitalization.reAdmission' action='set'  >
<annotation>
<![CDATA[ The type of hospital re-admission that has occurred (if any). If the value is absent, then this is not identified as a readmission ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.hospitalization&apos;=""'> 
<true>
<if condition='source.hospitalization.specialArrangement&apos;=""'> 
<true>
<foreach property='source.hospitalization.specialArrangement()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='target.hospitalization&apos;=""'> 
<true> 
<assign value='target.hospitalization.specialArrangement.Count()+1' property='index' action='set' />
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.hospitalization.specialArrangement.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.hospitalization.specialArrangement' action='set' key='index'  >
<annotation>
<![CDATA[ Wheelchair, translator, stretcher, etc.
 --- Note: The FHIR value set being used is (encounter-special-arrangements *) which means encounter-special-arrangements is the Preferred FHIR2 ValueSet for codes, but if you need to express meanings not found in encounter-special-arrangements, you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
<if condition='source.hospitalization&apos;=""'> 
<true>
<if condition='source.hospitalization.specialCourtesy&apos;=""'> 
<true>
<foreach property='source.hospitalization.specialCourtesy()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='target.hospitalization&apos;=""'> 
<true> 
<assign value='target.hospitalization.specialCourtesy.Count()+1' property='index' action='set' />
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.hospitalization.specialCourtesy.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.hospitalization.specialCourtesy' action='set' key='index'  >
<annotation>
<![CDATA[ Special courtesies (VIP, board member)
 --- Note: The FHIR value set being used is (encounter-special-courtesy *) which means encounter-special-courtesy is the Preferred FHIR2 ValueSet for codes, but if you need to express meanings not found in encounter-special-courtesy, you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
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
<![CDATA[ Identifier(s) by which this encounter is known ]]>
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

<if condition='source.incomingReferral&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Encounter:incomingReferral", source.incomingReferral)'> 
<true>
<foreach property='source.incomingReferral()' key='st' >
<assign value='target.incomingReferral.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.incomingReferral.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.incomingReferral' action='set' key='index'  >
<annotation>
<![CDATA[ The ReferralRequest that initiated this encounter
 --- ReferralRequest   ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
<if condition='source.language&apos;=""'> 
<true> 
<assign value='source.language' property='target.language' action='set' >
<annotation>
<![CDATA[ Language of the resource content ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.length&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Duration).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Duration.Duration' targetObj='tmp' sourceObj='source.length' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.length' action='set'  >
<annotation>
<![CDATA[ Quantity of time the encounter lasted (less time absent) ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.location&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.location()' key='k1' >
<if condition='source.location.(k1).location&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Encounter:location[n].location", source.location.(k1).location)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.location.(k1).location' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.location.(j1).location' action='set'  >
<annotation>
<![CDATA[ Location the encounter takes place
 --- Location   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.location.(k1).period&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Period).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Period.Period' targetObj='tmp' sourceObj='source.location.(k1).period' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.location.(j1).period' action='set'  >
<annotation>
<![CDATA[ Time period during which the patient was present at the location ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.location.(k1).status&apos;=""'> 
<true>
<if condition='source.location.(k1).status&apos;=""'> 
<true> 
<assign value='source.location.(k1).status' property='target.location.(j1).status' action='set' >
<annotation>
<![CDATA[ planned | active | reserved | completed
 --- Note: The FHIR value set being used is (encounter-location-status) which means encounter-location-status is the *Required* FHIR2 ValueSet for codes; you may NOT extend encounter-location-status and you may NOT use codes from other ValueSets.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='target.location.(j1) &apos;= ""'>
<true>
<assign value='j1+1' property='j1' action='set' />
</true>
</if>
</foreach>
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
<if condition='source.participant&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.participant()' key='k1' >
<if condition='source.participant.(k1).individual&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Encounter:participant[n].individual", source.participant.(k1).individual)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.participant.(k1).individual' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.participant.(j1).individual' action='set'  >
<annotation>
<![CDATA[ Persons involved in the encounter other than the patient
 --- Practitioner | RelatedPerson   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.participant.(k1).period&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Period).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Period.Period' targetObj='tmp' sourceObj='source.participant.(k1).period' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.participant.(j1).period' action='set'  >
<annotation>
<![CDATA[ Period of time during the encounter participant was present ]]>
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
<![CDATA[ Role of participant in encounter
 --- Note: The FHIR value set being used is (encounter-participant-type +) which means encounter-participant-type is the *Required* FHIR2 ValueSet for codes, but if you need to express meanings not found in encounter-participant-type, you may formally *Extend* encounter-participant-type to add codes to it.    ]]>
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
<if condition='source.partOf&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Encounter:partOf", source.partOf)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.partOf' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.partOf' action='set'  >
<annotation>
<![CDATA[ Another Encounter this encounter is part of
 --- Encounter   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.period&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Period).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Period.Period' targetObj='tmp' sourceObj='source.period' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.period' action='set'  >
<annotation>
<![CDATA[ The start and end time of the encounter ]]>
</annotation>
</assign></true> 
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
<if condition='source.priority&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.priority' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.priority' action='set'  >
<annotation>
<![CDATA[ Indicates the urgency of the encounter ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.reason&apos;=""'> 
<true>
<foreach property='source.reason()' key='st' >
<assign value='target.reason.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.reason.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.reason' action='set' key='index'  >
<annotation>
<![CDATA[ Reason the encounter takes place (code) ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.serviceProvider&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Encounter:serviceProvider", source.serviceProvider)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.serviceProvider' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.serviceProvider' action='set'  >
<annotation>
<![CDATA[ The custodian organization of this Encounter record
 --- Organization   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","vDSTU2","encounter-status","encounter-state",source.status)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.status' action='set' >
<annotation>
<![CDATA[ planned | arrived | in-progress | onleave | finished | cancelled
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- The source and target use different value sets. FHIR STU3 Encounter:status uses value set (encounter-status) and FHIR DSTU2 Encounter:status uses value set (encounter-state). 
 --- The target value set is not flexible enough to accept all values. When there is no valid source data, the default value (if supplied) will be assigned to the field. 
 --- The target FHIR DSTU2 Encounter:status is a required field with a required value set, but FHIR STU3 Encounter:status and  FHIR DSTU2 Encounter:status use different value sets. The target FHIR DSTU2 Encounter:status uses value set (encounter-state) and FHIR STU3 Encounter:status uses value set (encounter-status). *No Default Value* is supplied in case of invalid source data. This can be a serious gap.    ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.statusHistory&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.statusHistory()' key='k1' >
<if condition='source.statusHistory.(k1).period&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Period).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Period.Period' targetObj='tmp' sourceObj='source.statusHistory.(k1).period' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.statusHistory.(j1).period' action='set'  >
<annotation>
<![CDATA[ The time that the episode was in the specified status ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.statusHistory.(k1).status&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","vDSTU2","encounter-status","encounter-state",source.statusHistory.(k1).status)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.statusHistory.(j1).status' action='set' >
<annotation>
<![CDATA[ planned | arrived | in-progress | onleave | finished | cancelled
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- The source and target use different value sets. FHIR STU3 Encounter:statusHistory[n].status uses value set (encounter-status) and FHIR DSTU2 Encounter:statusHistory[n].status uses value set (encounter-state). 
 --- The target value set is not flexible enough to accept all values. When there is no valid source data, the default value (if supplied) will be assigned to the field. 
 --- The target FHIR DSTU2 Encounter:statusHistory[n].status is a required field with a required value set, but FHIR STU3 Encounter:statusHistory[n].status and  FHIR DSTU2 Encounter:statusHistory[n].status use different value sets. The target FHIR DSTU2 Encounter:statusHistory[n].status uses value set (encounter-state) and FHIR STU3 Encounter:statusHistory[n].status uses value set (encounter-status). *No Default Value* is supplied in case of invalid source data. This can be a serious gap.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='target.statusHistory.(j1) &apos;= ""'>
<true>
<assign value='j1+1' property='j1' action='set' />
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.subject&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Encounter:patient", source.subject)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.subject' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.patient' action='set'  >
<annotation>
<![CDATA[ The patient present at the encounter
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
<if condition='source.type&apos;=""'> 
<true>
<foreach property='source.type()' key='st' >
<assign value='target.type.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.type.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.type' action='set' key='index'  >
<annotation>
<![CDATA[ Specific type of encounter
 --- Note: The FHIR value set being used is (* encounter-type) which means any FHIR2 code may be used; encounter-type shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</transform>
}

}
