/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Extend, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging)

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Analysis.MultiMessageReport Extends %RegisteredObject
{

Property MessageType As %String [ Private ];

Property Logger As Logger [ Private ];

/// May be ""
Property MessageHandler As MessageHandler [ Private ];

/// List of message origin files
Property MessagesOrigin As %List [ Private ];

/// MessageParentFolders(PARENTFOLDER)=""
Property MessageParentFolders As array Of %String [ Private ];

/// MatchingMessages(..)=MessageReport
Property MatchingMessages As list Of MessageReport [ Private ];

/// MismatchingMessages(BESTSCHEMANAME)=MessageReportList
Property MismatchingMessages As array Of MessageReportList [ Private ];

/// EmptyMessages(..)=MessageReport
Property EmptyMessages As list Of MessageReport [ Private ];

/// SchemaExpansions(SCHEMANAME)=SCHEMASOURCE
Property SchemaExpansions As array Of %String [ Private ];

Method %OnNew(pMessageType As %String, pLogger As Logger, pMessageHandler As MessageHandler) As %Status
{
	Set ..Logger=pLogger
	Set ..MessageType=pMessageType
	Set ..MessageHandler=pMessageHandler
	Quit $$$OK
}

Method AddMessagesOrigin(pMessagesOrigin As %String)
{
	Set tResult=..MessagesOrigin
	
	Set ..MessagesOrigin=tResult_$ListBuild(pMessagesOrigin)
	
	If $Extract(pMessagesOrigin)="@" {
		Set tParentDir=##class(%File).GetDirectory($Extract(pMessagesOrigin,2,*),1)
		$$$THROWONERROR(tSC,..MessageParentFolders.SetAt("",tParentDir))
	}
}

Method GetMessageParentFolders() As %List
{
	Set tOut=""
	Set tKey="" While 1 {
		Set tKey=..MessageParentFolders.Next(tKey) If tKey="" {Quit}
		Set tOut=tOut_$ListBuild(tKey)
	}
	
	Quit tOut
}

Method AddMessageReport(pMessageReport As MessageReport)
{
	#Dim tBestSchema
	
	If pMessageReport.AnyResults() {
		If pMessageReport.Matched() {
			Do ..MatchingMessages.Insert(pMessageReport)
		}
		Else {
			If pMessageReport.BestSchemaCount() {
				Set $ListBuild(tBestSchemaName,tBestSchemaSource)=pMessageReport.BestSchema(1) // TODO taking first
				If '..MismatchingMessages.IsDefined(tBestSchemaName) {
					$$$THROWONERROR(tSC,..MismatchingMessages.SetAt(##class(MessageReportList).%New(),tBestSchemaName))
				}
				Do ..MismatchingMessages.GetAt(tBestSchemaName).AddMessageReport(pMessageReport)
				$$$THROWONERROR(tSC,..SchemaExpansions.SetAt(tBestSchemaSource,tBestSchemaName))
			}
		}
	}
	Else {
		Do ..EmptyMessages.Insert(pMessageReport)
	}
}

Method GetMessagesOrigin() As %List [ CodeMode = expression ]
{
..MessagesOrigin
}

Method Report(pMachineCollection As MachineCollection, pConfig As Config, Output pStrategyManagers)
{
	$$$SHOULDBEUNDEF(pStrategyManagers)
	
	// tReferencedSchemas(SCHEMANAME)=$LB(USAGE,SCHEMASOURCE)
	Kill tReferencedSchemas
	
	// HEADER
	Do ..WriteMessageHeader(pConfig)
	
	// SUMMARY
	Do ..WriteSummary()
	
	// MATCHING MESSAGES
	Do ..WriteMatchingMessages(pConfig,.tReferencedSchemas)
	
	// MISMATCHING MESSAGES
	Do ..WriteMismatchingMessages(pMachineCollection,pConfig,.tReferencedSchemas,.pStrategyManagers)
	
	// EMPTY MESSAGES
	Do ..WriteEmptyMessages()
	
	// SCHEMA SOURCES
	Do ..WriteSchemaSources(.tReferencedSchemas)
}

Method WriteMessageHeader(pConfig As Config) [ Private ]
{
	New %DAT,%TIM
	
	Do ..Logger.OutputToLog("")
	
	// date and time
	Do INT^%D // to %DAT
	Do INT^%T // to %TIM
	
	Do ..Logger.OutputToLog("Report: "_%DAT_"  "_%TIM)
	
	// message type
	Do ..Logger.OutputToLog("Message type: "_$Select(..MessageType="":"not given",1:..MessageType))
	
	// source file(s)
	Do ..Logger.OutputToLog("Scanned: "_$ListToString(..MessagesOrigin))
	
	// app config
	Set tAppConfig=##class(Common).AppConfiguration(+pConfig.GetOptionValue("MESSAGESKIPCOUNT"))
	If tAppConfig'="" {
		Do ..Logger.OutputToLog("App Configuration: "_tAppConfig)
	}
	
	// config
	Set tFlagNames=pConfig.FlagNames()
	Set tTrueFlags=""
	Set tPtrI=0 While $ListNext(tFlagNames,tPtrI,tElemI) {
		If pConfig.IsFlagSet(tElemI) {
			Set tTrueFlags=tTrueFlags_$ListBuild(tElemI)
		}
	}
	Do ..Logger.OutputToLog("Config: "_$Select(tTrueFlags="":"default",1:"some flags are set - "_$ListToString(tTrueFlags)))
	
	// options
	Set tOptionNames=pConfig.OptionNames()
	Set tSetOptions=""
	Set tPtrI=0 While $ListNext(tOptionNames,tPtrI,tElemI) {
		Set tOptionValue=pConfig.GetOptionValue(tElemI)
		If tOptionValue'="" {
			Set tSetOptions=tSetOptions_$ListBuild(tElemI_"="_tOptionValue)
		}
	}
	Do ..Logger.OutputToLog("Options: "_$Select(tSetOptions="":"default",1:"some options are set - "_$ListToString(tSetOptions)))
	
	Do ..Logger.OutputToLog("")
}

Method WriteSummary() [ Private ]
{
	Do ..Logger.OutputToLog("Total messages: "_(..MatchingMessages.Count()+..GetMismatchingMessagesCount()+..EmptyMessages.Count()))
	Do ..Logger.OutputToLog("")
	Do ..Logger.OutputToLog("Matching messages: "_..MatchingMessages.Count())
	Do ..Logger.OutputToLog("Mismatching messages: "_..GetMismatchingMessagesCount())	
	If ..EmptyMessages.Count() {
		Do ..Logger.OutputToLog("Empty messages: "_..EmptyMessages.Count())
	}
	Do ..Logger.OutputToLog("")
}

Method WriteMatchingMessages(pConfig As Config, ByRef pReferencedSchemas) [ Private ]
{
	Set tMatchingMessageCount=..MatchingMessages.Count()
	If tMatchingMessageCount {
	
		Do ..Logger.OutputToLog("Matching messages:")
		
		Kill tSchemaTable // tSchemaTable(SCHEMAS)=MESSAGECOUNT
		For tI=1:1:tMatchingMessageCount {
			
			Set tMessage=..MatchingMessages.GetAt(tI)
			
			Set tSchemaList=tMessage.GetMatchingSchemas()
			If $I(tSchemaTable($ListToString(..JustSchemaNames(tSchemaList))))
			
			Set tPtrJ=0 While $ListNext(tSchemaList,tPtrJ,tElemJ) {
				Set pReferencedSchemas($List(tElemJ))=$ListBuild("MATCHING",$List(tElemJ,2))
			}
			
			If ..MessageHandler'="" {
				Do ..MessageHandler.MatchingMessage(tMessage)
			}
		}
		
		Set tSchemaList="" While 1 {
			Set tSchemaList=$Order(tSchemaTable(tSchemaList),+1,tMessageCount) If tSchemaList="" {Quit}
			Do ..Logger.OutputToLog(" "_tSchemaList_" - "_tMessageCount)
		}
		
		Do ..Logger.OutputToLog("")
	}
}

Method WriteMismatchingMessages(pMachineCollection As MachineCollection, pConfig As Config, ByRef pReferencedSchemas, Output pStrategyManagers) [ Private ]
{
	$$$SHOULDBEUNDEF(pStrategyManagers)
	
	If ..MismatchingMessages.Count() {
	
		Do ..Logger.OutputToLog("Mismatching messages:")
		Set tBestSchema="" While 1 {
	
			Set tBestSchema=..MismatchingMessages.Next(tBestSchema) If tBestSchema="" {Quit}			
			Set tBestSchemaExpansion=..SchemaExpansions.GetAt(tBestSchema)
			
			Set pReferencedSchemas(tBestSchema)=$ListBuild("MISMATCHING",tBestSchemaExpansion)
			
			Set tMessageList=..MismatchingMessages.GetAt(tBestSchema)
			Do ..Logger.OutputToLog(" "_tBestSchema_" - "_tMessageList.Count())
			
			For tI=1:1:tMessageList.Count() {
			
				Set tMessage=tMessageList.GetAt(tI)
				
				If pConfig.IsFlagSet("IDENTIFYLISTMESSAGES") {
					Do ..Logger.OutputToLog("  "_tMessage.ShowSome(1,1,0))
				}
				
				Set tOutcomes($I(tOutcomes))=tMessage.BestSchemaFailureOutcome(1) // TODO taking first				
							
				If ..MessageHandler'="" {
					Do ..MessageHandler.MismatchingMessage(tMessage)
				}
			}
			
			If pConfig.IsFlagSet("IDENTIFYLISTMESSAGES") {
				Do ..Logger.OutputToLog("")
			}
			
			// form strategies for this schema
			Set pStrategyManagers($I(pStrategyManagers))=##class(StrategyManager).%New(tBestSchema,tBestSchemaExpansion,.tOutcomes,pMachineCollection,..Logger)
		}
		
		Do ..Logger.OutputToLog("")
	}
}

Method WriteEmptyMessages() [ Private ]
{
	If ..EmptyMessages.Count() {
	
		Do ..Logger.OutputToLog("Empty or invalid messages - "_..EmptyMessages.Count())
			
		For tI=1:1:..EmptyMessages.Count() {
			Do ..Logger.OutputToLog(..EmptyMessages.GetAt(tI).Show())
		}
	}
}

Method WriteSchemaSources(ByRef pReferencedSchemas) [ Private ]
{
	Set tSchema="" While 1 {
		Set tSchema=$Order(pReferencedSchemas(tSchema),+1,tInfo) If tSchema="" {Quit}
		Do ..Logger.OutputToLog(tSchema_" ("_$List(tInfo)_")")
		Do ..Logger.OutputToLog(" "_$List(tInfo,2))
	}
}

Method GetMismatchingMessagesCount() [ Private ]
{
	Set tTotalCount=0
	Set tBestSchema="" While 1 {
		Set tBestSchema=..MismatchingMessages.Next(tBestSchema) If tBestSchema="" {Quit}
		Set tTotalCount=tTotalCount+..MismatchingMessages.GetAt(tBestSchema).Count()
	}
	
	Quit tTotalCount
}

ClassMethod JustSchemaNames(pSchemaInfoList As %List) As %List [ Private ]
{
	Set tOut=""
	Set tPtrI=0 While $ListNext(pSchemaInfoList,tPtrI,tElemI) {
		Set tOut=tOut_$ListBuild($List(tElemI))
	}
	
	Quit tOut
}

}
