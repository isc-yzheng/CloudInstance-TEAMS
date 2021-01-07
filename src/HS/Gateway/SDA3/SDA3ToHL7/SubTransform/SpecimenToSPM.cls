/// JS PJH - SDA3 OtherOrder to HL7 SPM Sub Transform
Class HS.Gateway.SDA3.SDA3ToHL7.SubTransform.SpecimenToSPM Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.EDI.XML.Document, EnsLib.HL7.Segment) ]
{

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.XML.Document' targetClass='EnsLib.HL7.Segment' sourceDocType='HS.SDA3:Specimen' targetDocType='2.5.1:SPM' create='new' language='objectscript' >
<code>
<![CDATA[ 
 #;
 #; 1
 #;
]]></code>
<assign value='"1"' property='target.{1}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 2
 #;
]]></code>
<if condition='$Extract(source.{/Specimen/ExternalId})="^"' >
<true>
<assign value='$ZCVT($Extract(source.{/Specimen/ExternalId},2,999),"I","XML")' property='target.{2.2}' action='set' />
</true>
<false>
<assign value='$ZCVT(source.{/Specimen/ExternalId},"I","XML")' property='target.{2.2}' action='set' />
</false>
</if>
<code>
<![CDATA[ 
 #;
 #; 4
 #;
]]></code>
<assign value='source.{/Specimen/SpecimenType/Code}' property='target.{4.1}' action='set' />
<assign value='source.{/Specimen/SpecimenType/Description}' property='target.{4.2}' action='set' />
<assign value='source.{/Specimen/SpecimenType/SDACodingStandard}' property='target.{4.3}' action='set' />
<assign value='source.{/Specimen/SpecimenType/CodeSystemVersionId}' property='target.{4.7}' action='set' />
<if condition='+$Length(source.{/Specimen/SpecimenType/PriorCodes/[1]/Code})' >
<true>
<assign value='source.{/Specimen/SpecimenType/PriorCodes/[1]/Code}' property='target.{4.4}' action='set' />
<assign value='source.{/Specimen/SpecimenType/PriorCodes/[1]/Description}' property='target.{4.5}' action='set' />
<assign value='source.{/Specimen/SpecimenType/PriorCodes/[1]/CodeSystem}' property='target.{4.6}' action='set' />
<assign value='source.{/Specimen/SpecimenType/PriorCodes/[1]/CodeSystemVersionId}' property='target.{4.8}' action='set' />
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 5 - Specimen Type Modifiers
 #;
]]></code>
<if condition='+$Length(source.{/Specimen/SpecimenTypeModifiers})'>
<true>
<foreach property='source.{SpecimenTypeModifiers()}' key='k1' >
<assign value='source.{/Specimen/SpecimenTypeModifiers/["_k1_"]/Code}' property='target.{5(k1).1}' action='set' />
<assign value='source.{/Specimen/SpecimenTypeModifiers/["_k1_"]/Description}' property='target.{5(k1).2}' action='set' />
<assign value='source.{/Specimen/SpecimenTypeModifiers/["_k1_"]/SDACodingStandard}' property='target.{5(k1).3}' action='set' />
<assign value='source.{/Specimen/SpecimenTypeModifiers/["_k1_"]/CodeSystemVersionId}' property='target.{5(k1).7}' action='set' />
<if condition='+$Length(source.{/Specimen/SpecimenTypeModifiers/["_k1_"]/PriorCodes/[1]/Code})' >
<true>
<assign value='source.{/Specimen/SpecimenTypeModifiers/["_k1_"]/PriorCodes/[1]/Code}' property='target.{5(k1).4}' action='set' />
<assign value='source.{/Specimen/SpecimenTypeModifiers/["_k1_"]/PriorCodes/[1]/Description}' property='target.{5(k1).5}' action='set' />
<assign value='source.{/Specimen/SpecimenTypeModifiers/["_k1_"]/PriorCodes/[1]/CodeSystem}' property='target.{5(k1).6}' action='set' />
<assign value='source.{/Specimen/SpecimenTypeModifiers/["_k1_"]/PriorCodes/[1]/CodeSystemVersionId}' property='target.{5(k1).8}' action='set' />
</true>
</if>
</foreach>
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 6 -- Specimen Additives
 #;
]]></code>
<if condition='+$Length(source.{/Specimen/SpecimenAdditives})'>
<true>
<foreach property='source.{SpecimenAdditives()}' key='k1' >
<assign value='source.{/Specimen/SpecimenAdditives/["_k1_"]/Code}' property='target.{6(k1).1}' action='set' />
<assign value='source.{/Specimen/SpecimenAdditives/["_k1_"]/Description}' property='target.{6(k1).2}' action='set' />
<assign value='source.{/Specimen/SpecimenAdditives/["_k1_"]/SDACodingStandard}' property='target.{6(k1).3}' action='set' />
<assign value='source.{/Specimen/SpecimenAdditives/["_k1_"]/CodeSystemVersionId}' property='target.{6(k1).7}' action='set' />
<if condition='+$Length(source.{/Specimen/SpecimenAdditives/["_k1_"]/PriorCodes/[1]/Code})' >
<true>
<assign value='source.{/Specimen/SpecimenAdditives/["_k1_"]/PriorCodes/[1]/Code}' property='target.{6(k1).4}' action='set' />
<assign value='source.{/Specimen/SpecimenAdditives/["_k1_"]/PriorCodes/[1]/Description}' property='target.{6(k1).5}' action='set' />
<assign value='source.{/Specimen/SpecimenAdditives/["_k1_"]/PriorCodes/[1]/CodeSystem}' property='target.{6(k1).6}' action='set' />
<assign value='source.{/Specimen/SpecimenAdditives/["_k1_"]/PriorCodes/[1]/CodeSystemVersionId}' property='target.{6(k1).8}' action='set' />
</true>
</if>
</foreach>
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 7 - Collection Method
 #;
]]></code>
<assign value='source.{/Specimen/CollectionMethod/Code}' property='target.{7.1}' action='set' />
<assign value='source.{/Specimen/CollectionMethod/Description}' property='target.{7.2}' action='set' />
<assign value='source.{/Specimen/CollectionMethod/SDACodingStandard}' property='target.{7.3}' action='set' />
<assign value='source.{/Specimen/CollectionMethod/CodeSystemVersionId}' property='target.{7.7}' action='set' />
<if condition='+$Length(source.{/Specimen/CollectionMethod/PriorCodes/[1]/Code})' >
<true>
<assign value='source.{/Specimen/CollectionMethod/PriorCodes/[1]/Code}' property='target.{7.4}' action='set' />
<assign value='source.{/Specimen/CollectionMethod/PriorCodes/[1]/Description}' property='target.{7.5}' action='set' />
<assign value='source.{/Specimen/CollectionMethod/PriorCodes/[1]/CodeSystem}' property='target.{7.6}' action='set' />
<assign value='source.{/Specimen/CollectionMethod/PriorCodes/[1]/CodeSystemVersionId}' property='target.{7.8}' action='set' />
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 8 - Source Site
 #;
]]></code>
<assign value='source.{/Specimen/SpecimenSourceSite/Code}' property='target.{8.1}' action='set' />
<assign value='source.{/Specimen/SpecimenSourceSite/Description}' property='target.{8.2}' action='set' />
<assign value='source.{/Specimen/SpecimenSourceSite/SDACodingStandard}' property='target.{8.3}' action='set' />
<assign value='source.{/Specimen/SpecimenSourceSite/CodeSystemVersionId}' property='target.{8.7}' action='set' />
<if condition='+$Length(source.{/Specimen/SpecimenSourceSite/PriorCodes/[1]/Code})' >
<true>
<assign value='source.{/Specimen/SpecimenSourceSite/PriorCodes/[1]/Code}' property='target.{8.4}' action='set' />
<assign value='source.{/Specimen/SpecimenSourceSite/PriorCodes/[1]/Description}' property='target.{8.5}' action='set' />
<assign value='source.{/Specimen/SpecimenSourceSite/PriorCodes/[1]/CodeSystem}' property='target.{8.6}' action='set' />
<assign value='source.{/Specimen/SpecimenSourceSite/PriorCodes/[1]/CodeSystemVersionId}' property='target.{8.8}' action='set' />
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 9 - Source Site Modifiers
 #;
]]></code>
<if condition='+$Length(source.{/Specimen/SpecimenSourceSiteModifiers})'>
<true>
<foreach property='source.{SpecimenSourceSiteModifiers()}' key='k1' >
<assign value='source.{/Specimen/SpecimenSourceSiteModifiers/["_k1_"]/Code}' property='target.{9(k1).1}' action='set' />
<assign value='source.{/Specimen/SpecimenSourceSiteModifiers/["_k1_"]/Description}' property='target.{9(k1).2}' action='set' />
<assign value='source.{/Specimen/SpecimenSourceSiteModifiers/["_k1_"]/SDACodingStandard}' property='target.{9(k1).3}' action='set' />
<assign value='source.{/Specimen/SpecimenSourceSiteModifiers/["_k1_"]/CodeSystemVersionId}' property='target.{9(k1).7}' action='set' />
<if condition='+$Length(source.{/Specimen/SpecimenSourceSiteModifiers/["_k1_"]/PriorCodes/[1]/Code})' >
<true>
<assign value='source.{/Specimen/SpecimenSourceSiteModifiers/["_k1_"]/PriorCodes/[1]/Code}' property='target.{9(k1).4}' action='set' />
<assign value='source.{/Specimen/SpecimenSourceSiteModifiers/["_k1_"]/PriorCodes/[1]/Description}' property='target.{9(k1).5}' action='set' />
<assign value='source.{/Specimen/SpecimenSourceSiteModifiers/["_k1_"]/PriorCodes/[1]/CodeSystem}' property='target.{9(k1).6}' action='set' />
<assign value='source.{/Specimen/SpecimenSourceSiteModifiers/["_k1_"]/PriorCodes/[1]/CodeSystemVersionId}' property='target.{9(k1).8}' action='set' />
</true>
</if>
</foreach>
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 11 - Specimen Roles
 #;
]]></code>
<if condition='+$Length(source.{/Specimen/SpecimenRoles})'>
<true>
<foreach property='source.{/Specimen/SpecimenRoles()}' key='k1' >
<assign value='source.{/Specimen/SpecimenRoles/["_k1_"]/Code}' property='target.{11(k1).1}' action='set' />
<assign value='source.{/Specimen/SpecimenRoles/["_k1_"]/Description}' property='target.{11(k1).2}' action='set' />
<assign value='source.{/Specimen/SpecimenRoles/["_k1_"]/SDACodingStandard}' property='target.{11(k1).3}' action='set' />
<assign value='source.{/Specimen/SpecimenRoles/["_k1_"]/CodeSystemVersionId}' property='target.{11(k1).7}' action='set' />
<if condition='+$Length(source.{/Specimen/SpecimenRoles/["_k1_"]/PriorCodes/[1]/Code})' >
<true>
<assign value='source.{/Specimen/SpecimenRoles/["_k1_"]/PriorCodes/[1]/Code}' property='target.{11(k1).4}' action='set' />
<assign value='source.{/Specimen/SpecimenRoles/["_k1_"]/PriorCodes/[1]/Description}' property='target.{11(k1).5}' action='set' />
<assign value='source.{/Specimen/SpecimenRoles/["_k1_"]/PriorCodes/[1]/CodeSystem}' property='target.{11(k1).6}' action='set' />
<assign value='source.{/Specimen/SpecimenRoles/["_k1_"]/PriorCodes/[1]/CodeSystemVersionId}' property='target.{11(k1).8}' action='set' />
</true>
</if>
</foreach>
</true>
</if>
<code>
<![CDATA[
 #;
 #; 12 - Collection Amount and unit of measure
 #;
]]></code>
<if condition='+$Length(source.{/Specimen/CollectionAmount})'>
<true>
<assign value='source.{/Specimen/CollectionAmount}' property='target.{12.1}' action='set' />
<assign value='source.{/Specimen/CollectionAmountUnits/Code}' property='target.{12.2.1}' action='set' />
<assign value='source.{/Specimen/CollectionAmountUnits/Description}' property='target.{12.2.2}' action='set' />
<assign value='source.{/Specimen/CollectionAmountUnits/SDACodingStandard}' property='target.{12.2.3}' action='set' />
<assign value='source.{/Specimen/CollectionAmountUnits/CodeSystemVersionId}' property='target.{12.2.7}' action='set' />
<assign value='..Lookup("PriorUnitOfMeasureId",target.{12.2.1})' property='target.{12.2.4}' action='set' />
<if condition='+$Length(target.{12.2.4})'>
<annotation>If look up successful means we prior code of type L -- this is a hack for what should be a translated code table</annotation>
<true>
<assign value='"L"' property='target.{12.2.6}' action='set' />
<assign value='"V1"' property='target.{12.2.8}' action='set' />
<assign value='..Lookup("PriorUnitOfMeasureName",target.{12.2.4})' property='target.{12.2.5}' action='set' />
</true>
</if>
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 17 18
 #;
]]></code>
<assign value='##class(HS.Gateway.SDA3.SDA3ToHL7.TransformUtil).XMLTimeStampToDateTime(source.{/Specimen/FromTime})' property='target.{17.1}' action='set' />
<if condition='+$Length(source.{/Specimen/ToTime})'>
<true>
<assign value='##class(HS.Gateway.SDA3.SDA3ToHL7.TransformUtil).XMLTimeStampToDateTime(source.{/Specimen/ToTime})' property='target.{17.2}' action='set' />
</true>
</if>
<assign value='##class(HS.Gateway.SDA3.SDA3ToHL7.TransformUtil).XMLTimeStampToDateTime(source.{/Specimen/EnteredOn})' property='target.{18.1}' action='set' />
</transform>
}

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

}
