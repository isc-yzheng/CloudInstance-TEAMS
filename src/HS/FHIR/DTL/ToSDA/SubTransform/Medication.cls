Class HS.FHIR.DTL.ToSDA.SubTransform.Medication Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.vDSTU2.Model.Resource.Medication, HS.SDA3.Medication) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.vDSTU2.Model.Resource.Medication' targetClass='HS.SDA3.Medication' create='new' language='objectscript' >
<annotation>** DEPRECATED ** Please use either the MedicationDrugProduct or MedicationOrderItem sub transforms.</annotation>
<if condition='$IsObject(source.code)' >
<true>
<assign value='source.code.text.value' property='target.OrderItem.OriginalText' action='set' />
<assign value='source.code.coding.(1).display.value' property='target.OrderItem.Description' action='set' />
<assign value='source.code.coding.(1).code.value' property='target.OrderItem.Code' action='set' />
<assign value='source.code.coding.(1).version.value' property='target.OrderItem.CodeSystemVersionId' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.code.coding.(1).system.value)' property='target.OrderItem.SDACodingStandard' action='set' />
</true>
</if>
</transform>
}

}
