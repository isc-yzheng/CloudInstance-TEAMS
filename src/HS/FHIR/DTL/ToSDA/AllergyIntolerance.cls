Class HS.FHIR.DTL.ToSDA.AllergyIntolerance Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.vDSTU2.Model.Resource.AllergyIntolerance, HS.SDA3.Allergy) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.vDSTU2.Model.Resource.AllergyIntolerance' targetClass='HS.SDA3.Allergy' create='new' language='objectscript' >
<if condition='source.identifier.Count()&gt;0' >
<true>
<assign value='source.identifier.(1).value.value' property='target.ExternalId' action='set' />
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Utils).NormalizeTimeStamp(source.recordedDate.value)' property='target.EnteredOn' action='set' />
<assign value='source.substance.text.value' property='target.Allergy.OriginalText' action='set' />
<if condition='($IsObject(source.substance.coding)) &amp;&amp; (source.substance.coding.Count() &gt; 0)' >
<true>
<assign value='source.substance.coding.(1).code.value' property='target.Allergy.Code' action='set' />
<assign value='source.substance.coding.(1).display.value' property='target.Allergy.Description' action='set' />
<assign value='source.substance.coding.(1).version.value' property='target.Allergy.CodeSystemVersionId' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.substance.coding.(1).system.value)' property='target.Allergy.SDACodingStandard' action='set' />
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Utils).LookupFHIR("ToSDAAllergyStatus",source.status.value,"A",3)' property='target.Status' action='set' />
<if condition='source.category.value = "food"' >
<true>
<assign value='"414285001"' property='target.AllergyCategory.Code' action='set' />
<assign value='"Food allergy"' property='target.AllergyCategory.Description' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI("http://snomed.info/sct")' property='target.AllergyCategory.SDACodingStandard' action='set' />
</true>
<false>
<if condition='source.category.value = "medication"' >
<true>
<assign value='"416098002"' property='target.AllergyCategory.Code' action='set' />
<assign value='"Drug allergy"' property='target.AllergyCategory.Description' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI("http://snomed.info/sct")' property='target.AllergyCategory.SDACodingStandard' action='set' />
</true>
<false>
<if condition='source.category.value = "environment"' >
<true>
<assign value='"426232007"' property='target.AllergyCategory.Code' action='set' />
<assign value='"Environmental allergy"' property='target.AllergyCategory.Description' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI("http://snomed.info/sct")' property='target.AllergyCategory.SDACodingStandard' action='set' />
</true>
<false>
<if condition='source.category.value = "other"' >
<true>
<assign value='"other"' property='target.AllergyCategory.Code' action='set' />
<assign value='"other allergy"' property='target.AllergyCategory.Description' action='set' />
</true>
</if>
</false>
</if>
</false>
</if>
</false>
</if>
<if condition='source.reaction.Count() &gt; 0' >
<true>
<if condition='(source.reaction.(1).manifestation.Count() &gt; 0) &amp;&amp; ($IsObject(source.reaction.(1).manifestation.(1).coding)) &amp;&amp; (source.reaction.(1).manifestation.(1).coding.Count() &gt; 0)' >
<true>
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.reaction.(1).manifestation.(1).coding.(1).system.value)' property='target.Reaction.SDACodingStandard' action='set' />
</true>
</if>
<assign value='source.reaction.(1).certainty.value' property='target.Certainty.Code' action='set' />
<assign value='source.reaction.(1).certainty.value' property='target.Certainty.Description' action='set' />
<if condition='source.reaction.(1).severity.value = "mild"' >
<true>
<assign value='"255604002"' property='target.Severity.Code' action='set' />
<assign value='"Mild"' property='target.Severity.Description' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI("http://snomed.info/sct")' property='target.Severity.SDACodingStandard' action='set' />
</true>
<false>
<if condition='source.reaction.(1).severity.value = "moderate"' >
<true>
<assign value='"6736007"' property='target.Severity.Code' action='set' />
<assign value='"Moderate"' property='target.Severity.Description' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI("http://snomed.info/sct")' property='target.Severity.SDACodingStandard' action='set' />
</true>
<false>
<if condition='source.reaction.(1).severity.value = "severe"' >
<true>
<assign value='"24484000"' property='target.Severity.Code' action='set' />
<assign value='"Severe"' property='target.Severity.Description' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI("http://snomed.info/sct")' property='target.Severity.SDACodingStandard' action='set' />
</true>
</if>
</false>
</if>
</false>
</if>
<if condition='source.reaction.(1).manifestation.Count() &gt; 0' >
<true>
<assign value='source.reaction.(1).manifestation.(1).text.value' property='target.Reaction.OriginalText' action='set' />
<if condition='source.reaction.(1).manifestation.(1).coding.Count() &gt; 0' >
<true>
<assign value='source.reaction.(1).manifestation.(1).coding.(1).code.value' property='target.Reaction.Code' action='set' />
<assign value='source.reaction.(1).manifestation.(1).coding.(1).display.value' property='target.Reaction.Description' action='set' />
<assign value='source.reaction.(1).manifestation.(1).coding.(1).version.value' property='target.Reaction.CodeSystemVersionId' action='set' />
</true>
</if>
</true>
</if>
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Utils).NormalizeTimeStamp(source.onset.value)' property='target.FromTime' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).NormalizeTimeStamp(source.lastOccurence.value)' property='target.ToTime' action='set' />
<assign value='source.note.text.value' property='target.Comments' action='set' />
<if condition='..StartsWith(source.recorder.reference.value,"#") ' >
<true>
<foreach property='source.contained()' key='k2' >
<if condition='"#"_source.contained.(k2).Practitioner.id.value = source.recorder.reference.value' >
<true>
<subtransform class='HS.FHIR.DTL.ToSDA.SubTransform.Practitioner' targetObj='target.Clinician' sourceObj='source.contained.(k2).Practitioner' />
</true>
</if>
</foreach>
</true>
</if>
</transform>
}

}
