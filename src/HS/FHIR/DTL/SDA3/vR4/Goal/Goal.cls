/// Transforms SDA3 HS.SDA3.Goal to vR4 Goal
Class HS.FHIR.DTL.SDA3.vR4.Goal.Goal Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.Goal, HS.FHIR.DTL.vR4.Model.Resource.Goal), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.Goal' targetClass='HS.FHIR.DTL.vR4.Model.Resource.Goal' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms HS.SDA3.Goal (SDA3) to Goal (vR4) ]]>
  </annotation>
<assign value='##class(HS.FHIR.DTL.Util.SDA3.Handler.CustomPairs).Extension(source.CustomPairs, .target, .aux)' property='value' action='set' />
<assign value='target.extension.Count()+1' property='index' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/goal-custom-pairs"' property='value.url' action='set' />
<assign value='value' property='target.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations
 --- When the SDA3 source data contains a CustomPairs collection, and the target is FHIR, the collection is mapped to a FHIR extension that contains a Parameters resource. This Parameters resource is a collection of paired fields: name and valueString.   ]]>
</annotation>
</assign></true> 
</if> 
<assign value='aux("transformer").GetPatientReference()' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.subject' action='set' >
<annotation>
<![CDATA[ Who this goal is intended for ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.ToTime = ""'> 
<true>
<assign value='"active"' property='target.lifecycleStatus' action='set' >
<annotation>
<![CDATA[ proposed | planned | accepted | active | on-hold | completed | cancelled | entered-in-error | rejected ]]>
</annotation>
</assign>
</true>
</if>
<if condition='source.ToTime &apos;= ""'> 
<true>
<assign value='"completed"' property='target.lifecycleStatus' action='set' >
<annotation>
<![CDATA[ proposed | planned | accepted | active | on-hold | completed | cancelled | entered-in-error | rejected ]]>
</annotation>
</assign>
</true>
</if>
<if condition='source.Authors.Count()>0'> 
<true> 
<assign value='##class(HS.FHIR.DTL.vR4.Model.Resource.Practitioner).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Authors.(1), "HS.FHIR.DTL.SDA3.vR4.DocumentProvider.Practitioner")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Authors.(1), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='aux("transformer").AddResource(source.Authors.(1), tmp)' property='reference' action='set' />
<if condition='reference&apos;=""'> 
<true>
<assign value='reference' property='target.expressedBy' action='set'  >
<annotation>
<![CDATA[ Who's responsible for creating Goal?
 --- SDA3 HS.SDA3.Goal:Authors is a *List*, and FHIR4 Goal:expressedBy is *Single*. 
 --- For a list object mapped to a single FHIR object, the mapping table must contain 2 mapping entries for the source list: One maps only the first item from the list to the target object; the other maps the list to a FHIR extension that contains the full list.   ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true>
</if>
</true> 
</if> 
<foreach property='source.Authors()' key='st' >
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Authors.(st), "HS.FHIR.DTL.SDA3.vR4.DocumentProvider.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Authors.(st), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/goal-authors"' property='tmp.url' action='set' />
<assign value='tmp' property='target.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</foreach>
<if condition='source.Description&apos;=""'> 
<true>
<if condition='source.Description&apos;=""'> 
<true> 
<assign value='source.Description' property='target.description.text' action='set' >
<annotation>
<![CDATA[ Plain text representation of the concept ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.EncounterNumber&apos;=""'> 
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.EncounterNumber, "HS.FHIR.DTL.SubXFrm.SDA3.vR4.String.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.EncounterNumber, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/goal-encounter-number"' property='tmp.url' action='set' />
<assign value='tmp' property='target.extension' action='set' key='index'  >
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
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.EnteredAt, "HS.FHIR.DTL.SDA3.vR4.CodeTableDetail.Organization.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.EnteredAt, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/goal-entered-at"' property='tmp.url' action='set' />
<assign value='tmp' property='target.extension' action='set' key='index'  >
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
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.EnteredBy, "HS.FHIR.DTL.SDA3.vR4.CodeTableDetail.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.EnteredBy, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/goal-entered-by"' property='tmp.url' action='set' />
<assign value='tmp' property='target.extension' action='set' key='index'  >
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
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.EnteredOn, "HS.FHIR.DTL.SubXFrm.SDA3.vR4.TimeStamp.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.EnteredOn, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/goal-entered-on"' property='tmp.url' action='set' />
<assign value='tmp' property='target.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.SDA3.Handler.ExternalId).Identifier(source.ExternalId)' property='value' action='set' />
<assign value='target.identifier.Count()+1' property='index' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.identifier' action='set' key='index'  >
<annotation>
<![CDATA[ External Ids for this goal ]]>
</annotation>
</assign></true> 
</if> 
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).DateToFHIR(source.FromTime, "date")' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.startDate' action='set' >
<annotation>
<![CDATA[ When goal pursuit begins ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.HealthConcernIds&apos;=""'> 
<true>
<foreach property='source.HealthConcernIds()' key='st' >
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.HealthConcernIds.(st), "HS.FHIR.DTL.SubXFrm.SDA3.vR4.String.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.HealthConcernIds.(st), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/goal-health-concern-ids"' property='tmp.url' action='set' />
<assign value='tmp' property='target.extension' action='set' key='index'  >
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
<foreach property='source.HealthConcernIds()' key='st' >
<assign value='aux("transformer").GetReference("Condition", source.HealthConcernIds.GetAt(st))' property='value' action='set' />
<assign value='target.addresses.Count()+1' property='index' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.addresses' action='set' key='index'  >
<annotation>
<![CDATA[ Issues addressed by this goal ]]>
</annotation>
</assign></true> 
</if> </foreach>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "Priority")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Priority, "HS.FHIR.DTL.SDA3.vR4.CodeTableTranslated.CodeableConcept")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Priority, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.priority' action='set'  >
<annotation>
<![CDATA[ high-priority | medium-priority | low-priority
 --- In this case, goal-priority is the Preferred FHIR4 ValueSet for codes, but if you need to express meanings not found in goal-priority, you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "Status")'> 
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Status, "HS.FHIR.DTL.SDA3.vR4.CodeTableDetail.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Status, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/goal-status"' property='tmp.url' action='set' />
<assign value='tmp' property='target.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source.Target, "Clinician")'> 
<true>
<assign value='1' property='index' action='set' />
<if condition='(target.target&apos;="") &amp;&amp; (target.target.Count() &gt; 0)'> 
<true> 
<if condition='target.target.(1)&apos;=""'> 
<true> 
<assign value='target.target.(1).extension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Target.Clinician, "HS.FHIR.DTL.SDA3.vR4.CodeTableDetail.CareProvider.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Target.Clinician, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/goal-target-clinician"' property='tmp.url' action='set' />
<assign value='tmp' property='target.target.(1).extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
<if condition='source.Target.Comments&apos;=""'> 
<true>
<assign value='1' property='index' action='set' />
<if condition='(target.target&apos;="") &amp;&amp; (target.target.Count() &gt; 0)'> 
<true> 
<if condition='target.target.(1)&apos;=""'> 
<true> 
<assign value='target.target.(1).extension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Target.Comments, "HS.FHIR.DTL.SubXFrm.SDA3.vR4.String.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Target.Comments, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/goal-target-comments"' property='tmp.url' action='set' />
<assign value='tmp' property='target.target.(1).extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='source.Target.EncounterNumber&apos;=""'> 
<true>
<assign value='1' property='index' action='set' />
<if condition='(target.target&apos;="") &amp;&amp; (target.target.Count() &gt; 0)'> 
<true> 
<if condition='target.target.(1)&apos;=""'> 
<true> 
<assign value='target.target.(1).extension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Target.EncounterNumber, "HS.FHIR.DTL.SubXFrm.SDA3.vR4.String.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Target.EncounterNumber, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/goal-target-encounter-number"' property='tmp.url' action='set' />
<assign value='tmp' property='target.target.(1).extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source.Target, "EnteredAt")'> 
<true>
<assign value='1' property='index' action='set' />
<if condition='(target.target&apos;="") &amp;&amp; (target.target.Count() &gt; 0)'> 
<true> 
<if condition='target.target.(1)&apos;=""'> 
<true> 
<assign value='target.target.(1).extension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Target.EnteredAt, "HS.FHIR.DTL.SDA3.vR4.CodeTableDetail.Organization.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Target.EnteredAt, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/goal-target-entered-at"' property='tmp.url' action='set' />
<assign value='tmp' property='target.target.(1).extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source.Target, "EnteredBy")'> 
<true>
<assign value='1' property='index' action='set' />
<if condition='(target.target&apos;="") &amp;&amp; (target.target.Count() &gt; 0)'> 
<true> 
<if condition='target.target.(1)&apos;=""'> 
<true> 
<assign value='target.target.(1).extension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Target.EnteredBy, "HS.FHIR.DTL.SDA3.vR4.CodeTableDetail.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Target.EnteredBy, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/goal-target-entered-by"' property='tmp.url' action='set' />
<assign value='tmp' property='target.target.(1).extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
<if condition='source.Target.EnteredOn&apos;=""'> 
<true>
<assign value='1' property='index' action='set' />
<if condition='(target.target&apos;="") &amp;&amp; (target.target.Count() &gt; 0)'> 
<true> 
<if condition='target.target.(1)&apos;=""'> 
<true> 
<assign value='target.target.(1).extension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Target.EnteredOn, "HS.FHIR.DTL.SubXFrm.SDA3.vR4.TimeStamp.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Target.EnteredOn, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/goal-target-entered-on"' property='tmp.url' action='set' />
<assign value='tmp' property='target.target.(1).extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='source.Target.ExternalId&apos;=""'> 
<true>
<assign value='1' property='index' action='set' />
<if condition='(target.target&apos;="") &amp;&amp; (target.target.Count() &gt; 0)'> 
<true> 
<if condition='target.target.(1)&apos;=""'> 
<true> 
<assign value='target.target.(1).extension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Target.ExternalId, "HS.FHIR.DTL.SubXFrm.SDA3.vR4.String.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Target.ExternalId, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/goal-target-external-id"' property='tmp.url' action='set' />
<assign value='tmp' property='target.target.(1).extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='source.Target.FromTime&apos;=""'> 
<true>
<assign value='1' property='index' action='set' />
<if condition='(target.target&apos;="") &amp;&amp; (target.target.Count() &gt; 0)'> 
<true> 
<if condition='target.target.(1)&apos;=""'> 
<true> 
<assign value='target.target.(1).extension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Target.FromTime, "HS.FHIR.DTL.SubXFrm.SDA3.vR4.TimeStamp.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Target.FromTime, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/goal-target-from-time"' property='tmp.url' action='set' />
<assign value='tmp' property='target.target.(1).extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='source.Target.GroupId&apos;=""'> 
<true>
<assign value='1' property='index' action='set' />
<if condition='(target.target&apos;="") &amp;&amp; (target.target.Count() &gt; 0)'> 
<true> 
<if condition='target.target.(1)&apos;=""'> 
<true> 
<assign value='target.target.(1).extension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Target.GroupId, "HS.FHIR.DTL.SubXFrm.SDA3.vR4.String.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Target.GroupId, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/goal-target-group-id"' property='tmp.url' action='set' />
<assign value='tmp' property='target.target.(1).extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source.Target, "ObservationCode")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Target.ObservationCode, "HS.FHIR.DTL.SDA3.vR4.CodeTableDetail.Observation.CodeableConcept")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Target.ObservationCode, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.target.(1).measure' action='set'  >
<annotation>
<![CDATA[ The parameter whose value is being tracked ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
<if condition='##class(HS.FHIR.DTL.Util.SDA3.Handler.ResultItem).ResultValue(source.Target.ObservationValue) &apos;= ""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source.Target.ObservationCode, "ObservationValueUnits")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vR4.Model.Datatype.Quantity).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Target.ObservationCode.ObservationValueUnits, "HS.FHIR.DTL.SDA3.vR4.CodeTableTranslated.Quantity")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Target.ObservationCode.ObservationValueUnits, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.target.(1).detailQuantity' action='set'  >
<annotation>
<![CDATA[ The target value to be achieved ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
</true>
</if>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source.Target, "ObservationCodedValue")'> 
<true>
<assign value='1' property='index' action='set' />
<if condition='(target.target&apos;="") &amp;&amp; (target.target.Count() &gt; 0)'> 
<true> 
<if condition='target.target.(1)&apos;=""'> 
<true> 
<assign value='target.target.(1).extension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Target.ObservationCodedValue, "HS.FHIR.DTL.SDA3.vR4.CodeTableTranslated.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Target.ObservationCodedValue, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/goal-target-observation-coded-value"' property='tmp.url' action='set' />
<assign value='tmp' property='target.target.(1).extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
<foreach property='source.Target.ObservationMethods()' key='st' >
<assign value='1' property='index' action='set' />
<if condition='(target.target&apos;="") &amp;&amp; (target.target.Count() &gt; 0)'> 
<true> 
<if condition='target.target.(1)&apos;=""'> 
<true> 
<assign value='target.target.(1).extension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Target.ObservationMethods.(st), "HS.FHIR.DTL.SDA3.vR4.CodeTableTranslated.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Target.ObservationMethods.(st), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/goal-target-observation-methods"' property='tmp.url' action='set' />
<assign value='tmp' property='target.target.(1).extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</foreach>
<if condition='source.Target.ObservationTime&apos;=""'> 
<true>
<assign value='1' property='index' action='set' />
<if condition='(target.target&apos;="") &amp;&amp; (target.target.Count() &gt; 0)'> 
<true> 
<if condition='target.target.(1)&apos;=""'> 
<true> 
<assign value='target.target.(1).extension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Target.ObservationTime, "HS.FHIR.DTL.SubXFrm.SDA3.vR4.TimeStamp.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Target.ObservationTime, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/goal-target-observation-time"' property='tmp.url' action='set' />
<assign value='tmp' property='target.target.(1).extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='source.Target.ObservationValue&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.SDA3.Handler.ResultItem).ResultValue(source.Target.ObservationValue)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.target.(1).detailQuantity.value' action='set' >
<annotation>
<![CDATA[ Numerical value (with implicit precision) ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.Target.ObservationValue&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.SDA3.Handler.ResultItem).ResultValue(source.Target.ObservationValue) &apos;= ""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.SDA3.Handler.ResultItem).ResultComparator(source.Target.ObservationValue)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.target.(1).detailQuantity.comparator' action='set' >
<annotation>
<![CDATA[ < | <= | >= | > - how to understand the value ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
</true>
</if>
<if condition='source.Target.ObservationValue&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.SDA3.Handler.ResultItem).ResultValue(source.Target.ObservationValue) = ""'> 
<true>
<if condition='source.Target.ObservationValue&apos;=""'> 
<true> 
<assign value='source.Target.ObservationValue' property='target.target.(1).detailCodeableConcept.text' action='set' >
<annotation>
<![CDATA[ Plain text representation of the concept ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.Target.ObservationValueTime&apos;=""'> 
<true>
<assign value='1' property='index' action='set' />
<if condition='(target.target&apos;="") &amp;&amp; (target.target.Count() &gt; 0)'> 
<true> 
<if condition='target.target.(1)&apos;=""'> 
<true> 
<assign value='target.target.(1).extension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Target.ObservationValueTime, "HS.FHIR.DTL.SubXFrm.SDA3.vR4.TimeStamp.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Target.ObservationValueTime, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/goal-target-observation-value-time"' property='tmp.url' action='set' />
<assign value='tmp' property='target.target.(1).extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='source.Target.ObservationValueType&apos;=""'> 
<true>
<assign value='1' property='index' action='set' />
<if condition='(target.target&apos;="") &amp;&amp; (target.target.Count() &gt; 0)'> 
<true> 
<if condition='target.target.(1)&apos;=""'> 
<true> 
<assign value='target.target.(1).extension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Target.ObservationValueType, "HS.FHIR.DTL.SubXFrm.SDA3.vR4.String.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Target.ObservationValueType, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/goal-target-observation-value-type"' property='tmp.url' action='set' />
<assign value='tmp' property='target.target.(1).extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='source.Target.ToTime&apos;=""'> 
<true>
<assign value='1' property='index' action='set' />
<if condition='(target.target&apos;="") &amp;&amp; (target.target.Count() &gt; 0)'> 
<true> 
<if condition='target.target.(1)&apos;=""'> 
<true> 
<assign value='target.target.(1).extension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Target.ToTime, "HS.FHIR.DTL.SubXFrm.SDA3.vR4.TimeStamp.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Target.ToTime, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/goal-target-to-time"' property='tmp.url' action='set' />
<assign value='tmp' property='target.target.(1).extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='source.ToTime&apos;=""'> 
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.ToTime, "HS.FHIR.DTL.SubXFrm.SDA3.vR4.TimeStamp.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.ToTime, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/goal-to-time"' property='tmp.url' action='set' />
<assign value='tmp' property='target.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='##class(%Dictionary.ClassDefinition).%ExistsId("HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.Goal.Goal")'> 
<true>
<code><![CDATA[  lock +^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.Goal.Goal") ]]></code>
<assign value='##class(HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.Goal.Goal).Transform(source.Extension, .target, .aux)' property='target' action='set' />
<code><![CDATA[  lock -^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.Goal.Goal") ]]></code>
</true>
</if>
</transform>
}

}
