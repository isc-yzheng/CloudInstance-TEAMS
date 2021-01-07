/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.Shell, EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging, EnsLib.InteropTools.HL7.MessageAnalyzer.Lines)

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.DeriveTask)

/// Uses simplified schema format to keep strings small
Class EnsLib.InteropTools.HL7.MessageAnalyzer.Derive.TopLevel Extends %RegisteredObject [ Final ]
{

/// The Optional heuristic is applied after each of these is run
Parameter ALLHEURISTICS = {$ListBuild("DeriveTaskAbstractStrings","DeriveTaskPrefix","DeriveTaskSuffix")};

Property Tasks As TreeTaskList [ Private ];

/// Results(PATTERN)=SHORTESTHISTORY
Property Results As BigKeyTableDT [ Private ];

Property Config As Config [ Private ];

Property Logger As Logger [ Private ];

/// If present, has a method called CheckPattern which takes a string (the pattern) and returns either "" (pattern is OK) or an error message
Property PatternChecker As %RegisteredObject [ Private ];

/// Holds the mappings from generated symbols to original pattern fragments
Property LinesSymbols As LinesSymbols [ Private ];

/// pPattern is EITHER a $List of $List of message segment types OR a pattern, depending on pArgIsPattern
Method %OnNew(pPattern As %List, pConfig As Config, pLogger As Logger, pPatternChecker As %RegisteredObject = "", pLinesSymbols As LinesSymbols = "", pArgIsPattern As %Boolean = 0) As %Status
{
	Set ..Config=pConfig
	Set ..Logger=pLogger
	Set ..PatternChecker=pPatternChecker
	Set ..LinesSymbols=pLinesSymbols

	Set ..Tasks=##class(TreeTaskList).%New()

	If pArgIsPattern {
		Set tChoiceTree=##class(TreeBuilder).PatternToTree(pPattern,.tFocusIndex)
	}
	Else {
		Set tRepeatAsSubtrees=pConfig.IsFlagSet("COMPRESSTOTREE")
		Set tChoiceTree=##class(ChoiceTreeBuilder).MakeTree(pPattern,tRepeatAsSubtrees)
		Set tFocusIndex=1
	}

	// check initial pattern
	If ..PatternChecker'="" {
	
		Set tErr=..PatternChecker.CheckPattern(tChoiceTree.Pattern())
		If tErr'="" {
			Write "TopLevel initial pattern",!
			Write "*** "_$ListLength(tErr)_" messages did not match",!
			Write "- pattern: "_tChoiceTree.Pattern(),!
			Write "- messages:",!
			Set tPtr=0 While $ListNext(tErr,tPtr,tElem) {
				Write " "_$ListToString(tElem),!
			}
			Write !
			ZTrap
		}		
	}
	
	Set tPtrI=0 While $ListNext(..#ALLHEURISTICS,tPtrI,tElemI) {
		Do ..Tasks.AddTask(##class(TreeTask).%New(tChoiceTree.Clone(),tFocusIndex,tElemI,"",..Config,..Logger,..PatternChecker))
	}
	
	Set ..Results=##class(BigKeyTableDT).%New()
	
	If 'pArgIsPattern {

		// if there's just ONE string ..
		If $ListLength(pPattern)=1 {
		
			// add it to the results as a sequence
			Set tPattern=$ListToString($List(pPattern))
			Do ..AddResult(tPattern,"")
		}
	}

	Quit $$$OK
}

Method Run()
{
	Do ..RunAll()
}

/// Run using a state-machine over the heuristics
Method RunCycles()
{
	If $$$DBFLAG {Do ..Tasks.Dump()}
	While ..Tasks.NextTask(.tTask) {
		Do ..Step(tTask)
		If $$$DBFLAG {Do ..Tasks.Dump()}
	}
}

/// Run using all heuristics at every step
Method RunAll()
{
	If $$$DBFLAG {Do ..Tasks.Dump()}
	Kill tTried
	While ..Tasks.NextTask(.tTask) {
		Do ..StepAll(tTask,.tTried)
		If $$$DBFLAG {Do ..Tasks.Dump()}
		
		#define DOTRIM 1
		
		#define TRIMWHEN 50
		#define TRIMFACTOR 0.5

		#if $$$DOTRIM
		If ..Tasks.TaskCount() > $$$TRIMWHEN {
			Do ..Tasks.Trim($$$TRIMFACTOR)
			If $$$DBFLAG {Write " - trimmed -",! Do ..Tasks.Dump()}
		}
		#endif
	}
}

/// Step using the given heuristic, returning the new tree if the tree was changed, otherwise ""
ClassMethod StepHeuristic(pTree As Tree, pFocusIndex As %Integer, pHeuristic As %String, pHistory As %List, pConfig As Config, pLogger As Logger, pPatternChecker As %RegisteredObject = "") As Tree
{
	Set tTree=pTree.Clone()
	Set tNewTask=##class(TreeTask).%New(tTree,pFocusIndex,pHeuristic,pHistory,pConfig,pLogger,pPatternChecker)
	Quit tNewTask.Step()
}

ClassMethod OptimizeTree(pTree As Tree) As Tree
{
	Set tNewTree=pTree.Clone()
	Do ##class(OptimizeTree).%New(tNewTree).OptimizeTree(##class(TreeRefs).%New())
	Quit tNewTree
}

/// Returns pResults(1..*)=$LB(PATTERN,SHORTESTHISTORY)
Method GetResults(Output pResults)
{
	$$$SHOULDBEUNDEF(pResults)
	
	Set tKey="" While 1 {
		
		Set tKey=..Results.Next(tKey) If tKey="" {Quit}
		
		Set tSubsKey=$Select(..LinesSymbols="":tKey,1:..LinesSymbols.SubstituteSymbolsIn(tKey))
		
		// ignore <XXX> if XXX is present
		If '..MatchesSimplerResult(tSubsKey) {
			Set pResults($I(pResults))=$ListBuild(tSubsKey,..Results.GetAt(tKey))
		}
	}
}

/// Returns pResults(TERMCOUNT,1..*)=$LB(PATTERN,SHORTESTHISTORY)
Method GetSortedResults(Output pResults)
{
	$$$SHOULDBEUNDEF(pResults)
	
	Set tKey="" While 1 {
		Set tKey=..Results.Next(tKey) If tKey="" {Quit}
		Set tSubsKey=$Select(..LinesSymbols="":tKey,1:..LinesSymbols.SubstituteSymbolsIn(tKey))
		
		// ignore <XXX> if XXX is present
		If '..MatchesSimplerResult(tSubsKey) {		
			Set tTermCount=##class(Common).TermCount(tSubsKey)
			Set pResults(tTermCount,$I(pResults(tTermCount)))=$ListBuild(tSubsKey,..Results.GetAt(tKey))
		}
	}
}

Method Dump()
{
	Write "Tasks:",!
	Do ..Tasks.Dump()
	Write "Results:",!
	Set tKey="" While 1 {
		Set tKey=..Results.Next("") If tKey="" {Quit}
		Write " ",$ListToString(..Results.GetAt(tKey)),!
	}
}

Method MatchesSimplerResult(pKey As %String) As %Boolean [ Private ]
{
	If $Extract(pKey)="<",$Extract(pKey,*)=">" {
		Set tInnerPart=$Extract(pKey,2,*-1)
		If tInnerPart'="",..Results.IsDefined(tInnerPart) {
			Quit 1
		}
	}
	
	Quit 0
}

Method Step(pTask As TreeTask) [ Private ]
{
	Set tNewTree=pTask.Step()
	
	If '$IsObject(tNewTree) {
		Set tResult=pTask.GetTree().Pattern()
		$$$DBOUT("- result: "_tResult)
		Do ..AddResult(tResult,pTask.GetHistory())
	}
	
	Set tFollowingTask=..FollowingTask(pTask,tNewTree)
	If tFollowingTask'="" {
		Do ..Tasks.AddTask(tFollowingTask)
	}
}

Method StepAll(pTask As TreeTask, ByRef pTried) [ Private ]
{
	Set tOldPattern=pTask.GetTree().Pattern()
	Set tNewTree=pTask.Step()
	
	//If tNewTree'="" {
	//	Write "$ ",pTask.GetHeuristic(),":",!
	//	Write tOldPattern,!
	//	Write tNewTree.Pattern(),!
	//	Write !
	//}

	Set tHistory=pTask.GetHistory()
	
	If '$IsObject(tNewTree) {
		$$$DBOUT("- result: "_tOldPattern)
		Do ..AddResult(tOldPattern,tHistory)
	}
	Else {
	
		Set tPattern=tNewTree.Pattern()
		If tPattern'=tOldPattern {				
			Set tHistory=tHistory_$ListBuild($ListBuild(pTask.GetHeuristic(),tNewTree.Pattern()))
		}
		
		Set tPatternHash="Z"_##class(Common).Hash(tPattern)
		If '$Data(pTried(tPatternHash)) {
			
			Set pTried(tPatternHash)=""
		
			Set tHeuristics=..#ALLHEURISTICS
			Set tPtrI=0 While $ListNext(tHeuristics,tPtrI,tElemI) {
				Set tNewTask=##class(TreeTask).%New(tNewTree.Clone(),pTask.GetFocusIndex(),tElemI,tHistory,..Config,..Logger,..PatternChecker)
				Do ..Tasks.AddTask(tNewTask)
			}
		}
	}
	
	Quit
	
	// UNUSED
ProperlyMatched(pattern)
	Set stack=""
	For i=1:1:$Length(pattern) {
		Set c=$Extract(pattern,i)
		If "[{<"[c {
			Set stack=stack_c
		}
		ElseIf "]}>"[c {
			If stack="" {Return 0}
			Set top=$Extract(stack,*)
			If top'=$Case(c,"]":"[","}":"{",">":"<") {
				Return 0
			}
			Set stack=$Extract(stack,1,*-1)
		}
	}
	Quit stack=""
}

Method FollowingTask(pTask As TreeTask, pMaybeNewTree As Tree) As TreeTask [ Private ]
{
	If pMaybeNewTree="" {
		Set tTree=pTask.GetTree().Clone()
	}
	Else {
		Set tTree=pMaybeNewTree
	}
	
	Set tFocusIndex=pTask.GetFocusIndex()
	
	Set tOldTaskName=pTask.GetHeuristic()
	
	// found a tree last time ..
	If pMaybeNewTree'="" {
	
		// Prefix/Suffix -> SAME
		If (tOldTaskName="DeriveTaskPrefix") || (tOldTaskName="DeriveTaskSuffix") {
			Quit ##class(TreeTask).%New(tTree,tFocusIndex,tOldTaskName,..Config,..Logger,..PatternChecker)
		}
		
		// Optional -> AbstractStrings
		If tOldTaskName="DeriveTaskOptional" {
			Quit ##class(TreeTask).%New(tTree,tFocusIndex,"DeriveTaskAbstractStrings",..Config,..Logger,..PatternChecker)
		}
		
		// AbstractStrings -> Prefix
		If tOldTaskName="DeriveTaskAbstractStrings" {
			Quit ##class(TreeTask).%New(tTree,tFocusIndex,"DeriveTaskPrefix",..Config,..Logger,..PatternChecker)
		}
	}
	
	// .. didn't find a tree last time ..
	Else {
	
		// Prefix -> Suffix
		If tOldTaskName="DeriveTaskPrefix" {
			Quit ##class(TreeTask).%New(tTree,tFocusIndex,"DeriveTaskSuffix",..Config,..Logger,..PatternChecker)
		}
		
		// Suffix -> Optional
		If tOldTaskName="DeriveTaskSuffix" {
			Quit ##class(TreeTask).%New(tTree,tFocusIndex,"DeriveTaskOptional",..Config,..Logger,..PatternChecker)
		}
		
		// Optional -> AbstractStrings
		If tOldTaskName="DeriveTaskOptional" {
			Quit ##class(TreeTask).%New(tTree,tFocusIndex,"DeriveTaskAbstractStrings",..Config,..Logger,..PatternChecker)
		}
		
		// AbstractStrings -> END
		If tOldTaskName="DeriveTaskAbstractStrings" {
			Quit ""
		}
	}
	
	$$$FATAL("FollowingTask: don't know what follows "_tOldTaskName_" "_$Select(pMaybeNewTree'="":"(tree changed)",1:"(tree unchanged)"))
}

Method AddResult(pPattern As %String, pHistory As %List) [ Private ]
{
	If ..Results.IsDefined(pPattern) {
		Set tOldHistory=..Results.GetAt(pPattern)
		If $ListLength(pHistory)<$ListLength(tOldHistory) {
			Do ..Results.SetAt(pHistory,pPattern)
		}
	}
	Else {
		Do ..Results.SetAt(pHistory,pPattern)
	}
}

}
