Class HS.FHIR.DTL.ToSDA.SubTransform.Name Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.vDSTU2.Model.Base.HumanName, HS.SDA3.Name) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.vDSTU2.Model.Base.HumanName' targetClass='HS.SDA3.Name' create='new' language='objectscript' >
<foreach property='source.given()' key='k2' >
<if condition='k2=1' >
<true>
<assign value='source.given.(k2).value' property='target.GivenName' action='set' />
</true>
<false>
<if condition='k2=2' >
<true>
<assign value='source.given.(k2).value' property='target.MiddleName' action='set' />
</true>
<false>
<assign value='target.MiddleName_" "_source.given.(k2).value' property='target.MiddleName' action='set' />
</false>
</if>
</false>
</if>
</foreach>
<foreach property='source.family()' key='k1' >
<if condition='k1=1'>
<true>
<assign value='source.family.(k1).value' property='target.FamilyName' action='set' />
</true>
<false>
<assign value='target.FamilyName_" "_source.family.(k1).value' property='target.FamilyName' action='set' />
</false>
</if>
</foreach>
<foreach property='source.prefix()' key='k3' >
<if condition='k3=1' >
<true>
<assign value='source.prefix.(k3).value' property='target.NamePrefix' action='set' />
</true>
<false>
<assign value='source.prefix.(k3).value' property='target.FamilyNamePrefix' action='set' />
</false>
</if>
</foreach>
<foreach property='source.suffix()' key='k4' >
<if condition='##class(HS.FHIR.DTL.Utils).LookupFHIR("ToSDAIsNameSuffix",..ToLower(..Translate(source.suffix.(k4).value,".","")),0,3)' >
<true>
<assign value='source.suffix.(k4).value' property='target.NameSuffix' action='set' />
</true>
<false>
<if condition='source.suffix.(k4).value &apos;= ""' >
<true>
<assign value='source.suffix.(k4).value' property='target.ProfessionalSuffix' action='set' />
</true>
</if>
</false>
</if>
</foreach>
</transform>
}

}
