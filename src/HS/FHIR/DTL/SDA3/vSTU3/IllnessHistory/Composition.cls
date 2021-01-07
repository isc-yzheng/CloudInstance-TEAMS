/// Transforms SDA3 HS.SDA3.IllnessHistory to vSTU3 Composition
Class HS.FHIR.DTL.SDA3.vSTU3.IllnessHistory.Composition Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.IllnessHistory, HS.FHIR.DTL.vSTU3.Model.Resource.Composition), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.IllnessHistory' targetClass='HS.FHIR.DTL.vSTU3.Model.Resource.Composition' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms HS.SDA3.IllnessHistory (SDA3) to Composition (vSTU3) ]]>
  </annotation>
<if condition='source.NoteText &apos;= ""'> 
<true>
<assign value='"additional"' property='target.section.(1).text.status' action='set' >
<annotation>
<![CDATA[ generated | extensions | additional | empty ]]>
</annotation>
</assign>
</true>
</if>
<assign value='"History of present illness"' property='target.type.text' action='set' >
<annotation>
<![CDATA[ Plain text representation of the concept
 --- This target is one field within a CodeableConcept object assigned to the target Composition:type.    ]]>
</annotation>
</assign>
<assign value='"History of present illness"' property='target.type.coding.(1).display' action='set' >
<annotation>
<![CDATA[ Representation defined by the system
 --- This target is one field within a CodeableConcept object assigned to the target Composition:type.    ]]>
</annotation>
</assign>
<assign value='"10164-2"' property='target.type.coding.(1).code' action='set' >
<annotation>
<![CDATA[ Kind of composition (LOINC if possible)
 --- This target is one field within a CodeableConcept object assigned to the target Composition:type.    ]]>
</annotation>
</assign>
<assign value='"final"' property='target.status' action='set' >
<annotation>
<![CDATA[ preliminary | final | amended | entered-in-error ]]>
</annotation>
</assign>
<assign value='"History of present illness"' property='target.title' action='set' >
<annotation>
<![CDATA[ Human Readable name/title ]]>
</annotation>
</assign>
<assign value='aux("transformer").GetPatientReference()' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.subject' action='set' >
<annotation>
<![CDATA[ Who and/or what the composition is about ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.AssociatedEncounter&apos;=""'> 
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.AssociatedEncounter, "HS.FHIR.DTL.SubXFrm.SDA3.vSTU3.String.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.AssociatedEncounter, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/illness-history-associated-encounter"' property='tmp.url' action='set' />
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
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "Clinician")'> 
<true>
<assign value='target.author.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Resource.Practitioner).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Clinician, "HS.FHIR.DTL.SDA3.vSTU3.CodeTableDetail.CareProvider.Practitioner")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Clinician, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='aux("transformer").AddResource(source.Clinician, tmp)' property='reference' action='set' />
<if condition='reference&apos;=""'> 
<true>
<assign value='reference' property='target.author' action='set' key='index'  >
<annotation>
<![CDATA[ Who and/or what authored the composition ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true>
</if>
</true> 
</if>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "Condition")'> 
<true>
<assign value='1' property='index' action='set' />
<if condition='(target.event&apos;="") &amp;&amp; (target.event.Count() &gt; 0)'> 
<true> 
<if condition='target.event.(1)&apos;=""'> 
<true> 
<assign value='target.event.(1).code.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Condition, "HS.FHIR.DTL.SDA3.vSTU3.CodeTableTranslated.CodeableConcept")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Condition, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.event.(1).code' action='set' key='index'  >
<annotation>
<![CDATA[ code (s) that apply to the event being documented
 --- In this case, any FHIR3 code may be used; v3-ActCode shows Example codes, but you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
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
<assign value='value' property='target.encounter' action='set' >
<annotation>
<![CDATA[ Context of the Composition ]]>
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
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/illness-history-entered-at"' property='tmp.url' action='set' />
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
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/illness-history-entered-by"' property='tmp.url' action='set' />
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
<if condition='(source.EnteredOn &apos;= "")'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).DateToFHIR(source.EnteredOn, "dateTime")' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.date' action='set' >
<annotation>
<![CDATA[ Composition editing time
 --- The source is optional, but the target is *Required*. When there is no source data to assign to this field, there is no default value, so the FHIR resource fails validation and is not saved. For this field, this is the desired behavior.   ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.ExternalId&apos;=""'> 
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.ExternalId, "HS.FHIR.DTL.SubXFrm.SDA3.vSTU3.String.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.ExternalId, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/illness-history-external-id"' property='tmp.url' action='set' />
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
<if condition='source.FromTime&apos;=""'> 
<true>
<if condition='(source.ToTime &apos;= "")'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).DateToFHIR(source.FromTime, "dateTime")' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.event.(1).period.start' action='set' >
<annotation>
<![CDATA[ Starting time with inclusive boundary ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
</true>
</if>
<if condition='(source.EnteredOn = "") &amp;&amp; (source.ToTime = "")'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).DateToFHIR(source.FromTime, "dateTime")' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.date' action='set' >
<annotation>
<![CDATA[ Composition editing time
 --- The source is optional, but the target is *Required*. When there is no source data to assign to this field, there is no default value, so the FHIR resource fails validation and is not saved. For this field, this is the desired behavior.   ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.NoteText&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).ToDiv(source.NoteText)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.section.(1).text.div' action='set' >
<annotation>
<![CDATA[ Limited xhtml content. The narrative SHALL have some non-whitespace content (text or an image). The narrative SHALL contain only the basic html formatting elements and attributes described in chapters 7-11 (except section 4 of chapter 9) and 15 of the HTML 4.0 standard, <a> elements (either name or href), images and internally contained style attributes. The inner portion of the div content is often used for the innerHTML property in a browser. In order to simplify this kind of processing, when the narrative is represented in JSON, it SHALL be encoded so that the characters between the first '>' and the last '<' delimiters is the content of the <div> element; e.g. "div": "<div>text</div>" is legal, but this is not: "div": "<?xml ...><div>text</div>" Note that the XHTML is contained in general XML so there is no support for HTML entities like &nbsp; or &copy; etc. Unicode characters SHALL be used instead. Unicode &#160; substitutes for &nbsp;. ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.ToTime&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).DateToFHIR(source.ToTime, "dateTime")' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.event.(1).period.end' action='set' >
<annotation>
<![CDATA[ End time with inclusive boundary, if not ongoing ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='(source.EnteredOn = "")'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).DateToFHIR(source.ToTime, "dateTime")' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.date' action='set' >
<annotation>
<![CDATA[ Composition editing time
 --- The source is optional, but the target is *Required*. When there is no source data to assign to this field, there is no default value, so the FHIR resource fails validation and is not saved. For this field, this is the desired behavior.   ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.VerifiedTime&apos;=""'> 
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.VerifiedTime, "HS.FHIR.DTL.SubXFrm.SDA3.vSTU3.TimeStamp.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.VerifiedTime, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/illness-history-verified-time"' property='tmp.url' action='set' />
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
<if condition='##class(%Dictionary.ClassDefinition).%ExistsId("HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.IllnessHistory.Composition")'> 
<true>
<code><![CDATA[  lock +^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.IllnessHistory.Composition") ]]></code>
<assign value='##class(HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.IllnessHistory.Composition).Transform(source.Extension, .target, .aux)' property='target' action='set' />
<code><![CDATA[  lock -^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.IllnessHistory.Composition") ]]></code>
</true>
</if>
</transform>
}

}
