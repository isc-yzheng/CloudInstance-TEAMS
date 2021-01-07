/// Transforms SDA3 HS.SDA3.Intervention to vR4 CarePlan:activity
Class HS.FHIR.DTL.SDA3.vR4.Intervention.CarePlan.activity Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.Intervention, HS.FHIR.DTL.vR4.Model.Element.CarePlan.activity), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.Intervention' targetClass='HS.FHIR.DTL.vR4.Model.Element.CarePlan.activity' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms HS.SDA3.Intervention (SDA3) to CarePlan:activity (vR4) ]]>
  </annotation>
<assign value='##class(HS.FHIR.DTL.Util.SDA3.Handler.CustomPairs).Extension(source.CustomPairs, .target, .aux)' property='value' action='set' />
<if condition='target.detail&apos;=""'> 
<true> 
<assign value='target.detail.extension.Count()+1' property='index' action='set' />
</true> 
<false> 
<assign value='1' property='index' action='set' />
</false> 
</if> 
<if condition='value&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/intervention-custom-pairs"' property='value.url' action='set' />
<assign value='value' property='target.detail.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations
 --- When the SDA3 source data contains a CustomPairs collection, and the target is FHIR, the collection is mapped to a FHIR extension that contains a Parameters resource. This Parameters resource is a collection of paired fields: name and valueString.   ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.Description&apos;=""'> 
<true>
<if condition='source.Description&apos;=""'> 
<true> 
<assign value='source.Description' property='target.detail.description' action='set' >
<annotation>
<![CDATA[ Extra info describing activity to perform ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.EncounterNumber&apos;=""'> 
<true>
<assign value='1' property='index' action='set' />
<if condition='target.detail&apos;=""'> 
<true> 
<assign value='target.detail.extension.Count()+1' property='index' action='set' />
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.EncounterNumber, "HS.FHIR.DTL.SubXFrm.SDA3.vR4.String.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.EncounterNumber, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/intervention-encounter-number"' property='tmp.url' action='set' />
<assign value='tmp' property='target.detail.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "EnteredAt")'> 
<true>
<assign value='1' property='index' action='set' />
<if condition='target.detail&apos;=""'> 
<true> 
<assign value='target.detail.extension.Count()+1' property='index' action='set' />
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.EnteredAt, "HS.FHIR.DTL.SDA3.vR4.CodeTableDetail.Organization.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.EnteredAt, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/intervention-entered-at"' property='tmp.url' action='set' />
<assign value='tmp' property='target.detail.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "EnteredBy")'> 
<true>
<assign value='1' property='index' action='set' />
<if condition='target.detail&apos;=""'> 
<true> 
<assign value='target.detail.extension.Count()+1' property='index' action='set' />
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.EnteredBy, "HS.FHIR.DTL.SDA3.vR4.CodeTableDetail.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.EnteredBy, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/intervention-entered-by"' property='tmp.url' action='set' />
<assign value='tmp' property='target.detail.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
<if condition='source.EnteredOn&apos;=""'> 
<true>
<assign value='1' property='index' action='set' />
<if condition='target.detail&apos;=""'> 
<true> 
<assign value='target.detail.extension.Count()+1' property='index' action='set' />
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.EnteredOn, "HS.FHIR.DTL.SubXFrm.SDA3.vR4.TimeStamp.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.EnteredOn, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/intervention-entered-on"' property='tmp.url' action='set' />
<assign value='tmp' property='target.detail.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='source.ExternalId&apos;=""'> 
<true>
<assign value='1' property='index' action='set' />
<if condition='target.detail&apos;=""'> 
<true> 
<assign value='target.detail.extension.Count()+1' property='index' action='set' />
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.ExternalId, "HS.FHIR.DTL.SubXFrm.SDA3.vR4.String.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.ExternalId, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/intervention-external-id"' property='tmp.url' action='set' />
<assign value='tmp' property='target.detail.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='source.FromTime&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).DateToFHIR(source.FromTime, "dateTime")' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.detail.scheduledPeriod.start' action='set' >
<annotation>
<![CDATA[ Starting time with inclusive boundary ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.GoalIds&apos;=""'> 
<true>
<foreach property='source.GoalIds()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='target.detail&apos;=""'> 
<true> 
<assign value='target.detail.extension.Count()+1' property='index' action='set' />
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.GoalIds.(st), "HS.FHIR.DTL.SubXFrm.SDA3.vR4.String.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.GoalIds.(st), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/intervention-goal-ids"' property='tmp.url' action='set' />
<assign value='tmp' property='target.detail.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</foreach>
</true>
</if>
<foreach property='source.Performers()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='target.detail&apos;=""'> 
<true> 
<assign value='target.detail.performer.Count()+1' property='index' action='set' />
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vR4.Model.Resource.Practitioner).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Performers.(st), "HS.FHIR.DTL.SDA3.vR4.DocumentProvider.Practitioner")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Performers.(st), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='aux("transformer").AddResource(source.Performers.(st), tmp)' property='reference' action='set' />
<if condition='reference&apos;=""'> 
<true>
<assign value='reference' property='target.detail.performer' action='set' key='index'  >
<annotation>
<![CDATA[ Who will be responsible? ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true>
</if>
</foreach>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("SDA3","vR4","HS.SDA3.Intervention:Status","care-plan-activity-status|4.0.1",source.Status)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.detail.status' action='set' >
<annotation>
<![CDATA[ not-started | scheduled | in-progress | on-hold | completed | cancelled | stopped | unknown | entered-in-error
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- If the mapping is SDA to FHIR, and the source field contains a non-empty value, then by convention there are two mapping entries for this source field. Both entries execute under the same Condition to Set this Field. One entry does the lookup to retrieve the value to assign to the target field. The other stores the original source field value in a FHIR extension.    ]]>
</annotation>
</assign></true> 
<false> 
<assign value='"unknown"' property='target.detail.status' action='set' />
</false> 
</if> 
<if condition='source.Status&apos;=""'> 
<true>
<if condition='(##class(HS.FHIR.DTL.Util.Lookup).Code("SDA3","vR4","HS.SDA3.Intervention:Status","care-plan-activity-status|4.0.1",source.Status) = "")'> 
<true>
<assign value='1' property='index' action='set' />
<if condition='target.detail&apos;=""'> 
<true> 
<assign value='target.detail.extension.Count()+1' property='index' action='set' />
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Status, "HS.FHIR.DTL.SubXFrm.SDA3.vR4.String.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Status, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/intervention-status"' property='tmp.url' action='set' />
<assign value='tmp' property='target.detail.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
</true>
</if>
<if condition='source.ToTime&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).DateToFHIR(source.ToTime, "dateTime")' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.detail.scheduledPeriod.end' action='set' >
<annotation>
<![CDATA[ End time with inclusive boundary, if not ongoing ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='##class(%Dictionary.ClassDefinition).%ExistsId("HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.Intervention.CarePlan.activity")'> 
<true>
<code><![CDATA[  lock +^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.Intervention.CarePlan.activity") ]]></code>
<assign value='##class(HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.Intervention.CarePlan.activity).Transform(source.Extension, .target, .aux)' property='target' action='set' />
<code><![CDATA[  lock -^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.Intervention.CarePlan.activity") ]]></code>
</true>
</if>
</transform>
}

}
