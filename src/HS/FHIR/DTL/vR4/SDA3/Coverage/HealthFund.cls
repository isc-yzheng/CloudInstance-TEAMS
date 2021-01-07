/// Transforms vR4 Coverage to SDA3 HS.SDA3.HealthFund
Class HS.FHIR.DTL.vR4.SDA3.Coverage.HealthFund Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Resource.Coverage, HS.SDA3.HealthFund), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.Coverage' targetClass='HS.SDA3.HealthFund' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Coverage (vR4) to HS.SDA3.HealthFund (SDA3) ]]>
  </annotation>
<if condition='source.network&apos;=""'> 
<true>
<if condition='source.network&apos;=""'> 
<true> 
<assign value='source.network' property='target.HealthFund.Code' action='set' /></true> 
</if> 

</true>
</if>
<if condition='source.order&apos;=""'> 
<true> 
<assign value='source.order' property='target.Priority' action='set' >
<annotation>
<![CDATA[ 
 --- FHIR4 Coverage:order is type positiveInt; this is not a good match for SDA3 HS.SDA3.HealthFund:Priority, which is type %String. 
 --- SDA3 HS.SDA3.HealthFund:Priority is type %String and it has no MAXLEN value set, so its maximum string length is *50*.    ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.payor&apos;=""'> 
<true>
<if condition='source.payor.Count()>0'> 
<true> 
<assign value='##class(HS.SDA3.CodeTableDetail.HealthFund).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.payor.GetAt(1), .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.HealthFund' action='set' >
<annotation>
<![CDATA[ 
 --- FHIR4 Coverage:payor is a *List*, and SDA3 HS.SDA3.HealthFund:HealthFund is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.   ]]>
</annotation>
</assign></true> 
</if> </true> 
</if> 
</true>
</if>
<if condition='source.period&apos;=""'> 
<true>
<if condition='source.period.end&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.period.end)' property='value' action='set' />
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
<if condition='source.period&apos;=""'> 
<true>
<if condition='source.period.start&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.period.start)' property='value' action='set' />
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
<if condition='source.relationship&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.Relationship).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.relationship, "HS.FHIR.DTL.vR4.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.relationship, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.InsuredRelationship' action='set'  >
<annotation>
<![CDATA[ 
 --- In this case, subscriber-relationship is the *Required* FHIR4 ValueSet for codes, but if you need to express meanings not found in subscriber-relationship, you may formally *Extend* subscriber-relationship to add codes to it. 
 --- SDA does not restrict code values to a particular set.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='source.subscriberId&apos;=""'> 
<true> 
<assign value='source.subscriberId' property='target.MembershipNumber' action='set' >
<annotation>
<![CDATA[ 
 --- SDA3 HS.SDA3.HealthFund:MembershipNumber is type %String with a maximum string length of *220*.    ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.type&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.HealthFundPlan).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.type, "HS.FHIR.DTL.vR4.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.type, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.HealthFundPlan' action='set'  >
<annotation>
<![CDATA[ 
 --- In this case, coverage-type is the Preferred FHIR4 ValueSet for codes, but if you need to express meanings not found in coverage-type, you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='source.type&apos;=""'> 
<true>
<if condition='source.type.text&apos;=""'> 
<true>
<if condition='source.type.text&apos;=""'> 
<true> 
<assign value='source.type.text' property='target.PlanType' action='set' /></true> 
</if> 

</true>
</if>
</true>
</if>
</transform>
}

}
