Class HS.FHIR.DTL.ToSDA.Encounter Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.vDSTU2.Model.Resource.Encounter, HS.SDA3.Encounter) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.vDSTU2.Model.Resource.Encounter' targetClass='HS.SDA3.Encounter' create='new' language='objectscript' >
<if condition='source.identifier.Count()&gt;0' >
<true>
<assign value='source.identifier.(1).value.value' property='target.EncounterNumber' action='set' />
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Utils).NormalizeTimeStamp(source.period.start.value)' property='target.FromTime' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).NormalizeTimeStamp(source.period.end.value)' property='target.ToTime' action='set' />
<foreach property='source.type()' key='k2' >
<if condition='k2=1' >
<true>
<assign value='source.type.(1).text.value' property='target.AdmissionType.OriginalText' action='set' />
<if condition='source.type.(1).coding.Count() &gt; 0' >
<true>
<assign value='source.type.(1).coding.(1).code.value' property='target.AdmissionType.Code' action='set' />
<assign value='source.type.(1).coding.(1).display.value' property='target.AdmissionType.Description' action='set' />
<assign value='source.type.(1).coding.(1).version.value' property='target.AdmissionType.CodeSystemVersionId' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.type.(1).coding.(1).system.value)' property='target.AdmissionType.SDACodingStandard' action='set' />
</true>
</if>
</true>
</if>
</foreach>
<if condition='$IsObject(source.priority)' >
<true>
<assign value='source.priority.text.value' property='target.Priority.OriginalText' action='set' />
<if condition='source.priority.coding.Count() &gt; 0' >
<true>
<assign value='source.priority.coding.(1).code.value' property='target.Priority.Code' action='set' />
<assign value='source.priority.coding.(1).display.value' property='target.Priority.Description' action='set' />
<assign value='source.priority.coding.(1).version.value' property='target.Priority.CodeSystemVersionId' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.priority.coding.(1).system.value)' property='target.Priority.SDACodingStandard' action='set' />
</true>
</if>
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Utils).LookupFHIR("ToSDAEncounterEncounterType",source.class.value,"O",3)' property='target.EncounterType' action='set' />
<if condition='source.reason.Count() &gt; 0' >
<true>
<assign value='source.reason.(1).text.value' property='target.AdmitReason.OriginalText' action='set' />
<if condition='source.reason.(1).coding.Count() &gt; 0' >
<true>
<assign value='source.reason.(1).coding.(1).code.value' property='target.AdmitReason.Code' action='set' />
<assign value='source.reason.(1).coding.(1).display.value' property='target.AdmitReason.Description' action='set' />
<assign value='source.reason.(1).coding.(1).version.value' property='target.AdmitReason.CodeSystemVersionId' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.reason.(1).coding.(1).system.value)' property='target.AdmitReason.SDACodingStandard' action='set' />
</true>
</if>
</true>
</if>
<if condition='$IsObject(source.hospitalization)' >
<true>
<if condition='$IsObject(source.hospitalization.admitSource)' >
<true>
<assign value='source.hospitalization.admitSource.text.value' property='target.AdmissionSource.OriginalText' action='set' />
<if condition='source.hospitalization.admitSource.coding.Count() &gt; 0' >
<true>
<assign value='source.hospitalization.admitSource.coding.(1).code.value' property='target.AdmissionSource.Code' action='set' />
<assign value='source.hospitalization.admitSource.coding.(1).display.value' property='target.AdmissionSource.Description' action='set' />
<assign value='source.hospitalization.admitSource.coding.(1).version.value' property='target.AdmissionSource.CodeSystemVersionId' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.hospitalization.admitSource.coding.(1).system.value)' property='target.AdmissionSource.SDACodingStandard' action='set' />
</true>
</if>
</true>
</if>
<if condition='$IsObject(source.hospitalization.dischargeDisposition)' >
<true>
<assign value='source.hospitalization.dischargeDisposition.text.value' property='target.SeparationMode.OriginalText' action='set' />
<if condition='source.hospitalization.dischargeDisposition.coding.Count() &gt; 0' >
<true>
<assign value='source.hospitalization.dischargeDisposition.coding.(1).code.value' property='target.SeparationMode.Code' action='set' />
<assign value='source.hospitalization.dischargeDisposition.coding.(1).display.value' property='target.SeparationMode.Description' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.hospitalization.dischargeDisposition.coding.(1).system.value)' property='target.SeparationMode.SDACodingStandard' action='set' />
<assign value='source.hospitalization.dischargeDisposition.coding.(1).version.value' property='target.SeparationMode.CodeSystemVersionId' action='set' />
</true>
</if>
</true>
</if>
</true>
</if>
<code>
<![CDATA[ set iConsulting = 1]]></code>
<code>
<![CDATA[ set iAdmitting = 1]]></code>
<code>
<![CDATA[ set iAttending = 1]]></code>
<code>
<![CDATA[ set iReferring = 1]]></code>
<foreach property='source.participant()' key='k5' >
<if condition='..StartsWith(source.participant.(k5).individual.reference.value,"#")' >
<true>
<foreach property='source.contained()' key='k6' >
<if condition='"#"_source.contained.(k6).Practitioner.id.value = source.participant.(k5).individual.reference.value' >
<true>
<if condition='source.participant.(k5).type.Count() = 0' >
<true>
<subtransform class='HS.FHIR.DTL.ToSDA.SubTransform.Practitioner' targetObj='target.AttendingClinicians.(iAttending)' sourceObj='source.contained.(k6).Practitioner' />
<code>
<![CDATA[ set iAttending= iAttending + 1]]></code>
</true>
<false>
<if condition='source.participant.(k5).type.(1).coding.(1).code.value = "CON"' >
<true>
<subtransform class='HS.FHIR.DTL.ToSDA.SubTransform.Practitioner' targetObj='target.ConsultingClinicians.(iConsulting)' sourceObj='source.contained.(k6).Practitioner' />
<code>
<![CDATA[ set iConsulting = iConsulting + 1]]></code>
</true>
<false>
<if condition='(source.participant.(k5).type.(1).coding.(1).code.value = "ATND") || (source.participant.(k5).type.(1).coding.(1).code.value = "")' >
<true>
<subtransform class='HS.FHIR.DTL.ToSDA.SubTransform.Practitioner' targetObj='target.AttendingClinicians.(iAttending)' sourceObj='source.contained.(k6).Practitioner' />
<code>
<![CDATA[ set iAttending= iAttending + 1]]></code>
</true>
<false>
<if condition='(source.participant.(k5).type.(1).coding.(1).code.value = "ADM") &amp;&amp; (iAdmitting=1)' >
<true>
<subtransform class='HS.FHIR.DTL.ToSDA.SubTransform.Practitioner' targetObj='target.AdmittingClinician' sourceObj='source.contained.(k6).Practitioner' />
<code>
<![CDATA[ set iAdmitting = 0]]></code>
</true>
<false>
<if condition='(source.participant.(k5).type.(1).coding.(1).code.value = "REF") &amp;&amp; (iReferring=1)' >
<true>
<subtransform class='HS.FHIR.DTL.ToSDA.SubTransform.PractitionerReferring' targetObj='target.ReferringClinician' sourceObj='source.contained.(k6).Practitioner' />
<code>
<![CDATA[ set iReferring = 0]]></code>
</true>
</if>
</false>
</if>
</false>
</if>
</false>
</if>
</false>
</if>
</true>
</if>
</foreach>
</true>
</if>
</foreach>
<if condition='..StartsWith(source.serviceProvider.reference.value,"#")' >
<true>
<foreach property='source.contained()' key='k7' >
<if condition='"#"_source.contained.(k7).Organization.id.value = source.serviceProvider.reference.value' >
<true>
<assign value='source.contained.(k7).Organization.name.id' property='target.HealthCareFacility.Code' action='set' />
<assign value='source.contained.(k7).Organization.name.value' property='target.HealthCareFacility.Description' action='set' />
<foreach property='source.contained.(k7).Organization.address()' key='k8' >
<if condition='k8=1' >
<true>
<subtransform class='HS.FHIR.DTL.ToSDA.SubTransform.OrganizationHealthCareFacility' targetObj='target.HealthCareFacility.Organization' sourceObj='source.contained.(k7).Organization' />
</true>
</if>
</foreach>
</true>
</if>
</foreach>
</true>
</if>
</transform>
}

}
