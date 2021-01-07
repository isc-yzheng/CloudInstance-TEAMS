Class HS.FHIR.DTL.FromSDA.SubTransform.Address Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.Address, HS.FHIR.vDSTU2.Model.Base.Address) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.Address' targetClass='HS.FHIR.vDSTU2.Model.Base.Address' create='new' language='objectscript' >
<if condition='(source.Street&apos;="")||(##class(HS.FHIR.DTL.Utils).CTIsDefined(source,"City"))||(##class(HS.FHIR.DTL.Utils).CTIsDefined(source,"State"))||(##class(HS.FHIR.DTL.Utils).CTIsDefined(source,"Zip"))||(##class(HS.FHIR.DTL.Utils).CTIsDefined(source,"County"))||(##class(HS.FHIR.DTL.Utils).CTIsDefined(source,"Country"))' >
<true>
<if condition='source.Street &apos;= ""' >
<true>
<assign value='source.Street' property='target.line.(1).value' action='set' />
</true>
</if>
<assign value='source.City.Description' property='target.city.value' action='set' />
<assign value='source.State.Description' property='target.state.value' action='set' />
<assign value='source.Zip.Description' property='target.postalCode.value' action='set' />
<assign value='source.County.Description' property='target.district.value' action='set' />
<assign value='source.Country.Description' property='target.country.value' action='set' />
<if condition='(source.FromTime &apos;= "")||(source.ToTime &apos;= "")' >
<true>
<assign value='##class(HS.FHIR.DTL.Utils).FHIRDateTime(source.FromTime)' property='target.period.start.value' action='set' />
<assign value='##class(HS.FHIR.DTL.Utils).FHIRDateTime(source.ToTime)' property='target.period.end.value' action='set' />
</true>
</if>
</true>
</if>
</transform>
}

}
