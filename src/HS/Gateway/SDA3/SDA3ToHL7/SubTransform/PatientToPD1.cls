/// JS PJH - SDA3 Patient to HL7 PD1 Sub Transform
Class HS.Gateway.SDA3.SDA3ToHL7.SubTransform.PatientToPD1 Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.EDI.XML.Document, EnsLib.HL7.Segment) ]
{

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.XML.Document' targetClass='EnsLib.HL7.Segment' sourceDocType='HS.SDA3:Patient' targetDocType='2.5.1:PD1' create='new' language='objectscript' >
<code>
<![CDATA[ 
 #;
 #; 11 18 - Publicity Code
 #;
]]></code>
<if condition='$Length(source.{/Patient/PublicityCode/Code})'>
<true>
<assign value='source.{/Patient/PublicityCode/Code}' property='target.{11.1}' action='set' />
<assign value='source.{/Patient/PublicityCode/Description}' property='target.{11.2}' action='set' />
<assign value='source.{/Patient/PublicityCode/SDACodingStandard}' property='target.{11.3}' action='set' />
</true>
</if>

<assign value='##class(HS.Gateway.SDA3.SDA3ToHL7.TransformUtil).XMLTimeStampToDate(source.{/Patient/PublicityEffectiveDate})' property='target.{18}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 12 13 - Protection Indicator
 #;
]]></code>
<assign value='source.{/Patient/IsProtected}' property='tProtectionStatus' action='set' />
<if condition='tProtectionStatus=0' >
<true>
<assign value='"N"' property='target.{12}' action='set' />
</true>
<false>
<if condition='tProtectionStatus=1' >
<true>
<assign value='"Y"' property='target.{12}' action='set' />
</true>
</if>
</false>
</if>
<assign value='##class(HS.Gateway.SDA3.SDA3ToHL7.TransformUtil).XMLTimeStampToDate(source.{/Patient/ProtectedEffectiveDate})' property='target.{13}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 16 17 - Immunization Registry Status
 #;
]]></code>
<assign value='source.{/Patient/ImmunizationRegistryStatus}' property='target.{16}' action='set' />
<assign value='##class(HS.Gateway.SDA3.SDA3ToHL7.TransformUtil).XMLTimeStampToDate(source.{/Patient/ImmunizationRegistryStatusEffectiveDate})' property='target.{17}' action='set' />
</transform>
}

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

}
