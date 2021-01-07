/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Outcome.ControlFailureOutcome Extends FailureOutcome
{

Method Show(pDetailed As %Boolean = 0) As %String [ CodeMode = expression ]
{
"Failure - control"_$Select(pDetailed:" - remaining message: "_..BranchContext.LastSucceedingMessageRemaining,1:"")
}

Method FailureOutcomeType() As %Integer [ CodeMode = expression ]
{
$$$FOCONT
}

}
