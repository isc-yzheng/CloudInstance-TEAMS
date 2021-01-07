/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer.NFA

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Diff.Diff Extends %RegisteredObject
{

Property OriginalRecord As %List [ Private ];

Property RegionList As list Of DiffRegion [ Private ];

/// True if a new region should be created for any new schema/message records
Property NewRegion As %Boolean [ InitialExpression = 1, Private ];

Method %OnNew(pOriginalRecord As %List) As %Status
{
	Set ..OriginalRecord=pOriginalRecord
	Quit $$$OK
}

Method GetOriginalRecord() As %List [ CodeMode = expression ]
{
..OriginalRecord
}

/// schemaskipped is the name of an NFA node
Method AddSchemaRecord(pSchemaSkipped As %String)
{
	Do ..CurrentRegion().AddSchemaRecord(pSchemaSkipped)
}

/// messageskipped is $LB(skippedmessagecode,msroffsetatstartofskippedpart,$LB(schemapatternstartoffset,schemapatternafterendoffset))
Method AddMessageRecord(pMessageSkipped As %List)
{
	Do ..CurrentRegion().AddMessageRecord(pMessageSkipped)
}

/// start a new region
Method StartRegion()
{
	Set ..NewRegion=1
}

Method AsString(pWithSchemaOffset As %Boolean = 0) As %String
{
	Set tRegions=""

	For tI=1:1:..RegionList.Count() {
		Set tRegions=tRegions_$ListBuild(..RegionList.GetAt(tI).AsString(,pWithSchemaOffset))
	}
	
	Quit $ListToString(tRegions,"/")
}

/// Returns the total number of elements across all regions
Method Length() As %Integer
{
	Set tLength=0
	
	For tI=1:1:..RegionList.Count() {
		Set tLength=tLength+..RegionList.GetAt(tI).Length()
	}
	
	Quit tLength
}

/// Given: pDiffRecords(1..*)=Diff
/// <p>Return: the shortest records in pShortestDiffRecords(1..*)
ClassMethod GetShortest(ByRef pDiffRecords, Output pShortestDiffRecords) As Diff
{
	$$$SHOULDBEUNDEF(pShortestDiffRecords)
	
	If '$Get(pDiffRecords) {
		$$$FATAL("Diff.GetShortest: no records given")
	}
	
	Kill tIndex // tIndex(length,asstring)=diffrecord
	For tI=1:1:pDiffRecords {
		Set tRecord=pDiffRecords(tI)
		Set tLength=tRecord.Length()
		Set tAsString=tRecord.AsString()
		If tAsString'="" { // an empty diff is of no use
			If $Length(tAsString)<400 { // if it's longer than 400 characters: (1) it's unlikely to be of any use even if it is the shortest; (2) it could cause a <SUBSCRIPT> error
				If '$Data(tIndex(tLength,tAsString)) { // only store the first of identical records
					Set tIndex(tLength,tAsString)=tRecord
				}
			}
		}
	}
	
	Set tFirstKey=$Order(tIndex(""))
	If tFirstKey'="" {
		Set tSecondKey="" While 1 {
			Set tSecondKey=$Order(tIndex(tFirstKey,tSecondKey),+1,tRecord) If tSecondKey="" {Quit}
			Set pShortestDiffRecords($I(pShortestDiffRecords))=tRecord
		}
	}
}

Method AnySchemaElements() As %Boolean
{
	For tI=1:1:..RegionList.Count() {
		If ..RegionList.GetAt(tI).AnySchemaElements() {
			Return 1
		}
	}
	
	Quit 0
}

ClassMethod DiffRecordsAsString(ByRef pDiffRecords, pWithSchemaOffset As %Boolean = 0) As %String
{
	If '$Get(pDiffRecords) {
		$$$FATAL("Diff.DiffRecordsAsString: no records given")
	}
	
	Set tOut=""
	
	For tI=1:1:pDiffRecords {
		Set tOut=tOut_$ListBuild(pDiffRecords(tI).AsString(pWithSchemaOffset))
	}
	
	Quit $ListToString(tOut,"&")
}

/// pExtents(1..*,0)=$LB(FIRSTMESSAGEOFFSET,LASTMESSAGEOFFSET)
/// <p> pExtents(1..*,1..*)=SCHEMAELEMENTNAME
Method GetRegionExtents(Output pExtents)
{
	$$$SHOULDBEUNDEF(pExtents)
	
	For tI=1:1:..RegionList.Count() {
		Do ..RegionList.GetAt(tI).GetExtents(tI,.pExtents)
	}
	Set pExtents=..RegionList.Count()
}

Method Show(pMachine As Machine = "") As %String
{
	Set tOut=""
	
	For tI=1:1:..RegionList.Count() {
		Set tOut=tOut_$ListBuild(..RegionList.GetAt(tI).AsString(pMachine))
	}
	
	Quit "Diff records: "_$ListToString(tOut,"  //  ")
}

/// Return a //-delimited list of the expanded form of the regions
Method DiffKey() As %String
{
	Set tOut=""
	
	For tI=1:1:..RegionList.Count() {
		Set tOut=tOut_$ListBuild(..RegionList.GetAt(tI).AsString())
	}
	
	Quit $ListToString(tOut,"//")
}

/// Return a comma-separated string of skipped message segments 
Method CSVRepr() As %String
{
	Set tOut=""
	
	For tI=1:1:..RegionList.Count() {
		Set tOut=tOut_..RegionList.GetAt(tI).CSVRepr() // note: no $ListBuild
	}
	
	Quit $ListToString(tOut,",")
}

/// Return the message text at the given range, or "" if there is no entry for the range
Method MessageTextAt(pRange As %List) As %String
{
	Set $ListBuild(tStartOffs,tEndOffs)=pRange
	
	For tI=1:1:..RegionList.Count() {
		Set tMessageText=..RegionList.GetAt(tI).MessageTextAt(tStartOffs,tEndOffs)
		If tMessageText'="" {Return tMessageText} // TODO assumes regions are disjunct
	}
	
	Quit ""
}

/// Return a %List of the schema offset %Lists (start,afterend) corresponding to the skipped message segments
Method SchemaOffsets() As %List
{
	Set tOut=""

	For tI=1:1:..RegionList.Count() {
		Set tOut=tOut_..RegionList.GetAt(tI).SchemaOffsets() // note: no $ListBuild
	}
	
	Quit tOut
}

Method CurrentRegion() As DiffRegion [ Private ]
{
	If ..NewRegion {
		Do ..RegionList.Insert(##class(DiffRegion).%New())
		Set ..NewRegion=0
	}
	
	Quit ..RegionList.GetAt(..RegionList.Count())
}

}
