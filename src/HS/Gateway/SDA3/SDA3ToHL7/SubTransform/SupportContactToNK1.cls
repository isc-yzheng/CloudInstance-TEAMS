Class HS.Gateway.SDA3.SDA3ToHL7.SubTransform.SupportContactToNK1 Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.EDI.XML.Document, EnsLib.HL7.Segment) ]
{

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.XML.Document' targetClass='EnsLib.HL7.Segment' sourceDocType='HS.SDA3:SupportContact' targetDocType='2.5:NK1' create='new' language='objectscript' >
<assign value='0' property='tPhoneCount' action='set' />
<if condition='+$Length(source.{/SupportContact/EnteredAt/Code})' >
<true>
<code>
<![CDATA[ 
 #;
 #; 13, 30, 31, 32
 #;
]]></code>
<assign value='source.{/SupportContact/EnteredAt/Description}' property='target.{13(1).1}' action='set' />
<assign value='"L"' property='target.{13(1).2}' action='set' />
<assign value='..ReplaceStr(source.{/SupportContact/EnteredAt/SDACodingStandard},"&amp;amp;","&amp;")' property='target.{13(1).6}' action='set' />
<assign value='"XX"' property='target.{13(1).7}' action='set' />
<assign value='source.{/SupportContact/EnteredAt/Code}' property='target.{13(1).10}' action='set' />

<assign value='source.{/SupportContact/Name/FamilyName}' property='target.{30(1).1}' action='set' />
<assign value='source.{/SupportContact/Name/GivenName}' property='target.{30(1).2}' action='set' />
<assign value='source.{/SupportContact/Name/MiddleName}' property='target.{30(1).3}' action='set' />
<assign value='source.{/SupportContact/Name/NameSuffix}' property='target.{30(1).4}' action='set' />
<assign value='source.{/SupportContact/Name/NamePrefix}' property='target.{30(1).5}' action='set' />
<assign value='"L"' property='target.{30(1).7}' action='set' />
<if condition='+$Length(source.{/SupportContact/Name/ProfessionalSuffix})' >
<annotation>Not necessary but added for easier comparison of source and target messages</annotation>
<true>
<assign value='source.{/SupportContact/Name/ProfessionalSuffix}' property='target.{30(1).14}' action='set' />
</true>
</if>
<assign value='##class(EnsLib.EDI.XML.Document).ImportFromString("&lt;Phone&gt;"_source.{/SupportContact/ContactInfo/HomePhoneNumber}_"&lt;/Phone&gt;")' property='tPhone' action='set' />
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.Phone' targetObj='tSegment' sourceObj='tPhone' />
<assign value='$Translate(tSegment.OutputToString(),$Char(13),"")' property='tPhoneNumber' action='set' />
<if condition='+$Length(tPhoneNumber)' >
<true>
<assign value='tPhoneCount+1' property='tPhoneCount' action='set' />
<assign value='tPhoneNumber' property='target.{31(tPhoneCount)}' action='set' />
<assign value='"WPN"' property='target.{31(tPhoneCount).2}' action='set' />
<assign value='"PH"' property='target.{31(tPhoneCount).3}' action='set' />
</true>
</if>
<assign value='##class(EnsLib.EDI.XML.Document).ImportFromString("&lt;Address&gt;"_source.{/SupportContact/Address}_"&lt;/Address&gt;")' property='tAddress' action='set' />
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.Address' targetObj='tSegment' sourceObj='tAddress' />
<assign value='$Translate(tSegment.OutputToString(),$Char(13),"")' property='target.{32}' action='set' />
</true>
<false>
<code>
<![CDATA[ 
 #;
 #; 2
 #;

]]></code>
<if condition='$Length(source.{/SupportContact/Name/FamilyName})' >
<true>
<assign value='source.{/SupportContact/Name/FamilyName}' property='target.{2(1).1}' action='set' />
<assign value='source.{/SupportContact/Name/GivenName}' property='target.{2(1).2}' action='set' />
<assign value='source.{/SupportContact/Name/MiddleName}' property='target.{2(1).3}' action='set' />
<assign value='source.{/SupportContact/Name/NameSuffix}' property='target.{2(1).4}' action='set' />
<assign value='source.{/SupportContact/Name/NamePrefix}' property='target.{2(1).5}' action='set' />
<assign value='"L"' property='target.{2(1).7}' action='set' />
<if condition='+$Length(source.{/SupportContact/Name/ProfessionalSuffix})' >
<annotation>Not necessary but added for easier comparison of source and target messages</annotation>
<true>
<assign value='source.{/SupportContact/Name/ProfessionalSuffix}' property='target.{2(1).14}' action='set' />
</true>
</if>
</true>
</if>

<code>
<![CDATA[ 
 #;
 #; 3
 #;
]]></code>
<if condition='+$Length(source.{/SupportContact/Relationship/Code})' >
<true>
<assign value='source.{/SupportContact/Relationship/Code}' property='target.{3.1}' action='set' />
<assign value='source.{/SupportContact/Relationship/Description}' property='target.{3.2}' action='set' />
<assign value='source.{/SupportContact/Relationship/SDACodingStandard}' property='target.{3.3}' action='set' />
<if condition='+$Length(source.{/SupportContact/Relationship/CodeSystemVersionId})' >
<annotation>Not necessary but added for easier comparison of source and target messages</annotation>
<true>
<assign value='source.{/SupportContact/Relationship/CodeSystemVersionId}' property='target.{3.7}' action='set' />
</true>
</if>
<if condition='+$Length(source.{/SupportContact/Relationship/PriorCodes/[1]/Code})||+$Length(source.{/SupportContact/Relationship/PriorCodes/[1]/Description})' >
<true>
<assign value='source.{/SupportContact/Relationship/PriorCodes/[1]/Code}' property='target.{3.4}' action='set' />
<assign value='source.{/SupportContact/Relationship/PriorCodes/[1]/Description}' property='target.{3.5}' action='set' />
<assign value='source.{/SupportContact/Relationship/PriorCodes/[1]/CodeSystem}' property='target.{3.6}' action='set' />
<assign value='source.{/SupportContact/Relationship/PriorCodes/[1]/CodeSystemVersionId}' property='target.{3.8}' action='set' />
</true>
</if>
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 4
 #;
]]></code>
<assign value='##class(EnsLib.EDI.XML.Document).ImportFromString("&lt;Address&gt;"_source.{/SupportContact/Address}_"&lt;/Address&gt;")' property='tAddress' action='set' />
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.Address' targetObj='tSegment' sourceObj='tAddress' />
<assign value='$Translate(tSegment.OutputToString(),$Char(13),"")' property='target.{4(1)}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 5
 #;
]]></code>
<assign value='##class(EnsLib.EDI.XML.Document).ImportFromString("&lt;Phone&gt;"_source.{/SupportContact/ContactInfo/HomePhoneNumber}_"&lt;/Phone&gt;")' property='tPhone' action='set' />
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.Phone' targetObj='tSegment' sourceObj='tPhone' />
<assign value='$Translate(tSegment.OutputToString(),$Char(13),"")' property='tPhoneNumber' action='set' />
<if condition='+$Length(tPhoneNumber)' >
<true>
<assign value='tPhoneCount+1' property='tPhoneCount' action='set' />
<assign value='tPhoneNumber' property='target.{5(tPhoneCount)}' action='set' />
<assign value='"PRN"' property='target.{5(tPhoneCount).2}' action='set' />
<assign value='"PH"' property='target.{5(tPhoneCount).3}' action='set' />
</true>
</if>

<assign value='##class(EnsLib.EDI.XML.Document).ImportFromString("&lt;Phone&gt;"_source.{/SupportContact/ContactInfo/MobilePhoneNumber}_"&lt;/Phone&gt;")' property='tPhone' action='set' />
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.Phone' targetObj='tSegment' sourceObj='tPhone' />
<assign value='$Translate(tSegment.OutputToString(),$Char(13),"")' property='tPhoneNumber' action='set' />
<if condition='+$Length(tPhoneNumber)' >
<true>
<assign value='tPhoneCount+1' property='tPhoneCount' action='set' />
<assign value='tPhoneNumber' property='target.{5(tPhoneCount)}' action='set' />
<assign value='"ORN"' property='target.{5(tPhoneCount).2}' action='set' />
<assign value='"CP"' property='target.{5(tPhoneCount).3}' action='set' />
</true>
</if>
<assign value='##class(EnsLib.EDI.XML.Document).ImportFromString("&lt;Phone&gt;"_source.{/SupportContact/ContactInfo/WorkPhoneNumber}_"&lt;/Phone&gt;")' property='tPhone' action='set' />
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.Phone' targetObj='tSegment' sourceObj='tPhone' />
<assign value='$Translate(tSegment.OutputToString(),$Char(13),"")' property='tPhoneNumber' action='set' />
<if condition='+$Length(tPhoneNumber)' >
<true>
<assign value='tPhoneCount+1' property='tPhoneCount' action='set' />
<assign value='tPhoneNumber' property='target.{5(tPhoneCount)}' action='set' />
<assign value='"WPN"' property='target.{5(tPhoneCount).2}' action='set' />
<assign value='"PN"' property='target.{5(tPhoneCount).3}' action='set' />
</true>
</if>
<if condition='+$Length(source.{/SupportContact/ContactInfo/EmailAddress})' >
<true>
<assign value='"NET"' property='target.{5(2).2}' action='set' />
<assign value='"Internet"' property='target.{5(2).3}' action='set' />
<assign value='source.{/SupportContact/ContactInfo/EmailAddress}' property='target.{5(2).4}' action='set' />
<assign value='"Home"' property='target.{5(2).9}' action='set' />
</true>
</if>
</false>
</if>

</transform>
}

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

}
