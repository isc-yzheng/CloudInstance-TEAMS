/// Transforms vR4 Attachment to SDA3 HS.SDA3.Result
Class HS.FHIR.DTL.vR4.SDA3.Attachment.Result Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Datatype.Attachment, HS.SDA3.Result), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Datatype.Attachment' targetClass='HS.SDA3.Result' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Attachment (vR4) to HS.SDA3.Result (SDA3) ]]>
  </annotation>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).Code("vR4","SDA3","mimetypes|4.0.1","HS.SDA3.Document:FileType",source.contentType)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.FileType' action='set' >
<annotation>
<![CDATA[ The type of data e.g PDF, DOC, RTF, TXT. 
 --- This mapping entry seeks a lookup table entry that can match a source value with a target value for this field. If the mapping cannot find the lookup table, or cannot find a matching entry in the lookup table, and it has a non-empty Default Value defined, it places its Default Value into the target field. Otherwise, the target receive no value from this mapping. 
 --- SDA3 HS.SDA3.Result:FileType is type %String and it has no MAXLEN value set, so its maximum string length is *50*.    ]]>
</annotation>
</assign></true> 
</if> 
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Code("vR4","SDA3","mimetypes|4.0.1","HS.SDA3.Document:FileType",source.contentType) = ""'> 
<true>
<if condition='source.contentType&apos;=""'> 
<true> 
<assign value='source.contentType' property='target.FileType' action='set' >
<annotation>
<![CDATA[ The type of data e.g PDF, DOC, RTF, TXT. 
 --- SDA3 HS.SDA3.Result:FileType is type %String and it has no MAXLEN value set, so its maximum string length is *50*. 
 --- This mapping operates only when a table lookup to match an incoming FHIR code value with an appropriate SDA Code value fails. In that case, this mapping maps the source FHIR code value (unchanged) into an SDA CodeTableDetail Code value, and if the FHIR code was inside a Coding or CodeableConcept, it maps the FHIR display, system, and version values into appropriate SDA CodeTableDetail fields.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
<assign value='##class(HS.FHIR.DTL.Util.Element.Object).ToStream(source.data)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Stream' action='set' >
<annotation>
<![CDATA[ An alternative to ResultText, this property may contain the result as a stream of either plaintext or binary data (e.g. DOC, PDF, JPG), with the type of data given by FileType. Never atomic, see HS.SDA3.Result:ResultType. ]]>
</annotation>
</assign></true> 
</if> 
<if condition='source.title&apos;=""'> 
<true> 
<assign value='source.title' property='target.DocumentName' action='set' >
<annotation>
<![CDATA[ The name of the document. Used for text results only, see HS.SDA3.Result:ResultType
 --- SDA3 HS.SDA3.Result:DocumentName is type %String with a maximum string length of *220*.    ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.url&apos;=""'> 
<true> 
<assign value='source.url' property='target.DocumentURL' action='set' >
<annotation>
<![CDATA[ The full URL where the document can be accessed.  ]]>
</annotation>
</assign></true> 
</if> 

</transform>
}

}
