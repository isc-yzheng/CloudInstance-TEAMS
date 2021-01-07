/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.Match.Lexer, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Element, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Outcome, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Control, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Diff, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging)

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.Output)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Branch Extends %RegisteredObject
{

Property Element As ElementBase [ Private ];

Property BranchContext As BranchContext [ Private ];

Property DiffRecords As Diff [ Private ];

Property LatestGraphLabel As %String [ Private ];

Method %OnNew(pStartElement As ElementBase, pBranchContext As BranchContext, pDiffRecords As Diff) As %Status
{
	Set ..Element = pStartElement
	Set ..BranchContext=pBranchContext
	Set ..DiffRecords=pDiffRecords
	
	Quit $$$OK
}

Method RunBranch(pControl As ControlBase, pConfig As Config, pLogger As Logger) As OutcomeBase
{
	#Dim tElement,tPrevElement As ElementBase
	#Dim tMSR As MessageSegmentReader
	#Dim tSF,tIsSink As %Boolean
	#Dim tNext As %List
	
	Set tElement=..Element
	Do {

		If 'pControl.OnCycle(tElement,..BranchContext.MSR,..DiffRecords) {
			Return ##class(ControlFailureOutcome).%New(..BranchContext)
		}
		
		Set tMSR=..BranchContext.MSR.%ConstructClone(0)				
		
		Set $ListBuild(tSF,tNext)=tElement.Accept(tMSR,..BranchContext)

		$$$LOGOUTPUTIFCONFIG1X(pLogger,tElement.ElementName_" Accept: "_$Select(tSF:"SUCC",1:"FAIL")_" "_##class(%XSQL.Format).ListFormat(tNext)_" - "_tMSR.Show(),"LOGBRANCH",pConfig)
		
		// if the match succeeded ..
		If tSF {
		
			// only note a success if it *advanced* the reader (must be ">", not "'=", because Backtrack moves backwards over the reader) 
			If tMSR.GetOffset()>..BranchContext.MSR.GetOffset() {
				Do ..BranchContext.SetLast(tElement,tMSR.RemainingText())
				Do ..BranchContext.SetResyncing($$$RSNONE)
			}
			
			Do ..BranchContext.MSR.UpdateFrom(tMSR)
		}
		
		// .. match failed ..
		Else {

			// only note a failure if the element has successes
			If tElement.GetSucc()'="" {
				Do ..BranchContext.SetLast(,,tElement)
			}
		}
		
		Set tPrevElement=tElement
		
		// NO next element ..
		If tNext="" {
			Set tIsSink=tElement.%IsA("EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Element.SinkElement")
			Set tElement=""
		}
		
		// one next element ..
		ElseIf $ListLength(tNext)=1 {
			Set tElement=pControl.GetElement($List(tNext))
			$$$LOGOUTPUTIFCONFIG1X(pLogger,"Depth "_$ListLength(tPrevElement.Provenance)_" --> "_$ListLength(tElement.Provenance),"LOGBRANCH",pConfig)
		}
		
		// more than one next element ..
		Else {
			Set ..Element=pControl.GetElement($List(tNext))
			$$$LOGOUTPUTIFCONFIG1X(pLogger,"Depth "_$ListLength(tPrevElement.Provenance)_" --> "_$ListLength(..Element.Provenance),"LOGBRANCH",pConfig)
			Return ##class(SplitOutcome).%New(..BranchContext,tNext)
		}
		
	} While tElement'=""
	
	$$$ACASSERT(tElement="","tElement should be """" on exit from Do loop")
	
	If tIsSink {
		Quit ##class(SinkOutcome).%New()
	}
	
	Set tMSR=..BranchContext.MSR.%ConstructClone(0)
	If tSF {
		If ..BranchContext.MSR.Ended() {
			Do ..BranchContext.Bind(tMSR.GetOffset(),"SUCCESS","")
			Quit ##class(SuccessOutcome).%New(..BranchContext)
		}
		Else {
			Quit ##class(SchemaEndedFailureOutcome).%New(..BranchContext)
		}
	}
	Else {
		If ..BranchContext.MSR.Ended() {
			Quit ##class(MessageEndedFailureOutcome).%New(..BranchContext)
		}
		Else {
			Quit ##class(MismatchFailureOutcome).%New(..BranchContext)
		}
	}
}

Method GetMSROffset() As %Integer [ CodeMode = expression ]
{
..BranchContext.MSR.GetOffset()
}

Method Report() As %List
{
	Quit ..BranchContext.Report()
}

Method Extent() As %Integer [ CodeMode = expression ]
{
..BranchContext.Extent()
}

Method GetDiffRecords() As Diff [ CodeMode = expression ]
{
..DiffRecords
}

Method GetResyncing() As %Integer [ CodeMode = expression ]
{
..BranchContext.Resyncing
}

/// Updates the LatestGraphLabel property with the given label and returns the old label
Method UpdateGraphLabel(pNewGraphLabel As %String) As %String
{
	Set tOldGraphLabel=..LatestGraphLabel
	Set ..LatestGraphLabel=pNewGraphLabel
	Quit tOldGraphLabel
}

/// Back door for ControlBase for cleaning up after a control resources failure
Method GetBranchContext() As BranchContext [ CodeMode = expression ]
{
..BranchContext
}

Method Show() As %String [ CodeMode = expression ]
{
..Element.ElementName_..Element.ShowSourceOffset()_" - "_..BranchContext.MSR.Show()_" "_..BranchContext.ShowExtraState()
}

}
