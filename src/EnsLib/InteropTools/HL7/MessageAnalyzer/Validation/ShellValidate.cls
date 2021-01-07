/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.HL7, EnsLib.HL7.MsgRouter, EnsLib.InteropTools.HL7.MessageAnalyzer.Message, EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Validation.Segment, EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace)

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.Validation)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Validation.ShellValidate Extends %RegisteredObject
{

Property VersionedSchema As %String [ Private ];

Property MessageSourceReader As MessageSourceReader [ Private ];

Property ValSpec As %String [ Private ];

Property ListAll As %Boolean [ Private ];

Property DebuggingMode As %Boolean [ Private ];

Method %OnNew(pVersionedSchema As %String, pMessageSourceReader As MessageSourceReader, pValSpec As %String = "1", pListAll As %Boolean = 0, pAutoFix As %Boolean = 0, pDebuggingMode As %Boolean = 0) As %Status
{
	If pVersionedSchema'[":" {$$$THROW("Document structure name must include a schema prefix")}
	Set ..VersionedSchema=pVersionedSchema
	Set ..MessageSourceReader=pMessageSourceReader
	Set ..ValSpec=pValSpec
	Set ..ListAll=pListAll
	Set ..DebuggingMode=pDebuggingMode
	Quit $$$OK
}

Method ShellValidate()
{
	// validate each message
	Kill tInstances
	Do ..ValidateHL7Messages(.tInstances)

	// if there are no matches ..
	If '$Data(tInstances) {
		Write "No auto-fixable validation errors found",!
	}
	
	Else {
	
		// create an HL7Configuration object to cache the various names
		Set tHL7Configuration=##class(HL7Configuration).%New()
	
		// process the results
		Kill tLog
		Kill tErrorList
		Do ..ScanStatusMessages(tHL7Configuration,.tInstances,.tLog,.tErrorList)
		
		// show the log
		If $Get(tLog) {
			Write "Updates to HL7 configuration:",!
			For tI=1:1:tLog {
				Write " ",tLog(tI),!
			}
		}
		Else {
			Write "No changes made to HL7 configuration",!
		}
		
		// show the errors
		If $Get(tErrorList) {
			Write !,"There ",$$was(tErrorList)," ",$$error(tErrorList),":",!
			For tI=1:1:tErrorList {
				Write " ",tErrorList(tI),!
			}
		}
	}
	
	Quit
	
was(n)
	Quit $Case(n,1:"was",:"were")

error(n)
	Quit $Case(n,1:"error",:"errors")
}

Method ValidateHL7Messages(Output pInstances) [ Private ]
{
	$$$SHOULDBEUNDEF(pInstances)
	
	// set up a validation object
	Set tValidate=##class(Validate).%New(..VersionedSchema,..ValSpec,..ListAll,..DebuggingMode)
	
	// for each message ..
	Set tMessageIndex=0
	While ..MessageSourceReader.NextMessage(.tMessageText,.tMessageFilePath) {
	
		If ##class(FolderType).IsMessageFileName(tMessageFilePath) {
		
			Set tMessageIndex=tMessageIndex+1
			
			If ..ListAll {
				Write !,tMessageFilePath,!
			}
			
			Do tValidate.ValidateMessage(tMessageText,tMessageIndex,.pInstances)
		}
	}
}

Method ScanStatusMessages(pHL7Configuration As HL7Configuration, ByRef pInstances As SegmentValidationBase, Output pLog, Output pErrorList) [ Private ]
{
	$$$SHOULDBEUNDEF(pLog)
	$$$SHOULDBEUNDEF(pErrorList)
	
	Set tConfigChangeLog=##class(ConfigChangeLog).%New()
	Set tCustomVersion=$Piece(..VersionedSchema,":"),tSchemaName=$Piece(..VersionedSchema,":",2)
	Set tFix=##class(FixValidationProblem).%New(pHL7Configuration,tConfigChangeLog,tCustomVersion,tSchemaName)
	
	// for each operation ..
	Set tOperationKey=""
	While 1 {
		Set tOperationKey=$Order(pInstances(tOperationKey),+1,tInstance) If tOperationKey="" {Quit}
		Do tFix.Fix(tInstance,.pLog,.pErrorList)
	}
}

}
