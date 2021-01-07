/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.Match.Lexer, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Element)

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.BranchContext Extends %RegisteredObject [ Final ]
{

Property EnableBacktracking As %Boolean;

Property MSR As MessageSegmentReader;

Property Resyncing As %Integer;

Property LastSucceedingElement As ElementBase;

Property LastSucceedingMessageRemaining As %String;

Property LastFailingElement As ElementBase;

Property OptionalQueue As %List [ Private ];

/// Bindings(MESSAGEOFFSET)=BINDING
Property Bindings As array Of Binding [ Private ];

Property ExtraState As array Of %String [ Private ];

Method %OnNew(pEnableBacktracking As %Boolean, pMSR As MessageSegmentReader, pResyncing As %Integer, pLastSucceedingElement As ElementBase, pLastSucceedingMessageRemaining As %String, pLastFailingElement As ElementBase) As %Status
{
	Set ..EnableBacktracking=pEnableBacktracking
	Set ..MSR=pMSR
	Set ..Resyncing=pResyncing
	Set ..LastSucceedingElement=pLastSucceedingElement
	Set ..LastSucceedingMessageRemaining=pLastSucceedingMessageRemaining
	Set ..LastFailingElement=pLastFailingElement
	Quit $$$OK
}

Method Bind(pMessageOffset As %Integer, pMessageText As %String, pHierarchy As %List, pSourceOffset As %List = "")
{
	// later bindings overwrite earlier ones - later ones will be failures after backtracking
	$$$THROWONERROR(tSC,..Bindings.SetAt(##class(Binding).%New(pMessageText,pHierarchy,pSourceOffset),pMessageOffset))
}

Method Set(pVar As %String, pValue As %String)
{
	$$$THROWONERROR(tSC,..ExtraState.SetAt(pValue,pVar))
}

Method Get(pVar As %String) As %String [ CodeMode = expression ]
{
..ExtraState.GetAt(pVar)
}

Method SetResyncing(pResyncing As %Integer)
{
	Set ..Resyncing=pResyncing
}

Method SetLast(pLastSucceedingElement As ElementBase, pLastSucceedingMessageRemaining As %String, pLastFailingElement As ElementBase)
{
	If $Data(pLastSucceedingElement) {
		Set ..LastSucceedingElement=pLastSucceedingElement
	}

	If $Data(pLastSucceedingMessageRemaining) {
		Set ..LastSucceedingMessageRemaining=pLastSucceedingMessageRemaining
	}
	
	If $Data(pLastFailingElement) {
		Set ..LastFailingElement=pLastFailingElement
	}
}

Method AddLeafToQueue(pLeaf As %String)
{
	Set ..OptionalQueue=..OptionalQueue_$ListBuild(pLeaf)
}

Method TakeLeafFromQueueIfMatch(pLeaf As %String) As %Boolean
{
	If ..OptionalQueue'="",$List(..OptionalQueue)=pLeaf {
		Set ..OptionalQueue=$List(..OptionalQueue,2,*)
		Quit 1
	}
	
	Quit 0
}

Method ClearQueue()
{
	Set ..OptionalQueue=""
}

Method ShowExtraState() As %String
{
	Set tOut=""
	Set tKey="" While 1 {
		Set tValue=..ExtraState.GetNext(.tKey) If tKey="" {Quit}
		Set tOut=tOut_$ListBuild(tKey_"="_tValue)
	}
	
	Quit $ListToString(tOut)
}

Method Report() As %List
{
	#Dim tKey
	#Dim tOut As %List
	
	Set tOut=""
	Set tKey="" While 1 {
		Set tValue=..Bindings.GetNext(.tKey) If tKey="" {Quit}
		Set tOut=tOut_$ListBuild("+"_tKey_": "_tValue.Report())
	}
	
	Quit tOut
}

Method Extent() As %Integer [ CodeMode = expression ]
{
+..Bindings.Previous("")
}

/// Returns a $List of entries, each being: $LB(MESSAGEOFFSET,$LB(SCHEMASTARTOFFSET,SCHEMAAFTERENDOFFSET))
Method MessageSchemaXref() As %List
{
	Set tOut=""
	Set tMessageOffset="" While 1 {
		Set tMessageOffset=..Bindings.Next(tMessageOffset) If tMessageOffset="" {Quit}
		Set tSchemaOffsets=..Bindings.GetAt(tMessageOffset).GetSourceOffset()
		Set tOut=tOut_$ListBuild($ListBuild(tMessageOffset,tSchemaOffsets))
	}
	
	Quit tOut
}

}
