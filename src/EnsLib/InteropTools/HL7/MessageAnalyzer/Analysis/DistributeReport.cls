/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace, EnsLib.InteropTools.HL7.MessageAnalyzer.Common, EnsLib.InteropTools.HL7.MessageAnalyzer.Message)

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.SimpleMessage)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Analysis.DistributeReport Extends %RegisteredObject [ Abstract ]
{

/// Directory to which multi-message files - or subfolders of single-message files - are written
Property TargetDir As %String [ Private ];

Property Version As %String [ Private ];

Property ByMessageType As %Boolean [ Private ];

Property Manifest As %String [ Private ];

Property FolderType As FolderType [ Private ];

/// MessageCounts(KEYSPECKEY)=MESSAGECOUNT
Property MessageCounts As %Integer [ MultiDimensional, Private ];

Property MessageControlIDCount As array Of %Integer [ Private ];

Property AssignedSuffixCount As %Integer [ InitialExpression = 0, Private ];

Parameter NUMBERMAX = 99999999;

Parameter MESSAGEFILEEXT = ".txt";

Method %OnNew(pSourceDir As %String, pTargetDir As %String, pVersion As %String, pOptionalSchemaName As %String, pByMessageType As %Boolean, pManifest As %String, pFolderType As FolderType) As %Status
{
	If pTargetDir="" {
		$$$THROW("DistributeReport: target directory parameter is an empty string")
	}
	
	If pVersion="" {
		$$$THROW("DistributeReport: version parameter is an empty string")
	}
	
	If ##class(%File).DirectoryExists(pTargetDir) {
		$$$THROW("DistributeReport: target directory '"_pTargetDir_"' already exists")
	}

	If '##class(%File).CreateDirectoryChain(pTargetDir) {
		$$$THROW("DistributeReport: unable to create target directory '"_pTargetDir_"'")
	}

	Set ..TargetDir=pTargetDir
	Set ..Version=pVersion
	Set ..ByMessageType=pByMessageType
	Set ..Manifest=pManifest
	Set ..FolderType=pFolderType
	
	Do ..FolderType.WriteContainerFile(..TargetDir,"root",$ListBuild(..Version,pOptionalSchemaName,pSourceDir)) // this is read by the two workflow programs
	
	Quit $$$OK
}

Method GetMessageCounts(Output pMessageCounts)
{
	$$$SHOULDBEUNDEF(pMessageCounts)
	
	Merge pMessageCounts=..MessageCounts
}

/// pDuplicateIDs(ID)=COUNT
/// <p> Single-occurrence IDs are not included
Method DuplicateMessageControlIDs(Output pDuplicateIDs) [ Final ]
{
	$$$SHOULDBEUNDEF(pDuplicateIDs)
	
	Set tMessageID="" While 1 {
		Set tMessageID=..MessageControlIDCount.Next(tMessageID) If tMessageID="" {Quit}
		Set tCount=..MessageControlIDCount.GetAt(tMessageID)
		If tCount>1 {
			Set pDuplicateIDs(tMessageID)=tCount
		}
	}
}

Method GetAssignedSuffixCount() As %Integer [ CodeMode = expression ]
{
..AssignedSuffixCount
}

Method GetTargetDir() As %Integer [ CodeMode = expression ]
{
..TargetDir
}

Method AddMessage(pKeySpecKey As %String, pFullMessage As %String) [ Final ]
{
	If $I(..MessageCounts)
	
	If $I(..MessageCounts(pKeySpecKey))

	Set tSimpleMessage=##class(SimpleMessage).%New(pFullMessage)
	If '$IsObject(tSimpleMessage) {			
		$$$ThrowStatus(%objlasterror)
	}
	Set tMessageType=$$$SMMSHMESSAGETYPE(tSimpleMessage)
	Set tMessageTypeKey=$Select(tMessageType="":"NONE",1:tMessageType)
	If $I(..MessageCounts(pKeySpecKey,tMessageTypeKey))
	
	Do ..AddMessageImpl(pKeySpecKey,tMessageTypeKey,pFullMessage)
}

Method AddMessageImpl(pRelativePath As %String, pFullMessage As %String) [ Abstract ]
{
}

/// Given a full message, register the message control id (if any) and return an unique (FOR THIS RUN) file name
Method RegisterMessageControlID(pFullMessage As %String) As %String [ Private ]
{
	Set tSimpleMessage=##class(SimpleMessage).%New(pFullMessage)
	If '$IsObject(tSimpleMessage) {			
		$$$ThrowStatus(%objlasterror)
	}
	Set tMessageID=$$$SMMSHMESSAGECONTROLID(tSimpleMessage)

	If tMessageID="" {
	
		// no message control id => return generated name
		Quit ..NewMessageFileName()
	}
	
	If ..MessageControlIDCount.IsDefined(tMessageID) {
		Set tNewCount=..MessageControlIDCount.GetAt(tMessageID) + 1
	}
	Else {
		Set tNewCount=1
	}
	$$$THROWONERROR(tSC,..MessageControlIDCount.SetAt(tNewCount,tMessageID))
	
	Set suffix=$Select(tNewCount=1:"",1:"-"_tNewCount)
	
	Quit tMessageID_suffix_..#MESSAGEFILEEXT
}

Method NewMessageFileName() As %String [ Private ]
{
	Set tNumberWidth=$Length(..#NUMBERMAX)

	Set tNewCount=..AssignedSuffixCount + 1
	If tNewCount>..#NUMBERMAX {ZTrap} // ..#NUMBERMAX assigned files in the directory
	Set ..AssignedSuffixCount=tNewCount
	
	Quit ..MessageFileName(tNewCount,tNumberWidth)
}

ClassMethod MessageFileName(pIndex As %Integer, pNumberWidth As %Integer) [ CodeMode = expression, Private ]
{
"Message"_##class(Common).LZ(pIndex,pNumberWidth)_..#MESSAGEFILEEXT
}

}
