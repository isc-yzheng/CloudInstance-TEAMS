/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Outcome, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Extend.Extensions, EnsLib.InteropTools.HL7.MessageAnalyzer.Analysis, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell, EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging)

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.Output)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Extend.Strategies.AppendZSegments Extends %RegisteredObject [ Final ]
{

ClassMethod Extend(pBestSchemaName As %String, pBestSchemaSource As %String, ByRef pOutcomes, ByRef pExtensions, pMachineCollection As MachineCollection, pConfig As Config, pLogger As Logger, pRigSchemas As RigSchemaCollection)
{
	#Dim tSelectedOutcomes
	
	If '$Get(pOutcomes) {$$$FATAL("Extend: caller responsibility: at least one outcome should be given")}
	
	If pConfig.IsFlagSet("ENABLEAPPENDZ") {
	
		// select outcomes whose remaining segments are all Z-segments
		Do ..SelectZOutcomes(.pOutcomes,.tSelectedOutcomes)
		If '$Get(tSelectedOutcomes) {Quit} // no selected outcomes
	
		// turn the outcomes into a schema pattern
		Set tPattern=..AnalyzeZOutcomes(.tSelectedOutcomes,pConfig,pLogger,pRigSchemas)
		
		// if we got a pattern ..
		If tPattern'="" {
		
			// extend the schema with the pattern as an optional segment
			Set tStandardFormatPattern=##class(Common).PutBackSquiggles($$makeoptional(tPattern))
			Set pExtensions($I(pExtensions))=##class(ExtendSequence).%New(tStandardFormatPattern,$Length(pBestSchemaSource)+1)
			
			$$$IFSESSION(ScanEvent("StrategySuccess",$LB("Strategy","AppendZSegments"),$LB("SchemaName",pBestSchemaName),$LB("SchemaSource",pBestSchemaSource)))
		}
	}
	
	Quit
	
makeoptional(pattern)
	Set node=##class(Common).CompileSchema("["_pattern_"]")
	Quit node.OptimizedPattern()
}

/// Given an array of outcomes, return either a schema pattern fragment or "" if none could be found
ClassMethod AnalyzeZOutcomes(ByRef pOutcomes, pConfig As Config, pLogger As Logger, pRigSchemas As RigSchemaCollection) As %String [ Private ]
{
	$$$LOGOUTPUTIFCONFIG1X(pLogger,"AnalyzeZOutcomes outcomes:","LOGAPPENDZ",pConfig)
	Set tLines=""
	For tI=1:1:pOutcomes {
		Set tRemaining=pOutcomes(tI).BranchContext.LastSucceedingMessageRemaining
		$$$LOGOUTPUTIFCONFIG1X(pLogger," "_tRemaining,"LOGAPPENDZ",pConfig)
		Set tLines=tLines_$ListBuild(tRemaining)
	}
	
	Set tAS=##class(AbstractStrings).%New(tLines,1,pConfig,pLogger)
	Do tAS.GetCollections(.tCollections)

	// for each collection, ignoring outlier collections
	Set tPatterns=""
	For tI=1:1:tCollections {
		Set tColl=tCollections(tI)
	
		Set $ListBuild(tError,tOnePattern)=tColl.DerivePattern("Collection"_tI)
		If tError="" {
			Set tPatterns=tPatterns_$ListBuild(tOnePattern)
		}
		Else {
			$$$LOGOUTPUTIFCONFIG1X(pLogger,"Failed to derive pattern for '"_tColl.ShowCLIList()_"': "_tError,"LOGABSTRACTSTRINGS",pConfig)
		}
	}
	
	If tPatterns="" {
		Quit "" // no patterns derived
	}
	
	Set tOverallPattern=##class(Common).ListToPattern(tPatterns)
	
	$$$LOGOUTPUTIFCONFIG1X(pLogger,"AnalyzeZOutcomes pattern="_tOverallPattern,"LOGAPPENDZ",pConfig)
	
	Quit tOverallPattern
}

/// Given a list of outcomes, return (in pNewOutcomes) a list of those outcomes which have unmatched trailing Z-segments (and no other change)
ClassMethod SelectZOutcomes(ByRef pOutcomes, Output pNewOutcomes) [ Private ]
{
	#Dim tI,tOutcome,tRemaining,tSelect,tJ
	
	$$$SHOULDBEUNDEF(pNewOutcomes)
	
	For tI=1:1:pOutcomes {
		
		Set tOutcome=pOutcomes(tI)
		If tOutcome.FailureOutcomeType()'=$$$FOSEND {$$$FATAL("SelectZOutcomes: caller responsibility: we expect the schema to be ended and the message not")}
	
		Set tRemaining=tOutcome.BranchContext.MSR.RemainingItems()
		If tRemaining="" {$$$FATAL("SelectZOutcomes: caller responsibility: we expect the message NOT to be ended")}
	
		Set tSelect=1
		
		Set tPtrJ=0 While $ListNext(tRemaining,tPtrJ,tElemJ) {
			If $Extract(tElemJ)'="Z" {
				Set tSelect=0
				Quit  // not all the segments are Z-segments
			}
		}
		
		If tSelect {
			Set pNewOutcomes($I(pNewOutcomes))=tOutcome
		}
	}
}

}
