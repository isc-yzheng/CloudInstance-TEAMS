/// Transforms SDA3 HS.SDA3.Document to vSTU3 DocumentReference
Class HS.FHIR.DTL.SDA3.vSTU3.Document.DocumentReference Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.Document, HS.FHIR.DTL.vSTU3.Model.Resource.DocumentReference), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.Document' targetClass='HS.FHIR.DTL.vSTU3.Model.Resource.DocumentReference' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms HS.SDA3.Document (SDA3) to DocumentReference (vSTU3) ]]>
  </annotation>
<assign value='##class(HS.FHIR.DTL.Util.SDA3.Handler.CustomPairs).Extension(source.CustomPairs, .target, .aux)' property='value' action='set' />
<assign value='target.extension.Count()+1' property='index' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/document-custom-pairs"' property='value.url' action='set' />
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
<![CDATA[ Who/what is the subject of the document ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.ActionTime&apos;=""'> 
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.ActionTime, "HS.FHIR.DTL.SubXFrm.SDA3.vSTU3.TimeStamp.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.ActionTime, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/document-action-time"' property='tmp.url' action='set' />
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
<if condition='source.AuthorizationTime&apos;=""'> 
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.AuthorizationTime, "HS.FHIR.DTL.SubXFrm.SDA3.vSTU3.TimeStamp.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.AuthorizationTime, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/document-authorization-time"' property='tmp.url' action='set' />
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
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Clinician, "HS.FHIR.DTL.SDA3.vSTU3.CodeTableDetail.CareProvider.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Clinician, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/document-clinician"' property='tmp.url' action='set' />
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
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source,"DocumentCompletionStatus")'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "DocumentCompletionStatus")'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("SDA3","vSTU3","HS.SDA3.CodeTableDetail.DocumentCompletionStatus","composition-status",source.DocumentCompletionStatus)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.docStatus' action='set' >
<annotation>
<![CDATA[ preliminary | final | appended | amended | entered-in-error
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- If the mapping is SDA to FHIR, and the source field contains a non-empty value, then by convention there are two mapping entries for this source field. Both entries execute under the same Condition to Set this Field. One entry does the lookup to retrieve the value to assign to the target field. The other stores the original source field value in a FHIR extension.    ]]>
</annotation>
</assign></true> 
</if> </true> 
</if>
</true>
</if>
<if condition='&apos;##class(HS.FHIR.DTL.Util.Element.Object).Defined(source,"DocumentCompletionStatus") || (##class(HS.FHIR.DTL.Util.Lookup).Code("SDA3","vSTU3","HS.SDA3.CodeTableDetail.DocumentCompletionStatus","composition-status",source.DocumentCompletionStatus) = "")'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "DocumentCompletionStatus")'> 
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.DocumentCompletionStatus, "HS.FHIR.DTL.SDA3.vSTU3.CodeTableTranslated.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.DocumentCompletionStatus, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/document-document-completion-status"' property='tmp.url' action='set' />
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
<if condition='source.DocumentName&apos;=""'> 
<true>
<if condition='source.DocumentName&apos;=""'> 
<true> 
<assign value='source.DocumentName' property='target.content.(1).attachment.title' action='set' >
<annotation>
<![CDATA[ Label to display in place of the data ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<if condition='source.DocumentName&apos;=""'> 
<true> 
<assign value='source.DocumentName' property='target.description' action='set' >
<annotation>
<![CDATA[ Human-readable description (title) ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.DocumentNumber&apos;=""'> 
<true>
<assign value='1' property='index' action='set' />
<if condition='(target.content&apos;="") &amp;&amp; (target.content.Count() &gt; 0)'> 
<true> 
<if condition='target.content.(1).attachment&apos;=""'> 
<true> 
<assign value='target.content.(1).attachment.extension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.DocumentNumber, "HS.FHIR.DTL.SubXFrm.SDA3.vSTU3.String.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.DocumentNumber, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/document-document-number"' property='tmp.url' action='set' />
<assign value='tmp' property='target.content.(1).attachment.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional Content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
<if condition='source.DocumentTime&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).DateToFHIR(source.DocumentTime, "dateTime")' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.content.(1).attachment.creation' action='set' >
<annotation>
<![CDATA[ Date attachment was first created ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "DocumentType")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.DocumentType, "HS.FHIR.DTL.SDA3.vSTU3.CodeTableTranslated.CodeableConcept")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.DocumentType, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.type' action='set'  >
<annotation>
<![CDATA[ Kind of document (LOINC if possible)
 --- In this case, c80-doc-typecodes is the Preferred FHIR3 ValueSet for codes, but if you need to express meanings not found in c80-doc-typecodes, you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
<if condition='source.DocumentURL&apos;=""'> 
<true>
<if condition='source.DocumentURL&apos;=""'> 
<true> 
<assign value='source.DocumentURL' property='target.content.(1).attachment.url' action='set' >
<annotation>
<![CDATA[ Uri where the data can be found ]]>
</annotation>
</assign></true> 
</if> 

</true>
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
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/document-encounter-number"' property='tmp.url' action='set' />
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
<if condition='source.EncounterNumber&apos;=""'> 
<true>
<assign value='aux("transformer").GetReference("Encounter",source.EncounterNumber)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.context.encounter' action='set' >
<annotation>
<![CDATA[ Context of the document  content ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "EnteredAt")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Resource.Organization).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.EnteredAt, "HS.FHIR.DTL.SDA3.vSTU3.CodeTableDetail.Organization.Organization")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.EnteredAt, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='aux("transformer").AddResource(source.EnteredAt, tmp)' property='reference' action='set' />
<if condition='reference&apos;=""'> 
<true>
<assign value='reference' property='target.custodian' action='set'  >
<annotation>
<![CDATA[ Organization which maintains the document ]]>
</annotation>
</assign></true> 
</if>
</true>
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
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/document-entered-by"' property='tmp.url' action='set' />
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
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).DateToFHIR(source.EnteredOn, "dateTime")' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.created' action='set' >
<annotation>
<![CDATA[ Document creation time ]]>
</annotation>
</assign></true> 
</if> 
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).DateToFHIR(source.EnteredOn, "instant")' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.indexed' action='set' >
<annotation>
<![CDATA[ When this document reference was created
 --- The source is optional, but the target is *Required*. When there is no source data to assign to this field, there is no default value, so the FHIR resource fails validation and is not saved. For this field, this is the desired behavior.   ]]>
</annotation>
</assign></true> 
</if> 
<assign value='##class(HS.FHIR.DTL.Util.SDA3.Handler.ExternalId).Identifier(source.ExternalId)' property='value' action='set' />
<assign value='target.identifier.Count()+1' property='index' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.identifier' action='set' key='index'  >
<annotation>
<![CDATA[ Other identifiers for the document ]]>
</annotation>
</assign></true> 
</if> 
<foreach property='source.Facilities()' key='st' >
<assign value='target.author.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Resource.Organization).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Facilities.(st), "HS.FHIR.DTL.SDA3.vSTU3.CodeTableDetail.Organization.Organization")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Facilities.(st), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='aux("transformer").AddResource(source.Facilities.(st), tmp)' property='reference' action='set' />
<if condition='reference&apos;=""'> 
<true>
<assign value='reference' property='target.author' action='set' key='index'  >
<annotation>
<![CDATA[ Who and/or what authored the document ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true>
</if>
</foreach>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("SDA3","vSTU3","HS.SDA3.Document:FileType","MimeType RFC 4289",source.FileType)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.content.(1).attachment.contentType' action='set' >
<annotation>
<![CDATA[ Mime type of the content, with charset etc.
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- If the mapping is SDA to FHIR, and the source field contains a non-empty value, then by convention there are two mapping entries for this source field. Both entries execute under the same Condition to Set this Field. One entry does the lookup to retrieve the value to assign to the target field. The other stores the original source field value in a FHIR extension.    ]]>
</annotation>
</assign></true> 
<false> 
<assign value='"text/plain"' property='target.content.(1).attachment.contentType' action='set' />
</false> 
</if> 
<if condition='source.FileType&apos;=""'> 
<true>
<if condition='(##class(HS.FHIR.DTL.Util.Lookup).Code("SDA3","vSTU3","HS.SDA3.Document:FileType","MimeType RFC 4289",source.FileType) = "")'> 
<true>
<assign value='1' property='index' action='set' />
<if condition='(target.content&apos;="") &amp;&amp; (target.content.Count() &gt; 0)'> 
<true> 
<if condition='target.content.(1).attachment&apos;=""'> 
<true> 
<assign value='target.content.(1).attachment.extension.Count()+1' property='index' action='set' />
</true> 
</if> 
</true> 
</if> 
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.FileType, "HS.FHIR.DTL.SubXFrm.SDA3.vSTU3.String.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.FileType, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/document-file-type"' property='tmp.url' action='set' />
<assign value='tmp' property='target.content.(1).attachment.extension' action='set' key='index'  >
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
<if condition='source.FromTime&apos;=""'> 
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.FromTime, "HS.FHIR.DTL.SubXFrm.SDA3.vSTU3.TimeStamp.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.FromTime, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/document-from-time"' property='tmp.url' action='set' />
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
<if condition='source.NoteText&apos;=""'> 
<true>
<if condition='&apos;##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "Stream") || (source.Stream.Size = 0)'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).Base64Encode(source.NoteText)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.content.(1).attachment.data' action='set' >
<annotation>
<![CDATA[ Data inline, base64ed ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
</true>
</if>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "Status")'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("SDA3","vSTU3","HS.SDA3.CodeTableDetail.DocumentStatus","document-reference-status",source.Status)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.status' action='set' >
<annotation>
<![CDATA[ current | superseded | entered-in-error
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- If the mapping is SDA to FHIR, and the source field contains a non-empty value, then by convention there are two mapping entries for this source field. Both entries execute under the same Condition to Set this Field. One entry does the lookup to retrieve the value to assign to the target field. The other stores the original source field value in a FHIR extension.    ]]>
</annotation>
</assign></true> 
<false> 
<assign value='"current"' property='target.status' action='set' />
</false> 
</if> </true> 
<false> 
<assign value='"current"' property='target.status' action='set' />
</false> 
</if>
<if condition='&apos;##class(HS.FHIR.DTL.Util.Element.Object).Defined(source,"Status") || (##class(HS.FHIR.DTL.Util.Lookup).Code("SDA3","vSTU3","HS.SDA3.CodeTableDetail.DocumentStatus","document-reference-status",source.Status) = "")'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "Status")'> 
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Status, "HS.FHIR.DTL.SDA3.vSTU3.CodeTableTranslated.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Status, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/document-status"' property='tmp.url' action='set' />
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
<if condition='source.Stream&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.Object).FromStream(source.Stream)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.content.(1).attachment.data' action='set' >
<annotation>
<![CDATA[ Data inline, base64ed ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.ToTime&apos;=""'> 
<true>
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Base.Extension).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.ToTime, "HS.FHIR.DTL.SubXFrm.SDA3.vSTU3.TimeStamp.Extension")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.ToTime, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='"http://intersystems.com/fhir/extn/sda3/lib/document-to-time"' property='tmp.url' action='set' />
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
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).DateToFHIR(source.TranscriptionTime, "dateTime")' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.created' action='set' >
<annotation>
<![CDATA[ Document creation time ]]>
</annotation>
</assign></true> 
</if> 
<if condition='##class(%Dictionary.ClassDefinition).%ExistsId("HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.Document.DocumentReference")'> 
<true>
<code><![CDATA[  lock +^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.Document.DocumentReference") ]]></code>
<assign value='##class(HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.Document.DocumentReference).Transform(source.Extension, .target, .aux)' property='target' action='set' />
<code><![CDATA[  lock -^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.Document.DocumentReference") ]]></code>
</true>
</if>
</transform>
}

}
