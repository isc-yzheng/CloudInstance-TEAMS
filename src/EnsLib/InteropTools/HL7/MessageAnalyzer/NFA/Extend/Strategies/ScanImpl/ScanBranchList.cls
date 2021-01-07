/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Extend.Strategies.ScanImpl.ScanBranchList Extends %RegisteredObject
{

/// ScanBranches(PRIOKEY,1..ScanBranches(PRIOKEY))=SCANBRANCH
/// <p> The PRIOKEY is some integer associated with the branch such that small PRIOKEY branches should be processed first
Property ScanBranches As ScanBranch [ MultiDimensional, Private ];

Property BranchCount As %Integer [ InitialExpression = 0, Private ];

/// PATCHED STATS
Property MaxBranchCount As %Integer [ InitialExpression = 0, Private ];

/// PATCHED STATS
Property TotalBranchCount As %Integer [ InitialExpression = 0, Private ];

/// PATCHED STATS
Property DuplicateCount As %Integer [ InitialExpression = 0, Private ];

Property SchemaSources As %String [ MultiDimensional, Private ];

Property CountLimit As %Integer [ Private ];

Property TotalLimit As %Integer [ Private ];

/// The limit arguments are defaulted to reasonable values if they are passed as 0 or ""
Method %OnNew(pCountLimit As %Integer, pTotalLimit As %Integer) As %Status
{
	Set ..CountLimit=$Select(pCountLimit:pCountLimit,1:10)
	Set ..TotalLimit=$Select(pTotalLimit:pTotalLimit,1:20)
	Quit $$$OK
}

/// PATCHED STATS
Method %OnClose() As %Status
{
	// Write "ScanBranchList: MaxBranchCount="_..MaxBranchCount_", TotalBranchCount="_..TotalBranchCount_", DuplicateCount="_..DuplicateCount,!
	Quit $$$OK
}

Method ExceededLimits() As %Boolean [ CodeMode = expression ]
{
(..CountLimit && ..MaxBranchCount>..CountLimit) || (..TotalBranchCount>..TotalLimit)
}

Method AddScanBranch(pPrioKey As %Integer, pBranch As ScanBranch)
{
	Set tSchemaSourceHash=##class(Common).RawHash(pBranch.GetSchemaSource())
	If '$Data(..SchemaSources(tSchemaSourceHash)) {
	
		Set ..SchemaSources(tSchemaSourceHash)=""
		
		Set tNewSubKey=$I(..ScanBranches(pPrioKey))
		Set ..ScanBranches(pPrioKey,tNewSubKey)=pBranch	
		Set ..BranchCount=..BranchCount + 1
		
		If ..BranchCount>..MaxBranchCount {Set ..MaxBranchCount=..BranchCount}
		Set ..TotalBranchCount=..TotalBranchCount+1
	}
	
	// PATCHED STATS
	Else {
		Set ..DuplicateCount=..DuplicateCount+1
	}
}

/// Returns "" if no more branches
Method NextBranch() As ScanBranch
{
	Set tPrioKey=$Order(..ScanBranches(""))
	If tPrioKey="" {Quit ""}
	
	Set tSubKey=$Order(..ScanBranches(tPrioKey,""),+1,tBranch) // tSubKey can't be "" at this point because of the Kill below
	Kill ..ScanBranches(tPrioKey,tSubKey)
	Set ..BranchCount=..BranchCount - 1
	
	If $Data(..ScanBranches(tPrioKey))\10=0 {Kill ..ScanBranches(tPrioKey)}
	
	Quit tBranch
}

Method GetBranchCount() As %Integer [ CodeMode = expression ]
{
..BranchCount
}

}
