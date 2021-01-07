/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.NFA, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Element, EnsLib.InteropTools.HL7.MessageAnalyzer.Match.Lexer)

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Outcome.OutcomeBase Extends %RegisteredObject [ Abstract ]
{

/// Only present for Split
Property Nexts As %List;

/// Always present except for Sink
Property BranchContext As BranchContext;

Method GetResyncing() As %Integer [ CodeMode = expression, Final ]
{
..BranchContext.Resyncing
}

Method Show(pDetailed As %Boolean = 0) As %String [ Abstract ]
{
}

Method ExpandResyncing() [ CodeMode = expression ]
{
..ExpandResyncingFor(..BranchContext.Resyncing)
}

ClassMethod ExpandResyncingFor(pResyncing As %Integer) [ CodeMode = expression ]
{
$Case(pResyncing,$$$RSNONE:"None",$$$RSNOSM:"NoSkipMessage",$$$RSCANS:"CanSkipMessage",:"Unknown - "_pResyncing)
}

/// virtual default
Method FailureOutcomeType() As %Integer [ CodeMode = expression ]
{
$$$FONONE
}

}
