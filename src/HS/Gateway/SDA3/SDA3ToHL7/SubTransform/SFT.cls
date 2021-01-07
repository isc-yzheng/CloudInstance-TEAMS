/// JS PJH - SDA3 to HL7 SFT Transform
Class HS.Gateway.SDA3.SDA3ToHL7.SubTransform.SFT Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.Container, EnsLib.HL7.Segment) ]
{

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.XML.Document' targetClass='EnsLib.HL7.Segment' sourceDocType='HS.SDA3:Container' targetDocType='2.5.1:SFT' create='new' language='objectscript' >
<code>
<![CDATA[ 
 #;
 #; 1 - Vendor Organization
 #; 
]]></code>
<assign value='"NIST Lab, Inc.^L^^^^NIST&amp;2.16.840.1.113883.3.987.1&amp;ISO^XX^^^123544"' property='target.{1}' action='set' />
<assign value='"InterSystems Corporation"' property='target.{1.1}' action='set' />
<assign value='"L"' property='target.{1.2}' action='set' />
<assign value='"ISC"' property='target.{1.6.1}' action='set' />
<assign value='##class(HS.Data.OIDMap).OIDForType(target.{1.6.1},"Organization")' property='target.{1.6.2}' action='set' />
<assign value='"ISO"' property='target.{1.6.3}' action='set' />
<assign value='"XX"' property='target.{1.7}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 2 - Software Version
 #; 
]]></code>
<assign value='$P($ZV," ",5)' property='target.{2}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 3 - Software Product Name
 #; 
]]></code>
<assign value='"HealthShare"' property='target.{3}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 4 - Software Binary Id -- Build Id e.g. Build 446_2U
 #; 
]]></code>
<assign value='$P($P($ZV,"(",3),")")' property='target.{4}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 5 - Software Product Information
 #; 
]]></code>
<assign value='##class(%ZHSLIB.HealthShareMgr).VersionInfo()' property='target.{5}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 6 - Software Install Date -- Not really the install but the build date
 #; 
]]></code>
<assign value='$Translate($ZDT($ZDTH($E($ZSTRIP($P($ZV,")",3),"&lt;&gt;W"),5,*-4),8),8),": ","")' property='target.{6}' action='set' />
</transform>
}

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

}
