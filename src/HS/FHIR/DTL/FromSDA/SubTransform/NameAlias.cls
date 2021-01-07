Class HS.FHIR.DTL.FromSDA.SubTransform.NameAlias Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.Name, HS.FHIR.vDSTU2.Model.Base.HumanName) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.SDA3.Name' targetClass='HS.FHIR.vDSTU2.Model.Base.HumanName' create='new' language='objectscript' >
<subtransform class='HS.FHIR.DTL.FromSDA.SubTransform.Name' targetObj='target' sourceObj='source' />
<assign value='"anonymous"' property='target.use.value' action='set' />
</transform>
}

}
