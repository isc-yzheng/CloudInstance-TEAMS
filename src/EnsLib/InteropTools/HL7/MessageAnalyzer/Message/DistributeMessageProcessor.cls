/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.Analysis, EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Message.DistributeMessageProcessor Extends MessageProcessor
{

Property SourceDir As %String [ Private ];

Property TargetDir As %String [ Private ];

Property Version As %String [ Private ];

Property OptionalSchemaName As %String [ Private ];

Property Combine As %Boolean [ Private ];

Property KeySpec As KeySpec [ Private ];

Property ToDirectories As %Boolean [ Private ];

Property ByMessageType As %Boolean [ Private ];

Property Quiet As %Boolean [ Private ];

/// DistributeReportList(1..)=DISTRIBUTEREPORT
Property DistributeReportList As list Of DistributeReport [ Private ];

/// pLogger can be passed as "" for a console logger
Method %OnNew(pConfig As Config, pLogger As Logger, pSourceDir As %String, pTargetDir As %String, pVersion As %String, pOptionalSchemaName As %String, pCombine As %Boolean, pKeySpec As %String, pToDirectories As %Boolean, pByMessageType As %Boolean, pQuiet As %Boolean) As %Status
{
	Set ..Config=pConfig
	Set ..Logger=$Select(pLogger="":##class(Logger).%New(,,.Config),1:pLogger)
	Set ..FolderType=##class(FolderType).%New()
	Set ..SourceDir=pSourceDir
	Set ..TargetDir=pTargetDir
	Set ..Version=pVersion
	Set ..OptionalSchemaName=pOptionalSchemaName
	Set ..Combine=pCombine
	Set ..KeySpec=##class(KeySpec).%New(pKeySpec)
	Set ..ToDirectories=pToDirectories
	Set ..ByMessageType=pByMessageType
	Set ..Quiet=pQuiet
	
	Quit $$$OK
}

Method GetMessageParentFolders(pReportIndex As %Integer) As %List [ CodeMode = expression ]
{
""
}

Method MergeADT(pMessagesOrigin As %String) As %Boolean [ CodeMode = expression ]
{
..Config.IsFlagSet("MERGEADTMESSAGES")
}

Method NewReport(pMessagesOrigin As %String, pMessageType As %String) As %Integer
{
	// if we should combine sources ..
	If ..Combine {
			
		// if the report list is empty ..
		If ..DistributeReportList.Count()=0 {
	
			// create the one report we need
			Do ..DistributeReportList.Insert(..MakeDistributeReport())
		}
		
		// always return the first report
		Quit 1
	}
	
	// .. not combining sources ..
	Else {

		// create a new report
		Do ..DistributeReportList.Insert(..MakeDistributeReport())
		Set tIndex=..DistributeReportList.Count()
		
		// return its index
		Quit tIndex
	}
}

Method ProcessMessage(pReportIndex As %Integer, pMessageType As %String, pMessageSegmentTypes As %List, pMessageCount As %Integer, ByRef pFullMessageArray, pPathIfUnique As %String)
{
	For tI=1:1:pFullMessageArray {
		Set tFullMessage=pFullMessageArray(tI)
		Set tKeySpecKey=..KeySpec.KeySpecKeyFor(tFullMessage)
		Do ..DistributeReportList.GetAt(pReportIndex).AddMessage(tKeySpecKey,tFullMessage)
	}
}

Method GetVersion() As %String [ CodeMode = expression ]
{
""
}

Method GetReportCount() As %Integer [ CodeMode = expression ]
{
..DistributeReportList.Count()
}

Method Report(pReportIndex As %Integer, pMachineCollection As MachineCollection, pConfig As Config, pLogger As Logger, Output pStrategyManagers)
{
	Set tReport=..DistributeReportList.GetAt(pReportIndex)

	Do pLogger.OutputToLog("Report for "_tReport.GetTargetDir())
	Do pLogger.OutputToLog("")
	
	Kill tMessageCounts
	Do tReport.GetMessageCounts(.tMessageCounts)
	If '$Get(tMessageCounts) {
		Write "NO messages",!
	}
	Else {
		Do pLogger.OutputToLog("Message counts by facility and message type:")
		Set tKeySpecKey="" While 1 {
			Set tKeySpecKey=$Order(tMessageCounts(tKeySpecKey),+1,tFCount) If tKeySpecKey="" {Quit}
			Do pLogger.OutputToLog(" "_tKeySpecKey_" = "_tFCount)
			Set tMessageType="" While 1 {
				Set tMessageType=$Order(tMessageCounts(tKeySpecKey,tMessageType),+1,tTCount) If tMessageType="" {Quit}
				Do pLogger.OutputToLog("  "_tMessageType_" = "_tTCount)
			}
			Do pLogger.OutputToLog("")
		}
		Do pLogger.OutputToLog("Total for all facilities: "_tMessageCounts)
		Do pLogger.OutputToLog("")
		
		Kill tDuplicateIDs
		Do tReport.DuplicateMessageControlIDs(.tDuplicateIDs)
		If $Data(tDuplicateIDs)\10 {
			Do pLogger.OutputToLog("Duplicate message control IDS:")
			Set tMessageID="" While 1 {
				Set tMessageID=$Order(tDuplicateIDs(tMessageID),+1,tCount) If tMessageID="" {Quit}
				Do pLogger.OutputToLog(" "_tMessageID_" ("_tCount_")")
			}
			Do pLogger.OutputToLog("")
		}
		
		Set tAssignedCount=tReport.GetAssignedSuffixCount()
		Do pLogger.OutputToLog($Case(tAssignedCount,0:"No messages",1:"1 message",:tAssignedCount_" messages")_" without a message ID")
		Do pLogger.OutputToLog("")
	}
}

Method MakeDistributeReport(pByMessageType As %Boolean, pManifest As %String) As DistributeReport [ CodeMode = expression, Private ]
{
$Select(
	..ToDirectories:##class(DistributeReportDirs).%New(..SourceDir,..TargetDir,..Version,..OptionalSchemaName,..ByMessageType,..Manifest(),..FolderType),
	1:##class(DistributeReportFiles).%New(..SourceDir,..TargetDir,..Version,..OptionalSchemaName,..ByMessageType,..Manifest(),..FolderType))
}

Method Manifest() As %String [ CodeMode = expression, Private ]
{
"app=distribute,todir="_..ToDirectories_",bymt="_..ByMessageType
}

}
