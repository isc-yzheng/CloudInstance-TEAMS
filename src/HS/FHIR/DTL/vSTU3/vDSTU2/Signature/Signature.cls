/// Transforms vSTU3 Signature to vDSTU2 Signature
Class HS.FHIR.DTL.vSTU3.vDSTU2.Signature.Signature Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Datatype.Signature, HS.FHIR.DTL.vDSTU2.Model.Datatype.Signature), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Datatype.Signature' targetClass='HS.FHIR.DTL.vDSTU2.Model.Datatype.Signature' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Signature (vSTU3) to Signature (vDSTU2) ]]>
  </annotation>
<if condition='source.blob&apos;=""'> 
<true> 
<assign value='source.blob' property='target.blob' action='set' >
<annotation>
<![CDATA[ The actual signature content (XML DigSig. JWT, picture, etc.)
 --- FHIR STU3 Signature:blob is optional, and FHIR DSTU2 Signature:blob is required. No source value is mapped unconditionally to the target and *No Default Value* is supplied in case of no data received. This can be a serious gap. 
 --- This case might be fine, if there exists another mapping to the same target with a non-empty Condition to Set This Field. For example, two mappings could be defined to the same target, each with a Condition to Set This Field, in order to specify mutually exclusive cases.    ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.contentType&apos;=""'> 
<true> 
<assign value='source.contentType' property='target.contentType' action='set' >
<annotation>
<![CDATA[ The technical format of the signature
 --- FHIR STU3 Signature:contentType is optional, and FHIR DSTU2 Signature:contentType is required. No source value is mapped unconditionally to the target and *No Default Value* is supplied in case of no data received. This can be a serious gap. 
 --- This case might be fine, if there exists another mapping to the same target with a non-empty Condition to Set This Field. For example, two mappings could be defined to the same target, each with a Condition to Set This Field, in order to specify mutually exclusive cases. 
 --- Note: The FHIR value set being used is (MimeType RFC 4289) which means MimeType RFC 4289 is the *Required* IETF specification for the FHIR2 code values that may be used.    ]]>
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
<if condition='source.id&apos;=""'> 
<true> 
<assign value='source.id' property='target.id' action='set' >
<annotation>
<![CDATA[ xml:id (or equivalent in JSON) ]]>
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
<if condition='source.type&apos;=""'> 
<true>
<foreach property='source.type()' key='st' >
<assign value='target.type.Count()+1' property='index' action='set' />
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Coding.Coding' targetObj='tmp' sourceObj='source.type.(st)' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.type' action='set' key='index'  >
<annotation>
<![CDATA[ Indication of the reason the entity signed the object(s)
 --- Note: The FHIR value set being used is (signature-type *) which means signature-type is the Preferred FHIR2 ValueSet for codes, but if you need to express meanings not found in signature-type, you may use codes from any ValueSet.    ]]>
</annotation>
</assign></true> 
</if>
</foreach>
</true>
</if>
<if condition='source.when&apos;=""'> 
<true> 
<assign value='source.when' property='target.when' action='set' >
<annotation>
<![CDATA[ When the signature was created ]]>
</annotation>
</assign></true> 
</if> 

<if condition='source.whoReference&apos;=""'> 
<true>
<if condition='##class(HS.FHIR.DTL.Util.Lookup).Reference("vDSTU2", "Signature:whoReference", source.whoReference)'> 
<true>
<assign value='##class(HS.FHIR.DTL.vDSTU2.Model.Base.Reference).%New()' property='tmp' action='set' />
<subtransform class='HS.FHIR.DTL.vSTU3.vDSTU2.Reference.Reference' targetObj='tmp' sourceObj='source.whoReference' aux='.aux' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.whoReference' action='set'  >
<annotation>
<![CDATA[ Who signed.
 --- Practitioner | RelatedPerson | Patient | Device | Organization   ]]>
</annotation>
</assign></true> 
</if>

</true>
</if>
</true>
</if>
<if condition='source.whoUri&apos;=""'> 
<true> 
<assign value='source.whoUri' property='target.whoUri' action='set' >
<annotation>
<![CDATA[ Who signed. ]]>
</annotation>
</assign></true> 
</if> 

</transform>
}

}
