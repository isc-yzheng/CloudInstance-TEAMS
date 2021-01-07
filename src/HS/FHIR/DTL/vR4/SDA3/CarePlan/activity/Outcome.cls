/// Transforms vR4 CarePlan:activity to SDA3 HS.SDA3.Outcome
Class HS.FHIR.DTL.vR4.SDA3.CarePlan.activity.Outcome Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Element.CarePlan.activity, HS.SDA3.Outcome), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Element.CarePlan.activity' targetClass='HS.SDA3.Outcome' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms CarePlan:activity (vR4) to HS.SDA3.Outcome (SDA3) ]]>
  </annotation>
<if condition='source.outcomeCodeableConcept&apos;=""'> 
<true>
<if condition='source.outcomeReference.Count() = 0'> 
<true>
<if condition='source.outcomeCodeableConcept.Count()>0'> 
<true> 
<assign value='##class(HS.SDA3.CodeTableDetail.Observation).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.outcomeCodeableConcept.(1), "HS.FHIR.DTL.vR4.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.outcomeCodeableConcept.(1), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Observation.ObservationCode' action='set'  >
<annotation>
<![CDATA[ 
 --- FHIR4 CarePlan:activity[n].outcomeCodeableConcept is a *List*, and SDA3 HS.SDA3.Outcome:Observation.ObservationCode is *Single*. 
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
</true>
</if>
<if condition='source.outcomeReference&apos;=""'> 
<true>
<if condition='source.outcomeReference.Count()>0'> 
<true> 
<assign value='##class(HS.SDA3.Observation).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.outcomeReference.GetAt(1), .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Observation' action='set' >
<annotation>
<![CDATA[ 
 --- FHIR4 CarePlan:activity[n].outcomeReference is a *List*, and SDA3 HS.SDA3.Outcome:Observation is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.   ]]>
</annotation>
</assign></true> 
</if> </true> 
</if> 
</true>
</if>
</transform>
}

}
