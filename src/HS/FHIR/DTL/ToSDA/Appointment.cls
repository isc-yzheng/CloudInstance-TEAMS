Class HS.FHIR.DTL.ToSDA.Appointment Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.vDSTU2.Model.Resource.Appointment, HS.SDA3.Appointment) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.vDSTU2.Model.Resource.Appointment' targetClass='HS.SDA3.Appointment' create='new' language='objectscript' >
<foreach property='source.identifier()' key='k1' >
<if condition='k1=1' >
<true>
<assign value='source.identifier.(k1).value.value' property='target.PlacerApptId' action='set' />
</true>
<false>
<if condition='k1=2' >
<true>
<assign value='source.identifier.(k1).value.value' property='target.FillerApptId' action='set' />
</true>
<false>
<assign value='source.identifier.(k1).value.value' property='target.ExternalId' action='set' />
</false>
</if>
</false>
</if>
</foreach>
<if condition='source.status.value = "cancelled"' >
<true>
<assign value='"CANCELLED"' property='target.Status' action='set' />
</true>
<false>
<assign value='"BOOKED"' property='target.Status' action='set' />
</false>
</if>
<if condition='source.status.value="noshow"' >
<true>
<assign value='1' property='target.NoShow' action='set' />
</true>
</if>
<if condition='$IsObject(source.type)' >
<true>
<assign value='source.type.text.value' property='target.OrderItem.OriginalText' action='set' />
<if condition='source.type.coding.Count() &gt; 0' >
<true>
<assign value='source.type.coding.(1).code.value' property='target.OrderItem.Code' action='set' />
<assign value='source.type.coding.(1).display.value' property='target.OrderItem.Description' action='set' />
<assign value='source.type.coding.(1).version.value' property='target.OrderItem.CodeSystemVersionId' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.type.coding.(1).system.value)' property='target.OrderItem.SDACodingStandard' action='set' />
</true>
</if>
</true>
</if>
<if condition='$IsObject(source.reason)' >
<true>
<assign value='source.reason.text.value' property='target.Type.OriginalText' action='set' />
<if condition='source.reason.coding.Count() &gt; 0' >
<true>
<assign value='source.reason.coding.(1).code.value' property='target.Type.Code' action='set' />
<assign value='source.reason.coding.(1).display.value' property='target.Type.Description' action='set' />
<assign value='source.reason.coding.(1).version.value' property='target.Type.CodeSystemVersionId' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.reason.coding.(1).system.value)' property='target.Type.SDACodingStandard' action='set' />
</true>
</if>
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Utils).NormalizeTimeStamp(source.start.value)' property='target.FromTime' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).NormalizeTimeStamp(source.end.value)' property='target.ToTime' action='set' />
<assign value='source.comment.value' property='target.Notes' action='set' />
<code>
<![CDATA[ set iCareProvider = 1]]></code>
<foreach property='source.participant()' key='k2' >
<if condition='(..StartsWith(source.participant.(k2).actor.reference.value,"#")) &amp;&amp; (iCareProvider = 1)' >
<true>
<foreach property='source.contained()' key='k3' >
<if condition='"#"_source.contained.(k3).Practitioner.id.value = source.participant.(k2).actor.reference.value' >
<true>
<subtransform class='HS.FHIR.DTL.ToSDA.SubTransform.Practitioner' targetObj='target.CareProvider' sourceObj='source.contained.(k3).Practitioner' />
<code>
<![CDATA[ set iCareProvider = 0]]></code>
</true>
</if>
</foreach>
</true>
</if>
</foreach>
<code>
<![CDATA[ set iLocation = 1]]></code>
<foreach property='source.participant()' key='k4' >
<if condition='(..StartsWith(source.participant.(k4).actor.reference.value,"#")) &amp;&amp; (iLocation = 1)' >
<true>
<foreach property='source.contained()' key='k5' >
<if condition='"#"_source.contained.(k5).Location.id.value = source.participant.(k4).actor.reference.value' >
<true>
<subtransform class='HS.FHIR.DTL.ToSDA.SubTransform.Location' targetObj='target.Location' sourceObj='source.contained.(k5).Location' />
<code>
<![CDATA[ set iLocation = 0]]></code>
</true>
</if>
</foreach>
</true>
</if>
</foreach>
</transform>
}

}
