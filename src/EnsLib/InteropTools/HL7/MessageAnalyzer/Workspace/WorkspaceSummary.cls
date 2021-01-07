/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.Logging, EnsLib.InteropTools.HL7.MessageAnalyzer.Message, EnsLib.InteropTools.HL7.MessageAnalyzer)

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Output

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace.WorkspaceSummary Extends %RegisteredObject
{

Property Logger As Logger [ Private ];

Property FolderType As FolderType [ Private ];

Method %OnNew(pLogger As Logger) As %Status
{
	Set ..Logger=pLogger
	Set ..FolderType=##class(FolderType).%New()
	Quit $$$OK
}

Method Summary(pWorkspaceFolder As %String)
{
	If ..FolderType.GetFolderType(pWorkspaceFolder,.tSubType)'="container" {
		$$$LOGOUTPUT1(..Logger,"'"_pWorkspaceFolder_"' is not a workspace root or intermediate folder")
		Quit
	}
	
	If tSubType="root" {
		Do ..SummarizeRoot(pWorkspaceFolder)
	}
	
	ElseIf tSubType="facility" {
		Do ..SummarizeFacility(pWorkspaceFolder)
	}
	
	Else {
		$$$LOGOUTPUT1(..Logger,"Folder subtype '"_tSubType_"' is not supported by this utility")
		Quit
	}
}

Method SummarizeRoot(pWorkspaceFolder As %String, pIndent As %String = "") [ Private ]
{
	$$$LOGOUTPUT1(..Logger,"")
	$$$LOGOUTPUT1(..Logger,pIndent_"Summary Report for workspace "_pWorkspaceFolder)
	
	Do ##class(FolderType).GetFolderTypeFromFolder(pWorkspaceFolder,,.tRecord)
	Set tVersion=$List(tRecord)
	Write "Schema is ",tVersion,!
		
	// scan the folder for subfolders
	Set tScanner=##class(FolderScanner).%New(pWorkspaceFolder)
	While tScanner.Next(.tPath,.tIsDir) {
		
		// if it's a directory ..
		If tIsDir {
			Do ..SummarizeFacility(tPath,pIndent_" ")
		}
	}
}

Method SummarizeFacility(pFacilityFolder As %String, pIndent As %String = "") [ Private ]
{
	// get the last segment
	Set tFacilityName=##class(Common).LastFolderSegment(pFacilityFolder) 
	
	// tMatchedCount=MATCHEDCOUNT
	// tMatchedCount(SCHEMA)=MATCHEDCOUNT
	Kill tMatchedCount
	
	// tMismatchedCount=MISMATCHEDCOUNT
	Kill tMismatchedCount
	
	// tDerivedSchemaCount=GENERATEDSCHEMACOUNT
	Kill tDerivedSchemaCount
	
	// scan the folder for messages and subfolders
	Set tScanner=##class(FolderScanner).%New(pFacilityFolder)
	While tScanner.Next(.tPath,.tIsDir) {
		
		// if it's a directory ..
		If tIsDir {
			
			// get the last segment
			Set tLastSegment=##class(Common).LastFolderSegment(tPath) 
			
			Set tCount=..CountMessages(tPath)
			If $I(tMatchedCount,tCount)
			Set tMatchedCount(tLastSegment)=tCount
			
			If ##class(FolderType).IsGeneratedSchemaName(tLastSegment) {
				If $I(tDerivedSchemaCount)
			}
		}
		
		// .. a file ..
		Else {
		
			// if the file is a message file ..
			If ##class(FolderType).IsMessageFileName(tPath) {
				If $I(tMismatchedCount)
			}
		}
	}	
	
	Set tDerivedReport=$Select($Get(tDerivedSchemaCount):", derived "_tDerivedSchemaCount_" new document structures",1:"")
	$$$LOGOUTPUT1(..Logger,pIndent_tFacilityName_": "_$Get(tMatchedCount,0)_" matched, "_$Get(tMismatchedCount,0)_" unmatched"_tDerivedReport)
}

ClassMethod CountMessages(pFolder As %String) As %Integer [ Private ]
{
	Set tCount=0
	
	// scan the folder for files
	Set tScanner=##class(FolderScanner).%New(pFolder)
	While tScanner.Next(.tPath,.tIsDir) {
	
		// if it's a plain file ..
		If 'tIsDir {
			
			// if it's a message filename ..
			If ##class(FolderType).IsMessageFileName(tPath) {
				Set tCount=tCount+1
			}
		}
	}	
	
	Quit tCount
}

}
