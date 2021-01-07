/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Used in a conjunction with a com.intersystems.gateway.bh.BusinessService to create a Java
/// Business Service which treats incoming data as HL7 Messages.
Class EnsLib.HL7.Service.JavaService Extends (Ens.Java.Service.Standard, EnsLib.HL7.Service.Standard) [ Abstract ]
{

/// ConfigName(s) of the operations or processes to which reply (e.g. ACK) messages should be forwarded.
Property AckTargetConfigNames As %String;

Parameter SETTINGS = "AckTargetConfigNames:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

/* (override default value for Setting inherited from base class) */
/// Control of ACK handling; options:
/// - Never : Do not send back any ACK
/// - Immediate : Send back (commit) ACK reply message immediately upon receipt of the inbound message
/// - Application : If message passes validation, wait for ACK from target config item and forward it back when it arrives
/// - MSH-determined : Send back ACK reply messages as requested in the MSH header of the incoming message
Property AckMode As %String(DISPLAYLIST = ",Never,Immediate,Application,MSH-determined", VALUELIST = ",Never,Immed,App,Msh") [ InitialExpression = "Never", Required ];

ClassMethod OnProductionStart(pConfigName) As %Status
{
	#dim tSC As %Status = $$$OK
	
	Set tSC = ##super(pConfigName)
	Quit:$$$ISERR(tSC) tSC
	
	#dim tAckTargetConfigNames, tAckMode, tOldJob As %String
	
	Do {
		Set tSC = ##class(Ens.Java.Utils).GetSetting(pConfigName,"AckTargetConfigNames",.tAckTargetConfigNames)
		Quit:$$$ISERR(tSC)
		Set tSC = ##class(Ens.Java.Utils).GetSetting(pConfigName,"AckMode",.tAckMode)
		Quit:$$$ISERR(tSC)
	} While 0
	
	If $$$ISERR(tSC) {
		Set tOldJob = $$$JobConfigName
		// First make sure that the message will appear under the correct config item
		Set ($$$EnsJobStatus($$$SystemName,$Job,$$$eJobGuestConfigName),$$$EnsJobLocal("GuestConfigName"))=pConfigName
		Do ##class(Ens.Util.Trace).SetTraceOptimizer()
		
		$$$LOGERROR($System.Status.GetErrorText(tSC))
		$$$SetHostMonitor(pConfigName,$$$eMonitorStatus,"Error")
		
		Kill $$$EnsJobStatus($$$SystemName,$Job,$$$eJobGuestConfigName), $$$EnsJobLocal("GuestConfigName")
	 	Do:(tOldJob'="") ##class(Ens.Util.Trace).SetTraceOptimizer()
	
	} Elseif $$$XOR(""=tAckTargetConfigNames,"Never"=tAckMode) {
		Set tOldJob = $$$JobConfigName
		// First make sure that the message will appear under the correct config item
		Set ($$$EnsJobStatus($$$SystemName,$Job,$$$eJobGuestConfigName),$$$EnsJobLocal("GuestConfigName"))=pConfigName
		Do ##class(Ens.Util.Trace).SetTraceOptimizer()

		If ""=tAckTargetConfigNames {
			$$$LOGWARNING($$$FormatText($$$Text("No ACK Target Config Name configured for AckMode '%1'"),tAckMode))
		} Else {
			$$$LOGWARNING($$$FormatText($$$Text("ACK Target ConfigName(s) '%1' configured for AckMode '%2'"),tAckTargetConfigNames,tAckMode))
		}
		
		Kill $$$EnsJobStatus($$$SystemName,$Job,$$$eJobGuestConfigName), $$$EnsJobLocal("GuestConfigName")
	 	Do:(tOldJob'="") ##class(Ens.Util.Trace).SetTraceOptimizer()

	}
	Quit $$$OK
}

Method OnProcessInput(pInput As %Stream.Object, Output pOutput As EnsLib.HL7.Message) As %Status
{
	#dim tSC As %Status = $$$OK
	#dim tDocument As EnsLib.HL7.Message
	
	If $IsObject(pInput) {
		Set tMessage=##class(EnsLib.HL7.Message).ImportFromLibraryStream(pInput, .tSC)
	} Else {
		Set tMessage=##class(EnsLib.HL7.Message).ImportFromString(pInput, .tSC)
	}
	Quit:$$$ISERR(tSC) tSC

	Quit ..standardOnProcessInput(tMessage, .pOutput)
}

Method SendReply(pReplyDocument As EnsLib.EDI.Document, pOriginalDoc As EnsLib.EDI.Document = {$$$NULLOREF}) As %Status
{
	If ""=..AckTargetConfigNames {
		$$$sysTRACE("ACK "_pReplyDocument_$S($IsObject(pReplyDocument):"/"_pReplyDocument.%Id(),1:"")_" not sent because no ACK Target Config Name is configured")
		Quit $$$OK
	}
	Set pReplyDocument.IsMutable=0
	Set tSC=$$$OK  For iTarget=1:1:$L(..AckTargetConfigNames, ",") { Set tOneTarget=$ZStrip($P(..AckTargetConfigNames,",",iTarget),"<>W")  Continue:""=tOneTarget
		Set tSC1=..SendRequestAsync(tOneTarget,pReplyDocument) Quit:$$$ISERR(tSC)
		Set:$$$ISERR(tSC1) tSC=$$$ADDSC(tSC,tSC1)
	}
	Quit tSC
}

ClassMethod OnGetConnections(Output pArray As %String, pItem As Ens.Config.Item)
{
	Do ##super(.pArray,pItem)
	If pItem.GetModifiedSetting("TargetConfigNames",.tValue) {
		For i=1:1:$L(tValue,",") { Set tOne=$ZStrip($P(tValue,",",i),"<>W")  Continue:""=tOne  Set pArray(tOne)="" }
	}
	If pItem.GetModifiedSetting("AckTargetConfigNames",.tValue) {
		For i=1:1:$L(tValue,",") { Set tOne=$ZStrip($P(tValue,",",i),"<>W")  Continue:""=tOne  Set pArray(tOne)="" }
	}
}

}
