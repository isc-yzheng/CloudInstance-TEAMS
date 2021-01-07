/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Used in a conjunction with a com.intersystems.gateway.bh.BusinessService to create a Java
/// Business Service which treats incoming data as EDI Virtual Documents.
Class Ens.Java.Service.AbstractEDI Extends Ens.Java.Service.Standard [ Abstract ]
{

/// ConfigName(s) of the operations or processes to which reply messages should be forwarded.
Property ReplyTargetConfigNames As %String;

Parameter SETTINGS = "ReplyTargetConfigNames:Acknowledgement:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

ClassMethod OnProductionStart(pConfigName) As %Status
{
	#dim tSC As %Status = $$$OK
	
	Set tSC = ##super(pConfigName)
	Quit:$$$ISERR(tSC) tSC
	
	#dim tReplyTargetConfigNames, tReplyMode, tOldJob As %String
	
	Do {
		Set tSC = ##class(Ens.Java.Utils).GetSetting(pConfigName,"ReplyTargetConfigNames",.tReplyTargetConfigNames)
		Quit:$$$ISERR(tSC)
		Set tSC = ##class(Ens.Java.Utils).GetSetting(pConfigName,"ReplyMode",.tReplyMode)
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
	
	} Elseif $$$XOR(""=tReplyTargetConfigNames,"Never"=tReplyMode) {
		Set tOldJob = $$$JobConfigName
		// First make sure that the message will appear under the correct config item
		Set ($$$EnsJobStatus($$$SystemName,$Job,$$$eJobGuestConfigName),$$$EnsJobLocal("GuestConfigName"))=pConfigName
		Do ##class(Ens.Util.Trace).SetTraceOptimizer()

		If ""=tReplyTargetConfigNames {
			$$$LOGWARNING($$$FormatText($$$Text("No Reply Target Config Name configured for ReplyMode '%1'"),tReplyMode))
		} Else {
			$$$LOGWARNING($$$FormatText($$$Text("Reply Target ConfigName(s) '%1' configured for ReplyMode '%2'"),tReplyTargetConfigNames,tReplyMode))
		}
		
		Kill $$$EnsJobStatus($$$SystemName,$Job,$$$eJobGuestConfigName), $$$EnsJobLocal("GuestConfigName")
	 	Do:(tOldJob'="") ##class(Ens.Util.Trace).SetTraceOptimizer()

	}
	Quit $$$OK
}

Method SendReply(pReplyDocument As EnsLib.EDI.Document, pOriginalDoc As EnsLib.EDI.Document = {$$$NULLOREF}) As %Status
{
	If ""=..ReplyTargetConfigNames {
		$$$sysTRACE($$$FormatText($$$Text("Reply %1 not sent because no Reply Target Config Name is configured"),$S($IsObject(pReplyDocument):"/"_pReplyDocument.%Id(),1:"")))
		Quit $$$OK
	}
	Set pReplyDocument.IsMutable=0
	Set tSC=$$$OK
	For iTarget=1:1:$L(..ReplyTargetConfigNames, ",") {
		Set tOneTarget=$ZStrip($P(..ReplyTargetConfigNames,",",iTarget),"<>W")  Continue:""=tOneTarget
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
	If pItem.GetModifiedSetting("ReplyTargetConfigNames",.tValue) {
		For i=1:1:$L(tValue,",") { Set tOne=$ZStrip($P(tValue,",",i),"<>W")  Continue:""=tOne  Set pArray(tOne)="" }
	}
}

}
