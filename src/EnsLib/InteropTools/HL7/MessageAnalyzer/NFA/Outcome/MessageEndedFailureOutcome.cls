/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// The message is exhausted but schema content remains
Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Outcome.MessageEndedFailureOutcome Extends FailureOutcome
{

Method Show(pDetailed As %Boolean = 0) As %String [ CodeMode = expression ]
{
"Failure - message ended"
}

Method FailureOutcomeType() As %Integer [ CodeMode = expression ]
{
$$$FOMEND
}

}
