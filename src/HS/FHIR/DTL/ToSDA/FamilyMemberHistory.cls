Class HS.FHIR.DTL.ToSDA.FamilyMemberHistory Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.vDSTU2.Model.Resource.FamilyMemberHistory, HS.SDA3.FamilyHistory) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.vDSTU2.Model.Resource.FamilyMemberHistory' targetClass='HS.SDA3.FamilyHistory' create='new' language='objectscript' >
<if condition='source.identifier.Count()&gt;0' >
<true>
<assign value='source.identifier.(1).value.value' property='target.ExternalId' action='set' />
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Utils).NormalizeTimeStamp(source.date.value)' property='target.UpdatedOn' action='set' />
<assign value='source.relationship.text.value' property='target.FamilyMember.OriginalText' action='set' />
<assign value='source.relationship.coding.(1).display.id' property='target.FamilyMember.Description' action='set' />
<assign value='source.relationship.coding.(1).code.value' property='target.FamilyMember.Code' action='set' />
<assign value='source.relationship.coding.(1).version.value' property='target.FamilyMember.CodeSystemVersionId' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.relationship.coding.(1).system.value)' property='target.FamilyMember.SDACodingStandard' action='set' />
<foreach property='source.condition()' key='k2' >
<if condition='k2=1' >
<true>
<assign value='source.condition.(1).code.text.value' property='target.Diagnosis.OriginalText' action='set' />
<assign value='source.condition.(1).code.coding.(1).code.value' property='target.Diagnosis.Code' action='set' />
<assign value='source.condition.(1).code.coding.(1).display.value' property='target.Diagnosis.Description' action='set' />
<assign value='source.condition.(1).code.coding.(1).version.value' property='target.Diagnosis.CodeSystemVersionId' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.condition.(1).code.coding.(1).system.value)' property='target.Diagnosis.SDACodingStandard' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).NormalizeTimeStamp(source.condition.(1).onsetPeriod.start.value)' property='target.FromTime' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).NormalizeTimeStamp(source.condition.(1).onsetPeriod.end.value)' property='target.ToTime' action='set' />
</true>
</if>
</foreach>
<if condition='target.ToTime = ""' >
<true>
<assign value='"A"' property='target.Status' action='set' />
</true>
<false>
<assign value='"I"' property='target.Status' action='set' />
</false>
</if>
<assign value='source.note.text.value' property='target.NoteText' action='set' />
</transform>
}

}
