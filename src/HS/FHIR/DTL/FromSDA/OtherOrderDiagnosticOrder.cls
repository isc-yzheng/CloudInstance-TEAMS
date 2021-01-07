Class HS.FHIR.DTL.FromSDA.OtherOrderDiagnosticOrder Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.OtherOrder, HS.FHIR.vDSTU2.Model.Resource.DiagnosticOrder) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.OtherOrder' targetClass='HS.FHIR.vDSTU2.Model.Resource.DiagnosticOrder' create='new' language='objectscript' >
<annotation>This transform uses the reserved DTL input parameter named &#39;aux&#39;.
For this transform, aux is a local array of strings.  The values held in aux were generated by the SDA to FHIR DTL framework prior to calling into this transform.
aux("ResourceId"): FHIR resource id to assign to the resource being created by this transform.
aux("PatientResourceId"): FHIR resource id for the patient represented by the Patient object in the SDA Container being transformed.
aux("EncounterResourceIds", sda_encounter_number) = FHIR resource id for the Encounters from the SDA Container.</annotation>
<assign value='$G(aux("ResourceId"))' property='target.id.value' action='set' />
<if condition='source.ExternalId &apos;= ""' >
<true>
<assign value='"official"' property='target.identifier.(1).use.value' action='set' />
<assign value='"ExternalId"' property='target.identifier.(1).type.text.value' action='set' />
<assign value='source.ExternalId' property='target.identifier.(1).value.value' action='set' />
</true>
</if>
<subtransform class='HS.FHIR.DTL.FromSDA.SubTransform.PatientReference' targetObj='target.subject' sourceObj='target' aux='.aux' />
<if condition='(source.EncounterNumber &apos;= "") &amp;&amp; ($G(aux("EncounterResourceIds",source.EncounterNumber)) &apos;= "")' >
<true>
<assign value='"Encounter/"_aux("EncounterResourceIds",source.EncounterNumber)' property='target.encounter.reference.value' action='set' />
<assign value='source.EncounterNumber' property='target.encounter.display.value' action='set' />
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Utils).LookupFHIR("FromSDALabOrderDiagnosticOrderStatus",source.Status,,0)' property='target.status.value' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).LookupFHIR("FromSDALabOrderDiagnosticOrderPriority",source.Priority.Description,,0)' property='target.priority.value' action='set' />
<subtransform class='HS.FHIR.DTL.FromSDA.SubTransform.CodeTableTranslated' sourceObj='source.ReasonForStudy' targetObj='target.reason.(1)' />
<assign value='source.Comments' property='target.note.(1).text.value' action='set' />
<if condition='target.id.value &apos;= "internalDiagnosticOrder"' disabled='1'>
<true>
<foreach property='source.Specimens()' key='k1' >
<assign value='"#Specimen"_k1' property='target.specimen.(k1).reference.value' action='set' />
<assign value='source.Specimens.(k1).SpecimenType.Description' property='target.specimen.(k1).display.value' action='set' />
<subtransform class='HS.FHIR.DTL.FromSDA.SubTransform.Specimen' targetObj='target.contained.(k1+1).Specimen' sourceObj='source.Specimens.(k1)' aux='.aux' />
<assign value='"Specimen"_k1' property='target.contained.(k1+1).Specimen.id.value' action='set' />
</foreach>
<if condition='##class(HS.FHIR.DTL.Utils).CPIsDefined(source,"OrderedBy")' >
<true>
<assign value='"#"_source.OrderedBy.InternalReference' property='target.orderer.reference.value' action='set' />
<assign value='source.OrderedBy.Name.GivenName_" "_source.OrderedBy.Name.FamilyName' property='target.orderer.display.value' action='set' />
<subtransform class='HS.FHIR.DTL.FromSDA.SubTransform.CareProvider' targetObj='target.contained.(1).Practitioner' sourceObj='source.OrderedBy' />
</true>
</if>
</true>
</if>

</transform>
}

}