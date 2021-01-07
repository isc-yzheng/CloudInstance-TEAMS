/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// The schema is exhausted but message content remains
Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Outcome.SchemaEndedFailureOutcome Extends FailureOutcome
{

Method Show(pDetailed As %Boolean = 0) As %String [ CodeMode = expression ]
{
"Failure - schema ended"_$Select(pDetailed:" - remaining message: "_..BranchContext.LastSucceedingMessageRemaining,1:"")
}

Method FailureOutcomeType() As %Integer [ CodeMode = expression ]
{
$$$FOSEND
}

}
