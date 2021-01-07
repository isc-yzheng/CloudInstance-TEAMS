/// Transforms vSTU3 AllergyIntolerance to vDSTU2 AllergyIntolerance
Class HS.FHIR.DTL.vSTU3.vDSTU2.AllergyIntolerance.AllergyIntolerance Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.AllergyIntolerance, HS.FHIR.DTL.vDSTU2.Model.Resource.AllergyIntolerance), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.AllergyIntolerance' targetClass='HS.FHIR.DTL.vDSTU2.Model.Resource.AllergyIntolerance' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms AllergyIntolerance (vSTU3) to AllergyIntolerance (vDSTU2) ]]>
  </annotation>
<if condition='source.asserter&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "AllergyIntolerance:reporter", source.asserter)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.asserter' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.reporter' action='set'  >
<annotation>
<![CDATA[ Source of the information about the allergy
 --- Patient | RelatedPerson | Practitioner   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.category.Count()>0'> 
<true> 
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","vDSTU2","allergy-intolerance-category","allergy-intolerance-category",source.category.GetAt(1))' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.category' action='set' >
<annotation>
<![CDATA[ food | medication | environment | other - Category of Substance
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- FHIR STU3 AllergyIntolerance:category is a *List*, and FHIR DSTU2 AllergyIntolerance:category is *Single*. 
 --- For a list object mapped to a single FHIR object, the mapping table must contain 2 mapping entries for the source list: One maps only the first item from the list to the target object; the other maps the list to a FHIR extension that contains the full list.
 --- The source and target value set names are the same, but the target value set is missing some codes that are in the source value set. 
 --- The target value set is not flexible enough to accept all values. When there is no valid source data, the default value (if supplied) will be assigned to the field. 
 --- Note: The FHIR value set being used is (allergy-intolerance-category) which means allergy-intolerance-category is the *Required* FHIR2 ValueSet for codes; you may NOT extend allergy-intolerance-category and you may NOT use codes from other ValueSets.    ]]>
</annotation>
</assign></true> 
</if> </true> 
</if> 
<if condition='source.code&apos;=""'> 
<true>
<if condition='source.code&apos;=""'> 
<true> 
<assign value='source.code' property='target.substance' action='set' >
<annotation>
<![CDATA[ Substance, (or class) considered to be responsible for risk ]]>
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
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","vDSTU2","allergy-intolerance-criticality","allergy-intolerance-criticality",source.criticality)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.criticality' action='set' >
<annotation>
<![CDATA[ CRITL | CRITH | CRITU
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- The source and target value set names are the same, but the target value set is missing some codes that are in the source value set. 
 --- The target value set is not flexible enough to accept all values. When there is no valid source data, the default value (if supplied) will be assigned to the field. 
 --- Note: The FHIR value set being used is (allergy-intolerance-criticality) which means allergy-intolerance-criticality is the *Required* FHIR2 ValueSet for codes; you may NOT extend allergy-intolerance-criticality and you may NOT use codes from other ValueSets.    ]]>
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
<![CDATA[ External ids for this item ]]>
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

<if condition='source.lastOccurrence&apos;=""'> 
<true> 
<assign value='source.lastOccurrence' property='target.lastOccurence' action='set' >
<annotation>
<![CDATA[ Date(/time) of last known occurrence of a reaction ]]>
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
<![CDATA[ Additional text not captured in other fields
 --- FHIR STU3 AllergyIntolerance:note is a *List*, and FHIR DSTU2 AllergyIntolerance:note is *Single*. 
 --- For a list object mapped to a single FHIR object, the mapping table must contain 2 mapping entries for the source list: One maps only the first item from the list to the target object; the other maps the list to a FHIR extension that contains the full list.   ]]>
</annotation>
</assign></true> 
</if>
</true> 
</if> 
</true>
</if>
<if condition='source.onsetDateTime&apos;=""'> 
<true> 
<assign value='source.onsetDateTime' property='target.onset' action='set' >
<annotation>
<![CDATA[ Date(/time) when manifestations showed ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.patient&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "AllergyIntolerance:patient", source.patient)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.patient' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.patient' action='set'  >
<annotation>
<![CDATA[ Who the sensitivity is for
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
<if condition='source.reaction&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.reaction()' key='k1' >
<if condition='source.reaction.(k1).description&apos;=""'> 
<true>
<if condition='source.reaction.(k1).description&apos;=""'> 
<true> 
<assign value='source.reaction.(k1).description' property='target.reaction.(j1).description' action='set' >
<annotation>
<![CDATA[ Description of the event as a whole ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.reaction.(k1).exposureRoute&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.reaction.(k1).exposureRoute' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.reaction.(j1).exposureRoute' action='set'  >
<annotation>
<![CDATA[ How the subject was exposed to the substance
 --- Note: The FHIR value set being used is (* route-codes) which means any FHIR2 code may be used; route-codes shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='source.reaction.(k1).manifestation&apos;=""'> 
<true>
<foreach property='source.reaction.(k1).manifestation()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.reaction&apos;="") &amp;&amp; (target.reaction.Count() &gt; 0)'> 
<true> 
<if condition='target.reaction.(j1)&apos;=""'> 
<true> 
<assign value='target.reaction.(j1).manifestation.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.reaction.(k1).manifestation.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.reaction.(j1).manifestation' action='set' key='index'  >
<annotation>
<![CDATA[ Clinical symptoms/signs associated with the Event ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.reaction.(k1).note&apos;=""'> 
<true>
<if condition='source.reaction.(k1).note.Count()>0'> 
<true> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Annotation).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Annotation.Annotation' targetObj='tmp' sourceObj='source.reaction.(k1).note.(1)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.reaction.(j1).note' action='set'  >
<annotation>
<![CDATA[ Text about event not captured in other fields
 --- FHIR STU3 AllergyIntolerance:reaction[n].note is a *List*, and FHIR DSTU2 AllergyIntolerance:reaction[n].note is *Single*. 
 --- For a list object mapped to a single FHIR object, the mapping table must contain 2 mapping entries for the source list: One maps only the first item from the list to the target object; the other maps the list to a FHIR extension that contains the full list.   ]]>
</annotation>
</assign></true> 
</if>
</true> 
</if> 
</true>
</if>
<if condition='source.reaction.(k1).onset&apos;=""'> 
<true>
<if condition='source.reaction.(k1).onset&apos;=""'> 
<true> 
<assign value='source.reaction.(k1).onset' property='target.reaction.(j1).onset' action='set' >
<annotation>
<![CDATA[ Date(/time) when manifestations showed ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.reaction.(k1).severity&apos;=""'> 
<true>
<if condition='source.reaction.(k1).severity&apos;=""'> 
<true> 
<assign value='source.reaction.(k1).severity' property='target.reaction.(j1).severity' action='set' >
<annotation>
<![CDATA[ mild | moderate | severe (of event as a whole)
 --- Note: The FHIR value set being used is (reaction-event-severity) which means reaction-event-severity is the *Required* FHIR2 ValueSet for codes; you may NOT extend reaction-event-severity and you may NOT use codes from other ValueSets.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.reaction.(k1).substance&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.reaction.(k1).substance' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.reaction.(j1).substance' action='set'  >
<annotation>
<![CDATA[ Specific substance considered to be responsible for event
 --- Note: The FHIR value set being used is (* substance-code) which means any FHIR2 code may be used; substance-code shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<if condition='target.reaction.(j1) &apos;= ""'>
<true>
<assign value='j1+1' property='j1' action='set' />
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.recorder&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "AllergyIntolerance:recorder", source.recorder)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.recorder' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.recorder' action='set'  >
<annotation>
<![CDATA[ Who recorded the sensitivity
 --- Practitioner | Patient   ]]>
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
<assign value='source.type' property='target.type' action='set' >
<annotation>
<![CDATA[ allergy | intolerance - Underlying mechanism (if known)
 --- Note: The FHIR value set being used is (allergy-intolerance-type) which means allergy-intolerance-type is the *Required* FHIR2 ValueSet for codes; you may NOT extend allergy-intolerance-type and you may NOT use codes from other ValueSets.    ]]>
</annotation>
</assign></true> 
</if> 

</transform>
}

}
