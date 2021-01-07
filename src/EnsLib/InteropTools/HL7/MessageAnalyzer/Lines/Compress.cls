/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer.Logging

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.Output)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Lines.Compress
{

/// This must be sorted by length
Parameter ALLACTIONS = {$ListBuild(
	"M",
	"NM","MR","RN","MN","RM","NR",
	"NMR","MRN","RNM","RMN","NRM","MNR"
	)};

/// Given a list of lists in pMessages, a list of actions in pActionsList and a pattern judge in pJudge
/// <p> Return the best pattern and LinesSymbols which can be found - as judged by pJudge
/// <p> You should always pass the actions list sorted by length - otherwise the incremental building optimization will not be available
ClassMethod MakeLinesSymbolsBest(pMessages As %List, pLogger As Logger, pQuiet As %Boolean = 1, pActionsList As %List = {..#ALLACTIONS}, pJudge As BaseJudge, Output pPattern) As LinesSymbols
{
	$$$SHOULDBEUNDEF(pPattern)
	
	// tResults(RATING,ACTIONSX)=PATTERN
	// tResults(RATING,ACTIONSX,0)=LINESSYMBOLS
	// - RATING is a key returned by the judge - a RATING which collates earliest is considered "best"
	// - ACTIONSX is the compression actions string followed by "." (in case the actions string is "")
	Kill tResults
	
	// tErrors(ACTIONSX)=ERRORMESSAGE
	Kill tErrors
	
	// tBuilt(ACTIONSX)=LINESSYMBOLS
	Kill tBuilt
	
	Set tPtr=0 While $ListNext(pActionsList,tPtr,tActions) {

		Set tActionsX=tActions_"."
		
		Set tLinesSymbols=..MakeLinesSymbolsIncremental(pMessages,pLogger,pQuiet,tActions,.tBuilt)
		
		Try {
			Kill tPattern
			Set tRating=pJudge.RateLinesSymbols(tLinesSymbols,.tPattern)
			If tRating="" {
				Set tErrors(tActionsX)="Failed to derive a pattern"
			}
			Else {
				Set tResults(tRating,tActionsX)=tPattern
				Set tResults(tRating,tActionsX,0)=tLinesSymbols
			}
		}
		Catch err {
		
			// don't swallow <INTERRUPT> exceptions
			$$$RETHROWINTERRUPT(err)		
		
			Set tErrors(tActionsX)=err.DisplayString()
		}
	}
	
	// PATCHABLE
	#if 0
	If $Data(tErrors) {
		Write "Compress Errors:",!
		Set tErrorKey="" While 1 {
			Set tErrorKey=$Order(tErrors(tErrorKey),+1,tErrorMessage) If tErrorKey="" {Quit}
			Write " ",tErrorKey," => ",tErrorMessage,!
		}
	}
	#endif

	Set tTopRating=$Order(tResults(""),+1,tTopPattern)
	If tTopRating="" {
		
		// PATCHABLE
		#if 0
		Write ">> No lines symbols derived",!
		Set tActionsKey="" While 1 {
			Set tActionsKey=$Order(tErrors(tActionsKey),+1,tErrorMessage) If tActionsKey="" {Quit}
			Write " ",tActionsKey," -> ",tErrorMessage,!
		}
		#endif
		
		Set pPattern=""
		Quit ""
	}

	Set tActionsKey=$Order(tResults(tTopRating,""),+1,tPattern)
	Set tLinesSymbols=tResults(tTopRating,tActionsKey,0)
	
	// PATCHABLE
	#if 0
	Write ">> Best lines symbols for ",tActionsKey," - pattern: ",tPattern,!
	#endif
	
	Set pPattern=tPattern
	Quit tLinesSymbols
}

/// Given a list of lists in pMessages
ClassMethod MakeLinesSymbols(pMessages As %List, pLogger As Logger, pQuiet As %Boolean = 1, pActions As %String = "NMR") As LinesSymbols [ CodeMode = expression ]
{
..MakeLinesSymbolsImpl(pMessages,pLogger,pQuiet,pActions,##class(LinesSymbols).%New(pMessages))
}

ClassMethod MakeLinesSymbolsImpl(pMessages As %List, pLogger As Logger, pQuiet As %Boolean = 1, pActions As %String = "NMR", pLinesSymbols As LinesSymbols) As LinesSymbols [ Private ]
{
	For tI=1:1:$Length(pActions) {
	
		Set tA=$Extract(pActions,tI)
		
		// compress ngrams ..
		If tA="N" {			
			Do ##class(CompressNGrams).Compress(pLinesSymbols)
		}
		
		// .. compress multigrams ..
		ElseIf tA="M" {
			Do ##class(CompressMultiGrams).Compress(pLinesSymbols)
		}
		
		// .. compress repeats ..
		ElseIf tA="R" {
			Do ##class(CompressRepeats).Compress(pLinesSymbols)
		}
		
		Else {
			ZTrap
		}
		
		If 'pQuiet {
			// PATCHABLE
			//Do pLinesSymbols.DumpSymbols()
		}
	}
	
	// remove duplicate lines
	Do pLinesSymbols.MakeLinesUnique()
	
	// check for overlong records - overlong records are reported and removed from our data structure
	Kill tOverlong
	Do ..RemoveOverlongRecords(pLinesSymbols,.tOverlong)
	If 'pQuiet {
		For tI=1:1:$Get(tOverlong) {
			$$$LOGOUTPUTWRITEIF1(pLogger,"  - omitted record (too long): "_$ListToString(tOverlong(tI)),'pQuiet)
		}
	}
	
	Quit pLinesSymbols
}

ClassMethod MakeLinesSymbolsIncremental(pMessages As %List, pLogger As Logger, pQuiet As %Boolean = 1, pActions As %String, ByRef pBuilt) As LinesSymbols [ Private ]
{
	$$$ACASSERT('$Data(pBuilt(pActions_".")),"MakeLinesSymbolsIncremental: actions already built - "_pActions)
	
	Kill tBuiltLinesSymbols
	For tI=$Length(pActions)-1:-1:1 { // tI is the length of the prefix we hope to find in pBuilt
		Set tPrefix=$Extract(pActions,1,tI)
		If $Data(pBuilt(tPrefix_"."),tBuiltLinesSymbols) {
			Quit
		}
	}
	
	// if we can start from a previous LinesSymbols ..
	If $Data(tBuiltLinesSymbols) {
		Set tRemainingActions=$Extract(pActions,tI+1,*)
		Set tWorkingLinesSymbols=tBuiltLinesSymbols.Clone()
		Set tNewLinesSymbols=..MakeLinesSymbolsImpl(pMessages,pLogger,pQuiet,tRemainingActions,tWorkingLinesSymbols)
	}
	
	// .. make it from scratch ..
	Else {
		Set tNewLinesSymbols=..MakeLinesSymbols(pMessages,pLogger,pQuiet,pActions)
	}
	
	Set pBuilt(pActions_".")=tNewLinesSymbols
	Quit tNewLinesSymbols
}

/// Check for overlong records - overlong records are added to pOverlong(1..pOverlong) and removed from pLinesSymbols
ClassMethod RemoveOverlongRecords(pLinesSymbols As LinesSymbols, Output pOverlong) [ Private ]
{
	$$$SHOULDBEUNDEF(pOverlong)
	
	Set tRawLines=pLinesSymbols.GetLines()
	Set tLines=""
	Set tPtr=0 While $ListNext(tRawLines,tPtr,tElem) {
	
		If $Length(tElem)>$$$MAXSUBSCRIPTLENGTH {		
			Set pOverlong($I(pOverlong))=tElem
		}
		Else {
			Set tLines=tLines_$ListBuild(tElem)
		}
	}	
	
	Do pLinesSymbols.SetLines(tLines)
}

}
