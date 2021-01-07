/// Transforms vSTU3 CodeableConcept to SDA3 HS.SDA3.CodeTableTranslated
Class HS.FHIR.DTL.vSTU3.SDA3.CodeableConcept.CodeTableTranslated Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept, HS.SDA3.CodeTableTranslated), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Datatype.CodeableConcept' targetClass='HS.SDA3.CodeTableTranslated' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms CodeableConcept (vSTU3) to HS.SDA3.CodeTableTranslated (SDA3) ]]>
  </annotation>
<if condition='source.coding&apos;=""'> 
<true>
<if condition='source.coding.Count()>0'> 
<true> 
<assign value='target' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.coding.(1), "HS.FHIR.DTL.vSTU3.SDA3.Coding.CodeTableTranslated")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.coding.(1), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target' action='set'  >
<annotation>
<![CDATA[ 
 --- FHIR STU3 CodeableConcept:coding is a *List*, and SDA3 HS.SDA3.CodeTableTranslated is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.   ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if> 
</true>
</if>
<if condition='source.text&apos;=""'> 
<true> 
<assign value='source.text' property='target.OriginalText' action='set' >
<annotation>
<![CDATA[ The original text that was available to an automated process or a human before a specific code was assigned. ]]>
</annotation>
</assign></true> 
</if> 

</transform>
}

}
