Class HS.Gateway.SDA3.SDA3ToHL7.VXUV04 Extends Ens.DataTransformDTL [ DependsOn = (HS.SDA3.Container, EnsLib.HL7.Message) ]
{

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.XML.Document' targetClass='EnsLib.HL7.Message' sourceDocType='HS.SDA3:Container' targetDocType='2.5.1:VXU_V04' create='new' language='objectscript' >
<code>
<![CDATA[ 
 #;
 #; MSH
 #; 
]]></code>
<assign value='"|"' property='target.{MSH:1}' action='set' />
<assign value='"^~\&amp;"' property='target.{MSH:2}' action='set' />
<assign value='"Test EHR Application"' property='target.{MSH:3}' action='set' />
<assign value='"X68"' property='target.{MSH:4.1}' action='set' />
<assign value='"NIST Test Iz Reg"' property='target.{MSH:6}' action='set' />
<assign value='##class(HS.Gateway.SDA3.SDA3ToHL7.TransformUtil).DateTime()' property='target.{MSH:7}' action='set' />
<assign value='source.GetValueAt("/Container/EventDescription")' property='tEventDesc' action='set' />
<assign value='$Translate($E(tEventDesc,1,7),"_","^")_"^"_$Translate(target.GetSegmentAt("MSH").Unescape($E(tEventDesc,9,*)),"^","_")' property='target.{MSH:9}' action='set' />
<assign value='$ZTS' property='target.{MSH:10}' action='set' />
<assign value='"P"' property='target.{MSH:11}' action='set' />
<assign value='"2.5.1"' property='target.{MSH:12}' action='set' />
<assign value='"AL"' property='target.{MSH:15}' action='set' />
<assign value='"ER"' property='target.{MSH:16}' action='set' />

<code>
<![CDATA[ 
 #;
 #; PID
 #; 
]]></code>
<assign value='##class(EnsLib.EDI.XML.Document).ImportFromString("&lt;Patient&gt;"_source.GetValueAt("/Container/Patient/")_"&lt;/Patient&gt;")' property='tPatient' action='set' />
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.PatientToPID' targetObj='target.{PID}' sourceObj='tPatient' />
<assign value='0' property='tPID3Count' action='set' />
<foreach property='target.{PID:3()}' key='k1' >
<annotation>3.5 - Change MRN to MR, and reset with only the fields used by Immunization test cases
</annotation>
<assign value='tPID3Count+1' property='tPID3Count' action='set' />
<assign value='target.{PID:3(k1)}' property='target.{PID:4(k1)}' action='set' />
<assign value='""' property='target.{PID:3(k1)}' action='set' />
<assign value='target.{PID:4(k1).1}' property='target.{PID:3(k1).1}' action='set' />
<assign value='target.{PID:4(k1).2}' property='target.{PID:3(k1).2}' action='set' />
<assign value='target.{PID:4(k1).3}' property='target.{PID:3(k1).3}' action='set' />
<assign value='target.{PID:4(k1).4.1}' property='target.{PID:3(k1).4}' action='set' />
<if condition='target.{PID:4(k1).5}="MRN"' >
<true>
<assign value='"MR"' property='target.{PID:3(k1).5}' action='set' />
</true>
<false>
<assign value='target.{PID:4(k1).5}' property='target.{PID:3(k1).5}' action='set' />
</false>
</if>
<assign value='""' property='target.{PID:4(k1)}' action='set' />
</foreach>
<foreach property='target.{PID:11()}' key='k1' >
<annotation>Set Address type to L for legal</annotation>
<if condition='$Length(target.{PID:11(k1).1})' >
<true>
<assign value='"L"' property='target.{PID:11(k1).7}' action='set' />
</true>
</if>
</foreach>
<if condition='$Length(target.{PID:19})' >
<annotation>Move SSN to Patient number when present</annotation>
<true>
<assign value='target.{PID:19}' property='target.{PID:3(tPID3Count+1).1}' action='set' />
<assign value='"MAA"' property='target.{PID:3(tPID3Count+1).4}' action='set' />
<assign value='"SS"' property='target.{PID:3(tPID3Count+1).5}' action='set' />
</true>
</if>

<code>
<![CDATA[ 
 #;
 #; PID:13.3, 15, 16, 17, 30, 33, 34, 10.4+ and 22.4+ - Not required 
 #; All this below up to PD1 is just cleaning up to make validation easier -- Not strictly necessary
]]></code>
<foreach property='target.{PID:13()}' key='k1' >
<if condition='target.{PID:13(k1).2}="NET"' >
<annotation>clean up email addresses</annotation>
<true>
<assign value='target.{PID:13(k1)}' property='target.{PID:14(k1)}' action='set' />
<assign value='""' property='target.{PID:13(k1)}' action='set' />
<assign value='target.{PID:14(k1).2}' property='target.{PID:13(k1).2}' action='set' />
<assign value='target.{PID:14(k1).4}' property='target.{PID:13(k1).4}' action='set' />
<assign value='""' property='target.{PID:14(k1)}' action='set' />
</true>
</if>
<if condition='target.{PID:13(1)}=""' >
<true>
<assign value='""' property='target.{PID:13(1).2}' action='set' />
</true>
</if>
</foreach>
<assign value='""' property='target.{PID:14}' action='set' />
<if condition='$Length(target.{PID:10})' >
<true>
<assign value='target.{PID:10}' property='target.{PID:33}' action='set' />
<assign value='""' property='target.{PID:10}' action='set' />
<assign value='target.{PID:33.1}' property='target.{PID:10.1}' action='set' />
<assign value='target.{PID:33.2}' property='target.{PID:10.2}' action='set' />
<assign value='target.{PID:33.3}' property='target.{PID:10.3}' action='set' />
</true>
</if>
<assign value='""' property='target.{PID:15}' action='set' />
<assign value='""' property='target.{PID:16}' action='set' />
<assign value='""' property='target.{PID:17}' action='set' />
<assign value='""' property='target.{PID:19}' action='set' />
<if condition='$Length(target.{PID:22})' >
<true>
<assign value='target.{PID:22}' property='target.{PID:33}' action='set' />
<assign value='""' property='target.{PID:22}' action='set' />
<assign value='target.{PID:33.1}' property='target.{PID:22.1}' action='set' />
<assign value='target.{PID:33.2}' property='target.{PID:22.2}' action='set' />
<assign value='target.{PID:33.3}' property='target.{PID:22.3}' action='set' />
</true>
</if>
<assign value='""' property='target.{PID:30}' action='set' />
<assign value='""' property='target.{PID:33}' action='set' />
<assign value='""' property='target.{PID:34}' action='set' />
<code>
<![CDATA[ 
 #;
 #; PD1
 #;
]]></code>
<assign value='source.GetValueAt("/Container/Patient/PublicityCode/Code")' property='tPubCode' action='set' />
<assign value='source.GetValueAt("/Container/Patient/IsProtected")' property='tProtectionStatus' action='set' />
<assign value='source.GetValueAt("/Container/Patient/ImmunizationRegistryStatus")' property='tRegCode' action='set' />
<if condition='(($Length(tPubCode))||($Length(tProtectionStatus))||($Length(tRegCode)))'>
<true>
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.PatientToPD1' targetObj='target.{PD1}' sourceObj='tPatient' />
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; NK1
 #;
]]></code>
<foreach property='source.{Patient.SupportContacts()}' key='k1' >
<assign value='##class(EnsLib.EDI.XML.Document).ImportFromString("&lt;SupportContact&gt;"_source.GetValueAt("/Container/Patient/SupportContacts/["_k1_"]")_"&lt;/SupportContact&gt;")' property='tSupportContact' action='set' />
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.SupportContactToNK1' targetObj='target.{NK1(k1)}' sourceObj='tSupportContact' />
<assign value='k1' property='target.{NK1(k1):1}' action='set' />
<foreach property='target.{NK1(k1):4()}' key='k2' >
<annotation>Set Address type to L for legal</annotation>
<if condition='+$Length(target.{NK1(k1):4(k2).1})' >
<true>
<assign value='"L"' property='target.{NK1(k1):4(k2).7}' action='set' />
</true>
</if>
</foreach>
</foreach>
<code>
<![CDATA[ 
 #;
 #; ORC RXA RXR OBX
 #;
]]></code>
<foreach property='source.{Vaccinations()}' key='tORCGrp' >
<code>
<![CDATA[ 
 #;
 #; ORC
 #;
]]></code>
<assign value='##class(EnsLib.EDI.XML.Document).ImportFromString("&lt;Vaccination&gt;"_source.GetValueAt("/Container/Vaccinations/["_tORCGrp_"]")_"&lt;/Vaccination&gt;")' property='tVaccination' action='set' />
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.VaccinationToORC' targetObj='target.{ORCgrp(tORCGrp).ORC}' sourceObj='tVaccination' />
<code>
<![CDATA[ 
 #;
 #; RXA
 #; 
]]></code>
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.VaccinationToRXA' targetObj='target.{ORCgrp(tORCGrp).RXA}' sourceObj='tVaccination' />
<code>
<![CDATA[ 
 #;
 #; RXR
 #;
]]></code>
<if condition='$Length(source.GetValueAt("/Container/Vaccinations/["_tORCGrp_"]/Route/Code"))'>
<true>
<assign value='source.GetValueAt("/Container/Vaccinations/["_tORCGrp_"]/Route/Code")' property='target.{ORCgrp(tORCGrp).RXR:1.1}' action='set' />
<assign value='source.GetValueAt("/Container/Vaccinations/["_tORCGrp_"]/Route/Description")' property='target.{ORCgrp(tORCGrp).RXR:1.2}' action='set' />
<assign value='source.GetValueAt("/Container/Vaccinations/["_tORCGrp_"]/Route/SDACodingStandard")' property='target.{ORCgrp(tORCGrp).RXR:1.3}' action='set' />

<assign value='source.GetValueAt("/Container/Vaccinations/["_tORCGrp_"]/Administrations/[1]/AdministrationSite/Code")' property='target.{ORCgrp(tORCGrp).RXR:2.1}' action='set' />
<assign value='source.GetValueAt("/Container/Vaccinations/["_tORCGrp_"]/Administrations/[1]/AdministrationSite/Description")' property='target.{ORCgrp(tORCGrp).RXR:2.2}' action='set' />
<assign value='source.GetValueAt("/Container/Vaccinations/["_tORCGrp_"]/Administrations/[1]/AdministrationSite/SDACodingStandard")' property='target.{ORCgrp(tORCGrp).RXR:2.3}' action='set' />

</true>
</if>
<foreach property='source.{/Container/Vaccinations/["_tORCGrp_"]/VXUObservations/()}' key='k3' >
<assign value='##class(EnsLib.EDI.XML.Document).ImportFromString("&lt;Observation&gt;"_source.GetValueAt("/Container/Vaccinations/["_tORCGrp_"]/VXUObservations/["_k3_"]")_"&lt;/Observation&gt;")' property='tObservation' action='set' />
<code>
<![CDATA[ 
 #;
 #; OBX
 #; 
]]></code>
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.ObservationToOBX' targetObj='target.{ORCgrp(tORCGrp).OBXgrp(k3).OBX}' sourceObj='tObservation' />
<assign value='k3' property='target.{ORCgrp(tORCGrp).OBXgrp(k3).OBX:1}' action='set' />
<if condition='target.{ORCgrp(tORCGrp).OBXgrp(k3).OBX:2}="TS"'>
<annotation>The validator doesn't like the time of the TimeStamp</annotation>
<true>
<assign value='$E(target.{ORCgrp(tORCGrp).OBXgrp(k3).OBX:5},1,8)' property='target.{ORCgrp(tORCGrp).OBXgrp(k3).OBX:5}' action='set' />
</true>
</if>
</foreach>
</foreach>

</transform>
}

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

}
