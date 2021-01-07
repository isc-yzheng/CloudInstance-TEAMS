/// J2 PJH - SDA3 Encounter to HL7 PV2 Sub Transform
Class HS.Gateway.SDA3.SDA3ToHL7.SubTransform.EncounterToPV2 Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.EDI.XML.Document, EnsLib.HL7.Segment) ]
{

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.XML.Document' targetClass='EnsLib.HL7.Segment' sourceDocType='HS.SDA3:Encounter' targetDocType='2.5.1:PV2' create='new' language='objectscript' >
<code>
<![CDATA[ 
 /*
 Revision History:
   2013-05-15 Paul Hula: Created
 Documentation: 

 */
]]></code>
<code>
<![CDATA[ 
 #;
 #; 3
 #;
]]></code>
<assign value='source.{/Encounter/AdmitReason/Code}' property='target.{3.1}' action='set' />
<assign value='source.{/Encounter/AdmitReason/Description}' property='target.{3.2}' action='set' />
<assign value='source.{/Encounter/AdmitReason/SDACodingStandard}' property='target.{3.3}' action='set' />
</transform>
}

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

}
