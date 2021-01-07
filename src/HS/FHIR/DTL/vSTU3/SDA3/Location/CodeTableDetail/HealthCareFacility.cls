/// Transforms vSTU3 Location to SDA3 HS.SDA3.CodeTableDetail.HealthCareFacility
Class HS.FHIR.DTL.vSTU3.SDA3.Location.CodeTableDetail.HealthCareFacility Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Resource.Location, HS.SDA3.CodeTableDetail.HealthCareFacility), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Resource.Location' targetClass='HS.SDA3.CodeTableDetail.HealthCareFacility' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Location (vSTU3) to HS.SDA3.CodeTableDetail.HealthCareFacility (SDA3) ]]>
  </annotation>
<if condition='source.description&apos;=""'> 
<true> 
<assign value='source.description' property='target.Description' action='set' /></true> 
</if> 

<if condition='source.managingOrganization&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.CodeTableDetail.Organization).%New()' property='value' action='set' />
<assign value='aux("transformer").TransformReference(source.managingOrganization, .value, .aux)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.Organization' action='set' /></true> 
</if> 
</true>
</if>
<if condition='source.name&apos;=""'> 
<true> 
<assign value='source.name' property='target.Code' action='set' /></true> 
</if> 

<if condition='source.type&apos;=""'> 
<true>
<if condition='source.type.text&apos;=""'> 
<true>
<if condition='source.type.text&apos;=""'> 
<true> 
<assign value='source.type.text' property='target.LocationType' action='set' >
<annotation>
<![CDATA[ Values - CLINIC,ER,DEPARTMENT,WARD,OTHER - Type of location
 --- SDA3 HS.SDA3.CodeTableDetail.HealthCareFacility:LocationType is type %String and it has no MAXLEN value set, so its maximum string length is *50*.    ]]>
</annotation>
</assign></true> 
</if> 

</true>
</if>
</true>
</if>
</transform>
}

}
