/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Diff, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA)

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Extend.NewDiffCollection Extends %RegisteredObject
{

Property Machine As Machine [ Private ];

Property Config As Config [ Private ];

Property Logger As Logger [ Private ];

/// Diffs(1..*,1..*)=Diff
Property Diffs As Diff [ MultiDimensional, Private ];

/// Counts the number of diff records
Property Metric As %Integer [ Private ];

/// Counts the number of diff cases
Property CaseCount As %Integer [ Private ];

Method %OnNew(pMachine As Machine, pConfig As Config, pLogger As Logger) As %Status
{
	Set ..Machine=pMachine
	Set ..Config=pConfig
	Set ..Logger=pLogger
	
	Set ..Metric=0
	Set ..CaseCount=0
	
	Quit $$$OK
}

/// pDiffRecords(1..*)=Diff
/// <br> Returns the diff key
Method AddCase(ByRef pDiffRecords) As %String
{
	If '$Get(pDiffRecords) {$$$FATAL("NewDiffCollection:AddCase - no records passed")}
	
	// PATCHABLE WRITE
	//Write !,"New Diff Records",!
	//For i=1:1:pDiffRecords {
	//	Write " ",i,": ",pDiffRecords(i).AsString(1),!
	//}
	//Write !
	
	Set ..Metric=..Metric+pDiffRecords
	Set ..CaseCount=..CaseCount+1
	
	Set tCaseIndex=$I(..Diffs)
	For tI=1:1:pDiffRecords {
		Set ..Diffs(tCaseIndex,tI)=pDiffRecords(tI)
	}
	Set ..Diffs(tCaseIndex)=pDiffRecords
	
	Quit tCaseIndex
}

/// Returns pCSVRecordListTable(1..*,1..*)=RECORD (within GROUP)
/// <br> RECORD=$LB(MESSAGESEGMENTTYPE,..)
Method GetCSVRecords(pDiffCollection As DiffCollection, Output pCSVRecordListTable, Output pAnyWithoutEarliest, pConfig As Config)
{
	
	$$$SHOULDBEUNDEF(pCSVRecordListTable)
	
	For tI=1:1:$Get(..Diffs) {
		Set tRecord=""
		For tJ=1:1:..Diffs(tI) {
			Set tRecord=tRecord_$ListBuild($ListFromString(..Diffs(tI,tJ).CSVRepr()))
		}
		
		Set pCSVRecordListTable(1,$I(pCSVRecordListTable(1)))=tRecord
	}
}

Method SizeMetric() As %Integer [ CodeMode = expression ]
{
..Metric
}

Method Count() As %Integer [ CodeMode = expression ]
{
..CaseCount
}

Method CaseRepr(pDiffKey As %Integer) As %String
{
	Set tOut=""
	For tJ=1:1:..Diffs(pDiffKey) {
		Set tOut=tOut_$ListBuild(..Diffs(pDiffKey,tJ).AsString())
	}
	
	Quit $ListToString(tOut," || ")
}

Method CollectionKey() As %String
{
	Set tOut=""
	For tI=1:1:$Get(..Diffs) {
		Set tOut=tOut_$ListBuild(..Diffs(tI),tI)
	}
	
	Quit $ListToString(tOut)
}

Method Equals(pDiffCollection As NewDiffCollection) As %Boolean
{
	If $Get(..Diffs)'=$Get(pDiffCollection.Diffs) {Quit 0}
	
	For tI=1:1:$Get(..Diffs) {
		If ..Diffs(tI)'=pDiffCollection.Diffs {Return 0}
		For tJ=1:1:..Diffs(tI) {
			If ..Diffs(tI,tJ).CSVRepr()'=pDiffCollection.Diffs(tI,tJ).CSVRepr() {Return 0}
		}
	}

	Quit 1
}

Method DebugShow()
{
	If '$Get(..Diffs) {
		Write "No diff cases",!
	}
	Else {
		Write "Diff cases:",!
		Set tShown=0
		Set tShowAll=..Config.IsFlagSet("LOGALLDIFFCASES")
		For tI=1:1:..Diffs {
			If 'tShowAll,tShown=10 {
				Write "... more diff cases omitted here",!
				Quit
			}
			Write " #",tI,!
			If tShowAll {
				For tJ=1:1:..Diffs(tI) {
					Write "  ",$ListToString(..Diffs(tI,tJ).GetOriginalRecord()),!
				}
			}
			Set tShown=tShown+1
		}
	}
}

}
