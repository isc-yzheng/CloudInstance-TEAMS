Class HS.FHIR.DTL.ToSDA.SubTransform.MedicationDrugProduct Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.vDSTU2.Model.Resource.Medication, HS.SDA3.Medication) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.vDSTU2.Model.Resource.Medication' targetClass='HS.SDA3.Medication' create='existing' language='objectscript' >
<if condition='$IsObject(source.code)' >
<true>
<assign value='source.code.text.value' property='target.DrugProduct.OriginalText' action='set' />
<assign value='source.code.coding.(1).display.value' property='target.DrugProduct.Description' action='set' />
<assign value='source.code.coding.(1).code.value' property='target.DrugProduct.Code' action='set' />
<assign value='source.code.coding.(1).version.value' property='target.DrugProduct.CodeSystemVersionId' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.code.coding.(1).system.value)' property='target.DrugProduct.SDACodingStandard' action='set' />
</true>
</if>
<if condition='(source.isBrand.value &apos;= "") &amp;&amp; (source.isBrand.value &apos;= 1)' >
<true>
<assign value='source.code.coding.(1).display.value' property='target.DrugProduct.ProductName' action='set' />
<assign value='source.code.coding.(1).display.value' property='target.DrugProduct.Generic.OriginalText' action='set' />
<assign value='source.code.coding.(1).display.value' property='target.DrugProduct.Generic.Description' action='set' />
<assign value='source.code.coding.(1).code.value' property='target.DrugProduct.Generic.Code' action='set' />
</true>
</if>
<if condition='(target.OrderItem.Code = "") &amp;&amp; (target.OrderItem.Description = "") &amp;&amp; (target.OrderItem.OriginalText = "")' >
<true>
<subtransform class='HS.FHIR.DTL.ToSDA.SubTransform.MedicationOrderItem' targetObj='target' sourceObj='source' />
</true>
</if>
</transform>
}

}
