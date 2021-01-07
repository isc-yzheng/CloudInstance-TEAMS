Class HS.Gateway.SDA3.SDA3ToHL7.SubTransform.PatientToPID Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.EDI.XML.Document, EnsLib.HL7.Segment) ]
{

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.XML.Document' targetClass='EnsLib.HL7.Segment' sourceDocType='HS.SDA3:Patient' targetDocType='2.5:PID' create='new' language='objectscript' >
<assign value='1' property='target.{1}' action='set' />
<code>
<![CDATA[ 
 #;
 #; PID-3 - Patient Numbers
 #;
]]></code>
<assign value='0' property='tPID3Count' action='set' />
<foreach property='source.{PatientNumbers()}' key='k1' >
<if condition='source.{/Patient/PatientNumbers/["_k1_"]/NumberType}="SSN"' >
<true>
<assign value='source.{/Patient/PatientNumbers/["_k1_"]/Number}' property='target.{19}' action='set' />
</true>
<false>
<assign value='tPID3Count+1' property='tPID3Count' action='set' />
<assign value='source.{/Patient/PatientNumbers/["_k1_"]/Number}' property='target.{3(tPID3Count).1}' action='set' />
<assign value='source.{/Patient/PatientNumbers/["_k1_"]/Organization/Code}' property='tPatNumberOrgCode' action='set' />
<if condition='$Length(tPatNumberOrgCode)&lt;=20' >
<true>
<assign value='tPatNumberOrgCode' property='target.{3(tPID3Count).4.1}' action='set' />
</true>
<false>
<if condition='tPatNumberOrgCode[" "' >
<true>
<assign value='$Piece(tPatNumberOrgCode," ",$Length(tPatNumberOrgCode," "))' property='target.{3(tPID3Count).4.1}' action='set' />
</true>
<false>
<assign value='$Extract(tPatNumberOrgCode,1,20)' property='target.{3(tPID3Count).4.1}' action='set' />
</false>
</if>
</false>
</if>
<assign value='source.{/Patient/PatientNumbers/["_k1_"]/Organization/UniversalId}' property='target.{3(tPID3Count).4.2}' action='set' />
<if condition='target.{3(tPID3Count).4.2}=""' >
<true>
<assign value='##class(HS.Data.OIDMap).OIDForType(target.{3(k1).4.1},"AssigningAuthority")' property='target.{3(tPID3Count).4.2}' action='set' />
</true>
</if>
<if condition='+$Length(target.{3(tPID3Count).4.1})' >
<true>
<assign value='"ISO"' property='target.{3(tPID3Count).4.3}' action='set' />
</true>
</if>
<assign value='..Lookup("AAToFacilityOIDMap",target.{3(tPID3Count).4.2})' property='tFacilityOID' action='set' />
<if condition='+$Length(tFacilityOID)' >
<true>
<assign value='##class(HS.Data.OIDMap).GetCodeForOID(tFacilityOID,"UnexpectedFacilityOIDLookUp")' property='target.{3(tPID3Count).6.1}' action='set' />
<assign value='tFacilityOID' property='target.{3(tPID3Count).6.2}' action='set' />
<assign value='"ISO"' property='target.{3(tPID3Count).6.3}' action='set' />
</true>
</if>
<assign value='source.{/Patient/PatientNumbers/["_k1_"]/NumberType}' property='target.{3(tPID3Count).5}' action='set' />
</false>
</if>
</foreach>
<code>
<![CDATA[ 
 #;<assign value='target.{3(tPID3Count).4}' property='target.{3(tPID3Count).6}' action='set' >
#;<annotation>Just copying Assigning Authority to Assigning Facility TODO -- Make this look up driven
#;a.) Check for Facility with same OID 
#;b.) if missing look at cross map in ..Lookup
#;c.) Finally default to just copying like it is now?
#;</annotation>
#;</assign>

 #; 5 - Patient name
 #;
]]></code>
<assign value='source.{/Patient/Name/FamilyName}' property='target.{5(1).1}' action='set' />
<assign value='source.{/Patient/Name/GivenName}' property='target.{5(1).2}' action='set' />
<assign value='source.{/Patient/Name/MiddleName}' property='target.{5(1).3}' action='set' />
<assign value='source.{/Patient/Name/NameSuffix}' property='target.{5(1).4}' action='set' />
<assign value='source.{/Patient/Name/NamePrefix}' property='target.{5(1).5}' action='set' />
<if condition='$Length(source.{/Patient/Name/ProfessionalSuffix})' >
<annotation>Not necessary but added for easier comparison of source and target messages</annotation>
<true>
<assign value='source.{/Patient/Name/ProfessionalSuffix}' property='target.{5(1).14}' action='set' />
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 5.7 - Patient name type
 #;	s = Known but desire not to share
 #; u = unknown
]]></code>
<if condition='$Length(target.{5(1).1})' >
<annotation>Defaulting to Legal type name as there is no way in the SDA to determine name type
	Else use BlankNameReason 
</annotation>
<true>
<assign value='"L"' property='target.{5(1).7}' action='set' />
</true>
<false>
<assign value='source.{/Patient/BlankNameReason}' property='target.{5(2).7}' action='set' />
</false>
</if>
<code>
<![CDATA[ 
 #;
 #; 6 - Mothers Maiden Name
 #;
]]></code>
<if condition='+$Length(source.{/Patient/MothersFullName})' >
<true>
<assign value='source.{/Patient/MothersFullName/FamilyName}' property='target.{6(1).1}' action='set' />
<assign value='source.{/Patient/MothersFullName/GivenName}' property='target.{6(1).2}' action='set' />
<assign value='source.{/Patient/MothersFullName/MiddleName}' property='target.{6(1).3}' action='set' />
<assign value='source.{/Patient/MothersFullName/NameSuffix}' property='target.{6(1).4}' action='set' />
<assign value='source.{/Patient/MothersFullName/NamePrefix}' property='target.{6(1).5}' action='set' />
<assign value='"M"' property='target.{6(1).7}' action='set' />
<if condition='$Length(source.{/Patient/MothersFullName/ProfessionalSuffix})' >
<annotation>Not necessary but added for easier comparison of source and target messages</annotation>
<true>
<assign value='source.{/Patient/MothersFullName/ProfessionalSuffix}' property='target.{6(1).14}' action='set' />
</true>
</if>
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 7 8
 #;
]]></code>
<assign value='##class(HS.Gateway.SDA3.SDA3ToHL7.TransformUtil).XMLTimeStampToDate(source.{/Patient/BirthTime})' property='target.{7.1}' action='set' />
<assign value='source.{/Patient/Gender/Code}' property='target.{8}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 9
 #;
]]></code>
<if condition='+$Length(source.{Aliases})' >
<true>
<foreach property='source.{Aliases()}' key='k2' >
<assign value='source.{/Patient/Aliases/["_k2_"]/FamilyName}' property='target.{9(k2).1}' action='set' />
<assign value='source.{/Patient/Aliases/["_k2_"]/GivenName}' property='target.{9(k2).2}' action='set' />
<assign value='source.{/Patient/Aliases/["_k2_"]/MiddleName}' property='target.{9(k2).3}' action='set' />
<assign value='source.{/Patient/Aliases/["_k2_"]/NameSuffix}' property='target.{9(k2).4}' action='set' />
</foreach>
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 10 - Race
 #; If Race was a CodeTableTranslated type property the lookups would not be necessary
]]></code>
<if condition='+$Length(source.{/Patient/Race/Code})' >
<annotation>Not necessary but added for easier comparison of source and target messages</annotation>
<true>
<assign value='source.{/Patient/Race/Code}' property='target.{10(1).1}' action='set' />
<assign value='source.{/Patient/Race/Description}' property='target.{10(1).2}' action='set' />
<assign value='source.{/Patient/Race/SDACodingStandard}' property='target.{10(1).3}' action='set' />
<assign value='source.{/Patient/Race/CodeSystemVersionId}' property='target.{10(1).7}' action='set' />
<assign value='..Lookup("PriorRaceId",target.{10(1).1})' property='target.{10(1).4}' action='set' />
<if condition='+$Length(target.{10(1).4})' >
<annotation>If look up successful means we prior code of type L</annotation>
<true>
<assign value='"L"' property='target.{10(1).6}' action='set' />
<assign value='"4"' property='target.{10(1).8}' action='set' />
<assign value='..Lookup("PriorRaceName",target.{10(1).4})' property='target.{10(1).5}' action='set' />
</true>
</if>
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 10 - Races
 #; Add support for the multiple races in Races
]]></code>
<if condition='+$Length(source.{Races})' >
<true>
<foreach property='source.{Races()}' key='k3' >
<assign value='source.{/Patient/Races/["_k3_"]/Code}' property='target.{10(k3).1}' action='set' />
<assign value='source.{/Patient/Races/["_k3_"]/Description}' property='target.{10(k3).2}' action='set' />
<assign value='source.{/Patient/Races/["_k3_"]/SDACodingStandard}' property='target.{10(k3).3}' action='set' />
<assign value='source.{/Patient/Races/["_k3_"]/CodeSystemVersionId}' property='target.{10(k3).7}' action='set' />
<if condition='+$Length(target.{10(1).4})' >
<annotation>If look up successful means we prior code of type L</annotation>
<true>
<assign value='"L"' property='target.{10(1).6}' action='set' />
<assign value='"4"' property='target.{10(1).8}' action='set' />
<assign value='..Lookup("PriorRaceName",target.{10(1).4})' property='target.{10(1).5}' action='set' />
</true>
</if>
</foreach>
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 11 - Addresses
 #;
]]></code>
<if condition='+source.{/Patient/Addresses/[*]}' >
<true>
<foreach property='source.{Addresses()}' key='k1' >
<assign value='##class(EnsLib.EDI.XML.Document).ImportFromString("&lt;Address&gt;"_source.{/Patient/Addresses/["_k1_"]}_"&lt;/Address&gt;")' property='tAddress' action='set' />
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.Address' targetObj='tSegment' sourceObj='tAddress' />
<assign value='$Translate(tSegment.OutputToString(),$Char(13),"")' property='target.{11(k1)}' action='set' />
</foreach>
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 13 (1st Always Phone, 2nd Always Email)
 #; <assign value='""' property='target.{13(1).2}' action='set' />
]]></code>
<assign value='0' property='tPID13Count' action='set' />
<assign value='##class(EnsLib.EDI.XML.Document).ImportFromString("&lt;Phone&gt;"_source.{/Patient/ContactInfo/HomePhoneNumber}_"&lt;/Phone&gt;")' property='tPhone' action='set' />
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.Phone' targetObj='tSegment' sourceObj='tPhone' />
<assign value='$Translate(tSegment.OutputToString(),$Char(13),"")' property='tPhoneNumber' action='set' />
<if condition='+$Length(tPhoneNumber)' >
<true>
<assign value='tPID13Count+1' property='tPID13Count' action='set' />
<assign value='tPhoneNumber' property='target.{13(tPID13Count)}' action='set' />
<assign value='"PRN"' property='target.{13(tPID13Count).2}' action='set' />
<assign value='"PH"' property='target.{13(tPID13Count).3}' action='set' />
</true>
</if>
<assign value='##class(EnsLib.EDI.XML.Document).ImportFromString("&lt;Phone&gt;"_source.{/Patient/ContactInfo/MobilePhoneNumber}_"&lt;/Phone&gt;")' property='tPhone' action='set' />
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.Phone' targetObj='tSegment' sourceObj='tPhone' />
<assign value='$Translate(tSegment.OutputToString(),$Char(13),"")' property='tPhoneNumber' action='set' />
<if condition='+$Length(tPhoneNumber)' >
<true>
<assign value='tPID13Count+1' property='tPID13Count' action='set' />
<assign value='tPhoneNumber' property='target.{13(tPID13Count)}' action='set' />
<assign value='"ORN"' property='target.{13(tPID13Count).2}' action='set' />
<assign value='"CP"' property='target.{13(tPID13Count).3}' action='set' />
</true>
</if>
<if condition='$Length(source.{/Patient/ContactInfo/EmailAddress})' >
<true>
<assign value='"NET"' property='target.{13(2).2}' action='set' />
<assign value='"Internet"' property='target.{13(2).3}' action='set' />
<assign value='source.{/Patient/ContactInfo/EmailAddress}' property='target.{13(2).4}' action='set' />
<assign value='"home"' property='target.{13(2).9}' action='set' />
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 14 - Business/Work phone
 #;
]]></code>
<assign value='##class(EnsLib.EDI.XML.Document).ImportFromString("&lt;Phone&gt;"_source.{/Patient/ContactInfo/WorkPhoneNumber}_"&lt;/Phone&gt;")' property='tPhone' action='set' />
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.Phone' targetObj='tSegment' sourceObj='tPhone' />
<assign value='$Translate(tSegment.OutputToString(),$Char(13),"")' property='tPhoneNumber' action='set' />
<if condition='+$Length(tPhoneNumber)' >
<true>
<assign value='tPhoneNumber' property='target.{14(1)}' action='set' />
<assign value='"WPN"' property='target.{14(1).2}' action='set' />
<assign value='"PH"' property='target.{14(1).3}' action='set' />
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 15 - Primary Language
 #;
]]></code>
<assign value='source.{/Patient/PrimaryLanguage/Code}' property='target.{15.1}' action='set' />
<assign value='source.{/Patient/PrimaryLanguage/Description}' property='target.{15.2}' action='set' />
<assign value='source.{/Patient/PrimaryLanguage/SDACodingStandard}' property='target.{15.3}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 16 - Marital Status
 #;
]]></code>
<assign value='source.{/Patient/MaritalStatus/Code}' property='target.{16.1}' action='set' />
<assign value='source.{/Patient/MaritalStatus/Description}' property='target.{16.2}' action='set' />
<assign value='source.{/Patient/MaritalStatus/SDACodingStandard}' property='target.{16.3}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 17 - Religion
 #;
]]></code>
<assign value='source.{/Patient/Religion/Code}' property='target.{17.1}' action='set' />
<assign value='source.{/Patient/Religion/Description}' property='target.{17.2}' action='set' />
<assign value='source.{/Patient/Religion/SDACodingStandard}' property='target.{17.3}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 22 - Ethnic Group 
 #; If EthnicGroup was a CodeTableTranslated type property the lookups would not be necessary
]]></code>
<if condition='+$Length(source.{/Patient/EthnicGroup/Code})' >
<annotation>Not necessary but added for easier comparison of source and target messages</annotation>
<true>
<assign value='source.{/Patient/EthnicGroup/Code}' property='target.{22(1).1}' action='set' />
<assign value='source.{/Patient/EthnicGroup/Description}' property='target.{22(1).2}' action='set' />
<assign value='source.{/Patient/EthnicGroup/SDACodingStandard}' property='target.{22(1).3}' action='set' />
<if condition='+$Length(source.{/Patient/EthnicGroup/CodeSystemVersionId})' >
<annotation>Not necessary but added for easier comparison of source and target messages</annotation>
<true>
<assign value='source.{/Patient/EthnicGroup/CodeSystemVersionId}' property='target.{22(1).7}' action='set' />
</true>
</if>
<assign value='..Lookup("PriorEthnicGroupId",target.{22(1).1})' property='target.{22(1).4}' action='set' />
<if condition='+$Length(target.{22(1).4})' >
<annotation>If look up successful means we prior code of type L</annotation>
<true>
<assign value='"L"' property='target.{22(1).6}' action='set' />
<assign value='"4"' property='target.{22(1).8}' action='set' />
<assign value='..Lookup("PriorEthnicGroupName",target.{22(1).4})' property='target.{22(1).5}' action='set' />
</true>
</if>
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 30
 #;
]]></code>
<if condition='+source.{/Patient/IsDead/}' >
<true>
<assign value='"Y"' property='target.{30}' action='set' />
<assign value='##class(HS.Gateway.SDA3.SDA3ToHL7.TransformUtil).XMLTimeStampToDateTime(source.{/Patient/DeathTime/})' property='target.{29}' action='set' />
</true>
<false>
<assign value='"N"' property='target.{30}' action='set' />
</false>
</if>
<code>
<![CDATA[ 
 #;
 #; 33 
 #;
]]></code>
<assign value='##class(HS.Gateway.SDA3.SDA3ToHL7.TransformUtil).XMLTimeStampToDateTime(source.{/Patient/EnteredOn/})' property='target.{33}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 34
 #;
]]></code>
<assign value='source.{/Patient/EnteredAt/Code}' property='target.{34.1}' action='set' />
<if condition='+$Length(target.{34.1})' >
<true>
<assign value='##class(HS.Data.OIDMap).OIDForType(target.{34.1},"Facility")' property='target.{34.2}' action='set' />
<assign value='"ISO"' property='target.{34.3}' action='set' />
</true>
</if>
</transform>
}

Parameter IGNOREMISSINGSOURCE = 0;

Parameter REPORTERRORS = 1;

}
