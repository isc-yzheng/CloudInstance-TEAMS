/// JS PJH - SDA3 LabOrder to HL7 OBX Sub Transform
Class HS.Gateway.SDA3.SDA3ToHL7.SubTransform.LabResultToOBX Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.EDI.XML.Document, EnsLib.HL7.Segment) ]
{

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.XML.Document' targetClass='EnsLib.HL7.Segment' sourceDocType='HS.SDA3:LabResultItem' targetDocType='2.5.1:OBX' create='new' language='objectscript' >
<code>
<![CDATA[ 
 #;
 #; 2 - Observation Value Type
 #;
]]></code>
<assign value='source.{/LabResultItem/ObservationValueType}' property='target.{2}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 3 - Observation Identifier
 #;
]]></code>
<assign value='..ReplaceStr(source.{/LabResultItem/TestItemCode/Code}," Notes","")' property='target.{3.1}' action='set' />
<assign value='source.{/LabResultItem/TestItemCode/Description}' property='target.{3.2}' action='set' />
<assign value='source.{/LabResultItem/TestItemCode/SDACodingStandard}' property='target.{3.3}' action='set' />
<assign value='source.{/LabResultItem/TestItemCode/CodeSystemVersionId}' property='target.{3.7}' action='set' />
<if condition='$Length(source.{/LabResultItem/TestItemCode/OriginalText})' >
<annotation>Not necessary but added for easier comparison of source and target messages</annotation>
<true>
<assign value='source.{/LabResultItem/TestItemCode/OriginalText}' property='target.{3.9}' action='set' />
</true>
</if>

<if condition='+$Length(source.{/LabResultItem/TestItemCode/PriorCodes/[1]/Code})'>
<true>
<assign value='source.{/LabResultItem/TestItemCode/PriorCodes/[1]/Code}' property='target.{3.4}' action='set' />
<assign value='source.{/LabResultItem/TestItemCode/PriorCodes/[1]/Description}' property='target.{3.5}' action='set' />
<assign value='source.{/LabResultItem/TestItemCode/PriorCodes/[1]/CodeSystem}' property='target.{3.6}' action='set' />
<if condition='+$Length(source.{/LabResultItem/TestItemCode/PriorCodes/[1]/CodeSystemVersionId})' >
<annotation>If stmt not necessary but added for easier comparison of source and target messages</annotation>
<true>
<assign value='source.{/LabResultItem/TestItemCode/PriorCodes/[1]/CodeSystemVersionId}' property='target.{3.8}' action='set' />
</true>
</if>

</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 4 - Observation SubId
 #;
]]></code>
<assign value='source.{/LabResultItem/SubId}' property='target.{4}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 5 - Observation Value
 #;
]]></code>
<if condition='"CE,CWE,CNE,SN"[target.{2}' >
<true>
<if condition='"SN"[target.{2}' >
<true>
<assign value='##class(HS.Gateway.SDA3.SDA3ToHL7.TransformUtil).StructuredNumeric(source.{/LabResultItem/ResultValue},target.CS)' property='target.{5}' action='set' />
</true>
<false>
<assign value='source.{/LabResultItem/ResultCodedValue/Code}' property='target.{5.1}' action='set' />
<assign value='source.{/LabResultItem/ResultCodedValue/Description}' property='target.{5.2}' action='set' />
<assign value='source.{/LabResultItem/ResultCodedValue/SDACodingStandard}' property='target.{5.3}' action='set' />
<if condition='+$Length(source.{/LabResultItem/ResultCodedValue/CodeSystemVersionId})' >
<annotation>If stmt not necessary but added for easier comparison of source and target messages</annotation>
<true>
<assign value='source.{/LabResultItem/ResultCodedValue/CodeSystemVersionId}' property='target.{5.7}' action='set' />
</true>
</if>
<if condition='+$Length(source.{/LabResultItem/ResultCodedValue/OriginalText})' >
<annotation>If stmt not necessary but added for easier comparison of source and target messages</annotation>
<true>
<assign value='source.{/LabResultItem/ResultCodedValue/OriginalText}' property='target.{5.9}' action='set' />
</true>
</if>
<if condition='+$Length(source.{/LabResultItem/ResultCodedValue/PriorCodes/[1]/Code})||+$Length(source.{/LabResultItem/ResultCodedValue/PriorCodes/[1]/Description})' >
<annotation>If stmt not necessary but added for easier comparison of source and target messages</annotation>
<true>
<assign value='source.{/LabResultItem/ResultCodedValue/PriorCodes/[1]/Code}' property='target.{5.4}' action='set' />
<assign value='source.{/LabResultItem/ResultCodedValue/PriorCodes/[1]/Description}' property='target.{5.5}' action='set' />
<assign value='source.{/LabResultItem/ResultCodedValue/PriorCodes/[1]/CodeSystem}' property='target.{5.6}' action='set' />
<if condition='+$Length(source.{/LabResultItem/ResultCodedValue/PriorCodes/[1]/CodeSystemVersionId})' >
<annotation>If stmt not necessary but added for easier comparison of source and target messages</annotation>
<true>
<assign value='source.{/LabResultItem/ResultCodedValue/PriorCodes/[1]/CodeSystemVersionId}' property='target.{5.8}' action='set' />
</true>
</if>
</true>
</if>
</false>
</if>
</true>
<false>
<assign value='source.{/LabResultItem/ResultValue}' property='target.{5}' action='set' />
</false>
</if>


<code>
<![CDATA[ 
 #;
 #; 6 -- Units
 #; 6.4, 6.5, 6.6, and 6.8 are PriorCode or Alt Identifiers while ResultValueUnits is just a string value
 #; Would be nice if could be of type UofM and UofM extended CodeTableTranslated
]]></code>
<assign value='..ReplaceStr(..ReplaceStr(..ReplaceStr(source.{/LabResultItem/ResultValueUnits},"&amp;lt;","&lt;"),"&amp;gt;","&gt;"),"&amp;apos;","&apos;")' property='target.{6.1}' action='set' />
<if condition='+$Length(target.{6.1})'>
<true>
<assign value='..Lookup("UCUM",target.{6.1})' property='target.{6.2}' action='set' />
<if condition='+$Length(target.{6.2})'>
<annotation>If look up successful means we have a UCUM type unit</annotation>
<true>
<assign value='"UCUM"' property='target.{6.3}' action='set' />
<assign value='"1.1"' property='target.{6.7}' action='set' />
</true>
</if>
<assign value='..Lookup("PriorUnitOfMeasureId",target.{6.1})' property='target.{6.4}' action='set' />
<if condition='+$Length(target.{6.4})'>
<annotation>If look up successful means we prior code of type L -- this is a hack for what should be a translated code table</annotation>
<true>
<assign value='"L"' property='target.{6.6}' action='set' />
<assign value='"V1"' property='target.{6.8}' action='set' />
<assign value='..Lookup("PriorUnitOfMeasureName",target.{6.4})' property='target.{6.5}' action='set' />
</true>
</if>
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 7 - Reference Ranges
 #; 8 - Abnormal Flags -- ResultInterpretation is a string
 #; 
]]></code>
<assign value='..ReplaceStr(..ReplaceStr(source.{/LabResultItem/ResultNormalRange},"&amp;lt;","&lt;"),"&amp;gt;","&gt;")' property='target.{7}' action='set' />
<assign value='source.{/LabResultItem/ResultInterpretation}' property='target.{8(1).1}' action='set' />
<if condition='+$Length(target.{8(1).1})'>
<true>
<assign value='..Lookup("AbnormalFlag",source.{/LabResultItem/ResultInterpretation})' property='target.{8(1).2}' action='set' />
<if condition='+$Length(target.{8(1).2})'>
<true>
<assign value='"HL70078"' property='target.{8(1).3}' action='set' />
<assign value='"2.5.1"' property='target.{8(1).7}' action='set' />
<assign value='..Lookup("PriorAbnormalFlagId",target.{8(1).1})' property='target.{8(1).4}' action='set' />
<if condition='+$Length(target.{8(1).4})'>
<true>
<assign value='"L"' property='target.{8(1).6}' action='set' />
<assign value='..Lookup("PriorAbnormalFlagName",target.{8(1).4})' property='target.{8(1).5}' action='set' />
<assign value='"V1"' property='target.{8(1).8}' action='set' />
</true>
</if>
</true>
</if>
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 11
 #;
]]></code>
<assign value='source.{/LabResultItem/TestItemStatus}' property='target.{11}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 17
 #;
]]></code>
<if condition='+$Length(source.{ObservationMethods})'>
<true>
<foreach property='source.{ObservationMethods()}' key='k1' >
<assign value='source.{/LabResultItem/ObservationMethods/["_k1_"]/Code}' property='target.{17(k1).1}' action='set' />
<assign value='source.{/LabResultItem/ObservationMethods/["_k1_"]/Description}' property='target.{17(k1).2}' action='set' />
<assign value='source.{/LabResultItem/ObservationMethods/["_k1_"]/SDACodingStandard}' property='target.{17(k1).3}' action='set' />
<assign value='source.{/LabResultItem/ObservationMethods/["_k1_"]/CodeSystemVersionId}' property='target.{17(k1).7}' action='set' />
<if condition='+$Length(source.{/LabResultItem/ObservationMethods/["_k1_"]/PriorCodes/[1]/Code})' >
<true>
<assign value='source.{/LabResultItem/ObservationMethods/["_k1_"]/PriorCodes/[1]/Code}' property='target.{17(k1).4}' action='set' />
<assign value='source.{/LabResultItem/ObservationMethods/["_k1_"]/PriorCodes/[1]/Description}' property='target.{17(k1).5}' action='set' />
<assign value='source.{/LabResultItem/ObservationMethods/["_k1_"]/PriorCodes/[1]/CodeSystem}' property='target.{17(k1).6}' action='set' />
<assign value='source.{/LabResultItem/ObservationMethods/["_k1_"]/PriorCodes/[1]/CodeSystemVersionId}' property='target.{17(k1).8}' action='set' />
</true>
</if>
</foreach>
</true>
</if>

<code>
<![CDATA[ 
 #;
 #; 19
 #;
]]></code>
<assign value='##class(HS.Gateway.SDA3.SDA3ToHL7.TransformUtil).XMLTimeStampToDateTime(source.{/LabResultItem/AnalysisTime})' property='target.{19.1}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 23 -- Performing Organization 
 #;
]]></code>
<if condition='+$Length(source.{/LabResultItem/PerformedAt/Code})||+$Length(source.{/LabResultItem/PerformedAt/Description})' >
<true>
<assign value='source.{/LabResultItem/PerformedAt/Code}' property='target.{23.10}' action='set' />
<assign value='..ReplaceStr(source.{/LabResultItem/PerformedAt/SDACodingStandard},"&amp;amp;","&amp;")' property='target.{23.6}' action='set' />
<assign value='source.{/LabResultItem/PerformedAt/Description}' property='target.{23.1}' action='set' />
</true>
</if>
<if condition='+$Length(target.{23.1})'>
<true>
<assign value='"L"' property='target.{23.2}' action='set' />
</true>
</if>
<if condition='+$Length(target.{23.10})'>
<true>
<assign value='"XX"' property='target.{23.7}' action='set' />
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 24 -- Performing Organization Address
 #;
]]></code>
<assign value='##class(EnsLib.EDI.XML.Document).ImportFromString("&lt;Address&gt;"_source.{/LabResultItem/PerformedAt/Address}_"&lt;/Address&gt;")' property='tAddress' action='set' />
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.Address' targetObj='tSegment' sourceObj='tAddress' />
<assign value='$Translate(tSegment.OutputToString(),$Char(13),"")' property='target.{24}' action='set' />
<foreach property='target.{24()}' key='k2' >
<annotation>Set Address type to L for Legal</annotation>
<if condition='+$Length(target.{24(k2).1})' >
<true>
<assign value='"L"' property='target.{24(k2).7}' action='set' />
</true>
</if>
</foreach>

<code>
<![CDATA[ 
 #;
 #; 25 -- Performing Organization Medical Director
 #;
]]></code>
<if condition='+$Length(source.{/LabResultItem/PerformedAt/MedicalDirector/Code})'>
<true>
<assign value='source.{/LabResultItem/PerformedAt/MedicalDirector/Code}' property='target.{25.1}' action='set' />
</true>
</if>
<assign value='source.{/LabResultItem/PerformedAt/MedicalDirector/Name/FamilyName}' property='target.{25.2}' action='set' />
<assign value='source.{/LabResultItem/PerformedAt/MedicalDirector/Name/GivenName}' property='target.{25.3}' action='set' />
<assign value='source.{/LabResultItem/PerformedAt/MedicalDirector/Name/MiddleName}' property='target.{25.4}' action='set' />
<assign value='source.{/LabResultItem/PerformedAt/MedicalDirector/Name/NameSuffix}' property='target.{25.5}' action='set' />
<assign value='source.{/LabResultItem/PerformedAt/MedicalDirector/Name/NamePrefix}' property='target.{25.6}' action='set' />
<assign value='source.{/LabResultItem/PerformedAt/MedicalDirector/Name/ProfessionalSuffix}' property='target.{25.21}' action='set' />
<if condition='+$Length(target.{25.1})'>
<true>
<assign value='"L"' property='target.{25.10}' action='set' />
<assign value='"NPI"' property='target.{25.13}' action='set' />
</true>
</if>

</transform>
}

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

}
