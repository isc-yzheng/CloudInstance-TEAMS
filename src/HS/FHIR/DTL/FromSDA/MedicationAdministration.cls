Class HS.FHIR.DTL.FromSDA.MedicationAdministration Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.Medication, HS.FHIR.vDSTU2.Model.Resource.MedicationAdministration) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.Medication' targetClass='HS.FHIR.vDSTU2.Model.Resource.MedicationAdministration' create='new' language='objectscript' >
<assign value='$G(aux("ResourceId"))' property='target.id.value' action='set' />
<code>
<![CDATA[ set iPosition = aux("MedicationAdministrationPosition")]]></code>
<if condition='source.ExternalId  &apos;=""' >
<true>
<assign value='"official"' property='target.identifier.(1).use.value' action='set' />
<assign value='"ExternalId"' property='target.identifier.(1).type.text.value' action='set' />
<assign value='source.ExternalId' property='target.identifier.(1).value.value' action='set' />
</true>
</if>
<assign value='"MedicationOrder/"_$G(aux("MedicationOrderResourceId"))' property='target.prescription.reference.value' action='set' />
<subtransform class='HS.FHIR.DTL.FromSDA.SubTransform.PatientReference' targetObj='target.patient' sourceObj='target' aux='.aux' />
<if condition='(source.EncounterNumber &apos;= "") &amp;&amp; ($G(aux("EncounterResourceIds",source.EncounterNumber)) &apos;= "")' >
<true>
<assign value='"Encounter/"_aux("EncounterResourceIds",source.EncounterNumber)' property='target.encounter.reference.value' action='set' />
<assign value='source.EncounterNumber' property='target.encounter.display.value' action='set' />
</true>
</if>
<if condition='##class(HS.FHIR.DTL.Utils).CTIsDefined(source.Administrations.(iPosition),"RefusalReason")' >
<true>
<assign value='source.Administrations.(iPosition).RefusalReason.OriginalText' property='target.reasonNotGiven.(1).text.value' action='set' />
<assign value='"true"' property='target.wasNotGiven.value' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetURIForCode(source.Administrations.(iPosition).RefusalReason.SDACodingStandard)' property='target.reasonNotGiven.(1).coding.(1).system.value' action='set' />
<assign value='source.Administrations.(iPosition).RefusalReason.CodeSystemVersionId' property='target.reasonNotGiven.(1).coding.(1).version.value' action='set' />
<assign value='source.Administrations.(iPosition).RefusalReason.Code' property='target.reasonNotGiven.(1).coding.(1).code.value' action='set' />
<assign value='source.Administrations.(iPosition).RefusalReason.Description' property='target.reasonNotGiven.(1).coding.(1).display.value' action='set' />
</true>
<false>
<assign value='"false"' property='target.wasNotGiven.value' action='set' />
</false>
</if>
<assign value='"Medication/"_$G(aux("MedicationResourceId"))' property='target.medicationReference.reference.value' action='set' />
<assign value='source.Comments' property='target.note.value' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).LookupFHIR("FromSDAMedicationAdministrationStatus",source.Administrations.(iPosition).AdministrationStatus.Code,"completed")' property='target.status.value' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).FHIRDateTime(source.Administrations.(iPosition).FromTime)' property='target.effectiveTimePeriod.start.value' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).FHIRDateTime(source.Administrations.(iPosition).ToTime)' property='target.effectiveTimePeriod.end.value' action='set' />
<assign value='source.Administrations.(iPosition).AdministrationNotes' property='target.note.value' action='set' />
<assign value='source.Administrations.(iPosition).AdministrationSite.OriginalText' property='target.dosage.siteCodeableConcept.text.value' action='set' />
<assign value='source.Administrations.(iPosition).AdministrationSite.Description' property='target.dosage.siteCodeableConcept.coding.(1).display.value' action='set' />
<assign value='source.Administrations.(iPosition).AdministrationSite.Code' property='target.dosage.siteCodeableConcept.coding.(1).code.value' action='set' />
<assign value='source.Administrations.(iPosition).AdministrationSite.CodeSystemVersionId' property='target.dosage.siteCodeableConcept.coding.(1).version.value' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetURIForCode(source.Administrations.(iPosition).AdministrationSite.SDACodingStandard)' property='target.dosage.siteCodeableConcept.coding.(1).system.value' action='set' />
<assign value='source.Administrations.(iPosition).AdministeredAmount' property='target.dosage.quantity.value.value' action='set' />
<assign value='source.Administrations.(iPosition).AdministeredUnits' property='target.dosage.quantity.unit.value' action='set' />
<assign value='source.Route.OriginalText' property='target.dosage.route.text.value' action='set' />
<assign value='source.Route.Description' property='target.dosage.route.coding.(1).display.value' action='set' />
<assign value='source.Route.Code' property='target.dosage.route.coding.(1).code.value' action='set' />
<assign value='source.Route.CodeSystemVersionId' property='target.dosage.route.coding.(1).version.value' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetURIForCode(source.Route.SDACodingStandard)' property='target.dosage.route.coding.(1).system.value' action='set' />
<if condition='##class(HS.FHIR.DTL.Utils).CPIsDefined(source.Administrations.(1),"AdministeringProvider")' >
<true>
<assign value='"#"_source.Administrations.(iPosition).AdministeringProvider.InternalReference' property='target.practitioner.reference.value' action='set' />
<assign value='source.Administrations.(iPosition).AdministeringProvider.Name.GivenName_" "_source.Administrations.(1).AdministeringProvider.Name.FamilyName' property='target.practitioner.display.value' action='set' />
<subtransform class='HS.FHIR.DTL.FromSDA.SubTransform.CareProvider' targetObj='target.contained.(iPosition).Practitioner' sourceObj='source.Administrations.(iPosition).AdministeringProvider' />
</true>
</if>
</transform>
}

}
