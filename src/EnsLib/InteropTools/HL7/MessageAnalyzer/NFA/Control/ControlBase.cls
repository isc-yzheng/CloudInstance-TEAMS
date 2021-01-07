/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.Match.Lexer, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Element, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Traverser, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Outcome, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Diff, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging)

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.Output)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Control.ControlBase Extends %RegisteredObject [ Abstract ]
{

Property Machine As Machine [ Private ];

Property StartElement As %String [ Private ];

Property Config As Config [ Private, ReadOnly ];

Property Logger As Logger [ Private, ReadOnly ];

Property BranchCollection As BranchCollection [ Private ];

Property Results As list Of %String [ Private ];

Property Reports As list Of %List [ Private ];

Property EnableBacktracking As %Boolean [ Private ];

Method %OnNew(pMachine As Machine, pStartElement As %String, pConfig As Config, pLogger As Logger, pEnableBacktracking As %Boolean = 1) As %Status
{
	#Dim tKey
	#Dim tElement As ElementBase
	
	$$$ACASSERT(pMachine.IsDefined(pStartElement),"Start element ("_pStartElement_") is not in the machine")
	
	Set ..Machine=pMachine
	Set ..StartElement=pStartElement
	Set i%Config=pConfig
	Set i%Logger=pLogger
	Set ..EnableBacktracking=pEnableBacktracking
	
	Set tCountLimit=+pConfig.GetOptionValue("BRANCHCOUNTLIMIT")
	Set tTotalLimit=+pConfig.GetOptionValue("BRANCHTOTALLIMIT")
	Set ..BranchCollection=##class(BranchCollection).%New(tCountLimit,tTotalLimit)
	
	Quit $$$OK
}

/// Select a branch to process next and return its index
Method ChooseBranch() As %Integer [ Abstract ]
{
}

/// Action on SUCC
Method OnSucc(pBranchIndex As %Integer, pOutcome As OutcomeBase) [ Abstract ]
{
}

/// Action on FAIL
Method OnFail(pBranchIndex As %Integer, pOutcome As OutcomeBase) [ Abstract ]
{
}

/// Action on SINK
Method OnSink(pBranchIndex As %Integer) [ Abstract ]
{
}

/// Action on EXIT
Method OnExit() [ Abstract ]
{
}

/// Called before each Branch cycle: return 0 to abort the branch, 1 to continue
Method OnCycle(pElement As ElementBase, pMSR As MessageSegmentReader, pDiffRecords As Diff) As %Boolean [ Abstract ]
{
}

Method GetEnableBacktracking() As %Boolean [ CodeMode = expression, Final ]
{
..EnableBacktracking
}

/// Returns $LB(anysucc,furthestreport,$LB(summary1,summary2,..),message->schema xref)
/// <p> pStartAtElement can be omitted or "", defaulting to the StartElement property
Method RunControl(pStartAtElement As %String, pMSR As MessageSegmentReader, Output pResult As %List, Output pFailureOutcome As FailureOutcome)
{
	$$$SHOULDBEUNDEF(pResult)
	$$$SHOULDBEUNDEF(pFailureOutcome)

	If '..BranchCollection.IsEmpty() {$$$FATAL("ControlBase.RunControl: state is not empty")}
	
	// add initial branch for start element
	Set tStartAt=$Select($Get(pStartAtElement):pStartAtElement,1:..StartElement)
	Do ..AddBranch(..StartElement,##class(BranchContext).%New(..GetEnableBacktracking(),pMSR,$$$RSNONE,"","",""),##class(Diff).%New(pMSR.OriginalMessage()))
	
	// loop over running a branch
	Set tAnySucc=0
	Set tFurthestReport=""
	Set tSummary=""
	Set tMSXList=""
	Set pFailureOutcome=""
	Do {
	
		// select a branch
		Set tBranchIndex=..ChooseBranch()
		Set tBranch=..BranchCollection.GetBranch(tBranchIndex)
		$$$LOGOUTPUTIFCONFIG1X(..Logger,"Select branch #"_tBranchIndex_":"_tBranch.Show(),"LOGCONTROL",..Config)
		
		// run the selected branch
		Set tOutcome=tBranch.RunBranch($This,..Config,..Logger)
		$$$LOGOUTPUTIFCONFIGX(..Logger,$ListBuild(" - "_tOutcome.Show(),tBranch.Show()),"LOGCONTROL",..Config)
		
		// Outcome SINK ..
		If tOutcome.%ClassName()="SinkOutcome" {
		
			// delegate to subclass
			Do ..OnSink(tBranchIndex)
		}
		
		// Outcome SUCC ..
		ElseIf tOutcome.%ClassName()="SuccessOutcome" {
		
			Do ..AddReport(tBranchIndex,tOutcome,.tFurthestReport)
			
			// delegate to subclass
			Do ..OnSucc(tBranchIndex,tOutcome)
	
			Set tMessageSchemaXref=tBranch.GetBranchContext().MessageSchemaXref()
			
			// remove this branch 
			Do ..BranchCollection.RemoveBranch(tBranchIndex)
			
			Set tAnySucc=1
			Set tSummary=tSummary_$ListBuild(tOutcome.Show())
			Set tMSXList=tMSXList_$ListBuild(tMessageSchemaXref)		
		}
		
		// Outcome FAIL ..
		ElseIf tOutcome.FailureOutcomeType()'=$$$FONONE {
				
			Do ..AddReport(tBranchIndex,tOutcome,.tFurthestReport,.pFailureOutcome)
			
			// delegate to subclass
			Do ..OnFail(tBranchIndex,tOutcome)
						
			Set tMessageSchemaXref=tBranch.GetBranchContext().MessageSchemaXref()
			
			// remove this branch
			Do ..BranchCollection.RemoveBranch(tBranchIndex)
			
			Set tSummary=tSummary_$ListBuild(tOutcome.Show())
			Set tMSXList=tMSXList_$ListBuild(tMessageSchemaXref)		
		}
		
		// Outcome SPLIT ..
		ElseIf tOutcome.%ClassName()="SplitOutcome" {
		
			Set tDiffRecords=..BranchCollection.GetDiffRecords(tBranchIndex)
		
			// remove this branch
			Do ..BranchCollection.RemoveBranch(tBranchIndex)
		
			// create a branch for each successor
			Do ..Split(tOutcome,tDiffRecords)
		}
		
		// Outcome unknown ..
		Else {
			$$$FATAL("ControlBase.RunControl: unknown outcome type "_tOutcome.Show())
		}
		
	} While '..BranchCollection.IsEmpty(),'..BranchCollection.ExceededLimits() // until all the branches have been processed OR we hit a limit
	
	If '..BranchCollection.IsEmpty() {
		Set %MARESCOUNT=$Get(%MARESCOUNT)+1
		If %MARESCOUNT?1"1"."0" {
			$$$LOGOUTPUTIFCONFIG1(..Logger,"Control: branch collection resource - "_%MARESCOUNT,"LOGIDENTIFY")
		}
		Set pFailureOutcome=##class(ControlFailureOutcome).%New(tBranch.GetBranchContext())
	}
	
	Set pResult=$ListBuild(tAnySucc,tFurthestReport,tSummary,tMSXList)
	
	Do ..OnExit()
	
	Quit
}

Method GetReportCount() As %Integer [ CodeMode = expression, Final ]
{
..Reports.Count()
}

Method GetReports(pReportIndex As %Integer) As %List [ CodeMode = expression, Final ]
{
..Reports.GetAt(pReportIndex)
}

/// Callback API: return the element with the given name - or "" if passed ""
Method GetElement(pElementName As %String) [ CodeMode = expression, Final ]
{
$Select(pElementName="":"",1:..Machine.GetAt(pElementName))
}

Method AddBranch(pElementName As %String, pBranchContext As BranchContext, pDiffRecords As Diff, pLastSucceedingMessageRemaining As %String, pResyncing As %Integer) As %Integer [ Final, Private ]
{
	#Dim tElement As ElementBase
	#Dim tBranch As Branch
	
	Set tResyncing=$Get(pResyncing,$$$RSNONE)	
	$$$ACASSERT((tResyncing=$$$RSNONE)||(tResyncing=$$$RSNOSM)||(tResyncing=$$$RSCANS),"AddBranch: pResyncing is not set to a Parameter value - "_tResyncing)	
	Do pBranchContext.SetResyncing(tResyncing)
	Do pBranchContext.SetLast(,.pLastSucceedingMessageRemaining,)
	
	Set tElement=..GetElement(pElementName)
	Set tBranch=##class(Branch).%New(tElement,pBranchContext.%ConstructClone(1),pDiffRecords.%ConstructClone(1))
	Quit ..BranchCollection.AddBranch(tBranch)
}

Method AddReport(pBranchIndex As %Integer, pOutcome As OutcomeBase, ByRef pFurthestReport As %List, Output pFailureOutcome) [ Final, Private ]
{
	Set $ListBuild(tReport,tExtent)=..BranchCollection.Report(pBranchIndex)

	Do ..Reports.Insert($ListBuild(tReport))
	
	If (tExtent>$ListLength(pFurthestReport)) || ($Get(pFailureOutcome)="") {		
		Set pFurthestReport=tReport
		Set pFailureOutcome=pOutcome
	}
}

Method Split(pOutcome As OutcomeBase, pDiffRecords As Diff) [ Final, Private ]
{
	Set tMSR=pOutcome.BranchContext.MSR
	Set tBranchContext=pOutcome.BranchContext
	
	// create a branch for each successor
	Set tNextList=pOutcome.Nexts

	Set tPtrI=0 While $ListNext(tNextList,tPtrI,tElemI) {
		Set tElement=..GetElement(tElemI)
		Do ..AddBranch(tElement.ElementName,tBranchContext.%ConstructClone(1),pDiffRecords,,pOutcome.GetResyncing())
	}
}

}
