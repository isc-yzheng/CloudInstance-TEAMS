Class HS.FHIR.DTL.ToSDA.SubTransform.Practitioner Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.vDSTU2.Model.Resource.Practitioner, HS.SDA3.CodeTableDetail.CareProvider) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.vDSTU2.Model.Resource.Practitioner' targetClass='HS.SDA3.CodeTableDetail.CareProvider' create='new' language='objectscript' >
<foreach property='source.identifier()' key='k1' >
<if condition='(k1=1) || (source.identifier.(k1).use.value = "official")' >
<true>
<assign value='source.identifier.(k1).value.value' property='target.Code' action='set' />
<assign value='source.identifier.(k1).type.text.value' property='target.IdentifierTypeCode' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.identifier.(k1).system.value)' property='target.SDACodingStandard' action='set' />
</true>
</if>
</foreach>
<subtransform class='HS.FHIR.DTL.ToSDA.SubTransform.Name' targetObj='target.Name' sourceObj='source.name' />
<if condition='($IsObject(source.name))&amp;&amp;(source.name.given.Count()&gt;0)&amp;&amp;(source.name.family.Count()&gt;0)' >
<true>
<assign value='source.name.given.(1).value_" "_source.name.family.(1).value' property='target.Description' action='set' />
</true>
</if>
<foreach property='source.address.()' key='k2' >
<if condition='k2=1' >
<true>
<subtransform class='HS.FHIR.DTL.ToSDA.SubTransform.Address' targetObj='target.Address' sourceObj='source.address.(k2)' />
</true>
</if>
</foreach>
<foreach property='source.practitionerRole()' key='k4'>
<if condition='k4=1'>
<true>
<foreach property='source.practitionerRole.(k4).specialty()' key='k5'>
<if condition='k5=1'>
<true>
<assign value='source.practitionerRole.(k4).specialty.(k5).coding.(1).display.value' property='target.CareProviderType.Description' action='set' />
<assign value='source.practitionerRole.(k4).specialty.(k5).coding.(1).code.value' property='target.CareProviderType.Code' action='set' />
<assign value='source.practitionerRole.(k4).specialty.(k5).coding.(1).version.value' property='target.CareProviderType.CodeSystemVersionId' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.practitionerRole.(k4).specialty.(k5).coding.(1).system.value)' property='target.CareProviderType.SDACodingStandard' action='set' />
</true>
</if>
</foreach>
</true>
</if>
</foreach>
<assign value='source.birthDate.value' property='target.Name.DOB' action='set' />
<foreach property='source.telecom()' key='k3' >
<subtransform class='HS.FHIR.DTL.ToSDA.SubTransform.ContactPoint' targetObj='target.ContactInfo' sourceObj='source.telecom.(k3)' />
</foreach>
</transform>
}

}
