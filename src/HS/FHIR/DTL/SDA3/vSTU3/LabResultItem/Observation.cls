/// Transforms SDA3 HS.SDA3.LabResultItem to vSTU3 Observation
Class HS.FHIR.DTL.SDA3.vSTU3.LabResultItem.Observation Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.LabResultItem, HS.FHIR.DTL.vSTU3.Model.Resource.Observation), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.LabResultItem' targetClass='HS.FHIR.DTL.vSTU3.Model.Resource.Observation' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms HS.SDA3.LabResultItem (SDA3) to Observation (vSTU3) ]]>
  </annotation>
<assign value='##class(HS.FHIR.DTL.Util.SDA3.Handler.CustomPairs).Extension(source.CustomPairs, .target, .aux)' property='value' action='set' />
<assign value='target.extension.Count()+1' property='index' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/lab-result-item-custom-pairs"' property='value.url' action='set' />
<assign value='value' property='target.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional Content defined by implementations
 --- When the SDA3 source data contains a CustomPairs collection, and the target is FHIR, the collection is mapped to a FHIR extension that contains a Parameters resource. This Parameters resource is a collection of paired fields: name and valueString.   ]]>
</annotation>
</assign></true> 
</if> 
<assign value='aux("transformer").GetPatientReference()' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.subject' action='set' >
<annotation>
<![CDATA[ Who and/or what this is about ]]>
</annotation>
</assign></true> 
</if> 
<assign value='aux("transformer").GetReference("Encounter",aux("EncounterNumber"))' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.context' action='set' >
<annotation>
<![CDATA[ Healthcare event during which this observation is made ]]>
</annotation>
</assign></true> 
</if> 
<assign value='"laboratory"' property='target.category.(1).coding.(1).code' action='set' >
<annotation>
<![CDATA[ Classification of  type of observation
 --- This target is one field within a CodeableConcept object assigned to the target Observation:category.    ]]>
</annotation>
</assign>
<assign value='"http://hl7.org/fhir/observation-category"' property='target.category.(1).coding.(1).system' action='set' >
<annotation>
<![CDATA[ Identity of the terminology system
 --- This target is one field within a CodeableConcept object assigned to the target Observation:category.    ]]>
</annotation>
</assign>
<if condition='source.AnalysisTime&apos;=""'> 
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.AnalysisTime, "HS.FHIR.DTL.SubXFrm.SDA3.vSTU3.TimeStamp.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.AnalysisTime, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/lab-result-item-analysis-time"' property='tmp.url' action='set' />
<assign value='tmp' property='target.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional Content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='source.Comments&apos;=""'> 
<true> 
<assign value='source.Comments' property='target.comment' action='set' >
<annotation>
<![CDATA[ Comments about result ]]>
</annotation>
</assign></true> 
</if> 

<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "EnteredAt")'> 
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.EnteredAt, "HS.FHIR.DTL.SDA3.vSTU3.CodeTableDetail.Organization.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.EnteredAt, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/lab-result-item-entered-at"' property='tmp.url' action='set' />
<assign value='tmp' property='target.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional Content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "EnteredBy")'> 
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.EnteredBy, "HS.FHIR.DTL.SDA3.vSTU3.CodeTableDetail.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.EnteredBy, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/lab-result-item-entered-by"' property='tmp.url' action='set' />
<assign value='tmp' property='target.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional Content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).DateToFHIR(source.EnteredOn, "instant")' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.issued' action='set' >
<annotation>
<![CDATA[ Date/Time this was made available ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.ObservationMethods.Count()>0'> 
<true> 
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.ObservationMethods.(1), "HS.FHIR.DTL.SDA3.vSTU3.CodeTableTranslated.CodeableConcept")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.ObservationMethods.(1), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.method' action='set'  >
<annotation>
<![CDATA[ How it was done
 --- SDA3 HS.SDA3.LabResultItem:ObservationMethods is a *List*, and FHIR STU3 Observation:method is *Single*. 
 --- For a list object mapped to a single FHIR object, the mapping table must contain 2 mapping entries for the source list: One maps only the first item from the list to the target object; the other maps the list to a FHIR extension that contains the full list.
 --- In this case, any FHIR3 code may be used; observation-methods shows Example codes, but you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if> 
<foreach property='source.ObservationMethods()' key='st' >
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.ObservationMethods.(st), "HS.FHIR.DTL.SDA3.vSTU3.CodeTableTranslated.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.ObservationMethods.(st), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/lab-result-item-observation-methods"' property='tmp.url' action='set' />
<assign value='tmp' property='target.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional Content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</foreach>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).DateToFHIR(source.ObservationTime, "dateTime")' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.effectiveDateTime' action='set' >
<annotation>
<![CDATA[ Clinically relevant time/time-period for observation. ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.ObservationValueType&apos;=""'> 
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.ObservationValueType, "HS.FHIR.DTL.SubXFrm.SDA3.vSTU3.String.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.ObservationValueType, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/lab-result-item-observation-value-type"' property='tmp.url' action='set' />
<assign value='tmp' property='target.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional Content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "PerformedAt")'> 
<true>
<assign value='target.performer.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Resource.Organization).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.PerformedAt, "HS.FHIR.DTL.SDA3.vSTU3.CodeTableDetail.Organization.Organization")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.PerformedAt, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='aux("transformer").AddResource(source.PerformedAt, tmp)' property='reference' action='set' />
<if condition='reference&apos;=""'> 
<true>
<assign value='reference' property='target.performer' action='set' key='index'  >
<annotation>
<![CDATA[ Who is responsible for the observation ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true>
</if>
</true> 
</if>
<if condition='source.ReferenceComment&apos;=""'> 
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.ReferenceComment, "HS.FHIR.DTL.SubXFrm.SDA3.vSTU3.String.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.ReferenceComment, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/lab-result-item-reference-comment"' property='tmp.url' action='set' />
<assign value='tmp' property='target.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional Content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='source.ResultValue = ""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "ResultCodedValue")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.ResultCodedValue, "HS.FHIR.DTL.SDA3.vSTU3.CodeTableTranslated.CodeableConcept")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.ResultCodedValue, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.valueCodeableConcept' action='set'  >
<annotation>
<![CDATA[ Actual result.  ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
</true>
</if>
<if condition='source.ResultValue &apos;= ""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "ResultCodedValue")'> 
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.ResultCodedValue, "HS.FHIR.DTL.SDA3.vSTU3.CodeTableTranslated.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.ResultCodedValue, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/lab-result-item-result-coded-value"' property='tmp.url' action='set' />
<assign value='tmp' property='target.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional Content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
</true>
</if>
<if condition='source.ResultInterpretation&apos;=""'> 
<true>
<if condition='source.ResultInterpretation&apos;=""'> 
<true> 
<assign value='source.ResultInterpretation' property='target.interpretation.coding.(1).display' action='set' >
<annotation>
<![CDATA[ Representation defined by the system ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.ResultInterpretation&apos;=""'> 
<true>
<if condition='source.ResultInterpretation&apos;=""'> 
<true> 
<assign value='source.ResultInterpretation' property='target.interpretation.text' action='set' >
<annotation>
<![CDATA[ Plain text representation of the concept ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.SDA3.Handler.ResultItem).ResultNormalRange(source.ResultNormalRange, .aux)' property='value' action='set' />
<assign value='target.referenceRange.Count()+1' property='index' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.referenceRange' action='set' key='index'  >
<annotation>
<![CDATA[ Provides guide for interpretation ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.ResultValue&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.SDA3.Handler.ResultItem).ResultValue(source.ResultValue)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.valueQuantity.value' action='set' >
<annotation>
<![CDATA[ Numerical value (with implicit precision) ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.ResultValue&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.SDA3.Handler.ResultItem).ResultValue(source.ResultValue) &apos;= ""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.SDA3.Handler.ResultItem).ResultComparator(source.ResultValue)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.valueQuantity.comparator' action='set' >
<annotation>
<![CDATA[ < | <= | >= | > - how to understand the value ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
</true>
</if>
<if condition='##class(HS.FHIR.DTL.Util.SDA3.Handler.ResultItem).ResultValue(source.ResultValue) = ""'> 
<true>
<if condition='source.ResultValue&apos;=""'> 
<true> 
<assign value='source.ResultValue' property='target.valueString' action='set' >
<annotation>
<![CDATA[ Actual result.  ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.ResultValueUnits&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.SDA3.Handler.ResultItem).ResultValue(source.ResultValue) &apos;= ""'> 
<true>
<if condition='source.ResultValueUnits&apos;=""'> 
<true> 
<assign value='source.ResultValueUnits' property='target.valueQuantity.unit' action='set' >
<annotation>
<![CDATA[ Unit representation ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.ResultValueUnits&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.SDA3.Handler.ResultItem).ResultValue(source.ResultValue) &apos;= ""'> 
<true>
<if condition='source.ResultValueUnits&apos;=""'> 
<true> 
<assign value='source.ResultValueUnits' property='target.valueQuantity.code' action='set' >
<annotation>
<![CDATA[ Coded form of the unit ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='##class(HS.FHIR.DTL.Util.SDA3.Handler.ResultItem).ResultValue(source.ResultValue) &apos;= ""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).GetURIForValueSet("vSTU3", "http://unitsofmeasure.org", source.ResultValueUnits)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.valueQuantity.system' action='set' >
<annotation>
<![CDATA[ System that defines coded unit form ]]>
</annotation>
</assign></true> 
<false> 
<assign value='"http://www.intersystems.com/fhir/system"' property='target.valueQuantity.system' action='set' />
</false> 
</if> 
</true>
</if>
<if condition='source.SubId&apos;=""'> 
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.SubId, "HS.FHIR.DTL.SubXFrm.SDA3.vSTU3.String.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.SubId, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/lab-result-item-sub-id"' property='tmp.url' action='set' />
<assign value='tmp' property='target.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional Content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "TestItemCode")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.TestItemCode, "HS.FHIR.DTL.SDA3.vSTU3.CodeTableDetail.LabTestItem.CodeableConcept")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.TestItemCode, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.code' action='set'  >
<annotation>
<![CDATA[ Type of observation (code / type)
 --- Although not required according to the HS.SDA3.LabResultItem class definition, in practice, the TestItemCode property always contains a value.   ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("SDA3","vSTU3","HS.SDA3.LabResultItem:TestItemStatus","observation-status",source.TestItemStatus)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.status' action='set' >
<annotation>
<![CDATA[ registered | preliminary | final | amended +
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- If the mapping is SDA to FHIR, and the source field contains a non-empty value, then by convention there are two mapping entries for this source field. Both entries execute under the same Condition to Set this Field. One entry does the lookup to retrieve the value to assign to the target field. The other stores the original source field value in a FHIR extension.    ]]>
</annotation>
</assign></true> 
<false> 
<assign value='"unknown"' property='target.status' action='set' />
</false> 
</if> 
<if condition='source.TestItemStatus&apos;=""'> 
<true>
<if condition='(##class(HS.FHIR.DTL.Util.Lookup).Code("SDA3","vSTU3","HS.SDA3.LabResultItem:TestItemStatus","observation-status",source.TestItemStatus) = "")'> 
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.TestItemStatus, "HS.FHIR.DTL.SubXFrm.SDA3.vSTU3.String.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.TestItemStatus, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/lab-result-item-test-item-status"' property='tmp.url' action='set' />
<assign value='tmp' property='target.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional Content defined by implementations
 --- This mapping supports a related mapping that does a table lookup to match the incoming source value with a value to place in the target field. This mapping has the same Condition to Set this Field as the table lookup. If the lookup successfully finds a value for target field, this mapping stores the original source field value in a FHIR extension.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
</true>
</if>
<if condition='##class(%Dictionary.ClassDefinition).%ExistsId("HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.LabResultItem.Observation")'> 
<true>
<code><![CDATA[  lock +^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.LabResultItem.Observation") ]]></code>
<assign value='##class(HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.LabResultItem.Observation).Transform(source.Extension, .target, .aux)' property='target' action='set' />
<code><![CDATA[  lock -^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.LabResultItem.Observation") ]]></code>
</true>
</if>
</transform>
}

}
