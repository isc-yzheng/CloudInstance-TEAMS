/// Transforms vR4 Goal to SDA3 HS.SDA3.Goal
Class HS.FHIR.DTL.vR4.SDA3.Goal.Goal Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Resource.Goal, HS.SDA3.Goal), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.Goal' targetClass='HS.SDA3.Goal' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Goal (vR4) to HS.SDA3.Goal (SDA3) ]]>
  </annotation>
<if condition='source.description&apos;=""'> 
<true>
<if condition='source.description.text&apos;=""'> 
<true>
<if condition='source.description.text&apos;=""'> 
<true> 
<assign value='source.description.text' property='target.Description' action='set' /></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.expressedBy&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.DocumentProvider).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.expressedBy, .value, .aux)' property='value' action='set' />
<assign value='target.Authors.Count()+1' property='index' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Authors' action='set' key='index'  /></true> 
</if> 
</true>
</if>
<assign value='aux("transformer").GetIdentifier("Goal", source.id)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.ExternalId' action='set' >
<annotation>
<![CDATA[ Identifier used by systems outside HealthShare.
 --- SDA3 HS.SDA3.Goal:ExternalId is type %String with a maximum string length of *220*.    ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.lifecycleStatus&apos;=""'> 
<true>
<if condition='source.lifecycleStatus&apos;=""'> 
<true> 
<assign value='source.lifecycleStatus' property='target.Status.Code' action='set' >
<annotation>
<![CDATA[ The external code, e.g. "M" ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.priority&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.Priority).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.priority, "HS.FHIR.DTL.vR4.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.priority, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Priority' action='set'  >
<annotation>
<![CDATA[ 
 --- In this case, goal-priority is the Preferred FHIR4 ValueSet for codes, but if you need to express meanings not found in goal-priority, you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.startDate)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.FromTime' action='set' >
<annotation>
<![CDATA[ Start of time range ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.target&apos;=""'> 
<true>
<if condition='source.target.Count()>0'> 
<true> 
<assign value='##class(HS.SDA3.Observation).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.target.(1), "HS.FHIR.DTL.vR4.SDA3.Goal.target.Observation")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.target.(1), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Target' action='set'  >
<annotation>
<![CDATA[ The aim of this goal in coded form
 --- FHIR4 Goal:target is a *List*, and SDA3 HS.SDA3.Goal:Target is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.   ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if> 
</true>
</if>
</transform>
}

}
