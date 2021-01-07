Class HS.Gateway.SDA3.SDA3ToHL7.ADTA0N Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.EDI.XML.Document, EnsLib.HL7.Message) ]
{

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.XML.Document' targetClass='EnsLib.HL7.Message' sourceDocType='HS.SDA3:Container' targetDocType='2.5.1:ADT_A01' create='new' language='objectscript' >
<code>
<![CDATA[ 
 #;
 #; MSH  
 #; 
]]></code>
<assign value='"|"' property='target.{MSH:1}' action='set' />
<assign value='"^~\&amp;"' property='target.{MSH:2}' action='set' />
<assign value='source.GetValueAt("/Container/SendingFacility")' property='tFacilityName' action='set' />
<assign value='tFacilityName' property='target.{MSH:4.1}' action='set' />
<assign value='..Lookup("FacilityNameToNISTID",target.{MSH:4.1})' property='target.{MSH:4.2}' action='set' />
<assign value='"NPI"' property='target.{MSH:4.3}' action='set' />
<assign value='##class(HS.Gateway.SDA3.SDA3ToHL7.TransformUtil).DateTime()' property='target.{MSH:7}' action='set' />
<assign value='source.GetValueAt("/Container/EventDescription")' property='tEventDesc' action='set' />
<assign value='$Translate($Extract(tEventDesc,1,7),"_","^")_"^"_$Translate(target.GetSegmentAt("MSH").Unescape($Extract(tEventDesc,9,*)),"^","_")' property='target.{MSH:9}' action='set' />
<assign value='$ZTS' property='target.{MSH:10}' action='set' />
<assign value='"P"' property='target.{MSH:11}' action='set' />
<assign value='"2.5.1"' property='target.{MSH:12}' action='set' />
<assign value='"AL"' property='target.{MSH:15}' action='set' />
<assign value='"AL"' property='target.{MSH:16}' action='set' />
<assign value='"PH_SS-Ack^SS Sender^2.16.840.1.114222.4.10.3^ISO"' property='target.{MSH:21}' action='set' />
<code>
<![CDATA[ 
 #;
 #; EVN
 #; 
]]></code>
<assign value='target.{MSH:4}' property='target.{EVN:EventFacility}' action='set' />
<assign value='##class(HS.Gateway.SDA3.SDA3ToHL7.TransformUtil).DateTime(,1)' property='target.{EVN:RecordedDateTime}' action='set' />
<code>
<![CDATA[ 
 #;
 #; PID
 #; 
]]></code>
<assign value='##class(EnsLib.EDI.XML.Document).ImportFromString("&lt;Patient&gt;"_source.GetValueAt("/Container/Patient/")_"&lt;/Patient&gt;")' property='tPatient' action='set' />
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.PatientToPID' targetObj='target.{PID}' sourceObj='tPatient' />
<foreach property='target.{PID:3()}' key='k1' >
<annotation>Change MRN to MR</annotation>
<if condition='target.{PID:3(k1).5}="MRN"' >
<true>
<assign value='"MR"' property='target.{PID:3(k1).5}' action='set' />
</true>
</if>
</foreach>
<if condition='target.{PID:30}="N"' >
<true>
<assign value='""' property='target.{PID:30}' action='set' />
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; All this is just removing un-used parts to make comparisons easier
 #; Not strictly necessary
]]></code>
<assign value='""' property='target.{PID:5(1).7}' action='set' />
<assign value='""' property='target.{PID:15}' action='set' />
<assign value='""' property='target.{PID:16}' action='set' />
<assign value='""' property='target.{PID:17}' action='set' />

<if condition='$Length(target.{PID:22})' >
<true>
<assign value='target.{PID:22}' property='target.{PID:33}' action='set' />
<assign value='""' property='target.{PID:22}' action='set' />
<assign value='target.{PID:33.1}' property='target.{PID:22.1}' action='set' />
<assign value='target.{PID:33.2}' property='target.{PID:22.2}' action='set' />
<assign value='target.{PID:33.3}' property='target.{PID:22.3}' action='set' />
</true>
</if>
<assign value='$Extract(target.{PID:29},1,12)' property='target.{PID:29}' action='set' />
<assign value='""' property='target.{PID:33}' action='set' />
<assign value='""' property='target.{PID:34}' action='set' />
<code>
<![CDATA[ 
 #;
 #; PV1/PV2
 #; 
]]></code>
<if condition='+$Length(source.{/Container/Encounters/[1]})'>
<true>
<assign value='##class(EnsLib.EDI.XML.Document).ImportFromString("&lt;Encounter&gt;"_source.{/Container/Encounters/[1]}_"&lt;/Encounter&gt;")' property='tEncounter' action='set' />
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.EncounterToPV1' targetObj='target.{PV1}' sourceObj='tEncounter' />
<code>
<![CDATA[ 
 #;
 #; PV2
 #; 
]]></code>
<assign value='$Extract(target.{PV1:44},1,12)' property='target.{PV1:44}' action='set' >
<annotation>Strictly not necessary just for comparison reasons</annotation>
</assign>
<if condition='+$Length(source.{/Container/Encounters/[1]/AdmitReason/Code})'>
<true>
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.EncounterToPV2' targetObj='target.{PV2}' sourceObj='tEncounter' />
</true>
</if>
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; DG1
 #; 
]]></code>
<foreach property='source.{Diagnoses()}' key='k1' >
<assign value='k1' property='target.{DG1(k1):SetIDDG1}' action='set' />
<assign value='source.GetValueAt("/Container/Diagnoses/["_k1_"]/Diagnosis/Code")' property='target.{DG1(k1):DiagnosisCodeDG1.Identifier}' action='set' />
<assign value='source.GetValueAt("/Container/Diagnoses/["_k1_"]/Diagnosis/Description")' property='target.{DG1(k1):DiagnosisCodeDG1.Text}' action='set' />
<assign value='source.GetValueAt("/Container/Diagnoses/["_k1_"]/Diagnosis/SDACodingStandard")' property='target.{DG1(k1):DiagnosisCodeDG1.NameofCodingSystem}' action='set' />
<assign value='source.GetValueAt("/Container/Diagnoses/["_k1_"]/DiagnosisType/Code")' property='target.{DG1(k1):DiagnosisType}' action='set' />
</foreach>

<foreach property='source.{Observations()}' key='k3' >
<assign value='""' property='tObservation' action='set' />
<assign value='##class(EnsLib.EDI.XML.Document).ImportFromString("&lt;Observation&gt;"_source.GetValueAt("/Container/Observations/["_k3_"]")_"&lt;/Observation&gt;")' property='tObservation' action='set' />
<code>
<![CDATA[ 
 #;
 #; OBX
 #; 
]]></code>
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.ObservationToOBX' targetObj='target.{OBX(k3)}' sourceObj='tObservation' />
<assign value='k3' property='target.{OBX(k3):1}' action='set' />
<if condition='+$Length(target.{OBX(k3):6})' >
<annotation>Not necessary but added for easier comparison of source and target messages</annotation>
<true>
<assign value='target.{OBX(k3):6.1}' property='tSystem' action='set' />
<assign value='target.{OBX(k3):6.2}' property='tUnit' action='set' />
<assign value='target.{OBX(k3):6.3}' property='tCode' action='set' />
<assign value='""' property='target.{OBX(k3):6}' action='set' />
<assign value='tSystem' property='target.{OBX(k3):6.1}' action='set' />
<assign value='tUnit' property='target.{OBX(k3):6.2}' action='set' />
<assign value='tCode' property='target.{OBX(k3):6.3}' action='set' />
</true>
</if>

</foreach>
</transform>
}

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

}
