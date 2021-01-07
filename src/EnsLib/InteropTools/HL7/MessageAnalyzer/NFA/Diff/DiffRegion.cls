/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer.NFA

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

/// A region of difference between a schema and message
Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Diff.DiffRegion Extends %RegisteredObject [ Final ]
{

Property SchemaSkippedList As %List [ Private ];

Property MessageSkippedList As %List [ Private ];

Method AddSchemaRecord(pSchemaSkipped As %String)
{
	$$$ACASSERT(pSchemaSkipped'="","DiffRegion.AddSchemaRecord: schema argument is empty")
	
	Set ..SchemaSkippedList=..SchemaSkippedList_$ListBuild(pSchemaSkipped)
}

Method AddMessageRecord(pMessageSkipped As %List)
{
	$$$ACASSERT(pMessageSkipped'="","DiffRegion.AddMessageRecord: message argument is empty")
	
	Set ..MessageSkippedList=..MessageSkippedList_$ListBuild(pMessageSkipped)
}

Method AsString(pMachine As Machine = "", pWithSchemaOffset As %Boolean = 0) As %String [ CodeMode = expression ]
{
$ListToString(..ShowSchemaList(..SchemaSkippedList,pMachine)_..ShowMessageList(..MessageSkippedList,pWithSchemaOffset))
}

Method Length() As %Integer [ CodeMode = expression ]
{
$ListLength(..SchemaSkippedList) + $ListLength(..MessageSkippedList)
}

/// Sets pExtents(pIndex,0)=$LB(FIRSTMESSAGEOFFSET,LASTMESSAGEOFFSET)
/// <p> and sets pExtents(pIndex,1..*)=SCHEMAELEMENTNAME
Method GetExtents(pIndex As %Integer, ByRef pExtents)
{
	Set tMessageSkipped=..MessageSkippedList
	If tMessageSkipped'="" {
		If $ListLength(tMessageSkipped)=1 {
			Set tOffset=$List($List(tMessageSkipped),2)
			Set pExtents(pIndex,0)=$ListBuild(tOffset,tOffset)
		}
		Else {
			Set tFirstOffset=$List($List(tMessageSkipped),2)
			Set tLastOffset=$List($List(tMessageSkipped,*),2)
			Set pExtents(pIndex,0)=$ListBuild(tFirstOffset,tLastOffset)
		}
	}
	
	Set tSchemaSkipped=..SchemaSkippedList
	If tSchemaSkipped'="" {
		Set tPtrI=0 While $ListNext(tSchemaSkipped,tPtrI,tElemI) {
			Set pExtents(pIndex,$I(pExtents(pIndex)))=tElemI
		}
	}
}

Method AnySchemaElements() As %Boolean [ CodeMode = expression ]
{
..SchemaSkippedList'=""
}

/// Given $LB(MessageSkippedItem,..)
/// Return $LB(MessageExpansion,..)
ClassMethod ShowMessageList(pMessageSkippedList As %List, pWithSchemaOffset As %Boolean = 1) As %List
{
	Set tResult=""
	
	Set tPtrI=0 While $ListNext(pMessageSkippedList,tPtrI,tElemI) {
		Set tResult=tResult_$ListBuild(..ShowMessage(tElemI, pWithSchemaOffset))
	} 
	
	Quit tResult
}

ClassMethod ShowMessage(pMessageSkipped As %List, pWithSchemaOffset As %Boolean = 1) As %String [ CodeMode = expression ]
{
$List(pMessageSkipped)_" @"_$List(pMessageSkipped,2)_$Select(pWithSchemaOffset:..ShowSchemaOffset($List(pMessageSkipped,3)),1:"")
}

/// Return a %List of the message segments in our skipped list
Method CSVRepr() As %List
{
	If ..SchemaSkippedList'="" {
		Write "SCHEMASKIPPED NOT EMPTY: ",$ListToString(..SchemaSkippedList),! // TOPATCH-PATCHED
		$$$DBOUT("SCHEMASKIPPED NOT EMPTY")
	}
	
	Set tOut=""
	Set tPtrI=0 While $ListNext(..MessageSkippedList,tPtrI,tElemI) {
		Set tOut=tOut_$ListBuild($List(tElemI))
	}
	
	Quit tOut
}

/// Return the message text at the given range, or "" if there is no entry for the range
Method MessageTextAt(pStartOffs As %Integer, pEndOffs As %Integer) As %List
{
	Set tOut=""
	Set tPtrI=0 While $ListNext(..MessageSkippedList,tPtrI,tElemI) {
		Set $ListBuild(tMessageText,tMessageOffset)=tElemI
		If tMessageOffset>=pStartOffs,tMessageOffset<=pEndOffs {
			Set tOut=tOut_$ListBuild(tMessageText)
		}
	}
	
	Quit $ListToString(tOut)
}

/// Return a %List of the schema offset %Lists (start,afterend) corresponding to the skipped message segments
Method SchemaOffsets() As %String
{
	Set tOut=""
	Set tPtrI=0 While $ListNext(..MessageSkippedList,tPtrI,tElemI) {
		Set tOut=tOut_$ListBuild($List(tElemI,3))
	}
	
	Quit tOut
}

ClassMethod ShowSchemaList(pSchemaSkippedList As %List, pMachine As Machine = "") As %List [ Private ]
{
	Set tResult=""
	
	Set tPtrI=0 While $ListNext(pSchemaSkippedList,tPtrI,tElemI) {
		Set tResult=tResult_$ListBuild(..ShowSchema(tElemI,pMachine))
	} 
	
	Quit tResult
}

ClassMethod ShowSchema(pSchemaSkipped As %String, pMachine As Machine = "") As %String [ CodeMode = expression ]
{
pSchemaSkipped_$Select(pMachine="":"",1:"<"_$ListToString(pMachine.GetAt(pSchemaSkipped).GetProvenance(),"|")_">")
}

ClassMethod ShowSchemaOffset(pSchemaOffset As %List) As %String [ CodeMode = expression ]
{
"["_$List(pSchemaOffset)_"-"_$List(pSchemaOffset,2)_"]"
}

}
