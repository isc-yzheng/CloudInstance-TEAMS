/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Analysis.DistributeReportDirs Extends DistributeReport
{

Method AddMessageImpl(pKeySpecKey As %String, pMessageTypeKey As %String, pFullMessage As %String)
{
	
	Set tSubFolderPath=##class(%File).NormalizeDirectory(pKeySpecKey,..TargetDir)

	If '##class(%File).DirectoryExists(tSubFolderPath) {
		If '##class(%File).CreateDirectoryChain(tSubFolderPath) {
			$$$THROW("DistributeReport: facility subdirectory '"_tSubFolderPath_"' does not exist and cannot be created")
		}
	}

	
	If ..ByMessageType {
		Do ..FolderType.WriteContainerFile(tSubFolderPath,"facility")
		Set tPath=##class(%File).NormalizeDirectory(pMessageTypeKey,tSubFolderPath)
		If '##class(%File).DirectoryExists(tPath) {
			If '##class(%File).CreateDirectoryChain(tPath) {
				$$$THROW("DistributeReport: message type subdirectory '"_tPath_"' does not exist and cannot be created")
			}
		}
	}
	Else {
		Set tPath=tSubFolderPath
	}
				
	Do ..FolderType.WriteManifest(tPath,..Manifest)
	
	Set tFileName=..RegisterMessageControlID(pFullMessage)
	
	Set tFilePath=##class(%File).NormalizeFilename(tFileName,tPath)
	Set tOutputStream=##class(Common).WriteFileStream(tFilePath,$Char(10))
	$$$THROWONERROR(tSC,tOutputStream.Write(pFullMessage))
	$$$THROWONERROR(tSC,tOutputStream.%Save())
}

}
