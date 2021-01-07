Class HS.FHIR.DTL.ToSDA.SubTransform.Specimen Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.vDSTU2.Model.Resource.Specimen, HS.SDA3.Specimen) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.vDSTU2.Model.Resource.Specimen' targetClass='HS.SDA3.Specimen' create='new' language='objectscript' >
<foreach property='source.identifier()' key='k1' >
<if condition='k1=1' >
<true>
<assign value='source.identifier.(k1).value.value' property='target.ExternalId' action='set' />
</true>
</if>
</foreach>
<assign value='source.type.text.value' property='target.SpecimenType.OriginalText' action='set' />
<if condition='($IsObject(source.type.coding)) &amp;&amp; (source.type.coding.Count() &gt; 0)' >
<true>
<assign value='source.type.coding.(1).display.value' property='target.SpecimenType.Description' action='set' />
<assign value='source.type.coding.(1).code.value' property='target.SpecimenType.Code' action='set' />
<assign value='source.type.coding.(1).version.value' property='target.SpecimenType.CodeSystemVersionId' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.type.coding.(1).system.value)' property='target.SpecimenType.SDACodingStandard' action='set' />
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Utils).NormalizeTimeStamp(source.receivedTime.value)' property='target.EnteredOn' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).NormalizeTimeStamp(source.collection.collectedDateTime.value)' property='target.FromTime' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).NormalizeTimeStamp(source.collection.collectedPeriod.start.value)' property='target.FromTime' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).NormalizeTimeStamp(source.collection.collectedPeriod.end.value)' property='target.ToTime' action='set' />
<assign value='source.collection.quantity.value.value' property='target.CollectionAmount' action='set' />
<assign value='source.collection.quantity.unit.value' property='target.CollectionAmountUnits.Description' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.collection.quantity.system.value)' property='target.CollectionAmountUnits.SDACodingStandard' action='set' />
<assign value='source.collection.quantity.code.value' property='target.CollectionAmountUnits.Code' action='set' />
<assign value='source.collection.method.text.value' property='target.CollectionMethod.OriginalText' action='set' />
<if condition='($IsObject(source.collection.method.coding)) &amp;&amp; (source.collection.method.coding.Count() &gt; 0)' >
<true>
<assign value='source.collection.method.coding.(1).display.value' property='target.CollectionMethod.Description' action='set' />
<assign value='source.collection.method.coding.(1).code.value' property='target.CollectionMethod.Code' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.collection.method.coding.(1).system.value)' property='target.CollectionMethod.SDACodingStandard' action='set' />
<assign value='source.collection.method.coding.(1).version.value' property='target.CollectionMethod.CodeSystemVersionId' action='set' />
</true>
</if>
<assign value='source.collection.bodySite.text.value' property='target.SpecimenSourceSite.OriginalText' action='set' />
<if condition='($IsObject(source.collection.bodySite.coding)) &amp;&amp; (source.collection.bodySite.coding.Count() &gt; 0)' >
<true>
<assign value='source.collection.bodySite.coding.(1).display.value' property='target.SpecimenSourceSite.Description' action='set' />
<assign value='source.collection.bodySite.coding.(1).code.value' property='target.SpecimenSourceSite.Code' action='set' />
<assign value='source.collection.bodySite.coding.(1).version.value' property='target.SpecimenSourceSite.CodeSystemVersionId' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.collection.bodySite.coding.(1).system.value)' property='target.SpecimenSourceSite.SDACodingStandard' action='set' />
</true>
</if>
</transform>
}

}
