/// JS PJH - SDA3 Encounter to HL7 PV1 Sub Transform
Class HS.Gateway.SDA3.SDA3ToHL7.SubTransform.EncounterToPV1 Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.EDI.XML.Document, EnsLib.HL7.Segment) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.XML.Document' targetClass='EnsLib.HL7.Segment' sourceDocType='HS.SDA3:Encounter' targetDocType='2.5.1:PV1' create='new' language='objectscript' >
<code>
<![CDATA[ 
 /*
 Revision History:
   2013-05-15 Paul Hula: Created
 Documentation: 

 */
]]></code>
<code>
<![CDATA[ 
 #;
 #; 1 2
 #;
]]></code>
<assign value='"1"' property='target.{1}' action='set' />
<assign value='source.{/Encounter/EncounterType}' property='target.{2}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 4
 #;
]]></code>
<assign value='source.{/Encounter/AdmissionType/Code}' property='target.{4}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 19
 #;
]]></code>
<assign value='source.{/Encounter/EncounterNumber}' property='tEncounterNo' action='set' />
<if condition='+$Length(tEncounterNo)' >
<true>
<if condition='$Length(tEncounterNo)&gt;15'>
<true>
<if condition='tEncounterNo["-"' >
<true>
<assign value='$Piece(tEncounterNo,"-")' property='tEncounterNo' action='set' />
</true>
<false>
<assign value='$Extract(tEncounterNo,1,15)' property='tEncounterNo' action='set' />
</false>
</if>
</true>
</if>
<assign value='tEncounterNo' property='target.{19.1}' action='set' />
<assign value='source.{EnteredAt.Code}' property='target.{19.4.2}' action='set' />
<assign value='source.{EnteredAt.Description}' property='target.{19.4.1}' action='set' />
<assign value='source.{EnteredAt.SDACodingStandard}' property='target.{19.4.3}' action='set' />
<assign value='"VN"' property='target.{19.5}' action='set' />
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; 36
 #;
]]></code>
<assign value='source.{/Encounter/SeparationMode/Code}' property='target.{36}' action='set' />
<code>
<![CDATA[ 
 #;
 #; 44 For F(3)-SS_1_1.1
 #; 44 45
 #;
]]></code>
<assign value='##class(HS.Gateway.SDA3.SDA3ToHL7.TransformUtil).XMLTimeStampToDateTime(source.{/Encounter/FromTime})' property='target.{44}' action='set' />
<assign value='##class(HS.Gateway.SDA3.SDA3ToHL7.TransformUtil).XMLTimeStampToDateTime(source.{/Encounter/ToTime})' property='target.{45}' action='set' />

</transform>
}

}
