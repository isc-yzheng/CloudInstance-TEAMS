/// Transforms vSTU3 Extension to SDA3 HS.SDA3.CodeTableDetail
Class HS.FHIR.DTL.vSTU3.SDA3.Extension.CodeTableDetail Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Base.Extension, HS.SDA3.CodeTableDetail), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Base.Extension' targetClass='HS.SDA3.CodeTableDetail' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Extension (vSTU3) to HS.SDA3.CodeTableDetail (SDA3) ]]>
  </annotation>
<if condition='source.valueCodeableConcept&apos;=""'> 
<true>
<assign value='target' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.valueCodeableConcept, "HS.FHIR.DTL.vSTU3.SDA3.CodeableConcept.CodeTableDetail")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.valueCodeableConcept, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target' action='set'  /></true> 
</if>
</true>
</if>

</true>
</if>
</transform>
}

}
