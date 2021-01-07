/// JS PJH - SDA3 LabOrder to HL7 ORC Sub Transform
Class HS.Gateway.SDA3.SDA3ToHL7.SubTransform.LabOrderToORC Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.EDI.XML.Document, EnsLib.HL7.Segment) ]
{

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.XML.Document' targetClass='EnsLib.HL7.Segment' sourceDocType='HS.SDA3:LabOrder' targetDocType='2.5.1:ORC' create='new' language='objectscript' >
<code>
<![CDATA[ 
 #;
 #; 1
 #;
]]></code>
<assign value='"RE"' property='target.{1}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 2 
 #;
]]></code>
<if condition='+$Length(source.{/LabOrder/PlacerId})'>
<true>
<assign value='source.{/LabOrder/PlacerId}' property='target.{2.1}' action='set' />
<assign value='source.{/LabOrder/PlacerAssigningAuthority}' property='target.{2.2}' action='set' />
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 3
 #;
]]></code>
<assign value='source.{/LabOrder/FillerId}' property='target.{3.1}' action='set' />
<assign value='source.{/LabOrder/FillerAssigningAuthority}' property='target.{3.2}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 4 -
 #;
]]></code>
<if condition='$Length(source.{/LabOrder/GroupId})'>
<true>
<assign value='source.{/LabOrder/GroupId}' property='target.{4.1}' action='set' />
<assign value='source.{/LabOrder/VerifiedBy/SDACodingStandard}' property='target.{4.2}' action='set' />
<assign value='##class(HS.Data.OIDMap).OIDForType(target.{4.2},"AssigningAuthority")' property='target.{4.3}' action='set' />
<assign value='"ISO"' property='target.{4.4}' action='set' />
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 12 -- Facility Authority (12.14) seems redundant with Assigning Authority (12.9)
 #;
]]></code>
<if condition='$Length(source.{/LabOrder/OrderedBy/Code})'>
<true>
<if condition='source.{/LabOrder/OrderedBy/Code}&apos;="unknown"'>
<true>
<assign value='source.{/LabOrder/OrderedBy/Code}' property='target.{12.1}' action='set' />
</true>
</if>
<assign value='source.{/LabOrder/OrderedBy/Name/FamilyName}' property='target.{12.2}' action='set' />
<assign value='source.{/LabOrder/OrderedBy/Name/GivenName}' property='target.{12.3}' action='set' />
<assign value='source.{/LabOrder/OrderedBy/Name/MiddleName}' property='target.{12.4}' action='set' />
<assign value='source.{/LabOrder/OrderedBy/Name/NameSuffix}' property='target.{12.5}' action='set' />
<assign value='source.{/LabOrder/OrderedBy/Name/NamePrefix}' property='target.{12.6}' action='set' />
<assign value='source.{/LabOrder/OrderedBy/Name/ProfessionalSuffix}' property='target.{12.21}' action='set' />
<assign value='..ReplaceStr(source.{/LabOrder/OrderedBy/SDACodingStandard},"&amp;amp;","&amp;")' property='target.{12.9}' action='set' />
<if condition='+$Length(target.{12.9})'>
<true>
<assign value='##class(HS.Data.OIDMap).OIDForType(target.{12.9.1},"AssigningAuthority")' property='target.{12.9.2}' action='set' />
<assign value='"ISO"' property='target.{12.9.3}' action='set' />
<assign value='..Lookup("AAToFacilityOIDMap",target.{12.9.2})' property='tFacilityOID' action='set' />

<if condition='+$Length(tFacilityOID)' >
<true>
<assign value='##class(HS.Data.OIDMap).GetCodeForOID(tFacilityOID,"UnexpectedFacilityOIDLookUp")' property='target.{12.14.1}' action='set' />
<assign value='tFacilityOID' property='target.{12.14.2}' action='set' />
<assign value='"ISO"' property='target.{12.14.3}' action='set' />
</true>
</if>
<assign value='"L"' property='target.{12.10}' action='set' />
<assign value='"NPI"' property='target.{12.13}' action='set' />
</true>
</if>
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 14(1)
 #;
]]></code>
<assign value='##class(EnsLib.EDI.XML.Document).ImportFromString("&lt;Phone&gt;"_$Piece(source.{/LabOrder/CallbackNumber},",")_"&lt;/Phone&gt;")' property='tPhone' action='set' />
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
 #; 14(2)
 #;
]]></code>
<assign value='##class(EnsLib.EDI.XML.Document).ImportFromString("&lt;Phone&gt;"_$Piece(source.{/LabOrder/CallbackNumber},",",2)_"&lt;/Phone&gt;")' property='tPhone' action='set' />
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.Phone' targetObj='tSegment' sourceObj='tPhone' />
<assign value='$Translate(tSegment.OutputToString(),$Char(13),"")' property='tPhoneNumber' action='set' />
<if condition='+$Length(tPhoneNumber)' >
<true>
<assign value='tPhoneNumber' property='target.{14(2)}' action='set' />
<assign value='"WPN"' property='target.{14(2).2}' action='set' />
<assign value='"PH"' property='target.{14(2).3}' action='set' />
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 21  -- OID in source messages matches MSH:5 even though the name is different
 #;  	-- Also Doesn't seem like 21.6.1 should be in SDACodingStandard as it is set to NIST Sending Application
]]></code>
<if condition='+$Length(source.{/LabOrder/EnteredAt/Description})' >
<true>
<assign value='source.{/LabOrder/EnteredAt/Description}' property='target.{21(1).1}' action='set' />
<assign value='"L"' property='target.{21(1).2}' action='set' />
<assign value='..ReplaceStr(source.{/LabOrder/EnteredAt/SDACodingStandard},"&amp;amp;","&amp;")' property='target.{21(1).6}' action='set' />
<assign value='source.{/LabOrder/EnteredAt/Code}' property='target.{21(1).10}' action='set' />
</true>
</if>
<if condition='+$Length(target.{21(1).10})' >
<true>
<assign value='"XX"' property='target.{21(1).7}' action='set' />
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 22 - Ordering Facility Address
 #;
]]></code>
<assign value='##class(EnsLib.EDI.XML.Document).ImportFromString("&lt;Address&gt;"_source.{/LabOrder/EnteredAt/Address}_"&lt;/Address&gt;")' property='tAddress' action='set' />
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.Address' targetObj='tSegment' sourceObj='tAddress' />
<assign value='$Translate(tSegment.OutputToString(),$Char(13),"")' property='target.{22}' action='set' />
<foreach property='target.{22()}' key='k2' >
<annotation>Set Address type to L for Legal</annotation>
<if condition='+$Length(target.{22(k2).1})' >
<true>
<assign value='"L"' property='target.{22(k2).7}' action='set' />
</true>
</if>
</foreach>

<code>
<![CDATA[ 
 #;
 #; 23 - Ordering Facility Phone Number
 #;
]]></code>
<assign value='##class(EnsLib.EDI.XML.Document).ImportFromString("&lt;Phone&gt;"_source.{/LabOrder/EnteredAt/ContactInfo/WorkPhoneNumber}_"&lt;/Phone&gt;")' property='tPhone' action='set' />
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.Phone' targetObj='tSegment' sourceObj='tPhone' />
<assign value='$Translate(tSegment.OutputToString(),$Char(13),"")' property='tPhoneNumber' action='set' />
<if condition='+$Length(tPhoneNumber)' >
<true>
<assign value='tPhoneNumber' property='target.{23}' action='set' />
<assign value='"WPN"' property='target.{23.2}' action='set' />
<assign value='"PH"' property='target.{23.3}' action='set' />
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 24 - Ordering Provider Address
 #; 
]]></code>
<if condition='+$Length(source.{/LabOrder/OrderedBy/Address/Street})' >
<true>
<assign value='##class(EnsLib.EDI.XML.Document).ImportFromString("&lt;Address&gt;"_source.{/LabOrder/OrderedBy/Address}_"&lt;/Address&gt;")' property='tAddress' action='set' />
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.Address' targetObj='tSegment' sourceObj='tAddress' />
<assign value='$Translate(tSegment.OutputToString(),$Char(13),"")' property='target.{24}' action='set' />
</true>
<false>
<assign value='target.{22}' property='target.{24}' action='set' />
</false>
</if>
</transform>
}

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

}
