/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Outcome.SplitOutcome Extends OutcomeBase [ Final ]
{

Method %OnNew(pBranchContext As BranchContext, Nexts As %List) As %Status
{
	Set ..BranchContext=pBranchContext
	Set ..Nexts=Nexts
	
	Quit $$$OK
}

Method Show(pDetailed As %Boolean = 0) As %String [ CodeMode = expression ]
{
"Split"
}

}
