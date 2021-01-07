/// Transforms vR4 CarePlan:activity to SDA3 HS.SDA3.Intervention
Class HS.FHIR.DTL.vR4.SDA3.CarePlan.activity.Intervention Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Element.CarePlan.activity, HS.SDA3.Intervention), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Element.CarePlan.activity' targetClass='HS.SDA3.Intervention' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms CarePlan:activity (vR4) to HS.SDA3.Intervention (SDA3) ]]>
  </annotation>
<if condition='source.detail&apos;=""'> 
<true>
<if condition='source.detail.performer&apos;=""'> 
<true>
<foreach property='source.detail.performer()' key='st' >
<assign value='##class(HS.SDA3.DocumentProvider).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.detail.performer.GetAt(st), .value, .aux)' property='value' action='set' />
<assign value='target.Performers.Count()+1' property='index' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Performers' action='set' key='index'  /></true> 
</if> </foreach>
</true>
</if>
</true>
</if>
<if condition='source.detail&apos;=""'> 
<true>
<if condition='source.detail.scheduledPeriod&apos;=""'> 
<true>
<if condition='source.detail.scheduledPeriod.end&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.detail.scheduledPeriod.end)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.ToTime' action='set' >
<annotation>
<![CDATA[ End of time range ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
</true>
</if>
</true>
</if>
<if condition='source.detail&apos;=""'> 
<true>
<if condition='source.detail.scheduledPeriod&apos;=""'> 
<true>
<if condition='source.detail.scheduledPeriod.start&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.detail.scheduledPeriod.start)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.FromTime' action='set' >
<annotation>
<![CDATA[ Start of time range ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
</true>
</if>
</true>
</if>
<if condition='source.detail&apos;=""'> 
<true>
<if condition='source.detail.status&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vR4","SDA3","care-plan-activity-status|4.0.1","HS.SDA3.Intervention:Status",source.detail.status)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Status' action='set' >
<annotation>
<![CDATA[ 
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- SDA3 HS.SDA3.Intervention:Status is type %String and it has no MAXLEN value set, so its maximum string length is *50*.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
</true>
</if>
<if condition='source.detail&apos;=""'> 
<true>
<if condition='source.detail.status&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Code("vR4","SDA3","care-plan-activity-status|4.0.1","HS.SDA3.Intervention:Status",source.detail.status) = ""'> 
<true>
<if condition='source.detail.status&apos;=""'> 
<true> 
<assign value='source.detail.status' property='target.Status' action='set' >
<annotation>
<![CDATA[ 
 --- SDA3 HS.SDA3.Intervention:Status is type %String and it has no MAXLEN value set, so its maximum string length is *50*. 
 --- This mapping operates only when a table lookup to match an incoming FHIR code value with an appropriate SDA Code value fails. In that case, this mapping maps the source FHIR code value (unchanged) into an SDA CodeTableDetail Code value, and if the FHIR code was inside a Coding or CodeableConcept, it maps the FHIR display, system, and version values into appropriate SDA CodeTableDetail fields.    ]]>
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
