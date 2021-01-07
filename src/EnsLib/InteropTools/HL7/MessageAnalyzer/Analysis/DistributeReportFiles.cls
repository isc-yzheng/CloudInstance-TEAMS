/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Analysis.DistributeReportFiles Extends DistributeReport
{

Property TargetFiles As %Stream.Object [ MultiDimensional, Private ];

Method %OnClose() As %Status
{
	Set tKey="" While 1 {
		Set tKey=$Order(i%TargetFiles(tKey),+1,tStream) If tKey="" {Quit}
		Set tSC=tStream.%Save() If $$$ISERR(tSC) {Return tSC}
	}
	
	Quit $$$OK
}

Method AddMessageImpl(pKeySpecKey As %String, pMessageTypeKey As %String, pFullMessage As %String)
{
	If ..ByMessageType {

		Set tSubfolderPath=##class(%File).NormalizeDirectory(pKeySpecKey,..TargetDir)
		
		If '##class(%File).DirectoryExists(tSubfolderPath) {
			If '##class(%File).CreateDirectoryChain(tSubfolderPath) {
				$$$THROW("DistributeReport: target subdirectory '"_tSubfolderPath_"' does not exist and cannot be created")
			}
		}
	
		Set tPath=##class(%File).NormalizeFilename(pMessageTypeKey_..#MESSAGEFILEEXT,tSubfolderPath)
	}
	
	Else {
	
		Set tSubfolderPath=##class(%File).NormalizeFilename(pKeySpecKey,..TargetDir)
	
		Set tPath=tSubfolderPath_..#MESSAGEFILEEXT
	}
	
	// NO MANIFEST FOR MULTIMESSAGE-FILE FOLDERS
	
	Do ..RegisterMessageControlID(pFullMessage)
	
	If '$Data(i%TargetFiles(tPath)) {		
		Set tNewStream=##class(Common).WriteFileStream(tPath,$Char(10))
		Set i%TargetFiles(tPath)=tNewStream
	}
	
	Set tTargetStream=i%TargetFiles(tPath)
	$$$THROWONERROR(tSC,tTargetStream.Write(pFullMessage_$Char(10,10)))
}

}
