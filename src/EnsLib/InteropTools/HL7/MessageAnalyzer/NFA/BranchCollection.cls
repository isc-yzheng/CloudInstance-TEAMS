/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Diff

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.BranchCollection Extends %RegisteredObject [ Final ]
{

Property BranchArray As array Of Branch [ Private ];

Property BranchArrayCount As %Integer [ Private ];

Property LastBranchIndex As %Integer [ InitialExpression = 0, Private ];

Property CountLimit As %Integer [ Private ];

Property TotalLimit As %Integer [ Private ];

Property MaxCount As %Integer [ Private ];

/// The limit arguments are defaulted to reasonable values if they are passed as 0 or ""
Method %OnNew(pCountLimit As %Integer, pTotalLimit As %Integer) As %Status
{
	Set ..BranchArrayCount=0
	Set ..CountLimit=$Select(pCountLimit:pCountLimit,1:15)
	Set ..TotalLimit=$Select(pTotalLimit:pTotalLimit,1:150)
	Set ..MaxCount=0
	Quit $$$OK
}

Method ExceededLimits() As %Boolean [ CodeMode = expression ]
{
(..MaxCount>..CountLimit) || (..LastBranchIndex>..TotalLimit)
}

Method IsEmpty() [ CodeMode = expression ]
{
..BranchArray.Next("")=""
}

Method GetBranch(pBranchIndex As %Integer) As Branch [ CodeMode = expression ]
{
..BranchArray.GetAt(pBranchIndex)
}

Method RemoveBranch(pBranchIndex As %Integer)
{
	Do ..BranchArray.RemoveAt(pBranchIndex)
	Set ..BranchArrayCount=..BranchArrayCount-1
}

Method AddBranch(pBranch As Branch) As %Integer
{
	Set ..LastBranchIndex=..LastBranchIndex+1
	$$$THROWONERROR(tSC,..BranchArray.SetAt(pBranch,..LastBranchIndex))
	Set ..BranchArrayCount=..BranchArrayCount+1
	If ..BranchArrayCount>..MaxCount {
		Set ..MaxCount=..BranchArrayCount
	}
	Quit ..LastBranchIndex
}

Method GetDiffRecords(pBranchIndex As %Integer) As Diff [ CodeMode = expression ]
{
..BranchArray.GetAt(pBranchIndex).GetDiffRecords()
}

Method GetResyncing(pBranchIndex As %Integer) As %Integer [ CodeMode = expression ]
{
..BranchArray.GetAt(pBranchIndex).GetResyncing()
}

Method SelectEarliestBranchIndex() As %Integer
{
	#Dim tSmallestMsrOffset,tSmallestIndex,tMsrOffset
	
	Set tSmallestMsrOffset=99999999
	Kill tSmallestIndex
	Set tKey="" While 1 {
		Set tKey=..BranchArray.Next(tKey) If tKey="" {Quit}
		Set tMsrOffset=..BranchArray.GetAt(tKey).GetMSROffset()
		If tMsrOffset < tSmallestMsrOffset {
			Set tSmallestMsrOffset=tMsrOffset
			Set tSmallestIndex = tKey
		}
	}
	
	Quit tSmallestIndex
}

Method Report(pBranchIndex As %Integer) As %List
{
	Set tBranch=..BranchArray.GetAt(pBranchIndex)
	Quit $ListBuild(tBranch.Report(),tBranch.Extent())
}

Method ListCollection()
{
	Set tKey="" While 1 {
		Set tKey=..BranchArray.Next(tKey) If tKey="" {Quit}
		Write "#",tKey,": ",..BranchArray.GetAt(tKey).Show(),!
	}
}

}
