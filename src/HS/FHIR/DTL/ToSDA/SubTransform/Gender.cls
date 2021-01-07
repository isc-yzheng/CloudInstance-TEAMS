Class HS.FHIR.DTL.ToSDA.SubTransform.Gender Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.vDSTU2.Model.Datatype.Code, HS.SDA3.CodeTableDetail.Gender) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.vDSTU2.Model.Datatype.Code' targetClass='HS.SDA3.CodeTableDetail.Gender' create='new' language='objectscript' >
<if condition='source.value = "male"' >
<true>
<assign value='"M"' property='target.Code' action='set' />
</true>
<false>
<if condition='source.value = "female"' >
<true>
<assign value='"F"' property='target.Code' action='set' />
</true>
<false>
<if condition='source.value &apos;= ""' >
<true>
<assign value='"U"' property='target.Code' action='set' />
</true>
</if>
</false>
</if>
</false>
</if>
</transform>
}

}
