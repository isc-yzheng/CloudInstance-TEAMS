/// Transforms vR4 CodeableConcept to SDA3 HS.SDA3.CodeTableDetail
Class HS.FHIR.DTL.vR4.SDA3.CodeableConcept.CodeTableDetail Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept, HS.SDA3.CodeTableDetail), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept' targetClass='HS.SDA3.CodeTableDetail' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms CodeableConcept (vR4) to HS.SDA3.CodeTableDetail (SDA3) ]]>
  </annotation>
<if condition='source.coding&apos;=""'> 
<true>
<if condition='source.coding.Count()>0'> 
<true> 
<assign value='target' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.coding.(1), "HS.FHIR.DTL.vR4.SDA3.Coding.CodeTableDetail")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.coding.(1), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target' action='set'  >
<annotation>
<![CDATA[ 
 --- FHIR4 CodeableConcept:coding is a *List*, and SDA3 HS.SDA3.CodeTableDetail is *Single*. 
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
</transform>
}

}
