/// JS PJH - SDA3 OtherOrder to HL7 NTE Sub Transform
Class HS.Gateway.SDA3.SDA3ToHL7.SubTransform.LabOrderToNTE Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.EDI.XML.Document, EnsLib.HL7.Segment) ]
{

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.XML.Document' targetClass='EnsLib.HL7.Segment' sourceDocType='HS.SDA3:LabOrder' targetDocType='2.5.1:NTE' create='new' language='objectscript' >
<code>
<![CDATA[ 
 /*
 Revision History:
   2013-05-08 Paul Hula: Created
 Documentation: 

 */
]]></code>
<code>
<![CDATA[ 
 #;
 #; 2 3 4
 #;
]]></code>
<assign value='"L"' property='target.{2}' action='set' />
<assign value='source.{/LabOrder/Result/Comments}' property='target.{3}' action='set' />
<assign value='"RE"' property='target.{4.1}' action='set' />
<assign value='"Remark"' property='target.{4.2}' action='set' />
<assign value='"HL70364"' property='target.{4.3}' action='set' />
<assign value='"C"' property='target.{4.4}' action='set' />
<assign value='"Comment"' property='target.{4.5}' action='set' />
<assign value='"L"' property='target.{4.6}' action='set' />
<assign value='"2.5.1"' property='target.{4.7}' action='set' />
<assign value='"V1"' property='target.{4.8}' action='set' />
</transform>
}

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

}
