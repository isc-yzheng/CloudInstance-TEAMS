Class HS.Hub.Standalone.HL7.DTL.ADTA18ToSDA3 Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.HL7.Message, HS.SDA3.Container) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.HL7.Message' targetClass='HS.SDA3.Container' sourceDocType='2.5:ADT_A18' create='new' language='objectscript' >
<subtransform class='HS.Hub.Standalone.HL7.DTL.SubTransform.PIDToSDA3' targetObj='target' sourceObj='source.{PID}' aux='source.{MSH:SendingFacility.NamespaceID}' />
<subtransform class='HS.Hub.Standalone.HL7.DTL.SubTransform.PD1ToSDA3' targetObj='target' sourceObj='source.{PD1}' />
<subtransform class='HS.Hub.Standalone.HL7.DTL.SubTransform.MRGToSDA3' targetObj='target' sourceObj='source.{MRG}' />
</transform>
}

}
