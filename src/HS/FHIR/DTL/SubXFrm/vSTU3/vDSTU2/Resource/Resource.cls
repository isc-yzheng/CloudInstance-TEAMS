Class HS.FHIR.DTL.SubXFrm.vSTU3.vDSTU2.Resource.Resource Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Base.Resource, HS.FHIR.DTL.vDSTU2.Model.Base.Resource) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Base.Resource' targetClass='HS.FHIR.DTL.vDSTU2.Model.Base.Resource' create='existing' language='objectscript' >
<assign value='##class(HS.FHIR.DTL.Util.FHIR.Handler.Contained).GetClass(source, target)' property='class' action='set' />
<assign value='##class(HS.FHIR.DTL.Util.FHIR.Handler.Contained).Transform(class, source)' property='target' action='set' />
</transform>
}

}
