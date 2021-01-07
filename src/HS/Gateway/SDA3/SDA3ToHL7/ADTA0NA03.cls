Class HS.Gateway.SDA3.SDA3ToHL7.ADTA0NA03 Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.EDI.XML.Document, EnsLib.HL7.Message) ]
{

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.HL7.Message' targetClass='EnsLib.HL7.Message' sourceDocType='2.5.1:ADT_A01' targetDocType='2.5.1:ADT_A03' create='new' language='objectscript' >
<assign value='source.{MSH}' property='target.{MSH}' action='set' />
<assign value='"A03"' property='target.{MSH:9.2}' action='set' />
<assign value='"ADT_A03"' property='target.{MSH:9.3}' action='set' />
<assign value='source.{EVN}' property='target.{EVN}' action='set' />
<assign value='source.{PID}' property='target.{PID}' action='set' />
<assign value='source.{PV1}' property='target.{PV1}' action='set' />
<assign value='source.{PV2}' property='target.{PV2}' action='set' />
<assign value='source.{DG1}' property='target.{DG1}' action='set' />
<assign value='source.{OBX}' property='target.{OBX}' action='set' />
</transform>
}

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

}
