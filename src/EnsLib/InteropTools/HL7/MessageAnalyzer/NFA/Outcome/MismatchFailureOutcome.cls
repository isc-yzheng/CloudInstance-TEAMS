/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Neither the schema nor the message is exhausted
Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Outcome.MismatchFailureOutcome Extends FailureOutcome
{

Method Show(pDetailed As %Boolean = 0) As %String [ CodeMode = expression ]
{
"Failure - mismatch"_$Select(pDetailed:" - remaining message: "_..BranchContext.LastSucceedingMessageRemaining,1:"")
}

Method FailureOutcomeType() As %Integer [ CodeMode = expression ]
{
$$$FOMISM
}

}
