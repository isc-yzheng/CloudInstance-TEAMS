/// Transforms vSTU3 ReferralRequest to SDA3 HS.SDA3.Referral
Class HS.FHIR.DTL.vSTU3.SDA3.ReferralRequest.Referral Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.ReferralRequest, HS.SDA3.Referral), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.ReferralRequest' targetClass='HS.SDA3.Referral' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms ReferralRequest (vSTU3) to HS.SDA3.Referral (SDA3) ]]>
  </annotation>
<if condition='source.context&apos;=""'> 
<true>
<assign value='""' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.context, .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.EncounterNumber' action='set' >
<annotation>
<![CDATA[ A string that uniquely identifies an Encounter within a patient record.
 --- SDA3 HS.SDA3.Referral:EncounterNumber is type %String with a maximum string length of *220*.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.identifier&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.identifier()' key='k1' >
<if condition='source.identifier.(k1).value&apos;=""'> 
<true>
<if condition='(source.identifier.(k1).type &apos;= "") &amp;&amp; (source.identifier.(k1).type.coding.Count() > 0) &amp;&amp; (source.identifier.(k1).type.coding.(1).code = "FILL")'> 
<true>
<if condition='source.identifier.(k1).value&apos;=""'> 
<true> 
<assign value='source.identifier.(k1).value' property='target.FillerId' action='set' >
<annotation>
<![CDATA[ The identifier assigned to the referral by the referred-to provider
 --- SDA3 HS.SDA3.Referral:FillerId is type %String with a maximum string length of *220*.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.identifier.(k1).value&apos;=""'> 
<true>
<if condition='(source.identifier.(k1).type &apos;= "") &amp;&amp; (source.identifier.(k1).type.coding.Count() > 0) &amp;&amp; (source.identifier.(k1).type.coding.(1).code = "PLAC")'> 
<true>
<if condition='source.identifier.(k1).value&apos;=""'> 
<true> 
<assign value='source.identifier.(k1).value' property='target.PlacerId' action='set' >
<annotation>
<![CDATA[ The originating application's permanent identifier for the referral
 --- SDA3 HS.SDA3.Referral:PlacerId is type %String with a maximum string length of *220*.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
</foreach>
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.occurrenceDateTime)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.FromTime' action='set' >
<annotation>
<![CDATA[ Start of time range ]]>
</annotation>
</assign></true> 
</if> 
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.occurrenceDateTime)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.ToTime' action='set' >
<annotation>
<![CDATA[ End of time range ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.occurrencePeriod&apos;=""'> 
<true>
<if condition='source.occurrencePeriod.end&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.occurrencePeriod.end)' property='value' action='set' />
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
<if condition='source.occurrencePeriod&apos;=""'> 
<true>
<if condition='source.occurrencePeriod.start&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.occurrencePeriod.start)' property='value' action='set' />
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
<if condition='source.reasonCode.Count()>0'> 
<true>
<if condition='source.reasonCode.(1).text&apos;=""'> 
<true>
<if condition='source.reasonCode.(1).text&apos;=""'> 
<true> 
<assign value='source.reasonCode.(1).text' property='target.ReferralReason' action='set' /></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.recipient&apos;=""'> 
<true>
<if condition='source.recipient.Count()>0'> 
<true> 
<assign value='##class(HS.SDA3.CodeTableDetail.HealthCareFacility).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.recipient.GetAt(1), .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.ReferredToOrganization' action='set' >
<annotation>
<![CDATA[ 
 --- FHIR STU3 ReferralRequest:recipient is a *List*, and SDA3 HS.SDA3.Referral:ReferredToOrganization is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.   ]]>
</annotation>
</assign></true> 
</if> </true> 
</if> 
</true>
</if>
<if condition='source.recipient&apos;=""'> 
<true>
<if condition='source.recipient.Count()>0'> 
<true> 
<assign value='##class(HS.SDA3.CodeTableDetail.CareProvider).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.recipient.GetAt(1), .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.ReferredToProvider' action='set' >
<annotation>
<![CDATA[ 
 --- FHIR STU3 ReferralRequest:recipient is a *List*, and SDA3 HS.SDA3.Referral:ReferredToProvider is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.   ]]>
</annotation>
</assign></true> 
</if> </true> 
</if> 
</true>
</if>
<if condition='source.requester&apos;=""'> 
<true>
<if condition='source.requester.agent&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.CareProvider).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.requester.agent, .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.ReferringProvider' action='set' /></true> 
</if> 
</true>
</if>
</true>
</if>
<if condition='source.requester&apos;=""'> 
<true>
<if condition='source.requester.agent&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.HealthCareFacility).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.requester.agent, .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.ReferringOrganization' action='set' /></true> 
</if> 
</true>
</if>
</true>
</if>
<if condition='source.requester&apos;=""'> 
<true>
<if condition='source.requester.onBehalfOf&apos;=""'> 
<true>
<if condition='source.requester.agent.reference &apos;[ "Organization"'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.HealthCareFacility).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.requester.onBehalfOf, .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.ReferringOrganization' action='set' /></true> 
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
