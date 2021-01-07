Class HS.FHIR.DTL.FromSDA.SubTransform.Name Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.Name, HS.FHIR.vDSTU2.Model.Base.HumanName) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.Name' targetClass='HS.FHIR.vDSTU2.Model.Base.HumanName' create='new' language='objectscript' >
<assign value='source.FamilyName' property='target.family.(1).value' action='set' />
<assign value='source.GivenName' property='target.given.(1).value' action='set' />
<if condition='source.MiddleName &apos;= ""' >
<true>
<assign value='source.MiddleName' property='target.given.(2).value' action='set' />
</true>
</if>
<assign value='source.NameSuffix' property='target.suffix.(1).value' action='set' />
<if condition='source.ProfessionalSuffix&apos;=""'>
<true>
<if condition='source.NameSuffix=""'>
<true>
<assign value='source.ProfessionalSuffix' property='target.suffix.(1).value' action='set' />
</true>
<false>
<assign value='source.ProfessionalSuffix' property='target.suffix.(2).value' action='set' />
</false>
</if>
</true>
</if>
<assign value='source.NamePrefix' property='target.prefix.(1).value' action='set' />
<assign value='$s(source.NamePrefix&apos;="":source.NamePrefix_" ",1:"")_source.GivenName_$s(source.MiddleName&apos;="":" "_source.MiddleName,1:"")_$s(source.FamilyName&apos;="":" "_source.FamilyName,1:"")_$s(source.NameSuffix&apos;="":" "_source.NameSuffix,1:"")_$s(source.ProfessionalSuffix&apos;="":" "_source.ProfessionalSuffix,1:"")' property='target.text.value' action='set' />
</transform>
}

}
