/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.API, EnsLib.InteropTools.HL7.MessageAnalyzer.Message, EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Common, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell)

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.SimpleMessage, EnsLib.InteropTools.HL7.MessageAnalyzer.Output)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Union.LoadMessages [ Abstract ]
{

ClassMethod LoadMessagesInteractively(pFilePath As %String, pByMessageType As %Boolean, pConfig As Config, pLogger As Logger, pQuiet As %Boolean = 1, ByRef pMessageArray, ByRef pMessageCount)
{
	// load messages from the file
	$$$LOGOUTPUTWRITEIF1(pLogger,"Loading messages from "_pFilePath_" ..",'pQuiet)
	Set tReader=##class(MessageFileReader).%New(pFilePath,pConfig)
	
	// remove any duplicate messages and collect by message type
	$$$LOGOUTPUTWRITEIF1(pLogger,"Finding unique messages, by message type ..",'pQuiet)
	Kill tRejectedMessages
	If pByMessageType {
		Do ..CollectByMessageType(tReader,.pMessageArray,.pMessageCount,.tRejectedMessages)
	}
	Else {
		Do ..Collect(tReader,.pMessageArray,.pMessageCount,.tRejectedMessages)
	}
	
	// report any rejected messages
	If $Get(tRejectedMessages) {
		$$$LOGOUTPUT1(pLogger,tRejectedMessages_" rejected messages:")		
		If 'pQuiet {
			For tI=1:1:tRejectedMessages {
				$$$LOGOUTPUT1(pLogger," "_$ListToString(tRejectedMessages(tI)))
			}
		}
	}
}

/// Remove any duplicate messages and collect by message type
/// <p>
/// Returns: pMessageArray(MESSAGETYPE,SEGLISTHASH)=SEGLIST, pMessageCount(MESSAGETYPE,SEGLISTHASH)=COUNT, pRejectedMessages(1..pRejectedMessages)=SEGLIST
/// - where SEGLIST is a $List of message segment types, COUNT is the number of original messages with that SEGLIST, SEGLISTHASH is the raw hash of the SEGLIST
ClassMethod CollectByMessageType(pReader As MessageFileReader, ByRef pMessageArray, ByRef pMessageCount, Output pRejectedMessages) [ Private ]
{
	$$$SHOULDBEUNDEF(pRejectedMessages)
	 
	While pReader.NextMessage(.tMessage) {
	
		Set tMessageSegmentList=##class(MessageUtils).MessageSegmentTypes(tMessage)
		Set tSimpleMessage=##class(SimpleMessage).%New(tMessage)
		
		If $$acceptable(tMessageSegmentList),$IsObject(tSimpleMessage) {
		
			Set tMessageType=$$$SMMSHMESSAGETYPE(tSimpleMessage)
			
			Set tMessageSegmentListKey=##class(Common).RawHash(tMessageSegmentList)
			Set tUseMessageType=$Select(tMessageType="":"UNKNOWN",1:tMessageType)
			Set pMessageArray(tUseMessageType,tMessageSegmentListKey)=tMessageSegmentList
			If $I(pMessageCount(tUseMessageType,tMessageSegmentListKey))
		}
		Else {
			Set pRejectedMessages($I(pRejectedMessages))=tMessageSegmentList
		}
	}
	
	Quit
	
acceptable(messagesegmentlist)
	Quit $ZStrip($ListToString(messagesegmentlist),"<=>AN",",")=""
}

/// Remove any duplicate messages and collect without a grouping
/// <p>
/// Returns: pMessageArray(SEGLISTHASH)=SEGLIST, pMessageCount(SEGLISTHASH)=COUNT, pRejectedMessages(1..pRejectedMessages)=SEGLIST
/// - where SEGLIST is a $List of message segment types, COUNT is the number of original messages with that SEGLIST, SEGLISTHASH is the raw hash of the SEGLIST
ClassMethod Collect(pReader As MessageFileReader, ByRef pMessageArray, ByRef pMessageCount, Output pRejectedMessages)
{
	$$$SHOULDBEUNDEF(pRejectedMessages)
	 
	While pReader.NextMessage(.tMessage) {
	
		Set tMessageSegmentList=##class(MessageUtils).MessageSegmentTypes(tMessage)
		Set tSimpleMessage=##class(SimpleMessage).%New(tMessage)
		
		If $$acceptable(tMessageSegmentList),$IsObject(tSimpleMessage) {		
			Set tMessageSegmentListKey=##class(Common).RawHash(tMessageSegmentList)
			Set pMessageArray(tMessageSegmentListKey)=tMessageSegmentList
			If $I(pMessageCount(tMessageSegmentListKey))
		}
		Else {
			Set pRejectedMessages($I(pRejectedMessages))=tMessageSegmentList
		}
	}
	
	Quit
	
acceptable(messagesegmentlist)
	Quit $ZStrip($ListToString(messagesegmentlist),"<=>AN",",")=""
}

/// Collect each message with this message type into a $List of $Lists of message segment types
ClassMethod ExtractToLists(ByRef pMessageArray, pMessageType As %String) As %List
{
	Set tOut=""
	Set tKey="" While 1 {
		Set tKey=$Order(pMessageArray(pMessageType,tKey),+1,tMessageSegmentList) If tKey="" {Quit}
		Set tOut=tOut_$ListBuild(tMessageSegmentList)
	}
	
	Quit tOut
}

ClassMethod WithoutMatchingMessages(pMessages As %List, pSchemaName As %String, pVersion As %String) As %List
{
	Set tOut=""
	Set tPtr=0 While $ListNext(pMessages,tPtr,tOneMessage) {
		If '##class(IdentifyMessages).MessagePassesSchema($ListToString(tOneMessage),pSchemaName,pVersion) {
			Set tOut=tOut_$ListBuild(tOneMessage)
		}
	}
	
	Quit tOut
}

ClassMethod ClusterMessages(pMessageSegmentListList As %List, Output pCommonalities)
{
	$$$SHOULDBEUNDEF(pCommonalities)
	
	Kill tSets
	Set tMinScore=999999,tMaxScore=-1
	For tI=1:1:$ListLength(pMessageSegmentListList) {
		Set tMessageStringI=$ListToString($List(pMessageSegmentListList,tI))
		For tJ=tI+1:1:$ListLength(pMessageSegmentListList) {
			Set tMessageStringJ=$ListToString($List(pMessageSegmentListList,tJ))
			Set tScore=##class(PatternUtils).PatternCommonality(tMessageStringI,tMessageStringJ)
			Set pCommonalities(tI,tJ)=tScore
			Set tSets(tScore,tI,tJ)=""
			If tScore<tMinScore {Set tMinScore=tScore}
			If tScore>tMaxScore {Set tMaxScore=tScore}
		}
	}
}

}
