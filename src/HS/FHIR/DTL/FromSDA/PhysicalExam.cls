Class HS.FHIR.DTL.FromSDA.PhysicalExam Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.PhysicalExam, HS.FHIR.vDSTU2.Model.Resource.Observation) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.PhysicalExam' targetClass='HS.FHIR.vDSTU2.Model.Resource.Observation' create='new' language='objectscript' >
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
<assign value='"final"' property='target.status.value' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).FHIRDateTime(source.PhysExamTime)' property='target.effectiveDateTime.value' action='set' />
<subtransform class='HS.FHIR.DTL.FromSDA.SubTransform.PatientReference' targetObj='target.subject' sourceObj='target' aux='.aux' />
<if condition='(source.EncounterNumber &apos;= "") &amp;&amp; ($G(aux("EncounterResourceIds",source.EncounterNumber)) &apos;= "")' >
<true>
<assign value='"Encounter/"_aux("EncounterResourceIds",source.EncounterNumber)' property='target.encounter.reference.value' action='set' />
<assign value='source.EncounterNumber' property='target.encounter.display.value' action='set' />
</true>
</if>
<subtransform class='HS.FHIR.DTL.FromSDA.SubTransform.CodeTableTranslated' sourceObj='source.PhysExamObs' targetObj='target.code' />
<assign value='"exam"' property='target.category.coding.(1).code.value' action='set' />
<assign value='"Exam"' property='target.category.coding.(1).display.value' action='set' />
<assign value='"http://hl7.org/fhir/observation-category"' property='target.category.coding.(1).system.value' action='set' />
<assign value='"Exam"' property='target.category.text.value' action='set' />
<subtransform class='HS.FHIR.DTL.FromSDA.SubTransform.CodeTableTranslated' sourceObj='source.PhysExamCode' targetObj='target.code' />
<assign value='source.NoteText' property='target.comments.value' action='set' />
<subtransform class='HS.FHIR.DTL.FromSDA.SubTransform.CodeTableTranslated' sourceObj='source.PhysExamObsValue' targetObj='target.valueCodeableConcept' />
</transform>
}

}