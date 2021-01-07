/// Transforms vSTU3 Goal to SDA3 HS.SDA3.Goal
Class HS.FHIR.DTL.vSTU3.SDA3.Goal.Goal Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.Goal, HS.SDA3.Goal), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.Goal' targetClass='HS.SDA3.Goal' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Goal (vSTU3) to HS.SDA3.Goal (SDA3) ]]>
  </annotation>
<if condition='source.addresses&apos;=""'> 
<true>
<foreach property='source.addresses()' key='st' >
<assign value='""' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.addresses.GetAt(st), .value, .aux)' property='value' action='set' />
<assign value='target.HealthConcernIds.Count()+1' property='index' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.HealthConcernIds' action='set' key='index'  >
<annotation>
<![CDATA[ 
 --- SDA3 HS.SDA3.Goal:HealthConcernIds is type %String and it has no MAXLEN value set, so its maximum string length is *50*.    ]]>
</annotation>
</assign></true> 
</if> </foreach>
</true>
</if>
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
<if condition='source.priority&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.Priority).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.priority, "HS.FHIR.DTL.vSTU3.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.priority, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Priority' action='set'  >
<annotation>
<![CDATA[ 
 --- In this case, goal-priority is the Preferred FHIR3 ValueSet for codes, but if you need to express meanings not found in goal-priority, you may use codes from any ValueSet. 
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
<if condition='source.status&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","goal-status","HS.SDA3.Goal:Status",source.status)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Status.Code' action='set' >
<annotation>
<![CDATA[ The external code, e.g. "M"
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.status&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","SDA3","goal-status","HS.SDA3.Goal:Status",source.status) = ""'> 
<true>
<if condition='source.status&apos;=""'> 
<true> 
<assign value='source.status' property='target.Status.Code' action='set' >
<annotation>
<![CDATA[ The external code, e.g. "M"
 --- This mapping operates only when a table lookup to match an incoming FHIR code value with an appropriate SDA Code value fails. In that case, this mapping maps the source FHIR code value (unchanged) into an SDA CodeTableDetail Code value, and if the FHIR code was inside a Coding or CodeableConcept, it maps the FHIR display, system, and version values into appropriate SDA CodeTableDetail fields.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.target&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.Observation).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.target, "HS.FHIR.DTL.vSTU3.SDA3.Goal.target.Observation")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.target, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Target' action='set'  >
<annotation>
<![CDATA[ The aim of this goal in coded form ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
</transform>
}

}
