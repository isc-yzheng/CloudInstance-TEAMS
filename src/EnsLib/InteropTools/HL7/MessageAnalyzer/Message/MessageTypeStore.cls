/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Message.MessageTypeStore Extends %RegisteredObject
{

/// Store(MESSAGESEGMENTLISTCSV)=COUNT
Property Store As BigKeyTableDT [ Private ];

/// IDStore(FULLMESSAGE)=MESSAGECONTROLID
Property IDStore As BigKeyTableDT [ Private ];

/// Bridge(MESSAGESEGMENTLISTCSV#,FULLMESSAGE#)=FULLMESSAGE
Property Bridge As %String [ MultiDimensional, Private ];

Method %OnNew() As %Status
{
	Set ..Store=##class(BigKeyTableDT).%New()
	Set ..IDStore=##class(BigKeyTableDT).%New()
	Quit $$$OK
}

Method Add(pOriginalMessage As %String, pMessageSegmentListCSV As %String, pMessageControlID As %String)
{
	Do ..Store.SetAt(..Store.GetAt(pMessageSegmentListCSV)+1,pMessageSegmentListCSV)
	Do ..IDStore.SetAt(pMessageControlID,pOriginalMessage) // TODO this assumes no duplicate message control ids
	Set ..Bridge(##class(Common).RawHash(pMessageSegmentListCSV),##class(Common).RawHash(pOriginalMessage))=pOriginalMessage
}

Method ComputeTotalMessageCount() As %Integer
{
	Set tCount=0
	Set tKey="" While 1 {
		Set tKey=..Store.Next(tKey) If tKey="" {Quit}
		Set tCount=tCount + ..Store.GetAt(tKey)
	}
	
	Quit tCount
}

Method RemoveAndReturnOutliers(pThreshold As %Numeric, Output pOutliers)
{
	$$$SHOULDBEUNDEF(pOutliers)
	
	Do ..FindOutliers(pThreshold,.pOutliers)
	
	For tI=1:1:$Get(pOutliers) {
		Do ..Store.RemoveAt($List(pOutliers(tI)))
	}
}

/// Return the message segment list which follows the given one
Method Next(pKey As %String) As %String [ CodeMode = expression ]
{
..Store.Next(pKey)
}

/// Return the full message text which follows the given one
Method NextFull(pKey As %String) As %String [ CodeMode = expression ]
{
..IDStore.Next(pKey)
}

/// Return an array of full messages corresponding to the given message segment list CSV
Method GetFullMessages(pMessageSegmentListCSV As %String, Output pFullMessageArray)
{
	$$$SHOULDBEUNDEF(pFullMessageArray)
	
	Set pMessageHash=##class(Common).RawHash(pMessageSegmentListCSV)
	Set tKey="" While 1 {
		Set tKey=$Order(..Bridge(pMessageHash,tKey),+1,tFullMessage) If tKey="" {Quit}
		Set pFullMessageArray($I(pFullMessageArray))=tFullMessage
	}
}

Method GetMessageCount(pKey As %String) As %Integer [ CodeMode = expression ]
{
..Store.GetAt(pKey)
}

Method Count() As %Integer [ CodeMode = expression ]
{
..Store.Count()
}

/// Return 1 if this typestore contains a single message
/// <p> Return 0 otherwise
Method OneMessageOnly() As %Boolean [ CodeMode = expression ]
{
..IDStore.Count()=1
}

Method Dump()
{
	Write " Message counts",!
	Set tKey="" While 1 {
		Set tKey=..Store.Next(tKey) If tKey="" {Quit}
		Write "  ",tKey,"=",..Store.GetAt(tKey),!
	}
	Write !
	
	Write " Message IDs and originals",!
	Set tKey="" While 1 {
	
		Set tKey=..IDStore.Next(tKey) If tKey="" {Quit}
		Write ..IDStore.GetAt(tKey),":",!,tKey,!
		Write "--",!!
	}
	Write !
}

Method FindOutliers(pThreshold As %Numeric, Output pOutliers) [ Private ]
{
	$$$SHOULDBEUNDEF(pOutliers)
	
	Set tTotalCount=..ComputeTotalMessageCount()
	Set tThresholdCount=((tTotalCount*pThreshold) \ 1) + 1
	
	Set tKey="" While 1 {
		Set tKey=..Store.Next(tKey) If tKey="" {Quit}
		If ..Store.GetAt(tKey) < tThresholdCount {
			Set pOutliers($I(pOutliers))=$ListBuild(tKey,..Store.GetAt(tKey))
		}
	}
}

}
