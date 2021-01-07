Class HS.FHIR.DTL.SubXFrm.vSTU3.vDSTU2.Reference.Coding Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vSTU3.Model.Base.Reference, HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vSTU3.Model.Base.Reference' targetClass='HS.FHIR.DTL.vDSTU2.Model.Datatype.Coding' create='existing' language='objectscript' >
<assign value='source.primitiveExtension' property='target.primitiveExtension' action='set' />
<assign value='source.id' property='target.id' action='set' />
<assign value='source.extension' property='target.extension' action='set' />
<assign value='source.display' property='target.display' action='set' />
<assign value='source.identifier.system' property='target.system' action='set' />
<assign value='source.identifier.value' property='target.code' action='set' />
<assign value='source.identifier.type.coding.(1).userSelected' property='target.userSelected' action='set' />
<assign value='source.identifier.use' property='target.version' action='set' />
</transform>
}

}
