/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.HL7, EnsLib.HL7.MsgRouter, EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Validation.Segment, EnsLib.InteropTools.HL7.MessageAnalyzer.Message)

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Validation

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Validation.Validate Extends %RegisteredObject
{

Property VersionedSchema As %String [ Private ];

Property ValSpec As %String [ Private ];

Property ListAll As %Boolean [ Private ];

Property DebuggingMode As %Boolean [ Private ];

Property RoutingEngine As RoutingEngine [ Private ];

Method %OnNew(pVersionedSchema As %String, pValSpec As %String, pListAll As %Boolean, pDebuggingMode As %Boolean) As %Status
{
	Set ..VersionedSchema=pVersionedSchema
	Set ..ValSpec=pValSpec
	Set ..ListAll=pListAll
	Set ..DebuggingMode=pDebuggingMode
	
	// create a routing engine
	Set tConfig="Shell"
	Kill %objlasterror
	Set ..RoutingEngine=##class(RoutingEngine).%New(.tConfig)
	If '$IsObject(..RoutingEngine) {
		$$$THROWONERROR(tSC,$Get(%objlasterror,$$$ERROR($$$GeneralError,"Unable to create routing engine")))
	}
	
	// set up the patterns to dispatch the status messages
	Do ##class(ValidationStatusMessages).SetupPatterns()
	
	Quit $$$OK
}

Method SetValSpecInStats(ByRef pStats)
{
	Set pStats($$$VSTATSVALFLAGS)=..ValSpec
}

Method ValidateMessage(pMessageText As %String, pMessageIndex As %Integer, ByRef pInstances As SegmentValidationBase, ByRef pStats)
{
	// parse and validate the message
	Set tSimpleMessage=##class(SimpleMessage).%New(pMessageText)
	If tSimpleMessage="" {
		If $I(pStats($$$VSTATSINVALID))
		Set pStats($$$VSTATSINVALID,pMessageIndex)=""
		Quit  // - invalid message
	}
	
	If $I(pStats($$$VSTATSTOTALVALID))
	
	// create an HL7 message object
	Set tHL7Message=tSimpleMessage.ToHL7Message(.tSC) $$$THROWONERROR(tSC,tSC)
	
	// set the doctype
	Kill %objlasterror
	Set tHL7Message.DocType=..VersionedSchema
	Set tSC=$Get(%objlasterror,$$$OK)
	If $$$ISERR(tSC) {
		Do ..RecordStatusMessages(tSC,tHL7Message,pMessageIndex,.pInstances,.pStats)
	}
		
	// validate the message
	Set tSC=$$$OK
	Set tRet=..RoutingEngine.OnValidate(tHL7Message,..ValSpec,.tSC)
	If $$$ISERR(tSC) {
		Do ..RecordStatusMessages(tSC,tHL7Message,pMessageIndex,.pInstances,.pStats)
	}
}

Method RecordStatusMessages(pSC As %Status, pHL7Message As Message, pMessageIndex As %Integer, ByRef pInstances As SegmentValidationBase, ByRef pStats) [ Private ]
{
	// get a list of status error messages from pSC
	Kill tErrorList
	Do ##class(Common).StatusToErrorList(pSC,.tErrorList)
	
	// for each error message ..
	For tI=1:1:$Get(tErrorList) {
	
		// look up the status message
		Set tRetSM=##class(ValidationStatusMessages).DispatchStatusMessage(tErrorList(tI),..ListAll,..DebuggingMode,.tCleanedStatusMessage)
		
		// if the status message matched ..
		If tRetSM'="" {
		
			If '$Data(pStats($$$VSTATSVALFAILCANAUTOFIX,pMessageIndex)) {
				If $I(pStats($$$VSTATSVALFAILCANAUTOFIX))
				Set pStats($$$VSTATSVALFAILCANAUTOFIX,pMessageIndex)=""
			}
		
			Set $ListBuild(tClass,tArgNames,tArgs)=tRetSM
			
			// get the operation key
			Set tOperationKey=$ClassMethod("EnsLib.InteropTools.HL7.MessageAnalyzer.Validation.Segment."_tClass,"OperationKey",tArgs)
			
			If ..DebuggingMode {
				Write "OperationKey=<<",$ListToString(tOperationKey),">>",!
			}
			
			// create a new instance for this operation, if needed
			If '$Data(pInstances(tOperationKey)) {			

				If ..DebuggingMode {
					Write " Creating new instance",!
				}

				Set pInstances(tOperationKey)=$ClassMethod("EnsLib.InteropTools.HL7.MessageAnalyzer.Validation.Segment."_tClass,"%New",tOperationKey,tCleanedStatusMessage,tArgs)
			}
			
			// present the message to the handler
			If ..DebuggingMode {
				Write "AddMessage #",pMessageIndex," class=",pInstances(tOperationKey).%ClassName(0)," args=<<",$ListToString(tArgs),">>",!
			}
			Do pInstances(tOperationKey).AddMessage(tArgs,pHL7Message,pMessageIndex)
		}
		
		If ..ListAll {Write " ",tCleanedStatusMessage,!}
	}
}

}
