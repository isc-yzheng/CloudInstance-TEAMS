/// Transforms vSTU3 ReferralRequest to vDSTU2 ReferralRequest
Class HS.FHIR.DTL.vSTU3.vDSTU2.ReferralRequest.ReferralRequest Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.ReferralRequest, HS.FHIR.DTL.vDSTU2.Model.Resource.ReferralRequest), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.ReferralRequest' targetClass='HS.FHIR.DTL.vDSTU2.Model.Resource.ReferralRequest' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms ReferralRequest (vSTU3) to ReferralRequest (vDSTU2) ]]>
  </annotation>
<if condition='source.authoredOn&apos;=""'> 
<true> 
<assign value='source.authoredOn' property='target.date' action='set' >
<annotation>
<![CDATA[ Date of creation/activation ]]>
</annotation>
</assign></true> 
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
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "ReferralRequest:encounter", source.context)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.context' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.encounter' action='set'  >
<annotation>
<![CDATA[ Originating encounter
 --- The source and target data types are FHIR Reference. The target Reference does not support all the types that the source Reference supports.   ]]>
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
<![CDATA[ A textual description of the referral ]]>
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
<![CDATA[ Business identifier ]]>
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
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","vDSTU2","request-priority","diagnostic-order-priority",source.priority)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.priority.coding.(1).code' action='set' >
<annotation>
<![CDATA[ Urgency of referral / transfer of care request
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.reasonCode&apos;=""'> 
<true>
<if condition='source.reasonCode.Count()>0'> 
<true> 
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.reasonCode.(1)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.reason' action='set'  >
<annotation>
<![CDATA[ Reason for referral / transfer of care request
 --- FHIR STU3 ReferralRequest:reasonCode is a *List*, and FHIR DSTU2 ReferralRequest:reason is *Single*. 
 --- For a list object mapped to a single FHIR object, the mapping table must contain 2 mapping entries for the source list: One maps only the first item from the list to the target object; the other maps the list to a FHIR extension that contains the full list.   ]]>
</annotation>
</assign></true> 
</if>
</true> 
</if> 
</true>
</if>
<if condition='source.recipient&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "ReferralRequest:recipient", source.recipient)'> 
<true>
<foreach property='source.recipient()' key='st' >
<assign value='target.recipient.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.recipient.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.recipient' action='set' key='index'  >
<annotation>
<![CDATA[ Receiver of referral / transfer of care request
 --- The source and target data types are FHIR Reference. The target Reference does not support all the types that the source Reference supports.   ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
</true>
</if>
<if condition='source.requester&apos;=""'> 
<true>
<if condition='source.requester.agent&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "ReferralRequest:requester", source.requester.agent)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.requester.agent' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.requester' action='set'  >
<annotation>
<![CDATA[ Requester of referral / transfer of care
 --- The source and target data types are FHIR Reference. The target Reference does not support all the types that the source Reference supports.   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
</true>
</if>
<if condition='source.serviceRequested&apos;=""'> 
<true>
<foreach property='source.serviceRequested()' key='st' >
<assign value='target.serviceRequested.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.serviceRequested.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.serviceRequested' action='set' key='index'  >
<annotation>
<![CDATA[ Actions requested as part of the referral
 --- Note: The FHIR value set being used is (* c80-practice-codes) which means any FHIR2 code may be used; c80-practice-codes shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.specialty&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.specialty' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.specialty' action='set'  >
<annotation>
<![CDATA[ The clinical specialty (discipline) that the referral is requested for
 --- Note: The FHIR value set being used is (* practitioner-specialty) which means any FHIR2 code may be used; practitioner-specialty shows Example codes, but you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vSTU3","vDSTU2","request-status","referralstatus",source.status)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.status' action='set' >
<annotation>
<![CDATA[ draft | requested | active | cancelled | accepted | rejected | completed
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- The source and target use different value sets. FHIR STU3 ReferralRequest:status uses value set (request-status) and FHIR DSTU2 ReferralRequest:status uses value set (referralstatus). 
 --- The target value set is not flexible enough to accept all values. When there is no valid source data, the default value (if supplied) will be assigned to the field. 
 --- The target FHIR DSTU2 ReferralRequest:status is a required field with a required value set, but FHIR STU3 ReferralRequest:status and  FHIR DSTU2 ReferralRequest:status use different value sets. The target FHIR DSTU2 ReferralRequest:status uses value set (referralstatus) and FHIR STU3 ReferralRequest:status uses value set (request-status). *No Default Value* is supplied in case of invalid source data. This can be a serious gap.    ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.subject&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "ReferralRequest:patient", source.subject)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.subject' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.patient' action='set'  >
<annotation>
<![CDATA[ Patient referred to care or transfer
 --- The source and target data types are FHIR Reference. The target Reference does not support all the types that the source Reference supports.   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.supportingInfo&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "ReferralRequest:supportingInformation", source.supportingInfo)'> 
<true>
<foreach property='source.supportingInfo()' key='st' >
<assign value='target.supportingInformation.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.supportingInfo.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.supportingInformation' action='set' key='index'  >
<annotation>
<![CDATA[ Additonal information to support referral or transfer of care request
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
<if condition='source.type&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.CodeableConcept.CodeableConcept' targetObj='tmp' sourceObj='source.type' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.type' action='set'  >
<annotation>
<![CDATA[ Referral/Transition of care request type ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</transform>
}

}
