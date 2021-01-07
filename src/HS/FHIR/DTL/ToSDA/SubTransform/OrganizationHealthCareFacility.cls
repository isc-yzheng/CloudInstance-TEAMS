Class HS.FHIR.DTL.ToSDA.SubTransform.OrganizationHealthCareFacility Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.vDSTU2.Model.Resource.Organization, HS.SDA3.CodeTableDetail.HealthCareFacility) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.vDSTU2.Model.Resource.Organization' targetClass='HS.SDA3.CodeTableDetail.Organization' create='new' language='objectscript' >
<if condition='source.name.id &apos;=""' >
<true>
<assign value='source.name.id' property='target.Code' action='set' />
</true>
<false>
<if condition='(source.identifier.Count()&gt;0) &amp;&amp; (source.identifier.(1).value.value &apos;="")' >
<true>
<assign value='source.identifier.(1).value.value' property='target.Code' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.identifier.(1).system.value)' property='target.SDACodingStandard' action='set' />
</true>
</if>
</false>
</if>
<assign value='source.name.value' property='target.Description' action='set' />
<foreach property='source.address()' key='k1' >
<if condition='k1=1' >
<true>
<subtransform class='HS.FHIR.DTL.ToSDA.SubTransform.Address' targetObj='target.Address' sourceObj='source.address.(k1)' />
</true>
</if>
</foreach>
<foreach property='source.telecom()' key='k2' >
<subtransform class='HS.FHIR.DTL.ToSDA.SubTransform.ContactPoint' targetObj='target.ContactInfo' sourceObj='source.telecom.(k2)' />
</foreach>
<foreach property='source.contact()' key='k3' >
<if condition='k3=1' >
<true>
<subtransform class='HS.FHIR.DTL.ToSDA.SubTransform.Name' targetObj='target.MedicalDirector.Name' sourceObj='source.contact.(k3).name' />
<subtransform class='HS.FHIR.DTL.ToSDA.SubTransform.Address' targetObj='target.MedicalDirector.Address' sourceObj='source.contact.(k3).address' />
<foreach property='source.contact.(k3).telecom()' key='k4' >
<subtransform class='HS.FHIR.DTL.ToSDA.SubTransform.ContactPoint' targetObj='target.MedicalDirector.ContactInfo' sourceObj='source.contact.(k3).telecom.(k4)' />
</foreach>
</true>
</if>
</foreach>
</transform>
}

}
