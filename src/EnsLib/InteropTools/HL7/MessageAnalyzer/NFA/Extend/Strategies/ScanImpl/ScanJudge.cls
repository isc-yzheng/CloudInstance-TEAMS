/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.Shell, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging, EnsLib.InteropTools.HL7.MessageAnalyzer.Lines)

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Extend.Strategies.ScanImpl.ScanJudge Extends BaseJudge
{

Property Config As Config [ Private ];

Property Logger As Logger [ Private ];

Property OriginalRecords As %List [ Private ];

Property AnyWithoutEarliest [ MultiDimensional, Private ];

Method %OnNew(pConfig As Config, pLogger As Logger, pOriginalRecords As %List, ByRef pAnyWithoutEarliest) As %Status
{
	Set ..Config=pConfig
	Set ..Logger=pLogger
	Set ..OriginalRecords=pOriginalRecords
	Merge ..AnyWithoutEarliest=pAnyWithoutEarliest
	Quit $$$OK
}

Method RateLinesSymbols(pCandidate As LinesSymbols, Output pPattern As %String) As %CacheString
{
	$$$SHOULDBEUNDEF(pPattern)
	
	Merge tAnyWithoutEarliest=..AnyWithoutEarliest
	Set tPattern=##class(ScanBranch).GetPattern(..Config,..Logger,pCandidate,..OriginalRecords,.tAnyWithoutEarliest)
	If tPattern="" {
		Quit ""
	}
	
	Set pPattern=tPattern
	Quit $Length(pPattern) // the shorter the pattern, the better
}

}
