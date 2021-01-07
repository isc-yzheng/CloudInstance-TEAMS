/// JS PJH - SDA3 LabOrder to HL7 OBR Sub Transform
Class HS.Gateway.SDA3.SDA3ToHL7.SubTransform.LabOrderToOBR Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.EDI.XML.Document, EnsLib.HL7.Segment) ]
{

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.XML.Document' targetClass='EnsLib.HL7.Segment' sourceDocType='HS.SDA3:LabOrder' targetDocType='2.5.1:OBR' create='new' language='objectscript' >
<code>
<![CDATA[ 
 /*
 */
]]></code>
<code>
<![CDATA[ 
 #;
 #; 2 3.2
 #;
]]></code>
<if condition='+$Length(source.{/LabOrder/PlacerId[2]})' >
<true>
<assign value='source.{/LabOrder/PlacerId[2]}' property='target.{2.1}' action='set' />
<assign value='source.{/LabOrder/PlacerAssigningAuthority[2]}' property='target.{2.2}' action='set' />
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 3
 #;
]]></code>
<assign value='source.{/LabOrder/FillerId[2]}' property='target.{3.1}' action='set' />
<assign value='source.{/LabOrder/FillerAssigningAuthority[2]}' property='target.{3.2}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 4 - Universal Service Identifier
 #;
]]></code>
<assign value='source.{/LabOrder/OrderItem/Code}' property='target.{4.1}' action='set' />
<assign value='source.{/LabOrder/OrderItem/Description}' property='target.{4.2}' action='set' />
<assign value='source.{/LabOrder/OrderItem/SDACodingStandard}' property='target.{4.3}' action='set' />
<assign value='source.{/LabOrder/OrderItem/CodeSystemVersionId}' property='target.{4.7}' action='set' />
<if condition='+$Length(source.{/LabOrder/OrderItem/PriorCodes/[1]})' >
<true>
<assign value='source.{/LabOrder/OrderItem/PriorCodes/[1]/Code}' property='target.{4.4}' action='set' />
<assign value='source.{/LabOrder/OrderItem/PriorCodes/[1]/Description}' property='target.{4.5}' action='set' />
<assign value='source.{/LabOrder/OrderItem/PriorCodes/[1]/CodeSystem}' property='target.{4.6}' action='set' />
<assign value='source.{/LabOrder/OrderItem/PriorCodes/[1]/CodeSystemVersionId}' property='target.{4.8}' action='set' />
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 7 -- ObservationDateTime 
 #; 8 -- Not captured in AbstractOrder -- Set using SPM: 17.2 when available in main transform
]]></code>
<assign value='##class(HS.Gateway.SDA3.SDA3ToHL7.TransformUtil).XMLTimeStampToDateTime(source.{/LabOrder/SpecimenCollectedTime})' property='target.{7.1}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 13
 #;
]]></code>
<assign value='source.{/LabOrder/ClinicalInformation}' property='target.{13}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 16 -- TODO Facility Authority (16.14) seems redundant with Assigning Authority (16.9)
 #;
]]></code>
<if condition='$Length(source.{/LabOrder/OrderedBy/Code})' >
<true>
<if condition='source.{/LabOrder/OrderedBy/Code}&apos;="unknown"' >
<true>
<assign value='source.{/LabOrder/OrderedBy/Code}' property='target.{16.1}' action='set' />
</true>
</if>
<assign value='source.{/LabOrder/OrderedBy/Name/FamilyName}' property='target.{16.2}' action='set' />
<assign value='source.{/LabOrder/OrderedBy/Name/GivenName}' property='target.{16.3}' action='set' />
<assign value='source.{/LabOrder/OrderedBy/Name/MiddleName}' property='target.{16.4}' action='set' />
<assign value='source.{/LabOrder/OrderedBy/Name/NameSuffix}' property='target.{16.5}' action='set' />
<assign value='source.{/LabOrder/OrderedBy/Name/NamePrefix}' property='target.{16.6}' action='set' />
<assign value='source.{/LabOrder/OrderedBy/Name/ProfessionalSuffix}' property='target.{16.21}' action='set' />
<assign value='..ReplaceStr(source.{/LabOrder/OrderedBy/SDACodingStandard},"&amp;amp;","&amp;")' property='target.{16.9}' action='set' />
<if condition='+$Length(target.{16.9})' >
<true>
<assign value='##class(HS.Data.OIDMap).OIDForType(target.{16.9.1},"AssigningAuthority")' property='target.{16.9.2}' action='set' />
<assign value='"ISO"' property='target.{16.9.3}' action='set' />
<assign value='..Lookup("AAToFacilityOIDMap",target.{16.9.2})' property='tFacilityOID' action='set' />
<if condition='+$Length(tFacilityOID)' >
<true>
<assign value='##class(HS.Data.OIDMap).GetCodeForOID(tFacilityOID,"UnexpectedFacilityOIDLookUp")' property='target.{16.14.1}' action='set' />
<assign value='tFacilityOID' property='target.{16.14.2}' action='set' />
<assign value='"ISO"' property='target.{16.14.3}' action='set' />
</true>
</if>
<assign value='"L"' property='target.{16.10}' action='set' />
<assign value='"NPI"' property='target.{16.13}' action='set' />
</true>
</if>
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 17(1)
 #;
]]></code>
<assign value='##class(EnsLib.EDI.XML.Document).ImportFromString("&lt;Phone&gt;"_$Piece(source.{/LabOrder/CallbackNumber},",")_"&lt;/Phone&gt;")' property='tPhone' action='set' />
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.Phone' targetObj='tSegment' sourceObj='tPhone' />
<assign value='$Translate(tSegment.OutputToString(),$Char(13),"")' property='tPhoneNumber' action='set' />
<if condition='+$Length(tPhoneNumber)' >
<true>
<assign value='tPhoneNumber' property='target.{17(1)}' action='set' />
<assign value='"WPN"' property='target.{17(1).2}' action='set' />
<assign value='"PH"' property='target.{17(1).3}' action='set' />
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 17(2)
 #;
]]></code>
<assign value='##class(EnsLib.EDI.XML.Document).ImportFromString("&lt;Phone&gt;"_$Piece(source.{/LabOrder/CallbackNumber},",",2)_"&lt;/Phone&gt;")' property='tPhone' action='set' />
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.Phone' targetObj='tSegment' sourceObj='tPhone' />
<assign value='$Translate(tSegment.OutputToString(),$Char(13),"")' property='tPhoneNumber' action='set' />
<if condition='+$Length(tPhoneNumber)' >
<true>
<assign value='tPhoneNumber' property='target.{17(2)}' action='set' />
<assign value='"WPN"' property='target.{17(2).2}' action='set' />
<assign value='"PH"' property='target.{17(2).3}' action='set' />
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 22 and 25
 #;
]]></code>
<assign value='##class(HS.Gateway.SDA3.SDA3ToHL7.TransformUtil).XMLTimeStampToDateTime(source.{/LabOrder/Result/ResultTime})' property='target.{22.1}' action='set' />
<assign value='source.{/LabOrder/Result/ResultStatus}' property='target.{25}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 26 -- Parent Result Observation
 #;
]]></code>
<if condition='+$Length(source.{/LabOrder/ParentResultObservation/Code})' >
<true>
<assign value='source.{/LabOrder/ParentResultObservation/Code}' property='target.{26.1.1}' action='set' />
<assign value='source.{/LabOrder/ParentResultObservation/Description}' property='target.{26.1.2}' action='set' />
<assign value='source.{/LabOrder/ParentResultObservation/SDACodingStandard}' property='target.{26.1.3}' action='set' />
<if condition='+$Length(source.{/LabOrder/ParentResultObservation/PriorCodes/[1]})' >
<true>
<assign value='source.{/LabOrder/ParentResultObservation/PriorCodes/[1]/Code}' property='target.{26.1.4}' action='set' />
<assign value='source.{/LabOrder/ParentResultObservation/PriorCodes/[1]/Description}' property='target.{26.1.5}' action='set' />
<assign value='source.{/LabOrder/ParentResultObservation/PriorCodes/[1]/CodeSystem}' property='target.{26.1.6}' action='set' />
</true>
</if>
<assign value='source.{/LabOrder/ParentResultObservationSubId}' property='target.{26.2}' action='set' />
<assign value='source.{/LabOrder/ParentResultObservationText}' property='target.{26.3}' action='set' />
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 29 -- Parent filler/placer 
 #;
]]></code>
<if condition='+$Length(source.{/LabOrder/ParentPlacerId})' >
<true>
<assign value='..ReplaceStr(source.{/LabOrder/ParentPlacerAssigningAuthority},"^","&amp;")' property='temp' action='set' />
<if condition='+$Length(temp)' >
<true>
<assign value='"&amp;"_temp' property='temp' action='set' />
</true>
</if>
<assign value='source.{/LabOrder/ParentPlacerId}_temp' property='target.{29.1}' action='set' />
</true>
</if>
<if condition='+$Length(source.{/LabOrder/ParentFillerId})' >
<true>
<assign value='..ReplaceStr(source.{/LabOrder/ParentFillerAssigningAuthority},"^","&amp;")' property='temp' action='set' />
<if condition='+$Length(temp)' >
<true>
<assign value='"&amp;"_temp' property='temp' action='set' />
</true>
</if>
<assign value='source.{/LabOrder/ParentFillerId}_temp' property='target.{29.2}' action='set' />
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 31  
 #;
]]></code>
<assign value='source.{/LabOrder/ReasonForStudy/Code}' property='target.{31.1}' action='set' />
<assign value='source.{/LabOrder/ReasonForStudy/Description}' property='target.{31.2}' action='set' />
<assign value='source.{/LabOrder/ReasonForStudy/SDACodingStandard}' property='target.{31.3}' action='set' />
<assign value='source.{/LabOrder/ReasonForStudy/CodeSystemVersionId}' property='target.{31.7}' action='set' />
<if condition='+$Length(source.{/LabOrder/ReasonForStudy/PriorCodes/[1]})' >
<true>
<assign value='source.{/LabOrder/ReasonForStudy/PriorCodes/[1]/Code}' property='target.{31.4}' action='set' />
<assign value='source.{/LabOrder/ReasonForStudy/PriorCodes/[1]/Description}' property='target.{31.5}' action='set' />
<assign value='source.{/LabOrder/ReasonForStudy/PriorCodes/[1]/CodeSystem}' property='target.{31.6}' action='set' />
<assign value='source.{/LabOrder/ReasonForStudy/PriorCodes/[1]/CodeSystemVersionId}' property='target.{31.8}' action='set' />
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 32 (Blanks not allowed)
 #;
]]></code>
<if condition='+$Length(source.{/LabOrder/VerifiedBy/Code})' >
<true>
<assign value='source.{/LabOrder/VerifiedBy/Code}' property='target.{32.1.1}' action='set' />
<assign value='source.{/LabOrder/VerifiedBy/Name/FamilyName}' property='target.{32.1.2}' action='set' />
<assign value='source.{/LabOrder/VerifiedBy/Name/GivenName}' property='target.{32.1.3}' action='set' />
<assign value='source.{/LabOrder/VerifiedBy/Name/MiddleName}' property='target.{32.1.4}' action='set' />
<assign value='source.{/LabOrder/VerifiedBy/Name/NameSuffix}' property='target.{32.1.5}' action='set' />
<assign value='source.{/LabOrder/VerifiedBy/Name/NamePrefix}' property='target.{32.1.6}' action='set' />
<assign value='source.{/LabOrder/VerifiedBy/Name/ProfessionalSuffix}' property='target.{32.1.7}' action='set' />
<assign value='source.{/LabOrder/VerifiedBy/SDACodingStandard}' property='target.{32.1.9}' action='set' />
<assign value='##class(HS.Data.OIDMap).OIDForType(target.{32.1.9},"AssigningAuthority")' property='target.{32.1.10}' action='set' />
<assign value='"ISO"' property='target.{32.1.11}' action='set' />
</true>
</if>
</transform>
}

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

}
