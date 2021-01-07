/// Transforms vR4 Organization to SDA3 HS.SDA3.CodeTableDetail.HealthCareFacility
Class HS.FHIR.DTL.vR4.SDA3.Organization.CodeTableDetail.HealthCareFacility Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Resource.Organization, HS.SDA3.CodeTableDetail.HealthCareFacility), ProcedureBlock ]
{

/// This DTL XData block was generated. Do not modify it.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.Organization' targetClass='HS.SDA3.CodeTableDetail.HealthCareFacility' create='existing' language='objectscript' >
  <annotation>
    <![CDATA[ Transforms Organization (vR4) to HS.SDA3.CodeTableDetail.HealthCareFacility (SDA3) ]]>
  </annotation>
<if condition='source.address&apos;=""'> 
<true>
<if condition='source.address.Count()>0'> 
<true> 
<assign value='##class(HS.SDA3.Address).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.address.(1), "HS.FHIR.DTL.vR4.SDA3.Address.Address")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.address.(1), .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Organization.Address' action='set'  >
<annotation>
<![CDATA[ 
 --- FHIR4 Organization:address is a *List*, and SDA3 HS.SDA3.CodeTableDetail.HealthCareFacility:Organization.Address is *Single*. 
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
<if condition='source.identifier.Count()>0'> 
<true>
<if condition='source.identifier.(1).system&apos;=""'> 
<true>
<assign value='##class(HS.FHIR.DTL.Util.Lookup).GetCodeForURI(source.identifier.(1).system)' property='value' action='set' />
<if condition='value&apos;=""'> 
<true>
<assign value='value' property='target.SDACodingStandard' action='set' >
<annotation>
<![CDATA[ The coding standard. e.g. "3.2.45.7.34", "LOINC", etc. ]]>
</annotation>
</assign></true> 
</if> 
</true>
</if>
</true>
</if>
<if condition='source.identifier.Count()>0'> 
<true>
<if condition='source.identifier.(1).value&apos;=""'> 
<true>
<if condition='source.identifier.(1).value&apos;=""'> 
<true> 
<assign value='source.identifier.(1).value' property='target.Code' action='set' /></true> 
</if> 

</true>
</if>
</true>
</if>
<if condition='source.name&apos;=""'> 
<true> 
<assign value='source.name' property='target.Description' action='set' /></true> 
</if> 

<if condition='source.telecom&apos;=""'> 
<true>
<assign value='##class(HS.SDA3.ContactInfo).%New()' property='tmp' action='set' />
<assign value='aux("transformer").GetDTL(source.telecom, "HS.FHIR.DTL.SubXFrm.vR4.SDA3.ContactPoint.ContactInfo")' property='DTL' action='set' />
<if condition='DTL&apos;=""'> 
<true>
<assign value='$classmethod(DTL, "Transform", source.telecom, .tmp, .aux)' property='status' action='set' />
<if condition='tmp&apos;=""'> 
<true>
<assign value='tmp' property='target.Organization.ContactInfo' action='set'  >
<annotation>
<![CDATA[ 
 --- FHIR4 Organization:telecom is a *List*, and SDA3 HS.SDA3.CodeTableDetail.HealthCareFacility:Organization.ContactInfo is *Single*. 
 --- For a list of objects mapped to a single object, when the transformation is FHIR to SDA, the transformation maps the first object from the source list to the target, and discards the others.   ]]>
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
