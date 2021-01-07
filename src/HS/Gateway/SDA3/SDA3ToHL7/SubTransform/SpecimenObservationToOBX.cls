/// JS PJH - SDA3 Observation to HL7 OBX Sub Transform
Class HS.Gateway.SDA3.SDA3ToHL7.SubTransform.SpecimenObservationToOBX Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.EDI.XML.Document, EnsLib.HL7.Segment) ]
{

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.XML.Document' targetClass='EnsLib.HL7.Segment' sourceDocType='HS.SDA3:Specimen' targetDocType='2.5.1:OBX' create='new' language='objectscript' >
<code>
<![CDATA[ 
 #;
 #; 3
 #;
]]></code>
<assign value='1' property='target.{1}' action='set' />
<assign value='"SN"' property='target.{2}' action='set' />
<assign value='"35659-2^Age at Specimen Collection^LN^AGE^AGE^L^2.40^V1"' property='target.{3}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 5
 #;
]]></code>
<assign value='source.{/Specimen/Age}' property='target.{5.1}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 6
 #;
]]></code>
<assign value='source.{/Specimen/AgeUnits/Code}' property='target.{6.1}' action='set' />
<assign value='source.{/Specimen/AgeUnits/Description}' property='target.{6.2}' action='set' />
<assign value='source.{/Specimen/AgeUnits/SDACodingStandard}' property='target.{6.3}' action='set' />
<assign value='source.{/Specimen/AgeUnits/CodeSystemVersionId}' property='target.{6.7}' action='set' />
<assign value='..Lookup("PriorUnitOfMeasureId",target.{6.1})' property='target.{6.4}' action='set' />
<if condition='+$Length(target.{6.4})'>
<annotation>If look up successful means we prior code of type L -- this is a hack for what should be a translated code table</annotation>
<true>
<assign value='"L"' property='target.{6.6}' action='set' />
<assign value='"V1"' property='target.{6.8}' action='set' />
<assign value='..Lookup("PriorUnitOfMeasureName",target.{6.4})' property='target.{6.5}' action='set' />
</true>
</if>
</transform>
}

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

}
