/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Message.MessageStore Extends %RegisteredObject
{

Property MessagesOrigin As %String [ Private ];

Property MergeADT As %Boolean [ Private ];

/// Store(MESSAGETYPE)=TYPESTORE
Property Store As BigKeyTable [ Private ];

/// Used to generate message control IDs where not given
Property MessageControlIDCounter As %Integer [ Private ];

Method %OnNew(pMessagesOrigin As %String, pMergeADT As %Boolean) As %Status
{
	Set ..MessagesOrigin=pMessagesOrigin
	Set ..MergeADT=pMergeADT
	Set ..Store=##class(BigKeyTable).%New()	
	Set ..MessageControlIDCounter=0
	Quit $$$OK
}

Method Add(pOriginalMessage As %String, pMessageType As %String, pMessageControlID As %String, pMessageKey As %String)
{
	Set tMessageTypeKey=..MessageTypeKey(pMessageType)
	
	If '..Store.IsDefined(tMessageTypeKey) {
		Set tTypeStore=##class(MessageTypeStore).%New()
		Do ..Store.SetAt(tTypeStore,tMessageTypeKey)
	}
	Else {
		Set tTypeStore=..Store.GetAt(tMessageTypeKey)
	}
	
	Set tUseMessageControlID=$Select(pMessageControlID="":..GenMessageControlID(),1:pMessageControlID)
	Do tTypeStore.Add(pOriginalMessage,pMessageKey,tUseMessageControlID)
}

Method MessageTypes() As %List
{
	Set tOut=""
	Set tMessageTypeKey="" While 1 {
		Set tMessageTypeKey=..Store.Next(tMessageTypeKey) If tMessageTypeKey="" {Quit}
		Set tOut=tOut_$ListBuild(tMessageTypeKey)
	}
	
	Quit tOut
}

Method TypeStore(pMessageTypeKey As %String) As MessageTypeStore [ CodeMode = expression ]
{
..Store.GetAt(..MessageTypeKey(pMessageTypeKey))
}

Method ComputeTotalMessageCount() As %Integer
{
	Set tCount=0
	Set tKey="" While 1 {
		Set tKey=..Store.Next(tKey) If tKey="" {Quit}
		Set tCount=tCount + ..Store.GetAt(tKey).ComputeTotalMessageCount()
	}
	
	Quit tCount
}

Method Next(pKey As %String) As %String [ CodeMode = expression ]
{
..Store.Next(pKey)
}

Method GetMessagesOrigin() As %String [ CodeMode = expression ]
{
..MessagesOrigin
}

/// If this store contains a single message and the origin begins with "@": return what follows the "@"
/// <p> Otherwise return ""
Method GetUniquePath() As %String [ CodeMode = expression ]
{
$Select(..OneMessageOnly() && ($Extract(..MessagesOrigin)="@"):$Extract(..MessagesOrigin,2,*),1:"")
}

Method Count() As %Integer
{
	Set tCount=0
	Set tKey="" While 1 {
		Set tKey=..Store.Next(tKey) If tKey="" {Quit}
		Set tCount=tCount + ..Store.GetAt(tKey).Count()
	}
	
	Quit tCount
}

Method Dump()
{
	Write "MessageStore: ",..MessagesOrigin,!
	Set tKey="" While 1 {
		Set tKey=..Store.Next(tKey) If tKey="" {Quit}
		Write " ",tKey,!
		Do ..Store.GetAt(tKey).Dump()
	}
	Write !
}

Method MessageTypeKey(pMessageType As %String) As %String [ Private ]
{
	If pMessageType="" {
		Quit "UNKNOWN"
	}
	
	If ..MergeADT,$Piece(pMessageType,"_")="ADT" {
		Quit "ADT"
	}
	
	Quit pMessageType
}

Method GenMessageControlID() As %String [ Private ]
{
	Set ..MessageControlIDCounter=..MessageControlIDCounter+1
	Quit "ZZZ"_##class(Common).LZ(..MessageControlIDCounter,8)
}

/// Return 1 if this store contains a single message
/// <p> Return 0 otherwise
Method OneMessageOnly() As %Boolean [ CodeMode = expression, Private ]
{
(..Store.Count()=1) && (..Store.GetAt(..Store.Next("")).OneMessageOnly())
}

}
