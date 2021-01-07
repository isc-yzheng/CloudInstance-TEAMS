/// JS PJH - SDA3 to HL7 Transform for ORUR01
Class HS.Gateway.SDA3.SDA3ToHL7.ORUR01 Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.EDI.XML.Document, EnsLib.HL7.Message) ]
{

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.XML.Document' targetClass='EnsLib.HL7.Message' sourceDocType='HS.SDA3:Container' targetDocType='2.5.1:ORU_R01' create='new' language='objectscript' >
<code>
<![CDATA[ 
 #;
 #; MSH
 #; 
]]></code>
<assign value='"|"' property='target.{MSH:1}' action='set' />
<assign value='"^~\&amp;#"' property='target.{MSH:2}' action='set' />
<assign value='"NIST^2.16.840.1.113883.3.72.5.20^ISO"' property='target.{MSH:3}' action='set' />
<assign value='source.{/Container/SendingFacility}' property='target.{MSH:4.1}' action='set' />
<assign value='##class(HS.Data.OIDMap).OIDForType(target.{MSH:4.1},"Facility")' property='target.{MSH:4.2}' action='set' />
<assign value='"ISO"' property='target.{MSH:4.3}' action='set' />
<assign value='"NIST^2.16.840.1.113883.3.72.5.22^ISO"' property='target.{MSH:5}' action='set' />
<assign value='source.{/Container/SendingFacility}' property='target.{MSH:6.1}' action='set' />
<assign value='##class(HS.Data.OIDMap).OIDForType(target.{MSH:6.1}_"ReceivingFacility","Facility")' property='target.{MSH:6.2}' action='set' />
<assign value='"ISO"' property='target.{MSH:6.3}' action='set' />
<assign value='##class(HS.Gateway.SDA3.SDA3ToHL7.TransformUtil).DateTime()' property='target.{MSH:7}' action='set' />
<assign value='source.GetValueAt("/Container/EventDescription")' property='tEventDesc' action='set' />
<assign value='$Translate($E(tEventDesc,1,7),"_","^")_"^"_$Translate(target.GetSegmentAt("MSH").Unescape($E(tEventDesc,9,*)),"^","_")_tEventDesc' property='target.{MSH:9}' action='set' />
<code>
<![CDATA[ 
	;# TODO
]]></code>
<assign value='"NIST-ELR-002.01"' property='target.{MSH:10}' action='set' />
<assign value='"P"' property='target.{MSH:11}' action='set' />
<assign value='"2.5.1"' property='target.{MSH:12}' action='set' />
<assign value='"NE"' property='target.{MSH:15}' action='set' />
<assign value='"NE"' property='target.{MSH:16}' action='set' />
<assign value='"PHLabReport-NoAck^HL7^2.16.840.1.113883.9.11^ISO"' property='target.{MSH:21}' action='set' />
<code>
<![CDATA[ 
 #;
 #; SFT
 #; 
]]></code>
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.SFT' targetObj='target.{SFT(1)}' sourceObj='source' />
<code>
<![CDATA[ 
 #;
 #; PID
 #;
]]></code>
<assign value='##class(EnsLib.EDI.XML.Document).ImportFromString("&lt;Patient&gt;"_source.GetValueAt("/Container/Patient/")_"&lt;/Patient&gt;")' property='tPatient' action='set' />
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.PatientToPID' targetObj='target.{PIDgrpgrp(1).PIDgrp.PID}' sourceObj='tPatient' />
<if condition='+$Length(target.{PIDgrpgrp(1).PIDgrp.PID:19})' >
<annotation>If SSN present move from PID:19 to PID:3 for MU2 Lab Reporting</annotation>
<true>
<assign value='target.{PIDgrpgrp(1).PIDgrp.PID:3(*)}+1' property='tPID3Count' action='set' />
<assign value='target.{PIDgrpgrp(1).PIDgrp.PID:19}' property='target.{PIDgrpgrp(1).PIDgrp.PID:3(tPID3Count).1}' action='set' />
<assign value='"SSN"' property='target.{PIDgrpgrp(1).PIDgrp.PID:3(tPID3Count).4.1}' action='set' />
<assign value='##class(HS.Data.OIDMap).OIDForType("SSN","AssigningAuthority")' property='target.{PIDgrpgrp(1).PIDgrp.PID:3(tPID3Count).4.2}' action='set' >
</assign>
<assign value='"ISO"' property='target.{PIDgrpgrp(1).PIDgrp.PID:3(tPID3Count).4.3}' action='set' />
<assign value='"SS"' property='target.{PIDgrpgrp(1).PIDgrp.PID:3(tPID3Count).5}' action='set' />
<assign value='"SSA"' property='target.{PIDgrpgrp(1).PIDgrp.PID:3(tPID3Count).6.1}' action='set' />
<assign value='##class(HS.Data.OIDMap).OIDForType("SSA","AssigningAuthority")' property='target.{PIDgrpgrp(1).PIDgrp.PID:3(tPID3Count).6.2}' action='set' >
</assign>
<assign value='"ISO"' property='target.{PIDgrpgrp(1).PIDgrp.PID:3(tPID3Count).6.3}' action='set' />
<assign value='""' property='target.{PIDgrpgrp(1).PIDgrp.PID:19}' action='set' />
</true>
</if>
<foreach property='target.{PIDgrpgrp(1).PIDgrp.PID:3()}' key='k1' >
<annotation>Change MRN to MR</annotation>
<if condition='target.{PIDgrpgrp(1).PIDgrp.PID:3(k1).5}="MRN"' >
<true>
<assign value='"MR"' property='target.{PIDgrpgrp(1).PIDgrp.PID:3(k1).5}' action='set' />
</true>
</if>
</foreach>
<foreach property='target.{PIDgrpgrp(1).PIDgrp.PID:5()}' key='k1' >
<annotation>Default subtransforms for name type is L for MU2 reporting it is always B</annotation>
<if condition='target.{PIDgrpgrp(1).PIDgrp.PID:5(k1).7}="L"' >
<true>
<assign value='"B"' property='target.{PIDgrpgrp(1).PIDgrp.PID:5(k1).7}' action='set' />
</true>
</if>
</foreach>
<assign value='target.{PIDgrpgrp(1).PIDgrp.PID:5(*)}+1' property='tPID5Count' action='set' />
<foreach property='target.{PIDgrpgrp(1).PIDgrp.PID:9()}' key='k2' >
<annotation>If Aliases are present move from PID:9 to PID:5(n) for MU2 Lab Reporting</annotation>
<assign value='target.{PIDgrpgrp(1).PIDgrp.PID:9(k2)}' property='target.{PIDgrpgrp(1).PIDgrp.PID:5(tPID5Count)}' action='set' />
<assign value='"A"' property='target.{PIDgrpgrp(1).PIDgrp.PID:5(tPID5Count).7}' action='set' />
</foreach>
<assign value='""' property='target.{PIDgrpgrp(1).PIDgrp.PID:9}' action='set' />
<foreach property='target.{PIDgrpgrp(1).PIDgrp.PID:11()}' key='k1' >
<annotation>Set Address type to H for the first instance and C for the second</annotation>
<if condition='$Length(target.{PIDgrpgrp(1).PIDgrp.PID:11(k1).1})' >
<true>
<if condition='k1=1' >
<true>
<assign value='"H"' property='target.{PIDgrpgrp(1).PIDgrp.PID:11(k1).7}' action='set' />
</true>
<false>
<assign value='"C"' property='target.{PIDgrpgrp(1).PIDgrp.PID:11(k1).7}' action='set' />
</false>
</if>
</true>
</if>
</foreach>
<code>
<![CDATA[ 
 #;
 #; PID- 35 Hardcoding as HS is only used for Humans
 #;
]]></code>
<assign value='"337915000"' property='target.{PIDgrpgrp(1).PIDgrp.PID:35.1}' action='set' />
<assign value='"Homo sapiens (organism)"' property='target.{PIDgrpgrp(1).PIDgrp.PID:35.2}' action='set' />
<assign value='"SCT"' property='target.{PIDgrpgrp(1).PIDgrp.PID:35.3}' action='set' />
<assign value='"human"' property='target.{PIDgrpgrp(1).PIDgrp.PID:35.4}' action='set' />
<assign value='"human"' property='target.{PIDgrpgrp(1).PIDgrp.PID:35.5}' action='set' />
<assign value='"L"' property='target.{PIDgrpgrp(1).PIDgrp.PID:35.6}' action='set' />
<assign value='"07/31/2012"' property='target.{PIDgrpgrp(1).PIDgrp.PID:35.7}' action='set' />
<assign value='"4"' property='target.{PIDgrpgrp(1).PIDgrp.PID:35.8}' action='set' />
<code>
<![CDATA[ 
 #;
 #; PD1
 #;
]]></code>
<assign value='source.{/Container/Patient/Publicity/PublicityCode/Code}' property='tPubCode' action='set' />
<assign value='source.{/Container/Patient/IsProtected}' property='tProtectionStatus' action='set' />
<assign value='source.{/Container/Patient/ImmunizationRegistry/ImmunizationRegistryCode/Code}' property='tRegCode' action='set' />
<if condition='(($Length(tPubCode))||($Length(tProtectionStatus))||($Length(tRegCode)))' >
<true>
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.PatientToPD1' targetObj='target.{PIDgrpgrp(1).PIDgrp.PD1}' sourceObj='tPatient' />
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; NK1
 #;
]]></code>
<if condition='+source.GetValueAt("/Container/Patient/SupportContacts/[*]")' >
<true>
<assign value='0' property='tContactCount' action='set' />
<foreach property='source.{Patient.SupportContacts()}' key='k1' >
<assign value='##class(EnsLib.EDI.XML.Document).ImportFromString("&lt;SupportContact&gt;"_source.GetValueAt("/Container/Patient/SupportContacts/["_k1_"]")_"&lt;/SupportContact&gt;")' property='tSupportContact' action='set' />
<assign value='tSupportContact.{/SupportContact/Address/Street}' property='tStreet' action='set' />
<if condition='((+$Length(..ReplaceStr($ZStrip(tStreet,"*W"),";;","")))||(+$Length(tSupportContact.{/SupportContact/Organization/Code})))' >
<true>
<assign value='tContactCount+1' property='tContactCount' action='set' />
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.SupportContactToNK1' targetObj='target.{PIDgrpgrp(1).PIDgrp.NK1(tContactCount)}' sourceObj='tSupportContact' />
<assign value='tContactCount' property='target.{PIDgrpgrp(1).PIDgrp.NK1(tContactCount):1}' action='set' />
<if condition='+$Length(target.{PIDgrpgrp(1).PIDgrp.NK1(tContactCount):2.1})' >
<true>
<assign value='"L"' property='target.{PIDgrpgrp(1).PIDgrp.NK1(tContactCount):2.7}' action='set' />
</true>
</if>
<foreach property='target.{PIDgrpgrp(1).PIDgrp.NK1(tContactCount):4()}' key='k2' >
<annotation>Set Address type to H for home</annotation>
<if condition='+$Length(target.{PIDgrpgrp(1).PIDgrp.NK1(tContactCount):4(k2).1})' >
<true>
<assign value='"H"' property='target.{PIDgrpgrp(1).PIDgrp.NK1(tContactCount):4(k2).7}' action='set' />
</true>
</if>
</foreach>
<foreach property='target.{PIDgrpgrp(1).PIDgrp.NK1(tContactCount):32()}' key='k2' >
<annotation>Set Address type to L for Legal</annotation>
<if condition='+$Length(target.{PIDgrpgrp(1).PIDgrp.NK1(tContactCount):32(k2).1})' >
<true>
<assign value='"L"' property='target.{PIDgrpgrp(1).PIDgrp.NK1(tContactCount):32(k2).7}' action='set' />
</true>
</if>
</foreach>
</true>
</if>
</foreach>
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; PV1
 #;
]]></code>
<if condition='+$Length(source.{/Container/Encounters/[1]})' >
<true>
<assign value='##class(EnsLib.EDI.XML.Document).ImportFromString("&lt;Encounter&gt;"_source.{/Container/Encounters/[1]}_"&lt;/Encounter&gt;")' property='tEncounter' action='set' />
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.EncounterToPV1' targetObj='target.{PIDgrpgrp(1).PIDgrp.PV1grp.PV1}' sourceObj='tEncounter' />
<assign value='$Extract(target.{PIDgrpgrp(1).PIDgrp.PV1grp.PV1:44},1,8)' property='target.{PIDgrpgrp(1).PIDgrp.PV1grp.PV1:44}' action='set' >
<annotation>Not necessary but added for easier comparison</annotation>
</assign>
<assign value='$Extract(target.{PIDgrpgrp(1).PIDgrp.PV1grp.PV1:45},1,8)' property='target.{PIDgrpgrp(1).PIDgrp.PV1grp.PV1:45}' action='set' >
<annotation>Not necessary but added for easier comparison</annotation>
</assign>
<if condition='target.{PIDgrpgrp(1).PIDgrp.PV1grp.PV1:19.1}=(target.{PIDgrpgrp(1).PIDgrp.PID:3(1).1}_"-"_target.{PIDgrpgrp(1).PIDgrp.PV1grp.PV1:44})' >
<annotation>if HS generated encounter -- strip it out. -- TODO: Validate no labs have PV1-19</annotation>
<true>
<assign value='""' property='target.{PIDgrpgrp(1).PIDgrp.PV1grp.PV1:19}' action='set' />
</true>
<false>
<assign value='""' property='target.{PIDgrpgrp(1).PIDgrp.PV1grp.PV1:19}' action='set' />
</false>
</if>
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; NTE
 #;
]]></code>
<if condition='+$Length(source.{/Container/Patient/Comments})' >
<true>
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.PatientToNTE' targetObj='target.{PIDgrpgrp(1).PIDgrp.NTE(1)}' sourceObj='tPatient' />
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; Start
 #; ORC OBR NTE OBX
 #;
]]></code>
<if condition='+source.GetValueAt("/Container/LabOrders/[*]")' >
<true>
<foreach property='source.{LabOrders()}' key='k1' >
<assign value='##class(EnsLib.EDI.XML.Document).ImportFromString("&lt;LabOrder&gt;"_source.GetValueAt("/Container/LabOrders/["_k1_"]")_"&lt;/LabOrder&gt;")' property='tLabOrder' action='set' />
<if condition='1' >
<true>
<code>
<![CDATA[ 
 #;
 #; ORC -- Always setting PIDgrpgrp(1).ORCgrp(1).ORC rather than PIDgrpgrp(1).ORCgrp(k1).ORC
 #;
]]></code>
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.LabOrderToORC' targetObj='target.{PIDgrpgrp(1).ORCgrp(1).ORC}' sourceObj='tLabOrder' />
<assign value='"B"' property='target.{PIDgrpgrp(1).ORCgrp(1).ORC:24(1).7}' action='set' />
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; NTE
 #;
]]></code>
<if condition='+$Length(tLabOrder.{/LabOrder/Result/Comments})' >
<true>
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.LabOrderToNTE' targetObj='target.{PIDgrpgrp(1).ORCgrp(k1).NTE(1)}' sourceObj='tLabOrder' />
<assign value='k1' property='target.{PIDgrpgrp(1).ORCgrp(k1).NTE(1):1}' action='set' />
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; OBX (Only if we have Result)
 #; 
]]></code>
<assign value='""' property='tPreviousOBX31' action='set' />
<foreach property='source.{LabOrders(k1).Result.ResultItems()}' key='k5' >
<assign value='##class(EnsLib.EDI.XML.Document).ImportFromString("&lt;LabResultItem&gt;"_source.GetValueAt("/Container/LabOrders/["_k1_"]/Result/ResultItems/["_k5_"]")_"&lt;/LabResultItem&gt;")' property='tLabResult' action='set' />
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.LabResultToOBX' targetObj='target.{PIDgrpgrp(1).ORCgrp(k1).OBXgrp(k5).OBX}' sourceObj='tLabResult' />
<assign value='k5' property='target.{PIDgrpgrp(1).ORCgrp(k1).OBXgrp(k5).OBX:1}' action='set' />
<assign value='##class(HS.Gateway.SDA3.SDA3ToHL7.TransformUtil).XMLTimeStampToDateTime(tLabOrder.{/LabOrder/SpecimenCollectedTime})' property='target.{PIDgrpgrp(1).ORCgrp(k1).OBXgrp(k5).OBX:14}' action='set' />
<if condition='+$Length(target.{PIDgrpgrp(1).ORCgrp(k1).OBXgrp(k5).OBX:25.1})' >
<true>
<assign value='target.{PIDgrpgrp(1).ORCgrp(1).ORC:12(1).9}' property='target.{PIDgrpgrp(1).ORCgrp(k1).OBXgrp(k5).OBX:25.9}' action='set' />
<assign value='target.{PIDgrpgrp(1).ORCgrp(1).ORC:12(1).14}' property='target.{PIDgrpgrp(1).ORCgrp(k1).OBXgrp(k5).OBX:25.14}' action='set' />
</true>
</if>
<if condition='tPreviousOBX31=target.{PIDgrpgrp(1).ORCgrp(k1).OBXgrp(k5).OBX:3.1}' >
<annotation>If there are two OBXs with the same 3.1 SDA conversion calls them notes this resets OBX3 to the first if they repeat</annotation>
<true>
<assign value='target.{PIDgrpgrp(1).ORCgrp(k1).OBXgrp(k5-1).OBX:3}' property='target.{PIDgrpgrp(1).ORCgrp(k1).OBXgrp(k5).OBX:3}' action='set' />
</true>
</if>
<if condition='+$Length(tLabResult.{/LabResultItem/Comments})' >
<true>
<assign value='"L"' property='target.{PIDgrpgrp(1).ORCgrp(k1).OBXgrp(k5).NTE(1):2}' action='set' />
<assign value='tLabResult.{/LabResultItem/Comments}' property='target.{PIDgrpgrp(1).ORCgrp(k1).OBXgrp(k5).NTE(1):3}' action='set' />
<assign value='"RE"' property='target.{PIDgrpgrp(1).ORCgrp(k1).OBXgrp(k5).NTE(1):4.1}' action='set' />
<assign value='"Remark"' property='target.{PIDgrpgrp(1).ORCgrp(k1).OBXgrp(k5).NTE(1):4.2}' action='set' />
<assign value='"HL70364"' property='target.{PIDgrpgrp(1).ORCgrp(k1).OBXgrp(k5).NTE(1):4.3}' action='set' />
<assign value='"C"' property='target.{PIDgrpgrp(1).ORCgrp(k1).OBXgrp(k5).NTE(1):4.4}' action='set' />
<assign value='"Comment"' property='target.{PIDgrpgrp(1).ORCgrp(k1).OBXgrp(k5).NTE(1):4.5}' action='set' />
<assign value='"L"' property='target.{PIDgrpgrp(1).ORCgrp(k1).OBXgrp(k5).NTE(1):4.6}' action='set' />
<assign value='"2.5.1"' property='target.{PIDgrpgrp(1).ORCgrp(k1).OBXgrp(k5).NTE(1):4.7}' action='set' />
<assign value='"V1"' property='target.{PIDgrpgrp(1).ORCgrp(k1).OBXgrp(k5).NTE(1):4.8}' action='set' />
<assign value='1' property='target.{PIDgrpgrp(1).ORCgrp(k1).OBXgrp(k5).NTE(1):1}' action='set' />
</true>
</if>
</foreach>
<code>
<![CDATA[ 
 #;
 #; SPM
 #;
]]></code>
<if condition='+tLabOrder.{/LabOrder/Specimens/[*]}' >
<true>
<foreach property='source.{LabOrders(k1).Specimens()}' key='k2' >
<assign value='##class(EnsLib.EDI.XML.Document).ImportFromString("&lt;Specimen&gt;"_source.GetValueAt("/Container/LabOrders/["_k1_"]/Specimens/["_k2_"]")_"&lt;/Specimen&gt;")' property='tSpecimen' action='set' />
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.SpecimenToSPM' targetObj='target.{PIDgrpgrp(1).ORCgrp(k1).SPMgrp(1).SPM}' sourceObj='tSpecimen' />
<code>
<![CDATA[ 
 #;
 #; SPMOBX
 #;
]]></code>
<if condition='+$Length(tSpecimen.{/Specimen/Age})' >
<true>
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.SpecimenObservationToOBX' targetObj='target.{PIDgrpgrp(1).ORCgrp(k1).SPMgrp(k2).OBX(1)}' sourceObj='tSpecimen' />
<assign value='target.{PIDgrpgrp(1).ORCgrp(k1).OBXgrp(k2).OBX:11}' property='target.{PIDgrpgrp(1).ORCgrp(k1).SPMgrp(k2).OBX(1):11}' action='set' />
<assign value='target.{PIDgrpgrp(1).ORCgrp(k1).OBXgrp(k2).OBX:14}' property='target.{PIDgrpgrp(1).ORCgrp(k1).SPMgrp(k2).OBX(1):14}' action='set' />
<assign value='target.{PIDgrpgrp(1).ORCgrp(k1).OBXgrp(k2).OBX:19}' property='target.{PIDgrpgrp(1).ORCgrp(k1).SPMgrp(k2).OBX(1):19}' action='set' />
<assign value='target.{PIDgrpgrp(1).ORCgrp(k1).OBXgrp(k2).OBX:23}' property='target.{PIDgrpgrp(1).ORCgrp(k1).SPMgrp(k2).OBX(1):23}' action='set' />
<assign value='target.{PIDgrpgrp(1).ORCgrp(k1).OBXgrp(k2).OBX:24}' property='target.{PIDgrpgrp(1).ORCgrp(k1).SPMgrp(k2).OBX(1):24}' action='set' />
<assign value='target.{PIDgrpgrp(1).ORCgrp(k1).OBXgrp(k2).OBX:25}' property='target.{PIDgrpgrp(1).ORCgrp(k1).SPMgrp(k2).OBX(1):25}' action='set' />
</true>
</if>
</foreach>
</true>
</if>
<code>
<![CDATA[ 
 #;
 #; OBR -- Done after SPM as SPM-17.2 is used to set OBR-8
 #;
]]></code>
<subtransform class='HS.Gateway.SDA3.SDA3ToHL7.SubTransform.LabOrderToOBR' targetObj='target.{PIDgrpgrp(1).ORCgrp(k1).OBR}' sourceObj='tLabOrder' />
<assign value='k1' property='target.{PIDgrpgrp(1).ORCgrp(k1).OBR:1}' action='set' />
<foreach property='target.{PIDgrpgrp(1).ORCgrp()}' key='k2' >
<if condition='+$Length(target.{PIDgrpgrp(1).ORCgrp(k1).SPMgrp(1).SPM:17.2})' >
<true>
<assign value='target.{PIDgrpgrp(1).ORCgrp(k1).SPMgrp(1).SPM:17.2}' property='target.{PIDgrpgrp(1).ORCgrp(k2).OBR:8}' action='set' />
</true>
</if>
<if condition='+$Length(target.{PIDgrpgrp(1).ORCgrp(k2).OBR:29})' >
<annotation>If OBR-29 (parent placer/filler id) set look for the namespace info in previous OBRs</annotation>
<true>
<foreach property='target.{PIDgrpgrp(1).ORCgrp()}' key='k4' >
<if condition='target.{PIDgrpgrp(1).ORCgrp(k2).OBR:29.1}=target.{PIDgrpgrp(1).ORCgrp(k4).OBR:2.1}' >
<true>
<assign value='..ReplaceStr(target.{PIDgrpgrp(1).ORCgrp(k4).OBR:2},"^","&amp;")' property='target.{PIDgrpgrp(1).ORCgrp(k2).OBR:29.1}' action='set' />
</true>
</if>
<if condition='target.{PIDgrpgrp(1).ORCgrp(k2).OBR:29.2}=target.{PIDgrpgrp(1).ORCgrp(k4).OBR:3.1}' >
<true>
<assign value='..ReplaceStr(target.{PIDgrpgrp(1).ORCgrp(k4).OBR:3},"^","&amp;")' property='target.{PIDgrpgrp(1).ORCgrp(k2).OBR:29.2}' action='set' />
</true>
</if>
</foreach>
</true>
</if>
</foreach>

</foreach>
</true>
</if>

</transform>
}

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

}
