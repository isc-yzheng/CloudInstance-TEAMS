/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Analysis.MessageHandler Extends %RegisteredObject
{

Property FolderType As FolderType [ Private ];

Method %OnNew(pFolderType As FolderType) As %Status
{
	Set ..FolderType=pFolderType
	Quit $$$OK
}

Method MatchingMessage(pMessage As MessageReport)
{
	Set tPathIfUnique=pMessage.GetPathIfUnique()
	
	If tPathIfUnique'="" {
	
		Set tSourceFolder=##class(%File).GetDirectory(tPathIfUnique,1)
	
		If tSourceFolder'="",..FolderType.IsMessagesFolder(tSourceFolder) {
			Set tSchemaName=..MatchingSchema(pMessage)
			Set tSourceFile=##class(%File).GetFilename(tPathIfUnique)
			Set tDestFolder=..SchemaFolder(tSourceFolder,tSchemaName)
			If '##class(%File).DirectoryExists(tDestFolder) {
				If '##class(%File).CreateDirectory(tDestFolder,.rc) {
					$$$THROW("Unable to create '"_tDestFolder_"' - return code is "_rc)
				}
			}
			Set tDestPath=##class(%File).NormalizeFilename(tSourceFile,tDestFolder)
			Do ..MoveFile(tPathIfUnique,tDestPath)
							
			$$$IFSESSION(ScanEvent("MoveMessage",$LB("SourcePath",tPathIfUnique),$LB("TargetPath",tDestPath),$LB("SchemaName",tSchemaName),$LB("MessageFile",tSourceFile)))
		}
	}
}

Method MismatchingMessage(pMessage As MessageReport)
{
	// leave the file where it is
}

ClassMethod MatchingSchema(pMessage As MessageReport)
{
	Set tList=pMessage.GetMatchingSchemas()
	Quit $List($List(tList)) // take first one
}

ClassMethod SchemaFolder(pSourceFolder As %String, pSchemaName As %String) As %String [ Private ]
{
	Quit ##class(%File).NormalizeDirectory(pSchemaName,pSourceFolder)
}

ClassMethod MoveFile(pSourcePath As %String, pDestPath As %String) [ Private ]
{
	$$$DBOUT("Move message: "_pSourcePath_" --> "_pDestPath)
	
	If '##class(%File).Rename(pSourcePath,pDestPath,.rc) {
		$$$THROW("Unable to rename '"_pSourcePath_"' to '"_pDestPath_"'- return code is "_rc)
	}
}

}
