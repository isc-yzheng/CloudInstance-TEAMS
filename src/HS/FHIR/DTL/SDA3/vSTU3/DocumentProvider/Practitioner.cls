/// Transforms SDA3 HS.SDA3.DocumentProvider to vSTU3 Practitioner
Class HS.FHIR.DTL.SDA3.vSTU3.DocumentProvider.Practitioner Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.DocumentProvider, HS.FHIR.DTL.vSTU3.Model.Resource.Practitioner), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.DocumentProvider' targetClass='HS.FHIR.DTL.vSTU3.Model.Resource.Practitioner' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms HS.SDA3.DocumentProvider (SDA3) to Practitioner (vSTU3) ]]>
  </annotation>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "Provider")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vSTU3.Model.Resource.Practitioner).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Provider, "HS.FHIR.DTL.SDA3.vSTU3.CodeTableDetail.CareProvider.Practitioner")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Provider, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target' action='set'  >
<annotation>
<![CDATA[ A person who is directly or indirectly involved in the provisioning of healthcare. ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
<if condition='##class(%Dictionary.ClassDefinition).%ExistsId("HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.DocumentProvider.Practitioner")'> 
<true>
<code><![CDATA[  lock +^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.DocumentProvider.Practitioner") ]]></code>
<assign value='##class(HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.DocumentProvider.Practitioner).Transform(source.Extension, .target, .aux)' property='target' action='set' />
<code><![CDATA[  lock -^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vSTU3.DocumentProvider.Practitioner") ]]></code>
</true>
</if>
</transform>
}

}
