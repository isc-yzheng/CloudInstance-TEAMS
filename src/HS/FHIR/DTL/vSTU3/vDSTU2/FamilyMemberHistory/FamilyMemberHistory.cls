/// Transforms vSTU3 FamilyMemberHistory to vDSTU2 FamilyMemberHistory
Class HS.FHIR.DTL.vSTU3.vDSTU2.FamilyMemberHistory.FamilyMemberHistory Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.FamilyMemberHistory, HS.FHIR.DTL.vDSTU2.Model.Resource.FamilyMemberHistory), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.FamilyMemberHistory' targetClass='HS.FHIR.DTL.vDSTU2.Model.Resource.FamilyMemberHistory' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms FamilyMemberHistory (vSTU3) to FamilyMemberHistory (vDSTU2) ]]>
  </annotation>
<if condition='source.ageAge&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Age).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Age.Age' targetObj='tmp' sourceObj='source.ageAge' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.ageQuantity' action='set'  >
<annotation>
<![CDATA[ (approximate) age ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.ageRange&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Range).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Range.Range' targetObj='tmp' sourceObj='source.ageRange' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.ageRange' action='set'  >
<annotation>
<![CDATA[ (approximate) age ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.ageString&apos;=""'> 
<true> 
<assign value='source.ageString' property='target.ageString' action='set' >
<annotation>
<![CDATA[ (approximate) age ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.bornDate&apos;=""'> 
<true> 
<assign value='source.bornDate' property='target.bornDate' action='set' >
<annotation>
<![CDATA[ (approximate) date of birth ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.bornPeriod&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Period).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Period.Period' targetObj='tmp' sourceObj='source.bornPeriod' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.bornPeriod' action='set'  >
<annotation>
<![CDATA[ (approximate) date of birth ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.bornString&apos;=""'> 
<true> 
<assign value='source.bornString' property='target.bornString' action='set' >
<annotation>
<![CDATA[ (approximate) date of birth ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.condition&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.condition()' key='k1' >
<if condition='source.condition.(k1).code&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.condition.(k1).code' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.condition.(j1).code' action='set'  >
<annotation>
<![CDATA[ Condition suffered by relation
 --- Note: The FHIR value set being used is (* condition-code) which means any FHIR2 code may be used; condition-code shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.condition.(k1).note&apos;=""'> 
<true>
<if condition='source.condition.(k1).note.Count()>0'> 
<true> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Annotation).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Annotation.Annotation' targetObj='tmp' sourceObj='source.condition.(k1).note.(1)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.condition.(j1).note' action='set'  >
<annotation>
<![CDATA[ Extra information about condition
 --- FHIR STU3 FamilyMemberHistory:condition[n].note is a *List*, and FHIR DSTU2 FamilyMemberHistory:condition[n].note is *Single*. 
 --- For a list object mapped to a single FHIR object, the mapping table must contain 2 mapping entries for the source list: One maps only the first item from the list to the target object; the other maps the list to a FHIR extension that contains the full list.   ]]>
</annotation>
</assign></true> 
</if>
</true> 
</if> 
</true>
</if>
<if condition='source.condition.(k1).onsetAge&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Age).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Age.Age' targetObj='tmp' sourceObj='source.condition.(k1).onsetAge' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.condition.(j1).onsetQuantity' action='set'  >
<annotation>
<![CDATA[ When condition first manifested ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.condition.(k1).onsetPeriod&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Period).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Period.Period' targetObj='tmp' sourceObj='source.condition.(k1).onsetPeriod' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.condition.(j1).onsetPeriod' action='set'  >
<annotation>
<![CDATA[ When condition first manifested ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.condition.(k1).onsetRange&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Range).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Range.Range' targetObj='tmp' sourceObj='source.condition.(k1).onsetRange' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.condition.(j1).onsetRange' action='set'  >
<annotation>
<![CDATA[ When condition first manifested ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.condition.(k1).onsetString&apos;=""'> 
<true>
<if condition='source.condition.(k1).onsetString&apos;=""'> 
<true> 
<assign value='source.condition.(k1).onsetString' property='target.condition.(j1).onsetString' action='set' >
<annotation>
<![CDATA[ When condition first manifested ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.condition.(k1).outcome&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.condition.(k1).outcome' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.condition.(j1).outcome' action='set'  >
<annotation>
<![CDATA[ deceased | permanent disability | etc.
 --- Note: The FHIR value set being used is (* condition-outcome) which means any FHIR2 code may be used; condition-outcome shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='target.condition.(j1) &apos;= ""'>
<true>
<assign value='j1+1' property='j1' action='set' />
</true>
</if>
</foreach>
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
<if condition='source.date&apos;=""'> 
<true> 
<assign value='source.date' property='target.date' action='set' >
<annotation>
<![CDATA[ When history was captured/updated ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.deceasedAge&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Age).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Age.Age' targetObj='tmp' sourceObj='source.deceasedAge' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.deceasedQuantity' action='set'  >
<annotation>
<![CDATA[ Dead? How old/when? ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.deceasedBoolean&apos;=""'> 
<true> 
<assign value='source.deceasedBoolean' property='target.deceasedBoolean' action='set' >
<annotation>
<![CDATA[ Dead? How old/when? ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.deceasedDate&apos;=""'> 
<true> 
<assign value='source.deceasedDate' property='target.deceasedDate' action='set' >
<annotation>
<![CDATA[ Dead? How old/when? ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.deceasedRange&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Range).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Range.Range' targetObj='tmp' sourceObj='source.deceasedRange' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.deceasedRange' action='set'  >
<annotation>
<![CDATA[ Dead? How old/when? ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.deceasedString&apos;=""'> 
<true> 
<assign value='source.deceasedString' property='target.deceasedString' action='set' >
<annotation>
<![CDATA[ Dead? How old/when? ]]>
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
<if condition='source.gender&apos;=""'> 
<true> 
<assign value='source.gender' property='target.gender' action='set' >
<annotation>
<![CDATA[ male | female | other | unknown
 --- Note: The FHIR value set being used is (administrative-gender) which means administrative-gender is the *Required* FHIR2 ValueSet for codes; you may NOT extend administrative-gender and you may NOT use codes from other ValueSets.    ]]>
</annotation>
</assign></true> 
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
<![CDATA[ External Id(s) for this record ]]>
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
<if condition='source.name&apos;=""'> 
<true> 
<assign value='source.name' property='target.name' action='set' >
<annotation>
<![CDATA[ The family member described ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.note&apos;=""'> 
<true>
<if condition='source.note.Count()>0'> 
<true> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Annotation).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Annotation.Annotation' targetObj='tmp' sourceObj='source.note.(1)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.note' action='set'  >
<annotation>
<![CDATA[ General note about related person
 --- FHIR STU3 FamilyMemberHistory:note is a *List*, and FHIR DSTU2 FamilyMemberHistory:note is *Single*. 
 --- For a list object mapped to a single FHIR object, the mapping table must contain 2 mapping entries for the source list: One maps only the first item from the list to the target object; the other maps the list to a FHIR extension that contains the full list.   ]]>
</annotation>
</assign></true> 
</if>
</true> 
</if> 
</true>
</if>
<if condition='source.patient&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "FamilyMemberHistory:patient", source.patient)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.patient' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.patient' action='set'  >
<annotation>
<![CDATA[ Patient history is about
 --- Patient   ]]>
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
<if condition='source.relationship&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.relationship' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.relationship' action='set'  >
<annotation>
<![CDATA[ Relationship to the subject
 --- Note: The FHIR value set being used is (* v3-FamilyMember) which means any FHIR2 code may be used; v3-FamilyMember shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.status&apos;=""'> 
<true> 
<assign value='source.status' property='target.status' action='set' >
<annotation>
<![CDATA[ partial | completed | entered-in-error | health-unknown
 --- Note: The FHIR value set being used is (history-status) which means history-status is the *Required* FHIR2 ValueSet for codes; you may NOT extend history-status and you may NOT use codes from other ValueSets.    ]]>
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
