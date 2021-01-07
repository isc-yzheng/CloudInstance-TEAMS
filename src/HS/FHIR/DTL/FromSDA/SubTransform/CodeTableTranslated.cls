Class HS.FHIR.DTL.FromSDA.SubTransform.CodeTableTranslated Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.CodeTableTranslated, HS.FHIR.vDSTU2.Model.Base.CodeableConcept) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.CodeTableTranslated' targetClass='HS.FHIR.vDSTU2.Model.Base.CodeableConcept' create='new' language='objectscript' >
<if condition='(source.Code_source.Description_source.OriginalText) &apos;= ""' >
<true>
<assign value='source.OriginalText' property='target.text.value' action='set' />
<assign value='source.Code' property='target.coding.(1).code.value' action='set' />
<assign value='source.Description' property='target.coding.(1).display.value' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetURIForCode(source.SDACodingStandard)' property='target.coding.(1).system.value' action='set' />
<assign value='source.CodeSystemVersionId' property='target.coding.(1).version.value' action='set' />
</true>
</if>
</transform>
}

}
