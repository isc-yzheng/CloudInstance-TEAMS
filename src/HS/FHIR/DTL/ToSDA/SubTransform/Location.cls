Class HS.FHIR.DTL.ToSDA.SubTransform.Location Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.vDSTU2.Model.Resource.Location, HS.SDA3.CodeTableDetail.HealthCareFacility) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.vDSTU2.Model.Resource.Location' targetClass='HS.SDA3.CodeTableDetail.HealthCareFacility' create='new' language='objectscript' >
<foreach property='source.identifier()' key='k1' >
<if condition='(k1=1) || (source.identifier.(k1).use.value = "official")' >
<true>
<assign value='source.identifier.(k1).value.value' property='target.Code' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetCodeForURI(source.identifier.(k1).system.value)' property='target.SDACodingStandard' action='set' />
</true>
</if>
</foreach>
</transform>
}

}
