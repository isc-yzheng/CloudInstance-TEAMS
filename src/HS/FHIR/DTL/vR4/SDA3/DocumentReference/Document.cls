/// Transforms vR4 DocumentReference to SDA3 HS.SDA3.Document
Class HS.FHIR.DTL.vR4.SDA3.DocumentReference.Document Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Resource.DocumentReference, HS.SDA3.Document), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.DocumentReference' targetClass='HS.SDA3.Document' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms DocumentReference (vR4) to HS.SDA3.Document (SDA3) ]]>
  </annotation>
<if condition='source.author&apos;=""'> 
<true>
<foreach property='source.author()' key='st' >
<assign value='##class(HS.SDA3.CodeTableDetail.Organization).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.author.GetAt(st), .value, .aux)' property='value' action='set' />
<assign value='target.Facilities.Count()+1' property='index' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Facilities' action='set' key='index'  /></true> 
</if> </foreach>
</true>
</if>
<if condition='source.content.Count()>0'> 
<true>
<if condition='source.content.(1).attachment&apos;=""'> 
<true>
<if condition='source.content.(1).attachment.contentType&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vR4","SDA3","mimetypes|4.0.1","HS.SDA3.Document:FileType",source.content.(1).attachment.contentType)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.FileType' action='set' >
<annotation>
<![CDATA[ The type of data e.g PDF, DOC, RTF, TXT
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- SDA3 HS.SDA3.Document:FileType is type %String and it has no MAXLEN value set, so its maximum string length is *50*.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
</true>
</if>
</true>
</if>
<if condition='source.content&apos;=""'>
<true>
<assign value='1' property='j1' action='set' />
<foreach property='source.content()' key='k1' >
<if condition='source.content.(k1).attachment&apos;=""'> 
<true>
<if condition='source.content.(k1).attachment.contentType&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Code("vR4","SDA3","mimetypes|4.0.1","HS.SDA3.Document:FileType",source.content.(k1).attachment.contentType) = ""'> 
<true>
<if condition='source.content.(k1).attachment.contentType&apos;=""'> 
<true> 
<assign value='source.content.(k1).attachment.contentType' property='target.FileType' action='set' >
<annotation>
<![CDATA[ The type of data e.g PDF, DOC, RTF, TXT
 --- SDA3 HS.SDA3.Document:FileType is type %String and it has no MAXLEN value set, so its maximum string length is *50*. 
 --- This mapping operates only when a table lookup to match an incoming FHIR code value with an appropriate SDA Code value fails. In that case, this mapping maps the source FHIR code value (unchanged) into an SDA CodeTableDetail Code value, and if the FHIR code was inside a Coding or CodeableConcept, it maps the FHIR display, system, and version values into appropriate SDA CodeTableDetail fields.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.content.Count()>0'> 
<true>
<if condition='source.content.(1).attachment&apos;=""'> 
<true>
<if condition='source.content.(1).attachment.creation&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.content.(1).attachment.creation)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.DocumentTime' action='set' /></true> 
</if> 
</true>
</if>
</true>
</if>
</true>
</if>
<if condition='source.content.Count()>0'> 
<true>
<if condition='source.content.(1).attachment&apos;=""'> 
<true>
<if condition='source.content.(1).attachment.data&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Element.Object).ToStream(source.content.(1).attachment.data)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Stream' action='set' >
<annotation>
<![CDATA[ This property is used when the Note is binary data, e.g DOC, PDF, JPG ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
</true>
</if>
</true>
</if>
<if condition='source.content.Count()>0'> 
<true>
<if condition='source.content.(1).attachment&apos;=""'> 
<true>
<if condition='source.content.(1).attachment.title&apos;=""'> 
<true>
<if condition='source.content.(1).attachment.title&apos;=""'> 
<true> 
<assign value='source.content.(1).attachment.title' property='target.DocumentName' action='set' >
<annotation>
<![CDATA[ 
 --- SDA3 HS.SDA3.Document:DocumentName is type %String with a maximum string length of *220*.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
</true>
</if>
<if condition='source.content.Count()>0'> 
<true>
<if condition='source.content.(1).attachment&apos;=""'> 
<true>
<if condition='source.content.(1).attachment.url&apos;=""'> 
<true>
<if condition='source.content.(1).attachment.url&apos;=""'> 
<true> 
<assign value='source.content.(1).attachment.url' property='target.DocumentURL' action='set' >
<annotation>
<![CDATA[ 
 --- SDA3 HS.SDA3.Document:DocumentURL is type %String with a maximum string length of *220*.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
</true>
</if>
<if condition='source.context&apos;=""'> 
<true>
<if condition='source.context.encounter&apos;=""'> 
<true>
<if condition='source.context.encounter.Count()>0'> 
<true> 
<assign value='""' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.context.encounter.GetAt(1), .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.EncounterNumber' action='set' >
<annotation>
<![CDATA[ A string that uniquely identifies an Encounter within a patient record.
 --- SDA3 HS.SDA3.Document:EncounterNumber is type %String with a maximum string length of *220*. 
 --- FHIR4 DocumentReference:context.encounter is a *List*, and SDA3 HS.SDA3.Document:EncounterNumber is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.   ]]>
</annotation>
</assign></true> 
</if> </true> 
</if> 
</true>
</if>
</true>
</if>
<if condition='source.custodian&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.Organization).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.custodian, .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.EnteredAt' action='set' >
<annotation>
<![CDATA[ Source System name ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Element.TypeCast).FHIRDateToSDA3(source.date)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.EnteredOn' action='set' >
<annotation>
<![CDATA[ Date/time updated or entered. For labs ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.docStatus&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vR4","SDA3","composition-status|4.0.1","HS.SDA3.CodeTableDetail.DocumentCompletionStatus",source.docStatus)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.DocumentCompletionStatus.Code' action='set' >
<annotation>
<![CDATA[ The external code, e.g. "M"
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.docStatus&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Code("vR4","SDA3","composition-status|4.0.1","HS.SDA3.CodeTableDetail.DocumentCompletionStatus",source.docStatus) = ""'> 
<true>
<if condition='source.docStatus&apos;=""'> 
<true> 
<assign value='source.docStatus' property='target.DocumentCompletionStatus.Code' action='set' >
<annotation>
<![CDATA[ The external code, e.g. "M"
 --- This mapping operates only when a table lookup to match an incoming FHIR code value with an appropriate SDA Code value fails. In that case, this mapping maps the source FHIR code value (unchanged) into an SDA CodeTableDetail Code value, and if the FHIR code was inside a Coding or CodeableConcept, it maps the FHIR display, system, and version values into appropriate SDA CodeTableDetail fields.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.status&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vR4","SDA3","document-reference-status|4.0.1","HS.SDA3.CodeTableDetail.DocumentStatus",source.status)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Status.Code' action='set' >
<annotation>
<![CDATA[ The external code, e.g. "M"
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping.    ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
<if condition='source.status&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Code("vR4","SDA3","document-reference-status|4.0.1","HS.SDA3.CodeTableDetail.DocumentStatus",source.status) = ""'> 
<true>
<if condition='source.status&apos;=""'> 
<true> 
<assign value='source.status' property='target.Status.Code' action='set' >
<annotation>
<![CDATA[ The external code, e.g. "M"
 --- This mapping operates only when a table lookup to match an incoming FHIR code value with an appropriate SDA Code value fails. In that case, this mapping maps the source FHIR code value (unchanged) into an SDA CodeTableDetail Code value, and if the FHIR code was inside a Coding or CodeableConcept, it maps the FHIR display, system, and version values into appropriate SDA CodeTableDetail fields.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.type&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.DocumentType).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.type, "HS.FHIR.DTL.vR4.SDA3.CodeableConcept.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.type, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.DocumentType' action='set'  >
<annotation>
<![CDATA[ 
 --- In this case, c80-doc-typecodes is the Preferred FHIR4 ValueSet for codes, but if you need to express meanings not found in c80-doc-typecodes, you may use codes from any ValueSet. 
 --- SDA does not restrict code values to a particular set.    ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>

</true>
</if>
</transform>
}

}
