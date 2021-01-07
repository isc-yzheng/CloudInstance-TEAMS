/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Derive, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell, EnsLib.InteropTools.HL7.MessageAnalyzer.Common, EnsLib.InteropTools.HL7.MessageAnalyzer.Lines)

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.Output)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Union.DerivePattern Extends %RegisteredObject
{

Property Config As Config [ Private ];

Property Logger As Logger [ Private ];

Property Quiet As %Boolean [ Private ];

Method %OnNew(pConfig As Config, pLogger As Logger, pQuiet As %Boolean = 1) As %Status
{
	Set ..Config=pConfig
	Set ..Logger=pLogger
	Set ..Quiet=pQuiet
	Quit $$$OK
}

Method FindPattern(pMessages As %List, pLinesSymbols As LinesSymbols) As %String
{
	$$$ACASSERT(pMessages'="","FindPattern: no messages passed")
		
	Set tLines=pLinesSymbols.GetLines()
	
	// if there are NO lines left ..
	If tLines="" {
		$$$LOGOUTPUTWRITEIF1(..Logger,"  - no lines left",'..Quiet)
		Quit ""
	}
	
	// if there is only one line left ..
	If $ListLength(tLines)=1 {
	
		// the pattern is just the message with substitutions made
		Set tResult=pLinesSymbols.SubstituteSymbolsIn($ListToString($List(tLines)))
	}
	
	// .. more than one line ..
	Else {
			
		// run TopLevel to derive patterns from the messages
		Set tTopLevel=##class(TopLevel).%New(tLines,..Config,..Logger,,pLinesSymbols)
		Do tTopLevel.Run()
		
		// review results
		Set tPattern=..FirstResult(tTopLevel)
		If tPattern="" {
			$$$LOGOUTPUTWRITEIF1(..Logger,"  - no results found",'..Quiet)
			Quit ""
		}
	
		If $Length(tPattern,"<")=2 {
			Set tLinearizedPattern=##class(PatternUtils).LinearizeChoice(tPattern)
		}
		Else {
			Set tLinearizedPattern=tPattern
		}
		
		Set tOptimizedPattern=##class(PatternUtils).Optimize(tLinearizedPattern)
	
		Set tRet=..TreeBuilder(tOptimizedPattern)
		Set tResult=$Select(tRet="":tOptimizedPattern,1:tRet)
	}
	
	// PATCHED BACK-CHECK
	If 0 {
		Set tErr=..BackCheck(tResult,pMessages)
	}
			
	Quit tResult
}

ClassMethod FirstResult(pTopLevel As TopLevel) As %List [ Private ]
{
	Kill tSortedResults
	Do pTopLevel.GetSortedResults(.tSortedResults)
	Set tBestTermCount=$Order(tSortedResults(""))
	If tBestTermCount="" {
		Quit ""
	}

	Set tSubsKey=$Order(tSortedResults(tBestTermCount,""),+1,tRecord) If tSubsKey="" {ZTrap}
				
	Quit $List(tRecord)
}

Method TreeBuilder(pPattern As %String) As %String [ Private ]
{
	Set tTopLevel=##class(TopLevel).%New(pPattern,..Config,..Logger,,,1)
	Do tTopLevel.Run()
	Set tPattern=..FirstResult(tTopLevel)
	If tPattern="" {
		$$$LOGOUTPUTWRITEIF1(..Logger,"No pattern found in second run",'..Quiet)
		Quit ""
	}
	
	If tPattern=pPattern {
		Quit ""
	}
	
	Quit tPattern
}

/// Returns "" if OK, otherwise an error message
Method BackCheck(pPattern As %String, pMessageListList As %List) As %String [ Private ]
{
	Try {

		Set tOut=""
		Set tPtr=0 While $ListNext(pMessageListList,tPtr,tMessage) {
			Set tSubstMessageList=$ListFromString($ListToString(tMessage))
			Set tOut=tOut_$ListBuild(tSubstMessageList)
		}
		
		Set tPatternChecker=##class(PatternChecker).%New(tOut)
		Set tMismatches=tPatternChecker.CheckPattern(pPattern)
		If tMismatches'="" {
			Write "*** ",$ListLength(tMismatches)," messages did not match: ",pPattern,!
			Write "First mismatch:",!
			Write $ListToString($List(tMismatches)),!
			Return $ListLength(tMismatches)_" messages did not match"
		}
		
		Return ""
	}
	
	Catch err {
		Return err.DisplayString()
	}
}

}
