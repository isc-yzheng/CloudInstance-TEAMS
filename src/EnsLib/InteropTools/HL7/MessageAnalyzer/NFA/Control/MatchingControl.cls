/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Diff

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Output

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Control.MatchingControl Extends ControlBase [ Final ]
{

/// Select a branch to process next and return its index
Method ChooseBranch() As %Integer [ CodeMode = expression, Final ]
{
$Select(..Config.IsFlagSet("DEPTHFIRST"):1,1:..BranchCollection.SelectEarliestBranchIndex())
}

Method OnSucc(pBranchIndex As %Integer, pOutcome As OutcomeBase) [ Final ]
{
}

Method OnFail(pBranchIndex As %Integer, pOutcome As OutcomeBase) [ Final ]
{
	// log and/or graph remaining NFA
	If pOutcome.BranchContext.LastSucceedingElement'="",..Config.IsFlagSet("LOGREMAINING") || ..Config.IsFlagSet("GRAPHREMAINING"){
	
		Set tSuccList=pOutcome.BranchContext.LastSucceedingElement.GetSucc()
		
		// policy excludes multiple-success elements which advance the reader
		$$$ACASSERT($ListLength(tSuccList)=1,"LastSucceedingElement has "_$ListLength(tSuccList)_" success links (should be 1)")
		
		Set tElementAfterLastSucc=..Machine.GetAt($List(tSuccList))
		
		If ..Config.IsFlagSet("LOGREMAINING") {
		
			$$$LOGOUTPUT(..Logger,$ListBuild("","Unmatched NFA starts with: "_tElementAfterLastSucc.Show()))
			Set tRemainingMessage=pOutcome.BranchContext.LastSucceedingMessageRemaining
			If tRemainingMessage="" {
				$$$LOGOUTPUTDB1(..Logger,"No unmatched message")
			}
			Else {
				$$$LOGOUTPUTDB1(..Logger,"Unmatched message: "_tRemainingMessage)
			}
		}

		If ..Config.IsFlagSet("GRAPHREMAINING") {
		
			$$$LOGOUTPUT(..Logger,$ListBuild("","Graphing remaining NFA as 'nfaremaining'"))
			
			Set tTraverser=##class(ClosureTraverser).%New(..Machine)
			Do tElementAfterLastSucc.Traverse(..Machine,tTraverser)
			
			Do tTraverser.GetElements(.tClosureMachine)
		
			Do tElementAfterLastSucc.Digraph(tClosureMachine,..Config,"nfaremaining")
		}
	}
}

Method OnSink(pBranchIndex As %Integer) [ Final ]
{
	// just discard this branch
	Do ..BranchCollection.RemoveBranch(pBranchIndex)
}

Method OnExit()
{
}

Method OnCycle(pElement As ElementBase, pMSR As MessageSegmentReader, pDiffRecords As Diff) As %Boolean [ CodeMode = expression ]
{
1
}

}
