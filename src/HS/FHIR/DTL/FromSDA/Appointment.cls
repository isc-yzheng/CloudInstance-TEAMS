Class HS.FHIR.DTL.FromSDA.Appointment Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.Appointment, HS.FHIR.vDSTU2.Model.Resource.Appointment) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.Appointment' targetClass='HS.FHIR.vDSTU2.Model.Resource.Appointment' create='new' language='objectscript' >
<annotation>This transform uses the reserved DTL input parameter named &#39;aux&#39;.
For this transform, aux is a local array of strings.  The values held in aux were generated by the SDA to FHIR DTL framework prior to calling into this transform.
aux("ResourceId"): FHIR resource id to assign to the resource being created by this transform.
aux("PatientResourceId"): FHIR resource id for the patient represented by the Patient object in the SDA Container being transformed.</annotation>
<assign value='$G(aux("ResourceId"))' property='target.id.value' action='set' />
<code>
<![CDATA[ set iIdentifier = 1]]></code>
<if condition='source.PlacerApptId &apos;= ""' >
<true>
<assign value='source.PlacerApptId' property='target.identifier.(iIdentifier).value.value' action='set' />
<code>
<![CDATA[ set iIdentifier = iIdentifier + 1]]></code>
</true>
</if>
<if condition='source.FillerApptId &apos;= ""' >
<true>
<assign value='source.FillerApptId' property='target.identifier.(iIdentifier).value.value' action='set' />
<code>
<![CDATA[ set iIdentifier = iIdentifier + 1]]></code>
</true>
</if>
<if condition='source.ExternalId &apos;= ""' >
<true>
<assign value='"official"' property='target.identifier.(iIdentifier).use.value' action='set' />
<assign value='"ExternalId"' property='target.identifier.(iIdentifier).type.text.value' action='set' />
<assign value='source.ExternalId' property='target.identifier.(iIdentifier).value.value' action='set' />
<code>
<![CDATA[ set iIdentifier = iIdentifier + 1]]></code>
</true>
</if>
<if condition='source.NoShow = 1' >
<true>
<assign value='"noshow"' property='target.status.value' action='set' />
</true>
<false>
<assign value='##class(HS.FHIR.DTL.Utils).LookupFHIR("FromSDAAppointmentStatus",source.Status,"booked",3)' property='target.status.value' action='set' />
</false>
</if>
<subtransform class='HS.FHIR.DTL.FromSDA.SubTransform.CodeTableTranslated' targetObj='target.type' sourceObj='source.OrderItem' />
<subtransform class='HS.FHIR.DTL.FromSDA.SubTransform.CodeTableTranslated' targetObj='target.reason' sourceObj='source.Type' />
<if condition='(source.FromTime &apos;= "") &amp;&amp; (source.ToTime &apos;= "")' >
<annotation>FHIR wants start and end to be either both populated or both blank.</annotation>
<true>
<assign value='##class(HS.FHIR.DTL.Utils).FHIRInstant(source.FromTime)' property='target.start.value' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).FHIRInstant(source.ToTime)' property='target.end.value' action='set' />
</true>
<false>
<if condition='target.status.value &apos;= "cancelled"' >
<true>
<if condition='source.FromTime &apos;= ""' >
<true>
<assign value='##class(HS.FHIR.DTL.Utils).FHIRDateTime(source.FromTime)' property='target.start.value' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).FHIRDateTime(source.FromTime)' property='target.end.value' action='set' />
</true>
<false>
<if condition='source.ToTime &apos;= ""' >
<true>
<assign value='##class(HS.FHIR.DTL.Utils).FHIRDateTime(source.ToTime)' property='target.start.value' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).FHIRDateTime(source.ToTime)' property='target.end.value' action='set' />
</true>
</if>
</false>
</if>
</true>
</if>
</false>
</if>
<assign value='source.Notes' property='target.comment.value' action='set' />
<assign value='source.Notes' property='target.description.value' action='set' />
<subtransform class='HS.FHIR.DTL.FromSDA.SubTransform.PatientReference' targetObj='target.participant.(1).actor' sourceObj='target' aux='.aux' />
<assign value='"Patient"' property='target.participant.(1).type.(1).text.value' action='set' />
<assign value='"http://hl7.org/fhir/v3/ParticipationType"' property='target.participant.(1).type.(1).coding.(1).system.value' action='set' />
<assign value='"v1"' property='target.participant.(1).type.(1).coding.(1).version.value' action='set' />
<assign value='"PART"' property='target.participant.(1).type.(1).coding.(1).code.value' action='set' />
<assign value='"Participation"' property='target.participant.(1).type.(1).coding.(1).display.value' action='set' />
<assign value='"accepted"' property='target.participant.(1).status.value' action='set' />
<if condition='##class(HS.FHIR.DTL.Utils).CPIsDefined(source,"CareProvider")' >
<true>
<assign value='"#"_source.CareProvider.InternalReference' property='target.participant.(2).actor.reference.value' action='set' />
<assign value='source.CareProvider.Name.GivenName_" "_source.CareProvider.Name.FamilyName' property='target.participant.(2).actor.display.value' action='set' />
<assign value='"Consultant Clinician"' property='target.participant.(2).type.(1).text.value' action='set' />
<assign value='"http://hl7.org/fhir/v3/ParticipationType"' property='target.participant.(2).type.(1).coding.(1).system.value' action='set' />
<assign value='"v1"' property='target.participant.(2).type.(1).coding.(1).version.value' action='set' />
<assign value='"CON"' property='target.participant.(2).type.(1).coding.(1).code.value' action='set' />
<assign value='"consultant"' property='target.participant.(2).type.(1).coding.(1).display.value' action='set' />
<subtransform class='HS.FHIR.DTL.FromSDA.SubTransform.CareProvider' targetObj='target.contained.(1).Practitioner' sourceObj='source.CareProvider' />
<assign value='"accepted"' property='target.participant.(2).status.value' action='set' />
</true>
</if>
<if condition='##class(HS.FHIR.DTL.Utils).HCFIsDefined(source,"Location")' >
<true>
<if condition='##class(HS.FHIR.DTL.Utils).CPIsDefined(source,"CareProvider")' >
<true>
<assign value='"#"_source.Location.InternalReference' property='target.participant.(3).actor.reference.value' action='set' />
<subtransform class='HS.FHIR.DTL.FromSDA.SubTransform.HealthCareFacility' targetObj='target.contained.(2).Location' sourceObj='source.Location' />
<assign value='"accepted"' property='target.participant.(3).status.value' action='set' />
</true>
<false>
<assign value='"#"_source.Location.InternalReference' property='target.participant.(2).actor.reference.value' action='set' />
<subtransform class='HS.FHIR.DTL.FromSDA.SubTransform.HealthCareFacility' targetObj='target.contained.(1).Location' sourceObj='source.Location' />
<assign value='"accepted"' property='target.participant.(2).status.value' action='set' />
</false>
</if>
</true>
</if>
</transform>
}

}