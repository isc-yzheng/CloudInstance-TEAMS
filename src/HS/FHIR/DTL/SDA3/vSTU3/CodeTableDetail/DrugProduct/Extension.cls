/// Transforms SDA3 HS.SDA3.CodeTableDetail.DrugProduct to vSTU3 Extension
Class HS.FHIR.DTL.SDA3.vSTU3.CodeTableDetail.DrugProduct.Extension Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.CodeTableDetail.DrugProduct, HS.FHIR.DTL.vSTU3.Model.Base.Extension), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.CodeTableDetail.DrugProduct' targetClass='HS.FHIR.DTL.vSTU3.Model.Base.Extension' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms HS.SDA3.CodeTableDetail.DrugProduct (SDA3) to Extension (vSTU3) ]]>
  </annotation>
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Resource.Medication).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source, "HS.FHIR.DTL.SDA3.vSTU3.CodeTableDetail.DrugProduct.Medication")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='aux("transformer").AddResource(source, tmp)' property='reference' action='set' />
<if condition='reference&apos;=""'> 
<true>
<assign value='reference' property='target.valueReference' action='set'  >
<annotation>
<![CDATA[ Value of extension ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true>
</if>

<if condition='##class(%Dictionary.ClassDefinition).%ExistsId("HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.CodeTableDetail.DrugProduct.Extension")'> 
<true>
<code><![CDATA[  lock +^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.CodeTableDetail.DrugProduct.Extension") ]]></code>
<assign value='##class(HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.CodeTableDetail.DrugProduct.Extension).Transform(source.Extension, .target, .aux)' property='target' action='set' />
<code><![CDATA[  lock -^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.CodeTableDetail.DrugProduct.Extension") ]]></code>
</true>
</if>
</transform>
}

}
