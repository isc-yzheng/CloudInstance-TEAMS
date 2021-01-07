Include (HS.Gateway.HL7.HL7ToSDA3, HS.HC, HS.HC.Invoke, Ensemble)

/// Convert an HL7 message into SDA3 XML
Class HS.Gateway.HL7.HL7ToSDA3 Extends %RegisteredObject [ Not ProcedureBlock ]
{

Parameter HSDEPLOY = 1;

/// Input: One HL7 message in EnsLib.HL7.Message
/// Output: SDA3 XML string
ClassMethod GetSDA(pRequest As EnsLib.HL7.Message, Output pXML As %Stream.GlobalCharacter, pLogAlerts As %Boolean = 1, pObservationMode As %Boolean = 0, pMultiLineOBXCompatibilityMode As %Boolean = 0, pKeepDuplicateOBXIdentifiers As %Boolean = 0) As %Status
{
 #; Note: ProcedureBlock=0

 new (pRequest,pXML,pLogAlerts,pObservationMode,pMultiLineOBXCompatibilityMode,%Ensemble, pKeepDuplicateOBXIdentifiers)
 //new seps,msgType,cr,s1,s2,s3,s4,s5,occ,s,ss,p1,p2,t,phone,obxmode
 //new type,identifier,unis,ranges,interp,obx,obr,nte,open,val,vi,vline

 kill ^||HS.Data

 set tSC=$$$OK,pXML="",Action="",encNum="",obxmode=pObservationMode, multilineobxmode = pMultiLineOBXCompatibilityMode, keepDuplicateOBXIdentifiers = pKeepDuplicateOBXIdentifiers
 set msgType = pRequest.Name,msgType = $P(msgType,"_",1)_"_"_$P(msgType,"_",2)

 do ..GetData()

 set cr=$c(13,10),XMLBuffer="",s=1
 set pXML=##class(%Stream.GlobalCharacter).%New()

 do ..MSH()
 do ..write("<?xml version=""1.0"" encoding=""UTF-16""?>")
 do ..write(cr_"<Container xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xmlns:isc=""http://extension-functions.intersystems.com"">")
 do ..write(cr_"<EventDescription>"_pRequest.Name_"</EventDescription>")
 do ..write(cr_"<SendingFacility>"_$$$MSHSendingFacilityNamespaceID_"</SendingFacility>")
 set tSC=..message()
 do ..write(cr_"<Action>"_Action_"</Action>")
 do ..OnBeforeEndContainer()
 do ..write(cr_"</Container>"_cr)
 do:XMLBuffer]"" pXML.Write(XMLBuffer)
 
 // Check for extra segments that shouldn't be there (or out of sequence)
 // ^||HS.Data(s,0) is set to 1 when processed
 set s="" for {
	set s=$o(^||HS.Data(s)) quit:s'?1.n
	if ('$g(^||HS.Data(s,0)) && pLogAlerts) $$$LOGALERT("Segment "_s_" of type "_^||HS.Data(s)_" not allowed for message type "_msgType_", or out of sequence. Ignored.") 
 }
 quit tSC
}

ClassMethod message() As %Status
{
 set tSC=$$$OK
	#; Supported message types and message structures
	    if (msgType="ADT_A01") {do ..adta01()}
	elseif (msgType="ADT_A02") {do ..adta02()}
	elseif (msgType="ADT_A03") {do ..adta03()}
	elseif (msgType="ADT_A04") {do ..adta01()}
	elseif (msgType="ADT_A05") {do ..adta05()}
	elseif (msgType="ADT_A06") {do ..adta01()}
	elseif (msgType="ADT_A07") {do ..adta01()}
	elseif (msgType="ADT_A08") {do ..adta01()}
	elseif (msgType="ADT_A09") {do ..adta01()}
	elseif (msgType="ADT_A10") {do ..adta01()}
	elseif (msgType="ADT_A11") {do ..adta09()}
	elseif (msgType="ADT_A12") {do ..adta01()}
	elseif (msgType="ADT_A13") {do ..adta01()}
	elseif (msgType="ADT_A16") {do ..adta01()}
	elseif (msgType="ADT_A17") {do ..adta01()}
	elseif (msgType="ADT_A18") {do ..adta18()}
	elseif (msgType="ADT_A23") {do ..adta21()}
	elseif (msgType="ADT_A25") {do ..adta01()}
	elseif (msgType="ADT_A27") {do ..adta01()}
	elseif (msgType="ADT_A28") {do ..adta05()}
	elseif (msgType="ADT_A29") {do ..adta21()}
	elseif (msgType="ADT_A30") {do ..adta30()}
	elseif (msgType="ADT_A31") {do ..adta05()}
	elseif (msgType="ADT_A34") {do ..adta30()}
	elseif (msgType="ADT_A36") {do ..adta30()}
	elseif (msgType="ADT_A39") {do ..adta39()}
	elseif (msgType="ADT_A40") {do ..adta39()}
	;elseif (msgType="ADT_A41") {do ..adta39()}
	elseif (msgType="ADT_A45") {do ..adta45()}
	elseif (msgType="ADT_A47") {do ..adta30()}
	;elseif (msgType="ADT_A49") {do ..adta30()}
	elseif (msgType="ADT_A50") {do ..adta50()}
	;elseif (msgType="ADT_A51") {do ..adta50()}
	elseif (msgType="ADT_A60") {do ..adta60()}
	elseif (msgType="BAR_P12") {do ..barp12()}
	elseif (msgType="MDM_T02") {do ..mdmt02()}
	elseif (msgType="MDM_T04") {do ..mdmt02()}
	elseif (msgType="MDM_T08") {do ..mdmt02()}
	elseif (msgType="MDM_T11") {do ..mdmt01()}
	elseif (msgType="OMP_O09") {do ..ompo09()}
	elseif (msgType="ORM_O01") {do ..ormo01()}
	elseif (msgType="ORU_R01") {do ..orur01()}
	elseif (msgType="PPR_PC1") {do ..pprpc1()}
	elseif (msgType="PPR_PC2") {do ..pprpc1()}
	elseif (msgType="PPR_PC3") {do ..pprpc1()}
	elseif (msgType="RDE_O11") {do ..rdeo11()}
	elseif (msgType="SIU_S12") {do ..sius12()}
	elseif (msgType="SIU_S13") {do ..sius12()}
	elseif (msgType="SIU_S14") {do ..sius12()}
	elseif (msgType="SIU_S15") {do ..sius12()}
	elseif (msgType="SIU_S16") {do ..sius12()}
	elseif (msgType="SIU_S17") {do ..sius12()}
	elseif (msgType="SIU_S26") {do ..sius12()}
	elseif (msgType="VXU_V04") {do ..vxuv04()}
	else {Set tSC = $$$HSError($$$HSErrUnsupportedHL7MessageType,msgType)}
 quit tSC
}

ClassMethod adta01()
{
 set Action=$s(msgType="ADT_A13":"CancelDischarge",1:"AddOrUpdate")
 do ..EVN(),..PID(),..PD1()
 while $$$Next("NK1") {do ..NK1()} do ..end("NK1")
 do ..end("PID")
 while $$$Next("AL1") {do ..AL1()} do ..end("AL1")
 if ($$$Next("PV1"))&&(..StartEncounters()) {
	do ..PV1(),..PV2()
    while $$$Next("GT1") {do ..GT1()} do ..end("GT1")
	while $$$Next("IN1") {do ..IN1()} do ..end("IN1")
	If ($$$Next("DRG")) Do ..DRG()
	do ..EndEncounters()
 }
 while $$$Next("DG1") {do ..DG1()} do ..end("DG1")
 while $$$Next("PR1") {do ..PR1()} do ..end("PR1")
 while $$$Next("OBX") {do ..OBX("obs")} do ..end("OBX")
}

ClassMethod adta02()
{
 set Action="AddOrUpdate"
 do ..EVN(),..PID(),..PD1()
 do ..end("PID")
 if ($$$Next("PV1"))&&(..StartEncounters()) {
	do ..PV1(),..PV2()
	do ..EndEncounters()
 }
 while $$$Next("OBX") {do ..OBX("obs")} do ..end("OBX")
}

ClassMethod adta03()
{
 set Action="AddOrUpdate"
 do ..EVN(),..PID(),..PD1()
 while $$$Next("NK1") {do ..NK1()} do ..end("NK1")
 do ..end("PID")
 while $$$Next("AL1") {do ..AL1()} do ..end("AL1")
 if ($$$Next("PV1"))&&(..StartEncounters()) {
	do ..PV1(),..PV2()
	while $$$Next("GT1") {do ..GT1()} do ..end("GT1")
	while $$$Next("IN1") {do ..IN1()} do ..end("IN1")
	If ($$$Next("DRG")) Do ..DRG()
	do ..EndEncounters()
 }
 while $$$Next("DG1") {do ..DG1()} do ..end("DG1")
 while $$$Next("PR1") {do ..PR1()} do ..end("PR1")
 while $$$Next("OBX") {do ..OBX("obs")} do ..end("OBX")
}

ClassMethod adta05()
{
 set Action="AddOrUpdate"
 do ..EVN(),..PID(),..PD1()
 while $$$Next("NK1") {do ..NK1()} do ..end("NK1")
 do ..end("PID")
 while $$$Next("AL1") {do ..AL1()} do ..end("AL1")
 // StartEncounters will return 0 if PatientClass="N" and message type=ADT_A28 or ADT_A31
 if ($$$Next("PV1"))&&(..StartEncounters()) {
	do ..PV1(),..PV2()
	while $$$Next("GT1") {do ..GT1()} do ..end("GT1")
	while $$$Next("IN1") {do ..IN1()} do ..end("IN1")
	If ($$$Next("DRG")) Do ..DRG()
	do ..EndEncounters()
 }
 while $$$Next("DG1") {do ..DG1()} do ..end("DG1")
 while $$$Next("PR1") {do ..PR1()} do ..end("PR1")
 while $$$Next("OBX") {do ..OBX("obs")} do ..end("OBX")
}

ClassMethod adta09()
{
 set Action="DeleteEncounter"
 do ..EVN(),..PID(),..PD1()
 do ..end("PID")
 if ($$$Next("PV1"))&&(..StartEncounters()) {
	do ..PV1(),..PV2()
	do ..EndEncounters()
 }
 while $$$Next("OBX") {do ..OBX("obs")} do ..end("OBX")
 while $$$Next("DG1") {do ..DG1()} do ..end("DG1")
}

ClassMethod adta18()
{
 set Action="Merge"
 do ..EVN(),..PID(),..PD1()
 if $$$Next("MRG") {do ..MRG("patient"),..end("MRGPAT")}
 do ..end("PID")
 if ($$$Next("PV1"))&&(..StartEncounters()) {
	do ..PV1()
	do ..EndEncounters()
 }
}

ClassMethod adta21()
{
 // ADT_A23 or ADT_A29
 set Action=$s(msgType="ADT_A23":"DeleteEncounter",1:"DeletePatient")
 do ..EVN(),..PID(),..PD1()
 do ..end("PID")
 // StartEncounters will return 0 if PatientClass="N" and message type=ADT_A29
 if ($$$Next("PV1"))&&(..StartEncounters()) {
	do ..PV1(),..PV2()
	do ..EndEncounters()
 }
 while $$$Next("OBX") {do ..OBX("obs")} do ..end("OBX")
}

ClassMethod adta30()
{
 set Action="Merge"
 do ..EVN(),..PID(),..PD1()
 if $$$Next("MRG") {do ..MRG("patient"),..end("MRGPAT")}
 do ..end("PID")
}

ClassMethod adta39()
{
 set Action="Merge"
 do ..EVN(),..PID(),..PD1()
 if $$$Next("MRG") {do ..MRG("patient"),..end("MRGPAT")}
 do ..end("PID")
 if ($$$Next("PV1"))&&(..StartEncounters()) {
	do ..PV1()
	do ..EndEncounters()
 }
}

ClassMethod adta45()
{
 set Action="Move"
 do ..EVN(),..PID(),..PD1()
 if $$$Next("MRG") {do ..MRG("patient"),..end("MRGPAT")}
 do ..end("PID")
 if ($$$Next("PV1"))&&(..StartEncounters()) {
	do ..PV1()
	set ^||HS.Data("MRG")="" // I need to process the MRG twice, once for the patientnumber, this one for the visitnumber
	if $$$Next("MRG") {do ..MRG("visit"),..end("MRGVIS")}
	do ..EndEncounters()
 }
}

ClassMethod adta50()
{
 set Action="Merge"
 do ..EVN(),..PID(),..PD1()
 if $$$Next("MRG") {do ..MRG("patient"),..end("MRGPAT")}
 do ..end("PID")
 if ($$$Next("PV1"))&&(..StartEncounters()) {
	do ..PV1()
	set ^||HS.Data("MRG")="" // I need to process the MRG twice, once for the patientnumber, this one for the visitnumber
	if $$$Next("MRG") {do ..MRG("visit"),..end("MRGVIS")}
	do ..EndEncounters()
 }
}

ClassMethod adta60()
{
 set Action="AddOrUpdate"
 do ..EVN(),..PID()
 do ..end("PID")
 while $$$Next("IAM") {do ..IAM()} do ..end("IAM")
 if ($$$Next("PV1"))&&(..StartEncounters()) {
	do ..PV1(),..PV2()
	do ..EndEncounters()
 }
}

ClassMethod barp12()
{
 set Action="AddOrUpdate"
 do ..EVN(),..PID()
 do ..end("PID")
 if ($$$Next("PV1"))&&(..StartEncounters()) {
	do ..PV1()
	If ($$$Next("DRG")) Do ..DRG()
	do ..EndEncounters()
 }
 while $$$Next("DG1") {do ..DG1()} do ..end("DG1")
 while $$$Next("PR1") {do ..PR1()} do ..end("PR1")
}

ClassMethod mdmt01()
{
 set Action="AddOrUpdate"
 do ..EVN(),..PID()
 do ..end("PID")
 if ($$$Next("PV1"))&&(..StartEncounters()) {
	do ..PV1()
	do ..EndEncounters()
 }
 if $$$Next("TXA") {do ..TXA()} do ..end("TXA")
}

ClassMethod mdmt02()
{
 set Action="AddOrUpdate"
 do ..EVN(),..PID()
 do ..end("PID")
 if ($$$Next("PV1"))&&(..StartEncounters()) {
	do ..PV1()
	do ..EndEncounters()
 }
 if $$$Next("TXA") {do ..TXA()} do ..end("TXA")
}

ClassMethod ompo09()
{
 set Action="AddOrUpdate"
 do ..PID(),..PD1()
 do ..end("PID")
 while $$$Next("AL1") {do ..AL1()} do ..end("AL1")
 if ($$$Next("PV1"))&&(..StartEncounters()) {
	do ..PV1(),..PV2()
	while $$$Next("GT1") {do ..GT1()} do ..end("GT1")
	while $$$Next("IN1") {do ..IN1()} do ..end("IN1")
 	do ..EndEncounters() 
 }
 while $$$Next("ORCOMP") {do ..ORC("omp")} do ..end("ORCOMP")
}

ClassMethod ormo01()
{
 set Action="AddOrUpdate"
 do ..PID(),..PD1()
 do ..end("PID")
 while $$$Next("AL1") {do ..AL1()} do ..end("AL1")
 if ($$$Next("PV1"))&&(..StartEncounters()) {
	do ..PV1(),..PV2()
	while $$$Next("GT1") {do ..GT1()} do ..end("GT1")
	while $$$Next("IN1") {do ..IN1()} do ..end("IN1")
 	do ..EndEncounters() 
 }
 while $$$Next("ORCORD") {do ..ORC("ord")} 
 do ..EndOrder()
 while $$$Next("ORCMED") {do ..ORC("med")} do ..end("ORCMED")
 while $$$Next("DG1") {do ..DG1()} do ..end("DG1")
}

/// oru_r01
ClassMethod orur01()
{
 set Action="AddOrUpdate"
 // J2 PJH - Include SFT
 if $$$IsFollowing("SFT") {
 	while $$$Next("SFT") {do ..SFT()} do ..end("SFT")
 }
 do ..PID(),..PD1()

 if $$$IsFollowing("NTE") { do ..NTE() }

 while $$$Next("NK1") {do ..NK1()} do ..end("NK1")
 do ..end("PID")
 if ($$$Next("PV1"))&&(..StartEncounters()) {
	do ..PV1(),..PV2()
	do ..EndEncounters() 
 }
 while $$$Next("ORCOBS") {do ..ORC("obs")} do ..end("ORCOBS")
 while $$$Next("ORCRES") {do ..ORC("res")}

 do ..EndOrder()
}

ClassMethod pprpc1()
{
 set Action="AddOrUpdate"
 do ..PID(),..end("PID")
 if ($$$Next("PV1"))&&(..StartEncounters()) {
	do ..PV1(),..PV2()
	do ..EndEncounters() 
 }
 while $$$Next("PRB") {do ..PRB()} do ..end("PRB")
 while $$$Next("ORCOBS") {do ..ORC("obs")} do ..end("ORCOBS")
 while $$$Next("ORCRES") {do ..ORC("res")}
 while $$$Next("ORCORD") {do ..ORC("ord")}
 do ..EndOrder()
}

ClassMethod rdeo11()
{
 set Action="AddOrUpdate"
 do ..PID(),..PD1(),..end("PID")
 while $$$Next("AL1") {do ..AL1()} do ..end("AL1")
 if ($$$Next("PV1"))&&(..StartEncounters()) {
 	do ..PV1(),..PV2()
 	while $$$Next("IN1") {do ..IN1()} do ..end("IN1")
 	do ..EndEncounters()
 }
 while $$$Next("ORCRDE") {do ..ORC("rde")} do ..end("ORCRDE")
}

ClassMethod sius12()
{
	set Action="AddOrUpdate"
	do ..PID(),..PD1(),..end("PID")
	if ($$$Next("PV1"))&&(..StartEncounters()) {
		do ..PV1(),..PV2()
		do ..EndEncounters()
	}
	while $$$Next("DG1") {do ..DG1()} do ..end("DG1")
	while $$$Next("OBX") {do ..OBX("obs")} do ..end("OBX")
	do ..SCH()
}

ClassMethod vxuv04()
{
 set Action="AddOrUpdate"
 do ..PID(),..PD1()
 while $$$Next("NK1") {do ..NK1()} do ..end("NK1")
 do ..end("PID")
 if ($$$Next("PV1"))&&(..StartEncounters()) {
	do ..PV1(),..PV2()
	while $$$Next("GT1") {do ..GT1()} do ..end("GT1")
	while $$$Next("IN1") {do ..IN1()} do ..end("IN1")
 	do ..EndEncounters() 
 }
 while $$$Next("ORC") {do ..ORC("vxu")} do ..end("ORC")
}

ClassMethod StartEncounters() As %Status
{
 $$$Find("PV1")

 #;  for ADT_A28, A29 & A31, PatientClass 'N' is defined by the standard as 'dummy' to be ignored
 set pClass=$$$PV1PatientClass
 if ("ADT_A28^ADT_A29^ADT_A31"[msgType)&&(pClass="N") {
	#if $$$HSDebug
		do ##class(HS.Util.HSDebug).Debug("PV1","HS.Gateway.HL7.HL7ToSDA3","txt",s_" PatientClass='N'")
	#endif
	quit 0
 }
 set encNum=$$$PV1VisitNumberIDNumber
 // If no EncounterNumber, try to generate one.
 if encNum="" {
	$$$HCInvoke(encNum,"","GenerateEncounterNum",pClass,mrn,..xmltimestamp($$$PV1AdmitDateTimeTime))
 	// If a number is generated, log an alert, but only if encounter type is not G or S
 	if (encNum'="") {if (",G,S,"'[pClass) $$$LOGALERT(" SDA Data Alert: Visit Number was blank and has been generated as "_encNum) }
 	// If no number is generated, log a warning and quit 0 to skip the encounter.
 	else {
		$$$LOGWARNING("Could not generate EncounterNumber, skipping Encounter")
		quit 0
 	}
 }
 
 do ..write(cr_"<Encounters>")
 do ..write(cr_"<Encounter>")
 do ..OnEncounter()
 quit $$$OK
}

ClassMethod EndEncounters()
{
 do ..write(cr_"</Encounter>")
 do ..write(cr_"</Encounters>")
}

/// No longer used, as any type can now be encounter-less.
ClassMethod DummyEncounters()
{
	// No longer used as of JLD193
 do ..write(cr_"<Encounters>")
 do ..write(cr_"<Encounter>")	
 #if $$$HSDebug
	do ##class(HS.Util.HSDebug).Debug("DummyEncounters","HS.Gateway.HL7.HL7ToSDA3","txt",s)
 #endif

 #; PV1-2 : PatientClass
 do ..write(cr_"<EncounterType>G</EncounterType>")

 #; PV1-10 : HospitalService
 do ..write(cr_"<HealthCareFacility>")
 do ..write(cr_"<Code>"_$$$MSHSendingFacilityNamespaceID_"</Code>")
 do ..write(cr_"<Organization>")
 do ..write(cr_"<Code>"_$$$MSHSendingFacilityNamespaceID_"</Code>")
 do ..write(cr_"</Organization>")	 
 do ..write(cr_"</HealthCareFacility>")

 #; PV1-19 : EncounterNumber (dummy)
 do ..WriteEncounterNumber(encNum)
 
 #; PV1-44 : AdmitDateTime
 do ..write(cr_"<FromTime>"_$tr($zdt($h,3,1)," ","T")_"Z"_"</FromTime>")

 #; EVN-5 : OperatorID  -> EnteredBy in SuperClass
 // J2 PJH New By call parameters
 if $$$EVN'="" {
	set %occ="" for {
		set %occ=$$$EVNOperator(%occ) quit:%occ=""
		do ..By("<EnteredBy>",,"User",
			$$$EVNOperatorIDAssigningAuthority(%occ),
			$$$EVNOperatorIDIDNumber(%occ),
			$$$EVNOperatorIDFamilyNameSurname(%occ),
			$$$EVNOperatorIDGivenName(%occ))
		quit  // only one
	}
 }

 #; MSH-4 : SendingFacility -> EnteredAt in SuperClass
 do ..write(cr_"<EnteredAt>")
 do ..write(cr_"<Code>"_$$$MSHSendingFacilityNamespaceID_"</Code>")
 do ..write(cr_"</EnteredAt>")
}

ClassMethod GetData()
{
 new s,line,seg,fno,fval,field,occ,sval,sub,tSegment
 set seps=pRequest.Separators
 set s1=$e(seps,1),s2=$e(seps,2),s3=$e(seps,3),s4=$e(seps,4),s5=$e(seps,5)
 //Set up array mapping HL7 escape sequences to target characters
 //The XML escaping is mostly for "&"
 set:s1'="^" escape(s4_"F"_s4) = s1
 set:s2'="^" escape(s4_"S"_s4) = s2
 set:s3'="^" escape(s4_"R"_s4) = s3
 set:s4'="^" escape(s4_"E"_s4) = s4
 set:s5'="^" escape(s4_"T"_s4) = s5
 set escape(s4_".br"_s4) = $c(13,10)
 #;
 #;	build ^||HS.Data(s,field,sub,occ)
 #;		  ^||HS.Data(s)=seg
 #;		  ^||HS.Data(seg)=lasts
 #;		  ^||HS.Data(seg,s)=""
 #;		s     = sequence number, keep segments in order
 #;		seg   = segment type (eg "PID"), for "ORC" add indexes (see below)
 #;		lasts = s of last segment of that type processed
 #;		field = the main field number within a segment
 #;		sub   = the second level field number (note: we do not use any 3rd-level subfields)
 #;		occ   = the occurrence number within a repeating field
 #;
 #;		for fields with just a value, set ^||HS.Data(s,field)=val and ^||HS.Data(s,field,1)=val
 #;		  and ^||HS.Data(s,field,1,1)
 #;		for fields with subfields, set ^||HS.Data(s,field)=val1^val2^... and ^||HS.Data(s,field,f)=valf
 #;		  and ^||HS.Data(s,field,f,1)
 #;		for repeating fields, set ^||HS.Data(s,field)=val1^val2~val3... and ^||HS.Data(s,field,sub,occ)=val
 #;		  and ^||HS.Data(s,field,sub)=^||HS.Data(seg,n,field,sub,1)

 for s=1:1:pRequest.SegCount {
	kill tSegment
	set tSegment=pRequest.getSegmentByIndex(s)
	set line=tSegment.GetValueAt("",,.tSC) quit:$$$ISERR(tSC)
	set seg=$p(line,s1),^||HS.Data(s)=seg,^||HS.Data(seg)=s,^||HS.Data(seg,s)=""
	for fno=2:1:$l(line,s1) {
		set fval=$p(line,s1,fno) if fval="" continue
		set field=fno-(seg'="MSH")
		if fval'[s3,fval'[s2 set (^||HS.Data(s,field),^||HS.Data(s,field,1),^||HS.Data(s,field,1,1))=fval continue
		if fval[s3 {  // repeating field
			set ^||HS.Data(s,field)=fval
			for occ=1:1:$l(fval,s3) {
				set sval=$p(fval,s3,occ) if sval="" continue
					for sub=1:1:$l(sval,s2) {
						set val=$p(sval,s2,sub) if val="" continue
						set ^||HS.Data(s,field,sub,occ)=val
						if occ=1 set ^||HS.Data(s,field,sub)=val}}
		} else { // not repeating field
			set ^||HS.Data(s,field)=fval
			if fval[s2 {for sub=1:1:$l(fval,s2) {
				set val=$p(fval,s2,sub) if val="" continue
				set (^||HS.Data(s,field,sub),^||HS.Data(s,field,sub,1))=val}}
		}
	}
	do pRequest.commitSegmentByIndex(s)
	
	#; for ORC add index for orders (ORCMED or ORCORD)
	#;  and results (ORCOBS or ORCRES)
	if seg="ORC" {
		set type=$zcvt($$$ORCOrderTypeIdentifier,"U")
		if msgType="ORM_O01" {  // Orders
			if type="MED" {
				set ^||HS.Data(s)="ORCMED",^||HS.Data("ORCMED",s)=""
			} else {
				set ^||HS.Data(s)="ORCORD",^||HS.Data("ORCORD",s)=""
			}
		}
		elseif msgType="OMP_O09" {  // Med Orders
			set ^||HS.Data(s)="ORCOMP",^||HS.Data("ORCOMP",s)=""
		}
		elseif msgType="ORU_R01" {  // Results
			if type="OBS" {
				set ^||HS.Data(s)="ORCOBS",^||HS.Data("ORCOBS",s)=""
			} else {
				set ^||HS.Data(s)="ORCRES",^||HS.Data("ORCRES",s)=""
			}
		}
		elseif msgType="RDE_O11" {
			set ^||HS.Data(s)="ORCRDE",^||HS.Data("ORCRDE",s)=""
		}
		elseif msgType="PPR_PC1" {
			if (type="LAB")||(type="RAD") { set ^||HS.Data(s)="ORCRES",^||HS.Data("ORCRES",s)="" }
			elseif type="OBS" { set ^||HS.Data(s)="ORCOBS",^||HS.Data("ORCOBS",s)="" }
			else { set ^||HS.Data(s)="ORCORD",^||HS.Data("ORCORD",s)="" }
		}
	}
	#; initialize last-processed of each segment type
	set ^||HS.Data(seg)=0
 }

 #; for ORCRES, check if only OBR, OBX(FT/TX) and NTE
 set res="" for {
	set res=$o(^||HS.Data("ORCRES",res)) quit:res=""
	#; If there are no OBX then alltext will be null.
	set tItem=""
	set alltext="" for s=res+1:1 {
		if '$d(^||HS.Data(s)) quit  // end
		if (^||HS.Data(s)="OBR")||(^||HS.Data(s)="NTE")||(^||HS.Data(s)="TQ1") continue
		if ^||HS.Data(s)'="OBX" quit  // next order or other segment	
		#; An OBX found for comparison.
		if alltext="" set alltext=1
		if tItem="" set tItem=$$$OBXObservationIdentifierIdentifier(s)
		if ('(multilineobxmode)&&(tItem'=$$$OBXObservationIdentifierIdentifier(s))){
			set alltext=0
			quit
		}
		if ",FT,TX,ED,"'[(","_$zcvt($$$OBXValueType,"U")_",") set alltext=0 quit
	}
	set ^||HS.Data("ORCRES",res)=alltext
 }
}

/// Unescape HL7 escape sequences found in <i>text</i>.  This will <b>not</b> unescape anything to a
/// carat (^) as that is used as a delimiter internally.  The HL7 escape sequences are used to
/// encode the HL7 field separator and encoding characters, which are defined in MSH-1 and -2 and can
/// vary from message to message.  This method will unescape to the characters used in the current message.
/// Also note that the character used to denote escape sequences (usually "\") is one of the encoding
/// characters that can vary from message to message.  This method will look for the escape character
/// defined for the current message.<br/><br/>
/// The supported HL7 escape sequences are (assuming "\" is the escape character):<br/>
/// \F\ - Field separator (usually "|")<br/>
/// \S\ - Component separator (usually "^")<b>***</b><br/>
/// \R\ - Repetition separator (usually "~")<br/>
/// \E\ - Escape character (usually "\")<br/>
/// \T\ - Subcomponent separator (usually "&")<br/>
/// \.br\ - line break (CRLF)<br/><br/>
/// <b>***Note that, as stated above, this method will not unescape anything to a carat (^), so if the
/// component separator is "^", we will not unescape "\S\" to that.  However this method will unescape "\S\"
/// if another character is used.  The same is true for the other escape sequences.</b>
ClassMethod unescape(text As %String) As %String
{
	//based on replaceArrayLeftToRight^EnsUtil
	set idxStart=1 for {
		//s4 is the escape character
		set idxStart=$find(text,s4,idxStart) quit:idxStart=0
		set idxEnd=$find(text,s4,idxStart) quit:idxEnd=0
		set substr = $extract(text,idxStart-1,idxEnd-1)
		// If substr is too long, it will cause a <SUBSCRIPT> error, so check for this.
		// This will probably be caused by non-escaped escape characters in the data.
		if $L(substr)>10 continue
		//escape is defined in getdata()
		if $data(escape(substr)) { set $extract(text,idxStart-1,idxEnd-1) = escape(substr),idxStart=idxEnd-$l(substr)+1 }
	}
	quit text
}

ClassMethod ACC()
{
 $$$Find("ACC")
 #if $$$HSDebug
	do ##class(HS.Util.HSDebug).Debug("ACC","HS.Gateway.HL7.HL7ToSDA3","txt",s)
 #endif
}

ClassMethod AL1()
{
 $$$Find("AL1")
 #if $$$HSDebug
	do ##class(HS.Util.HSDebug).Debug("AL1","HS.Gateway.HL7.HL7ToSDA3","txt",s)
 #endif

 do ..start("AL1",cr_"<Allergies>")

 do ..write(cr_"<Allergy>")
 Do ..OnAllergy()
 #; AL1-1 : SetIDAL1 ("" means inactivate all, """" means delete all)
 if $$$AL1SetIDAL1="""""" {
	do ..write(cr_"<ActionCode>I</ActionCode></Allergy>") quit
 }
 elseif $$$AL1SetIDAL1="""""""""" {
	do ..write(cr_"<ActionCode>C</ActionCode></Allergy>") quit
 }

 #; AL1-2 : AllergenTypeCode
 if $$$AL1AllergenTypeCodeIdentifier'="" {
	do ..write(cr_"<AllergyCategory>")
	do ..write(cr_"<SDACodingStandard>"_$$$AL1AllergenTypeCodeNameofCodingSystem_"</SDACodingStandard>")
	do ..write(cr_"<Code>"_$$$AL1AllergenTypeCodeIdentifier_"</Code>")
	do ..write(cr_"<Description>"_$$$AL1AllergenTypeCodeText_"</Description>")
	do ..write(cr_"</AllergyCategory>")
}
 #; AL1-3 : AllergenCodeMnemonicDescript
 if ($$$AL1AllergenCodeMnemonicDescriptIdentifier'="")||($$$AL1AllergenCodeMnemonicDescriptText'="") {
	do ..write(cr_"<Allergy>")
	do ..write(cr_"<SDACodingStandard>"_$$$AL1AllergenCodeMnemonicDescriptNameofCodingSystem_"</SDACodingStandard>")
	do ..write(cr_"<Code>"_$$$AL1AllergenCodeMnemonicDescriptIdentifier_"</Code>")
	do ..write(cr_"<Description>"_$$$AL1AllergenCodeMnemonicDescriptText_"</Description>")
	if ($$$AL1AllergenCodeMnemonicAltDescriptIdentifier'="")||($$$AL1AllergenCodeMnemonicAltDescriptText'="") {
		do ..write(cr_"<PriorCodes>")
		do ..write(cr_"<PriorCode>")
		do ..write(cr_"<CodeSystem>"_$$$AL1AllergenCodeMnemonicAltDescriptNameofCodingSystem_"</CodeSystem>")
		do ..write(cr_"<Code>"_$$$AL1AllergenCodeMnemonicAltDescriptIdentifier_"</Code>")
		do ..write(cr_"<Description>"_$$$AL1AllergenCodeMnemonicAltDescriptText_"</Description>")
		do ..write(cr_"<Type>A</Type>")
		do ..write(cr_"</PriorCode>")
		do ..write(cr_"</PriorCodes>")
	}
	if ($$$AL1AllergenCodeMnemonicOriginalText'="") {
		do ..write(cr_"<OriginalText>"_$$$AL1AllergenCodeMnemonicOriginalText_"</OriginalText>")
	}
	do ..write(cr_"</Allergy>")
 }

 #; AL1-4 : AllergySeverityCode
 if ($$$AL1AllergySeverityCodeIdentifier'="")||($$$AL1AllergySeverityCodeText'="") {
	do ..write(cr_"<Severity>")
	do ..write(cr_"<SDACodingStandard>"_$$$AL1AllergySeverityCodeNameofCodingSystem_"</SDACodingStandard>")
	do ..write(cr_"<Code>"_$$$AL1AllergySeverityCodeIdentifier_"</Code>")
	do ..write(cr_"<Description>"_$$$AL1AllergySeverityCodeText_"</Description>")
	do ..write(cr_"</Severity>")
 }

 #; AL1-5 : AllergyReaction
 set %occ="" for {
	set %occ=$$$AL1AllergyReaction(%occ) quit:%occ=""
	do ..write(cr_"<Reaction>")
	do ..write(cr_"<Code>"_$$$AL1AllergyReactionCode(%occ)_"</Code>")
	do ..write(cr_"</Reaction>")
	quit  // only one
 }

 #; AL1-6 : IdentificationDate  (we assume to be HL7 Date)
 do ..write(cr_"<DiscoveryTime>"_..xmltimestamp($$$AL1IdentificationDate)_"</DiscoveryTime>")
 do ..write(cr_"<FromTime>"_..xmltimestamp($$$AL1IdentificationDate)_"</FromTime>")

 #; Status - there is no AL1 field for Status, so we force it to 'A' (Active)
 #;  else 'snapshot mode' would not work - the allergy would stay inactive
 do ..write(cr_"<Status>A</Status>")

 #; MSH-4 : EnteredAt
 do ..write(cr_"<EnteredAt>")
 do ..write(cr_"<Code>"_$$$MSHSendingFacilityNamespaceID_"</Code>")
 do ..write(cr_"</EnteredAt>")

 do ..write(cr_"</Allergy>")
}

ClassMethod AIL()
{
	$$$Find("AIL")
	
	if $$$AILLocationResourceIDLocationDescription'="" {
		do ..write(cr_"<Location>")
		do ..write(cr_"<Code>"_$$$AILLocationResourceIDLocationDescription_"</Code>")
		do ..write(cr_"</Location>") 
 }
}

ClassMethod AIP()
{
	$$$Find("AIP")
	
	#; AIP-3 : PersonnelResourceID
	#; AIP-4 : ResourceType
	set %occ="" for {
		set %occ=$$$AIPPersonnelResourceID(%occ) quit:%occ=""
		do ..write(cr_"<CareProvider>")
		do ..write(cr_"<SDACodingStandard>"_$$$AIPPersonnelResourceIDIDAssigningAuthority(%occ)_"</SDACodingStandard>")
		do ..write(cr_"<Code>"_$$$AIPPersonnelResourceIDIDNumber(%occ)_"</Code>")
		set name=..formatname($$$AIPPersonnelResourceIDFamilyNameSurname(%occ),$$$AIPPersonnelResourceIDGivenName(%occ),$$$AIPPersonnelResourceIDMiddleName(%occ),$$$AIPPersonnelResourceIDNamePrefix(%occ))
		do ..write(cr_"<Description>"_name_"</Description>")
		do ..write(cr_"<Name>")
		do ..write(cr_"<FamilyName>"_$$$AIPPersonnelResourceIDFamilyNameSurname(%occ)_"</FamilyName>") 
		do ..write(cr_"<GivenName>"_$$$AIPPersonnelResourceIDGivenName(%occ)_"</GivenName>") 
		do ..write(cr_"<MiddleName>"_$$$AIPPersonnelResourceIDMiddleName(%occ)_"</MiddleName>") 
		do ..write(cr_"<NamePrefix>"_$$$AIPPersonnelResourceIDNamePrefix(%occ)_"</NamePrefix>")
		do ..write(cr_"<NameSuffix>"_$$$AIPPersonnelResourceIDNameSuffix(%occ)_"</NameSuffix>")
		do ..write(cr_"<ProfessionalSuffix>"_$$$AIPPersonnelResourceIDProfessionalSuffix(%occ)_"</ProfessionalSuffix>")
		do ..write(cr_"</Name>")
		if ($$$AIPResourceTypeIdentifier'="")||($$$AIPResourceTypeText'="") {
			do ..write(cr_"<CareProviderType>")
			do ..write(cr_"<SDACodingStandard>"_$$$AIPResourceTypeNameofCodingSystem_"</SDACodingStandard>")
			do ..write(cr_"<Code>"_$$$AIPResourceTypeIdentifier_"</Code>")
			do ..write(cr_"<Description>"_$$$AIPResourceTypeText_"</Description>")
			do ..write(cr_"</CareProviderType>")
		}
		do ..write(cr_"</CareProvider>")
		quit  // only one
 	}
}

ClassMethod AIS()
{
	$$$Find("AIS")
	
	#; AIS-3 : Universal Service Identifier
	if ($$$AISUniversalServiceIdentifierIdentifier'="")||($$$AISUniversalServiceIdentifierText'="") {
		do ..write(cr_"<OrderItem>")
		do ..write(cr_"<SDACodingStandard>"_$$$AISUniversalServiceIdentifierNameofCodingSystem_"</SDACodingStandard>")
		do ..write(cr_"<Code>"_$$$AISUniversalServiceIdentifierIdentifier_"</Code>")
		do ..write(cr_"<Description>"_$$$AISUniversalServiceIdentifierText_"</Description>")
		if ($$$AISUniversalServiceIdentifierAltIdentifier'="")||($$$AISUniversalServiceIdentifierAltText'="") {
			do ..write(cr_"<PriorCodes>")
			do ..write(cr_"<PriorCode>")
			do ..write(cr_"<CodeSystem>"_$$$AISUniversalServiceIdentifierAltNameofCodingSystem_"</CodeSystem>")
			do ..write(cr_"<Code>"_$$$AISUniversalServiceIdentifierAltIdentifier_"</Code>")
			do ..write(cr_"<Description>"_$$$AISUniversalServiceIdentifierAltText_"</Description>")
			do ..write(cr_"<Type>A</Type>")
			do ..write(cr_"</PriorCode>")
			do ..write(cr_"</PriorCodes>")
		}
		if ($$$AISUniversalServiceIdentifierOriginalText'="") {
			do ..write(cr_"<OriginalText>"_$$$AISUniversalServiceIdentifierOriginalText_"</OriginalText>")
		}
		do ..write(cr_"</OrderItem>")
	}
}

ClassMethod DB1()
{
 $$$Find("DB1")
 #if $$$HSDebug
	do ##class(HS.Util.HSDebug).Debug("DB1","HS.Gateway.HL7.HL7ToSDA3","txt",s)
 #endif
}

ClassMethod DG1()
{
 $$$Find("DG1")
 // In ADT_A11 (Cancel Admit), DG1 remains for backwards compatibility only, so is ignored here
 if (msgType="ADT_A11") {
	 if (pLogAlerts) $$$LOGALERT("Segment "_s_" of type DG1 is supported in ADT_A11 for backwards compatibility only and will not be parsed.")
	 quit
 }
 #if $$$HSDebug
	do ##class(HS.Util.HSDebug).Debug("DG1","HS.Gateway.HL7.HL7ToSDA3","txt",s)
 #endif

 do ..start("DG1",cr_"<Diagnoses>")

 do ..write(cr_"<Diagnosis>")
 do ..OnDiagnosis()
 do ..WriteEncounterNumber(encNum)

 #; DG1-1 : SetIDDG1 ("" means inactivate all, """" means delete all)
 if $$$DG1SetIDDG1="""""" {
	do ..write(cr_"<ActionCode>I</ActionCode></Diagnosis>") quit
 }
 elseif $$$DG1SetIDDG1="""""""""" {
	do ..write(cr_"<ActionCode>C</ActionCode></Diagnosis>") quit
 }

 #; DG1-3 : DiagnosisCodeDG1
 if ($$$DG1DiagnosisCodeDG1Identifier'="")||($$$DG1DiagnosisCodeDG1Text'="") {
	do ..write(cr_"<Diagnosis>")
	do ..write(cr_"<SDACodingStandard>"_$$$DG1DiagnosisCodeDG1NameofCodingSystem_"</SDACodingStandard>")
	do ..write(cr_"<Code>"_$$$DG1DiagnosisCodeDG1Identifier_"</Code>")
	do ..write(cr_"<Description>"_$$$DG1DiagnosisCodeDG1Text_"</Description>")
	if ($$$DG1DiagnosisCodeDG1AltIdentifier'="")||($$$DG1DiagnosisCodeDG1AltText'="") {
		do ..write(cr_"<PriorCodes>")
		do ..write(cr_"<PriorCode>")
		do ..write(cr_"<CodeSystem>"_$$$DG1DiagnosisCodeDG1AltNameofCodingSystem_"</CodeSystem>")
		do ..write(cr_"<Code>"_$$$DG1DiagnosisCodeDG1AltIdentifier_"</Code>")
		do ..write(cr_"<Description>"_$$$DG1DiagnosisCodeDG1AltText_"</Description>")
		do ..write(cr_"<Type>A</Type>")
		do ..write(cr_"</PriorCode>")
		do ..write(cr_"</PriorCodes>")
	}
	if ($$$DG1DiagnosisCodeDG1OriginalText'="") {
		do ..write(cr_"<OriginalText>"_$$$DG1DiagnosisCodeDG1OriginalText_"</OriginalText>")
	}
	do ..write(cr_"</Diagnosis>")
 } 

 #; DG1-4 : DiagnosisDescription
 elseif $$$DG1DiagnosisDescription'="" {
	do ..write(cr_"<Diagnosis>")
	do ..write(cr_"<Code>"_$$$DG1DiagnosisDescription_"</Code>")
	do ..write(cr_"</Diagnosis>")
 }

 #; DG1-5 : DiagnosisDateTime
 do ..write(cr_"<EnteredOn>"_..xmltimestamp($$$DG1DiagnosisDateTimeTime)_"</EnteredOn>")

 #; DG1-6 : DiagnosisType
 if $$$DG1DiagnosisType'="" {
	do ..write(cr_"<DiagnosisType>")
	do ..write(cr_"<Code>"_$$$DG1DiagnosisType_"</Code>")
	do ..write(cr_"</DiagnosisType>")
 }

 #; DG1-15 : DiagnosisPriority
 if $$$DG1DiagnosisPriority'="" {
	do ..write(cr_"<DiagnosisPriority>"_$$$DG1DiagnosisPriority_"</DiagnosisPriority>")
 }

 #; DG1-16 : DiagnosingClinician
 set %occ="" for {
	set %occ=$$$DG1DiagnosingClinician(%occ) quit:%occ=""
	do ..By("<DiagnosingClinician>",,
		"CareProvider",
		$$$DG1DiagnosingClinicianIDAssigningAuthority(%occ),
		$$$DG1DiagnosingClinicianIDNumber(%occ),
		$$$DG1DiagnosingClinicianFamilyNameSurname(%occ),
		$$$DG1DiagnosingClinicianGivenName(%occ),
		$$$DG1DiagnosingClinicianMiddleName(%occ),
		$$$DG1DiagnosingClinicianNamePrefix(%occ),
		$$$DG1DiagnosingClinicianNameSuffix(%occ),
		$$$DG1DiagnosingClinicianProfessionalSuffix(%occ))
	quit  // only one
 }

 #; DG1-21 : DiagnosisActionCode
 #; Only allow A,D or U (HL7 values).  Note that 'I' would cause 'Inactivate ALL'
 set action=$$$DG1DiagnosisActionCode if ",A,D,U,,"'[(","_action_",") set action="A"
 do ..write(cr_"<ActionCode>"_action_"</ActionCode>")
 kill action

 #; Status - there is no DG1 field for Status, so we force it to 'A' (Active)
 #;  else 'snapshot mode' would not work - the diagnoses would stay inactive
 do ..write(cr_"<Status><Code>A</Code><Description>Active</Description></Status>")
 
 #; MSH-4 : SendingFacility -> EnteredAt in SuperClass 
 do ..write(cr_"<EnteredAt>")
 do ..write(cr_"<Code>"_$$$MSHSendingFacilityNamespaceID_"</Code>")
 do ..write(cr_"</EnteredAt>")

 do ..write(cr_"</Diagnosis>")
}

ClassMethod DRG()
{
 $$$Find("DRG")
 	do ..write(cr_"<DiagnosisRelatedGroup>")
		do ..write(cr_"<SDACodingStandard>"_$$$DRGDiagnosisRelatedGroupNameofCodingSystem_"</SDACodingStandard>")
		do ..write(cr_"<Code>"_$$$DRGDiagnosisRelatedGroupIdentifier_"</Code>")
		do ..write(cr_"<Description>"_$$$DRGDiagnosisRelatedGroupText_"</Description>")
 	do ..write(cr_"</DiagnosisRelatedGroup>")
 #if $$$HSDebug
	do ##class(HS.Util.HSDebug).Debug("DRG","HS.Gateway.HL7.HL7ToSDA3","txt",s)
 #endif
}

ClassMethod EVN()
{
 $$$Find("EVN")
 #if $$$HSDebug
	do ##class(HS.Util.HSDebug).Debug("EVN","HS.Gateway.HL7.HL7ToSDA3","txt",s)
 #endif
}

ClassMethod GT1()
{
 $$$Find("GT1")
 #if $$$HSDebug
	do ##class(HS.Util.HSDebug).Debug("GT1","HS.Gateway.HL7.HL7ToSDA3","txt",s)
 #endif

 do ..start("GT1",cr_"<Guarantors>")

 do ..write(cr_"<Guarantor>")

 #; GT1-2 : GuarantorNumber
 set (%occ,numbertype)="" for {
	set %occ=$$$GT1GuarantorNumber(%occ) quit:%occ=""	 
	do ..write(cr_"<GuarantorNumber>")
	do ..write(cr_"<Number>"_$$$GT1GuarantorNumberIDNumber(%occ)_"</Number>")
	set numbertype=..idtype($$$GT1GuarantorNumberIdentifierTypeCode(%occ))
	do ..write(cr_"<NumberType>"_numbertype_"</NumberType>")
	set assigningauthority=$$$GT1GuarantorNumberAssigningAuthorityNamespaceID(%occ)
	if assigningauthority="" {
		set assigningauthority=$$$MSHSendingFacilityNamespaceID}
	if assigningauthority'="" {
		do ..write(cr_"<Organization>")
		do ..write(cr_"<Code>"_assigningauthority_"</Code>")
		do ..write(cr_"</Organization>")
	}
	do ..write(cr_"</GuarantorNumber>")
	quit // only one
 }

 #; GT1-3 : GuarantorName
 set %occ="" for {
	set %occ=$$$GT1GuarantorName(%occ) quit:%occ=""	 
	do ..write(cr_"<Name>")
	do ..write(cr_"<GivenName>"_$$$GT1GuarantorNameGivenName(%occ)_"</GivenName>")
	do ..write(cr_"<FamilyName>"_$$$GT1GuarantorNameFamilyNameSurname(%occ)_"</FamilyName>")
	do ..write(cr_"<FamilyNamePrefix>"_$$$GT1GuarantorNameFamilyNameOwnSurnamePrefix(%occ)_"</FamilyNamePrefix>")
	do ..write(cr_"<MiddleName>"_$$$GT1GuarantorNameSecondandFurtherGivenNamesor(%occ)_"</MiddleName>")
	do ..write(cr_"<NamePrefix>"_$$$GT1GuarantorNamePrefix(%occ)_"</NamePrefix>")
	do ..write(cr_"<NameSuffix>"_$$$GT1GuarantorNameSuffix(%occ)_"</NameSuffix>")
	do ..write(cr_"<ProfessionalSuffix>"_$$$GT1GuarantorNameProfessionalSuffix(%occ)_"</ProfessionalSuffix>")
	do ..write(cr_"</Name>")
	quit  // only one
 }

 #; GT1-5 : GuarantorAddress
 set %occ="" for {
	set %occ=$$$GT1GuarantorAddress(%occ) quit:%occ=""
	do ..write(cr_"<Address>")	 
	do ..write(cr_"<Street>")
	do ..write($$$GT1GuarantorAddressStreetAddressStreetorMailingAddress(%occ))
	if $$$GT1GuarantorAddressOtherDesignation(%occ)'="" {
		do ..write("; "_$$$GT1GuarantorAddressOtherDesignation(%occ))}
	do ..write("</Street>")
	if $$$GT1GuarantorAddressCity(%occ)'="" {
		do ..write(cr_"<City>")
		do ..write(cr_"<Code>"_$$$GT1GuarantorAddressCity(%occ)_"</Code>")
		do ..write(cr_"</City>")
	}
	if $$$GT1GuarantorAddressStateorProvince(%occ)'="" {
		do ..write(cr_"<State>")
		do ..write(cr_"<Code>"_$$$GT1GuarantorAddressStateorProvince(%occ)_"</Code>")
		do ..write(cr_"</State>")
	}
	if $$$GT1GuarantorAddressZiporPostalCode(%occ)'="" {
		do ..write(cr_"<Zip>")
		do ..write(cr_"<Code>"_$$$GT1GuarantorAddressZiporPostalCode(%occ)_"</Code>")
		do ..write(cr_"</Zip>")
	}
	if $$$GT1GuarantorAddressCountry(%occ)'="" {
		do ..write(cr_"<Country>")
		do ..write(cr_"<Code>"_$$$GT1GuarantorAddressCountry(%occ)_"</Code>")
		do ..write(cr_"</Country>")
	}
	if $$$GT1GuarantorAddressCountyParishCode(%occ)'="" {
		do ..write(cr_"<County>")
		do ..write(cr_"<Code>"_$$$GT1GuarantorAddressCountyParishCode(%occ)_"</Code>")
		do ..write(cr_"</County>")
	}
	do ..write(cr_"<FromTime>"_..xmltimestamp($$$GT1GuarantorAddressEffectiveDateTime(%occ))_"</FromTime>")
	do ..write(cr_"<ToTime>"_..xmltimestamp($$$GT1GuarantorAddressExpirationDateTime(%occ))_"</ToTime>")
	do ..write(cr_"</Address>")
	quit  // only one 
 }

 #; GT1-6 : GuarantorPhNumHome
 #; GT1-7 : GuarantorPhNumBusiness
 do ..PhonesAndEmail(s,6,.homephone,.homemobile,.homeemail)
 do ..PhonesAndEmail(s,7,.workphone,.workmobile,.workemail)
 set home=$p(homephone,"^",1),work=$p(workphone,"^",1)
 set mobile=$p(homemobile,"^",1) if mobile="" set mobile=$p(workmobile,"^",1)
 set email=$p(homeemail,"^",1) if email="" set email=$p(workemail,"^",1)
 do ..write(cr_"<ContactInfo>")
 do ..write(cr_"<HomePhoneNumber>"_..xml(home)_"</HomePhoneNumber>")
 do ..write(cr_"<WorkPhoneNumber>"_..xml(work)_"</WorkPhoneNumber>")
 do ..write(cr_"<MobilePhoneNumber>"_..xml(mobile)_"</MobilePhoneNumber>")
 do ..write(cr_"<EmailAddress>"_..xml(email)_"</EmailAddress>")
 do ..write(cr_"</ContactInfo>")
 kill home,mobile,email

 #; GT1-8 : GuarantorDateTimeOfBirth
 do ..write(cr_"<BirthTime>"_..xmltimestamp($$$GT1GuarantorDateTimeOfBirthTime)_"</BirthTime>")
 
 #; GT1-9 : GuarantorAdministrativeSex
 if $$$GT1GuarantorAdministrativeSex'="" {
	do ..write(cr_"<Gender>")
	do ..write(cr_"<Code>"_$$$GT1GuarantorAdministrativeSex_"</Code>")
	do ..write(cr_"</Gender>")
 }
 #; GT1-10 : GuarantorType
 if ($$$GT1GuarantorType'=""){
	do ..write(cr_"<GuarantorType>"_$$$GT1GuarantorType_"</GuarantorType>")
 }
 #; GT1-11 : GuarantorRelationship
 if ($$$GT1GuarantorRelationshipIdentifier'="")||($$$GT1GuarantorRelationshipText'="") {
	do ..write(cr_"<Relationship>")
	do ..write(cr_"<SDACodingStandard>"_$$$GT1GuarantorRelationshipNameofCodingSystem_"</SDACodingStandard>")
	do ..write(cr_"<Code>"_$$$GT1GuarantorRelationshipIdentifier_"</Code>")
	do ..write(cr_"<Description>"_$$$GT1GuarantorRelationshipText_"</Description>")
	do ..write(cr_"</Relationship>")
 }

 #; GT1-12 : GuarantorSSN
 if ($$$GT1GuarantorSSN'=""){
	do ..write(cr_"<SSN>"_$$$GT1GuarantorSSN_"</SSN>")
 }

 #; GT1-13 : GuarantorDateBegin  (maybe free text), we treat as HL7DateTime
 do ..write(cr_"<FromTime>"_..xmltimestamp($$$GT1GuarantorDateBegin)_"</FromTime>")

 #; GT1-14 : GuarantorDateEnd  (maybe free text), we treat as HL7DateTime
 do ..write(cr_"<ToTime>"_..xmltimestamp($$$GT1GuarantorDateEnd)_"</ToTime>")

 #; GT1-16 : GuarantorEmployerName
 set %occ="" for {
	set %occ=$$$GT1GuarantorEmployerName(%occ) quit:%occ=""	 
	do ..write(cr_"<EmployerName>")
	do ..write(cr_"<GivenName>"_$$$GT1GuarantorEmployerNameGivenName(%occ)_"</GivenName>")
	do ..write(cr_"<FamilyName>"_$$$GT1GuarantorEmployerNameFamilyNameSurname(%occ)_"</FamilyName>")
	do ..write(cr_"<FamilyNamePrefix>"_$$$GT1GuarantorEmployerNameFamilyNameOwnSurnamePrefix(%occ)_"</FamilyNamePrefix>")
	do ..write(cr_"<MiddleName>"_$$$GT1GuarantorEmployerNameSecondandFurtherGivenNamesor(%occ)_"</MiddleName>")
	do ..write(cr_"<NamePrefix>"_$$$GT1GuarantorEmployerNamePrefix(%occ)_"</NamePrefix>")
	do ..write(cr_"<NameSuffix>"_$$$GT1GuarantorEmployerNameSuffix(%occ)_"</NameSuffix>")
	do ..write(cr_"<ProfessionalSuffix>"_$$$GT1GuarantorEmployerNameProfessionalSuffix(%occ)_"</ProfessionalSuffix>")
	do ..write(cr_"</EmployerName>")
	quit  // only one
 }

 #; GT1-17 : GuarantorEmployerAddress
 set %occ="" for {
	set %occ=$$$GT1GuarantorEmployerAddress(%occ) quit:%occ=""
	do ..write(cr_"<EmployerAddress>")	 
	do ..write(cr_"<Street>")
	do ..write($$$GT1GuarantorEmployerAddressStreetAddressStreetorMailingAddress(%occ))
	if $$$GT1GuarantorEmployerAddressOtherDesignation(%occ)'="" {
		do ..write("; "_$$$GT1GuarantorEmployerAddressOtherDesignation(%occ))}
	do ..write("</Street>")
	if $$$GT1GuarantorEmployerAddressCity(%occ)'="" {
		do ..write(cr_"<City>")
		do ..write(cr_"<Code>"_$$$GT1GuarantorEmployerAddressCity(%occ)_"</Code>")
		do ..write(cr_"</City>")
	}
	if $$$GT1GuarantorEmployerAddressStateorProvince(%occ)'="" {
		do ..write(cr_"<State>")
		do ..write(cr_"<Code>"_$$$GT1GuarantorEmployerAddressStateorProvince(%occ)_"</Code>")
		do ..write(cr_"</State>")
	}
	if $$$GT1GuarantorEmployerAddressZiporPostalCode(%occ)'="" {
		do ..write(cr_"<Zip>")
		do ..write(cr_"<Code>"_$$$GT1GuarantorEmployerAddressZiporPostalCode(%occ)_"</Code>")
		do ..write(cr_"</Zip>")
	}
	if $$$GT1GuarantorEmployerAddressCountry(%occ)'="" {
		do ..write(cr_"<Country>")
		do ..write(cr_"<Code>"_$$$GT1GuarantorEmployerAddressCountry(%occ)_"</Code>")
		do ..write(cr_"</Country>")
	}
	if $$$GT1GuarantorEmployerAddressCountyParishCode(%occ)'="" {
		do ..write(cr_"<County>")
		do ..write(cr_"<Code>"_$$$GT1GuarantorEmployerAddressCountyParishCode(%occ)_"</Code>")
		do ..write(cr_"</County>")
	}
	do ..write(cr_"<FromTime>"_..xmltimestamp($$$GT1GuarantorEmployerAddressEffectiveDateTime(%occ))_"</FromTime>")
	do ..write(cr_"<ToTime>"_..xmltimestamp($$$GT1GuarantorEmployerAddressExpirationDateTime(%occ))_"</ToTime>")
	do ..write(cr_"</EmployerAddress>")
	quit  // only one 
 }

 #; GT1-51 : GuarantorEmployerOrganizationName
 set %occ="" for {
	set %occ=$$$GT1GuarantorEmployerOrganizationName(%occ) quit:%occ=""
	do ..write(cr_"<EmployerOrganizationName>"_$$$GT1GuarantorEmployerOrganizationNameName(%occ)_"</EmployerOrganizationName>")
	quit  // only one 
}
 #; GT1-18 : GuarantorEmployerPhoneNumber
 do ..PhonesAndEmail(s,18,.employerhomephone,.employermobile,,,.employerworkphone)
 set ehome=$p(employerhomephone,"^",1)
 set mobile=$p(employermobile,"^",1)
 set work=$p(employerworkphone,"^",1)
 set:work="" work=mobile
 set:work="" work=ehome
 do ..write(cr_"<EmployerPhoneNumber>"_..xml(work)_"</EmployerPhoneNumber>")
 kill ehome,mobile,work

 #; GT1-20 : GuarantorEmploymentStatusCode
 If ($$$GT1GuarantorEmploymentStatusCode'="") {
	 do ..write(cr_"<EmploymentStatusCode>")
	 do ..write(cr_"<Code>"_$$$GT1GuarantorEmploymentStatusCode_"</Code>")
	 do ..write(cr_"</EmploymentStatusCode>")
 }
 
 #; GT1-29 : GuarantorEmployerID
 If ($$$GT1GuarantorEmployerID'=""){
	do ..write(cr_"<EmployerID>"_$$$GT1GuarantorEmployerID_"</EmployerID>")
 }
 
 #; GT1-31 : GuarantorHireEffectiveDate  (maybe free text), we treat as HL7DateTime
 do ..write(cr_"<HireEffectiveDate>"_..xmltimestamp($$$GT1GuarantorHireEffectiveDate)_"</HireEffectiveDate>")

 #; GT1-32 : GuarantorEmploymentStopDate  (maybe free text), we treat as HL7DateTime
 do ..write(cr_"<EmploymentStopDate>"_..xmltimestamp($$$GT1GuarantorEmploymentStopDate)_"</EmploymentStopDate>")

 #; GT1-49 : GuarantorJobTitle
 if ($$$GT1GuarantorJobTitle'="") {
	 do ..write(cr_"<JobTitle>"_$$$GT1GuarantorJobTitle_"</JobTitle>")
 }
 
 #; GT1-50 : GuarantorOccupation
 do ..write(cr_"<Occupation>")
 do ..write(cr_"<Code>"_$$$GT1GuarantorOccupationCode_"</Code>")
 do ..write(cr_"<JobClass>"_$$$GT1GuarantorOccupationClass_"</JobClass>")
 do ..write(cr_"<Description>"_$$$GT1GuarantorOccupationDescriptionText_"</Description>")
 do ..write(cr_"</Occupation>")

 do ..write(cr_"</Guarantor>")
}

ClassMethod IAM()
{

 $$$Find("IAM")
 #if $$$HSDebug
	do ##class(HS.Util.HSDebug).Debug("IAM","HS.Gateway.HL7.HL7ToSDA3","txt",s)
 #endif

 do ..start("IAM",cr_"<Allergies>")

 do ..write(cr_"<Allergy>")
 Do ..OnAllergy()
 #; IAM-1 : SetIDIAM ("" means inactivate all, """" means delete all)
 if $$$IAMSetIDIAM="""""" {
	do ..write(cr_"<ActionCode>I</ActionCode></Allergy>") quit
 }
 elseif $$$IAMSetIDIAM="""""""""" {
	do ..write(cr_"<ActionCode>C</ActionCode></Allergy>") quit
 }

 #; IAM-2 : AllergenTypeCode
 if $$$IAMAllergenTypeCodeIdentifier'="" {
	do ..write(cr_"<AllergyCategory>")
	do ..write(cr_"<SDACodingStandard>"_$$$IAMAllergenTypeCodeNameofCodingSystem_"</SDACodingStandard>")
	do ..write(cr_"<Code>"_$$$IAMAllergenTypeCodeIdentifier_"</Code>")
	do ..write(cr_"<Description>"_$$$IAMAllergenTypeCodeText_"</Description>")
	do ..write(cr_"</AllergyCategory>")
}
 #; IAM-3 : AllergenCodeMnemonicDescript
 if ($$$IAMAllergenCodeMnemonicDescriptIdentifier'="")||($$$IAMAllergenCodeMnemonicDescriptText'="") {
	do ..write(cr_"<Allergy>")
	do ..write(cr_"<SDACodingStandard>"_$$$IAMAllergenCodeMnemonicDescriptNameofCodingSystem_"</SDACodingStandard>")
	do ..write(cr_"<Code>"_$$$IAMAllergenCodeMnemonicDescriptIdentifier_"</Code>")
	do ..write(cr_"<Description>"_$$$IAMAllergenCodeMnemonicDescriptText_"</Description>")
	if ($$$IAMAllergenCodeMnemonicAltDescriptIdentifier'="")||($$$IAMAllergenCodeMnemonicAltDescriptText'="") {
		do ..write(cr_"<PriorCodes>")
		do ..write(cr_"<PriorCode>")
		do ..write(cr_"<CodeSystem>"_$$$IAMAllergenCodeMnemonicAltDescriptNameofCodingSystem_"</CodeSystem>")
		do ..write(cr_"<Code>"_$$$IAMAllergenCodeMnemonicAltDescriptIdentifier_"</Code>")
		do ..write(cr_"<Description>"_$$$IAMAllergenCodeMnemonicAltDescriptText_"</Description>")
		do ..write(cr_"<Type>A</Type>")
		do ..write(cr_"</PriorCode>")
		do ..write(cr_"</PriorCodes>")
	}
	if ($$$IAMAllergenCodeMnemonicOriginalText'="") {
		do ..write(cr_"<OriginalText>"_$$$IAMAllergenCodeMnemonicOriginalText_"</OriginalText>")
	}
	do ..write(cr_"</Allergy>")
 }

 #; IAM-4 : AllergySeverityCode
 if ($$$IAMAllergySeverityCodeIdentifier'="")||($$$IAMAllergySeverityCodeText'="") {
	do ..write(cr_"<Severity>")
	do ..write(cr_"<SDACodingStandard>"_$$$IAMAllergySeverityCodeNameofCodingSystem_"</SDACodingStandard>")
	do ..write(cr_"<Code>"_$$$IAMAllergySeverityCodeIdentifier_"</Code>")
	do ..write(cr_"<Description>"_$$$IAMAllergySeverityCodeText_"</Description>")
	do ..write(cr_"</Severity>")
 }

 #; IAM-5 : AllergyReaction
 set %occ="" for {
	set %occ=$$$IAMAllergyReaction(%occ) quit:%occ=""
	do ..write(cr_"<Reaction>")
	do ..write(cr_"<Code>"_$$$IAMAllergyReactionCode(%occ)_"</Code>")
	do ..write(cr_"</Reaction>")
	quit  // only one
 }

 #; IAM-6 : AllergyActionCode
 if $$$IAMAllergyActionCode="D" do ..write(cr_"<ActionCode>D</ActionCode>")

 #; IAM-7 : AllergyUniqueIdentifier
 do ..write(cr_"<ExternalId>"_$$$IAMAllergyUniqueIdentifierEntityIdentifier_"</ExternalId>")
 
 #; IAM-8 : ActionReason
 do ..write(cr_"<InactiveComments>"_$$$IAMActionReason_"</InactiveComments>")

 #; IAM-11 : OnSetDate (we assume to be HL7 Date) 
 do ..write(cr_"<FromTime>"_..xmltimestamp($$$IAMOnSetDate)_"</FromTime>")

 #; IAM-13 : ReportedDateTime
 do ..write(cr_"<EnteredOn>"_..xmltimestamp($$$IAMReportedDateTimeTime)_"</EnteredOn>")

 #; IAM-14 : ReportedBy
 do ..By("<EnteredBy>",,"User","","",
 	$$$IAMReportedByFamilyNameSurname,$$$IAMReportedByGivenName)

 #; IAM-17 : AllergyClinicalStatusCode
 do ..write(cr_"<Status>"_$$$IAMAllergyClinicalStatusCodeIdentifier_"</Status>")

 #; IAM-20 : StatusedatDateTime
 do ..write(cr_"<InactiveTime>"_..xmltimestamp($$$IAMStatusedatDateTime)_"</InactiveTime>")

 #; MSH-4 : EnteredAt
 do ..write(cr_"<EnteredAt>")
 do ..write(cr_"<Code>"_$$$MSHSendingFacilityNamespaceID_"</Code>")
 do ..write(cr_"</EnteredAt>")

 do ..write(cr_"</Allergy>")
}

ClassMethod IN1()
{
 $$$Find("IN1")
 #if $$$HSDebug
	do ##class(HS.Util.HSDebug).Debug("IN1","HS.Gateway.HL7.HL7ToSDA3","txt",s)
 #endif

 #; IN1-3.1 : InsuranceCompany or #; IN1-4.1 : InsuranceCompanyName are required
 if $$$IN1InsuranceCompanyID="",$$$IN1InsuranceCompanyName="" quit

 do ..start("IN1",cr_"<HealthFunds>")

 do ..write(cr_"<HealthFund>")
	
 #; IN1-2 : InsurancePlanID
 #; Plan (if present)  [HL7: required]
 if ($$$IN1InsurancePlanIDIdentifier'="")||($$$IN1InsurancePlanIDText'="") {
	do ..write(cr_"<HealthFundPlan>")
	do ..write(cr_"<SDACodingStandard>"_$$$IN1InsurancePlanIDNameofCodingSystem_"</SDACodingStandard>")
	do ..write(cr_"<Code>"_$$$IN1InsurancePlanIDIdentifier_"</Code>")
	do ..write(cr_"<Description>"_$$$IN1InsurancePlanIDText_"</Description>")
	do ..write(cr_"</HealthFundPlan>")
 }
 #; IN1-3 : InsuranceCompany
 #; IN1-4 : InsuranceCompanyName
 #; Fund
 do ..write(cr_"<HealthFund>")
 do ..write(cr_"<SDACodingStandard>"_$$$IN1InsuranceCompanyAssigningAuthority_"</SDACodingStandard>")
 do ..write(cr_"<Code>"_$$$IN1InsuranceCompanyID_"</Code>")
 do ..write(cr_"<Description>"_$$$IN1InsuranceCompanyName_"</Description>")
 #; IN1-5 : InsuranceCompanyAddress
 do ..write(cr_"<Address>")	 
 do ..write(cr_"<Street>")
 do ..write($$$IN1InsuranceCompanyAddressStreetAddressStreetorMailingAddress)
 if $$$IN1InsuranceCompanyAddressOtherDesignation'="" {
	do ..write("; "_$$$IN1InsuranceCompanyAddressOtherDesignation)}
 do ..write("</Street>")
 if $$$IN1InsuranceCompanyAddressCity'="" {
	do ..write(cr_"<City>")
	do ..write(cr_"<Code>"_$$$IN1InsuranceCompanyAddressCity_"</Code>")
	do ..write(cr_"</City>")
 }
 if $$$IN1InsuranceCompanyAddressStateorProvince'="" {
	do ..write(cr_"<State>")
	do ..write(cr_"<Code>"_$$$IN1InsuranceCompanyAddressStateorProvince_"</Code>")
	do ..write(cr_"</State>")
 }
 if $$$IN1InsuranceCompanyAddressZiporPostalCode'="" {
	do ..write(cr_"<Zip>")
	do ..write(cr_"<Code>"_$$$IN1InsuranceCompanyAddressZiporPostalCode_"</Code>")
	do ..write(cr_"</Zip>")
 }
 if $$$IN1InsuranceCompanyAddressCountry'="" {
	do ..write(cr_"<Country>")
	do ..write(cr_"<Code>"_$$$IN1InsuranceCompanyAddressCountry_"</Code>")
	do ..write(cr_"</Country>")
 }
 if $$$IN1InsuranceCompanyAddressCountyParishCode'="" {
	do ..write(cr_"<County>")
	do ..write(cr_"<Code>"_$$$IN1InsuranceCompanyAddressCountyParishCode_"</Code>")
	do ..write(cr_"</County>")
 }
 do ..write(cr_"<FromTime>"_..xmltimestamp($$$IN1InsuranceCompanyAddressEffectiveDateTime)_"</FromTime>")
 do ..write(cr_"<ToTime>"_..xmltimestamp($$$IN1InsuranceCompanyAddressExpirationDateTime)_"</ToTime>")
 do ..write(cr_"</Address>")
 #; IN1-6 : InsuranceCoContactPerson
 do ..write(cr_"<ContactPerson>")	 
 do ..write(cr_"<GivenName>"_$$$IN1InsuranceCoContactPersonGivenName_"</GivenName>")
 do ..write(cr_"<FamilyName>"_$$$IN1InsuranceCoContactPersonFamilyNameSurname_"</FamilyName>")
 do ..write(cr_"<FamilyNamePrefix>"_$$$IN1InsuranceCoContactPersonFamilyNameOwnSurnamePrefix_"</FamilyNamePrefix>")
 do ..write(cr_"<MiddleName>"_$$$IN1InsuranceCoContactPersonSecondandFurtherGivenNamesor_"</MiddleName>")
 do ..write(cr_"<NamePrefix>"_$$$IN1InsuranceCoContactPersonPrefix_"</NamePrefix>")
 do ..write(cr_"<NameSuffix>"_$$$IN1InsuranceCoContactPersonSuffix_"</NameSuffix>")
 do ..write(cr_"<ProfessionalSuffix>"_$$$IN1InsuranceCoContactPersonProfessionalSuffix_"</ProfessionalSuffix>")
 do ..write(cr_"</ContactPerson>")	 
 #; IN1-7 : InsuranceCoPhoneNumber
 do ..PhonesAndEmail(s,7,.workphone,.workmobile,.workemail)
 do ..write(cr_"<ContactInfo>")
 do ..write(cr_"<WorkPhoneNumber>"_..xml($p(workphone,"^",1))_"</WorkPhoneNumber>")
 do ..write(cr_"<MobilePhoneNumber>"_..xml($p(workmobile,"^",1))_"</MobilePhoneNumber>")
 do ..write(cr_"<EmailAddress>"_..xml($p(workemail,"^",1))_"</EmailAddress>")
 do ..write(cr_"</ContactInfo>")

 do ..write(cr_"</HealthFund>")

 #; IN1-8 : GroupNumber
 do ..write(cr_"<GroupNumber>"_$$$IN1GroupNumber_"</GroupNumber>")

 #; IN1-9 : GroupName
 do ..write(cr_"<GroupName>"_$$$IN1GroupNameOrganizationName_"</GroupName>")

 #; IN1-12 : PlanEffectiveDate  (free text, we assume it is HL7Date)
 do ..write(cr_"<FromTime>"_..xmltimestamp($$$IN1PlanEffectiveDate)_"</FromTime>")

 #; IN1-13 : PlanExpirationDate
 do ..write(cr_"<ToTime>"_..xmltimestamp($$$IN1PlanExpirationDate)_"</ToTime>")

 #; IN1-15 : PlanType
 do ..write(cr_"<PlanType>"_$$$IN1PlanType_"</PlanType>")

 #; IN1-16 : NameOfInsured
 do ..write(cr_"<InsuredName>")	 
 do ..write(cr_"<GivenName>"_$$$IN1NameOfInsuredGivenName_"</GivenName>")
 do ..write(cr_"<FamilyName>"_$$$IN1NameOfInsuredFamilyNameSurname_"</FamilyName>")
 do ..write(cr_"<FamilyNamePrefix>"_$$$IN1NameOfInsuredFamilyNameOwnSurnamePrefix_"</FamilyNamePrefix>")
 do ..write(cr_"<MiddleName>"_$$$IN1NameOfInsuredSecondandFurtherGivenNamesor_"</MiddleName>")
 do ..write(cr_"<NamePrefix>"_$$$IN1NameOfInsuredPrefix_"</NamePrefix>")
 do ..write(cr_"<NameSuffix>"_$$$IN1NameOfInsuredSuffix_"</NameSuffix>")
 do ..write(cr_"<ProfessionalSuffix>"_$$$IN1NameOfInsuredProfessionalSuffix_"</ProfessionalSuffix>")
 do ..write(cr_"</InsuredName>")	 

 #; IN1-17 : InsuredsRelationshipToPatien
  if ($$$IN1InsuredsRelationshipToPatienIdentifier'="")||($$$IN1InsuredsRelationshipToPatienText'="") {
	do ..write(cr_"<InsuredRelationship>")
	do ..write(cr_"<SDACodingStandard>"_$$$IN1InsuredsRelationshipToPatienNameofCodingSystem_"</SDACodingStandard>")
	do ..write(cr_"<Code>"_$$$IN1InsuredsRelationshipToPatienIdentifier_"</Code>")
	do ..write(cr_"<Description>"_$$$IN1InsuredsRelationshipToPatienText_"</Description>")
 	do ..write(cr_"</InsuredRelationship>")
 }

 #; IN1-19 : InsuredsAddress
 do ..write(cr_"<InsuredAddress>")	 
 do ..write(cr_"<Street>")
 do ..write($$$IN1InsuredsAddressStreetAddressStreetorMailingAddress)
 if $$$IN1InsuredsAddressOtherDesignation'="" {
 	do ..write("; "_$$$IN1InsuredsAddressOtherDesignation)}
 do ..write("</Street>")
 if $$$IN1InsuredsAddressCity'="" {
	do ..write(cr_"<City>")
	do ..write(cr_"<Code>"_$$$IN1InsuredsAddressCity_"</Code>")
	do ..write(cr_"</City>")
 }
 if $$$IN1InsuredsAddressStateorProvince'="" {
	do ..write(cr_"<State>")
	do ..write(cr_"<Code>"_$$$IN1InsuredsAddressStateorProvince_"</Code>")
	do ..write(cr_"</State>")
 }
 if $$$IN1InsuredsAddressZiporPostalCode'="" {
	do ..write(cr_"<Zip>")
	do ..write(cr_"<Code>"_$$$IN1InsuredsAddressZiporPostalCode_"</Code>")
	do ..write(cr_"</Zip>")
 }
 if $$$IN1InsuredsAddressCountry'="" {
	do ..write(cr_"<Country>")
	do ..write(cr_"<Code>"_$$$IN1InsuredsAddressCountry_"</Code>")
	do ..write(cr_"</Country>")
 }
 if $$$IN1InsuredsAddressCountyParishCode'="" {
	do ..write(cr_"<County>")
	do ..write(cr_"<Code>"_$$$IN1InsuredsAddressCountyParishCode_"</Code>")
	do ..write(cr_"</County>")
 }
 do ..write(cr_"<FromTime>"_..xmltimestamp($$$IN1InsuredsAddressEffectiveDateTime)_"</FromTime>")
 do ..write(cr_"<ToTime>"_..xmltimestamp($$$IN1InsuredsAddressExpirationDateTime)_"</ToTime>")
 do ..write(cr_"</InsuredAddress>")
 
 #; IN1-22 : Coord of Ben. Priority
 do ..write(cr_"<Priority>"_$$$IN1CoordofBenPriority_"</Priority>")

 #; IN1-36 : PolicyNumber
 do ..write(cr_"<MembershipNumber>"_$$$IN1PolicyNumber_"</MembershipNumber>")

 do ..write(cr_"</HealthFund>")
}

ClassMethod IN2()
{
 $$$Find("IN2")
 #if $$$HSDebug
	do ##class(HS.Util.HSDebug).Debug("IN2","HS.Gateway.HL7.HL7ToSDA3","txt",s)
 #endif
}

ClassMethod IN3()
{
 $$$Find("IN3")
 #if $$$HSDebug
	do ##class(HS.Util.HSDebug).Debug("IN3","HS.Gateway.HL7.HL7ToSDA3","txt",s)
 #endif
}

ClassMethod MRG(mode As %String)
{
 $$$Find("MRG")
 #if $$$HSDebug
	do ##class(HS.Util.HSDebug).Debug("MRG","HS.Gateway.HL7.HL7ToSDA3","txt",s)
 #endif

 #; MRG-1 : PriorPatientIdentifierList	 
 if mode="patient" {	 
	if $$$MRGPriorPatientIdentifierList'="" { // check
		do ..start("MRGPAT",cr_"<PriorPatientNumbers>")
		set occ="" for {  // for each PriorPatientIdentifierList with AssigningAuthority <> ""
			set occ=$o($$$MRGPriorPatientIdentifierListAssigningAuthority) quit:occ=""	 
			do ..write(cr_"<PatientNumber>")
				do ..write(cr_"<Number>"_$$$MRGPriorPatientIdentifierListIDNumber_"</Number>")
				do ..write(cr_"<NumberType>"_..idtype($$$MRGPriorPatientIdentifierListIdentifierTypeCode)_"</NumberType>")
				do ..write(cr_"<Organization>")
				do ..write(cr_"<Code>"_$$$MRGPriorPatientIdentifierListAssigningAuthorityNamespaceID_"</Code>")
				do ..write(cr_"</Organization>")
			do ..write(cr_"</PatientNumber>")
		}
		do ..end("MRGPAT")
	}
 
 #; MRG-5 : PriorVisitNumber	 
 } else {  // mode="visit"
	if $$$MRGPriorVisitNumber'="" { // check
		do ..write(cr_"<PriorVisitNumber>"_$$$MRGPriorVisitNumber_"</PriorVisitNumber>")
	}
 }
}

ClassMethod MSH()
{
 $$$Find("MSH")
 #if $$$HSDebug
	set msgtype=$$$MSHMessageType
	do ##class(HS.Util.HSDebug).Debug("MSH","HS.Gateway.HL7.HL7ToSDA3","txt",s_" "_msgtype)
 #endif
}

ClassMethod NK1()
{
 $$$Find("NK1")
 #if $$$HSDebug
	do ##class(HS.Util.HSDebug).Debug("NK1","HS.Gateway.HL7.HL7ToSDA3","txt",s)
 #endif

 do ..start("NK1",cr_"<SupportContacts>")

 do ..write(cr_"<SupportContact>")

 #; NK1-1 : Set ID ("" means delete matching stored record, set ActionCode = "D" for delete)
 if ($$$NK1SetIDNK1="""""") {
 	do ..write(cr_"<ActionCode>D</ActionCode>")
 }
 
 #; NK1-2 : Name
 set %occ="" for {
	set %occ=$$$NK1Name(%occ) quit:%occ=""	 
	do ..write(cr_"<Name>")
	do ..write(cr_"<GivenName>"_$$$NK1NameGivenName(%occ)_"</GivenName>")
	do ..write(cr_"<FamilyName>"_$$$NK1NameFamilyNameSurname(%occ)_"</FamilyName>")
	do ..write(cr_"<FamilyNamePrefix>"_$$$NK1NameFamilyNameOwnSurnamePrefix(%occ)_"</FamilyNamePrefix>")
	do ..write(cr_"<MiddleName>"_$$$NK1NameSecondandFurtherGivenNamesor(%occ)_"</MiddleName>")
	do ..write(cr_"<NamePrefix>"_$$$NK1NamePrefix(%occ)_"</NamePrefix>")
	do ..write(cr_"<NameSuffix>"_$$$NK1NameSuffix(%occ)_"</NameSuffix>")
	do ..write(cr_"<ProfessionalSuffix>"_$$$NK1NameProfessionalSuffix(%occ)_"</ProfessionalSuffix>")
	do ..write(cr_"</Name>")
	quit  // only one
 }

 #; NK1-3 : Relationship
 if ($$$NK1RelationshipIdentifier'="")||
	 ($$$NK1RelationshipText'="") {
	do ..write(cr_"<Relationship>")
	do ..write(cr_"<SDACodingStandard>"_$$$NK1RelationshipNameofCodingSystem_"</SDACodingStandard>")
	do ..write(cr_"<Code>"_$$$NK1RelationshipIdentifier_"</Code>")
	do ..write(cr_"<Description>"_$$$NK1RelationshipText_"</Description>")
	do ..write(cr_"<CodeSystemVersionId>"_$$$NK1CodeVersion_"</CodeSystemVersionId>")
	if ($$$NK1AltRelationshipIdentifier'="")||($$$NK1AltRelationshipText'="") {
		do ..write(cr_"<PriorCodes>")
		do ..write(cr_"<PriorCode>")
		do ..write(cr_"<Code>"_$$$NK1AltRelationshipIdentifier_"</Code>")
		do ..write(cr_"<Description>"_$$$NK1AltRelationshipText_"</Description>")
		do ..write(cr_"<CodeSystem>"_$$$NK1AltRelationshipNameofCodingSystem_"</CodeSystem>")
		do ..write(cr_"<CodeSystemVersionId>"_$$$NK1AltCodeVersion_"</CodeSystemVersionId>")
		do ..write(cr_"<Type>A</Type>")
		do ..write(cr_"</PriorCode>")
		do ..write(cr_"</PriorCodes>")
	}
	
 	do ..write(cr_"</Relationship>")
 }

 #; NK1-4 : Address
 set %occ=""
 for {
	set %occ=$$$NK1Address(%occ) quit:%occ=""
	do ..write(cr_"<Address>")	 
	do ..write(cr_"<Street>")
	do ..write($$$NK1AddressStreetAddressStreetorMailingAddress(%occ))
	if $$$NK1AddressOtherDesignation(%occ)'="" {
		do ..write("; "_$$$NK1AddressOtherDesignation(%occ))}
	do ..write("</Street>")
	if $$$NK1AddressCity(%occ)'="" {
		do ..write(cr_"<City>")
		do ..write(cr_"<Code>"_$$$NK1AddressCity(%occ)_"</Code>")
		do ..write(cr_"</City>")
	}
	if $$$NK1AddressStateorProvince(%occ)'="" {
		do ..write(cr_"<State>")
		do ..write(cr_"<Code>"_$$$NK1AddressStateorProvince(%occ)_"</Code>")
		do ..write(cr_"</State>")
	}
	if $$$NK1AddressZiporPostalCode(%occ)'="" {
		do ..write(cr_"<Zip>")
		do ..write(cr_"<Code>"_$$$NK1AddressZiporPostalCode(%occ)_"</Code>")
		do ..write(cr_"</Zip>")
	}
	if $$$NK1AddressCountry(%occ)'="" {
		do ..write(cr_"<Country>")
		do ..write(cr_"<Code>"_$$$NK1AddressCountry(%occ)_"</Code>")
		do ..write(cr_"</Country>")
	}
	if $$$NK1AddressCountyParishCode(%occ)'="" {
		do ..write(cr_"<County>")
		do ..write(cr_"<Code>"_$$$NK1AddressCountyParishCode(%occ)_"</Code>")
		do ..write(cr_"</County>")
	}
	do ..write(cr_"<FromTime>"_..xmltimestamp($$$NK1AddressEffectiveDateTime(%occ))_"</FromTime>")
	do ..write(cr_"<ToTime>"_..xmltimestamp($$$NK1AddressExpirationDateTime(%occ))_"</ToTime>")
	do ..write(cr_"</Address>")	 
	quit  // only one
 }

 #; NK1-5 : PhoneNumber
 #; NK1-6 : BusinessPhoneNumber
 do ..PhonesAndEmail(s,5,.homephone,.homemobile,.homeemail)
 do ..PhonesAndEmail(s,6,.workphone,.workmobile,.workemail)
 set home=$p(homephone,"^",1),work=$p(workphone,"^",1)
 set mobile=$p(homemobile,"^",1) if mobile="" set mobile=$p(workmobile,"^",1)
 set email=$p(homeemail,"^",1) if email="" set email=$p(workemail,"^",1)
 do ..write(cr_"<ContactInfo>")
 do ..write(cr_"<HomePhoneNumber>"_..xml(home)_"</HomePhoneNumber>")
 do ..write(cr_"<WorkPhoneNumber>"_..xml(work)_"</WorkPhoneNumber>")
 do ..write(cr_"<MobilePhoneNumber>"_..xml(mobile)_"</MobilePhoneNumber>")
 do ..write(cr_"<EmailAddress>"_..xml(email)_"</EmailAddress>")
 do ..write(cr_"</ContactInfo>")
 kill home,mobile,email
 
 #; NK1-7 : ContactRole
 if ($$$NK1ContactRoleIdentifier'="")||
	 ($$$NK1ContactRoleText'="") {
	do ..write(cr_"<ContactType>")
	do ..write(cr_"<SDACodingStandard>"_$$$NK1ContactRoleNameofCodingSystem_"</SDACodingStandard>")
	do ..write(cr_"<Code>"_$$$NK1ContactRoleIdentifier_"</Code>")
	do ..write(cr_"<Description>"_$$$NK1ContactRoleText_"</Description>")
 	do ..write(cr_"</ContactType>")
 }
 
 #; NK1-8 : StartDate
 do ..write(cr_"<FromTime>"_..xmltimestamp($$$NK1StartDate)_"</FromTime>")
 #; NK1-9 : EndDate
 do ..write(cr_"<ToTime>"_..xmltimestamp($$$NK1EndDate)_"</ToTime>")
 
 do ..write(cr_"</SupportContact>")
 #; J2 - Added support for NK1-13, 30-32
 if ($$$NK1Organizations'=""){
	 do ..write(cr_"<SupportContact>")
	 set %occ=""
	 for {
		set %occ=$$$NK1Organization(%occ) quit:%occ=""
		 #; NK1-13 : Organization
		 do ..write(cr_"<EnteredAt>")
		 if ($$$NK1OrganizationNameIdentifier(%occ)=""){
		 	do ..write(cr_"<Code>"_$$$NK1OrganizationNameIDNumber(%occ)_"</Code>")
		 }else{
			 do ..write(cr_"<Code>"_$$$NK1OrganizationNameIdentifier(%occ)_"</Code>")
		 }
		 do ..write(cr_"<Description>"_$$$NK1OrganizationName(%occ)_"</Description>")
		 do ..write(cr_"<SDACodingStandard>"_$$$NK1OrganizationNameAssigningAuthority(%occ)_"</SDACodingStandard>")
		 do ..write(cr_"</EnteredAt>")	 
 		 quit  // only one
	 }

	 #; NK1-32 : Contact Persons Address
	 set %occ=""
	 for {
		set %occ=$$$NK1ContactAddress(%occ) quit:%occ=""
		do ..write(cr_"<Address>")	 
		do ..write(cr_"<Street>")
		do ..write($$$NK1ContactAddressStreetAddressStreetorMailingAddress(%occ))
		if $$$NK1ContactAddressOtherDesignation(%occ)'="" {
			do ..write("; "_$$$NK1ContactAddressOtherDesignation(%occ))}
		do ..write("</Street>")
		if $$$NK1ContactAddressCity(%occ)'="" {
			do ..write(cr_"<City>")
			do ..write(cr_"<Code>"_$$$NK1ContactAddressCity(%occ)_"</Code>")
			do ..write(cr_"</City>")
		}
		if $$$NK1ContactAddressStateorProvince(%occ)'="" {
			do ..write(cr_"<State>")
			do ..write(cr_"<Code>"_$$$NK1ContactAddressStateorProvince(%occ)_"</Code>")
			do ..write(cr_"</State>")
		}
		if $$$NK1ContactAddressZiporPostalCode(%occ)'="" {
			do ..write(cr_"<Zip>")
			do ..write(cr_"<Code>"_$$$NK1ContactAddressZiporPostalCode(%occ)_"</Code>")
			do ..write(cr_"</Zip>")
		}
		if $$$NK1ContactAddressCountry(%occ)'="" {
			do ..write(cr_"<Country>")
			do ..write(cr_"<Code>"_$$$NK1ContactAddressCountry(%occ)_"</Code>")
			do ..write(cr_"</Country>")
		}
		if $$$NK1ContactAddressCountyParishCode(%occ)'="" {
			do ..write(cr_"<County>")
			do ..write(cr_"<Code>"_$$$NK1ContactAddressCountyParishCode(%occ)_"</Code>")
			do ..write(cr_"</County>")
		}
		do ..write(cr_"<FromTime>"_..xmltimestamp($$$NK1ContactAddressEffectiveDateTime(%occ))_"</FromTime>")
		do ..write(cr_"<ToTime>"_..xmltimestamp($$$NK1ContactAddressExpirationDateTime(%occ))_"</ToTime>")
		do ..write(cr_"</Address>")	 
		quit  // only one
	 }
	 #; NK1-30 : Contact Persons Name
	 set %occ=""
	 set %occ="" for {
		set %occ=$$$NK1ContactName(%occ) quit:%occ=""	 
		do ..write(cr_"<Name>")
		do ..write(cr_"<GivenName>"_$$$NK1ContactNameGivenName(%occ)_"</GivenName>")
		do ..write(cr_"<FamilyName>"_$$$NK1ContactNameFamilyNameSurname(%occ)_"</FamilyName>")
		do ..write(cr_"<FamilyNamePrefix>"_$$$NK1ContactNameFamilyNameOwnSurnamePrefix(%occ)_"</FamilyNamePrefix>")
		do ..write(cr_"<MiddleName>"_$$$NK1ContactNameSecondandFurtherGivenNamesor(%occ)_"</MiddleName>")
		do ..write(cr_"<NamePrefix>"_$$$NK1ContactNamePrefix(%occ)_"</NamePrefix>")
		do ..write(cr_"<NameSuffix>"_$$$NK1ContactNameSuffix(%occ)_"</NameSuffix>")
		do ..write(cr_"<ProfessionalSuffix>"_$$$NK1ContactNameProfessionalSuffix(%occ)_"</ProfessionalSuffix>")
		do ..write(cr_"</Name>")
		quit  // only one
	 }
	 #; NK1-31 : Contact Persons Telephone
	 do ..PhonesAndEmail(s,31,.workphone,.workmobile,.workemail)
	 do ..write(cr_"<ContactInfo>")
	 do ..write(cr_"<WorkPhoneNumber>"_..xml($p(workphone,"^",1))_"</WorkPhoneNumber>")
	 do ..write(cr_"<MobilePhoneNumber>"_..xml($p(workmobile,"^",1))_"</MobilePhoneNumber>")
	 do ..write(cr_"<EmailAddress>"_..xml($p(workemail,"^",1))_"</EmailAddress>")
	 do ..write(cr_"</ContactInfo>")
	 kill workphone,workmobile,workemail
	 do ..write(cr_"</SupportContact>")
 }
}

ClassMethod NTE()
{
 #; NTE-3 : Comment

 #; output a <Comments> from a set of NTE comments (if any)
 do ..writecdata("Comments","NTE",3)
}

ClassMethod OBR(mode As %String)
{
 if mode="obs" {   // ORU OrderTypeIdentifier="OBS"
	$$$GetFollowing("OBR")
	#if $$$HSDebug
		do ##class(HS.Util.HSDebug).Debug("OBR(obs)","HS.Gateway.HL7.HL7ToSDA3","txt",s)
	#endif
	// ignore any OBR NTE's as we have no place to put them (the Comments
	// field in HS.SDA.Observation is used for the OBX NTE's)
	while $$$IsFollowing("NTE") {$$$GetFollowing("NTE")}
	quit
 }

 #; else mode="ord", "lab" or "txt"
 $$$Find("OBR")  // J2 How much will this break changing from GetFollowing to Find
 #if $$$HSDebug
	do ##class(HS.Util.HSDebug).Debug("OBR("_mode_")","HS.Gateway.HL7.HL7ToSDA3","txt",s)
 #endif

 #; OBR-2 : PlacerOrderNumber
 do ..write(cr_"<PlacerId>"_$$$OBRPlacerOrderNumberEntityIdentifier_"</PlacerId>")

 #; J2 -- add namespace and Universal ID
 Set pfs=$$$OBRPlacerOrderNumberNamespace_"^"_$$$OBRPlacerOrderNumberUniversalID_"^"_$$$OBRPlacerOrderNumberUniversalIDType
 do:pfs'="^^" ..write(cr_"<PlacerAssigningAuthority>"_pfs_"</PlacerAssigningAuthority>")

 #; OBR-3 : FillerOrderNumber
 do ..write(cr_"<FillerId>"_$$$OBRFillerOrderNumberEntityIdentifier_"</FillerId>")
 
 #; J2 -- add namespace and Universal ID
 Set pfs=$$$OBRFillerOrderNumberNamespace_"^"_$$$OBRFillerOrderNumberUniversalID_"^"_$$$OBRFillerOrderNumberUniversalIDType
 do:pfs'="^^" ..write(cr_"<FillerAssigningAuthority>"_pfs_"</FillerAssigningAuthority>")


 #; OBR-4 : UniversalServiceIdentifier
 if ($$$OBRUniversalServiceIdentifierIdentifier'="")||
    ($$$OBRUniversalServiceIdentifierText'="") {
	do ..write(cr_"<OrderItem>")
	do ..write(cr_"<SDACodingStandard>"_$$$OBRUniversalServiceIdentifierNameofCodingSystem_"</SDACodingStandard>")
	do ..write(cr_"<Code>"_$$$OBRUniversalServiceIdentifierIdentifier_"</Code>")
	do ..write(cr_"<Description>"_$$$OBRUniversalServiceIdentifierText_"</Description>")
	do ..write(cr_"<CodeSystemVersionId>"_$$$OBRUniversalServiceIdentifierCodeSystemVersionId_"</CodeSystemVersionId>")
	if ($$$OBRUniversalServiceIdentifierAltIdentifier'="")||($$$OBRUniversalServiceIdentifierAltText'="") {
		do ..write(cr_"<PriorCodes>")
		do ..write(cr_"<PriorCode>")
		do ..write(cr_"<Code>"_$$$OBRUniversalServiceIdentifierAltIdentifier_"</Code>")
		do ..write(cr_"<Description>"_$$$OBRUniversalServiceIdentifierAltText_"</Description>")
		do ..write(cr_"<CodeSystem>"_$$$OBRUniversalServiceIdentifierAltNameofCodingSystem_"</CodeSystem>")
		do ..write(cr_"<CodeSystemVersionId>"_$$$OBRUniversalServiceIdentifierAltCodeSystemVersionId_"</CodeSystemVersionId>")
		do ..write(cr_"<Type>A</Type>")
		do ..write(cr_"</PriorCode>")
		do ..write(cr_"</PriorCodes>")
	}
	if ($$$OBRUniversalServiceIdentifierOriginalText'="") {
		do ..write(cr_"<OriginalText>"_$$$OBRUniversalServiceIdentifierOriginalText_"</OriginalText>")
	}
	do ..write(cr_"</OrderItem>")
 }

 #; OBR-5 : PriorityOBR
 if $$$OBRPriorityOBR'="" {
	do ..write(cr_"<Priority>")
	do ..write(cr_"<Code>"_$$$OBRPriorityOBR_"</Code>")
	do ..write(cr_"</Priority>")
 }

 #; OBR-6 : RequestedDateTime  (see also ORC-7.4, OBR-27.4 and TQ1-7)
 do ..write(cr_"<FromTime>"_..xmltimestamp($$$OBRRequestedDateTimeTime)_"</FromTime>")

 #; OBR-7 : ObservationDateTime
 do ..write(cr_"<SpecimenCollectedTime>"_..xmltimestamp($$$OBRObservationDateTimeTime)_"</SpecimenCollectedTime>")

 #; OBR-11 : SpecimenActionCode
 #; Record here, then use it when processing any following SPM segments
 set specimenActionCode = $$$OBRSpecimenActionCode

 // J2 PJH
 #; OBR-13 - Relevent Clinicial Information
 do ..write(cr_"<ClinicalInformation>"_$$$OBRObservationClinicalInformation_"</ClinicalInformation>")

 #; OBR-14 : SpecimenReceivedDateTime
 do ..write(cr_"<SpecimenReceivedTime>"_..xmltimestamp($$$OBRSpecimenReceivedDateTimeTime)_"</SpecimenReceivedTime>")

 #; OBR-15 : SpecimenSource
 if $$$OBRSpecimenSourceSpecimenSourceNameorCodeText'="" {
	do ..write(cr_"<Specimen>"_$$$OBRSpecimenSourceSpecimenSourceNameorCodeText_"</Specimen>")
 } else {
	do ..write(cr_"<Specimen>"_$$$OBRSpecimenSourceSpecimenSourceNameorCodeIdentifier_"</Specimen>")
 }
 
 #; J2 PJH - Pass in Suffix
 #; OBR-16 : OrderingProvider  (see also ORC-12, RXO-14)
 set %occ="" for {
	set %occ=$$$OBROrderingProvider(%occ) quit:%occ=""
 	if $$$OBROrderingProviderIDNumber(%occ)'="" {
		do ..By("<OrderedBy>",,
			"CareProvider",
			$$$OBROrderingProviderAssigningAuthority(%occ),
			$$$OBROrderingProviderIDNumber(%occ),
			$$$OBROrderingProviderFamilyNameSurname(%occ),
			$$$OBROrderingProviderGivenName(%occ),
			$$$OBROrderingProviderMiddleName(%occ),
			$$$OBROrderingProviderNamePrefix(%occ),
			$$$OBROrderingProviderNameSuffix(%occ),
			$$$OBROrderingProviderNameProfessionalSuffix(%occ),
			$$$OBROrderingProviderNameTypeCode(%occ),
			$$$OBROrderingProviderIdentifierTypeCode(%occ))
		quit  // only one
 	}
 }

 #; OBR-17 : OrderCallbackPhoneNumber  (see also ORC-14)
 do ..PhonesAndEmail(s,17,.workphone,.workmobile,.workemail,.workfax)
 set callback=""
 set work=$tr(workphone,"^",",") if work'="" set callback=work
 set mobile=$tr(workmobile,"^",",")
 if mobile'="" {
	 if callback'="" set callback=callback_", "
	 set callback=callback_"Mobile: "_mobile}
 set fax=$tr(workfax,"^",",")
 if fax'="" {
	 if callback'="" set callback=callback_", "
	 set callback=callback_"Fax: "_fax}
 set email=$tr(workemail,"^",",")
 if email'="" {
	 if callback'="" set callback=callback_", "
	 set callback=callback_"email: "_email}
 do ..write(cr_"<CallbackNumber>"_..xml(callback)_"</CallbackNumber>")
 kill callback,work,mobile,email,fax
 
 #; OBR-22 : ResultsRptStatusChngDateTime
 set resulttime=$$$OBRResultsRptStatusChngDateTimeTime // See OBX
 #; OBR-24: DiagnosticServSectID - see OBR-4
 #; OrderCategory is being created as a code table rather than a string to make it more flexible if/when we
 #; want it as a proper code table in the SDA from non-HL7 sources.
 If $$$OBRDiagnosticServSectID'="" {
	do ..write(cr_"<OrderCategory>")
	do ..write(cr_"<Code>"_$zcvt($$$OBRDiagnosticServSectID,"U")_"</Code>")
	do ..write(cr_"</OrderCategory>")
 }
 #; OBR-25 : ResultStatus
 set resultstatus=$$$OBRResultStatus // See OBX
 
 #; J2
 #; OBR-26.1 : Parent Result Observation
 //ParentResultObservation
 do ..write(cr_"<ParentResultObservation>")
 do ..write(cr_"<Code>"_$$$OBRParentResultObservationIdentifierIdentifier_"</Code>")
 do ..write(cr_"<Description>"_$$$OBRParentResultObservationIdentifierText_"</Description>")
 do ..write(cr_"<SDACodingStandard>"_$$$OBRParentResultObservationIdentifierNameOfCodingSystem_"</SDACodingStandard>")
 If $$$OBRParentResultObservationIdentifierAltIdentifier'=""||($$$OBRParentResultObservationIdentifierAltText'="") {
	 do ..write(cr_"<PriorCodes>")
	 	do ..write(cr_"<PriorCode>")
			do ..write(cr_"<CodeSystem>"_$$$OBRParentResultObservationIdentifierAltNameOfCodingSystem_"</CodeSystem>")
			do ..write(cr_"<Code>"_$$$OBRParentResultObservationIdentifierAltIdentifier_"</Code>")
			do ..write(cr_"<Description>"_$$$OBRParentResultObservationIdentifierAltText_"</Description>")
			do ..write(cr_"<Type>A</Type>")
 		do ..write(cr_"</PriorCode>")
 	do ..write(cr_"</PriorCodes>")
 }
 do ..write(cr_"</ParentResultObservation>")
 
 #; J2
 #; OBR-26.2 : Parent Result Observation Sub Id
 //ParentResultObservationSubId
 do ..write(cr_"<ParentResultObservationSubId>"_$$$OBRParentResultObservationSubIdentifier_"</ParentResultObservationSubId>")
 #; J2
 #; OBR-26.3 : Parent Result Observation Text
 do ..write(cr_"<ParentResultObservationText>"_$$$OBRParentResultObservationValueDescription_"</ParentResultObservationText>")

 #; OBR-27 : QuantityTiming  (see also ORC-7, TQ1-2, -7, -8, -9, -10, -11, OBR-6)
 set %occ="" for {
	set %occ=$$$OBRQuantityTiming(%occ) quit:%occ=""
	 
	do ..write(cr_"<OrderQuantity>"_$$$OBRQuantityTimingQuantityQuantity(%occ)_"</OrderQuantity>")

	if $$$OBRQuantityTimingDuration(%occ)'="" {
		do ..write(cr_"<Duration>")
		do ..write(cr_"<Code>"_$$$OBRQuantityTimingDuration(%occ)_"</Code>")
		do ..write(cr_"</Duration>")
	}
	
	do ..write(cr_"<FromTime>"_..xmltimestamp($$$OBRQuantityTimingStartDateTimeTime(%occ))_"</FromTime>")
	do ..write(cr_"<ToTime>"_..xmltimestamp($$$OBRQuantityTimingEndDateTimeTime(%occ))_"</ToTime>")

	if $$$OBRQuantityTimingPriority(%occ)'="" {
		do ..write(cr_"<Priority>")
		do ..write(cr_"<Code>"_$$$OBRQuantityTimingPriority(%occ)_"</Code>")
		do ..write(cr_"</Priority>")
	}

	do ..write(cr_"<Condition>"_$$$OBRQuantityTimingCondition(%occ)_"</Condition>")
	do ..write(cr_"<TextInstruction>"_$$$OBRQuantityTimingText(%occ)_"</TextInstruction>")

 }
 #; J2 PJH Pass in Suffix
 #; OBR-28 : ResultCopiesTo
 set %occ=""
 If $$$OBRCopyProvider(%occ) {
	 Do ..write(cr_"<ResultCopiesTo>")
	 for {
		set %occ=$$$OBRCopyProvider(%occ) quit:%occ=""
	 	if $$$OBRCopyProviderIDNumber(%occ)'="" {
			do ..By("<CareProvider>",,
				"CareProvider",
				$$$OBRCopyProviderAssigningAuthority(%occ),
				$$$OBRCopyProviderIDNumber(%occ),
				$$$OBRCopyProviderFamilyNameSurname(%occ),
				$$$OBRCopyProviderGivenName(%occ),
				$$$OBRCopyProviderMiddleName(%occ),
				$$$OBRCopyProviderNamePrefix(%occ),
				$$$OBRCopyProviderNameSuffix(%occ))
	 	}
	 }
	 Do ..write(cr_"</ResultCopiesTo>")
 }
 
 #; J2
 #; OBR-29.1.1 ParentPlacerId
 do ..write(cr_"<ParentPlacerId>"_$$$OBRParentPlacerId_"</ParentPlacerId>")
 
 #; add namespace and Universal ID
 Set pfs=$$$OBRParentPlacerAssignedIdentifierNamespaceID_"^"_$$$OBRParentPlacerAssignedIdentifierUniversalID_"^"_$$$OBRParentPlacerAssignedIdentifierUniversalIDType
 do:pfs'="^^" ..write(cr_"<ParentPlacerAssigningAuthority>"_pfs_"</ParentPlacerAssigningAuthority>")

 #; J2
 #; OBR-29.2.1 ParentFillerId
 do ..write(cr_"<ParentFillerId>"_$$$OBRParentFillerId_"</ParentFillerId>")
 
 #; add namespace and Universal ID
 Set pfs=$$$OBRParentFillerAssignedIdentifierNamespaceID_"^"_$$$OBRParentFillerAssignedIdentifierUniversalID_"^"_$$$OBRParentFillerAssignedIdentifierUniversalIDType
 do:pfs'="^^" ..write(cr_"<ParentFillerAssigningAuthority>"_pfs_"</ParentFillerAssigningAuthority>")

 // J2 PJH Allow Reason for Study
 #; OBR-31 : ReasonForStudy
 
 If $$$OBRReasonForStudy'="" {
	Do ..write(cr_"<ReasonForStudy>")
		do ..write(cr_"<Code>"_$$$OBRReasonForStudyIdentifier_"</Code>")
		do ..write(cr_"<Description>"_$$$OBRReasonForStudyDescription_"</Description>")
		do ..write(cr_"<SDACodingStandard>"_$$$OBRReasonForStudyNameofCodingSystem_"</SDACodingStandard>")
		do ..write(cr_"<CodeSystemVersionId>"_$$$OBRReasonForStudyCodeSystemVersionId_"</CodeSystemVersionId>")
		if $$$OBRReasonForStudyAltIdentifier'=""||($$$OBRReasonForStudyAltText'="") {
			do ..write(cr_"<PriorCodes>")
			do ..write(cr_"<PriorCode>")
			do ..write(cr_"<Code>"_$$$OBRReasonForStudyAltIdentifier_"</Code>")
			do ..write(cr_"<Description>"_$$$OBRReasonForStudyAltText_"</Description>")
			do ..write(cr_"<CodeSystem>"_$$$OBRReasonForStudyAltNameofCodingSystem_"</CodeSystem>")
			do ..write(cr_"<CodeSystemVersionId>"_$$$OBRReasonForStudyAltCodeSystemVersionId_"</CodeSystemVersionId>")
			do ..write(cr_"<Type>A</Type>")
			do ..write(cr_"</PriorCode>")
			do ..write(cr_"</PriorCodes>")
		}
	 Do ..write(cr_"</ReasonForStudy>")
 }
 
  // J2 PJH - Populate Verified By
 #; OBR-32 - Principal Intepreter
 do ..By("<VerifiedBy>",,
	"ResultsInterpreter",
	$$$OBRPrincipalResultsAssigningAuthNamespaceID,
	$$$OBRPrincipalResultsInterpreterIDNumber,
	$$$OBRPrincipalResultsInterpreterFamilyNameSurname,
	$$$OBRPrincipalResultsInterpreterGivenName,
	$$$OBRPrincipalResultsInterpreterMiddleName,
	$$$OBRPrincipalResultsInterpreterNamePrefix,
	$$$OBRPrincipalResultsInterpreterNameSuffix,
	$$$OBRPrincipalResultsInterpreterNameProfessionalSuffix
 )
}

ClassMethod OBX(mode As %String, pReplace As %String = "")
{
 // J2 PJh Allow spm
 if ((mode="obs")||(mode="vxu")) {

	$$$Find("OBX")
	#if $$$HSDebug
		do ##class(HS.Util.HSDebug).Debug("OBX("_mode_")","HS.Gateway.HL7.HL7ToSDA3","txt",s)
	#endif
	
	// J2 PJH - call VXU Observations VXUObservations
	If mode="vxu" {
		do ..start("OBX",cr_"<VXUObservations>")
	} Else {
		do ..start("OBX",cr_"<Observations>")
	}
	do ..write(cr_"<Observation>")
	Do ..OnObservation()
	do ..write(cr_"<EncounterNumber>"_encNum_"</EncounterNumber>")

	#; OBX-3 : ObservationIdentifier
	if $$$OBXObservationIdentifierIdentifier(s)'="" { 	 
		do ..write(cr_"<ObservationCode>")
		do ..write(cr_"<SDACodingStandard>"_$$$OBXObservationIdentifierNameofCodingSystem(s)_"</SDACodingStandard>")
		do ..write(cr_"<Code>"_$$$OBXObservationIdentifierIdentifier(s)_"</Code>")
		do ..write(cr_"<Description>"_$$$OBXObservationIdentifierText(s)_"</Description>")
	#; OBX-6 : Units
		if ($$$OBXUnitsIdentifier'="") {
			do ..write(cr_"<ObservationValueUnits>")
			do ..write(cr_"<SDACodingStandard>"_$$$OBXUnitsNameofCodingSystem_"</SDACodingStandard>")
			do ..write(cr_"<Code>"_$$$OBXUnitsIdentifier_"</Code>")
			do ..write(cr_"<Description>"_$$$OBXUnitsText_"</Description>")
			do ..write(cr_"</ObservationValueUnits>")
		}		
		do ..write(cr_"</ObservationCode>")
	}

	#; OBX-5 : ObservationValue
	#; J2 Add mode for VXU so all observation parameters come across
	set type=$$$OBXValueType
	do ..write(cr_"<ObservationValueType>"_type_"</ObservationValueType>")
	#;Check for compatability flag -- if set process as usual
	#;Only have compatability mode for obs as vxu and spm are new and
	#;do not have compatability issues
	If ((obxmode)&&(mode="obs")){
		set (%occ,value)="" for {
			set %occ=$$$OBXObservation(%occ) quit:%occ=""
			if value'="" set value=value_", "
			set value=value_$$$OBXObservationValue(%occ)
		}
		do ..write(cr_"<ObservationValue>"_value_"</ObservationValue>")
		kill value
	}Else{ //Otherwise add coded observation values
		if ("CE,CWE,CNE,"[type) {
			do ..write(cr_"<ObservationCodedValue>")
			do ..write("<Code>"_$$$OBXObservationValues_"</Code>")
			do ..write("<Description>"_$$$OBXObservationText_"</Description>")
			do ..write("<SDACodingStandard>"_$$$OBXObservationValueEDDataSubType_"</SDACodingStandard>")
			// J2 PJH, Make conditional
			If $$$OBXObservationValueEDEncoding'=""||($$$OBXObservationValueEDData'="") {
				do ..write(cr_"<PriorCodes>")
				do ..write(cr_"<PriorCode>")
				do ..write(cr_"<Code>"_$$$OBXObservationValueEDEncoding_"</Code>")
				do ..write(cr_"<Description>"_$$$OBXObservationValueEDData_"</Description>")
				do ..write(cr_"<CodeSystem>"_$$$OBXObservationValueAltCodeSystem_"</CodeSystem>")
				do ..write(cr_"<CodeSystemVersionId>"_$$$OBXObservationValueAltCodeSystemVersion_"</CodeSystemVersionId>")
				do ..write(cr_"<Type>A</Type>")
				do ..write(cr_"</PriorCode>")
				do ..write(cr_"</PriorCodes>")
			}
			do ..write("<CodeSystemVersionId>"_$$$OBXObservationValueCodeSystemVersion_"</CodeSystemVersionId>")
			do ..write("<OriginalText>"_$$$OBXObservationValueOriginalText_"</OriginalText>")
			do ..write(cr_"</ObservationCodedValue>")
			#; Now set original Observation Value with reasonable string display
			if ($$$OBXObservationText'=""){
				do ..write(cr_"<ObservationValue>"_$$$OBXObservationText_"</ObservationValue>")
			}else{
				do ..write(cr_"<ObservationValue>"_$$$OBXObservationValueOriginalText_"</ObservationValue>")
			}
		}elseif ("TS,DT"[type) {
			do ..write(cr_"<ObservationValueTime>"_..xmltimestamp($$$OBXObservationValues)_"</ObservationValueTime>")
			#; Now set original Observation Value with reasonable string display
			do ..write(cr_"<ObservationValue>"_$Piece(..xmltimestamp($$$OBXObservationValues),"T")_" "_$Piece(..xmltimestamp($$$OBXObservationValues),"T",2)_"</ObservationValue>")
		}elseif ("SN"=type) {
			do ..write(cr_"<ObservationValue>"_$$$OBXObservationValueComparator_$$$OBXObservationValueNum1_$$$OBXObservationValueSeparatorSuffix_$$$OBXObservationValueNum2_"</ObservationValue>")
		}Else{ // If not a coded value just do the normal processing
			set (%occ,value)="" for {
				set %occ=$$$OBXObservation(%occ) quit:%occ=""
				if value'="" set value=value_", "
				set value=value_$$$OBXObservationValue(%occ)
			}
			do ..write(cr_"<ObservationValue>"_value_"</ObservationValue>")
			kill value
		}
	}

	#; OBX-14 : DateTimeoftheObservation
	do ..write(cr_"<ObservationTime>"_..xmltimestamp($$$OBXDateTimeoftheObservationTime)_"</ObservationTime>")
	
	#; J2
	#; OBX-17 : Observation Method
	do ..write(cr_"<ObservationMethods>")
	set %occ="" for {
		set %occ=$$$OBXObservationMethod(%occ) quit:%occ=""
		do ..write(cr_"<ObservationMethod>")
		do ..write(cr_"<Code>"_$$$OBXObservationMethodCodeIdentifier(%occ)_"</Code>")
		do ..write(cr_"<Description>"_$$$OBXObservationMethodCodeText(%occ)_"</Description>")
		do ..write(cr_"<SDACodingStandard>"_$$$OBXObservationMethodCodeNameofCodingSystem(%occ)_"</SDACodingStandard>")
		do ..write(cr_"<CodeSystemVersionId>"_$$$OBXObservationMethodCodeCodeSystemVersionId(%occ)_"</CodeSystemVersionId>")
		If ($$$OBXObservationMethodCodeAltIdentifer(%occ)'="")||($$$OBXObservationMethodCodeAltText(%occ)'="") {
			do ..write(cr_"<PriorCodes>")
				do ..write(cr_"<PriorCode>")
					do ..write(cr_"<Code>"_$$$OBXObservationMethodCodeAltIdentifer(%occ)_"</Code>")
					do ..write(cr_"<Description>"_$$$OBXObservationMethodCodeAltText(%occ)_"</Description>")
					do ..write(cr_"<CodeSystem>"_$$$OBXObservationMethodCodeAltNameofCodingSystem(%occ)_"</CodeSystem>")
					do ..write(cr_"<CodeSystemVersionId>"_$$$OBXObservationMethodCodeAltCodeSystemVersionId(%occ)_"</CodeSystemVersionId>")
					do ..write(cr_"<Type>A</Type>")
				do ..write(cr_"</PriorCode>")
			do ..write(cr_"</PriorCodes>")
		}
		do ..write(cr_"</ObservationMethod>")
	}
	do ..write(cr_"</ObservationMethods>")

	// J2 PJH - Add in Observation Sub ID for vxu OBX sorting
	#; OBX-4 : Observation Sub-ID
	If mode="vxu" {
		do ..write(cr_"<GroupId>"_$$$OBXObservationSubID_"</GroupId>")
	}


	do ..NTE()
	do ..write(cr_"</Observation>")
	quit
 }

 if mode="mdm"||(mode="txt") {  // MDM Document or Text Result 

	set saves=s
	
	// Get first OBX
	$$$GetFollowing("OBX")  // will quit if none

	if mode="txt" {
		#; OBX-15 : ProducersID
		#; OBX-25 Performing Organization Medical Director 
		Do ..writePerformedAt()
			
		#; OBX-8 : Abnormal Flags
		#; If any OBX-8 = A, flag the whole result as abnormal.
		for {
			set %occ="" for {
				set %occ=$$$OBXAbnormalFlag(%occ) quit:%occ=""
				if $$$OBXAbnormalFlags(%occ)="A" {
					do ..write(cr_"<ResultInterpretation>A</ResultInterpretation>")
					quit	
				}
			}
			$$$GetFollowing("OBX")
		}
		set s=saves+1
		
	}
		
	// If RP then URL
	// If ED then encapsulated document with type in OBX-5.3
	// If OBX-5 is {\rtf... then encapsulated document with type "RTF"
	// Else plain text NoteText 
	
	#; OBX-2 : ValueType  if RP then OBX-5.1 = URL
	#; Text Results will use a DocumentURL if the first OBX has ValueType of RP.
	#; Otherwise the content is included in the text result.
	set type=$$$OBXValueType
 	if type="RP" {
		do ..write(cr_"<DocumentURL>"_$$$xml(..unescape($$$OBXObservationValues))_"</DocumentURL>")
		#; Continue if there is further OBX segments to be processed.
		if '$$$IsFollowing("OBX") quit
		#; Do not include the RP ValueType OBX in the text
		set saves=s
	}

 	#; OBX-5.3 : ObservationValueEDDataSubType
 	if type="ED" {	
	 	// filetype should be upper case only
		set filetype=$$$OBXObservationValueEDDataSubType
 	} elseif $Extract($$$OBXObservationValues,1,5)="{\rtf" {
		set filetype="RTF"
	} else {  // Assumed plain text
		set s=saves
		set tag=$s(mode="mdm":"NoteText",1:"ResultText")
		do ..writecdata(tag,"OBX",5,"NTE",3)
		quit
	}
	
	// filetype should always be uppercase
	Set filetype=$ZCVT(filetype,"U")
	
	// Encapsulated document
	do ..write(cr_"<FileType>"_filetype_"</FileType>")
	kill filetype

	#; OBX-5.4 : ObservationValueEDEncoding
	set encoding=$$$OBXObservationValueEDEncoding
	
	#; OBX-5.1 : ObservationValues
	#; NTE-3 : Comments
	// Make text out of this (and following) OBX's and NTE's
	set text=..gettext("OBX",5,"NTE",3) if text="" quit

	// If the data is not already Base64 encoded, then encode it.
	if $zcvt(encoding,"U")'="BASE64" {
		set text = $system.Encryption.Base64Encode(text)
	}

	do ..write(cr_"<Stream>"_text_"</Stream>")
	kill text

	quit
 }
 if (mode="lab") {
	#; Handles stream of OBX's (perhaps with NTE's) for one ORC/OBR
	#; Each OBX is    OBX||type|identifier||result...
	#; Each <LabResultItem> has a <TestItemCode> followed by a single <ResultValue> with
	#;  a) block of FT's (with the same identifier)
	#;  b) block of TX's (with the same identifier)
	#;  c) single item
	#; followed by units, ranges and interpretation and an optional NTE

	#; Save where we are in the list of segments as want to loop through them twice
	set saves=s
	kill TestItem,TestItemUsed
	while $$$IsFollowing("OBX") {
		$$$GetFollowing("OBX")
		#; Setup Array for speed to identify when same TestCode is used more than once.
		#; Used when we tag the SubID on it to ensure don't lose data
		#; If there is no SubID then we need to use something else otherwise will lose data
		set obsid=$$$OBXObservationIdentifierIdentifier(s)
		if obsid'="" set TestItem(obsid)=$g(TestItem(obsid))+1
		#; Beware there can be NTEs mixed in with the OBXs, so skip them
		while $$$IsFollowing("NTE") { $$$GetFollowing("NTE")}
	}
	set s=saves

	while $$$IsFollowing("OBX") {
		$$$GetFollowing("OBX")
		#if $$$HSDebug
			do ##class(HS.Util.HSDebug).Debug("OBX(lab)","HS.Gateway.HL7.HL7ToSDA3","txt",s)
		#endif

		#; Log and ignore if no Item
		set obsid=$$$OBXObservationIdentifierIdentifier(s)
 		if obsid="" {
	 		$$$LOGALERT("Segment "_s_" has no ObservationIdentifier. Ignored.") 
			while $$$IsFollowing("NTE") { $$$GetFollowing("NTE")}  // Skip any NTE(s)
			continue
 		}

		#; Start new group
		do ..write(cr_"<LabResultItem>")
		#; OBX-8 : AbnormalFlags
		#; AW This is out of sequence to deal with special cases of AntiBiotic Resistance
		#; it is needed to process OBX-3
		set (%occ,flags)="" for {
			set %occ=$$$OBXAbnormalFlag(%occ) quit:%occ=""
			if $$$OBXAbnormalFlags(%occ)'="" {
				if flags'="" set flags=flags_", "
				set flags=flags_$$$OBXAbnormalFlags(%occ)	
			}
		}
		do ..write(cr_"<ResultInterpretation>"_flags_"</ResultInterpretation>")
		
		#; OBX-2 : ValueType
		set type=$$$OBXValueType

		#; OBX-3 : ObservationIdentifier
		do ..write(cr_"<TestItemCode>")
		do ..write(cr_"<SDACodingStandard>"_$$$OBXObservationIdentifierNameofCodingSystem(s)_"</SDACodingStandard>")
		do ..write(cr_"<CodeSystemVersionId>"_$$$OBXObservationIdentifieCodeSystemVersionId(s)_"</CodeSystemVersionId>")
		
		set codeChanged=0
		if (type="NM") {
			do ..write(cr_"<Code>"_$$$OBXObservationIdentifierIdentifier(s)_"</Code>")
			do ..write(cr_"<Description>"_$$$OBXObservationIdentifierText(s)_"</Description>")
			do ..write(cr_"<IsNumeric>true</IsNumeric>")
		}
		elseif (type="CE")&&("/S/R/I/MS/VS/"'[("/"_flags_"/")) {  // ^pp this code does not work with > 1 flag
			// Be careful here, we only want to tag on the SubId if there are duplicates for this TestItem
			// Also, sometimes the SubID is blank and in those cases we don't want to loose rows of data.
			// Also only want to tag on the SubIdfor the 2nd and subsequent use of it
			// If replace action, always use the code, no sub-id
			//
			// We keep the identifier if any of the following are true 
			// 1) We are not configued to change duplicate identifiers
			// 2) There are no duplicates for this TestItem
			// 3) We are looking at the first use of this test id
			// 4) replace action
			If (
					(keepDuplicateOBXIdentifiers)
				 	|| (TestItem($$$OBXObservationIdentifierIdentifier(s))=1)
					|| ('$d(TestItemUsed($$$OBXObservationIdentifierIdentifier(s))))
					|| pReplace
				) {
				do ..write(cr_"<Code>"_$$$OBXObservationIdentifierIdentifier(s)_"</Code>")
				Set TestItemUsed($$$OBXObservationIdentifierIdentifier(s))=1
				}
			ElseIf $$$OBXObservationSubID'="" {do ..write(cr_"<Code>"_$$$OBXObservationIdentifierIdentifier(s)_$$$OBXObservationSubID_"</Code>") set codeChanged=1}
			Else {do ..write(cr_"<Code>"_$$$OBXObservationIdentifierIdentifier(s)_s_"</Code>") set codeChanged=1}
			do ..write(cr_"<Description>"_$$$OBXObservationIdentifierText(s)_"</Description>")
		}
		elseif (type="ST") {
			// We keep the identifier if any of the following are true 
			// 1) We are not configued to change duplicate identifiers
			// 2) There are no duplicates for this TestItem
			// 3) We are looking at the first use of this test id
			// 4) replace action
			If (
					(keepDuplicateOBXIdentifiers)
				 	|| (TestItem($$$OBXObservationIdentifierIdentifier(s))=1)
					|| ('$d(TestItemUsed($$$OBXObservationIdentifierIdentifier(s))))
					|| pReplace
				) {
				do ..write(cr_"<Code>"_$$$OBXObservationIdentifierIdentifier(s)_"</Code>")
				if TestItem($$$OBXObservationIdentifierIdentifier(s)) '= 1&&'pReplace {
					if $d(TestItemUsed($$$OBXObservationIdentifierIdentifier(s))) {
						If $$$OBXObservationSubID = "" {
							// Note: This catches a common case of missing sub ids.
							// To correctly warn of all cases of duplicate records we should
							// - scan the OBXs, keeping track of Code, SDACodingStandard, and SubId
							// - determine if there are any that would be consolidated in the streamlet class
							// - only log the warning in that case.
							$$$LOGWARNING("Duplicate OBX record "_$$$OBXObservationIdentifierIdentifier(s)_"(line "_s_") missing SubId, may be lost during deduplication")
						}
					} 
					else {
						Set TestItemUsed($$$OBXObservationIdentifierIdentifier(s)) = 1
					}
				}
			}
			Else {
				set codeChanged=1
				// Sometimes the SubID is blank and in those cases we don't want to lose rows of data.
				If $$$OBXObservationSubID'="" {
					do ..write(cr_"<Code>"_$$$OBXObservationIdentifierIdentifier(s)_$$$OBXObservationSubID_"</Code>") 
				}
				Else {
					do ..write(cr_"<Code>"_$$$OBXObservationIdentifierIdentifier(s)_s_"</Code>") 
				}
			}
			do ..write(cr_"<Description>"_$$$OBXObservationIdentifierText(s)_"</Description>")
			do ..write(cr_"<IsNumeric>true</IsNumeric>")
		}		
		else {
			// check if there are  notes/text for the same Test
			// Addendum: only do this if compatibility mode is on
			set identifier=$$$OBXObservationIdentifierIdentifier(s)_"^"_$$$OBXObservationIdentifierText(s)
			Set previdentifier="" If s>1 Set previdentifier=$$$OBXObservationIdentifierIdentifier(s-1)_"^"_$$$OBXObservationIdentifierText(s-1)
			If (previdentifier=identifier)&&(obxmode) {
				do ..write(cr_"<Code>"_$$$OBXObservationIdentifierIdentifier(s)_" Notes</Code>" )
				set codeChanged=1
				do ..write(cr_"<Description>"_$$$OBXObservationIdentifierText(s)_" Notes</Description>")
			}
			Else {
				do ..write(cr_"<Code>"_$$$OBXObservationIdentifierIdentifier(s)_"</Code>")
				do ..write(cr_"<Description>"_$$$OBXObservationIdentifierText(s)_"</Description>")
			}
		}
		//Only parse the alternate code/desc/CS and OriginalText if we did NOT change the code of the primary
		if 'codeChanged {
			if ($$$OBXObservationIdentifierAltIdentifier(s)'="")||($$$OBXObservationIdentifierAltText(s)'="") {
				do ..write(cr_"<PriorCodes>")
				do ..write(cr_"<PriorCode>")
				do ..write(cr_"<CodeSystem>"_$$$OBXObservationIdentifierAltNameofCodingSystem(s)_"</CodeSystem>")
				do ..write(cr_"<Code>"_$$$OBXObservationIdentifierAltIdentifier(s)_"</Code>")
				do ..write(cr_"<Description>"_$$$OBXObservationIdentifierAltText(s)_"</Description>")
				do ..write(cr_"<CodeSystemVersionId>"_$$$OBXObservationIdentifierAltCodeSystemVersionId(s)_"</CodeSystemVersionId>")
				do ..write(cr_"<Type>A</Type>")
				do ..write(cr_"</PriorCode>")
				do ..write(cr_"</PriorCodes>")
			}
			if ($$$OBXObservationIdentifierOriginalText(s)'="") {
				do ..write(cr_"<OriginalText>"_$$$OBXObservationIdentifierOriginalText(s)_"</OriginalText>")
			}
		}
		do ..write(cr_"</TestItemCode>")
		kill flags

		#; OBX-4 : SubId
		do ..write(cr_"<SubId>"_$$$OBXObservationSubID_"</SubId>")

		#; OBX-5 : ObservationValue
		do ..write(cr_"<ResultValue>")
		set identifier=$$$OBXObservationIdentifierIdentifier(s)_"^"_$$$OBXObservationIdentifierText(s)
		if "TX,FT"[type {  // Text or Formatted Text
			do ..write("<![CDATA[")
			for {
				set %occ="" for {
					set %occ=$$$OBXObservation(%occ) quit:%occ=""
					do ..write(..unescape($$$OBXObservationValueNoCVT(%occ))_cr)
				}
				if '$$$IsFollowing("OBX") quit
				if ($$$OBXObservationIdentifierIdentifier(s+1)_"^"_$$$OBXObservationIdentifierText(s+1))'=identifier quit
				$$$GetFollowing("OBX")
			}
			do ..write("]]>")
		} 
		// special handling for CE, CNE, CWE, and SN, but only if not in compatibility mode
		elseif ('obxmode)&&(",CE,CNE,CWE,SN,"[type) {
			if type="SN" { do ..write($$$OBXObservationValueComparator_$$$OBXObservationValueNum1_$$$OBXObservationValueSeparatorSuffix_$$$OBXObservationValueNum2) }
			else { do ..write($$$OBXObservationText) }
		}
		else {  // Single fields, possibly repeating
			set %occ="" for {
				set %occ=$$$OBXObservation(%occ) quit:%occ=""
				if type="DT" { // Date
					do ..write(..xmltimestamp($$$OBXObservationValue(%occ)))
				} else { // Other
					do ..write($$$OBXObservationValue(%occ))
				}
				quit  // only one
			}
		}
		do ..write("</ResultValue>")
		
		#; J2 Added coded versions of results
		#; Does not change how ResultValue is set in any way
		do ..write("<ObservationValueType>"_type_"</ObservationValueType>")
		if ("CE,CWE,CNE"[type&&($$$OBXObservationValueEDDataSubType'="")) {
			do ..write(cr_"<ResultCodedValue>")
			do ..write(cr_"<Code>"_$$$xml($$$OBXObservationValues)_"</Code>")
			do ..write(cr_"<Description>"_$$$OBXObservationText_"</Description>")
			do ..write(cr_"<SDACodingStandard>"_$$$OBXObservationValueEDDataSubType_"</SDACodingStandard>")
			If ($$$OBXObservationValueEDEncoding'="")||($$$OBXObservationValueEDData'="") {
				do ..write(cr_"<PriorCodes>")
				do ..write(cr_"<PriorCode>")
				do ..write(cr_"<Code>"_$$$OBXObservationValueEDEncoding_"</Code>")
				do ..write(cr_"<Description>"_$$$OBXObservationValueEDData_"</Description>")
				do ..write(cr_"<CodeSystem>"_$$$OBXObservationValueAltCodeSystem_"</CodeSystem>")
				do ..write(cr_"<CodeSystemVersionId>"_$$$OBXObservationValueAltCodeSystemVersion_"</CodeSystemVersionId>")
				do ..write(cr_"<Type>A</Type>")
				do ..write(cr_"</PriorCode>")
				do ..write(cr_"</PriorCodes>")
			}
			do ..write("<CodeSystemVersionId>"_$$$OBXObservationValueCodeSystemVersion_"</CodeSystemVersionId>")
			do ..write("<OriginalText>"_$$$OBXObservationValueOriginalText_"</OriginalText>")
			do ..write(cr_"</ResultCodedValue>")
		}
		

		#; OBX-6 : Units
		do ..write(cr_"<ResultValueUnits>"_$$$OBXUnitsIdentifier_"</ResultValueUnits>")

		#; OBX-7 : ReferencesRange
		do ..write(cr_"<ResultNormalRange>"_$$$OBXReferencesRange_"</ResultNormalRange>")

		#; OBX-11 : ObservationResultStatus
		// if they send C, change it to K to avoid pipeline work
		set itemstatus=$$$OBXObservationResultStatus
		if itemstatus="C" set itemstatus="K"
		do ..write(cr_"<TestItemStatus>"_itemstatus_"</TestItemStatus>")
		kill itemstatus
		
		#; OBX-14 : DateTimeoftheObservation
		do ..write(cr_"<ObservationTime>"_..xmltimestamp($$$OBXDateTimeoftheObservationTime)_"</ObservationTime>")
		
		#; OBX-15 : ProducersID - Must match OBX-23 if present
		#; OBX-25 Performing Organization Medical Director 
		do ..writePerformedAt()
		
		#; J2 PJH Additional ","
		#; OBX-16 : ResponsibleObserver
		set %occ="" for {
			set %occ=$$$OBXResponsibleObserver(%occ) quit:%occ=""
			do ..By("<EnteredBy>",,"User",
				$$$OBXResponsibleObserverAssigningAuthority(%occ),
				$$$OBXResponsibleObserverIDNumber(%occ),
				$$$OBXResponsibleObserverFamilyNameSurname(%occ),
				$$$OBXResponsibleObserverGivenName(%occ))
			quit  // only one
		}
		// J2
		#; OBX-17 : Observation Methods
		do ..write(cr_"<ObservationMethods>")
		set %occ="" for {
			set %occ=$$$OBXObservationMethod(%occ) quit:%occ=""
			do ..write(cr_"<ObservationMethod>")
			do ..write(cr_"<Code>"_$$$OBXObservationMethodCodeIdentifier(%occ)_"</Code>")
			do ..write(cr_"<Description>"_$$$OBXObservationMethodCodeText(%occ)_"</Description>")
			do ..write(cr_"<SDACodingStandard>"_$$$OBXObservationMethodCodeNameofCodingSystem(%occ)_"</SDACodingStandard>")
			do ..write(cr_"<CodeSystemVersionId>"_$$$OBXObservationMethodCodeCodeSystemVersionId(%occ)_"</CodeSystemVersionId>")
			if (($$$OBXObservationMethodCodeAltIdentifer(%occ)'="")||($$$OBXObservationMethodCodeAltText(%occ)'="")){
				do ..write(cr_"<PriorCodes>")
				do ..write(cr_"<PriorCode>")
				do ..write(cr_"<Code>"_$$$OBXObservationMethodCodeAltIdentifer(%occ)_"</Code>")
				do ..write(cr_"<Description>"_$$$OBXObservationMethodCodeAltText(%occ)_"</Description>")
				do ..write(cr_"<CodeSystem>"_$$$OBXObservationMethodCodeAltNameofCodingSystem(%occ)_"</CodeSystem>")
				do ..write(cr_"<CodeSystemVersionId>"_$$$OBXObservationMethodCodeAltCodeSystemVersionId(%occ)_"</CodeSystemVersionId>")
				do ..write(cr_"<Type>A</Type>")
				do ..write(cr_"</PriorCode>")
				do ..write(cr_"</PriorCodes>")
			}
			do ..write(cr_"</ObservationMethod>")
		}
		do ..write(cr_"</ObservationMethods>")
		// J2 PJH
		#; OBX-19
		do ..write(cr_"<AnalysisTime>"_..xmltimestamp($$$OBXDateTimeoftheAnalysisTime)_"</AnalysisTime>")


		if $$$IsFollowing("NTE") do ..NTE()
		
		// Deal with the cases for NM where they send the same Code 
		// with a different ValueType and different SubId to mean a comment	
		// s is being saved while we look at the following segment details before setting it back.	
		If ($$$OBXValueType="NM")&&($$$IsFollowing("OBX"))&&($$$OBXObservationSubID'="") {
			Set saves=s, prevcode=$$$OBXObservationIdentifierIdentifier(s), prevsubid=$$$OBXObservationSubID
			$$$GetFollowing("OBX")
			If (prevcode=$$$OBXObservationIdentifierIdentifier(s))&&(prevsubid'=$$$OBXObservationSubID){			
				// The line below is deliberate, because Studio is getting confused saving xml and 
				// changing the text, nasty but hacks around problem
				do ..write(cr_"<Comments><![CD"_"ATA[")
				for {
					set %occ="" for {
						set %occ=$$$OBXObservation(%occ) quit:%occ=""
						do ..write(..unescape($$$OBXObservationValueNoCVT(%occ))_cr)
					}
					if '$$$IsFollowing("OBX") quit
					if ($$$OBXObservationIdentifierIdentifier(s+1)_"^"_$$$OBXObservationIdentifierText(s+1))'=identifier quit
					$$$GetFollowing("OBX")
				}
				// next check it is not a nasty mix with NTEs at the end
				// if it is then append them to the comments.
				if $$$IsFollowing("NTE") {
					$$$GetFollowing("NTE") 
					set text=..gettext("NTE",3)
					do ..write(text)
				}
				// The line below is deliberate, because Studio is getting confused saving xml and 
				// changing the text, nasty but hacks around problem
				do ..write("]"_"]></Comments>")
			}	
			Else {s s=saves}	

		}
		do ..write(cr_"</LabResultItem>")

	}  // Repeat for next OBX (group)
	 
 }
}

/// J2
/// Writes out the PerformedAt tags associated with Result and LabResultItem<br>
/// PerformedAt property.<br>
/// If OBX-15 and OBX-23 are valued they should match.<br>
/// If valued OBX-23 is used over OBX-15<br>
/// otherwise default to OBX-15.<br>
/// If OBX-24 Performing Organization Address is found that will be written out also.<br>
ClassMethod writePerformedAt()
{
	set tOBX23Found=0
	set tOBX15Found=0
	set tOBX24Found=0
	set tOBX25Found=0
	#; OBX-23 Performing Organization
	If (($$$OBXPerformingOrganizationName'="")||($$$OBXPerformingOrganizationIdentifier'="")){
		set tOBX23Found=1
	 	do ..write(cr_"<PerformedAt>")
		If $$$OBXPerformingOrganizationIdentifier=""{ //3 deprecated in 2.5 in favor of 10
		 	do ..write(cr_"<Code>"_$$$OBXPerformingOrganizationID_"</Code>")
		}Else{
			do ..write(cr_"<Code>"_$$$OBXPerformingOrganizationIdentifier_"</Code>")
		} 
		do ..write(cr_"<SDACodingStandard>"_$$$OBXPerformingOrganizationAssigningAuthority_"</SDACodingStandard>")
	 	do ..write(cr_"<Description>"_$$$OBXPerformingOrganizationName_"</Description>")
	}
	#; OBX-15 : ProducersID - Must match OBX-23 if present
	if (($$$OBXProducersIDIdentifier'="")||($$$OBXProducersIDText'=""))&&('tOBX23Found) {
		set tOBX15Found=1
		do ..write(cr_"<PerformedAt>")
		do ..write(cr_"<SDACodingStandard>"_$$$OBXProducersIDNameofCodingSystem_"</SDACodingStandard>")
		do ..write(cr_"<Code>"_$$$OBXProducersIDIdentifier_"</Code>")
		do ..write(cr_"<Description>"_$$$OBXProducersIDText_"</Description>")
	}
	if (($$$OBXPerformingOrganizationAddressStreet'="")||($$$OBXPerformingOrganizationAddressZiporPostalCode'="")) {
		do:(('tOBX15Found)&&('tOBX23Found)) ..write(cr_"<PerformedAt>")
		set tOBX24Found=1
		do ..write(cr_"<Address>")
		do ..write(cr_"<Street>")
		do ..write($$$OBXPerformingOrganizationAddressStreet)
		if $$$OBXPerformingOrganizationAddressOtherDesignation'="" {
			do ..write("; "_$$$OBXPerformingOrganizationAddressOtherDesignation)}
		do ..write("</Street>")
		do ..write(cr_"<City><Code>"_$$$OBXPerformingOrganizationAddressCity_"</Code></City>")
		do ..write(cr_"<State><Code>"_$$$OBXPerformingOrganizationAddressStateorProvince_"</Code></State>")
		do ..write(cr_"<Zip><Code>"_$$$OBXPerformingOrganizationAddressZiporPostalCode_"</Code></Zip>")
		do ..write(cr_"<Country><Code>"_$$$OBXPerformingOrganizationAddressCountry_"</Code></Country>")
		do ..write(cr_"<County><Code>"_$$$OBXPerformingOrganizationAddressCountyParishCode_"</Code></County>")
		do ..write(cr_"</Address>")
	}
	
	if ($$$OBXPerformingOrganizationMedicaIDNumber'="")||($$$OBXPerformingOrganizationMedicaAssigningAuthority'="")||($$$OBXPerformingOrganizationMedicaFamilyNameSurname'="") {
		do:(('tOBX15Found)&&('tOBX23Found)&('tOBX24Found)) ..write(cr_"<PerformedAt>")
		Set tOBX25Found = 1
		do ..By("<MedicalDirector>",,"MedicalDirector",
			$$$OBXPerformingOrganizationMedicaAssigningAuthority,
			$$$OBXPerformingOrganizationMedicaIDNumber,
			$$$OBXPerformingOrganizationMedicaFamilyNameSurname,
			$$$OBXPerformingOrganizationMedicaGivenName,
			$$$OBXPerformingOrganizationMedicaMiddleName,
			$$$OBXPerformingOrganizationMedicaNamePrefix,
			$$$OBXPerformingOrganizationMedicaNameSuffix,
			$$$OBXPerformingOrganizationMedicaNameProfSuffix
		)
	}	

	do:((tOBX15Found)||(tOBX23Found)||(tOBX24Found))||(tOBX25Found) ..write(cr_"</PerformedAt>")
}

/// J2
/// If OBX-25 - Performing Organization Medical Director is valued <br>
/// Writes out <PerformedAt/MedicalDirector> as a CareProvider<br>
/// for the Result and LabResultItem property PerformedAt/MedicalDirector.<br>
ClassMethod writeMedicalDirector() As %Boolean
{
	Set retVal=0
	if ($$$OBXPerformingOrganizationMedicaIDNumber'="")||($$$OBXPerformingOrganizationMedicaAssigningAuthority'="")||($$$OBXPerformingOrganizationMedicaFamilyNameSurname'="") {
		do ..By("<MedicalDirector>",,"MedicalDirector",
			$$$OBXPerformingOrganizationMedicaAssigningAuthority,
			$$$OBXPerformingOrganizationMedicaIDNumber,
			$$$OBXPerformingOrganizationMedicaFamilyNameSurname,
			$$$OBXPerformingOrganizationMedicaGivenName,
			$$$OBXPerformingOrganizationMedicaMiddleName,
			$$$OBXPerformingOrganizationMedicaNamePrefix,
			$$$OBXPerformingOrganizationMedicaNameSuffix,
			$$$OBXPerformingOrganizationMedicaNameProfSuffix
		)
		Set retVal=1
	}
	Quit retVal
}

ClassMethod ORC(mode As %String)
{
 #; initialize
 set (ordertype,resulttime,resultstatus,tReplace)=""
 if mode="obs" {   // ORU OrderTypeIdentifier="OBS"
	$$$Find("ORCOBS")
	#if $$$HSDebug
		do ##class(HS.Util.HSDebug).Debug("ORC(obs)","HS.Gateway.HL7.HL7ToSDA3","txt",s)
	#endif
	do ..OBR("obs")
	while $$$IsFollowing("TQ1") {$$$GetFollowing("TQ1")} // ignore any TQ1
	while $$$IsFollowing("OBX") {do ..OBX("obs")} do ..end("OBX")
	quit
 }
 elseif mode="med" {   // ORM Ordertype="MED"
	$$$Find("ORCMED")
	#if $$$HSDebug
		do ##class(HS.Util.HSDebug).Debug("ORC(med)","HS.Gateway.HL7.HL7ToSDA3","txt",s)
	#endif
	do ..start("ORCMED",cr_"<Medications>")
	do ..write(cr_"<Medication>")
	Do ..OnMedication()
 }
 elseif mode="ord" {   // ORM OrderType'="MED"
	$$$Find("ORCORD")
	#if $$$HSDebug
		do ##class(HS.Util.HSDebug).Debug("ORC(ord)","HS.Gateway.HL7.HL7ToSDA3","txt",s)
	#endif
	do ..StartOrder()
 }
 elseif mode="omp" {   // OMP_O09
	$$$Find("ORCOMP")
	#if $$$HSDebug
		do ##class(HS.Util.HSDebug).Debug("ORC(omp)","HS.Gateway.HL7.HL7ToSDA3","txt",s)
	#endif
	do ..start("ORCOMP",cr_"<Medications>")
	do ..write(cr_"<Medication>")
	Do ..OnMedication()
 }
 elseif mode="rde" {   //RDE_O11
 	$$$Find("ORCRDE")
 	#if $$$HSDebug
		do ##class(HS.Util.HSDebug).Debug("ORC(rde)","HS.Gateway.HL7.HL7ToSDA3","txt",s)
	#endif
	do ..start("ORCRDE",cr_"<Medications>")
	do ..write(cr_"<Medication>")
	Do ..OnMedication()
 }
 elseif mode="vxu" {   // VXU_V04
	$$$Find("ORC")
	#if $$$HSDebug
		do ##class(HS.Util.HSDebug).Debug("ORC(vxu)","HS.Gateway.HL7.HL7ToSDA3","txt",s)
	#endif
		
	do ..start("ORC",cr_"<Vaccinations>")
	do ..write(cr_"<Vaccination>")
	Do ..OnVaccination()
 }
 elseif mode="res" {   // ORU OrderTypeIdentifier'="OBS"
	$$$Find("ORCRES")
	#if $$$HSDebug
		do ##class(HS.Util.HSDebug).Debug("ORC(res)","HS.Gateway.HL7.HL7ToSDA3","txt",s)
	#endif

	do ..StartOrder()
	if ($zcvt($$$ORCOrderTypeIdentifier,"U")="LAB")&&($$$ORCNotAllText) {  // Atomic Results
		set mode="lab"
	} else {  // Text Results
		set mode="txt"
	}
 }
 do ..WriteEncounterNumber(encNum)
 
 #; ORC-1 : OrderControl ("" means inactivate all, """" means delete all)
 if $$$ORCOrderControl="""""" {
	do ..RemoveOrder(mode,"I")
	quit
 }
 elseif $$$ORCOrderControl="""""""""" {
	do ..RemoveOrder(mode,"C")
	quit
 }
  elseif $$$ORCOrderControl="R"&&(mode="lab") {
	  //for atomic lab results, action code R means we are replacing the entire set of results
	  do ..write(cr_"<ActionCode>R</ActionCode>")
	  Set tReplace=1
 }

 #; ORC-2 : PlacerOrderNumber
 do ..write(cr_"<PlacerId>"_$$$ORCPlacerOrderNumberEntityIdentifier_"</PlacerId>")
 #; J2 -- add namespace and Universal ID
 Set pfs=$$$ORCPlacerNamespace_"^"_$$$ORCPlacerUniversalID_"^"_$$$ORCPlacerUniversalIDType
 do:pfs'="^^" ..write(cr_"<PlacerAssigningAuthority>"_pfs_"</PlacerAssigningAuthority>")
 
 #; ORC-3 : FillerOrderNumber
 do ..write(cr_"<FillerId>"_$$$ORCFillerOrderNumberEntityIdentifier_"</FillerId>")
 #; J2 -- add namespace and Universal ID
 Set pfs=$$$ORCFillerNamespace_"^"_$$$ORCFillerUniversalID_"^"_$$$ORCFillerUniversalIDType
 do:pfs'="^^" ..write(cr_"<FillerAssigningAuthority>"_pfs_"</FillerAssigningAuthority>")
 
 // J2 PJH
 #; ORC-4 : Placer Group Number
 do ..write(cr_"<GroupId>"_$$$ORCPlacerGroupNumberEntityIdentifier_"</GroupId>")
 Set pfs=$$$ORCPlacerGroupNamespace_"^"_$$$ORCPlacerGroupUniversalID_"^"_$$$ORCPlacerGroupUniversalIDType
 do:pfs'="^^" ..write(cr_"<GroupAssigningAuthority>"_pfs_"</GroupAssigningAuthority>")

 #; ORC-5 : OrderStatus
 do ..write(cr_"<Status>"_..orderstatus($$$ORCOrderStatus)_"</Status>")

 #; ORC-7 : QuantityTiming (see also OBR-27, TQ1-2, -7, -8, -9, -10, -11, OBR-6)
 set %occ="" for {
	set %occ=$$$ORCQuantityTiming(%occ) quit:%occ=""
	 
	do ..write(cr_"<OrderQuantity>"_$$$ORCQuantityTimingQuantityQuantity(%occ)_"</OrderQuantity>")

	if $$$ORCQuantityTimingDuration(%occ)'="" {
		do ..write(cr_"<Duration>")
		do ..write(cr_"<Code>"_$$$ORCQuantityTimingDuration(%occ)_"</Code>")
		do ..write(cr_"</Duration>")
	}
	
	do ..write(cr_"<FromTime>"_..xmltimestamp($$$ORCQuantityTimingStartDateTimeTime(%occ))_"</FromTime>")
	do ..write(cr_"<ToTime>"_..xmltimestamp($$$ORCQuantityTimingEndDateTimeTime(%occ))_"</ToTime>")

	if $$$ORCQuantityTimingPriority(%occ)'="" {
		do ..write(cr_"<Priority>")
		do ..write(cr_"<Code>"_$$$ORCQuantityTimingPriority(%occ)_"</Code>")
		do ..write(cr_"</Priority>")
	}

	do ..write(cr_"<Condition>"_$$$ORCQuantityTimingCondition(%occ)_"</Condition>")
	do ..write(cr_"<TextInstruction>"_$$$ORCQuantityTimingText(%occ)_"</TextInstruction>")

	quit  // only one

 }

 #; ORC-9 : DateTimeofTransaction
 do ..write(cr_"<EnteredOn>"_..xmltimestamp($$$ORCDateTimeofTransactionTime)_"</EnteredOn>")

 #; J2 PJH - Additional ","
 #; ORC-10 : EnteredBy
 set %occ="" for {
	set %occ=$$$ORCEnteredBy(%occ) quit:%occ=""
	do ..By("<EnteredBy>",,"User",
			$$$ORCEnteredByAssigningAuthority(%occ),
			$$$ORCEnteredByIDNumber(%occ),
	 		$$$ORCEnteredByFamilyNameSurname(%occ),
	 		$$$ORCEnteredByGivenName(%occ))
	quit  // only one
 }

 #; J2 PJH - Pass in Suffix
 #; ORC-11 : VerifiedBy
 set %occ="" for {
	set %occ=$$$ORCVerifiedBy(%occ) quit:%occ=""
	do ..By("<VerifiedBy>",,
		"CareProvider",
		$$$ORCVerifiedByAssigningAuthority(%occ),
		$$$ORCVerifiedByIDNumber(%occ),
		$$$ORCVerifiedByFamilyNameSurname(%occ),
		$$$ORCVerifiedByGivenName(%occ),
		$$$ORCVerifiedByMiddleName(%occ),
		$$$ORCVerifiedByNamePrefix(%occ),
		$$$ORCVerifiedByNameSuffix(%occ))
	quit  // only one
 }

 #; J2 PJH Pass in Suffix
 #; ORC-12 : OrderingProvider  (see RXO-14, OBR-16)
 set %occ="" for {
	set %occ=$$$ORCOrderingProvider(%occ) quit:%occ=""
	if $$$ORCOrderingProviderIDNumber(%occ)'="" {
		do ..By("<OrderedBy>",0,
			"CareProvider",
			$$$ORCOrderingProviderAssigningAuthority(%occ),
			$$$ORCOrderingProviderIDNumber(%occ),
			$$$ORCOrderingProviderFamilyNameSurname(%occ),
			$$$ORCOrderingProviderGivenName(%occ),
			$$$ORCOrderingProviderMiddleName(%occ),
			$$$ORCOrderingProviderNamePrefix(%occ),
			$$$ORCOrderingProviderNameSuffix(%occ),
			$$$ORCOrderingProviderNameProfessionalSuffix(%occ))
	#; ORC-24 : OrderingProviderAddress
		do ..write(cr_"<Address>")	 
		do ..write(cr_"<Street>")
		do ..write($$$ORCOrderingProviderAddressStreetAddressStreetorMailingAddress(%occ))
		if $$$ORCOrderingProviderAddressOtherDesignation(%occ)'="" {
			do ..write("; "_$$$ORCOrderingProviderAddressOtherDesignation(%occ))}
		do ..write("</Street>")
		if $$$ORCOrderingProviderAddressCity(%occ)'="" {
			do ..write(cr_"<City>")
			do ..write(cr_"<Code>"_$$$ORCOrderingProviderAddressCity(%occ)_"</Code>")
			do ..write(cr_"</City>")
		}
		if $$$ORCOrderingProviderAddressStateorProvince(%occ)'="" {
			do ..write(cr_"<State>")
			do ..write(cr_"<Code>"_$$$ORCOrderingProviderAddressStateorProvince(%occ)_"</Code>")
			do ..write(cr_"</State>")
		}
		if $$$ORCOrderingProviderAddressZiporPostalCode(%occ)'="" {
			do ..write(cr_"<Zip>")
			do ..write(cr_"<Code>"_$$$ORCOrderingProviderAddressZiporPostalCode(%occ)_"</Code>")
			do ..write(cr_"</Zip>")
		}
		if $$$ORCOrderingProviderAddressCountry(%occ)'="" {
			do ..write(cr_"<Country>")
			do ..write(cr_"<Code>"_$$$ORCOrderingProviderAddressCountry(%occ)_"</Code>")
			do ..write(cr_"</Country>")
		}
		if $$$ORCOrderingProviderAddressCountyParishCode(%occ)'="" {
			do ..write(cr_"<County>")
			do ..write(cr_"<Code>"_$$$ORCOrderingProviderAddressCountyParishCode(%occ)_"</Code>")
			do ..write(cr_"</County>")
		}
		do ..write(cr_"</Address>")
		do ..write(cr_"</OrderedBy>")
		quit  // only one
	}
 }

 #; ORC-13 : EnterersLocation
 if $$$ORCEnterersLocationPointofCare'="" {
	do ..write(cr_"<EnteringOrganization>")
	do ..write(cr_"<Code>"_$$$ORCEnterersLocationPointofCare_"</Code>")
	do ..write(cr_"<Organization>")
	do ..write(cr_"<Code>"_$$$MSHSendingFacilityNamespaceID_"</Code>")
	do ..write(cr_"</Organization>")	 
	do ..write(cr_"</EnteringOrganization>")
 }

 #; ORC-14 : CallBackPhoneNumber  (see OBR-17)
 do ..PhonesAndEmail(s,14,.workphone,.workmobile,.workemail,.workfax)
 set callback=""
 set work=$tr(workphone,"^",",") if work'="" set callback=work
 set mobile=$tr(workmobile,"^",",")
 if mobile'="" {
	if callback'="" set callback=callback_", "
	set callback=callback_"Mobile: "_mobile
 }
 set fax=$tr(workfax,"^",",")
 if fax'="" {
	 if callback'="" set callback=callback_", "
	 set callback=callback_"Fax: "_fax}
 set email=$tr(workemail,"^",",")
 if email'="" {
	if callback'="" set callback=callback_", "
	 set callback=callback_"email: "_email
 }
 do ..write(cr_"<CallbackNumber>"_..xml(callback)_"</CallbackNumber>")
 kill callback,work,mobile,email

 #; ORC-21 : OrderingFacilityName
 set %occ="" for {
	set %occ=$$$ORCOrderingFacilityName(%occ) quit:%occ=""
	do ..write(cr_"<EnteredAt>")
	#; J2 - Prefered Id is found in ORC-21.10 if not there default to ORC-21.3 per HL7 spec
	if $$$ORCOrderingFacilityNameOrganizationIdentifier(%occ)'=""{
		do ..write(cr_"<Code>"_$$$ORCOrderingFacilityNameOrganizationIdentifier(%occ)_"</Code>")
	}Else{
		do ..write(cr_"<Code>"_$$$ORCOrderingFacilityNameIDNumber(%occ)_"</Code>")
	}
	do ..write(cr_"<SDACodingStandard>"_$$$ORCOrderingFacilityNameAssigningAuthority(%occ)_"</SDACodingStandard>")
	do ..write(cr_"<Description>"_$$$ORCOrderingFacilityNameOrganizationName(%occ)_"</Description>")
	
 #; ORC-22 : OrderingFacilityAddress
	do ..write(cr_"<Address>")
	do ..write(cr_"<Street>")
	do ..write($$$ORCOrderingFacilityAddressStreetAddressStreetorMailingAddress(%occ))
	if $$$ORCOrderingFacilityAddressOtherDesignation(%occ)'="" {
		do ..write("; "_$$$ORCOrderingFacilityAddressOtherDesignation(%occ))}
	do ..write("</Street>")
	if $$$ORCOrderingFacilityAddressCity(%occ)'="" {
		do ..write(cr_"<City>")
		do ..write(cr_"<Code>"_$$$ORCOrderingFacilityAddressCity(%occ)_"</Code>")
		do ..write(cr_"</City>")
	}
	if $$$ORCOrderingFacilityAddressStateorProvince(%occ)'="" {
		do ..write(cr_"<State>")
		do ..write(cr_"<Code>"_$$$ORCOrderingFacilityAddressStateorProvince(%occ)_"</Code>")
		do ..write(cr_"</State>")
	}
	if $$$ORCOrderingFacilityAddressZiporPostalCode(%occ)'="" {
		do ..write(cr_"<Zip>")
		do ..write(cr_"<Code>"_$$$ORCOrderingFacilityAddressZiporPostalCode(%occ)_"</Code>")
		do ..write(cr_"</Zip>")
	}
	if $$$ORCOrderingFacilityAddressCountry(%occ)'="" {
		do ..write(cr_"<Country>")
		do ..write(cr_"<Code>"_$$$ORCOrderingFacilityAddressCountry(%occ)_"</Code>")
		do ..write(cr_"</Country>")
	}
	if $$$ORCOrderingFacilityAddressCountyParishCode(%occ)'="" {
		do ..write(cr_"<County>")
		do ..write(cr_"<Code>"_$$$ORCOrderingFacilityAddressCountyParishCode(%occ)_"</Code>")
		do ..write(cr_"</County>")
	}
	do ..write(cr_"</Address>")

 #; ORC-23 : OrderingFacilityPhoneNumber
	do ..PhonesAndEmail(s,23,.workphone,.workmobile,.workemail)
	do ..write(cr_"<ContactInfo>")
	do ..write(cr_"<WorkPhoneNumber>"_..xml($p(workphone,"^",1))_"</WorkPhoneNumber>")
	do ..write(cr_"<MobilePhoneNumber>"_..xml($p(workmobile,"^",1))_"</MobilePhoneNumber>")
	do ..write(cr_"<EmailAddress>"_..xml($p(workemail,"^",1))_"</EmailAddress>")
	do ..write(cr_"</ContactInfo>")

	do ..write(cr_"</EnteredAt>")
	quit  // only one	 
 }
 #; ORC-28 : ConfidentialityCode 
 if ($$$ORCConfidentialityCodeIdentifier'="")||
    ($$$ORCConfidentialityCodeText'="") {
	do ..write(cr_"<ConfidentialityCode>")
	do ..write(cr_"<SDACodingStandard>"_$$$ORCConfidentialityCodenameofCodingSystem_"</SDACodingStandard>")
	do ..write(cr_"<Code>"_$$$ORCConfidentialityCodeIdentifier_"</Code>")
	do ..write(cr_"<Description>"_$$$ORCConfidentialityCodeText_"</Description>")
	do ..write(cr_"</ConfidentialityCode>")
 }

 #; ORC-29 : OrderType  (see OBR-4, GetData)
 set ordertype=$zcvt($$$ORCOrderTypeIdentifier,"U")
 if (ordertype="")||(",LAB,RAD,MED,VXU,OTH,"'[(","_ordertype_",")) {set ordertype="OTH"}


 #; --------- end of ORC, now process the body of the order ----------

 if mode="med" {   // ORM Ordertype="MED"
	set ordertype="MED"
	if $$$IsFollowing("RXO") {do ..RXO()}
	if $$$IsFollowing("NTE") {do ..NTE()}
 }
 elseif mode="ord" {   // ORM OrderType'="MED", only allow LAB, RAD or OTH for now
	if (ordertype'="LAB")&&(ordertype'="RAD") set ordertype="OTH"
	if $$$IsFollowing("OBR") {do ..OBR(mode)}
	if $$$IsFollowing("NTE") {do ..NTE()}
 }
 elseif mode="omp" {   // OMP_O09
 	set ordertype="MED"
 	while $$$IsFollowing("TQ1") {do ..TQ1()}
	if $$$IsFollowing("RXO") {do ..RXO()}
	if $$$IsFollowing("NTE") {do ..NTE()}
 }
 elseif mode="vxu" {   // VXU_V04
	set ordertype="VXU"
	if $$$IsFollowing("TQ1") {do ..TQ1()}  // 0-1 for now
	if $$$IsFollowing("RXA") {do ..RXA(mode)}

	// J2 PJH - Ensure vxu can have RXR
	if $$$IsFollowing("RXR") {do ..RXR()}

	// J2 PJH - add obx
	while $$$IsFollowing("OBX") {do ..OBX("vxu")} do ..end("OBX")

 }
 elseif mode="rde" {   // RDE_O11
 	set ordertype="MED"
 	if $$$IsFollowing("RXE") {do ..RXE()}
 	if $$$IsFollowing("NTE") {do ..NTE()}
 	if $$$IsFollowing("TQ1") {do ..TQ1()}
	if $$$IsFollowing("RXR") {do ..RXR()}
	while $$$IsFollowing("RXC") {do ..RXC()} do ..end("RXC")
 }
 elseif mode="lab" {   // ORU OrderTypeIdentifier'="OBS", Atomic results
 	set orcsave = s
	do ..OBR("lab")
 
	//if $$$IsFollowing("OBR") {do ..OBR("lab")}
	// Don't process the NTE's at this point for a result
	// If they are in an ORU, assume they are ResultComments, rather than OrderComments
	//  if $$$IsFollowing("NTE") {do ..NTE()}
 }
 elseif mode="txt" {   // ORU OrderTypeIdentifier'="OBS", Text results
	if $$$IsFollowing("OBR") {do ..OBR("txt")}
	if $$$IsFollowing("NTE") {do ..NTE()}
 }

 #; --------- end of body, now close the order -----------

 if mode="med" {   // ORM Ordertype="MED"
	do ..write(cr_"</Medication>")
 }
 if mode="omp" {   // OMP_O09
	do ..write(cr_"</Medication>")
 }
 if mode="rde" {   //RDE_O11
 	do ..write(cr_"</Medication>")
 }
 if mode="vxu" {   // VXU_V04
 	do ..write(cr_"</Vaccination>")
	// J2 PJH - Process results/observations
	;while $$$IsFollowing("OBX") {do ..OBX("vxu")} do ..end("OBX")

 }
 if (mode="lab")||(mode="txt") {   // ORU OrderTypeIdentifier'="OBS"
 	do ..write(cr_"<Result>")
	while $$$IsFollowing("TQ1") {$$$GetFollowing("TQ1")} // ignore any TQ1
 }

 #; -------- process results -----------------------------

 if mode="lab" {   // ORU OrderTypeIdentifier'="OBS", Atomic results
	do ..write(cr_"<ResultType>AT</ResultType>")
	// we have done the OBR, so now check for NTE's after the OBR, before the OBX(s)
	// These should be ResultComments, rather than OrderComments
	if $$$IsFollowing("NTE") {do ..NTE()}
	// There may be TQ1s after the NTEs. If so, remember the seg # to process them later
	if $$$IsFollowing("TQ1") { 
		set tq1s = s
		// advance the context
		while $$$IsFollowing("TQ1") { $$$GetFollowing("TQ1") }
	} 
	else { set tq1s = "" }

	if resulttime'="" {
		do ..write(cr_"<ResultTime>"_..xmltimestamp(resulttime)_"</ResultTime>")
	}
	if resultstatus'="" {
		do ..write(cr_"<ResultStatus>"_resultstatus_"</ResultStatus>")
	}
	do ..write(cr_"<ResultItems>")
	do ..OBX("lab",tReplace) // handle all following OBX's + NTE
	do ..write(cr_"</ResultItems>")
	do ..write(cr_"</Result>")
	if (tq1s '= "") { 
		set saves = s
		set s = tq1s
		while $$$IsFollowing("TQ1") { do ..TQ1() }
		set s = saves
		kill saves
	}
 }

 if mode="txt" {   // ORU OrderTypeIdentifier'="OBS", Text results
 	// technically there can be NTEs preceding any TQ1s, but we do not expect them on a text result
 	while $$$IsFollowing("TQ1") { do ..TQ1() }
	if resulttime'="" {
		do ..write(cr_"<ResultTime>"_..xmltimestamp(resulttime)_"</ResultTime>")
		do ..write(cr_"<AuthorizationTime>"_..xmltimestamp(resulttime)_"</AuthorizationTime>")
		
	}
	if resultstatus'="" {
		do ..write(cr_"<ResultStatus>"_resultstatus_"</ResultStatus>")
	}
	
	do ..OBX("txt") // handle all following OBX's + NTE
	do ..write(cr_"</Result>")
 }
  #; J2
  If ($$$IsFollowing("SPM")){
	 do ..write(cr_"<Specimens>")
	 while $$$IsFollowing("SPM") { do ..SPM() }
	 do ..end("SPM")
	 do ..write(cr_"</Specimens>")
  }
 if ((mode="lab")&&($$$Next("OBR"))&&($$$Next("ORCRES")="")) {
  set s = orcsave //rewind to replay ORC
  Set ^||HS.Data("ORCRES")=$o(^||HS.Data("ORCRES",^||HS.Data("ORCRES")),-1) 
  do ..ORC("res")
 }
}

/// J2 PJH - Added Publicity Code and Immunication Registry Info
ClassMethod PD1()
{
 $$$Find("PD1")
 #if $$$HSDebug
	do ##class(HS.Util.HSDebug).Debug("PD1","HS.Gateway.HL7.HL7ToSDA3","txt",s)
 #endif

 #; PD1-4 : PatientPrimaryCareProvider
 set %occ="" for {
	set %occ=$$$PD1PatientPrimaryCareProvider(%occ) quit:%occ=""
	do ..By("<FamilyDoctor>",,
		"ReferralDoctor",
		$$$PD1PatientPrimaryCareProviderAssigningAuthority(%occ),
		$$$PD1PatientPrimaryCareProviderIDNumber(%occ),
		$$$PD1PatientPrimaryCareProviderFamilyNameSurname(%occ),
		$$$PD1PatientPrimaryCareProviderGivenName(%occ),
		$$$PD1PatientPrimaryCareProviderMiddleName(%occ),
		$$$PD1PatientPrimaryCareProviderNamePrefix(%occ),
		$$$PD1PatientPrimaryCareProviderNameSuffix(%occ))
	quit  // only one
 }
 
 // J2 PJH -- Include Publicity Info if present
 #;  PD1-11
 #; PD1-11 Publicity Code
 If $$$PD1PublicityCodeText'="" {
	do ..write(cr_"<PublicityCode>")
		do ..write(cr_"<SDACodingStandard>"_$$$PD1PublicityCodenameofCodingSystem_"</SDACodingStandard>")
		do ..write(cr_"<Code>"_$$$PD1PublicityCodeIdentifier_"</Code>")
		do ..write(cr_"<Description>"_$$$PD1PublicityCodeText_"</Description>")
	do ..write(cr_"</PublicityCode>")
	do ..write(cr_"<PublicityEffectiveDate>"_..xmltimestamp($$$PD1PublicityCodeEffectiveDate)_"</PublicityEffectiveDate>")
 }
 // J2 - Include Immunization Registry info if present
 #; PD1-16 Immunization Registry Status
 #; PD1-17 Immunization Registry Status Effective date 
 If $$$PD1ImmunizationRegistryStatus'="" {
	do ..write(cr_"<ImmunizationRegistryStatus>"_$$$PD1ImmunizationRegistryStatus_"</ImmunizationRegistryStatus>")
	do ..write(cr_"<ImmunizationRegistryStatusEffectiveDate>"_..xmltimestamp($$$PD1ImmunizationRegistryStatusEffectiveDate)_"</ImmunizationRegistryStatusEffectiveDate>")
 }
 // J2 - Set protection status
 #; PD1-12 Protection status indicator
 #; PD1-13 Protection status indicator effective date
 set isProtected = $CASE($$$PD1ProtectionIndicator, "Y":1, "N":0, $C(34,34):$C(34,34), :"")
 if isProtected'="" {
 	do ..write(cr_"<IsProtected>"_isProtected_"</IsProtected>")
 }
 do ..write(cr_"<ProtectedEffectiveDate>"_..xmltimestamp($$$PD1ProtectionEffectiveDate)_"</ProtectedEffectiveDate>")
}

ClassMethod PDA()
{
 $$$Find("PDA")
 #if $$$HSDebug
	do ##class(HS.Util.HSDebug).Debug("PDA","HS.Gateway.HL7.HL7ToSDA3","txt",s)
 #endif
}

ClassMethod PID()
{
 $$$Find("PID")
 #if $$$HSDebug
	do ##class(HS.Util.HSDebug).Debug("PID","HS.Gateway.HL7.HL7ToSDA3","txt",s)
 #endif

 set (ssn,dl,mrn)=""
 do ..start("PID",cr_"<Patient>")
 Do ..OnPatient()
 do ..write(cr_"<PatientNumbers>")

 #; PID-2 : PatientID
 if ($$$PIDPatientID'="")&&
	((..idtype($$$PIDPatientIDIdentifierTypeCode)="MRN")||
	 (..idtype($$$PIDPatientIDIdentifierTypeCode)="")) {
	do ..write(cr_"<PatientNumber>")
	set mrn = $$$PIDPatientIDIDNumber
	do ..write(cr_"<Number>"_mrn_"</Number>")
	do ..write(cr_"<NumberType>MRN</NumberType>")
	set orgCode=$$$PIDPatientIDAssigningAuthorityNamespaceID
	if orgCode="" set orgCode=$$$MSHSendingFacilityNamespaceID
	if orgCode'="" {
		do ..write(cr_"<Organization>")
		do ..write(cr_"<Code>"_orgCode_"</Code>")
		do ..write(cr_"</Organization>")
	}
	do ..write(cr_"<ISOAssigningAuthority>"_$$$PIDPatientIDAssigningAuthority_"</ISOAssigningAuthority>")
	do ..write(cr_"</PatientNumber>")
 }

 #; PID-3 : PatientIdentifierList
 set %occ="" for {
	set %occ=$$$PIDPatientIdentifierList(%occ) quit:%occ=""	 
	do ..write(cr_"<PatientNumber>")
	do ..write(cr_"<Number>"_$$$PIDPatientIdentifierListIDNumber(%occ)_"</Number>")
	set numbertype=..idtype($$$PIDPatientIdentifierListIdentifierTypeCode(%occ))
	if numbertype="SSN" set ssn=$$$PIDPatientIdentifierListIDNumber(%occ)
	if numbertype="DL" set dl=$$$PIDPatientIdentifierListIDNumber(%occ)
	if numbertype="MRN",mrn="" set mrn=$$$PIDPatientIdentifierListIDNumber(%occ)
	do ..write(cr_"<NumberType>"_numbertype_"</NumberType>")
	set orgCode=$$$PIDPatientIdentifierListAssigningAuthorityNamespaceID(%occ)
	//
	if (orgCode="")&&((numbertype="MRN")||(numbertype="")) {
		set orgCode=$$$MSHSendingFacilityNamespaceID}
	if orgCode'="" {
		do ..write(cr_"<Organization>")
		do ..write(cr_"<Code>"_orgCode_"</Code>")
		do ..write(cr_"</Organization>")
	}
	do ..write(cr_"<ISOAssigningAuthority>"_$$$PIDPatientIdentifierListAssigningAuthority(%occ)_"</ISOAssigningAuthority>")
	do ..write(cr_"</PatientNumber>")
 }

 #; PID-4 : AlternatePatientIDPID
 set %occ="" for {
	set %occ=$$$PIDAlternatePatientIDPID(%occ) quit:%occ=""	 
	do ..write(cr_"<PatientNumber>")
	do ..write(cr_"<Number>"_$$$PIDAlternatePatientIDPIDIDNumber(%occ)_"</Number>")
	set numbertype=..idtype($$$PIDAlternatePatientIDPIDIdentifierTypeCode(%occ))
	if numbertype="SSN",ssn="" set ssn=$$$PIDAlternatePatientIDPIDIDNumber(%occ)
	if numbertype="DL",dl="" set dl=$$$PIDAlternatePatientIDPIDIDNumber(%occ)
	if numbertype="MRN",mrn="" set mrn=$$$PIDAlternatePatientIDPIDIDNumber(%occ)
	do ..write(cr_"<NumberType>"_..idtype($$$PIDAlternatePatientIDPIDIdentifierTypeCode(%occ))_"</NumberType>")
	set orgCode=$$$PIDAlternatePatientIDPIDAssigningAuthorityNamespaceID(%occ)

	if (orgCode="")&&((numbertype="MRN")||(numbertype="")) {
		set orgCode=$$$MSHSendingFacilityNamespaceID}
	if orgCode'="" {
		do ..write(cr_"<Organization>")
		do ..write(cr_"<Code>"_orgCode_"</Code>")
		do ..write(cr_"</Organization>")
	}
	do ..write(cr_"<ISOAssigningAuthority>"_$$$PIDAlternatePatientIDAssigningAuthority(%occ)_"</ISOAssigningAuthority>")
	do ..write(cr_"</PatientNumber>")
 }

 #; PID-19 : SSNNumberPatient
 #;  value from PID-3 or PID-4 overrides
 if $$$PIDSSNNumberPatient'="",ssn="" {
	do ..write(cr_"<PatientNumber>")
	set ssn=$$$PIDSSNNumberPatient
	do ..write(cr_"<Number>"_ssn_"</Number>")
	do ..write(cr_"<NumberType>SSN</NumberType>")
	do ..write(cr_"</PatientNumber>")
 }

 #; PID-20 : DriversLicenseNumberPatient
 #;  value from PID-3 or PID-4 overrides
 if $$$PIDDriversLicenseNumberPatientLicenseNumber'="",dl="" {
	do ..write(cr_"<PatientNumber>")
	set dl=$$$PIDDriversLicenseNumberPatientLicenseNumber
	do ..write(cr_"<Number>"_dl_"</Number>")
	do ..write(cr_"<NumberType>DL</NumberType>")
	do ..write(cr_"<Organization>")
	do ..write(cr_"<Code>"_$$$PIDDriversLicenseNumberPatientIssuingStateProvinceCountry_"</Code>")
	do ..write(cr_"</Organization>")
	do ..write(cr_"</PatientNumber>")
 }

 do ..write(cr_"</PatientNumbers>")

 #; PID-5 : PatientName
 set %occ="" for {
	set %occ=$$$PIDPatientName(%occ) quit:%occ=""
	#; J2 added skip of Alias
	if ($$$PIDPatientNameCodeType(%occ)'="A"){ // A Type = Alias -- added to Aliases
		do ..write(cr_"<Name>")
		do ..write(cr_"<GivenName>"_$$$PIDPatientNameGivenName(%occ)_"</GivenName>")
		do ..write(cr_"<FamilyName>"_$$$PIDPatientNameFamilyNameSurname(%occ)_"</FamilyName>")
		do ..write(cr_"<FamilyNamePrefix>"_$$$PIDPatientNameFamilyNameOwnSurnamePrefix(%occ)_"</FamilyNamePrefix>")
		do ..write(cr_"<MiddleName>"_$$$PIDPatientNameSecondandFurtherGivenNamesor(%occ)_"</MiddleName>")
		do ..write(cr_"<NamePrefix>"_$$$PIDPatientNamePrefix(%occ)_"</NamePrefix>")
		do ..write(cr_"<NameSuffix>"_$$$PIDPatientNameSuffix(%occ)_"</NameSuffix>")
		do ..write(cr_"<ProfessionalSuffix>"_$$$PIDPatientNameProfessionalSuffix(%occ)_"</ProfessionalSuffix>")
		do ..write(cr_"</Name>")
		quit  // only one
	}	 
 }
 // 
 #; PID-5.7 : PatientNameType if Blank (Used last)
 Set tUnknownName=""
 set %occ="" for {
	set %occ=$$$PIDPatientName(%occ) quit:%occ=""
	Set tNameType=$$$PIDPatientNameCodeType(%occ)
	If tNameType="U" {
		Set tUnknownName="U"
	} Elseif tNameType="S" {
		Set tUnknownName="S"
	}
 }
 If tUnknownName'="" {
	do ..write(cr_"<BlankNameReason>"_tUnknownName_"</BlankNameReason>")
 }

 #; PID-6 : MothersMaidenName
 set %occ="" for {
	set %occ=$$$PIDMother(%occ) quit:%occ=""	 
	do ..write(cr_"<MothersMaidenName>"_$$$PIDMothersMaidenNameSurname(%occ)_"</MothersMaidenName>")
	do ..write(cr_"<MothersFullName>")
		do ..write(cr_"<GivenName>"_$$$PIDMothersMaidenNameGivenName(%occ)_"</GivenName>")
		do ..write(cr_"<FamilyName>"_$$$PIDMothersMaidenNameSurname(%occ)_"</FamilyName>")
		do ..write(cr_"<FamilyNamePrefix>"_$$$PIDMothersMaidenNameFamilyNameOwnSurnamePrefix(%occ)_"</FamilyNamePrefix>")
		do ..write(cr_"<MiddleName>"_$$$PIDMothersMaidenNameSecondandFurtherGivenNamesor(%occ)_"</MiddleName>")
		do ..write(cr_"<NamePrefix>"_$$$PIDMothersMaidenNamePrefix(%occ)_"</NamePrefix>")
		do ..write(cr_"<NameSuffix>"_$$$PIDMothersMaidenNameSuffix(%occ)_"</NameSuffix>")
		do ..write(cr_"<ProfessionalSuffix>"_$$$PIDMothersMaidenNameProfessionalSuffix(%occ)_"</ProfessionalSuffix>")
	do ..write(cr_"</MothersFullName>")
	quit  // only one
 }

 #; PID-7 : DateTimeofBirth
 do ..write(cr_"<BirthTime>"_..xmltimestamp($$$PIDDateTimeofBirthTime)_"</BirthTime>")

 #; PID-8 : AdministrativeSex
 if $$$PIDAdministrativeSex'="" {
	do ..write(cr_"<Gender>")
	do ..write(cr_"<Code>"_$$$PIDAdministrativeSex_"</Code>")
	do ..write(cr_"</Gender>")
 }

 #; PID-9 : PatientAlias
 do ..write(cr_"<Aliases>")	 
 set %occ="" for {
	set %occ=$$$PIDPatientAlias(%occ) quit:%occ=""
	do ..write(cr_"<Name>")
	do ..write(cr_"<GivenName>"_$$$PIDPatientAliasGivenName(%occ)_"</GivenName>")
	do ..write(cr_"<FamilyName>"_$$$PIDPatientAliasFamilyNameSurname(%occ)_"</FamilyName>")
	do ..write(cr_"<FamilyNamePrefix>"_$$$PIDPatientAliasFamilyNameOwnSurnamePrefix(%occ)_"</FamilyNamePrefix>")
	do ..write(cr_"<MiddleName>"_$$$PIDPatientAliasSecondandFurtherGivenNamesor(%occ)_"</MiddleName>")
	do ..write(cr_"<NamePrefix>"_$$$PIDPatientAliasPrefix(%occ)_"</NamePrefix>")
	do ..write(cr_"<NameSuffix>"_$$$PIDPatientAliasSuffix(%occ)_"</NameSuffix>")
	do ..write(cr_"<ProfessionalSuffix>"_$$$PIDPatientAliasProfessionalSuffix(%occ)_"</ProfessionalSuffix>")
	do ..write(cr_"</Name>")
 }
 
 #; J2 if PID-5.7 = A it is an alias
 set %occ="" for {
	set %occ=$$$PIDPatientName(%occ) quit:%occ=""	 
	if ($$$PIDPatientNameCodeType(%occ)="A"){ // Type of Alias -- add to Aliases
		do ..write(cr_"<Name>")
		do ..write(cr_"<GivenName>"_$$$PIDPatientNameGivenName(%occ)_"</GivenName>")
		do ..write(cr_"<FamilyName>"_$$$PIDPatientNameFamilyNameSurname(%occ)_"</FamilyName>")
		do ..write(cr_"<FamilyNamePrefix>"_$$$PIDPatientNameFamilyNameOwnSurnamePrefix(%occ)_"</FamilyNamePrefix>")
		do ..write(cr_"<MiddleName>"_$$$PIDPatientNameSecondandFurtherGivenNamesor(%occ)_"</MiddleName>")
		do ..write(cr_"<NamePrefix>"_$$$PIDPatientNamePrefix(%occ)_"</NamePrefix>")
		do ..write(cr_"<NameSuffix>"_$$$PIDPatientNameSuffix(%occ)_"</NameSuffix>")
		do ..write(cr_"<ProfessionalSuffix>"_$$$PIDPatientNameProfessionalSuffix(%occ)_"</ProfessionalSuffix>")
		do ..write(cr_"</Name>")
	}
 }
 
 do ..write(cr_"</Aliases>")	

 #; PID-10 : Race
 set %occ="",tGotRace=0 for {
	set %occ=$$$PIDRace(%occ) quit:%occ=""
	if ($$$PIDRaceIdentifier(%occ)'="")||($$$PIDRaceText(%occ)'="") {
		If 'tGotRace {
			//for compatibility, populate the older single instance property with the first race
			do ..write(cr_"<Race>")
			do ..write(cr_"<SDACodingStandard>"_$$$PIDRaceNameofCodingSystem(%occ)_"</SDACodingStandard>")
			do ..write(cr_"<Code>"_$$$PIDRaceIdentifier(%occ)_"</Code>")
			do ..write(cr_"<Description>"_$$$PIDRaceText(%occ)_"</Description>")
			do ..write(cr_"<CodeSystemVersionId>"_$$$PIDRaceCodeSystemVersionId(%occ)_"</CodeSystemVersionId>")
			do ..write(cr_"</Race>")
			do ..write(cr_"<Races>")
			Set tGotRace=1
		}
		do ..write(cr_"<Race>")
		do ..write(cr_"<SDACodingStandard>"_$$$PIDRaceNameofCodingSystem(%occ)_"</SDACodingStandard>")
		do ..write(cr_"<Code>"_$$$PIDRaceIdentifier(%occ)_"</Code>")
		do ..write(cr_"<Description>"_$$$PIDRaceText(%occ)_"</Description>")
		do ..write(cr_"<CodeSystemVersionId>"_$$$PIDRaceCodeSystemVersionId(%occ)_"</CodeSystemVersionId>")
		do ..write(cr_"</Race>")
	}
 }
 If tGotRace do ..write(cr_"</Races>")

 #; PID-11 : PatientAddress
 do ..write(cr_"<Addresses>")
 set %occ="" for {
	set %occ=$$$PIDPatientAddress(%occ) quit:%occ=""
	do ..write(cr_"<Address>")	 
	do ..write(cr_"<Street>")
	do ..write($$$PIDPatientAddressStreetAddressStreetorMailingAddress(%occ))
	if $$$PIDPatientAddressOtherDesignation(%occ)'="" {
		do ..write("; "_$$$PIDPatientAddressOtherDesignation(%occ))}
	do ..write("</Street>")
	if $$$PIDPatientAddressCity(%occ)'="" {
		do ..write(cr_"<City>")
		do ..write(cr_"<Code>"_$$$PIDPatientAddressCity(%occ)_"</Code>")
		do ..write(cr_"</City>")
	}
	if $$$PIDPatientAddressStateorProvince(%occ)'="" {
		do ..write(cr_"<State>")
		do ..write(cr_"<Code>"_$$$PIDPatientAddressStateorProvince(%occ)_"</Code>")
		do ..write(cr_"</State>")
	}
	if $$$PIDPatientAddressZiporPostalCode(%occ)'="" {
		do ..write(cr_"<Zip>")
		do ..write(cr_"<Code>"_$$$PIDPatientAddressZiporPostalCode(%occ)_"</Code>")
		do ..write(cr_"</Zip>")
	}
	if $$$PIDPatientAddressCountry(%occ)'="" {
		do ..write(cr_"<Country>")
		do ..write(cr_"<Code>"_$$$PIDPatientAddressCountry(%occ)_"</Code>")
		do ..write(cr_"</Country>")
	}
	if $$$PIDPatientAddressCountyParishCode(%occ)'="" {
		do ..write(cr_"<County>")
		do ..write(cr_"<Code>"_$$$PIDPatientAddressCountyParishCode(%occ)_"</Code>")
		do ..write(cr_"</County>")
	}
	do ..write(cr_"<FromTime>"_..xmltimestamp($$$PIDPatientAddressEffectiveDateTime(%occ))_"</FromTime>")
	do ..write(cr_"<ToTime>"_..xmltimestamp($$$PIDPatientAddressExpirationDateTime(%occ))_"</ToTime>")
	do ..write(cr_"</Address>")	 
 }
 do ..write(cr_"</Addresses>")	 

 #; PID-13 : PhoneNumberHome
 #; PID-14 : PhoneNumberBusiness
 do ..PhonesAndEmail(s,13,.homephone,.homemobile,.homeemail)
 do ..PhonesAndEmail(s,14,.workphone,.workmobile,.workemail)
 set home=$p(homephone,"^",1),work=$p(workphone,"^",1)
 set mobile=$p(homemobile,"^",1) if mobile="" set mobile=$p(workmobile,"^",1)
 set email=$p(homeemail,"^",1) if email="" set email=$p(workemail,"^",1)
 do ..write(cr_"<ContactInfo>")
 do ..write(cr_"<HomePhoneNumber>"_..xml(home)_"</HomePhoneNumber>")
 do ..write(cr_"<WorkPhoneNumber>"_..xml(work)_"</WorkPhoneNumber>")
 do ..write(cr_"<MobilePhoneNumber>"_..xml(mobile)_"</MobilePhoneNumber>")
 do ..write(cr_"<EmailAddress>"_..xml(email)_"</EmailAddress>")
 do ..write(cr_"</ContactInfo>")
 kill home,mobile,email

 #; PID-15 : PrimaryLanguage
 if ($$$PIDPrimaryLanguageIdentifier'="")||($$$PIDPrimaryLanguageText'="") {
	do ..write(cr_"<PrimaryLanguage>")
	do ..write(cr_"<SDACodingStandard>"_$$$PIDPrimaryLanguageNameofCodingSystem_"</SDACodingStandard>")
	do ..write(cr_"<Code>"_$$$PIDPrimaryLanguageIdentifier_"</Code>")
	do ..write(cr_"<Description>"_$$$PIDPrimaryLanguageText_"</Description>")
	do ..write(cr_"</PrimaryLanguage>")
 }

 #; PID-16 : MaritalStatus
 if ($$$PIDMaritalStatusIdentifier'="")||($$$PIDMaritalStatusText'="") {
	do ..write(cr_"<MaritalStatus>")
	do ..write(cr_"<SDACodingStandard>"_$$$PIDMaritalStatusNameofCodingSystem_"</SDACodingStandard>")
	do ..write(cr_"<Code>"_$$$PIDMaritalStatusIdentifier_"</Code>")
	do ..write(cr_"<Description>"_$$$PIDMaritalStatusText_"</Description>")
	do ..write(cr_"</MaritalStatus>")
 }

 #; PID-17 : Religion
 if ($$$PIDReligionIdentifier'="")||($$$PIDReligionText'="") {
	do ..write(cr_"<Religion>")
	do ..write(cr_"<SDACodingStandard>"_$$$PIDReligionNameofCodingSystem_"</SDACodingStandard>")
	do ..write(cr_"<Code>"_$$$PIDReligionIdentifier_"</Code>")
	do ..write(cr_"<Description>"_$$$PIDReligionText_"</Description>")
	do ..write(cr_"</Religion>")
 }

 #; PID-18 : PatientAccountNumber - see PV1
 set accountnumber=$$$PIDPatientAccountNumber
 #; PID-19 : SSNNumberPatient - see above
 #; PID-20 : DriversLicenseNumberPatient - see above
 
 #; PID-22 : EthnicGroup
 set %occ="" for {
	set %occ=$$$PIDEthnicGroup(%occ) quit:%occ=""
	if ($$$PIDEthnicGroupIdentifier(%occ)'="")||($$$PIDEthnicGroupText(%occ)'="") {
		do ..write(cr_"<EthnicGroup>")
		do ..write(cr_"<SDACodingStandard>"_$$$PIDEthnicGroupNameofCodingSystem(%occ)_"</SDACodingStandard>")
		do ..write(cr_"<Code>"_$$$PIDEthnicGroupIdentifier(%occ)_"</Code>")
		do ..write(cr_"<Description>"_$$$PIDEthnicGroupText(%occ)_"</Description>")
		do ..write(cr_"<CodeSystemVersionId>"_$$$PIDEthnicGroupCodeSystemVersionId(%occ)_"</CodeSystemVersionId>")
		do ..write(cr_"</EthnicGroup>")
	}
	quit  // only one
 }
 
 #; PID-24 : MultipleBirthIndicator
 #; PID-25 : BirthOrder
 if ($ZCVT($E($$$PIDMultipleBirthIndicator,1),"U")="N") { do ..write(cr_"<BirthOrder>0</BirthOrder>") }
 else { do ..write(cr_"<BirthOrder>"_$$$PIDBirthOrder_"</BirthOrder>") }

 #; PID-26 : Citizenship
 set (%occ,citizenship)="" for {
	set %occ=$$$PIDCitizenship(%occ) quit:%occ=""
	if ($$$PIDCitizenshipIdentifier(%occ)'="")||($$$PIDCitizenshipText(%occ)'="") {
		do ..write(cr_"<Citizenship>")
		do ..write(cr_"<SDACodingStandard>"_$$$PIDCitizenshipNameofCodingSystem(%occ)_"</SDACodingStandard>")
		do ..write(cr_"<Code>"_$$$PIDCitizenshipIdentifier(%occ)_"</Code>")
		do ..write(cr_"<Description>"_$$$PIDCitizenshipText(%occ)_"</Description>")
		do ..write(cr_"</Citizenship>")
		set citizenship=1
		quit  // only one
	}
 }

 #; PID-28 : Nationality - only used if PID-26 is empty
 if (citizenship'=1)&&
	(($$$PIDNationalityIdentifier'="")||($$$PIDNationalityText'="")) {
	do ..write(cr_"<Citizenship>")
	do ..write(cr_"<SDACodingStandard>"_$$$PIDNationalityNameofCodingSystem_"</SDACodingStandard>")
	do ..write(cr_"<Code>"_$$$PIDNationalityIdentifier_"</Code>")
	do ..write(cr_"<Description>"_$$$PIDNationalityText_"</Description>")
	do ..write(cr_"</Citizenship>")
 }

 #; PID-29 : PatientDeathDateandTime
 do ..write(cr_"<DeathTime>"_..xmltimestamp($$$PIDPatientDeathDateandTimeTime)_"</DeathTime>")

 #; PID-30 : PatientDeathIndicator
 set isDead = $CASE($$$PIDPatientDeathIndicator, "Y":1, "N":0, $C(34,34):$C(34,34), :"")
 if isDead'="" {
 	do ..write(cr_"<IsDead>"_isDead_"</IsDead>")
 }

 #; PID-33 : LastUpdateDateTime -> EnteredOn in SuperClass
 do ..write(cr_"<EnteredOn>"_..xmltimestamp($$$PIDLastUpdateDateTimeTime)_"</EnteredOn>")

 #; PID-34 : LastUpdateFacility -> EnteredAt in SuperClass
 do ..write(cr_"<EnteredAt>")
 if $$$PIDLastUpdateFacilityNamespaceID'="" {
	do ..write(cr_"<Code>"_$$$PIDLastUpdateFacilityNamespaceID_"</Code>")
 } else {
	do ..write(cr_"<Code>"_$$$MSHSendingFacilityNamespaceID_"</Code>")
 }
 do ..write(cr_"</EnteredAt>")

 #; J2 PJH Additional ","
 #; EVN-5 : OperatorID  -> EnteredBy in SuperClass
 if $$$EVN'="" {
	set %occ="" for {
		set %occ=$$$EVNOperator(%occ) quit:%occ=""
		do ..By("<EnteredBy>",,"User",
			$$$EVNOperatorIDAssigningAuthority(%occ),
			$$$EVNOperatorIDIDNumber(%occ),
			$$$EVNOperatorIDFamilyNameSurname(%occ),
			$$$EVNOperatorIDGivenName(%occ))
		quit  // only one
	}
 }
}

/// Examine the (repeating) Phone & Email field for Home, Work, Mobile and Fax
///  Phone number(s) and Email address(es)
/// Note that Fax is only stored for OBR-17/ORC-14<BR><BR>
/// The <paramater>workphone</parameter> parameter was added for ROL-12 since
/// this field can contain both home and work numbers.  For other fields this
/// parameter is unused. (JLD035)
ClassMethod PhonesAndEmail(s As %Integer, field As %Integer, ByRef phone As %String, ByRef mobile As %String, ByRef email As %String, ByRef fax As %String, ByRef workphone)
{
 // s is the current segment number
 // field is the field number within the segment (eg 13 is PID HomePhone)
 // Loop thru all field repeating ocurrences and build a list of
 //  phone numbers (phone), mobile numbers (mobile), fax numbers (fax) and email addresses (email)
 //  and business phone numbers (ROL-12 only)
 set (phone,mobile,fax,email,workphone)=""
 if (^||HS.Data(s)="ROL") { set workphonevar="workphone" } else { set workphonevar="phone" }
 for %occ=1:1 {
	if $p($g(^||HS.Data(s,field)),s3,%occ,9999)="" quit  // no more
	set xtn=$p(^||HS.Data(s,field),s3,%occ)  // one phone number ocurrence (XTN)
	// break it down into elements (this code uses macros to ensure the
	//  principle that all referenced fields and sub-fields are macros
	if (^||HS.Data(s)="PID")&&(field=13) {
		set xtn1=$$$PIDPhoneNumberHomeTelephoneNumber(%occ)
		set xtn2=$$$PIDPhoneNumberHomeTelecommunicationUseCode(%occ)
		set xtn3=$$$PIDPhoneNumberHomeTelecommunicationEquipmentTy(%occ)
		set xtn4=$$$PIDPhoneNumberHomeEmailAddress(%occ)
		set xtn5=$$$PIDPhoneNumberHomeCountryCode(%occ)
		set xtn6=$$$PIDPhoneNumberHomeAreaCityCode(%occ)
		set xtn7=$$$PIDPhoneNumberHomeLocalNumber(%occ)
		set xtn8=$$$PIDPhoneNumberHomeExtension(%occ)
		set xtn9=$$$PIDPhoneNumberHomeAnyText(%occ)
		set xtn12=$$$PIDPhoneNumberHomeUnformattedTelephonenumber(%occ)
		set type="home"
	}
	elseif (^||HS.Data(s)="PID")&&(field=14) {
		set xtn1=$$$PIDPhoneNumberBusinessTelephoneNumber(%occ)
		set xtn2=$$$PIDPhoneNumberBusinessTelecommunicationUseCode(%occ)
		set xtn3=$$$PIDPhoneNumberBusinessTelecommunicationEquipmentTy(%occ)
		set xtn4=$$$PIDPhoneNumberBusinessEmailAddress(%occ)
		set xtn5=$$$PIDPhoneNumberBusinessCountryCode(%occ)
		set xtn6=$$$PIDPhoneNumberBusinessAreaCityCode(%occ)
		set xtn7=$$$PIDPhoneNumberBusinessLocalNumber(%occ)
		set xtn8=$$$PIDPhoneNumberBusinessExtension(%occ)
		set xtn9=$$$PIDPhoneNumberBusinessAnyText(%occ)
		set xtn12=$$$PIDPhoneNumberBusinessUnformattedTelephonenumber(%occ)
		set type="business"
	}
	elseif (^||HS.Data(s)="NK1")&&(field=5) {
		set xtn1=$$$NK1PhoneNumberTelephoneNumber(%occ)
		set xtn2=$$$NK1PhoneNumberTelecommunicationUseCode(%occ)
		set xtn3=$$$NK1PhoneNumberTelecommunicationEquipmentTy(%occ)
		set xtn4=$$$NK1PhoneNumberEmailAddress(%occ)
		set xtn5=$$$NK1PhoneNumberCountryCode(%occ)
		set xtn6=$$$NK1PhoneNumberAreaCityCode(%occ)
		set xtn7=$$$NK1PhoneNumberLocalNumber(%occ)
		set xtn8=$$$NK1PhoneNumberExtension(%occ)
		set xtn9=$$$NK1PhoneNumberAnyText(%occ)
		set xtn12=$$$NK1PhoneNumberUnformattedTelephonenumber(%occ)
		set type="home"		
	}
	elseif (^||HS.Data(s)="NK1")&&(field=6) {
		set xtn1=$$$NK1BusinessPhoneNumberTelephoneNumber(%occ)
		set xtn2=$$$NK1BusinessPhoneNumberTelecommunicationUseCode(%occ)
		set xtn3=$$$NK1BusinessPhoneNumberTelecommunicationEquipmentTy(%occ)
		set xtn4=$$$NK1BusinessPhoneNumberEmailAddress(%occ)
		set xtn5=$$$NK1BusinessPhoneNumberCountryCode(%occ)
		set xtn6=$$$NK1BusinessPhoneNumberAreaCityCode(%occ)
		set xtn7=$$$NK1BusinessPhoneNumberLocalNumber(%occ)
		set xtn8=$$$NK1BusinessPhoneNumberExtension(%occ)
		set xtn9=$$$NK1BusinessPhoneNumberAnyText(%occ)
		set xtn12=$$$NK1BusinessPhoneNumberUnformattedTelephonenumber(%occ)
		set type="business"		
	}
	elseif (^||HS.Data(s)="NK1")&&(field=31) { // J2
		set xtn1=$$$NK1ContactPhoneNumberTelephoneNumber(%occ)
		set xtn2=$$$NK1ContactPhoneNumberTelecommunicationUseCode(%occ)
		set xtn3=$$$NK1ContactPhoneNumberTelecommunicationEquipmentTy(%occ)
		set xtn4=$$$NK1ContactPhoneNumberEmailAddress(%occ)
		set xtn5=$$$NK1ContactPhoneNumberCountryCode(%occ)
		set xtn6=$$$NK1ContactPhoneNumberAreaCityCode(%occ)
		set xtn7=$$$NK1ContactPhoneNumberLocalNumber(%occ)
		set xtn8=$$$NK1ContactPhoneNumberExtension(%occ)
		set xtn9=$$$NK1ContactPhoneNumberAnyText(%occ)
		set xtn12=$$$NK1ContactPhoneNumberUnformattedTelephonenumber(%occ)
		set type="business"		
	}
	elseif (^||HS.Data(s)="GT1")&&(field=6) {
		set xtn1=$$$GT1GuarantorPhNumHomeTelephoneNumber(%occ)
		set xtn2=$$$GT1GuarantorPhNumHomeTelecommunicationUseCode(%occ)
		set xtn3=$$$GT1GuarantorPhNumHomeTelecommunicationEquipmentTy(%occ)
		set xtn4=$$$GT1GuarantorPhNumHomeEmailAddress(%occ)
		set xtn5=$$$GT1GuarantorPhNumHomeCountryCode(%occ)
		set xtn6=$$$GT1GuarantorPhNumHomeAreaCityCode(%occ)
		set xtn7=$$$GT1GuarantorPhNumHomeLocalNumber(%occ)
		set xtn8=$$$GT1GuarantorPhNumHomeExtension(%occ)
		set xtn9=$$$GT1GuarantorPhNumHomeAnyText(%occ)
		set xtn12=$$$GT1GuarantorPhNumHomeUnformattedTelephonenumber(%occ)
		set type="home"		
	}
	elseif (^||HS.Data(s)="GT1")&&(field=7) {
		set xtn1=$$$GT1GuarantorPhNumBusinessTelephoneNumber(%occ)
		set xtn2=$$$GT1GuarantorPhNumBusinessTelecommunicationUseCode(%occ)
		set xtn3=$$$GT1GuarantorPhNumBusinessTelecommunicationEquipmentTy(%occ)
		set xtn4=$$$GT1GuarantorPhNumBusinessEmailAddress(%occ)
		set xtn5=$$$GT1GuarantorPhNumBusinessCountryCode(%occ)
		set xtn6=$$$GT1GuarantorPhNumBusinessAreaCityCode(%occ)
		set xtn7=$$$GT1GuarantorPhNumBusinessLocalNumber(%occ)
		set xtn8=$$$GT1GuarantorPhNumBusinessExtension(%occ)
		set xtn9=$$$GT1GuarantorPhNumBusinessAnyText(%occ)
		set xtn12=$$$GT1GuarantorPhNumBusinessUnformattedTelephonenumber(%occ)
		set type="business"		
	}
	elseif (^||HS.Data(s)="GT1")&&(field=18) {
		set xtn1=$$$GT1GuarantorPhNumEmployerTelephoneNumber(%occ)
		set xtn2=$$$GT1GuarantorPhNumEmployerTelecommunicationUseCode(%occ)
		set xtn3=$$$GT1GuarantorPhNumEmployerTelecommunicationEquipmentTy(%occ)
		set xtn4=$$$GT1GuarantorPhNumEmployerEmailAddress(%occ)
		set xtn5=$$$GT1GuarantorPhNumEmployerCountryCode(%occ)
		set xtn6=$$$GT1GuarantorPhNumEmployerAreaCityCode(%occ)
		set xtn7=$$$GT1GuarantorPhNumEmployerLocalNumber(%occ)
		set xtn8=$$$GT1GuarantorPhNumEmployerExtension(%occ)
		set xtn9=$$$GT1GuarantorPhNumEmployerAnyText(%occ)
		set xtn12=$$$GT1GuarantorPhNumEmployerUnformattedTelephonenumber(%occ)
		//Decide if this is a home or business number based on xtn2.
		//"", "ASN", and unrecognized codes will go to business.
		//"EMR" will go to home.
		set type=$CASE(xtn2, "PRN":"home", "ORN":"home", "VHN":"home", "EMR":"home", "":"business", "WPN":"business", "ASN":"business", :"business")
	}
	elseif (^||HS.Data(s)="IN1")&&(field=7) {
		set xtn1=$$$IN1InsuranceCoPhoneNumberTelephoneNumber
		set xtn2=$$$IN1InsuranceCoPhoneNumberTelecommunicationUseCode
		set xtn3=$$$IN1InsuranceCoPhoneNumberTelecommunicationEquipmentTy
		set xtn4=$$$IN1InsuranceCoPhoneNumberEmailAddress
		set xtn5=$$$IN1InsuranceCoPhoneNumberCountryCode
		set xtn6=$$$IN1InsuranceCoPhoneNumberAreaCityCode
		set xtn7=$$$IN1InsuranceCoPhoneNumberLocalNumber
		set xtn8=$$$IN1InsuranceCoPhoneNumberExtension
		set xtn9=$$$IN1InsuranceCoPhoneNumberAnyText
		set xtn12=$$$IN1InsuranceCoPhoneNumberUnformattedTelephonenumber
		set type="business"		
	}
	elseif ($e(^||HS.Data(s),1,3)="ORC")&&(field=14) {
		set xtn1=$$$ORCCallBackPhoneNumberTelephoneNumber(%occ)
		set xtn2=$$$ORCCallBackPhoneNumberTelecommunicationUseCode(%occ)
		set xtn3=$$$ORCCallBackPhoneNumberTelecommunicationEquipmentTy(%occ)
		set xtn4=$$$ORCCallBackPhoneNumberEmailAddress(%occ)
		set xtn5=$$$ORCCallBackPhoneNumberCountryCode(%occ)
		set xtn6=$$$ORCCallBackPhoneNumberAreaCityCode(%occ)
		set xtn7=$$$ORCCallBackPhoneNumberLocalNumber(%occ)
		set xtn8=$$$ORCCallBackPhoneNumberExtension(%occ)
		set xtn9=$$$ORCCallBackPhoneNumberAnyText(%occ)
		set xtn12=$$$ORCCallBackPhoneNumberUnformattedTelephonenumber(%occ)
		set type="business"		
	}
	elseif ($e(^||HS.Data(s),1,3)="ORC")&&(field=23) {
		set xtn1=$$$ORCOrderingFacilityPhoneNumberTelephoneNumber(%occ)
		set xtn2=$$$ORCOrderingFacilityPhoneNumberTelecommunicationUseCode(%occ)
		set xtn3=$$$ORCOrderingFacilityPhoneNumberTelecommunicationEquipmentTy(%occ)
		set xtn4=$$$ORCOrderingFacilityPhoneNumberEmailAddress(%occ)
		set xtn5=$$$ORCOrderingFacilityPhoneNumberCountryCode(%occ)
		set xtn6=$$$ORCOrderingFacilityPhoneNumberAreaCityCode(%occ)
		set xtn7=$$$ORCOrderingFacilityPhoneNumberLocalNumber(%occ)
		set xtn8=$$$ORCOrderingFacilityPhoneNumberExtension(%occ)
		set xtn9=$$$ORCOrderingFacilityPhoneNumberAnyText(%occ)
		set xtn12=$$$ORCOrderingFacilityPhoneNumberUnformattedTelephonenumber(%occ)
		set type="business"		
	}
	elseif (^||HS.Data(s)="OBR")&&(field=17) {
		set xtn1=$$$OBROrderCallbackPhoneNumberTelephoneNumber(%occ)
		set xtn2=$$$OBROrderCallbackPhoneNumberTelecommunicationUseCode(%occ)
		set xtn3=$$$OBROrderCallbackPhoneNumberTelecommunicationEquipmentTy(%occ)
		set xtn4=$$$OBROrderCallbackPhoneNumberEmailAddress(%occ)
		set xtn5=$$$OBROrderCallbackPhoneNumberCountryCode(%occ)
		set xtn6=$$$OBROrderCallbackPhoneNumberAreaCityCode(%occ)
		set xtn7=$$$OBROrderCallbackPhoneNumberLocalNumber(%occ)
		set xtn8=$$$OBROrderCallbackPhoneNumberExtension(%occ)
		set xtn9=$$$OBROrderCallbackPhoneNumberAnyText(%occ)
		set xtn12=$$$OBROrderCallbackPhoneNumberUnformattedTelephonenumber(%occ)
		set type="business"		
	}
	elseif (^||HS.Data(s)="ROL")&&(field=12) {
		set xtn1=$$$ROLPhoneTelephoneNumber(%occ)
		set xtn2=$$$ROLPhoneTelecommunicationUseCode(%occ)
		set xtn3=$$$ROLPhoneTelecommunicationEquipmentType(%occ)
		set xtn4=$$$ROLPhoneEmailAddress(%occ)
		set xtn5=$$$ROLPhoneCountryCode(%occ)
		set xtn6=$$$ROLPhoneAreaCityCode(%occ)
		set xtn7=$$$ROLPhoneLocalNumber(%occ)
		set xtn8=$$$ROLPhoneExtension(%occ)
		set xtn9=$$$ROLPhoneAnyText(%occ)
		set xtn12=$$$ROLPhoneUnformattedTelephonenumber(%occ)
		//Decide if this is a home or business number based on xtn2.
		//"", "ASN", and unrecognized codes will go to business.
		//"EMR" will go to home.
		set type=$CASE(xtn2, "PRN":"home", "ORN":"home", "VHN":"home", "EMR":"home", "":"business", "WPN":"business", "ASN":"business", :"business")
		
	}
	// home phone if xtn2 in ("",PRN,ORN,VHN,ASN,EMR) and xtn3 in ("",PH)
	if (type="home")&&
		((xtn2="")||(xtn2="PRN")||(xtn2="ORN")||(xtn2="VHN")||(xtn2="ASN")||(xtn2="EMR"))&&
		((xtn3="")||(xtn3="PH")) {
		if xtn5_xtn6_xtn7_xtn8'="" {set phone=phone_"^"_..FormatPhone(xtn5,xtn6,xtn7,xtn8) if (xtn9'="") {set phone=phone_";"_xtn9, xtn9=""}}
		if xtn12'="" {set phone=phone_"^"_xtn12 if (xtn9'="") {set phone=phone_";"_xtn9, xtn9=""}}
		if xtn1'="" {set phone=phone_"^"_xtn1 if (xtn9'="") {set phone=phone_";"_xtn9, xtn9=""}}
	}
	// business phone if xtn2 in ("",WPN,ASN,EMR) and xtn3 in ("",PH)
	elseif (type="business")&&
		((xtn2="")||(xtn2="WPN")||(xtn2="ASN")||(xtn2="EMR"))&&
		((xtn3="")||(xtn3="PH")) {
		// workphonevar is "workphone" for a ROL segment only. Otherwise it is "phone".
		if xtn5_xtn6_xtn7_xtn8'="" {set @workphonevar=@workphonevar_"^"_..FormatPhone(xtn5,xtn6,xtn7,xtn8) if (xtn9'="") {set @workphonevar=@workphonevar_";"_xtn9, xtn9=""}}
		if xtn12'="" {set @workphonevar=@workphonevar_"^"_xtn12 if (xtn9'="") {set @workphonevar=@workphonevar_";"_xtn9, xtn9=""}}
		if xtn1'="" {set @workphonevar=@workphonevar_"^"_xtn1 if (xtn9'="") {set @workphonevar=@workphonevar_";"_xtn9, xtn9=""}}
	}
	// fax if xtn2 in ("",WPN,ASN,EMR) and xtn3 is FX
	elseif (type="business")&&
		((xtn2="")||(xtn2="WPN")||(xtn2="ASN")||(xtn2="EMR"))&&
		((xtn3="FX")) {
		if xtn5_xtn6_xtn7_xtn8'="" {set fax=fax_"^"_..FormatPhone(xtn5,xtn6,xtn7,xtn8) if (xtn9'="") {set fax=fax_";"_xtn9, xtn9=""}}
		if xtn12'="" {set fax=fax_"^"_xtn12 if (xtn9'="") {set fax=fax_";"_xtn9, xtn9=""}}
		if xtn1'="" {set fax=fax_"^"_xtn1 if (xtn9'="") {set fax=fax_";"_xtn9, xtn9=""}}
	}
	// mobile phone if xtn2 in (BPN) or xtn3 in (CP,BP)
	if (xtn2="BPN")||(xtn3="CP")||(xtn3="BP") {
		if xtn5_xtn6_xtn7_xtn8'="" {set mobile=mobile_"^"_..FormatPhone(xtn5,xtn6,xtn7,xtn8) if (xtn9'="") {set mobile=mobile_";"_xtn9, xtn9=""}}
		if xtn12'="" {set mobile=mobile_"^"_xtn12 if (xtn9'="") {set mobile=mobile_";"_xtn9, xtn9=""}}
		if xtn1'="" {set mobile=mobile_"^"_xtn1 if (xtn9'="") {set mobile=mobile_";"_xtn9, xtn9=""}}
	}
	// email from xtn4
	if xtn4'="" {set email=email_"^"_xtn4}
 }
 set phone=$e(phone,2,*),mobile=$e(mobile,2,*),email=$e(email,2,*),fax=$e(fax,2,*),workphone=$e(workphone,2,*)
 kill xtn,xtn1,xtn2,xtn3,xtn4,xtn5,xtn6,xtn7,xtn8,xtn12,type
 quit
}

/// Format a Phone Number from the 4 fields supplied
ClassMethod FormatPhone(country As %String, area As %String, number As %String, extension As %String) As %String
{
 set tPhone=""
 if country'="" set tPhone=tPhone_"+"_country
 if area'="" set:tPhone'="" tPhone=tPhone_" " set tPhone=tPhone_"("_area_")"
 set:tPhone'="" tPhone=tPhone_" " set tPhone=tPhone_number
 if extension'="" set:tPhone'="" tPhone=tPhone_" " set tPhone=tPhone_"x"_extension
 quit tPhone
}

ClassMethod PR1()
{
 $$$Find("PR1")
 #if $$$HSDebug
	do ##class(HS.Util.HSDebug).Debug("PR1","HS.Gateway.HL7.HL7ToSDA3","txt",s)
 #endif

 do ..start("PR1",cr_"<Procedures>")

 do ..write(cr_"<Procedure>")
 Do ..OnProcedure()
 do ..WriteEncounterNumber(encNum)

 #; PR1-3 : ProcedureCode
 if ($$$PR1ProcedureCodeIdentifier'="")||($$$PR1ProcedureCodeText'="") {
	do ..write(cr_"<Procedure>")
	do ..write(cr_"<SDACodingStandard>"_$$$PR1ProcedureCodeNameofCodingSystem_"</SDACodingStandard>")
	do ..write(cr_"<Code>"_$$$PR1ProcedureCodeIdentifier_"</Code>")
	do ..write(cr_"<Description>"_$$$PR1ProcedureCodeText_"</Description>")
	if ($$$PR1ProcedureCodeAltIdentifier'="")||($$$PR1ProcedureCodeAltText'="") {
		do ..write(cr_"<PriorCodes>")
		do ..write(cr_"<PriorCode>")
		do ..write(cr_"<CodeSystem>"_$$$PR1ProcedureCodeAltNameofCodingSystem_"</CodeSystem>")
		do ..write(cr_"<Code>"_$$$PR1ProcedureCodeAltIdentifier_"</Code>")
		do ..write(cr_"<Description>"_$$$PR1ProcedureCodeAltText_"</Description>")
		do ..write(cr_"<Type>A</Type>")
		do ..write(cr_"</PriorCode>")
		do ..write(cr_"</PriorCodes>")
	}
	if ($$$PR1ProcedureCodeOriginalText'="") {
		do ..write(cr_"<OriginalText>"_$$$PR1ProcedureCodeOriginalText_"</OriginalText>")
	}
	do ..write(cr_"</Procedure>")
 }

 #; PR1-4 : ProcedureDescription
 elseif ($$$PR1ProcedureDescription'="") {
	do ..write(cr_"<Procedure>")
	do ..write(cr_"<Code>"_$$$PR1ProcedureDescription_"</Code>")
	do ..write(cr_"</Procedure>")
 }

 #; PR1-5 : ProcedureDateTime
 do ..write(cr_"<ProcedureTime>"_..xmltimestamp($$$PR1ProcedureDateTimeTime)_"</ProcedureTime>")

 #; PR1-11 : Surgeon
 set %occ="" for {
	set %occ=$$$PR1Surgeon(%occ) quit:%occ=""
	do ..By("<Clinician>",,
		"CareProvider",
		$$$PR1SurgeonAssigningAuthority(%occ),
		$$$PR1SurgeonIDNumber(%occ),
		$$$PR1SurgeonFamilyNameSurname(%occ),
		$$$PR1SurgeonGivenName(%occ),
		$$$PR1SurgeonMiddleName(%occ),
		$$$PR1SurgeonNamePrefix(%occ),
		$$$PR1SurgeonNameSuffix(%occ),
		$$$PR1SurgeonProfessionalSuffix(%occ))
	quit  // only one
 }

 #; PR1-14 : ProcedurePriority
 if $$$PR1ProcedurePriority'="" {
	do ..write(cr_"<ProcedurePriority>"_$$$PR1ProcedurePriority_"</ProcedurePriority>")
 }

 #; PR1-19 : ProcedureIdentifier
 do ..write(cr_"<ExternalId>"_$$$PR1ProcedureIdentifierEntityIdentifier_"</ExternalId>")
 
 #; PR1-20 : ProcedureActionCode
 if ($$$PR1ProcedureActionCode'="") {
	 do ..write(cr_"<ActionCode>"_$$$PR1ProcedureActionCode_"</ActionCode>")
 }
 

 #; MSH-4 : SendingFacility -> EnteredAt in SuperClass 
 do ..write(cr_"<EnteredAt>")
 do ..write(cr_"<Code>"_$$$MSHSendingFacilityNamespaceID_"</Code>")
 do ..write(cr_"</EnteredAt>")

 do ..write(cr_"</Procedure>")
}

ClassMethod PRB()
{
	$$$Find("PRB")
	
	do ..start("PRB",cr_"<Problems>")
	
	do ..write(cr_"<Problem>")
	Do ..OnProblem()
	do ..WriteEncounterNumber(encNum)
	
	#; PRB-1 : Action Code
	#;   For PPR^PC3 (Problem Delete) always use "D"
	do ..write(cr_"<ActionCode>"_$S(msgType="PPR_PC3":"D", 1:$$$PRBActionCode)_"</ActionCode>")
	
	#; PRB-2 : Action Date/Time - See PRB-15
	
	#; PRB-3 : Problem ID
	if ($$$PRBProblemIDIdentifier'="")||($$$PRBProblemIDText'="") {
		do ..write(cr_"<Problem>")
		do ..write(cr_"<SDACodingStandard>"_$$$PRBProblemIDNameofCodingSystem_"</SDACodingStandard>")
		do ..write(cr_"<Code>"_$$$PRBProblemIDIdentifier_"</Code>")
		do ..write(cr_"<Description>"_$$$PRBProblemIDText_"</Description>")
		do ..write(cr_"</Problem>")
	}	
	
	#; PRB-4 : Problem Instance ID
	do ..write(cr_"<ExternalId>"_$$$PRBProblemInstanceID_"</ExternalId>")
	
	#; PRB-7 : Problem Established Date/Time - See PRB-16
	
	#; PRB-9 : Actual Problem Resolution Date/Time
	#; PRB-8 : Anticipated Problem Resolution Date/Time
	if $$$PRBActualProblemResolutionDateTime'="" {
		do ..write(cr_"<ToTime>"_..xmltimestamp($$$PRBActualProblemResolutionDateTime)_"</ToTime>") }
	elseif $$$PRBAnticipatedProblemResolutionDateTime'="" {
		do ..write(cr_"<ToTime>"_..xmltimestamp($$$PRBAnticipatedProblemResolutionDateTime)_"</ToTime>") }
		
	#; PRB-10 : Problem Classification
	if ($$$PRBProblemClassificationIdentifier'="")||($$$PRBProblemClassificationText'="") {
		do ..write(cr_"<Category>")
		do ..write(cr_"<SDACodingStandard>"_$$$PRBProblemClassificationNameofCodingSystem_"</SDACodingStandard>")
		do ..write(cr_"<Code>"_$$$PRBProblemClassificationIdentifier_"</Code>")
		do ..write(cr_"<Description>"_$$$PRBProblemClassificationText_"</Description>")
		do ..write(cr_"</Category>")
	}
	
	#; PRB-14 : Problem Life Cycle Status
	#; (This logic is only applied when there is a Code or Description.)
	#; If the Code matches one of the SNOMED codes and the SDACodingStandard contains "SNOMED",
	#;   use the corresponding SNOMED description.
	#; Else if the description matches one of the SNOMED descriptions (case- and whitespace-insensitive), 
	#;   use to the appropriate SNOMED code.
	#; Else if there is a value in PRB-9, map to "Resolved".
	#; Else default to "Active".  In each case, the SDACodingStandard is set to "SNOMED CT".
	if ($$$PRBProblemLifeCycleStatusIdentifier'="")||($$$PRBProblemLifeCycleStatusText'="") {
		if (("^55561003^73425007^90734009^7087005^255227004^415684004^410516002^413322009^"[("^"_$$$PRBProblemLifeCycleStatusIdentifier_"^"))&&
	    	($ZCVT($$$PRBProblemLifeCycleStatusNameofCodingSystem,"U")["SNOMED")) {
		    	set code=$$$PRBProblemLifeCycleStatusIdentifier
		    	set desc=$CASE(code,
		                   55561003:"Active",
		                   73425007:"Inactive",
		                   90734009:"Chronic",
		                   7087005:"Intermittent",
		                   255227004:"Recurrent",
		                   415684004:"Rule Out",
		                   410516002:"Ruled Out",
		                   413322009:"Resolved")   
		}
		elseif ("^ACTIVE^INACTIVE^CHRONIC^INTERMITTENT^RECURRENT^RULEOUT^RULEDOUT^RESOLVED^"[("^"_$ZSTRIP($ZCVT($$$PRBProblemLifeCycleStatusText,"U"),"*W")_"^")){
			set desc=$ZSTRIP($ZCVT($$$PRBProblemLifeCycleStatusText,"U"),"*W")
			set code=$CASE(desc,
		               "ACTIVE":55561003,
		               "INACTIVE":73425007,
		               "CHRONIC":90734009,
		               "INTERMITTENT":7087005,
		               "RECURRENT":255227004,
		               "RULEOUT":415684004,
		               "RULEDOUT":410516002,
		               "RESOLVED":413322009)
			//Put spaces back in, convert first letter of each word to uppercase (with rest lowercase)
			set desc=$ZCVT($CASE(desc,"RULEOUT":"Rule Out","RULEDOUT":"Ruled Out",:desc),"W")	               
		}
		elseif $$$PRBActualProblemResolutionDateTime'="" {
		set code=413322009, desc="Resolved"
		}
		else {
			set code=55561003, desc="Active"
		}
		do ..write(cr_"<Status>")
		do ..write(cr_"<SDACodingStandard>SNOMED CT</SDACodingStandard>")
		do ..write(cr_"<Code>"_code_"</Code>")
		do ..write(cr_"<Description>"_desc_"</Description>")
		do ..write(cr_"</Status>")
		kill code, desc
	}
	
	#; PRB-15 : Problem Life Cycle Status Date/Time
	#; PRB-2 : Action Date/Time
	if $$$PRBProblemLifeCycleStatusDateTime'="" {
		do ..write(cr_"<EnteredOn>"_..xmltimestamp($$$PRBProblemLifeCycleStatusDateTime)_"</EnteredOn>") }
	elseif $$$PRBActionDateTime'="" {
		do ..write(cr_"<EnteredOn>"_..xmltimestamp($$$PRBActionDateTime)_"</EnteredOn>") }
		
	#; PRB-16 : Problem Date of Onset
	#; PRB-7 : Problem Established Date/Time
	if $$$PRBProblemDateofOnset'="" {
		do ..write(cr_"<FromTime>"_..xmltimestamp($$$PRBProblemDateofOnset)_"</FromTime>") }
	elseif $$$PRBProblemEstablishedDateTime'="" {
		do ..write(cr_"<FromTime>"_..xmltimestamp($$$PRBProblemEstablishedDateTime)_"</FromTime>") }
		
	do ..write(cr_"<EnteredAt>")
 	do ..write(cr_"<Code>"_$$$MSHSendingFacilityNamespaceID_"</Code>")
 	do ..write(cr_"</EnteredAt>")
		
	#; NTE segment (repeating)
	do ..writecdata("ProblemDetails","NTE",3)

	#; ROL segment (repeating)
	#; The first ROL with ROL-3.1 (Role.Identifier) from code table 2.5:443 (Provider Role)
	#; will be used as the Problem.Clinician.
	#; The first ROL with ROL-3.1 = "TR" (for "Transcriptionist", from 2.6:443) will be
	#; used as Problem.EnteredBy.
	set clinicianFound=0, enteredByFound=0
	while $$$IsFollowing("ROL") {
		$$$GetFollowing("ROL")
		if ('clinicianFound)&&("^AD^AT^CP^FHCP^PP^RP^RT^"[("^"_$$$ROLRoleIdentifier_"^")) {
			do ..ROL("CareProvider","Clinician")
			set clinicianFound=1
		}
		elseif ('enteredByFound)&&($$$ROLRoleIdentifier="TR") {
			do ..ROL("User","EnteredBy")
			set enteredByFound=1
		}
		if (clinicianFound&&enteredByFound) { quit }
	}
	kill clinicianFound,enteredByFound
	
	do ..write(cr_"</Problem>")
}

ClassMethod PV1() As %Status
{

 #; $$$Find("PV1") - done in StartEncounters
 #if $$$HSDebug
	do ##class(HS.Util.HSDebug).Debug("PV1","HS.Gateway.HL7.HL7ToSDA3","txt",s)
 #endif

 #; PV1-10 : HospitalService
 if $$$PV1HospitalService'="" {
	set healthcarefacility=$$$PV1HospitalService
 } else {
	set healthcarefacility=$$$MSHSendingFacilityNamespaceID
 }

 #; PV1-2 : PatientClass
 do ..write(cr_"<EncounterType>"_$$$PV1PatientClass_"</EncounterType>")
	
 #; PV1-3 : AssignedPatientLocation
 if $$$PV1AssignedPatientLocationPointofCare '="" {
		do ..write(cr_"<AssignedWard>"_$$$PV1AssignedPatientLocationPointofCare_"</AssignedWard>")}
 if $$$PV1AssignedPatientLocationRoom '="" {
		do ..write(cr_"<AssignedRoom>"_$$$PV1AssignedPatientLocationRoom_"</AssignedRoom>")}
 if $$$PV1AssignedPatientLocationBed '="" {
		do ..write(cr_"<AssignedBed>"_$$$PV1AssignedPatientLocationBed_"</AssignedBed>")}

 #; PV1-4 : AdmissionType
 if $$$PV1AdmissionType'="" {
	do ..write(cr_"<AdmissionType>")
	do ..write(cr_"<Code>"_$$$PV1AdmissionType_"</Code>")
	do ..write(cr_"</AdmissionType>") 
 }

 #; PV1-5 : PreAdmissionNumber
 do ..write(cr_"<PreAdmissionNumber>"_$$$PV1PreadmitNumberIDNumber_"</PreAdmissionNumber>") 

 #; J2 PJH Pass in Suffix
 #; PV1-7 : AttendingDoctor
 do ..write(cr_"<AttendingClinicians>")	 
 set %occ="" for {
	set %occ=$$$PV1AttendingDoctor(%occ) quit:%occ=""
	do ..By("<CareProvider>",,
		"CareProvider",
		$$$PV1AttendingDoctorAssigningAuthority(%occ),
		$$$PV1AttendingDoctorIDNumber(%occ),
		$$$PV1AttendingDoctorFamilyNameSurname(%occ),
		$$$PV1AttendingDoctorGivenName(%occ),
		$$$PV1AttendingDoctorMiddleName(%occ),
		$$$PV1AttendingDoctorNamePrefix(%occ),
		$$$PV1AttendingDoctorNameSuffix(%occ))
 }
 do ..write(cr_"</AttendingClinicians>")	 

 #; J2 PJH Pass in Suffix
 #; PV1-8 : ReferringDoctor
 set %occ="" for {
	set %occ=$$$PV1ReferringDoctor(%occ) quit:%occ=""
	do ..By("<ReferringClinician>",,
		"ReferralDoctor",
		$$$PV1ReferringDoctorAssigningAuthority(%occ),
		$$$PV1ReferringDoctorIDNumber(%occ),
		$$$PV1ReferringDoctorFamilyNameSurname(%occ),
		$$$PV1ReferringDoctorGivenName(%occ),
		$$$PV1ReferringDoctorMiddleName(%occ),
		$$$PV1ReferringDoctorNamePrefix(%occ),
		$$$PV1ReferringDoctorNameSuffix(%occ))
	quit  // only one
 }

 #; J2 PJH Pass in Suffix
 #; PV1-9 : ConsultingDoctor
 do ..write(cr_"<ConsultingClinicians>")	 
 set %occ="" for {
	set %occ=$$$PV1ConsultingDoctor(%occ) quit:%occ=""
	do ..By("<CareProvider>",,
		"CareProvider",
		$$$PV1ConsultingDoctorAssigningAuthority(%occ),
		$$$PV1ConsultingDoctorIDNumber(%occ),
		$$$PV1ConsultingDoctorFamilyNameSurname(%occ),
		$$$PV1ConsultingDoctorGivenName(%occ),
		$$$PV1ConsultingDoctorMiddleName(%occ),
		$$$PV1ConsultingDoctorNamePrefix(%occ),
		$$$PV1ConsultingDoctorNameSuffix(%occ))
 }
 do ..write(cr_"</ConsultingClinicians>")	 

 #; PV1-10 : HospitalService
 if $$$PV1HospitalService'="" {
	do ..write(cr_"<HealthCareFacility>")
	do ..write(cr_"<Code>"_$$$PV1HospitalService_"</Code>")
	do ..write(cr_"<Organization>")
	do ..write(cr_"<Code>"_$$$MSHSendingFacilityNamespaceID_"</Code>")
	do ..write(cr_"</Organization>")	 
	do ..write(cr_"</HealthCareFacility>") 
 }

 #; PV1-14 : AdmitSource
 if $$$PV1AdmitSource'="" {
	do ..write(cr_"<AdmissionSource>")
	do ..write(cr_"<Code>"_$$$PV1AdmitSource_"</Code>")
	do ..write(cr_"</AdmissionSource>")
 }

 #; J2 PJH Pass in Suffix
 #; PV1-17 : AdmittingDoctor
 set %occ="" for {
	set %occ=$$$PV1AdmittingDoctor(%occ) quit:%occ=""
	do ..By("<AdmittingClinician>",,
		"CareProvider",
		$$$PV1AdmittingDoctorAssigningAuthority(%occ),
		$$$PV1AdmittingDoctorIDNumber(%occ),
		$$$PV1AdmittingDoctorFamilyNameSurname(%occ),
		$$$PV1AdmittingDoctorGivenName(%occ),
		$$$PV1AdmittingDoctorMiddleName(%occ),
		$$$PV1AdmittingDoctorNamePrefix(%occ),
		$$$PV1AdmittingDoctorNameSuffix(%occ))
	quit  // only one
 }

 #; PV1-19 : EncounterNumber
 do ..WriteEncounterNumber(encNum)

 // J2 PJH
 #; PV1-36 : PV1DischargeDisposition into SeparationMode
 if $$$PV1DischargeDisposition'="" {
	do ..write(cr_"<SeparationMode>")
	do ..write(cr_"<Code>"_$$$PV1DischargeDisposition_"</Code>")
	do ..write(cr_"</SeparationMode>") 
 }

 #; PV1-37 : DischargeLocation
 if $$$PV1DischargeLocation'="" {
	do ..write(cr_"<DischargeLocation>")
	do ..write(cr_"<Code>"_$$$PV1DischargeLocation_"</Code>")
	do ..write(cr_"</DischargeLocation>") 
 }

 #; PV1-44 : AdmitDateTime
 do ..write(cr_"<FromTime>"_..xmltimestamp($$$PV1AdmitDateTimeTime)_"</FromTime>")
 do ..write(cr_"<EnteredOn>"_..xmltimestamp($$$PV1AdmitDateTimeTime)_"</EnteredOn>")

 #; PV1-45 : DischargeDateTime
 set %occ="" for {
	set %occ=$$$PV1DischargeDateTime(%occ) quit:%occ=""
	do ..write(cr_"<ToTime>"_..xmltimestamp($$$PV1DischargeDateTimeTime(%occ))_"</ToTime>")
	quit  // only one
 }

 #; PID-18 : AccountNumber
 do ..write(cr_"<AccountNumber>"_$g(accountnumber)_"</AccountNumber>")

 #; J2 PJH Additional ","
 #; EVN-5 : OperatorID  -> EnteredBy in SuperClass
 if $$$EVN'="" {
	set %occ="" for {
		set %occ=$$$EVNOperator(%occ) quit:%occ=""
		do ..By("<EnteredBy>",,"User",
			$$$EVNOperatorIDAssigningAuthority(%occ),
			$$$EVNOperatorIDIDNumber(%occ),
			$$$EVNOperatorIDFamilyNameSurname(%occ),
			$$$EVNOperatorIDGivenName(%occ))
		quit  // only one
	}
 }

 #; MSH-4 : SendingFacility -> EnteredAt in SuperClass
 do ..write(cr_"<EnteredAt>")
 do ..write(cr_"<Code>"_$$$MSHSendingFacilityNamespaceID_"</Code>")
 do ..write(cr_"</EnteredAt>")

 quit $$$OK
}

ClassMethod PV2()
{
 $$$Find("PV2")
 #if $$$HSDebug
	do ##class(HS.Util.HSDebug).Debug("PV2","HS.Gateway.HL7.HL7ToSDA3","txt",s)
 #endif

 #; PV2-3 : AdmitReason
 if ($$$PV2AdmitReasonIdentifier'="")||($$$PV2AdmitReasonText'="") {
	do ..write(cr_"<AdmitReason>")
	do ..write(cr_"<SDACodingStandard>"_$$$PV2AdmitReasonNameofCodingSystem_"</SDACodingStandard>")
	do ..write(cr_"<Code>"_$$$PV2AdmitReasonIdentifier_"</Code>")
	do ..write(cr_"<Description>"_$$$PV2AdmitReasonText_"</Description>")
	do ..write(cr_"</AdmitReason>")
 }

 #; PV2-12 : VisitDescription
 do ..write(cr_"<VisitDescription>"_$$$PV2VisitDescription_"</VisitDescription>")

 /* NOT USED
 #; PV2-45 : AdvanceDirectiveCode
 set %occ="" for {
	set %occ=$$$PV2AdvanceDirective(%occ) quit:%occ=""
	do ..write(cr_"<AdvanceDirective>")
	do ..write(cr_"<SDACodingStandard>"_$$$PV2AdvanceDirectiveNameofCodingSystem(%occ)_"</SDACodingStandard>")
	do ..write(cr_"<Code>"_$$$PV2AdvanceDirectiveIdentifier(%occ)_"</Code>")
	do ..write(cr_"<Description>"_$$$PV2AdvanceDirectiveText(%occ)_"</Description>")
	do ..write(cr_"</AdvanceDirective>")
	quit  // only one
 }
 */
}

/// <parameter>mode</parameter> has 2 possible values: "CareProvider" and "User",
/// corresponding to which HS.SDA.CodeTableDetail class this segment should map to.
/// <parameter>tag</parameter> is the name of the element this ROL segment maps to in SDA.
ClassMethod ROL(mode As %String, tag As %String)
{
 #if $$$HSDebug
		do ##class(HS.Util.HSDebug).Debug("ROL","HS.Gateway.HL7.HL7ToSDA3","txt",s)
 #endif
 
 if (mode'="CareProvider")&&(mode'="User") { quit }
 do ..write(cr_"<"_tag_">")
 
 set %occ=""
 set %occ=$$$ROLRolePerson(%occ)  //Repeating field, only use the first.
 
 #; ROL-1   : Role Instance ID
 #; ROL-4.1 : Role Person.ID Number
 #; For Code+SDACodingStandard, look first at ROL-1, if blank then try ROL-4
 set (code,name,sdacodingstandard,last,lastprefix,first,middle,suffix,prefix,degree)=""
 if ($$$ROLRoleInstanceIDEntityIdentifier'="") { set code=$$$ROLRoleInstanceIDEntityIdentifier,sdacodingstandard=$$$ROLRoleInstanceIDNamespaceID }
 elseif (%occ'="")&&($$$ROLRolePersonIDNumber(%occ)'="") { set code=$$$ROLRolePersonIDNumber(%occ),sdacodingstandard=$$$ROLRolePersonAssigningAuthority(%occ) }
 
 #; ROL-4 : Role Person
 if (%occ'="") {
 	set last=$$$ROLRolePersonFamilyNameSurname(%occ)
 	set lastprefix=$$$ROLRolePersonFamilyNameOwnSurnamePrefix(%occ)  //ex: "von" in "von Neumann"
 	set first=$$$ROLRolePersonGivenName(%occ)
 	set middle=$$$ROLRolePersonMiddleName(%occ)
 	set suffix=$$$ROLRolePersonSuffix(%occ)		//Jr., Sr., III, ...
 	set prefix=$$$ROLRolePersonNamePrefix(%occ)	//Mr., Dr., Sir, ...
 	set degree=$$$ROLRolePersonDegree(%occ)		//MD, PhD, ...
 	set name=..formatname(last,first,middle,prefix)
 }
 
 do ..write(cr_"<SDACodingStandard>"_sdacodingstandard_"</SDACodingStandard>")
 do ..write(cr_"<Code>"_code_"</Code>")
 do ..write(cr_"<Description>"_name_"</Description>")
 
 if (mode="CareProvider") {
	 do ..write(cr_"<Name>")
	 do ..write(cr_"<FamilyName>"_last_"</FamilyName>")
	 do ..write(cr_"<FamilyNamePrefix>"_lastprefix_"</FamilyNamePrefix>")
	 do ..write(cr_"<NamePrefix>"_prefix_"</NamePrefix>")
	 do ..write(cr_"<NameSuffix>"_suffix_"</NameSuffix>")
	 do ..write(cr_"<GivenName>"_first_"</GivenName>")
	 do ..write(cr_"<MiddleName>"_middle_"</MiddleName>")
	 do ..write(cr_"<ProfessionalSuffix>"_degree_"</ProfessionalSuffix>")
	 do ..write(cr_"</Name>")
	 
	 #; ROL-9 : Provider Type
	 set %occ=""
	 set %occ=$$$ROLProviderType(%occ)  //Repeating field, only use the first.
	 if (%occ'="")&&($$$ROLProviderTypeIdentifier(%occ)'=""||$$$ROLProviderTypeText(%occ)'="") {
		do ..write(cr_"<CareProviderType>")
	 	do ..write(cr_"<SDACodingStandard>"_$$$ROLProviderTypeNameofCodingSystem(%occ)_"</SDACodingStandard>")
	 	do ..write(cr_"<Code>"_$$$ROLProviderTypeIdentifier(%occ)_"</Code>")
	 	do ..write(cr_"<Description>"_$$$ROLProviderTypeText(%occ)_"</Description>")
	 	do ..write(cr_"</CareProviderType>")
	 }
	 
	 #; ROL-11 : Office/Home Address/Birthplace
	 set %occ=""
	 set %occ=$$$ROLOfficeHomeAddressBirthplace(%occ)	//Repeating field, only use the first.
	 do ..write(cr_"<Address>")
	 do ..write(cr_"<Street>")
	 do ..write($$$ROLOfficeHomeAddressBirthplaceStreetAddress(%occ))
	 if ($$$ROLOfficeHomeAddressBirthplaceOtherDesignation(%occ)'="") {
		 do ..write("; "_$$$ROLOfficeHomeAddressBirthplaceOtherDesignation(%occ)) }
	 do ..write(cr_"</Street>")
	 if ($$$ROLOfficeHomeAddressBirthplaceCity(%occ)'="") {
		 do ..write(cr_"<City>")
		 do ..write(cr_"<Code>"_$$$ROLOfficeHomeAddressBirthplaceCity(%occ)_"</Code>")
		 do ..write(cr_"</City>")
	 }
	 if ($$$ROLOfficeHomeAddressBirthplaceStateorProvince(%occ)'="") {
		 do ..write(cr_"<State>")
		 do ..write(cr_"<Code>"_$$$ROLOfficeHomeAddressBirthplaceStateorProvince(%occ)_"</Code>")
		 do ..write(cr_"</State>")
	 }
	 if ($$$ROLOfficeHomeAddressBirthplaceZiporPostalCode(%occ)'="") {
		 do ..write(cr_"<Zip>")
		 do ..write(cr_"<Code>"_$$$ROLOfficeHomeAddressBirthplaceZiporPostalCode(%occ)_"</Code>")
		 do ..write(cr_"</Zip>")
	 }
	 if ($$$ROLOfficeHomeAddressBirthplaceCountry(%occ)'="") {
		 do ..write(cr_"<Country>")
		 do ..write(cr_"<Code>"_$$$ROLOfficeHomeAddressBirthplaceCountry(%occ)_"</Code>")
		 do ..write(cr_"</Country>")
	 }
	 if ($$$ROLOfficeHomeAddressBirthplaceCountyParishCode(%occ)'="") {
		 do ..write(cr_"<County>")
		 do ..write(cr_"<Code>"_$$$ROLOfficeHomeAddressBirthplaceCountyParishCode(%occ)_"</Code>")
		 do ..write(cr_"</County>")
	 }
	 do ..write(cr_"<FromTime>"_..xmltimestamp($$$ROLOfficeHomeAddressBirthplaceEffectiveDate(%occ))_"</FromTime>")
	 do ..write(cr_"<ToTime>"_..xmltimestamp($$$ROLOfficeHomeAddressBirthplaceExpirationDate(%occ))_"</ToTime>")
	 do ..write(cr_"</Address>")
	 
	 #; ROL-12 : Phone
	 do ..PhonesAndEmail(s,12,.homephone,.mobile,.email,.fax,.workphone)
	 set homephone=$P(homephone,"^"),mobile=$P(mobile,"^"),email=$P(email,"^"),workphone=$P(workphone,"^")
	 do ..write(cr_"<ContactInfo>")
	 do ..write(cr_"<HomePhoneNumber>"_homephone_"</HomePhoneNumber>")
	 do ..write(cr_"<WorkPhoneNumber>"_workphone_"</WorkPhoneNumber>")
	 do ..write(cr_"<MobilePhoneNumber>"_mobile_"</MobilePhoneNumber>")
	 do ..write(cr_"<EmailAddress>"_email_"</EmailAddress>")
	 do ..write(cr_"</ContactInfo>")
	 kill homephone,mobile,email,fax,workphone
 }
 kill last,lastprefix,first,middle,suffix,prefix,degree,name,code,sdacodingstandard
 
 do ..write(cr_"</"_tag_">")
 
 quit
}

/// RXA
ClassMethod RXA(mode As %String)
{
 $$$GetFollowing("RXA")
 #if $$$HSDebug
	do ##class(HS.Util.HSDebug).Debug("RXA","HS.Gateway.HL7.HL7ToSDA3.Segments","txt",s)
 #endif

 #; --------Medication--------------------------------------------

 #; RXA-5 : AdministeredCode
 do ..write(cr_"<DrugProduct>")
 do ..write(cr_"<SDACodingStandard>"_$$$RXAAdministeredCodeNameofCodingSystem_"</SDACodingStandard>")
 do ..write(cr_"<Code>"_$$$RXAAdministeredCodeIdentifier_"</Code>")
 do ..write(cr_"<Description>"_$$$RXAAdministeredCodeText_"</Description>")
 if ($$$RXAAdministeredCodeAltIdentifier'="")||($$$RXAAdministeredCodeAltText'="") {
		do ..write(cr_"<PriorCodes>")
		do ..write(cr_"<PriorCode>")
		do ..write(cr_"<CodeSystem>"_$$$RXAAdministeredCodeAltNameofCodingSystem_"</CodeSystem>")
		do ..write(cr_"<Code>"_$$$RXAAdministeredCodeAltIdentifier_"</Code>")
		do ..write(cr_"<Description>"_$$$RXAAdministeredCodeAltText_"</Description>")
		do ..write(cr_"<Type>A</Type>")
		do ..write(cr_"</PriorCode>")
		do ..write(cr_"</PriorCodes>")
	}
	if ($$$RXAAdministeredCodeOriginalText'="") {
		do ..write(cr_"<OriginalText>"_$$$RXAAdministeredCodeOriginalText_"</OriginalText>")
	}
 do ..write(cr_"</DrugProduct>")

 #; RXA-8 : AdministeredDosageForm
 if ($$$RXAAdministeredDosageFormIdentifier'="")||($$$RXAAdministeredDosageFormText'="") {
	do ..write(cr_"<DosageForm>")
	do ..write(cr_"<SDACodingStandard>"_$$$RXAAdministeredDosageFormNameofCodingSystem_"</SDACodingStandard>")
	do ..write(cr_"<Code>"_$$$RXAAdministeredDosageFormIdentifier_"</Code>")
	do ..write(cr_"<Description>"_$$$RXAAdministeredDosageFormText_"</Description>")
	do ..write(cr_"</DosageForm>")
 }

 #; RXA-12 : AdministeredPerTimeUnit  (see RXO-17)
 do ..write(cr_"<RateTimeUnit>"_$$$RXAAdministeredPerTimeUnit_"</RateTimeUnit>")

 #; RXA-13 : AdministeredStrength  (see RXO-18)
 do ..write(cr_"<DoseQuantity>"_$$$RXAAdministeredStrength_"</DoseQuantity>")

 #; RXA-14 : AdministeredStrengthUnits  (see RXO-22)
 if ($$$RXAAdministeredStrengthUnitsText'="")||($$$RXAAdministeredStrengthUnitsIdentifier'="") {
	do ..write(cr_"<DoseUoM>")
	do ..write(cr_"<SDACodingStandard>"_$$$RXAAdministeredStrengthUnitsNameofCodingSystem_"</SDACodingStandard>")
	do ..write(cr_"<Code>"_$$$RXAAdministeredStrengthUnitsIdentifier_"</Code>")
	do ..write(cr_"<Description>"_$$$RXAAdministeredStrengthUnitsText_"</Description>")
	do ..write(cr_"</DoseUoM>")
 }

 #; RXA-19 : Indication  (see RXO-20)
 set %occ="" for {
	set %occ=$$$RXAIndication(%occ) quit:%occ=""
	if $$$RXAIndicationText(%occ)'="" {
		do ..write(cr_"<Indication>"_$$$RXAIndicationText(%occ)_"</Indication>") 
	} else {
		do ..write(cr_"<Indication>"_$$$RXAIndicationIdentifier(%occ)_"</Indication>") 
	}
	quit  // only one
 }

 #; RXA-23 : AdministeredDrugStrengthVolu  (see RXO-25)
 do ..write(cr_"<StrengthVolume>"_$$$RXAAdministeredDrugStrengthVolu_"</StrengthVolume>")

 #; RXA-24 : AdministeredDrugStrengthUnit  (see RXO-26)
 if ($$$RXAAdministeredDrugStrengthUnitText'="") {
	do ..write(cr_"<StrengthVolumeUnits>"_$$$RXAAdministeredDrugStrengthUnitText_"</StrengthVolumeUnits>") 
 } else {
	do ..write(cr_"<StrengthVolumeUnits>"_$$$RXAAdministeredDrugStrengthUnitIdentifier_"</StrengthVolumeUnits>") 	 
 }

 #; --------Medication.Administrations------------------------------

 do ..write(cr_"<Administrations>")
 do ..write(cr_"<Administration>")

 #; RXA-3 : DateTimeStartofAdministratio
 do ..write(cr_"<FromTime>"_..xmltimestamp($$$RXADateTimeStartofAdministratioTime)_"</FromTime>")

 #; RXA-4 : DateTimeEndofAdministration
 do ..write(cr_"<ToTime>"_..xmltimestamp($$$RXADateTimeEndofAdministrationTime)_"</ToTime>")

 #; RXA-6 : AdministeredAmount
 do ..write(cr_"<AdministeredAmount>"_$$$RXAAdministeredAmount_"</AdministeredAmount>")

 #; RXA-7 : AdministeredUnits
 if $$$RXAAdministeredUnitsText'="" {
	do ..write(cr_"<AdministeredUnits>"_$$$RXAAdministeredUnitsText_"</AdministeredUnits>")
 } else {
	do ..write(cr_"<AdministeredUnits>"_$$$RXAAdministeredUnitsIdentifier_"</AdministeredUnits>")	 
 }

 #; RXA-9 : AdministrationNotes
 #;     make all the notes into a multi-line (crlf) string using Text or Identifier
 set (%occ,notes)="" for {
	set %occ=$$$RXAAdministrationNotes(%occ) quit:%occ=""
	if $$$RXAAdministrationNotesText(%occ)'="" {
		if notes'="" set notes=notes_cr
		set notes=notes_$$$RXAAdministrationNotesText(%occ)
	}
	elseif $$$RXAAdministrationNotesIdentifier(%occ)'="" {
		if notes'="" set notes=notes_cr
		set notes=notes_$$$RXAAdministrationNotesIdentifier(%occ)
	}
 }
 do ..write(cr_"<AdministrationNotes>"_notes_"</AdministrationNotes>")
 kill notes

 #; J2 PJH Pass in Suffix
 #; RXA-10 : AdministeringProvider
 set %occ="" for {
	set %occ=$$$RXAAdministeringProvider(%occ) quit:%occ=""
	do ..By("<AdministeringProvider>",,
		"CareProvider",
		$$$RXAAdministeringProviderAssigningAuthority(%occ),
		$$$RXAAdministeringProviderIDNumber(%occ),
		$$$RXAAdministeringProviderFamilyNameSurname(%occ),
		$$$RXAAdministeringProviderGivenName(%occ),
		$$$RXAAdministeringProviderMiddleName(%occ),
		$$$RXAAdministeringProviderNamePrefix(%occ),
		$$$RXAAdministeringProviderNameSuffix(%occ))
		quit  // only one
 }

 #; RXA-11 : AdministeredatLocation
 if $$$RXAAdministeredatLocationPointofCare'="" {
	do ..write(cr_"<AdministeredAtLocation>")
	do ..write(cr_"<Code>"_$$$RXAAdministeredatLocationPointofCare_"</Code>")
	do ..write(cr_"</AdministeredAtLocation>")
 }

 #; RXA-15 : SubstanceLotNumber
 set %occ="" for {
	set %occ=$$$RXASubstanceLotNumber(%occ) quit:%occ=""
	do ..write(cr_"<LotNumber>"_$$$RXASubstanceLotNumberValue(%occ)_"</LotNumber>")
	quit  // only one
 }

 #; RXA-16 : SubstanceExpirationDate
 set %occ="" for {
	set %occ=$$$RXASubstanceExpirationDate(%occ) quit:%occ=""
	do ..write(cr_"<ExpiryDate>"_..xmltimestamp($$$RXASubstanceExpirationDateTime(%occ))_"</ExpiryDate>")
	quit  // only one
 }

 #; RXA-17 : SubstanceManufacturerName
 set %occ="" for {
	set %occ=$$$RXASubstanceManufacturerName(%occ) quit:%occ=""
	if $$$RXASubstanceManufacturerNameText(%occ)'="" {
		do ..write(cr_"<ManufacturerName>"_$$$RXASubstanceManufacturerNameText(%occ)_"</ManufacturerName>")
	} else {
		do ..write(cr_"<ManufacturerName>"_$$$RXASubstanceManufacturerNameIdentifier(%occ)_"</ManufacturerName>")
	}
	quit  // only one
 }
 
 // J2 PJH - Added Refusal
 #; RXA-18 : Substance/Treatment Refusal Reason
 if $$$RXASubstanceRefusalIdentifier'="" {
	do ..write(cr_"<RefusalReason>")
	do ..write(cr_"<SDACodingStandard>"_$$$RXASubstanceRefusalNameofCodingSystem_"</SDACodingStandard>")
	do ..write(cr_"<Code>"_$$$RXASubstanceRefusalIdentifier_"</Code>")
	do ..write(cr_"<Description>"_$$$RXASubstanceRefusalText_"</Description>")
	do ..write(cr_"</RefusalReason>")
 }

 #; RXA-20 : CompletionStatus
 if $$$RXACompletionStatus'="" {
 	do ..write(cr_"<AdministrationStatus>")
 	do ..write(cr_"<Code>"_$$$RXACompletionStatus_"</Code>")
 	do ..write(cr_"</AdministrationStatus>")
 }

 #; RXA-22 : SystemEntryDateTime
 do ..write(cr_"<EnteredOn>"_..xmltimestamp($$$RXASystemEntryDateTimeTime)_"</EnteredOn>")

 // J2 - Ensure vxu can have RXR
 if $$$IsFollowing("RXR") {do ..RXRAdminSite()}

 do ..write(cr_"</Administration>")
 do ..write(cr_"</Administrations>")
}

ClassMethod RXC()
{
	$$$GetFollowing("RXC")
	
	do ..start("RXC",cr_"<ComponentMeds>")
	
	do ..write(cr_"<DrugProduct>")
	
	#; RXC-2 : ComponentCode
	if ($$$RXCComponentCodeIdentifier'="")||($$$RXCComponentCodeText'="") {
		do ..write(cr_"<Code>"_$$$RXCComponentCodeIdentifier_"</Code>")
		do ..write(cr_"<Description>"_$$$RXCComponentCodeText_"</Description>")
		do ..write(cr_"<SDACodingStandard>"_$$$RXCComponentCodeNameofCodingSystem_"</SDACodingStandard>")
		if ($$$RXCComponentCodeAltIdentifier'="")||($$$RXCComponentCodeAltText'="") {
			do ..write(cr_"<PriorCodes>")
			do ..write(cr_"<PriorCode>")
			do ..write(cr_"<CodeSystem>"_$$$RXCComponentCodeAltNameofCodingSystem_"</CodeSystem>")
			do ..write(cr_"<Code>"_$$$RXCComponentCodeAltIdentifier_"</Code>")
			do ..write(cr_"<Description>"_$$$RXCComponentCodeAltText_"</Description>")
			do ..write(cr_"<Type>A</Type>")
			do ..write(cr_"</PriorCode>")
			do ..write(cr_"</PriorCodes>")
		}
		do ..write(cr_"<OriginalText>"_$$$RXCComponentCodeOriginalText_"</OriginalText>")
	}
	
	#; RXC-5 : ComponentStrength
	do ..write(cr_"<StrengthQty>"_$$$RXCComponentStrength_"</StrengthQty>")
	
	#; RXC-6 : ComponentStrengthUnits
	if ($$$RXCComponentStrengthUnitsIdentifier'="")||($$$RXCComponentStrengthUnitsText) {
		do ..write(cr_"<StrengthUnits>")
		do ..write(cr_"<Code>"_$$$RXCComponentStrengthUnitsIdentifier_"</Code>")
		do ..write(cr_"<Description>"_$$$RXCComponentStrengthUnitsText_"</Description>")
		do ..write(cr_"<SDACodingStandard>"_$$$RXCComponentStrengthUnitsNameofCodingSystem_"</SDACodingStandard>")
		do ..write(cr_"</StrengthUnits>")
	}
	
	#; RXC-8 : ComponentDrugStrengthVolume
	do ..write(cr_"<BaseQty>"_$$$RXCComponentDrugStrengthVol_"</BaseQty>")
	
	#; RXC-9 : ComponentDrugStrengthVolumeUnits
	if ($$$RXCComponentDrugStrengthVolUnitsIdentifier'="")||($$$RXCComponentDrugStrengthVolUnitsText) {
		do ..write(cr_"<BaseUnits>")
		do ..write(cr_"<Code>"_$$$RXCComponentDrugStrengthVolUnitsIdentifier_"</Code>")
		do ..write(cr_"<Description>"_$$$RXCComponentDrugStrengthVolUnitsText_"</Description>")
		do ..write(cr_"<SDACodingStandard>"_$$$RXCComponentDrugStrengthVolUnitsNameofCodingSystem_"</SDACodingStandard>")
		do ..write(cr_"</BaseUnits>")
	}
	
	do ..write(cr_"</DrugProduct>")
}

ClassMethod RXE()
{
	$$$GetFollowing("RXE")
	
	#; RXE-1 : QuantityTiming (see also ORC-7, TQ1-2, -7, -8, -9, -10, -11)
	do ..write(cr_"<OrderQuantity>"_$$$RXEQuantityTimingQuantityQuantity_"</OrderQuantity>")
	if $$$RXEQuantityTimingDuration'="" {
		do ..write(cr_"<Duration>")
		do ..write(cr_"<Code>"_$$$RXEQuantityTimingDuration_"</Code>")
		do ..write(cr_"</Duration>")
	}
	do ..write(cr_"<FromTime>"_..xmltimestamp($$$RXEQuantityTimingStartDateTimeTime)_"</FromTime>")
	do ..write(cr_"<ToTime>"_..xmltimestamp($$$RXEQuantityTimingEndDateTimeTime)_"</ToTime>")
	if $$$RXEQuantityTimingPriority'="" {
		do ..write(cr_"<Priority>")
		do ..write(cr_"<Code>"_$$$RXEQuantityTimingPriority_"</Code>")
		do ..write(cr_"</Priority>")
	}
	do ..write(cr_"<Condition>"_$$$RXEQuantityTimingCondition_"</Condition>")
	do ..write(cr_"<TextInstruction>"_$$$RXEQuantityTimingText_"</TextInstruction>")
	
	#; RXE-2 : GiveCode
	if ($$$RXEGiveCodeIdentifier'="")||($$$RXEGiveCodeText'="") {
		do ..write(cr_"<DrugProduct>")
		do ..write(cr_"<SDACodingStandard>"_$$$RXEGiveCodeNameofCodingSystem_"</SDACodingStandard>")
		do ..write(cr_"<Code>"_$$$RXEGiveCodeIdentifier_"</Code>")
		do ..write(cr_"<Description>"_$$$RXEGiveCodeText_"</Description>")
		if ($$$RXEGiveCodeAltIdentifier'="")||($$$RXEGiveCodeAltText'="") {
			do ..write(cr_"<PriorCodes>")
			do ..write(cr_"<PriorCode>")
			do ..write(cr_"<CodeSystem>"_$$$RXEGiveCodeAltNameofCodingSystem_"</CodeSystem>")
			do ..write(cr_"<Code>"_$$$RXEGiveCodeAltIdentifier_"</Code>")
			do ..write(cr_"<Description>"_$$$RXEGiveCodeAltText_"</Description>")
			do ..write(cr_"<Type>A</Type>")
			do ..write(cr_"</PriorCode>")
			do ..write(cr_"</PriorCodes>")
		}
		if ($$$RXEGiveCodeOriginalText'="") {
			do ..write(cr_"<OriginalText>"_$$$RXEGiveCodeOriginalText_"</OriginalText>")
		}
		do ..write(cr_"</DrugProduct>")
	}
	
	#; RXE-3 : GiveAmountMinimum
 	do ..write(cr_"<DoseQuantity>"_$$$RXEGiveAmountMinimum_"</DoseQuantity>")

 	#; RXE-4 : GiveAmountMaximum
 	do ..write(cr_"<MaxDoseQuantity>"_$$$RXEGiveAmountMaximum_"</MaxDoseQuantity>")
 	
 	#; RXE-5 : GiveUnits
 	if ($$$RXEGiveUnitsIdentifier'="")||($$$RXEGiveUnitsText'="") {
		do ..write(cr_"<DoseUoM>")
		do ..write(cr_"<SDACodingStandard>"_$$$RXEGiveUnitsNameofCodingSyatem_"</SDACodingStandard>")
		do ..write(cr_"<Code>"_$$$RXEGiveUnitsIdentifier_"</Code>")
		do ..write(cr_"<Description>"_$$$RXEGiveUnitsText_"</Description>")
		do ..write(cr_"</DoseUoM>")
 	}
 	
 	#; RXE-6 : GiveDosageForm
 	if ($$$RXEGiveDosageFormIdentifier'="")||($$$RXEGiveDosageFormText'="") {
		do ..write(cr_"<DosageForm>")
		do ..write(cr_"<SDACodingStandard>"_$$$RXEGiveDosageFormNameofCodingSystem_"</SDACodingStandard>")
		do ..write(cr_"<Code>"_$$$RXEGiveDosageFormIdentifier_"</Code>")
		do ..write(cr_"<Description>"_$$$RXEGiveDosageFormText_"</Description>")
		do ..write(cr_"</DosageForm>")
	}
	
	#; RXE-7 : ProvidersAdministrationInstr
 	set %occ="" for {
		set %occ=$$$RXEProvidersAdministrationInstr(%occ) quit:%occ=""
		do ..write(cr_"<Route>")
		do ..write(cr_"<SDACodingStandard>"_$$$RXEProvidersAdministrationInstrNameofCodingSystem(%occ)_"</SDACodingStandard>")
		do ..write(cr_"<Code>"_$$$RXEProvidersAdministrationInstrIdentifier(%occ)_"</Code>")
		do ..write(cr_"<Description>"_$$$RXEProvidersAdministrationInstrText(%occ)_"</Description>")
		do ..write(cr_"</Route>")
		quit // only one
	}
	
	#; RXE-12 : NumberOfRefills
 	do ..write(cr_"<NumberOfRefills>"_$$$RXENumberOfRefills_"</NumberOfRefills>")
 	
 	#; RXE-13 : OrderingProvidersDEANumber  (see ORC-12)
 	set %occ="" for {
		set %occ=$$$RXEOrderingProvidersDEANumber(%occ) quit:%occ=""
		do ..By("<OrderedBy>",,
			"CareProvider",
			$$$RXEOrderingProvidersDEANumberAssigningAuthority(%occ),
			$$$RXEOrderingProvidersDEANumberIDNumber(%occ),
			$$$RXEOrderingProvidersDEANumberFamilyNameSurname(%occ),
			$$$RXEOrderingProvidersDEANumberGivenName(%occ),
			$$$RXEOrderingProvidersDEANumberMiddleName(%occ),
			$$$RXEOrderingProvidersDEANumberNamePrefix(%occ),
			$$$RXEOrderingProvidersDEANumberNameSuffix(%occ),
			$$$RXEOrderingProvidersDEANumberProfessionalSuffix(%occ))
		quit  // only one
 	}
 	
 	#; RXE-15 : PrescriptionNumber
 	do ..write("<PrescriptionNumber>"_$$$RXEPrescriptionNumber_"</PrescriptionNumber>")
 	
 	#; RXE-22 : GivePerTimeUnit
 	do ..write(cr_"<RateTimeUnit>"_$$$RXEGivePerTimeUnit_"</RateTimeUnit>")
 	
 	#; RXE-23 : GiveRateAmount
 	do ..write(cr_"<RateAmount>"_$$$RXEGiveRateAmount_"</RateAmount>")
 	
 	#; RXE-24 : GiveRateUnits
 	if ($$$RXEGiveRateUnitsText'="")||($$$RXEGiveRateUnitsIdentifier'="") {
		do ..write(cr_"<RateUnits>")
		do ..write(cr_"<SDACodingStandard>"_$$$RXEGiveRateUnitsNameofCodingSystem_"</SDACodingStandard>")
		do ..write(cr_"<Code>"_$$$RXEGiveRateUnitsIdentifier_"</Code>")
		do ..write(cr_"<Description>"_$$$RXEGiveRateUnitsText_"</Description>")
		do ..write(cr_"</RateUnits>")
 	}
 	
 	#; RXE-25 : GiveStrength
 	do ..write(cr_"<DoseQuantity>"_$$$RXEGiveStrength_"</DoseQuantity>")
 	
 	#; RXE-26 : GiveStrengthUnits
 	if ($$$RXEGiveStrengthUnitsIdentifier'="")||($$$RXEGiveStrengthUnitsText'="") {
		do ..write(cr_"<DoseUoM>")
		do ..write(cr_"<SDACodingStandard>"_$$$RXEGiveStrengthUnitsNameofCodingSystem_"</SDACodingStandard>")
		do ..write(cr_"<Code>"_$$$RXEGiveStrengthUnitsIdentifier_"</Code>")
		do ..write(cr_"<Description>"_$$$RXEGiveStrengthUnitsText_"</Description>")
		do ..write(cr_"</DoseUoM>")
	}
	
	#; RXE-27 : Indication
 	set %occ="" for {
		set %occ=$$$RXEIndication(%occ) quit:%occ=""
		if $$$RXEIndicationText(%occ)'="" {
			do ..write(cr_"<Indication>"_$$$RXEIndicationText(%occ)_"</Indication>") 
		} else {
			do ..write(cr_"<Indication>"_$$$RXEIndicationIdentifier(%occ)_"</Indication>") 
		}
		quit  // only one
 	}
 	
 	#; RXE-33 : GiveDrugStrengthVolume
 	do ..write(cr_"<StrengthVolume>"_$$$RXEGiveDrugStrengthVolume_"</StrengthVolume>")

 	#; RXE-34 : GiveDrugStrengthVolumeU
 	if ($$$RXEGiveDrugStrengthVolumeUnitsText'="") {
		do ..write(cr_"<StrengthVolumeUnits>"_$$$RXEGiveDrugStrengthVolumeUnitsText_"</StrengthVolumeUnits>") 
	 } else {
		do ..write(cr_"<StrengthVolumeUnits>"_$$$RXEGiveDrugStrengthVolumeUnitsIdentifier_"</StrengthVolumeUnits>") 	 
	 }
}

ClassMethod RXO()
{
 $$$GetFollowing("RXO")
 #if $$$HSDebug
	do ##class(HS.Util.HSDebug).Debug("RXO","HS.Gateway.HL7.HL7ToSDA3.Segments","txt",s)
 #endif

 #; RXO-1 : RequestedGiveCode

 if ($$$RXORequestedGiveCodeIdentifier'="")||($$$RXORequestedGiveCodeText'="") {
	do ..write(cr_"<DrugProduct>")
	do ..write(cr_"<SDACodingStandard>"_$$$RXORequestedGiveCodeNameofCodingSystem_"</SDACodingStandard>")
	do ..write(cr_"<Code>"_$$$RXORequestedGiveCodeIdentifier_"</Code>")
	do ..write(cr_"<Description>"_$$$RXORequestedGiveCodeText_"</Description>")
	if ($$$RXORequestedGiveCodeAltIdentifier'="")||($$$RXORequestedGiveCodeAltText'="") {
		do ..write(cr_"<PriorCodes>")
		do ..write(cr_"<PriorCode>")
		do ..write(cr_"<CodeSystem>"_$$$RXORequestedGiveCodeAltNameofCodingSystem_"</CodeSystem>")
		do ..write(cr_"<Code>"_$$$RXORequestedGiveCodeAltIdentifier_"</Code>")
		do ..write(cr_"<Description>"_$$$RXORequestedGiveCodeAltText_"</Description>")
		do ..write(cr_"<Type>A</Type>")
		do ..write(cr_"</PriorCode>")
		do ..write(cr_"</PriorCodes>")
	}
	if ($$$RXORequestedGiveCodeOriginalText'="") {
		do ..write(cr_"<OriginalText>"_$$$RXORequestedGiveCodeOriginalText_"</OriginalText>")
	}
	do ..write(cr_"</DrugProduct>")
 }

 #; RXO-2 : RequestedGiveAmountMinimum
 do ..write(cr_"<DoseQuantity>"_$$$RXORequestedGiveAmountMinimum_"</DoseQuantity>")

 #; RXO-3 : RequestedGiveAmountMaximum
 do ..write(cr_"<MaxDoseQuantity>"_$$$RXORequestedGiveAmountMaximum_"</MaxDoseQuantity>")

 #; RXO-4 : RequestedGiveUnits
 if ($$$RXORequestedGiveUnitsIdentifier'="")||($$$RXORequestedGiveUnitsText'="") {
	do ..write(cr_"<DoseUoM>")
	do ..write(cr_"<SDACodingStandard>"_$$$RXORequestedGiveUnitsNameofCodingSyatem_"</SDACodingStandard>")
	do ..write(cr_"<Code>"_$$$RXORequestedGiveUnitsIdentifier_"</Code>")
	do ..write(cr_"<Description>"_$$$RXORequestedGiveUnitsText_"</Description>")
	do ..write(cr_"</DoseUoM>")
 }

 #; RXO-5 :  RequestedDosageForm
 if ($$$RXORequestedDosageFormIdentifier'="")||($$$RXORequestedDosageFormText'="") {
	do ..write(cr_"<DosageForm>")
	do ..write(cr_"<SDACodingStandard>"_$$$RXORequestedDosageFormNameofCodingSystem_"</SDACodingStandard>")
	do ..write(cr_"<Code>"_$$$RXORequestedDosageFormIdentifier_"</Code>")
	do ..write(cr_"<Description>"_$$$RXORequestedDosageFormText_"</Description>")
	do ..write(cr_"</DosageForm>")
 }

 #; RXO-6 :  ProvidersPharmacyTreatmentIn
 set %occ="" for {
	set %occ=$$$RXOProvidersPharmacyTreatmentIn(%occ) quit:%occ=""
	do ..write(cr_"<DrugProduct>")
	do ..write(cr_"<SDACodingStandard>"_$$$RXOProvidersPharmacyTreatmentInNameofCodingSystem(%occ)_"</SDACodingStandard>")
	do ..write(cr_"<Code>"_$$$RXOProvidersPharmacyTreatmentInIdentifier(%occ)_"</Code>")
	do ..write(cr_"<Description>"_$$$RXOProvidersPharmacyTreatmentInText(%occ)_"</Description>")
	if ($$$RXOProvidersPharmacyTreatmentInAltIdentifier(%occ)'="")||($$$RXOProvidersPharmacyTreatmentInAltText(%occ)'="") {
		do ..write(cr_"<PriorCodes>")
		do ..write(cr_"<PriorCode>")
		do ..write(cr_"<CodeSystem>"_$$$RXOProvidersPharmacyTreatmentInAltNameofCodingSystem(%occ)_"</CodeSystem>")
		do ..write(cr_"<Code>"_$$$RXOProvidersPharmacyTreatmentInAltIdentifier(%occ)_"</Code>")
		do ..write(cr_"<Description>"_$$$RXOProvidersPharmacyTreatmentInAltText(%occ)_"</Description>")
		do ..write(cr_"<Type>A</Type>")
		do ..write(cr_"</PriorCode>")
		do ..write(cr_"</PriorCodes>")
	}
	if ($$$RXOProvidersPharmacyTreatmentInOriginalText(%occ)'="") {
		do ..write(cr_"<OriginalText>"_$$$RXOProvidersPharmacyTreatmentInOriginalText(%occ)_"</OriginalText>")
	}
	do ..write(cr_"</DrugProduct>")
	quit  // only one
 }

 #; RXO-7 : ProvidersAdministrationInstr
 set %occ="" for {
	set %occ=$$$RXOProvidersAdministrationInstr(%occ) quit:%occ=""
	do ..write(cr_"<Route>")
	do ..write(cr_"<SDACodingStandard>"_$$$RXOProvidersAdministrationInstrNameofCodingSystem(%occ)_"</SDACodingStandard>")
	do ..write(cr_"<Code>"_$$$RXOProvidersAdministrationInstrIdentifier(%occ)_"</Code>")
	do ..write(cr_"<Description>"_$$$RXOProvidersAdministrationInstrText(%occ)_"</Description>")
	do ..write(cr_"</Route>")
	quit // only one
 }

 #; RXO-13 : NumberOfRefills
 do ..write(cr_"<NumberOfRefills>"_$$$RXONumberOfRefills_"</NumberOfRefills>")

 #; RXO-14 : OrderingProvidersDEANumber  (see ORC-12, OBR-16)
 set %occ="" for {
	set %occ=$$$RXOOrderingProvidersDEANumber(%occ) quit:%occ=""
	do ..By("<OrderedBy>",,
		"CareProvider",
		$$$RXOOrderingProvidersDEANumberAssigningAuthority(%occ),
		$$$RXOOrderingProvidersDEANumberIDNumber(%occ),
		$$$RXOOrderingProvidersDEANumberFamilyNameSurname(%occ),
		$$$RXOOrderingProvidersDEANumberGivenName(%occ),
		$$$RXOOrderingProvidersDEANumberMiddleName(%occ),
		$$$RXOOrderingProvidersDEANumberNamePrefix(%occ),
		$$$RXOOrderingProvidersDEANumberNameSuffix(%occ),
		$$$RXOOrderingProvidersDEANumberProfessionalSuffix(%occ))
	quit  // only one
 }

 #; RXO-17 : RequestedGivePerTimeUnit  (see RXA-14)
 do ..write(cr_"<RateTimeUnit>"_$$$RXORequestedGivePerTimeUnit_"</RateTimeUnit>")

 #; RXO-18 : RequestedGiveStrength
 do ..write(cr_"<DoseQuantity>"_$$$RXORequestedGiveStrength_"</DoseQuantity>")

 #; RXO-19 : RequestedGiveStrengthUnits
 if ($$$RXORequestedGiveStrengthUnitsIdentifier'="")||($$$RXORequestedGiveStrengthUnitsText'="") {
	do ..write(cr_"<DoseUoM>")
	do ..write(cr_"<SDACodingStandard>"_$$$RXORequestedGiveStrengthUnitsNameofCodingSystem_"</SDACodingStandard>")
	do ..write(cr_"<Code>"_$$$RXORequestedGiveStrengthUnitsIdentifier_"</Code>")
	do ..write(cr_"<Description>"_$$$RXORequestedGiveStrengthUnitsText_"</Description>")
	do ..write(cr_"</DoseUoM>")
 }

 #; RXO-20 : Indication  (see RXA-19)
 set %occ="" for {
	set %occ=$$$RXOIndication(%occ) quit:%occ=""
	if $$$RXOIndicationText(%occ)'="" {
		do ..write(cr_"<Indication>"_$$$RXOIndicationText(%occ)_"</Indication>") 
	} else {
		do ..write(cr_"<Indication>"_$$$RXOIndicationIdentifier(%occ)_"</Indication>") 
	}
	quit  // only one
 }

 #; RXO-21 : RequestedGiveRateAmount  (see RXA-12)
 do ..write(cr_"<RateAmount>"_$$$RXORequestedGiveRateAmount_"</RateAmount>")

 #; RXO-22 : RequestedGiveRateUnits  (see RXA-13)
 if ($$$RXORequestedGiveRateUnitsText'="")||($$$RXORequestedGiveRateUnitsIdentifier'="") {
	do ..write(cr_"<RateUnits>")
	do ..write(cr_"<SDACodingStandard>"_$$$RXORequestedGiveRateUnitsNameofCodingSystem_"</SDACodingStandard>")
	do ..write(cr_"<Code>"_$$$RXORequestedGiveRateUnitsIdentifier_"</Code>")
	do ..write(cr_"<Description>"_$$$RXORequestedGiveRateUnitsText_"</Description>")
	do ..write(cr_"</RateUnits>")
 }

 #; RXO-25 : RequestedDrugStrengthVolume  (see RXA-23)
 do ..write(cr_"<StrengthVolume>"_$$$RXORequestedDrugStrengthVolume_"</StrengthVolume>")

 #; RXO-26 : RequestedDrugStrengthVolumeU  (see RXA-24)
 if ($$$RXORequestedDrugStrengthVolumeUText'="") {
	do ..write(cr_"<StrengthVolumeUnits>"_$$$RXORequestedDrugStrengthVolumeUText_"</StrengthVolumeUnits>") 
 } else {
	do ..write(cr_"<StrengthVolumeUnits>"_$$$RXORequestedDrugStrengthVolumeUIdentifier_"</StrengthVolumeUnits>") 	 
 }
}

ClassMethod RXR()
{
	$$$GetFollowing("RXR")
	
	#; RXR-1 : Route
 	if ($$$RXRRouteIdentifier'="")||($$$RXRRouteText'="") {
		do ..write(cr_"<Route>")
		do ..write(cr_"<SDACodingStandard>"_$$$RXRRouteNameofCodingSystem_"</SDACodingStandard>")
		do ..write(cr_"<Code>"_$$$RXRRouteIdentifier_"</Code>")
		do ..write(cr_"<Description>"_$$$RXRRouteText_"</Description>")
		do ..write(cr_"</Route>")
 	}
}

ClassMethod RXRAdminSite()
{
	$$$GetFollowing("RXR")
	
	#; RXR-2 : Administration Site
 	if ($$$RXRAdministrationSiteIdentifier'="")||($$$RXRAdministrationSiteText'="") {
		do ..write(cr_"<AdministrationSite>")
		do ..write(cr_"<SDACodingStandard>"_$$$RXRAdministrationSiteNameofCodingSystem_"</SDACodingStandard>")
		do ..write(cr_"<Code>"_$$$RXRAdministrationSiteIdentifier_"</Code>")
		do ..write(cr_"<Description>"_$$$RXRAdministrationSiteText_"</Description>")
		do ..write(cr_"</AdministrationSite>")
 	}
 	#; "Rewind" RXR segment
	Set s = s-1
}

ClassMethod SCH()
{
	$$$Find("SCH")
 	do ..write(cr_"<Appointments>")
 	do ..write(cr_"<Appointment>")
 	Do ..OnAppointment()
 	if ($D(encNum)) { do ..WriteEncounterNumber(encNum) }
 	#; SCH-1 : PlacerAppointmentID
 	#; SCH-2 : FillerAppointmentID
 	#; SCH-3 : OccurrenceNumber
 	set placerApptId = $$$SCHPlacerAppointmentID
 	set fillerApptId = $$$SCHFillerAppointmentID
 	set occNum = $$$SCHOccurrenceNumber
 	if (occNum '= "") {
	 	if (placerApptId '= "") { set placerApptId = placerApptId_":"_occNum }
	 	if (fillerApptId '= "") { set fillerApptId = fillerApptId_":"_occNum }
 	}
 	do ..write(cr_"<PlacerApptId>"_placerApptId_"</PlacerApptId>")
 	do ..write(cr_"<FillerApptId>"_fillerApptId_"</FillerApptId>")
 	// If a delete, just set the ActionCode and quit here.
 	if (msgType = "SIU_S17") {
	 	do ..write(cr_"<ActionCode>D</ActionCode>")
	 	do ..write(cr_"</Appointment>")
	 	do ..write(cr_"</Appointments>")
	 	#; RGS segment is required but not used
		$$$Find("RGS")
	 	quit
 	}
 	// SIU_S15 and 16 set the Status
 	set status = $CASE(msgType, "SIU_S15":"CANCELLED", "SIU_S16":"DC", :"")
 	if (status'="") { do ..write(cr_"<Status>"_status_"</Status>") }
 	// SIU_S26 sets NoShow
 	if (msgType = "SIU_S26") { do ..write(cr_"<NoShow>1</NoShow>") }
 	
 	
 	#; SCH-7 : AppointmentReason
 	if ($$$SCHAppointmentReasonIdentifier'="")||($$$SCHAppointmentReasonText'="") {
	 	do ..write(cr_"<Type>")
	 	do ..write(cr_"<SDACodingStandard>"_$$$SCHAppointmentReasonNameofCodingSystem_"</SDACodingStandard>")
 		do ..write(cr_"<Code>"_$$$SCHAppointmentReasonIdentifier_"</Code>")
 		do ..write(cr_"<Description>"_$$$SCHAppointmentReasonText_"</Description>")
 		do ..write(cr_"</Type>")
 	}
 	
 	#; SCH-9 : AppointmentDuration
 	#; SCH-10 : AppointmentDurationUnits
 	#; SCH-11 : AppointmentTimingQuantity
 	#; TQ1-6 : ServiceDuration
 	#; TQ1-7 : StartDateTime
 	#; TQ1-8 : EndDateTime
 	// A TQ1 is supposed to be used for the start and end time, the SCH fields are only supported for backwards compatibility.
 	// Check first for a TQ1 following the SCH, and if none, look at the SCH fields.
 	// In either case, if there is a start time and duration but no end time, end time is calculated, but only if the units
 	// of the duration is one of "M", "MINUTES", "H", or "HOURS", case-insensitive
 	if ($$$IsFollowing("TQ1")) {
	 	$$$GetFollowing("TQ1")
	 	set durationQuantity = $$$TQ1ServiceDurationQuantity
	 	set durationUnits = $system.Util.Collation($$$TQ1ServiceDurationUnitsIdentifier,6)  // ALPHAUP
	 	set fromTime = $$$TQ1StartdatetimeTime
	 	set toTime = $$$TQ1EnddatetimeTime
	 	// Switch context back to SCH segment
	 	set s = s - 1
 	}
 	else {
	 	set durationQuantity = $$$SCHAppointmentDuration
	 	set durationUnits = $system.Util.Collation($$$SCHAppointmentDurationUnitsIdentifier,6)  // ALPHAUP
	 	set (fromTime,toTime)=""
		set %occ="" for {
			set %occ = $$$SCHTimingQuantity(%occ) quit:%occ=""
			set fromTime = $$$SCHTimingQuantityStartDateTime(%occ)
			set toTime = $$$SCHTimingQuantityEndDateTime(%occ)
			quit  // only one
		}
 	}
 	if ((fromTime'="")&&(toTime="")&&($IsValidNum(durationQuantity))&&(",M,MINUTES,H,HOURS,"[(","_durationUnits_","))) {
	 	// Calculate ToTime from FromTime and Duration
	 	// Convert duration to seconds
	 	if ($E(durationUnits) = "M") { set durationQuantity = durationQuantity * 60 }
	 	else { set durationQuantity = durationQuantity * 3600 }
	 	// Convert FromTime to horolog format
	 	set dateTimeH=..HL7ToHorolog(fromTime), dateH=$P(dateTimeH,",",1), timeH=$P(dateTimeH,",",2)
	 	set timeH = timeH + durationQuantity
	 	// Check to see if the duration incremented the date. Not likely, but just in case.
	 	set secondsPerDay = 86400
	 	if (timeH >= secondsPerDay) {
		 	set dateH = dateH + timeH\secondsPerDay // Will also take care of cases where date is incremented by >1
		 	set timeH = timeH # secondsPerDay
	 	}
	 	// and finally convert to xml format
	 	set fromTime = $TR($ZDT(dateTimeH, 3), " ", "T")_"Z"
	 	set toTime = $TR($ZDT(dateH_","_timeH, 3), " ", "T")_"Z"
	 	do ..write(cr_"<FromTime>"_fromTime_"</FromTime>")
	 	do ..write(cr_"<ToTime>"_toTime_"</ToTime>")
 	}
 	else {
		do ..write(cr_"<FromTime>"_..xmltimestamp(fromTime)_"</FromTime>")
	 	do ..write(cr_"<ToTime>"_..xmltimestamp(toTime)_"</ToTime>")
 	}
 	
 	#; SCH-20 : EnteredByPerson
 	set %occ="" for {
		set %occ=$$$SCHEnteredByPerson(%occ) quit:%occ=""
		do ..By("<EnteredBy>",,"User",
			$$$SCHEnteredByPersonAssigningAuthority(%occ),
			$$$SCHEnteredByPersonIDNumber(%occ),
			$$$SCHEnteredByPersonFamilyNameSurname(%occ),
			$$$SCHEnteredByPersonGivenName(%occ))
		quit  // only one
	}
	
	#; SCH-22 : EnteredAtLocation
	if ($$$SCHEnteredAtLocation '= "") { set enteredAt = $$$SCHEnteredAtLocation }
	else { set enteredAt = $$$MSHSendingFacilityNamespaceID }
	do ..write(cr_"<EnteredAt>")
	do ..write(cr_"<Code>"_enteredAt_"</Code>")
	do ..write(cr_"</EnteredAt>")
	
	#; SCH-26 : PlacerOrderNumber
	do ..write("<PlacerOrderId>"_$$$SCHPlacerOrderNumber_"</PlacerOrderId>")
	#; SCH-27 : FillerOrderNumber
	do ..write("<FillerOrderId>"_$$$SCHFillerOrderNumber_"</FillerOrderId>")
	
	#; NTE segment (repeating)
	#; NTEs will follow the TQ1, if present, so first find them, then go back 1 segment because
	#; writecdata will advance the context one segment
	if $$$Next("NTE") {
		set s = $$$Next("NTE")
		// Make sure we are following either the SCH or TQ1
		if ((^||HS.Data(s-1)="SCH")||(^||HS.Data(s-1)="TQ1")) { set s=s-1 do ..writecdata("Notes","NTE",3) }
	}
	
	#; RGS segment is required but not used
	$$$Find("RGS")	
	if $$$Next("AIS") do ..AIS()
	if $$$Next("AIP") do ..AIP()
	if $$$Next("AIL") do ..AIL()
	
	do ..write(cr_"</Appointment>")
	do ..write(cr_"</Appointments>")
}

ClassMethod SFT()
{
 $$$Find("SFT")
 #if $$$HSDebug
	do ##class(HS.Util.HSDebug).Debug("SFT","HS.Gateway.HL7.HL7ToSDA3","txt",s)
 #endif
}

/// J2
/// Write out a Code Table Translated
ClassMethod writeCodeTableTranslated(pTag As %String, pCode As %String = "", pDescription As %String = "", pCodingStandard As %String = "", pCodeSystemVersion As %String = "", pPriorCode As %String = "", pPriorDescription As %String = "", pPriorCodeSystem As %String = "", pPriorCodeSystemVersion As %String = "", pOriginalText As %String = "")
{
 do ..write(cr_"<"_pTag_">")
	do ..write(cr_"<Code>"_pCode_"</Code>")
	do ..write(cr_"<Description>"_pDescription_"</Description>")
	do ..write(cr_"<SDACodingStandard>"_pCodingStandard_"</SDACodingStandard>")
	do ..write(cr_"<CodeSystemVersionId>"_pCodeSystemVersion_"</CodeSystemVersionId>")
	if (pPriorCode'="")||(pPriorDescription'=""){
		do ..write(cr_"<PriorCodes>")
		do ..write(cr_"<PriorCode>")
		do ..write(cr_"<Code>"_pPriorCode_"</Code>")
		do ..write(cr_"<Description>"_pPriorDescription_"</Description>")
		do ..write(cr_"<CodeSystem>"_pPriorCodeSystem_"</CodeSystem>")
		do ..write(cr_"<CodeSystemVersionId>"_pPriorCodeSystemVersion_"</CodeSystemVersionId>")
		do ..write(cr_"<Type>A</Type>")
		do ..write(cr_"</PriorCode>")
		do ..write(cr_"</PriorCodes>")
	}
	do ..write(cr_"<OriginalText>"_pOriginalText_"</OriginalText>")
 do ..write(cr_"</"_pTag_">")
}

/// J2 PJH - Added in SPM
ClassMethod SPM()
{
 $$$GetFollowing("SPM")

 #if $$$HSDebug
	do ##class(HS.Util.HSDebug).Debug("SPM","HS.Gateway.HL7.HL7ToSDA3","txt",s)
 #endif
 
 do ..write(cr_"<Specimen>")
 #; OBR-11 - SpecimenActionCode
 if ($g(specimenActionCode)'="") do ..write(cr_"<ActionCode>"_specimenActionCode_"</ActionCode>")
 
 #; SPM-2 : Specimen External ID
 do ..write(cr_"<ExternalId>"_$$$SPMExternalId_"</ExternalId>")

 #; SPM-4 - Specimen Type -- one and only one allowed
 Do ..writeCodeTableTranslated("SpecimenType",
	 $$$SPMTypeIdentifer,
	 $$$SPMTypeDescription,
	 $$$SPMTypeNameofCodingSystem,
	 $$$SPMTypeCodeSystemVersionId,
	 $$$SPMTypeAltIdentifer,
	 $$$SPMTypeAltDescription,
	 $$$SPMTypeAltNameofCodingSystem,
	 $$$SPMTypeAltCodeSystemVersionId
 )

 #; SPM-5 - Specimen Types Modifier
 do ..write(cr_"<SpecimenTypeModifiers>")
 Set %occ="" for {
	 set %occ=$$$SPMTypeModifier(%occ) quit:%occ=""
	 Do ..writeCodeTableTranslated("SpecimenTypeModifier",
		 $$$SPMTypeModifierIdentifier(%occ),
		 $$$SPMTypeModifierDescription(%occ),
		 $$$SPMTypeModifierNameofCodingSystem(%occ),
		 $$$SPMTypeModifierCodeSystemVersionId(%occ),
		 $$$SPMTypeModifierAltIdentifer(%occ),
		 $$$SPMTypeModifierAltDescription(%occ),
		 $$$SPMTypeModifierAltNameofCodingSystem(%occ),
		 $$$SPMTypeModifierAltCodeSystemVersionId(%occ)
 	)
 }
 do ..write(cr_"</SpecimenTypeModifiers>")

 #; SPM-6 - Specimen Additive
 do ..write(cr_"<SpecimenAdditives>")
 Set %occ="" for {
	 set %occ=$$$SPMAdditive(%occ) quit:%occ=""
	 Do ..writeCodeTableTranslated("SpecimenAdditive",
		 $$$SPMAdditiveIdentifier(%occ),
		 $$$SPMAdditiveDescription(%occ),
		 $$$SPMAdditiveNameofCodingSystem(%occ),
		 $$$SPMAdditiveCodeSystemVersionId(%occ),
		 $$$SPMAdditiveAltIdentifer(%occ),
		 $$$SPMAdditiveAltDescription(%occ),
		 $$$SPMAdditiveAltNameofCodingSystem(%occ),
		 $$$SPMAdditiveAltCodeSystemVersionId(%occ)
 	)
 }
 do ..write(cr_"</SpecimenAdditives>")

 #; SPM-7 - Collection Method
 Do ..writeCodeTableTranslated("CollectionMethod",
	 $$$SPMCollectionMethodIdentifer,
	 $$$SPMCollectionMethodDescription,
	 $$$SPMCollectionMethodNameofCodingSystem,
	 $$$SPMCollectionMethodCodeSystemVersionId,
	 $$$SPMCollectionMethodAltIdentifer,
	 $$$SPMCollectionMethodAltDescription,
	 $$$SPMCollectionMethodAltNameofCodingSystem,
	 $$$SPMCollectionMethodAltCodeSystemVersionId
 )

 #; SPM-8 - Specimen Source Site
 Do ..writeCodeTableTranslated("SpecimenSourceSite",
	 $$$SPMSourceSiteIdentifer,
	 $$$SPMSourceSiteDescription,
	 $$$SPMSourceSiteNameofCodingSystem,
	 $$$SPMSourceSiteCodeSystemVersionId,
	 $$$SPMSourceSiteAltIdentifer,
	 $$$SPMSourceSiteAltDescription,
	 $$$SPMSourceSiteAltNameofCodingSystem,
	 $$$SPMSourceSiteAltCodeSystemVersionId
 )

 #; SPM-9 - Specimen Source Site Modifier
 do ..write(cr_"<SpecimenSourceSiteModifiers>")
 Set %occ="" for {
	 set %occ=$$$SPMSourceSiteModifier(%occ) quit:%occ=""
	 Do ..writeCodeTableTranslated("SpecimenSourceSiteModifier",
		 $$$SPMSourceSiteModifierIdentifer(%occ),
		 $$$SPMSourceSiteModifierDescription(%occ),
		 $$$SPMSourceSiteModifierNameofCodingSystem(%occ),
		 $$$SPMSourceSiteModifierCodeSystemVersionId(%occ),
		 $$$SPMSourceSiteModifierAltIdentifer(%occ),
		 $$$SPMSourceSiteModifierAltDescription(%occ),
		 $$$SPMSourceSiteModifierAltNameofCodingSystem(%occ),
		 $$$SPMSourceSiteModifierAltCodeSystemVersionId(%occ)
 	)
 }
 do ..write(cr_"</SpecimenSourceSiteModifiers>")
 
 #; SPM-11 - Specimen Roles
 do ..write(cr_"<SpecimenRoles>")
 Set %occ="" for {
	 set %occ=$$$SPMSpecimenRole(%occ) quit:%occ=""
	 Do ..writeCodeTableTranslated("SpecimenRole",
		 $$$SPMSpecimenRoleIdentifer(%occ),
		 $$$SPMSpecimenRoleDescription(%occ),
		 $$$SPMSpecimenRoleNameofCodingSystem(%occ),
		 $$$SPMSpecimenRoleCodeSystemVersionId(%occ),
		 $$$SPMSpecimenRoleAltIdentifer(%occ),
		 $$$SPMSpecimenRoleAltDescription(%occ),
		 $$$SPMSpecimenRoleAltNameofCodingSystem(%occ),
		 $$$SPMSpecimenRoleAltCodeSystemVersionId(%occ)
 	)
 }
 do ..write(cr_"</SpecimenRoles>")
 
 #; SPM-12.1 - Collection Amounts
 do ..write(cr_"<CollectionAmount>"_$$$SPMCollectionAmountQuantity_"</CollectionAmount>")
 
 #; SPM-12.1 - Collection Amounts Unit of Measure
  Do ..writeCodeTableTranslated("CollectionAmountUnits",
	 $$$SPMCollectionAmountIdentifer,
	 $$$SPMCollectionAmountDescription,
	 $$$SPMCollectionAmountNameofCodingSystem,
	 $$$SPMCollectionAmountCodeSystemVersionId,
 )
 
 #; SPM-17.1 - Specimen Collection Date/Time -- Start
 do ..write(cr_"<FromTime>"_..xmltimestamp($$$SPMSpecimenCollectionDateTimeStart)_"</FromTime>")

 #; SPM-17.2 - Specimen Collection Date/Time -- End
 do ..write(cr_"<ToTime>"_..xmltimestamp($$$SPMSpecimenCollectionDateTimeEnd)_"</ToTime>")

 #; SPM-18 - Specimen Received Date/Time 
 do ..write(cr_"<EnteredOn>"_..xmltimestamp($$$SPMSpecimenReceivedDateTime)_"</EnteredOn>")
 
 #; SPM-21 - Specimen Reject Reason
 do ..write(cr_"<RejectReasons>")
 Set %occ="" for {
	 set %occ=$$$SPMSpecimenRejectReason(%occ) quit:%occ=""
	 Do ..writeCodeTableTranslated("SpecimenRejectReason",
		 $$$SPMSpecimenRejectReasonIdentifier(%occ),
		 $$$SPMSpecimenRejectReasonDescription(%occ),
		 $$$SPMSpecimenRejectReasonNameofCodingSystem(%occ),
		 $$$SPMSpecimenRejectReasonCodeSystemVersionId(%occ),
		 $$$SPMSpecimenRejectReasonAltIdentifier(%occ),
		 $$$SPMSpecimenRejectReasonAltDescription(%occ),
		 $$$SPMSpecimenRejectReasonAltNameofCodingSystem(%occ),
		 $$$SPMSpecimenRejectReasonAltCodeSystemVersionId(%occ),
		 $$$SPMSpecimenRejectReasonOriginalText(%occ)
 	)
 }
 do ..write(cr_"</RejectReasons>")
 
 #; SPM-22 - Specimen Quality
 Do ..writeCodeTableTranslated("Quality",
	 $$$SPMSpecimenQualityIdentifier,
	 $$$SPMSpecimenQualityDescription,
	 $$$SPMSpecimenQualityNameofCodingSystem,
	 $$$SPMSpecimenQualityCodeSystemVersionId,
	 $$$SPMSpecimenQualityAltIdentifier,
	 $$$SPMSpecimenQualityAltDescription,
	 $$$SPMSpecimenQualityAltNameofCodingSystem,
	 $$$SPMSpecimenQualityAltCodeSystemVersionId,
	 $$$SPMSpecimenQualityOriginalText
 )
 
 #; SPM-23 - Specimen Appropriateness
 Do ..writeCodeTableTranslated("Appropriateness",
	 $$$SPMSpecimenAppropriatenessIdentifier,
	 $$$SPMSpecimenAppropriatenessDescription,
	 $$$SPMSpecimenAppropriatenessNameofCodingSystem,
	 $$$SPMSpecimenAppropriatenessCodeSystemVersionId,
	 $$$SPMSpecimenAppropriatenessAltIdentifier,
	 $$$SPMSpecimenAppropriatenessAltDescription,
	 $$$SPMSpecimenAppropriatenessAltNameofCodingSystem,
	 $$$SPMSpecimenAppropriatenessAltCodeSystemVersionId,
	 $$$SPMSpecimenAppropriatenessOriginalText
 )
 
 #; SPM-24 - Specimen Condition
 do ..write(cr_"<Condition>")
 Set %occ="" for {
	 set %occ=$$$SPMSpecimenCondition(%occ) quit:%occ=""
	 Do ..writeCodeTableTranslated("SpecimenCondition",
		 $$$SPMSpecimenConditionIdentifier(%occ),
		 $$$SPMSpecimenConditionDescription(%occ),
		 $$$SPMSpecimenConditionNameofCodingSystem(%occ),
		 $$$SPMSpecimenConditionCodeSystemVersionId(%occ),
		 $$$SPMSpecimenConditionAltIdentifier(%occ),
		 $$$SPMSpecimenConditionAltDescription(%occ),
		 $$$SPMSpecimenConditionAltNameofCodingSystem(%occ),
		 $$$SPMSpecimenConditionAltCodeSystemVersionId(%occ),
		 $$$SPMSpecimenConditionOriginalText(%occ)
 	)
 }
 do ..write(cr_"</Condition>")
 
 #; check if there is an OBX after SPM if so it is always the age of the specimen
 If $$$IsFollowing("OBX"){
 	$$$GetFollowing("OBX")
	 do ..write("<Age>"_$$$OBXObservationValueAll_"</Age>")	
 	 Do ..writeCodeTableTranslated("AgeUnits",
	 	$$$OBXUnitsIdentifier,
	 	$$$OBXUnitsText,
	 	$$$OBXUnitsNameofCodingSystem,
	 	$$$OBXUnitsCodeSystemVersionId,
	 )
 }
 do ..write(cr_"</Specimen>")
}

ClassMethod TQ1()
{

 // PP - need to make a new order for each of these (except the first)	
	
 $$$GetFollowing("TQ1")
 #if $$$HSDebug
	do ##class(HS.Util.HSDebug).Debug("TQ1","HS.Gateway.HL7.HL7ToSDA3","txt",s)
 #endif

 #; TQ1-2 : Quantity  (see ORC-7.1, OBR-27.1)
 do ..write(cr_"<OrderQuantity>"_$$$TQ1QuantityQuantity_"</OrderQuantity>")

 #; TQ1-3 : RepeatPattern
 set %occ="" for {
	set %occ=$$$TQ1RepeatPattern(%occ) quit:%occ=""
	do ..write(cr_"<Frequency>") 
	do ..write(cr_"<Code>"_$$$TQ1RepeatPatternRepeatPatternCodeIdentifier(%occ)_"</Code>")
	do ..write(cr_"<Description>"_$$$TQ1RepeatPatternRepeatPatternCodeText(%occ)_"</Description>")
	do ..write(cr_"<Factor>"_$$$TQ1RepeatPatternPeriodQuantity(%occ)_"</Factor>")
	do ..write(cr_"</Frequency>")
	quit  // only one
 }

 #; TQ1-6 : ServiceDuration
 set quan=$$$TQ1ServiceDurationQuantity
 set code=$$$TQ1ServiceDurationUnitsIdentifier
 set desc=$$$TQ1ServiceDurationUnitsText
 if quan_code_desc '="" {  // |quan^code&desc|
	set factor=""
	if quan'="" {
		if code_desc="" set code=quan						// e.g. |Daily|		= |1^Daily&Daily|
		set factor=$s(+quan:+quan,1:"")						// e.g. |2 Days|	= |2^2 Days&2 Days|
		if +quan,'+code set code=+quan_code					// e.g. |2^D|		= |2^2D&2D|
		if +quan,$l(desc),'+desc set desc=+quan_" "_desc	// e.g. |2^D&Days|	= |2^2D&2 Days|
	}
	else {
		if +code {set factor=+code}  						// e.g. |^2D|		= |2^2D&2D|
		elseif +desc {set factor=+desc}  					// e.g. |^&3W|		= |3^3W&3W|
	}
	do ..write(cr_"<Duration>")
	do ..write(cr_"<Code>"_code_"</Code>")
	do ..write(cr_"<Description>"_desc_"</Description>")
	do ..write(cr_"<Factor>"_factor_"</Factor>")
	do ..write(cr_"</Duration>")
 } 
 kill quan,code,desc,factor
 
 #; TQ1-7 : Startdatetime  (see ORC-7.4, OBR-27.4, OBR-6)
 do ..write(cr_"<FromTime>"_..xmltimestamp($$$TQ1StartdatetimeTime)_"</FromTime>")

 #; TQ1-8 : Enddatetime  (see ORC-7.5, OBR-27.5)
 do ..write(cr_"<ToTime>"_..xmltimestamp($$$TQ1EnddatetimeTime)_"</ToTime>")

 #; TQ1-9 : Priority  (see ORC-7.6, OBR-27.6)
 set %occ="" for {
	set %occ=$$$TQ1Priority(%occ) quit:%occ=""
	do ..write(cr_"<Priority>")
	do ..write(cr_"<SDACodingStandard>"_$$$TQ1PriorityNameofCodingSystem(%occ)_"</SDACodingStandard>")
	do ..write(cr_"<Code>"_$$$TQ1PriorityIdentifier(%occ)_"</Code>")
	do ..write(cr_"<Description>"_$$$TQ1PriorityText(%occ)_"</Description>")
	do ..write(cr_"</Priority>")
	quit  // only one
 }

 #; TQ1-10 : Conditiontext  (see ORC-7.7, OBR-27.7)
 do ..write(cr_"<Condition>"_$$$TQ1Conditiontext_"</Condition>")

 #; TQ1-11 : Textinstruction  (see ORC-7.8, OBR-27.8)
 do ..write(cr_"<TextInstruction>"_$$$TQ1Textinstruction_"</TextInstruction>")
}

ClassMethod TXA()
{
 
	$$$Find("TXA")
	#if $$$HSDebug
		do ##class(HS.Util.HSDebug).Debug("TXA","HS.Gateway.HL7.HL7ToSDA3","txt",s)
	#endif

	do ..start("TXA",cr_"<Documents>")
	do ..write(cr_"<Document>")
	Do ..OnDocument()
	do ..WriteEncounterNumber(encNum)

	#; TXA-1 : SetIDTXA ("" means inactivate all, """" means delete all)
	if $$$TXASetIDTXA="""""" {
		do ..write(cr_"<ActionCode>I</ActionCode></Document>") quit
 	}
	elseif $$$TXASetIDTXA="""""""""" {
		do ..write(cr_"<ActionCode>C</ActionCode></Document>") quit
 	}

	#; MDM^T11 is Delete Document
	if msgType="MDM_T11" do ..write(cr_"<ActionCode>D</ActionCode>")

	#; TXA-2 : DocumentType
	#; For "DS", default Description to "DischargeSummary" (JLD190)
	if $$$TXADocumentType = "DS" {
		do ..write(cr_"<DocumentType>")
		do ..write(cr_"<Code>DS</Code>")
		do ..write(cr_"<Description>DischargeSummary</Description>")
		do ..write(cr_"</DocumentType>")
	}
	elseif $$$TXADocumentType'="" {
		do ..write(cr_"<DocumentType>")
		do ..write(cr_"<Code>"_$$$TXADocumentType_"</Code>")
		do ..write(cr_"</DocumentType>")
	}

	#; TXA-4 : ActivityDateTime
	do ..write(cr_"<DocumentTime>"_..xmltimestamp($$$TXAActivityDateTimeTime)_"</DocumentTime>")
	
	#; TXA-5 : PrimaryActivityProviderCodeName
	set %occ="" for {
		set %occ=$$$TXAPrimaryActivityProviderCodeName(%occ) quit:%occ=""
		do ..By("<Clinician>",,
			"CareProvider",
			$$$TXAPrimaryActivityProviderCodeNameAssigningAuthority(%occ),
			$$$TXAPrimaryActivityProviderCodeNameIDNumber(%occ),
 			$$$TXAPrimaryActivityProviderCodeNameFamilyNameSurname(%occ),
			$$$TXAPrimaryActivityProviderCodeNameGivenName(%occ),
			$$$TXAPrimaryActivityProviderCodeNameMiddleName(%occ),
			$$$TXAPrimaryActivityProviderCodeNamePrefix(%occ),
			$$$TXAPrimaryActivityProviderCodeNameSuffix(%occ),
			$$$TXAPrimaryActivityProviderCodeProfessionalSuffix(%occ))
 		quit  // only one
	}

	#; TXA-7 : TranscriptionDateTime
	do ..write(cr_"<TranscriptionTime>"_..xmltimestamp($$$TXATranscriptionDateTimeTime)_"</TranscriptionTime>")
	
	#; TXA-9 : OriginatorCodeName
	set %occ="" for {
		set %occ=$$$TXAOriginatorCodeName(%occ) quit:%occ=""
		do ..By("<EnteredBy>",,"User",
			$$$TXAOriginatorCodeNameAssigningAuthority(%occ),
			$$$TXAOriginatorCodeNameIDNumber(%occ),
			$$$TXAOriginatorCodeNameFamilyNameSurname(%occ),
			$$$TXAOriginatorCodeNameGivenName(%occ))
		quit  // only one
	}
	
	#; TXA-12 : UniqueDocumentNumber
	do ..write(cr_"<DocumentNumber>"_$$$TXAUniqueDocumentNumber_"</DocumentNumber>")
	
	#; TXA-16 : UniqueDocumentFileName
	do ..write(cr_"<DocumentName>"_$$$TXAUniqueDocumentFileName_"</DocumentName>")
	
	#; TXA-17 : DocumentCompletionStatus
	if $$$TXADocumentCompletionStatus'="" {
		do ..write(cr_"<DocumentCompletionStatus><Code>"_$$$TXADocumentCompletionStatus_"</Code></DocumentCompletionStatus>")}
	
	#; TXA-19 : DocumentAvailabilityStatus
	if $$$TXADocumentAvailabilityStatus'="" {
		do ..write(cr_"<Status><Code>"_$$$TXADocumentAvailabilityStatus_"</Code></Status>")}
	
	#; TXA-22 : AuthenticationPersonTimeStamp
	do ..write(cr_"<AuthorizationTime>"_..xmltimestamp($$$TXAAuthenticationPersonTimeStampDateTimeActionPerformed)_"</AuthorizationTime>")
	
	#; MSH-4 : SendingFacility -> EnteredAt in SuperClass 
	do ..write(cr_"<EnteredAt>")
	do ..write(cr_"<Code>"_$$$MSHSendingFacilityNamespaceID_"</Code>")
	do ..write(cr_"</EnteredAt>")

	#; OBX
	if $$$IsFollowing("OBX") {do ..OBX("mdm")}

	do ..write(cr_"</Document>")
}

ClassMethod UB1()
{
 $$$Find("UB1")
 #if $$$HSDebug
	do ##class(HS.Util.HSDebug).Debug("UB1","HS.Gateway.HL7.HL7ToSDA3","txt",s)
 #endif
}

ClassMethod UB2()
{
 $$$Find("UB2")
 #if $$$HSDebug
	do ##class(HS.Util.HSDebug).Debug("UB2","HS.Gateway.HL7.HL7ToSDA3","txt",s)
 #endif
}

/// Add to XML buffer, and possibly write it to the output stream
ClassMethod write(s As %String)
{
 #; if s is just [cr]<xxx>[cr]</xxx> ignore it 
 set ss=$tr(s,$c(13,10))
 if ss?1"<"1.an1"></"1.an1">" quit
 #; check for XMLBuffer ending with [aaa][cr]<xxx> and s=[cr]</xxx>[bbb]
 #; replace with XMLBuffer ending with [aaa] and s=[bbb]
 if ss?1"</".e {
	set xxx=$e($p(ss,">",1),3,*)
	if $e(XMLBuffer,*-$l(xxx)-1,*)=("<"_xxx_">") {
		set XMLBuffer=$e(XMLBuffer,1,*-$l(xxx)-2),s=$p(s,">",2,999)
		if $e(XMLBuffer,*-1,*)=$c(13,10) set XMLBuffer=$e(XMLBuffer,1,*-2)
	}
 }
 if s'="" {
	 set XMLBuffer=XMLBuffer_s
	 if $L(XMLBuffer)>30000 {
		do pXML.Write(XMLBuffer)
		set XMLBuffer=""
	 }
 }
}

/// Output <segment> value as CData (optionally with NTE(<segment2>))
ClassMethod writecdata(tag As %String, segment As %String, fieldnum As %Integer, segment2 As %String, fieldnum2 As %Integer)
{
 $$$GetFollowing(segment)  // will quit if no more
 set text=..gettext(segment,fieldnum,$g(segment2),$g(fieldnum2))
 if text="" quit
 do ..write(cr_"<"_tag_"><![CDATA["_text_"]]></"_tag_">")
 kill text
}

/// Get text from <segment> value (optionally followed by NTE(<segment2>))
ClassMethod gettext(segment As %String, fieldnum As %Integer, segment2 As %String, fieldnum2 As %Integer) As %String
{
 #; for each following <segment>  (the first is already in focus)
 #;   get the value from <fieldnum>
 #;   append value (if repeating concatenate)
 #;   for each <segment2> if any [currently only one]
 #;     get the value from <fieldnum>
 #;     append value (if repeating concatenate), making sure you don't go over the long string limit
 set text="",max=3600000,isED=0
 for {
	#if $$$HSDebug
		do ##class(HS.Util.HSDebug).Debug("gettext("_segment_")","HS.Gateway.HL7.HL7ToSDA3","txt",s)
	#endif
	if (segment="NTE")&&(fieldnum=3) {
		set val=$$$NTEComment
	} elseif (segment="OBX")&&(fieldnum=5) {
		if $$$OBXValueType'="ED" {
			set val=$$$OBXObservationValueAllNoCVT  // [repeating]
		} else {
			set isED=1
			set val=$$$OBXObservationValueEDData
		}
	} else {
		quit
	}
	for vi=1:1:$l(val,s3) {  // repeating
		continue:$l(text)>max
		set text=text_$p(val,s3,vi)_cr
	}
	if $g(segment2)'="" {
		while $$$IsFollowing(segment2) {
			$$$GetFollowing(segment2)
			#if $$$HSDebug
				do ##class(HS.Util.HSDebug).Debug("gettext("_segment2_")","HS.Gateway.HL7.HL7ToSDA3","txt",s)
			#endif
			if (segment2="NTE")&&(fieldnum2=3) {set val=$$$NTEComment}
			else {quit}
			for vi=1:1:$l(val,s3) {  // repeating
				continue:$l(text)>max
				set text=text_$p(val,s3,vi)_cr
			}
		} 	
	}
	$$$GetFollowing(segment)  // will quit if no more
 }
 kill val,v1
 if isED=0 set text=..unescape(text)
 quit $e(text,1,*-2)_$s($l(text)>=max:"...",1:"") // leave off trailing $c(13,10) and possibly show continuation indicatior
}

/// Convert HL7 date to XML date
ClassMethod xmltimestamp(dt As %String) As %String
{
 quit:dt="""""" dt
 #; Convert an HL7 date of the form yyyymmddhhnnss into a
 #; standard XML date format yyyy-mm-ddThh:nn:ssZ
 #; If invalid, return ""
 new yyyy,mm,dd,hh,nn,ss,valid,tz
 set tz="+"_$zstrip($p(dt,"+",2),"<>W")
 set:tz="+" tz="-"_$zstrip($p(dt,"-",2),"<>W")
 If tz="-" {
	 Set tz="Z"
 }Else{
	 set tz = $E(tz,1,3)_":"_$E(tz,4,*)
 }
 set:dt["+" dt=$zstrip($p(dt,"+"),"<>W") quit:$c(0)[dt ""
 set:dt["-" dt=$zstrip($p(dt,"-"),"<>W") quit:$c(0)[dt ""
 #; extract yyyy,mm,dd,hh,nn,ss
 set yyyy=$e(dt,1,4),mm=$e(dt,5,6),dd=$e(dt,7,8),hh=$e(dt,9,10),nn=$e(dt,11,12),ss=$e(dt,13,14)
 #; default mm and dd to 01
 set:mm="" mm=1 set:dd="" dd=1
 #; convert to yyyy-mm-dd hh:nn:ss
 set dt=yyyy_"-"_$e(100+mm,2,3)_"-"_$e(100+dd,2,3)_" "_$e(100+hh,2,3)_":"_$e(100+nn,2,3)_":"_$e(100+ss,2,3)
 #; validate
 set valid=$zdth(dt,8,1,,,,,,,0) if valid=0 quit ""
 #; convert to yyyy-mm-ddThh:nn:ssZ
 quit $tr(dt," ","T")_tz
}

/// Convert an HL7 timestamp to horolog ($H) format
ClassMethod HL7ToHorolog(dt As %String) As %String
{
	// First transform YYYYMMDDhhmm to YYYYMMDDThh:mm
	set dt = $E(dt,1,8)_"T"_$E(dt,9,10)_":"_$E(dt,11,12)
	quit $ZDTH(dt,8,2)
}

/// Patient Number Identifier Codes
ClassMethod idtype(value As %String) As %String
{
 if (value="MR")||(value="MRN")||(value="PI") quit "MRN"
 If ##class(HS.Registry.Config).GetKeyValue("\General\LegacyPatientIdentifierTypeRestriction",0) {
	 if (value="SSN")||(value="DL")||(value="XX")||(value="PPN")||(value="SNC")||(value="NI") quit value
	 if (value="") quit ""
	 quit "OTH"
 }
 Quit value
}

/// Order Status Codes
ClassMethod orderstatus(value As %String) As %String
{
 if (value="DC") quit "D"
 if (value="CA") quit "C"
 if (value="RP") quit "R"
 if (value="HD") quit "H"
 if (value="IP")||(value="SC") quit "IP"
 if (value="CM") quit "E"
 quit value
}

/// Make a 'By' tag from the supplied fields for 
/// User, CareProvider, ReferralDoctor
/// J2 PJH - Allow NameSuffix, ProfSuffix, remove close tage to be a boolean option and closer in parameter list
ClassMethod By(tag As %String, bclosetag As %Boolean = 1, table As %String, codingstandard As %String, code As %String, last As %String, first As %String, middle As %String = "", prefix As %String = "", suffix As %String = "", profsuffix As %String = "", nametypecode As %String = "", idtypecode As %String = "")
{
 set name=..formatname(last,first,middle,prefix)
 if code="",name="" quit	
 do ..write(cr_tag)
 do ..write(cr_"<SDACodingStandard>"_codingstandard_"</SDACodingStandard>")
 do ..write(cr_"<Code>"_code_"</Code>")
 do ..write(cr_"<Description>"_name_"</Description>")
 // J2 PJH - Allow table="ResultsInterpreter"
 if (table="CareProvider")||(table="ReferralDoctor")||(table="ResultsInterpreter")||(table="MedicalDirector") {
	do ..write(cr_"<NameTypeCode>"_nametypecode_"</NameTypeCode>")
	do ..write(cr_"<IdentifierTypeCode>"_idtypecode_"</IdentifierTypeCode>")
	do ..write(cr_"<Name>")
	do ..write(cr_"<FamilyName>"_last_"</FamilyName>") 
	do ..write(cr_"<GivenName>"_first_"</GivenName>") 
	do ..write(cr_"<MiddleName>"_middle_"</MiddleName>") 
	do ..write(cr_"<NamePrefix>"_prefix_"</NamePrefix>")
	// J2 PJH
	do ..write(cr_"<NameSuffix>"_suffix_"</NameSuffix>")
	do ..write(cr_"<ProfessionalSuffix>"_profsuffix_"</ProfessionalSuffix>")
	do ..write(cr_"</Name>")
 }
 if +bclosetag do ..write(cr_$Extract(tag,1)_"/"_$Extract(tag,2,$Length(tag)))
}

/// If both last and first are given, returns the name as last_", "_first<br>
/// Else if last is given, returns last<br>
/// Else if first is given, returns first<br>
/// Else returns ""
ClassMethod formatname(last As %String, first As %String, middle As %String, prefix As %String) As %String
{
 set name=""
 if $l(last) {
	set name=last
	if $l(first) {
		set name=name_", "_first}	
 } elseif $l(first) {
	set name=first}
 quit name
}

/// Get next occurence (after occ, if any) that has any data for the field, else ""
ClassMethod occ(field As %String, occ As %Integer) As %Integer
{
 for occ=occ+1:1 {
	if $p(field,s3,occ,9999)="" set occ="" quit
	if $p(field,s3,occ)'="" quit}
 quit occ
}

/// XML-escape all data when fetched
ClassMethod xml(text As %String) As %String
{
	 quit $zconvert(text,"O","XML")
}

/// Start an order, possibly with enclosing element
ClassMethod StartOrder()
{
	set tOrderType=$zcvt($$$ORCOrderTypeIdentifier,"U")

	if tOrderType="RAD" {
		set tOrder="RadOrder"
	} elseIf (tOrderType="LAB") {
		set tOrder="LabOrder"
	} else {
		set tOrder="OtherOrder"
	}
	do ..EndOrder(tOrder)
	do ..start("ORCORD",cr_"<"_tOrder_"s>")
	do ..start("Order",cr_"<"_tOrder_">")
	If (tOrder="RadOrder"){
		Do ..OnRadOrder()
	}
	ElseIf (tOrder = "LabOrder"){
		Do ..OnLabOrder()
	}
	Else{
		Do ..OnOtherOrder()
	}
}

/// End an order, and possibly its enclosing elmement
ClassMethod EndOrder(order As %String = "*LAST*")
{
 if '$d(open("Order")) quit  // segment not started yet
 do ..end("Order")
 do:$G(open("ORCORD"))'[order_"s" ..end("ORCORD")
}

/// Delete or inactivate an order
ClassMethod RemoveOrder(mode As %String, type As %String)
{
	do ..write(cr_"<ActionCode>"_type_"</ActionCode>")
	if mode="lab" {
		do ..write(cr_"<Result>")	
		do ..write(cr_"<ResultType>AT</ResultType>")
		do ..write(cr_"</Result>")
	} elseif mode="txt" {
		do ..write(cr_"<Result/>") ; To indicate that the removed order had a result
	} elseif mode="ord" {
		// Orders (with and without results) are closed elsewhere, in EndOrder
	} else {
		do ..write(cr_"</"_$case(mode,"med":"Medication","omp":"Medication","vxu":"Vaccination")_">")
 	} 
 	
 	// skip following (some required) segments
	for seg="RXO","OBR","TQ1","RXA","OBR","NTE" {while $$$IsFollowing(seg) {$$$GetFollowing(seg)}}
	if type="C" for seg="RXE","RXE" {while $$$IsFollowing(seg) {$$$GetFollowing(seg)}}
}

/// Output <tag> if this is the first occurrence of <seg>
ClassMethod start(seg As %String, tag As %String)
{
 #; open(seg)=tag  ; tag is cr<xxx>
 if '$d(open(seg)) do ..write(tag) set open(seg)=tag
}

/// Output closing </tag> if it was opened
ClassMethod end(seg As %String)
{
 if '$d(open(seg)) quit  // segment not used
 set tag=open(seg) do ..write($p(tag,"<",1)_"</"_$p(tag,"<",2))
 kill open(seg),tag
}

/// Generate an encounter number when none is provided
ClassMethod GenerateEncounterNumber() As %String [ CodeMode = expression ]
{
$tr($zts,",.","")_$R(10000)
}

/// Add encounter number to encounter-related data stored at the same level as the encounter
ClassMethod WriteEncounterNumber(pEncNum)
{
 do ..write(cr_"<EncounterNumber>"_pEncNum_"</EncounterNumber>")
}

/// This method is meant to be called by the OnValidate method of any Ensemble HL7 Service that
/// expects to receive messages with ADD segments.  Per the HL7 spec, it takes the content of each
/// ADD segment and appends it to the end of the preceding segment, then removes the ADD segment.<br><br>
/// The arguments to this method are the same as those to OnValidate.  Also note that for the 
/// OnValidate method to be called, the Validation property of the class has to be set to a non-null value.
ClassMethod ParseADDSegs(pDoc As EnsLib.EDI.Document, pValSpec As %String, Output pStatus As %Status) As %Boolean
{
	set tI = ""
	for {
		set tADDSeg = pDoc.FindSegment("ADD", .tI, .pStatus)
		if (tI = "") { quit }
		set tADDVal = $P(tADDSeg.GetValueAt(""), "ADD|", 2)
		set tVal = pDoc.GetSegmentAt(tI-1).GetValueAt("")_tADDVal
		set tSeg = ##class(EnsLib.HL7.Segment).ImportFromString(tVal)
		set pStatus = pDoc.SetSegmentAt(tSeg, tI-1)
		set pStatus = pDoc.RemoveSegmentAt(tI)
		set tI = tI - 1
	}
	Quit 0
}

/// Callback method for custom processing of Allergy streamlet
ClassMethod OnAllergy()
{
	Quit
}

/// Callback method for custom processing of Appointment streamlet
ClassMethod OnAppointment()
{
	Quit
}

/// Callback method for custom processing of Diagnosis streamlet
ClassMethod OnDiagnosis()
{
	Quit
}

/// Callback method for custom processing of Document streamlet
ClassMethod OnDocument()
{
	Quit
}

/// Callback method for custom processing of Encounter streamlet
ClassMethod OnEncounter()
{
	Quit
}

/// Callback method for custom processing of LabOrder streamlet
ClassMethod OnLabOrder()
{
	Quit
}

/// Callback method for custom processing of Medication streamlet
ClassMethod OnMedication()
{
	Quit
}

/// Callback method for custom processing of Observation streamlet
ClassMethod OnObservation()
{
	Quit
}

/// Callback method for custom processing of OtherOrder streamlet
ClassMethod OnOtherOrder()
{
	Quit
}

/// Callback method for custom processing of Patient streamlet
ClassMethod OnPatient()
{
	Quit
}

/// Callback method for custom processing of Problem streamlet
ClassMethod OnProblem()
{
	Quit
}

/// Callback method for custom processing of Procedure streamlet
ClassMethod OnProcedure()
{
	Quit
}

/// Callback method for custom processing of RadOrder streamlet
ClassMethod OnRadOrder()
{
	Quit
}

/// Callback method for custom processing of Vaccination streamlet
ClassMethod OnVaccination()
{
	Quit
}

/// Callback method to enable addition of custom streamlets and streamlets from non-standard segments to SDA
ClassMethod OnBeforeEndContainer()
{
	Quit
}

}
