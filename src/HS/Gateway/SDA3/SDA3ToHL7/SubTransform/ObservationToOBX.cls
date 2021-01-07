Class HS.Gateway.SDA3.SDA3ToHL7.SubTransform.ObservationToOBX Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.EDI.XML.Document, EnsLib.HL7.Segment) ]
{

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.XML.Document' targetClass='EnsLib.HL7.Segment' sourceDocType='HS.SDA3:Observation' targetDocType='2.5:OBX' create='new' language='objectscript' >
<code>
<![CDATA[ 
 #;
 #; 3
 #;
]]></code>
<assign value='source.{/Observation/ObservationCode/Code}' property='target.{3.1}' action='set' />
<assign value='source.{/Observation/ObservationCode/Description}' property='target.{3.2}' action='set' />
<assign value='source.{/Observation/ObservationCode/SDACodingStandard}' property='target.{3.3}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 4 11
 #;
]]></code>
<if condition='+$Length(target.{3.1})' >
<true>
<assign value='source.{/Observation/GroupId}' property='target.{4}' action='set' />
<assign value='"F"' property='target.{11}' action='set' />
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 2 5 14
 #;
]]></code>
<assign value='source.{/Observation/ObservationValueType}' property='target.{2}' action='set' />
<if condition='"CE,CWE,CNE,"[target.{2}' >
<true>
<assign value='source.{/Observation/ObservationCodedValue/Code}' property='target.{5.1}' action='set' />
<assign value='source.{/Observation/ObservationCodedValue/Description}' property='target.{5.2}' action='set' />
<assign value='source.{/Observation/ObservationCodedValue/SDACodingStandard}' property='target.{5.3}' action='set' />
<if condition='+$Length(source.{/Observation/ObservationCodedValue/CodeSystemVersionId})' >
<annotation>If stmt not necessary but added for easier comparison of source and target messages</annotation>
<true>
<assign value='source.{/Observation/ObservationCodedValue/CodeSystemVersionId}' property='target.{5.7}' action='set' />
</true>
</if>
<if condition='+$Length(source.{/Observation/ObservationCodedValue/OriginalText})' >
<annotation>If stmt not necessary but added for easier comparison of source and target messages</annotation>
<true>
<assign value='source.{/Observation/ObservationCodedValue/OriginalText}' property='target.{5.9}' action='set' />
</true>
</if>
<if condition='+$Length(source.{/LabResultItem/ResultCodedValue/PriorCodes/[1]/Code})||+$Length(source.{/LabResultItem/ResultCodedValue/PriorCodes/[1]/Description})' >
<annotation>If stmt not necessary but added for easier comparison of source and target messages</annotation>
<true>
<assign value='source.{/Observation/ObservationCodedValue/PriorCodes/[1]/Code}' property='target.{5.4}' action='set' />
<assign value='source.{/Observation/ObservationCodedValue/PriorCodes/[1]/Description}' property='target.{5.5}' action='set' />
<assign value='source.{/Observation/ObservationCodedValue/PriorCodes/[1]/CodeSystem}' property='target.{5.6}' action='set' />
<assign value='source.{/Observation/ObservationCodedValue/PriorCodes/[1]/CodeSystemVersionId}' property='target.{5.8}' action='set' />
</true>
</if>


</true>
</if>
<if condition='"TS,DT"[target.{2}' >
<true>
<assign value='##class(HS.Gateway.SDA3.SDA3ToHL7.TransformUtil).XMLTimeStampToDateTime(source.{/Observation/ObservationValueTime})' property='target.{5.1}' action='set' />
</true>
</if>
<if condition='"SN"=target.{2}' >
<true>
<assign value='##class(HS.Gateway.SDA3.SDA3ToHL7.TransformUtil).StructuredNumeric(source.{/Observation/ObservationValue},target.CS)' property='target.{5}' action='set' />
</true>
</if>
<if condition='&apos;("CE,CWE,CNE,TS,DT,SN"[target.{2})' >
<true>
<assign value='source.{/Observation/ObservationValue}' property='target.{5.1}' action='set' />
</true>
</if>
<assign value='##class(HS.Gateway.SDA3.SDA3ToHL7.TransformUtil).XMLTimeStampToDate(source.{/Observation/ObservationTime})' property='target.{14.1}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 6
 #;
]]></code>
<assign value='source.{/Observation/ObservationCode/ObservationValueUnits/Code}' property='target.{6.1}' action='set' />
<if condition='+$Length(target.{6.1})'>
<true>
<assign value='source.{/Observation/ObservationCode/ObservationValueUnits/Description}' property='target.{6.2}' action='set' />
<assign value='source.{/Observation/ObservationCode/ObservationValueUnits/SDACodingStandard}' property='target.{6.3}' action='set' />
<if condition='target.{6.3}="UCUM"'>
<true>
<assign value='..Lookup("UCUM",target.{6.1})' property='target.{6.2}' action='set' />
</true>
</if>
<assign value='target.{6.1}' property='target.{6.4}' action='set' />
<assign value='target.{6.2}' property='target.{6.5}' action='set' />
<assign value='"L"' property='target.{6.6}' action='set' />
<assign value='"1.1"' property='target.{6.7}' action='set' />
<assign value='"V1"' property='target.{6.8}' action='set' />
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 17 - Observation Method
 #;
]]></code>
<if condition='+$Length(source.{ObservationMethods})'>
<true>
<foreach property='source.{ObservationMethods()}' key='k1' >
<assign value='source.{/Observation/ObservationMethods/["_k1_"]/Code}' property='target.{17(k1).1}' action='set' />
<assign value='source.{/Observation/ObservationMethods/["_k1_"]/Description}' property='target.{17(k1).2}' action='set' />
<assign value='source.{/Observation/ObservationMethods/["_k1_"]/SDACodingStandard}' property='target.{17(k1).3}' action='set' />

<if condition='+$Length(source.{/Observation/ObservationMethods/["_k1_"]/CodeSystemVersionId})' >
<annotation>If stmt not necessary but added for easier comparison of source and target messages</annotation>
<true>
<assign value='source.{/Observation/ObservationMethods/["_k1_"]/CodeSystemVersionId}' property='target.{17(k1).7}' action='set' />
</true>
</if>
<if condition='+$Length(source.{/Observation/ObservationMethods/["_k1_"]/OriginalText})' >
<annotation>If stmt not necessary but added for easier comparison of source and target messages</annotation>
<true>
<assign value='source.{/Observation/ObservationMethods/["_k1_"]/OriginalText}' property='target.{5.9}' action='set' />
</true>
</if>

<if condition='+$Length(source.{/Observation/ObservationMethods/["_k1_"]/PriorCodes/[1]/Code})' >
<true>
<assign value='source.{/Observation/ObservationMethods/["_k1_"]/PriorCodes/[1]/Code}' property='target.{17(k1).4}' action='set' />
<assign value='source.{/Observation/ObservationMethods/["_k1_"]/PriorCodes/[1]/Description}' property='target.{17(k1).5}' action='set' />
<assign value='source.{/Observation/ObservationMethods/["_k1_"]/PriorCodes/[1]/CodeSystem}' property='target.{17(k1).6}' action='set' />
<assign value='source.{/Observation/ObservationMethods/["_k1_"]/PriorCodes/[1]/CodeSystemVersionId}' property='target.{17(k1).8}' action='set' />
</true>
</if>
</foreach>
</true>
</if>
</transform>
}

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

}
