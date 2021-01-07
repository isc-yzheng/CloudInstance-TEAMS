Class HS.FHIR.DTL.ToSDA.SubTransform.RadObservationResult Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.vDSTU2.Model.Resource.Observation, HS.SDA3.Result) ]
{

Parameter IGNOREMISSINGtarget = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

Parameter IGNOREMISSINGSOURCE = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.vDSTU2.Model.Resource.Observation' targetClass='HS.SDA3.Result' create='new' language='objectscript' >
<assign value='"IM"' property='target.ResultType' action='set' />
<assign value='source.valueAttachment.title.value' property='target.DocumentName' action='set' />
<assign value='source.valueAttachment.url.value' property='target.DocumentURL' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).NormalizeTimeStamp(source.issued.value)' property='target.ResultTime' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).NormalizeTimeStamp(source.effectivePeriod.start.value)' property='target.FromTime' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).NormalizeTimeStamp(source.effectivePeriod.end.value)' property='target.ToTime' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).LookupFHIR("ToSDAObservationRadResultStatus",source.status.value,"final",3)' property='target.ResultStatus' action='set' />
<if condition='source.valueAttachment.data.value &apos;= ""' >
<true>
<if condition='source.valueAttachment.contentType.value = "text/plain"' >
<true>
<assign value='"TXT"' property='target.FileType' action='set' />
<assign value='source.valueAttachment.data.value' property='target.ResultText' action='set' />
</true>
<false>
<if condition='source.valueAttachment.contentType.value = "application/pdf"' >
<true>
<assign value='"PDF"' property='target.FileType' action='set' />
</true>
<false>
<if condition='source.valueAttachment.contentType.value = "application/rtf"' >
<true>
<assign value='"RTF"' property='target.FileType' action='set' />
</true>
</if>
</false>
</if>
<code>
<![CDATA[ do target.Stream.Write(source.valueAttachment.data.value) ]]></code>
</false>
</if>
</true>
</if>
<code>
<![CDATA[ set iPerformer = 1
 set iOrganization =1 ]]></code>
<foreach property='source.performer()' key='k1' >
<if condition='..StartsWith(source.performer.(k1).reference.value,"#")' >
<true>
<foreach property='source.contained()' key='k2' >
<if condition='(source.performer.(k1).reference.value = "#"_source.contained.(k2).Organization.id.value) &amp;&amp; (iOrganization = 1)' >
<true>
<code>
<![CDATA[ set iOrganization = 2]]></code>
<assign value='source.contained.(k2).Organization.name.id' property='target.EnteredAt.Code' action='set' />
<assign value='source.contained.(k2).Organization.name.value' property='target.PerformedAt.Description' action='set' />
<subtransform class='HS.FHIR.DTL.ToSDA.SubTransform.Address' targetObj='target.PerformedAt.Address' sourceObj='source.contained.(k2).Organization.address.(1)' />
<foreach property='source.contained.(k2).Organization.telecom()' key='k3' >
<subtransform class='HS.FHIR.DTL.ToSDA.SubTransform.ContactPoint' targetObj='target.PerformedAt.ContactInfo' sourceObj='source.contained.(k2).Organization.telecom.(k3)' />
</foreach>
</true>
<false>
<if condition='(source.performer.(k1).reference.value = "#"_source.contained.(k2).Organization.id.value) &amp;&amp; (iOrganization = 2)' >
<true>
<assign value='source.contained.(k2).Organization.name.id' property='target.EnteredAt.Code' action='set' />
<assign value='source.contained.(k2).Organization.name.value' property='target.EnteredAt.Description' action='set' />
<subtransform class='HS.FHIR.DTL.ToSDA.SubTransform.Address' targetObj='target.EnteredAt.Address' sourceObj='source.contained.(k2).Organization.address.(1)' />
<foreach property='source.contained.(k2).Organization.telecom()' key='k4' >
<subtransform class='HS.FHIR.DTL.ToSDA.SubTransform.ContactPoint' targetObj='target.EnteredAt.ContactInfo' sourceObj='source.contained.(k2).Organization.telecom.(k4)' />
</foreach>
</true>
</if>
</false>
</if>
</foreach>
</true>
</if>
</foreach>
</transform>
}

}
