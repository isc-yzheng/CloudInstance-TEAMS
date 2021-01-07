/// Transforms vSTU3 Practitioner to SDA3 HS.SDA3.DocumentProvider
Class HS.FHIR.DTL.vSTU3.SDA3.Practitioner.DocumentProvider Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.Practitioner, HS.SDA3.DocumentProvider), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.Practitioner' targetClass='HS.SDA3.DocumentProvider' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Practitioner (vSTU3) to HS.SDA3.DocumentProvider (SDA3) ]]>
  </annotation>
<if condition='source&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.CareProvider).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source, "HS.FHIR.DTL.vSTU3.SDA3.Practitioner.CodeTableDetail.CareProvider")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Provider' action='set'  /></true> 
</if>
</true>
</if>

</true>
</if>
</transform>
}

}
