Class HS.FHIR.DTL.ToSDA.SubTransform.ObservationLabResultItem Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.vDSTU2.Model.Resource.Observation, HS.SDA3.LabResultItem) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.vDSTU2.Model.Resource.Observation' targetClass='HS.SDA3.LabResultItem' create='new' language='objectscript' >
<if condition='source.identifier.Count()&gt;0' >
<true>
<assign value='source.identifier.(1).value.value' property='target.ExternalId' action='set' />
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Utils).LookupFHIR("ToSDAObservationLabResultItemStatus",source.status.value)' property='target.TestItemStatus' action='set' />
<assign value='source.code.text.value' property='target.TestItemCode.OriginalText' action='set' />
<if condition='($IsObject(source.code.coding)) &amp;&amp; (source.code.coding.Count() &gt; 0)' >
<true>
<assign value='source.code.coding.(1).code.value' property='target.TestItemCode.Code' action='set' />
<assign value='source.code.coding.(1).display.value' property='target.TestItemCode.Description' action='set' />
<assign value='source.code.coding.(1).version.value' property='target.TestItemCode.CodeSystemVersionId' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.code.coding.(1).system.value)' property='target.TestItemCode.SDACodingStandard' action='set' />
<if condition='##class(HS.FHIR.DTL.Utils).IsNumeric(source.valueQuantity.value.value)' >
<true>
<assign value='"1"' property='target.TestItemCode.IsNumeric' action='set' />
</true>
<false>
<assign value='"0"' property='target.TestItemCode.IsNumeric' action='set' />
</false>
</if>
</true>
</if>
<assign value='source.comments.value' property='target.Comments' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).NormalizeTimeStamp(source.effectiveDateTime.value)' property='target.ObservationTime' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).NormalizeTimeStamp(source.effectivePeriod.start.value)' property='target.FromTime' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).NormalizeTimeStamp(source.effectivePeriod.end.value)' property='target.ToTime' action='set' />
<if condition='($IsObject(source.interpretation)) &amp;&amp; ($IsObject(source.interpretation.coding)) &amp;&amp; (source.interpretation.coding.Count()&gt;0)' >
<true>
<assign value='source.interpretation.coding.(1).display.value' property='target.ResultInterpretation' action='set' />
</true>
</if>
<if condition='$IsObject(source.method)' >
<true>
<assign value='source.method.text.value' property='target.ObservationMethods.(1).OriginalText' action='set' />
<if condition='source.method.coding.Count() &gt; 0' >
<true>
<assign value='source.method.coding.(1).display.value' property='target.ObservationMethods.(1).Description' action='set' />
<assign value='source.method.coding.(1).code.value' property='target.ObservationMethods.(1).Code' action='set' />
<assign value='source.method.coding.(1).version.value' property='target.ObservationMethods.(1).CodeSystemVersionId' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.method.coding.(1).system.value)' property='target.ObservationMethods.(1).SDACodingStandard' action='set' />
</true>
</if>
</true>
</if>
<if condition='source.component.Count() &gt; 0' >
<true>
<assign value='source.component.(1).id' property='target.SubId' action='set' />
</true>
</if>
<if condition='source.referenceRange.Count()>0' >
<true>
<if condition='(source.referenceRange.(1).low.value.value = "") &amp;&amp; (source.referenceRange.(1).high.value.value = "") &amp;&amp; (source.referenceRange.(1).text.value &apos;= "")' >
<true>
<assign value='source.referenceRange.(1).text.value' property='target.ResultNormalRange' action='set' />
</true>
<false>
<if condition='(source.referenceRange.(1).low.value.value &apos;= "") &amp;&amp; (source.referenceRange.(1).high.value.value &apos;= "")' >
<true>
<assign value='source.referenceRange.(1).low.value.value_"-"_source.referenceRange.(1).high.value.value' property='target.ResultNormalRange' action='set' />
</true>
<false>
<if condition='(source.referenceRange.(1).low.value.value = "") &amp;&amp; (source.referenceRange.(1).high.value.value &apos;= "")' >
<true>
<assign value='"&lt;="_source.referenceRange.(1).high.value.value' property='target.ResultNormalRange' action='set' />
</true>
<false>
<if condition='(source.referenceRange.(1).low.value.value &apos;= "") &amp;&amp; (source.referenceRange.(1).high.value.value = "")' >
<true>
<assign value='"&gt;="_source.referenceRange.(1).low.value.value' property='target.ResultNormalRange' action='set' />
</true>
</if>
</false>
</if>
</false>
</if>
</false>
</if>
</true>
</if>
<if condition='$IsObject(source.valueString) ' >
<true>
<assign value='source.valueString.value' property='target.ResultValue' action='set' />
</true>
<false>
<if condition='$IsObject(source.valueRange)' >
<true>
<assign value='"From: "_source.valueRange.low.value.value_" To: "_source.valueRange.high.value.value' property='target.ResultValue' action='set' />
<if condition='source.valueRange.low.unit.value &apos;= ""' >
<true>
<assign value='source.valueRange.low.unit.value' property='target.ResultValueUnits' action='set' />
</true>
<false>
<assign value='source.valueRange.high.unit.value' property='target.ResultValueUnits' action='set' />
</false>
</if>
<assign value='source.valueRange.low.value.value_"/"_source.valueRange.high.value.value' property='target.ResultNormalRange' action='set' />
<if condition='source.valueRange.low.code &apos;= ""' >
<true>
<assign value='source.valueRange.low.code.value' property='target.ResultCodedValue.Code' action='set' />
<assign value='source.valueRange.low.code.value' property='target.ResultCodedValue.Description' action='set' />
</true>
<false>
<assign value='source.valueRange.high.code.value' property='target.ResultCodedValue.Code' action='set' />
<assign value='source.valueRange.high.code.value' property='target.ResultCodedValue.Description' action='set' />
</false>
</if>
</true>
<false>
<if condition='$IsObject(source.valueRatio)' >
<true>
<assign value='source.valueRatio.numerator.value.value_"/"_source.valueRatio.denominator.value.value' property='target.ResultValue' action='set' />
<if condition='source.valueRatio.numerator.unit.value &apos;= ""' >
<true>
<assign value='source.valueRatio.numerator.unit.value' property='target.ResultValueUnits' action='set' />
</true>
<false>
<assign value='source.valueRatio.denominator.unit.value' property='target.ResultValueUnits' action='set' />
</false>
</if>
<if condition='source.valueRatio.numerator.code.value &apos;= ""' >
<true>
<assign value='source.valueRatio.numerator.code.value' property='target.ResultCodedValue.Code' action='set' />
<assign value='source.valueRatio.numerator.code.value' property='target.ResultCodedValue.Description' action='set' />
</true>
<false>
<assign value='source.valueRatio.denominator.code.value' property='target.ResultCodedValue.Code' action='set' />
<assign value='source.valueRatio.denominator.code.value' property='target.ResultCodedValue.Description' action='set' />
</false>
</if>
</true>
<false>
<if condition='$IsObject(source.valueSampledData)' >
<true>
<assign value='source.valueSampledData.data.value' property='target.ResultValue' action='set' />
</true>
<false>
<if condition='$IsObject(source.valueAttachment)' >
<true>
<assign value='source.valueAttachment.data.value' property='target.ResultValue' action='set' />
</true>
<false>
<if condition='$IsObject(source.valueTime)' >
<true>
<assign value='source.valueTime.value' property='target.ResultValue' action='set' />
</true>
<false>
<if condition='$IsObject(source.valueDateTime)' >
<true>
<assign value='source.valueDateTime.value' property='target.ResultValue' action='set' />
</true>
<false>
<if condition='$IsObject(source.valuePeriod)' >
<true>
<assign value='"From: "_source.valuePeriod.start.value_" To: "_source.valuePeriod.end.value' property='target.ResultValue' action='set' />
</true>
<false>
<if condition='$IsObject(source.valueQuantity)' >
<true>
<assign value='source.valueQuantity.comparator.value_source.valueQuantity.value.value' property='target.ResultValue' action='set' />
<assign value='source.valueQuantity.unit.value' property='target.ResultValueUnits' action='set' />
</true>
<false>
<if condition='$IsObject(source.valueCodeableConcept)' >
<true>
<assign value='source.valueCodeableConcept.text.value' property='target.ResultCodedValue.OriginalText' action='set' />
<if condition='source.valueCodeableConcept.coding.Count() &gt; 0' >
<true>
<assign value='source.valueCodeableConcept.coding.(1).display.value' property='target.ResultValue' action='set' />
<assign value='source.valueCodeableConcept.coding.(1).code.value' property='target.ResultCodedValue.Code' action='set' />
<assign value='source.valueCodeableConcept.coding.(1).display.value' property='target.ResultCodedValue.Description' action='set' />
<assign value='source.valueCodeableConcept.coding.(1).version.value' property='target.ResultCodedValue.CodeSystemVersionId' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.valueCodeableConcept.coding.(1).system.value)' property='target.ResultCodedValue.SDACodingStandard' action='set' />
</true>
</if>
</true>
</if>
</false>
</if>
</false>
</if>
</false>
</if>
</false>
</if>
</false>
</if>
</false>
</if>
</false>
</if>
</false>
</if>
</false>
</if>
</transform>
}

}
