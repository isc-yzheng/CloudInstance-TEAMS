Class HS.FHIR.DTL.FromSDA.SubTransform.HealthCareFacility Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.CodeTableDetail.HealthCareFacility, HS.FHIR.vDSTU2.Model.Resource.Location) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.CodeTableDetail.HealthCareFacility' targetClass='HS.FHIR.vDSTU2.Model.Resource.Location' create='new' language='objectscript' >
<assign value='source.InternalReference' property='target.id.value' action='set' />
<assign value='"official"' property='target.identifier.(1).use.value' action='set' />
<assign value='source.Code' property='target.identifier.(1).value.value' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).GetURLForCode(source.SDACodingStandard)' property='target.identifier.(1).system.value' action='set' />
<assign value='source.LocationType' property='target.type.text.value' action='set' />
</transform>
}

}
