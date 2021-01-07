/// Transforms SDA3 HS.SDA3.DocumentOrganization to vR4 Organization
Class HS.FHIR.DTL.SDA3.vR4.DocumentOrganization.Organization Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.DocumentOrganization, HS.FHIR.DTL.vR4.Model.Resource.Organization), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.DocumentOrganization' targetClass='HS.FHIR.DTL.vR4.Model.Resource.Organization' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms HS.SDA3.DocumentOrganization (SDA3) to Organization (vR4) ]]>
  </annotation>
<if condition='##class(HS.FHIR.DTL.Util.Element.Object).Defined(source, "Organization")'> 
<true>
<assign value='##class(HS.FHIR.DTL.vR4.Model.Resource.Organization).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.Organization, "HS.FHIR.DTL.SDA3.vR4.CodeTableDetail.Organization.Organization")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.Organization, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target' action='set'  >
<annotation>
<![CDATA[ A grouping of people or organizations with a common purpose ]]>
</annotation>
</assign></true> 
</if>
</true>
</if>
</true> 
</if>
<if condition='##class(%Dictionary.ClassDefinition).%ExistsId("HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.DocumentOrganization.Organization")'> 
<true>
<code><![CDATA[  lock +^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.DocumentOrganization.Organization") ]]></code>
<assign value='##class(HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.DocumentOrganization.Organization).Transform(source.Extension, .target, .aux)' property='target' action='set' />
<code><![CDATA[  lock -^HS.FHIR.DTL("lock", "HS.FHIR.DTL.Mapping.Extension.SDA3.vR4.DocumentOrganization.Organization") ]]></code>
</true>
</if>
</transform>
}

}
