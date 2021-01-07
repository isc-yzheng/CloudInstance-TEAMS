/// Transforms vSTU3 Attachment to vDSTU2 Attachment
Class HS.FHIR.DTL.vSTU3.vDSTU2.Attachment.Attachment Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Datatype.Attachment, HS.FHIR.DTL.vDSTU2.Model.Datatype.Attachment), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Datatype.Attachment' targetClass='HS.FHIR.DTL.vDSTU2.Model.Datatype.Attachment' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Attachment (vSTU3) to Attachment (vDSTU2) ]]>
  </annotation>
<if condition='source.contentType&apos;=""'> 
<true> 
<assign value='source.contentType' property='target.contentType' action='set' >
<annotation>
<![CDATA[ Mime type of the content, with charset etc.
 --- Note: The FHIR value set being used is (MimeType RFC 4289) which means MimeType RFC 4289 is the *Required* IETF specification for the FHIR2 code values that may be used.    ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.creation&apos;=""'> 
<true> 
<assign value='source.creation' property='target.creation' action='set' >
<annotation>
<![CDATA[ Date attachment was first created ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.data&apos;=""'> 
<true> 
<assign value='source.data' property='target.data' action='set' >
<annotation>
<![CDATA[ Data inline, base64ed ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.extension&apos;=""'> 
<true>
<foreach property='source.extension()' key='st' >
<assign value='target.extension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.extension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.extension' action='set' key='index'  >
<annotation>
<![CDATA[ Additional Content defined by implementations ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.hash&apos;=""'> 
<true> 
<assign value='source.hash' property='target.hash' action='set' >
<annotation>
<![CDATA[ Hash of the data (sha-1, base64ed) ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.id&apos;=""'> 
<true> 
<assign value='source.id' property='target.id' action='set' >
<annotation>
<![CDATA[ xml:id (or equivalent in JSON) ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.language&apos;=""'> 
<true> 
<assign value='source.language' property='target.language' action='set' >
<annotation>
<![CDATA[ Human language of the content (BCP-47) ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.primitiveExtension&apos;=""'> 
<true>
<foreach property='source.primitiveExtension()' key='st' >
<assign value='target.primitiveExtension.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Extension).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Extension.Extension' targetObj='tmp' sourceObj='source.primitiveExtension.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.primitiveExtension' action='set' key='index'  >
<annotation>
<![CDATA[ Generated property, not a FHIR element: Storage space for extensions of any elements that have a primitive data type. ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.size&apos;=""'> 
<true> 
<assign value='source.size' property='target.size' action='set' >
<annotation>
<![CDATA[ Number of bytes of content (if url provided) ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.title&apos;=""'> 
<true> 
<assign value='source.title' property='target.title' action='set' >
<annotation>
<![CDATA[ Label to display in place of the data ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.url&apos;=""'> 
<true> 
<assign value='source.url' property='target.url' action='set' >
<annotation>
<![CDATA[ Uri where the data can be found ]]>
</annotation>
</assign></true> 
</if> 

</transform>
}

}
