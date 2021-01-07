Class HS.FHIR.DTL.FromSDA.SubTransform.Gender Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.CodeTableDetail.Gender, HS.FHIR.vDSTU2.Model.Datatype.Code) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.CodeTableDetail.Gender' targetClass='HS.FHIR.vDSTU2.Model.Datatype.Code' create='new' language='objectscript' >
<assign value='source.Code' property='target.value' action='set' />
<if condition='($ZConvert(source.Code,"U") = "M") || ($ZConvert(source.Code,"U") = "MALE") || ($ZConvert(source.Description,"U") = "M") || ($ZConvert(source.Description,"U") = "MALE") || ($ZConvert(source.OriginalText,"U") = "M") || ($ZConvert(source.OriginalText,"U") = "MALE")'>
<true>
<assign value='"male"' property='target.value' action='set' />
</true>
<false>
<if condition='($ZConvert(source.Code,"U") = "F") || ($ZConvert(source.Code,"U") = "FEMALE") || ($ZConvert(source.Description,"U") = "F") || ($ZConvert(source.Description,"U") = "FEMALE") || ($ZConvert(source.OriginalText,"U") = "F") || ($ZConvert(source.OriginalText,"U") = "FEMALE")'>
<true>
<assign value='"female"' property='target.value' action='set' />
</true>
<false>
<if condition='source.Code &apos;= ""' >
<true>
<assign value='"unknown"' property='target.value' action='set' />
</true>
</if>
</false>
</if>
</false>
</if>
</transform>
}

}
