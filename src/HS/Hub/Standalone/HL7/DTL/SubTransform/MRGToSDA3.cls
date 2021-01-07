Class HS.Hub.Standalone.HL7.DTL.SubTransform.MRGToSDA3 Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.HL7.Segment, HS.SDA3.Container) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.HL7.Segment' targetClass='HS.SDA3.Container' sourceDocType='2.5:MRG' create='existing' language='objectscript' >
<assign value='1' property='tIndex' action='set' />
<foreach property='source.{PriorPatientIdentifierList()}' key='k1' >
<assign value='source.{PriorPatientIdentifierList(k1).IDNumber}' property='target.Patient.PriorPatientNumbers.(tIndex).Number' action='set' />
<assign value='##class(HS.Hub.Standalone.HL7.HL7ToSDA3).idtype(source.{PriorPatientIdentifierList(k1).IdentifierTypeCode})' property='target.Patient.PriorPatientNumbers.(tIndex).NumberType' action='set' />
<assign value='source.{PriorPatientIdentifierList(k1).AssigningAuthority.NamespaceID}' property='target.Patient.PriorPatientNumbers.(tIndex).Organization.Code' action='set' />
</foreach>
</transform>
}

}
