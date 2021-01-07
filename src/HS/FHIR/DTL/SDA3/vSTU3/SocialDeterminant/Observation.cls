/// Transforms SDA3 HS.SDA3.SocialDeterminant to vSTU3 Observation
Class HS.FHIR.DTL.SDA3.vSTU3.SocialDeterminant.Observation Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.SocialDeterminant, HS.FHIR.DTL.vSTU3.Model.Resource.Observation), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.SocialDeterminant' targetClass='HS.FHIR.DTL.vSTU3.Model.Resource.Observation' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms HS.SDA3.SocialDeterminant (SDA3) to Observation (vSTU3) ]]>
  </annotation>
<assign value='"social-history"' property='target.category.(1).coding.(1).code' action='set' >
<annotation>
<![CDATA[ Classification of  type of observation
 --- This target is one field within a CodeableConcept object assigned to the target Observation:category.    ]]>
</annotation>
</assign>
<assign value='"Social History"' property='target.category.(1).coding.(1).display' action='set' >
<annotation>
<![CDATA[ Representation defined by the system
 --- This target is one field within a CodeableConcept object assigned to the target Observation:category.    ]]>
</annotation>
</assign>
<assign value='"http://hl7.org/fhir/observation-category"' property='target.category.(1).coding.(1).system' action='set' >
<annotation>
<![CDATA[ Identity of the terminology system
 --- This target is one field within a CodeableConcept object assigned to the target Observation:category.    ]]>
</annotation>
</assign>
<assign value='"Social History"' property='target.category.(1).text' action='set' >
<annotation>
<![CDATA[ Plain text representation of the concept
 --- This target is one field within a CodeableConcept object assigned to the target Observation:category.    ]]>
</annotation>
</assign>
<assign value='##class(HS.FHIR.DTL.Util.SDA3.Handler.CustomPairs).Extension(source.CustomPairs, .target, .aux)' property='value' action='set' />
<assign value='target.extension.Count()+1' property='index' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/social-determinant-custom-pairs"' property='value.url' action='set' />
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
<if condition='source.Comments&apos;=""'> 
<true> 
<assign value='source.Comments' property='target.comment' action='set' >
<annotation>
<![CDATA[ Comments about result ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.EncounterNumber&apos;=""'> 
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.EncounterNumber, "HS.FHIR.DTL.SubXFrm.SDA3.vSTU3.String.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.EncounterNumber, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/social-determinant-encounter-number"' property='tmp.url' action='set' />
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
<assign value='aux("transformer").GetReference("Encounter",source.EncounterNumber)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.context' action='set' >
<annotation>
<![CDATA[ Healthcare event during which this observation is made ]]>
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
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/social-determinant-entered-at"' property='tmp.url' action='set' />
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
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/social-determinant-entered-by"' property='tmp.url' action='set' />
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
<assign value='##class(HS.FHIR.DTL.Util.SDA3.Handler.ExternalId).Identifier(source.ExternalId)' property='value' action='set' />
<assign value='target.identifier.Count()+1' property='index' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.identifier' action='set' key='index'  >
<annotation>
<![CDATA[ Business Identifier for observation ]]>
</annotation>
</assign></true> 
</if> 
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "SocialDeterminantCode")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.SocialDeterminantCode, "HS.FHIR.DTL.SDA3.vSTU3.CodeTableTranslated.CodeableConcept")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.SocialDeterminantCode, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.code' action='set'  >
<annotation>
<![CDATA[ Type of observation (code / type)
 --- Although not required according to the HS.SDA3.SocialDeterminant class definition, in practice, the SocialDeterminantCode property always contains a value.
 --- In this case, any FHIR3 code may be used; observation-codes shows Example codes, but you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
<if condition='source.SocialDeterminantUnitOfMeasure.Code&apos;=""'> 
<true>
<if condition='source.SocialDeterminantValueNumeric &apos;= ""'> 
<true>
<if condition='source.SocialDeterminantUnitOfMeasure.Code&apos;=""'> 
<true> 
<assign value='source.SocialDeterminantUnitOfMeasure.Code' property='target.valueQuantity.code' action='set' >
<annotation>
<![CDATA[ Coded form of the unit ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='(source.SocialDeterminantValueNumeric &apos;= "") &amp;&amp; (##class(HS.FHIR.DTL.Util.Lookup).GetURIForCode(source.SocialDeterminantUnitOfMeasure.SDACodingStandard) = "")'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).GetURIForValueSet("vSTU3", "http://unitsofmeasure.org", source.SocialDeterminantUnitOfMeasure.Code)' property='value' action='set' />
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
<if condition='source.SocialDeterminantUnitOfMeasure.Description&apos;=""'> 
<true>
<if condition='source.SocialDeterminantValueNumeric &apos;= ""'> 
<true>
<if condition='source.SocialDeterminantUnitOfMeasure.Description&apos;=""'> 
<true> 
<assign value='source.SocialDeterminantUnitOfMeasure.Description' property='target.valueQuantity.unit' action='set' >
<annotation>
<![CDATA[ Unit representation ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.SocialDeterminantUnitOfMeasure.SDACodingStandard&apos;=""'> 
<true>
<if condition='source.SocialDeterminantValueNumeric &apos;= ""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).GetURIForCode(source.SocialDeterminantUnitOfMeasure.SDACodingStandard)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.valueQuantity.system' action='set' >
<annotation>
<![CDATA[ System that defines coded unit form ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
</true>
</if>
<if condition='source.SocialDeterminantUnitOfMeasure.SDACodingStandard&apos;=""'> 
<true>
<if condition='(##class(HS.FHIR.DTL.Util.Lookup).GetURIForCode(source.SocialDeterminantUnitOfMeasure.SDACodingStandard) = "") &amp;&amp; (source.SocialDeterminantValueNumeric &apos;= "")'> 
<true>
<assign value='1' property='index' action='set' />
<if condition='target.valueQuantity&apos;=""'> 
<true> 
<assign value='target.valueQuantity.extension.Count()+1' property='index' action='set' />
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.SocialDeterminantUnitOfMeasure.SDACodingStandard, "HS.FHIR.DTL.SubXFrm.SDA3.vSTU3.StrippedString.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.SocialDeterminantUnitOfMeasure.SDACodingStandard, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/social-determinant-social-determinant-unit-of-measure-s-d-a-coding-standard"' property='tmp.url' action='set' />
<assign value='tmp' property='target.valueQuantity.extension' action='set' key='index'  >
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
<if condition='(source.SocialDeterminantValueNumeric = "") &amp;&amp; (source.SocialDeterminantValueText = "")'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "SocialDeterminantValueCoded")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.SocialDeterminantValueCoded, "HS.FHIR.DTL.SDA3.vSTU3.CodeTableTranslated.CodeableConcept")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.SocialDeterminantValueCoded, .tmp, .aux)' property='status' action='set' />
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
<if condition='source.SocialDeterminantValueNumeric&apos;=""'> 
<true>
<if condition='source.SocialDeterminantValueNumeric&apos;=""'> 
<true> 
<assign value='source.SocialDeterminantValueNumeric' property='target.valueQuantity.value' action='set' >
<annotation>
<![CDATA[ Numerical value (with implicit precision) ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.SocialDeterminantValueNumeric = ""'> 
<true>
<if condition='source.SocialDeterminantValueText&apos;=""'> 
<true> 
<assign value='source.SocialDeterminantValueText' property='target.valueString' action='set' >
<annotation>
<![CDATA[ Actual result.  ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("SDA3","vSTU3","HS.SDA3.SocialDeterminant:Status","observation-status",source.Status)' property='value' action='set' />
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
<if condition='source.Status&apos;=""'> 
<true>
<if condition='(##class(HS.FHIR.DTL.Util.Lookup).Code("SDA3","vSTU3","HS.SDA3.SocialDeterminant:Status","observation-status",source.Status) = "")'> 
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Status, "HS.FHIR.DTL.SubXFrm.SDA3.vSTU3.String.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Status, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/social-determinant-status"' property='tmp.url' action='set' />
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
<if condition='source.Warning&apos;=""'> 
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Warning, "HS.FHIR.DTL.SubXFrm.SDA3.vSTU3.Boolean.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Warning, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/social-determinant-warning"' property='tmp.url' action='set' />
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
<if condition='##class(%Dictionary.ClassDefinition).%ExistsId("HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.SocialDeterminant.Observation")'> 
<true>
<code><![CDATA[  lock +^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.SocialDeterminant.Observation") ]]></code>
<assign value='##class(HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.SocialDeterminant.Observation).Transform(source.Extension, .target, .aux)' property='target' action='set' />
<code><![CDATA[  lock -^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.SocialDeterminant.Observation") ]]></code>
</true>
</if>
</transform>
}

}
