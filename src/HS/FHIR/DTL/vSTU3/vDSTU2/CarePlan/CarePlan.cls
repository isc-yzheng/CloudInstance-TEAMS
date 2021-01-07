/// Transforms vSTU3 CarePlan to vDSTU2 CarePlan
Class HS.FHIR.DTL.vSTU3.vDSTU2.CarePlan.CarePlan Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.CarePlan, HS.FHIR.DTL.vDSTU2.Model.Resource.CarePlan), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.CarePlan' targetClass='HS.FHIR.DTL.vDSTU2.Model.Resource.CarePlan' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms CarePlan (vSTU3) to CarePlan (vDSTU2) ]]>
  </annotation>
<if condition='source.activity&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.activity()' key='k1' >
<if condition='source.activity.(k1).detail&apos;=""'> 
<true>
<if condition='source.activity.(k1).detail.category&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.activity.(k1).detail.category' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.activity.(j1).detail.category' action='set'  >
<annotation>
<![CDATA[ diet | drug | encounter | observation | procedure | supply | other
 --- Note: The FHIR value set being used is (* care-plan-activity-category) which means any FHIR2 code may be used; care-plan-activity-category shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.activity.(k1).detail&apos;=""'> 
<true>
<if condition='source.activity.(k1).detail.code&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.activity.(k1).detail.code' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.activity.(j1).detail.code' action='set'  >
<annotation>
<![CDATA[ Detail type of activity
 --- Note: The FHIR value set being used is (* care-plan-activity) which means any FHIR2 code may be used; care-plan-activity shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.activity.(k1).detail&apos;=""'> 
<true>
<if condition='source.activity.(k1).detail.dailyAmount&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.SimpleQuantity.SimpleQuantity' targetObj='tmp' sourceObj='source.activity.(k1).detail.dailyAmount' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.activity.(j1).detail.dailyAmount' action='set'  >
<annotation>
<![CDATA[ How to consume/day? ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.activity.(k1).detail&apos;=""'> 
<true>
<if condition='source.activity.(k1).detail.description&apos;=""'> 
<true>
<if condition='source.activity.(k1).detail.description&apos;=""'> 
<true> 
<assign value='source.activity.(k1).detail.description' property='target.activity.(j1).detail.description' action='set' >
<annotation>
<![CDATA[ Extra info describing activity to perform ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.activity.(k1).detail&apos;=""'> 
<true>
<if condition='source.activity.(k1).detail.goal&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "CarePlan:activity[n].detail.goal", source.activity.(k1).detail.goal)'> 
<true>
<foreach property='source.activity.(k1).detail.goal()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.activity&apos;="") &amp;&amp; (target.activity.Count() &gt; 0)'> 
<true> 
<if condition='target.activity.(j1).detail&apos;=""'> 
<true> 
<assign value='target.activity.(j1).detail.goal.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.activity.(k1).detail.goal.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.activity.(j1).detail.goal' action='set' key='index'  >
<annotation>
<![CDATA[ Goals this activity relates to
 --- Goal   ]]>
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
<if condition='source.activity.(k1).detail&apos;=""'> 
<true>
<if condition='source.activity.(k1).detail.location&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "CarePlan:activity[n].detail.location", source.activity.(k1).detail.location)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.activity.(k1).detail.location' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.activity.(j1).detail.location' action='set'  >
<annotation>
<![CDATA[ Where it should happen
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
<if condition='source.activity.(k1).detail&apos;=""'> 
<true>
<if condition='source.activity.(k1).detail.performer&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "CarePlan:activity[n].detail.performer", source.activity.(k1).detail.performer)'> 
<true>
<foreach property='source.activity.(k1).detail.performer()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.activity&apos;="") &amp;&amp; (target.activity.Count() &gt; 0)'> 
<true> 
<if condition='target.activity.(j1).detail&apos;=""'> 
<true> 
<assign value='target.activity.(j1).detail.performer.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.activity.(k1).detail.performer.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.activity.(j1).detail.performer' action='set' key='index'  >
<annotation>
<![CDATA[ Who will be responsible?
 --- The source and target data types are FHIR Reference. The target Reference does not support all the types that the source Reference supports.   ]]>
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
<if condition='source.activity.(k1).detail&apos;=""'> 
<true>
<if condition='source.activity.(k1).detail.productCodeableConcept&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.activity.(k1).detail.productCodeableConcept' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.activity.(j1).detail.productCodeableConcept' action='set'  >
<annotation>
<![CDATA[ What is to be administered/supplied
 --- Note: The FHIR value set being used is (* medication-codes) which means any FHIR2 code may be used; medication-codes shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.activity.(k1).detail&apos;=""'> 
<true>
<if condition='source.activity.(k1).detail.productReference&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "CarePlan:activity[n].detail.productReference", source.activity.(k1).detail.productReference)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.activity.(k1).detail.productReference' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.activity.(j1).detail.productReference' action='set'  >
<annotation>
<![CDATA[ What is to be administered/supplied
 --- Medication | Substance   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
</true>
</if>
<if condition='source.activity.(k1).detail &apos;= ""'> 
<true>
<if condition='source.activity.(k1).detail.prohibited&apos;=""'> 
<true> 
<assign value='source.activity.(k1).detail.prohibited' property='target.activity.(j1).detail.prohibited' action='set' >
<annotation>
<![CDATA[ Do NOT do ]]>
</annotation>
</assign></true> 
<false> 
<assign value='"0"' property='target.activity.(j1).detail.prohibited' action='set' />
</false> 
</if> 

</true>
</if>
<if condition='source.activity.(k1).detail&apos;=""'> 
<true>
<if condition='source.activity.(k1).detail.quantity&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.SimpleQuantity).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.SimpleQuantity.SimpleQuantity' targetObj='tmp' sourceObj='source.activity.(k1).detail.quantity' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.activity.(j1).detail.quantity' action='set'  >
<annotation>
<![CDATA[ How much to administer/supply/consume ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.activity.(k1).detail&apos;=""'> 
<true>
<if condition='source.activity.(k1).detail.reasonCode&apos;=""'> 
<true>
<foreach property='source.activity.(k1).detail.reasonCode()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.activity&apos;="") &amp;&amp; (target.activity.Count() &gt; 0)'> 
<true> 
<if condition='target.activity.(j1).detail&apos;=""'> 
<true> 
<assign value='target.activity.(j1).detail.reasonCode.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.activity.(k1).detail.reasonCode.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.activity.(j1).detail.reasonCode' action='set' key='index'  >
<annotation>
<![CDATA[ Why activity should be done
 --- Note: The FHIR value set being used is (* activity-reason) which means any FHIR2 code may be used; activity-reason shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
<if condition='source.activity.(k1).detail&apos;=""'> 
<true>
<if condition='source.activity.(k1).detail.reasonReference&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "CarePlan:activity[n].detail.reasonReference", source.activity.(k1).detail.reasonReference)'> 
<true>
<foreach property='source.activity.(k1).detail.reasonReference()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.activity&apos;="") &amp;&amp; (target.activity.Count() &gt; 0)'> 
<true> 
<if condition='target.activity.(j1).detail&apos;=""'> 
<true> 
<assign value='target.activity.(j1).detail.reasonReference.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.activity.(k1).detail.reasonReference.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.activity.(j1).detail.reasonReference' action='set' key='index'  >
<annotation>
<![CDATA[ Condition triggering need for activity
 --- Condition   ]]>
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
<if condition='source.activity.(k1).detail&apos;=""'> 
<true>
<if condition='source.activity.(k1).detail.scheduledPeriod&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Period).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Period.Period' targetObj='tmp' sourceObj='source.activity.(k1).detail.scheduledPeriod' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.activity.(j1).detail.scheduledPeriod' action='set'  >
<annotation>
<![CDATA[ When activity is to occur ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.activity.(k1).detail&apos;=""'> 
<true>
<if condition='source.activity.(k1).detail.scheduledString&apos;=""'> 
<true>
<if condition='source.activity.(k1).detail.scheduledString&apos;=""'> 
<true> 
<assign value='source.activity.(k1).detail.scheduledString' property='target.activity.(j1).detail.scheduledString' action='set' >
<annotation>
<![CDATA[ When activity is to occur ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.activity.(k1).detail&apos;=""'> 
<true>
<if condition='source.activity.(k1).detail.scheduledTiming&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Timing).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Timing.Timing' targetObj='tmp' sourceObj='source.activity.(k1).detail.scheduledTiming' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.activity.(j1).detail.scheduledTiming' action='set'  >
<annotation>
<![CDATA[ When activity is to occur ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.activity.(k1).detail&apos;=""'> 
<true>
<if condition='source.activity.(k1).detail.status&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","vDSTU2","care-plan-activity-status","care-plan-activity-status",source.activity.(k1).detail.status)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.activity.(j1).detail.status' action='set' >
<annotation>
<![CDATA[ not-started | scheduled | in-progress | on-hold | completed | cancelled
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- The source and target value set names are the same, but the target value set is missing some codes that are in the source value set. 
 --- The target value set is not flexible enough to accept all values. When there is no valid source data, the default value (if supplied) will be assigned to the field. 
 --- Note: The FHIR value set being used is (care-plan-activity-status) which means care-plan-activity-status is the *Required* FHIR2 ValueSet for codes; you may NOT extend care-plan-activity-status and you may NOT use codes from other ValueSets.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
</true>
</if>
<if condition='source.activity.(k1).detail&apos;=""'> 
<true>
<if condition='source.activity.(k1).detail.statusReason&apos;=""'> 
<true>
<if condition='source.activity.(k1).detail.statusReason&apos;=""'> 
<true> 
<assign value='source.activity.(k1).detail.statusReason' property='target.activity.(j1).detail.statusReason.text' action='set' >
<annotation>
<![CDATA[ Plain text representation of the concept ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.activity.(k1).outcomeReference&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "CarePlan:activity[n].actionResulting", source.activity.(k1).outcomeReference)'> 
<true>
<foreach property='source.activity.(k1).outcomeReference()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.activity&apos;="") &amp;&amp; (target.activity.Count() &gt; 0)'> 
<true> 
<if condition='target.activity.(j1)&apos;=""'> 
<true> 
<assign value='target.activity.(j1).actionResulting.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.activity.(k1).outcomeReference.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.activity.(j1).actionResulting' action='set' key='index'  >
<annotation>
<![CDATA[ Appointments, orders, etc.
 --- Any FHIR3 Resource may be indicated by this Reference   ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
<if condition='source.activity.(k1).progress&apos;=""'> 
<true>
<foreach property='source.activity.(k1).progress()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.activity&apos;="") &amp;&amp; (target.activity.Count() &gt; 0)'> 
<true> 
<if condition='target.activity.(j1)&apos;=""'> 
<true> 
<assign value='target.activity.(j1).progress.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Annotation).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Annotation.Annotation' targetObj='tmp' sourceObj='source.activity.(k1).progress.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.activity.(j1).progress' action='set' key='index'  >
<annotation>
<![CDATA[ Comments about the activity status/progress ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.activity.(k1).reference&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "CarePlan:activity[n].reference", source.activity.(k1).reference)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.activity.(k1).reference' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.activity.(j1).reference' action='set'  >
<annotation>
<![CDATA[ Activity details defined in specific resource
 --- The source and target data types are FHIR Reference. The target Reference does not support all the types that the source Reference supports.   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='target.activity.(j1) &apos;= ""'>
<true>
<assign value='j1+1' property='j1' action='set' />
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.addresses&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "CarePlan:addresses", source.addresses)'> 
<true>
<foreach property='source.addresses()' key='st' >
<assign value='target.addresses.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.addresses.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.addresses' action='set' key='index'  >
<annotation>
<![CDATA[ Health issues this plan addresses
 --- Condition   ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
<if condition='source.author&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "CarePlan:author", source.author)'> 
<true>
<foreach property='source.author()' key='st' >
<assign value='target.author.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.author.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.author' action='set' key='index'  >
<annotation>
<![CDATA[ Who is responsible for contents of the plan
 --- The source and target data types are FHIR Reference. The target Reference does not support all the types that the source Reference supports.   ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
<if condition='source.category&apos;=""'> 
<true>
<foreach property='source.category()' key='st' >
<assign value='target.category.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.category.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.category' action='set' key='index'  >
<annotation>
<![CDATA[ Type of plan
 --- Note: The FHIR value set being used is (* care-plan-category) which means any FHIR2 code may be used; care-plan-category shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
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
<if condition='source.context&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "CarePlan:context", source.context)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.context' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.context' action='set'  >
<annotation>
<![CDATA[ Created in context of
 --- Encounter | EpisodeOfCare   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.description&apos;=""'> 
<true> 
<assign value='source.description' property='target.description' action='set' >
<annotation>
<![CDATA[ Summary of nature of plan ]]>
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
<if condition='source.goal&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "CarePlan:goal", source.goal)'> 
<true>
<foreach property='source.goal()' key='st' >
<assign value='target.goal.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.goal.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.goal' action='set' key='index'  >
<annotation>
<![CDATA[ Desired outcome of plan
 --- Goal   ]]>
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
<![CDATA[ External Ids for this plan ]]>
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
<![CDATA[ Comments about the plan
 --- FHIR STU3 CarePlan:note is a *List*, and FHIR DSTU2 CarePlan:note is *Single*. 
 --- For a list object mapped to a single FHIR object, the mapping table must contain 2 mapping entries for the source list: One maps only the first item from the list to the target object; the other maps the list to a FHIR extension that contains the full list.   ]]>
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
<![CDATA[ Time period plan covers ]]>
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
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","vDSTU2","care-plan-status","care-plan-status",source.status)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.status' action='set' >
<annotation>
<![CDATA[ proposed | draft | active | completed | cancelled
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- The source and target value set names are the same, but the target value set is missing some codes that are in the source value set. 
 --- The target value set is not flexible enough to accept all values. When there is no valid source data, the default value (if supplied) will be assigned to the field. 
 --- Note: The FHIR value set being used is (care-plan-status) which means care-plan-status is the *Required* FHIR2 ValueSet for codes; you may NOT extend care-plan-status and you may NOT use codes from other ValueSets.    ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.subject&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "CarePlan:subject", source.subject)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.subject' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.subject' action='set'  >
<annotation>
<![CDATA[ Who care plan is for
 --- Patient | Group   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.supportingInfo&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "CarePlan:support", source.supportingInfo)'> 
<true>
<foreach property='source.supportingInfo()' key='st' >
<assign value='target.support.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.supportingInfo.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.support' action='set' key='index'  >
<annotation>
<![CDATA[ Information considered as part of plan
 --- Any FHIR3 Resource may be indicated by this Reference   ]]>
</annotation>
</assign></true> 
</if>
</foreach>
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
