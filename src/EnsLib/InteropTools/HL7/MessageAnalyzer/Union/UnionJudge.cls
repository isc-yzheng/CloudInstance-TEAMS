/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer.Lines

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Union.UnionJudge Extends BaseJudge
{

Property Messages As %List [ Private ];

Property DerivePattern As DerivePattern [ Private ];

Method %OnNew(pMessages As %List, pDerivePattern As DerivePattern) As %Status
{
	Set ..Messages=pMessages
	Set ..DerivePattern=pDerivePattern
	Quit $$$OK
}

Method RateLinesSymbols(pCandidate As LinesSymbols, Output pPattern As %String) As %CacheString
{
	$$$SHOULDBEUNDEF(pPattern)
	
	Set tPattern=..DerivePattern.FindPattern(..Messages,pCandidate)
	If tPattern="" {
		Quit ""
	}
	
	Set pPattern=tPattern
	Quit $Length(pPattern) // the shorter the pattern, the better
}

}
