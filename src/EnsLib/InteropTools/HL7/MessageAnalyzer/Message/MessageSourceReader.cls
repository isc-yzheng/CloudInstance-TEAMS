/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Message.MessageSourceReader Extends %RegisteredObject
{

/// This is set to "" if the source is a single file
Property NestedFolderScanner As NestedFolderScanner [ Private ];

Property MessageFileReader As MessageFileReader [ Private ];

Property MessageFilePath As %String [ Private ];

Method %OnNew(pMessagesFileOrFolder As %String, pMaxDepth As %Integer) As %Status
{
	// if it's a folder ..
	If ##class(%File).DirectoryExists(pMessagesFileOrFolder) {
	
		Set ..NestedFolderScanner=##class(NestedFolderScanner).%New(pMessagesFileOrFolder,pMaxDepth)
		
		// if there's no file ..
		If '..NextFile(.tPath) {		
			Set ..NestedFolderScanner=""
			Set ..MessageFileReader=""
		}
		
		// .. there is a file ..
		Else {
			Set ..MessageFileReader=##class(MessageFileReader).%New(tPath)
		}
	}
	
	// .. it's a file ..
	ElseIf ##class(%File).Exists(pMessagesFileOrFolder) {
		Set ..NestedFolderScanner=""
		Set ..MessageFileReader=##class(MessageFileReader).%New(pMessagesFileOrFolder)
		Set ..MessageFilePath=pMessagesFileOrFolder
	}
	
	// .. doesn't exist ..
	Else {
		$$$THROW("Message file/folder not found - "_pMessagesFileOrFolder)
	}
	
	Quit $$$OK
}

/// Returns 0 if no more messages
Method NextMessage(Output pMessage As %String, Output pMessageFilePath As %String) As %Boolean
{
	Set (pMessage,pMessageFilePath)=""
	
	// there were no messages at all ..
	If ..MessageFileReader="" {Quit 0}
	
	// found a message in the current file ..
	If ..MessageFileReader.NextMessage(.pMessage) {
		Set pMessageFilePath=..MessageFilePath
		Quit 1
	}
	
	// there was just a file, no folder to scan ..
	If ..NestedFolderScanner="" {Quit 0}
	
	// until we find a message ..
	While 1 {
	
		// no more files in the folder ..
		If '..NextFile(.tPath) {
		
			// no more messages
			Set ..NestedFolderScanner=""
			Set ..MessageFileReader=""
			Return 0
		}
		
		// open a reader over this file
		Set ..MessageFileReader=##class(MessageFileReader).%New(tPath)
		
		// if there's a message ..
		If ..MessageFileReader.NextMessage(.tMessage) {
			
			// found a message
			Set pMessage=tMessage
			Set pMessageFilePath=..MessageFilePath
			Return 1
		}		
	}
}

Method NextFile(Output pPath As %String) As %Boolean [ Private ]
{
	If '..NestedFolderScanner.Next(.tPath) {
		Quit 0
	}
	
	Set ..MessageFilePath=tPath
	Set pPath=tPath
	Quit 1
}

}
