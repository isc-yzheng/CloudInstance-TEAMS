Class HS.FHIR.DTL.FromSDA.SubTransform.ResultRadObservation Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.Result, HS.FHIR.vDSTU2.Model.Resource.Observation) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.Result' targetClass='HS.FHIR.vDSTU2.Model.Resource.Observation' create='new' language='objectscript' >
<assign value='"radiology result"' property='target.code.text.value' action='set' />
<assign value='source.DocumentName' property='target.valueAttachment.title.value' action='set' />
<assign value='source.DocumentURL' property='target.valueAttachment.url.value' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).FHIRDateTime(source.ResultTime)' property='target.issued.value' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).FHIRDateTime(source.FromTime)' property='target.effectivePeriod.start.value' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).FHIRDateTime(source.ToTime)' property='target.effectivePeriod.end.value' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).LookupFHIR("FromSDARadOrderObservationStatus",source.ResultStatus,"final",3)' property='target.status.value' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).FHIRDateTime(source.AuthorizationTime)' property='target.effectiveDateTime.value' action='set' />
<if condition='source.ResultText &apos;= ""' >
<true>
<assign value='"text/plain"' property='target.valueAttachment.contentType.value' action='set' />
<assign value='source.ResultText' property='target.valueAttachment.data.value' action='set' />
</true>
<false>
<if condition='source.FileType = "PDF"' >
<true>
<assign value='"application/pdf"' property='target.valueAttachment.contentType.value' action='set' />
</true>
<false>
<if condition='source.FileType = "RTF"' >
<true>
<assign value='"application/rtf"' property='target.valueAttachment.contentType.value' action='set' />
</true>
<false>
<if condition='source.FileType = "TXT"' >
<true>
<assign value='"text/plain"' property='target.valueAttachment.contentType.value' action='set' />
</true>
</if>
</false>
</if>
</false>
</if>
<code>
<![CDATA[ do source.Stream.Rewind()]]></code>
<assign value='source.Stream.Read(3000000)' property='target.valueAttachment.data.value' action='set' />
</false>
</if>
<code>
<![CDATA[ set iContained = 1]]></code>
<if condition='##class(HS.FHIR.DTL.Utils).OrgIsDefined(source, "EnteredAt")' >
<true>
<assign value='source.EnteredAt.Description' property='target.performer.(iContained).display.value' action='set' />
<subtransform class='HS.FHIR.DTL.FromSDA.SubTransform.Address' targetObj='target.contained.(iContained).Organization.address.(1)' sourceObj='source.EnteredAt.Address' disabled='1' />
<assign value='source.EnteredAt.Code' property='target.contained.(iContained).Organization.name.id' action='set' />
<assign value='source.EnteredAt.Description' property='target.contained.(iContained).Organization.name.value' action='set' />
<code>
<![CDATA[ set iTelecom = 1]]></code>
<if condition='source.EnteredAt.ContactInfo.HomePhoneNumber &apos;= ""' >
<true>
<assign value='"phone"' property='target.contained.(iContained).Organization.telecom.(iTelecom).system.value' action='set' />
<assign value='"home"' property='target.contained.(iContained).Organization.telecom.(iTelecom).use.value' action='set' />
<assign value='source.EnteredAt.ContactInfo.HomePhoneNumber' property='target.contained.(iContained).Organization.telecom.(iTelecom).value.value' action='set' />
<code>
<![CDATA[ set iTelecom = iTelecom + 1]]></code>
</true>
</if>
<if condition='source.EnteredAt.ContactInfo.WorkPhoneNumber &apos;= ""' >
<true>
<assign value='"phone"' property='target.contained.(iContained).Organization.telecom.(iTelecom).system.value' action='set' />
<assign value='"work"' property='target.contained.(iContained).Organization.telecom.(iTelecom).use.value' action='set' />
<assign value='source.EnteredAt.ContactInfo.WorkPhoneNumber' property='target.contained.(iContained).Organization.telecom.(iTelecom).value.value' action='set' />
<code>
<![CDATA[ set iTelecom = iTelecom + 1]]></code>
</true>
</if>
<if condition='source.EnteredAt.ContactInfo.MobilePhoneNumber &apos;= ""' >
<true>
<assign value='"phone"' property='target.contained.(iContained).Organization.telecom.(iTelecom).system.value' action='set' />
<assign value='"mobile"' property='target.contained.(iContained).Organization.telecom.(iTelecom).use.value' action='set' />
<assign value='source.EnteredAt.ContactInfo.MobilePhoneNumber' property='target.contained.(iContained).Organization.telecom.(iTelecom).value.value' action='set' />
<code>
<![CDATA[ set iTelecom = iTelecom + 1]]></code>
</true>
</if>
<if condition='source.EnteredAt.ContactInfo.EmailAddress &apos;= ""' >
<true>
<assign value='"email"' property='target.contained.(iContained).Organization.telecom.(iTelecom).system.value' action='set' />
<assign value='source.EnteredAt.ContactInfo.EmailAddress' property='target.contained.(iContained).Organization.telecom.(iTelecom).value.value' action='set' />
<code>
<![CDATA[ set iTelecom = iTelecom + 1]]></code>
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Utils).CreateUUID()' property='target.contained.(iContained).Organization.id.value' action='set' />
<assign value='"#"_target.contained.(iContained).Organization.id.value' property='target.performer.(iContained).reference.value' action='set' />
<code>
<![CDATA[ set iContained = iContained + 1]]></code>
</true>
</if>
<if condition='##class(HS.FHIR.DTL.Utils).OrgIsDefined(source, "PerformedAt")' >
<true>
<assign value='source.PerformedAt.Description' property='target.performer.(iContained).display.value' action='set' />
<subtransform class='HS.FHIR.DTL.FromSDA.SubTransform.Address' targetObj='target.contained.(iContained).Organization.address.(1)' sourceObj='source.PerformedAt.Address' disabled='1' />
<assign value='source.PerformedAt.Code' property='target.contained.(iContained).Organization.name.id' action='set' />
<assign value='source.PerformedAt.Description' property='target.contained.(iContained).Organization.name.value' action='set' />
<code>
<![CDATA[ set iTelecom = 1]]></code>
<if condition='source.PerformedAt.ContactInfo.HomePhoneNumber &apos;= ""' >
<true>
<assign value='"phone"' property='target.contained.(iContained).Organization.telecom.(iTelecom).system.value' action='set' />
<assign value='"home"' property='target.contained.(iContained).Organization.telecom.(iTelecom).use.value' action='set' />
<assign value='source.PerformedAt.ContactInfo.HomePhoneNumber' property='target.contained.(iContained).Organization.telecom.(iTelecom).value.value' action='set' />
<code>
<![CDATA[ set iTelecom = iTelecom + 1]]></code>
</true>
</if>
<if condition='source.PerformedAt.ContactInfo.WorkPhoneNumber &apos;= ""' >
<true>
<assign value='"phone"' property='target.contained.(iContained).Organization.telecom.(iTelecom).system.value' action='set' />
<assign value='"work"' property='target.contained.(iContained).Organization.telecom.(iTelecom).use.value' action='set' />
<assign value='source.PerformedAt.ContactInfo.WorkPhoneNumber' property='target.contained.(iContained).Organization.telecom.(iTelecom).value.value' action='set' />
<code>
<![CDATA[ set iTelecom = iTelecom + 1]]></code>
</true>
</if>
<if condition='source.PerformedAt.ContactInfo.MobilePhoneNumber &apos;= ""' >
<true>
<assign value='"phone"' property='target.contained.(iContained).Organization.telecom.(iTelecom).system.value' action='set' />
<assign value='"mobile"' property='target.contained.(iContained).Organization.telecom.(iTelecom).use.value' action='set' />
<assign value='source.PerformedAt.ContactInfo.MobilePhoneNumber' property='target.contained.(iContained).Organization.telecom.(iTelecom).value.value' action='set' />
<code>
<![CDATA[ set iTelecom = iTelecom + 1]]></code>
</true>
</if>
<if condition='source.PerformedAt.ContactInfo.EmailAddress &apos;= ""' >
<true>
<assign value='"email"' property='target.contained.(iContained).Organization.telecom.(iTelecom).system.value' action='set' />
<assign value='source.PerformedAt.ContactInfo.EmailAddress' property='target.contained.(iContained).Organization.telecom.(iTelecom).value.value' action='set' />
<code>
<![CDATA[ set iTelecom = iTelecom + 1]]></code>
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Utils).CreateUUID()' property='target.contained.(iContained).Organization.id.value' action='set' />
<assign value='"#"_target.contained.(iContained).Organization.id.value' property='target.performer.(iContained).reference.value' action='set' />
<code>
<![CDATA[ set iContained = iContained + 1]]></code>
</true>
</if>
</transform>
}

}
