/// Transforms vSTU3 Organization to SDA3 HS.SDA3.DocumentOrganization
Class HS.FHIR.DTL.vSTU3.SDA3.Organization.DocumentOrganization Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.Organization, HS.SDA3.DocumentOrganization), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.Organization' targetClass='HS.SDA3.DocumentOrganization' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Organization (vSTU3) to HS.SDA3.DocumentOrganization (SDA3) ]]>
  </annotation>
<if condition='source&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.Organization).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source, "HS.FHIR.DTL.vSTU3.SDA3.Organization.CodeTableDetail.Organization")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Organization' action='set'  /></true> 
</if>
</true>
</if>

</true>
</if>
</transform>
}

}
