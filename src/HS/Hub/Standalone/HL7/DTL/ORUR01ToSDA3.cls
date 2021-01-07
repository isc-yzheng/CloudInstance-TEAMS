Class HS.Hub.Standalone.HL7.DTL.ORUR01ToSDA3 Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.HL7.Message, HS.SDA3.Container) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.HL7.Message' targetClass='HS.SDA3.Container' sourceDocType='2.5:ORU_R01' create='new' language='objectscript' >
<foreach property='source.{PIDgrpgrp()}' key='k1' >
<subtransform class='HS.Hub.Standalone.HL7.DTL.SubTransform.PIDToSDA3' targetObj='target' sourceObj='source.{PIDgrpgrp(k1).PIDgrp.PID}' aux='source.{MSH:SendingFacility.NamespaceID}' />
<subtransform class='HS.Hub.Standalone.HL7.DTL.SubTransform.PD1ToSDA3' targetObj='target' sourceObj='source.{PIDgrpgrp(k1).PIDgrp.PD1}' />
</foreach>
</transform>
}

}
