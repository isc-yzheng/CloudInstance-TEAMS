/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging, EnsLib.InteropTools.HL7.MessageAnalyzer.Derive, EnsLib.InteropTools.HL7.MessageAnalyzer.Message, EnsLib.InteropTools.HL7.MessageAnalyzer.Common, EnsLib.InteropTools.HL7.MessageAnalyzer.API, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell, EnsLib.InteropTools.HL7.MessageAnalyzer.Lines)

Include (EnsHL7, EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.Output)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Union.Process Extends %RegisteredObject
{

Property Version As %String [ Private ];

Property Config As Config [ Private ];

Property Logger As Logger [ Private ];

Property Quiet As %Boolean [ Private ];

Method %OnNew(pVersion As %String, pConfig As Config, pLogger As Logger, pQuiet As %Boolean = 1) As %Status
{
	Set ..Version=##class(Common).SchemaVersion(pVersion)
	Set ..Config=pConfig
	Set ..Logger=pLogger
	Set ..Quiet=pQuiet
	Quit $$$OK
}

/// Perform union-processing on pPath, which can be either a file or a folder
/// <p> If pOnlyMessageType is given and non-empty then only messages with that type will be processed
/// <p> pOmitMatchingMessages means don't process messages which match the schema
Method Process(pPath As %String, pOnlyMessageType As %String, pOmitMatchingMessages As %Boolean, pListMessages As %Boolean)
{
	If ##class(%File).DirectoryExists(pPath) {	
		Do ..ProcessFolder(pPath,pOnlyMessageType,pOmitMatchingMessages,pListMessages)
	}
	ElseIf ##class(%File).Exists(pPath) {
		Do ..ProcessFile(pPath,pOnlyMessageType,pOmitMatchingMessages,pListMessages)
	}
	Else {
		$$$THROW("Union: path not found - "_pPath)
	}
}

/// Perform union-processing on all files in pFolderPath which have a non-empty filename and extension
Method ProcessFolder(pFolderPath As %String, pOnlyMessageType As %String, pOmitMatchingMessages As %Boolean, pListMessages As %Boolean) [ Private ]
{
	Kill tMessageArray // tMessageArray(tMessageType,RAWHASH(tMessageSegmentList))=tMessageSegmentList
	Kill tMessageCount // tMessageCount(tMessageType,RAWHASH(tMessageSegmentList))=tMessageCount
	Set tScanner=##class(FolderScanner).%New(pFolderPath)
	While tScanner.Next(.tPath,.tIsDir) {
		If 'tIsDir {
			Set tFileName=##class(%File).GetFilename(tPath)
			If $Piece(tFileName,".")'="",$Piece(tFileName,".",*)'="" {
				Do ##class(LoadMessages).LoadMessagesInteractively(tPath,1,..Config,..Logger,..Quiet,.tMessageArray,.tMessageCount) // TODO .tMessageCount is not used after this
			}
		}
	}
	
	Do ..ProcessMessages(pFolderPath,pOnlyMessageType,pOmitMatchingMessages,pListMessages,.tMessageArray)
}

/// Perform union-processing on file pFilePath
Method ProcessFile(pFilePath As %String, pOnlyMessageType As %String, pOmitMatchingMessages As %Boolean, pListMessages As %Boolean) [ Private ]
{
	
	Kill tMessageArray // tMessageArray(tMessageType,RAWHASH(tMessageSegmentList))=tMessageSegmentList
	Kill tMessageCount // tMessageCount(tMessageType,RAWHASH(tMessageSegmentList))=tMessageCount
	Do ##class(LoadMessages).LoadMessagesInteractively(pFilePath,1,..Config,..Logger,..Quiet,.tMessageArray,.tMessageCount) // TODO .tMessageCount is not used after this

	Do ..ProcessMessages(pFilePath,pOnlyMessageType,pOmitMatchingMessages,pListMessages,.tMessageArray)
}

Method ProcessMessages(pPath As %String, pOnlyMessageType As %String, pOmitMatchingMessages As %Boolean, pListMessages As %Boolean, ByRef pMessageArray) [ Private ]
{
	// if there isn't a designated message type ..
	If pOnlyMessageType="" {
		
		// for each message type ..
		$$$LOGOUTPUTWRITEIF1(..Logger,"Process each message type",'..Quiet)
		Set tMessageType="" While 1 {		
			Set tMessageType=$Order(pMessageArray(tMessageType)) If tMessageType="" {Quit}		
			Do ..ProcessMessageType(pPath,tMessageType,pOmitMatchingMessages,pListMessages,.pMessageArray)
		}
	}
	
	// .. there is a designated message type ..
	Else {
	
		If $Data(pMessageArray(pOnlyMessageType)) {

			// just the given message type ..
			Do ..ProcessMessageType(pPath,pOnlyMessageType,pOmitMatchingMessages,pListMessages,.pMessageArray)
		}
		Else {
			$$$LOGOUTPUTWRITEIF1(..Logger,"No messages with message type "_pOnlyMessageType,'..Quiet)
		}
	}
}

/// Perform union-processing on messages with a particular message type
/// TODO: pMessageCount is not used
Method ProcessMessageType(pPath As %String, pMessageType As %String, pOmitMatchingMessages As %Boolean, pListMessages As %Boolean, ByRef pMessageArray)
{
	$$$LOGOUTPUTWRITEIF1(..Logger," "_pMessageType_" - source: "_pPath,'..Quiet)

	// collect each message with this message type into tOut - a $List of $Lists of message segment types
	$$$LOGOUTPUTWRITEIF1(..Logger,"  assemble messages ..",'..Quiet)
	Set tPreOut=##class(LoadMessages).ExtractToLists(.pMessageArray,pMessageType)		
	If '..Quiet {
		Do ..LogMessages(tPreOut,pListMessages)
	}		
	
	// get schema source associated with message type (if any)
	Set tRet=..GetMessageTypeSchemaSource(pMessageType)	
	If tRet'="" {
		Set $ListBuild(tSchemaNameMT,tSchemaSourceMT)=tRet
	}
	Else {
		Set (tSchemaNameMT,tSchemaSourceMT)=""
	}
	
	// if we should omit matching messages AND we have a message-type schema ..
	If pOmitMatchingMessages,tSchemaNameMT'="" {
		Set tOut=##class(LoadMessages).WithoutMatchingMessages(tPreOut,tSchemaNameMT,..Version)
		Set tRemovedCount=$ListLength(tPreOut)-$ListLength(tOut)
		If tRemovedCount'=0 {
			$$$LOGOUTPUTWRITEIF1(..Logger,"  - "_$ListLength(tOut)_" messages remain after removing matching ones",'..Quiet)
		}
	}
	Else {
		Set tOut=tPreOut
	}
	
	// if there are NO messages ..
	If tOut="" {
		$$$LOGOUTPUTWRITEIF1(..Logger,"  - no messages to process",'..Quiet)
		Quit
	}
	
	// derive a pattern from the messages
	Set tDerivePattern=##class(DerivePattern).%New(..Config,..Logger,..Quiet)
	
	Set tJudge=##class(UnionJudge).%New(tOut,tDerivePattern)
	Kill tPattern
	Set tLinesSymbols=##class(Compress).MakeLinesSymbolsBest(tOut,..Logger,..Quiet,,tJudge,.tPattern)
	
	If tPattern="" {
		$$$LOGOUTPUT1(..Logger,"  - no results found")
	}
	Else {
		$$$LOGOUTPUT1(..Logger,"  found: "_tPattern)
	}
	
	$$$LOGOUTPUTWRITEIF1(..Logger,"-----",'..Quiet)
	$$$LOGOUTPUTWRITEIF1(..Logger,"",'..Quiet)
}

// log up to 5 messages - or all messages if pListMessages is true

Method LogMessages(pMessages As %List, pListMessages As %Boolean) [ Private ]
{
	Set tShownCount=0
	Set tPtr=0 While $ListNext(pMessages,tPtr,tElem) {
		If 'pListMessages,tShownCount=5 {
			$$$LOGOUTPUTWRITEIF1(..Logger,"...",'..Quiet)
			Quit
		}
		$$$LOGOUTPUTWRITEIF1(..Logger,$ListToString(tElem),'..Quiet)
		Set tShownCount=tShownCount+1
	}
	
	$$$LOGOUTPUTWRITEIF1(..Logger,"  "_$ListLength(pMessages)_" unique messages",'..Quiet)
}

/// Get a $List of name and source (simplified format) of schema associated with message type, or "" if not found
/// <p> The version prefix is removed from the message segment types in the returned schema source
Method GetMessageTypeSchemaSource(pMessageType As %String) As %List [ Private ]
{
	Set tMessageTypeKey=$Piece(pMessageType,"^")_"_"_$Piece(pMessageType,"^",2)
	If $Data($$$vaSchemaGbl(..Version,"MT",tMessageTypeKey),tSchemaRef)#10 {
	
		Set tSchemaVersion=$Piece(tSchemaRef,":"),tSchemaName=$Piece(tSchemaRef,":",2)
		
		If tSchemaVersion'="",tSchemaVersion'=..Version {
			$$$LOGOUTPUTWRITEIF1(..Logger,"Warning: message type '"_pMessageType_"' in version "_..Version_" refers to schema '"_tSchemaRef_"'",'..Quiet)
		}
		
		Set tSchemaSource=##class(Common).SchemaStandardSource(tSchemaName,tSchemaVersion)
		If tSchemaSource'="" {
			Set tSimplifiedSchemaSource=##class(Common).AsSSF(tSchemaSource)
			Set tSimplifiedSchemaSourceNV=##class(Common).WithoutVersionPrefixes(tSimplifiedSchemaSource,tSchemaVersion)
			$$$LOGOUTPUTWRITEIF1(..Logger,"  - schema "_tSchemaName_": "_tSimplifiedSchemaSourceNV,'..Quiet)
			Quit $ListBuild(tSchemaName,tSimplifiedSchemaSourceNV)
		}				
	}  
	
	Quit ""
}

}
