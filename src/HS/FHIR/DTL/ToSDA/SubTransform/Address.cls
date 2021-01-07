Class HS.FHIR.DTL.ToSDA.SubTransform.Address Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.vDSTU2.Model.Base.Address, HS.SDA3.Address) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.vDSTU2.Model.Base.Address' targetClass='HS.SDA3.Address' create='new' language='objectscript' >
<assign value='source.city.value' property='target.City.Description' action='set' />
<assign value='source.district.value' property='target.County.Description' action='set' />
<assign value='source.state.value' property='target.State.Description' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).NormalizeTimeStamp(source.period.start.value)' property='target.FromTime' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).NormalizeTimeStamp(source.period.end.value)' property='target.ToTime' action='set' />
<assign value='source.postalCode.value' property='target.Zip.Description' action='set' />
<assign value='source.country.value' property='target.Country.Description' action='set' />
<foreach property='source.line()' key='k1' >
<if condition='k1=1' >
<true>
<assign value='source.line.(k1).value' property='target.Street' action='set' />
</true>
<false>
<assign value='target.Street_";"_source.line.(k1).value' property='target.Street' action='set' />
</false>
</if>
</foreach>
</transform>
}

}
