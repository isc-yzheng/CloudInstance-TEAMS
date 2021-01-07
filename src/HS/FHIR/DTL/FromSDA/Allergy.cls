Class HS.FHIR.DTL.FromSDA.Allergy Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.Allergy, HS.FHIR.vDSTU2.Model.Resource.AllergyIntolerance) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.Allergy' targetClass='HS.FHIR.vDSTU2.Model.Resource.AllergyIntolerance' create='new' language='objectscript' >
<annotation>This transform uses the reserved DTL input parameter named &#39;aux&#39;.
For this transform, aux is a local array of strings.  The values held in aux were generated by the SDA to FHIR DTL framework prior to calling into this transform.
aux(&quot;ResourceId&quot;): FHIR resource id to assign to the resource being created by this transform.
aux(&quot;PatientResourceId&quot;): FHIR resource id for the patient represented by the Patient object in the SDA Container being transformed.</annotation>
<assign value='$G(aux("ResourceId"))' property='target.id.value' action='set' />
<if condition='source.ExternalId &apos;= ""' >
<true>
<assign value='"official"' property='target.identifier.(1).use.value' action='set' />
<assign value='"ExternalId"' property='target.identifier.(1).type.text.value' action='set' />
<assign value='source.ExternalId' property='target.identifier.(1).value.value' action='set' />
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Utils).FHIRDateTime(source.EnteredOn)' property='target.recordedDate.value' action='set' />
<subtransform class='HS.FHIR.DTL.FromSDA.SubTransform.CodeTableTranslated' targetObj='target.substance' sourceObj='source.Allergy' />
<assign value='##class(HS.FHIR.DTL.Utils).LookupFHIR("FromSDAAllergyStatus",source.Status,"active",3)' property='target.status.value' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).LookupFHIR("FromSDAAllergyCategory",source.AllergyCategory.Code,"other",3)' property='target.category.value' action='set' />
<subtransform class='HS.FHIR.DTL.FromSDA.SubTransform.PatientReference' targetObj='target.patient' sourceObj='target' aux='.aux' />
<if condition='##class(HS.FHIR.DTL.Utils).CTIsDefined(source,"Reaction")' >
<true>
<assign value='##class(HS.FHIR.DTL.Utils).LookupFHIR("FromSDAAllergyCertainty",source.Certainty.Description)' property='target.reaction.(1).certainty.value' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).LookupFHIR("FromSDAAllergySeverity",source.Severity.Code)' property='target.reaction.(1).severity.value' action='set' />
<subtransform class='HS.FHIR.DTL.FromSDA.SubTransform.CodeTableTranslated' targetObj='target.reaction.(1).manifestation.(1)' sourceObj='source.Reaction' />
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Utils).FHIRDateTime(source.FromTime)' property='target.onset.value' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).FHIRDateTime(source.ToTime)' property='target.lastOccurence.value' action='set' />
<if condition='source.Comments &apos;= ""'>
<true>
<assign value='source.Comments' property='target.note.text.value' action='set' />
</true>
</if>
<if condition='##class(HS.FHIR.DTL.Utils).CPIsDefined(source,"Clinician")' >
<true>
<assign value='"#"_source.Clinician.InternalReference' property='target.recorder.reference.value' action='set' />
<assign value='source.Clinician.Name.GivenName_" "_source.Clinician.Name.FamilyName' property='target.recorder.display.value' action='set' />
<subtransform class='HS.FHIR.DTL.FromSDA.SubTransform.CareProvider' targetObj='target.contained.(1).Practitioner' sourceObj='source.Clinician' />
</true>
</if>
</transform>
}

}