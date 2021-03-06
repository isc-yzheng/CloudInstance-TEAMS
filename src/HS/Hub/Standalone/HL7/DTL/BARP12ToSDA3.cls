Class HS.Hub.Standalone.HL7.DTL.BARP12ToSDA3 Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.HL7.Message, HS.SDA3.Container) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.HL7.Message' targetClass='HS.SDA3.Container' sourceDocType='2.5:BAR_P12' create='new' language='objectscript' >
<subtransform class='HS.Hub.Standalone.HL7.DTL.SubTransform.PIDToSDA3' targetObj='target' sourceObj='source.{PID}' aux='source.{MSH:SendingFacility.NamespaceID}' />
</transform>
}

}
