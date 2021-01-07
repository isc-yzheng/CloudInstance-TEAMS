/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Outcome, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Extend.Extensions, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell, EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Match.Lexer, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Extend, EnsLib.InteropTools.HL7.MessageAnalyzer.Derive, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging, EnsLib.InteropTools.HL7.MessageAnalyzer.API, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Extend.Strategies.ScanImpl, EnsLib.InteropTools.HL7.MessageAnalyzer.Lines)

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.Output)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Extend.Strategies.Scan Extends %RegisteredObject [ Final ]
{

Property Config As Config [ Private ];

Property Logger As Logger [ Private ];

Property IgnoreTrailingZ As %Boolean [ Private ];

ClassMethod Extend(pBestSchemaName As %String, pBestSchemaSource As %String, ByRef pOutcomes, ByRef pExtensions, pMachineCollection As MachineCollection, pConfig As Config, pLogger As Logger, pRigSchemas As RigSchemaCollection)
{
	If '$Get(pOutcomes) {$$$FATAL("Extend: caller responsibility: at least one outcome should be given")}
		
	If pConfig.IsFlagSet("ENABLESCANEXTENSION") {
		
		Set tScan=..%New(pConfig,pLogger)
		
		Kill tMessageArray
		Do ..GetMessagesFromOutcomes(.pOutcomes,.tMessageArray,pConfig)
		
		Set tOldExtensionsCount=$Get(pExtensions)
		
		If pConfig.IsFlagSet("LIMITDIFFCHANGES") {
			Do tScan.ExtendProgressively(pBestSchemaName,pBestSchemaSource,.tMessageArray,.pExtensions)
		}
		Else {
			
			// construct a diff collection from the machine associated with the best-matching schema
			Set tDiffCollection=##class(DiffCollection).MakeDiffCollection(pMachineCollection.GetAt(pBestSchemaName),pConfig,pLogger)
		
			// get the schema from the rig collection
			Set tRigSchema=pRigSchemas.GetByName(pBestSchemaName)		
			
			Do ##class(ScanBranch).ExtendImpl(pConfig,pLogger,pConfig.GetExtensionOption("NOSCANZ"),pBestSchemaName,pBestSchemaSource,.tMessageArray,pMachineCollection,tRigSchema,tDiffCollection,,.pExtensions)
		}
		
		If $Get(pExtensions)'=tOldExtensionsCount {
			$$$IFSESSION(ScanEvent("StrategySuccess",$LB("Strategy","Scan"),$LB("SchemaName",pBestSchemaName),$LB("SchemaSource",pBestSchemaSource)))
		}
	}
}

Method %OnNew(pConfig As Config, pLogger As Logger) As %Status
{
	Set ..Config=pConfig
	Set ..Logger=pLogger
	
	// we can ignore messages with trailing Z-segments if an extension option is set
	Set ..IgnoreTrailingZ=..Config.GetExtensionOption("NOSCANZ")
	
	Quit $$$OK
}

Method ExtendProgressively(pBestSchemaName As %String, pBestSchemaSource As %String, ByRef pMessageArray, ByRef pExtensions As Extend) [ Private ]
{
	Set tScanBranchList=##class(ScanBranchList).%New("","")
	Do tScanBranchList.AddScanBranch(0,##class(ScanBranch).%New(pBestSchemaSource,.pMessageArray,"",..Config,..Logger))
	// - the priority is arbitrary because this branch will be immediately removed anyway
	
	Kill tTried
	While 1 {
	
		If ..Config.IsFlagSet("LOGSCANEXTENSION") {
			Write "Branch count: ",tScanBranchList.GetBranchCount(),! 
		}	
		
		// the branch with fewest mismatches
		Set tBranch=tScanBranchList.NextBranch()
		If tBranch="" {
			Quit
		}
		
		Kill tNewSchemaSourceList
		Set tMatchingSchema=tBranch.ExtendProgressivelyOne(..IgnoreTrailingZ,.tNewSchemaSourceList)
		If tMatchingSchema'="" {
			Set pExtensions($I(pExtensions))=##class(ExtendReplace).%New(tMatchingSchema)						
			$$$LOGOUTPUTIFCONFIG(..Logger,$LB("++ found matching schema:",tMatchingSchema),"LOGSCANEXTENSION")
			Return
		}
		
		If tScanBranchList.ExceededLimits() {		
			$$$LOGOUTPUTIFCONFIG1(..Logger,"Scan: branch resource limits exceeded","LOGIDENTIFY")
			Quit
		}
		
		Set tDiffCollection=tBranch.GetDiffCollection()
		Set tSizeMetric=tBranch.SizeMetric()
				
		If ..Config.IsFlagSet("LOGSCANEXTENSION") {
			Write "Metric: ",tSizeMetric,! 
		}	
				
		Set tPtr=0 While $ListNext(tNewSchemaSourceList,tPtr,tNewSchemaSource) {

			Set tNewBranch=##class(ScanBranch).%New(tNewSchemaSource,.pMessageArray,tDiffCollection,..Config,..Logger)

			Do tScanBranchList.AddScanBranch(tSizeMetric,tNewBranch)
		}		
	}
	
	$$$LOGOUTPUTIFCONFIG1(..Logger,"== found NO matching schema","LOGSCANEXTENSION")
}

/// returns pMessageArray(1..pMessageArray)=MESSAGESEGMENTLIST
ClassMethod GetMessagesFromOutcomes(ByRef pOutcomes, Output pMessageArray, pConfig As Config) [ Private ]
{
	$$$SHOULDBEUNDEF(pMessageArray)
	
	$$$ACASSERT($Get(pOutcomes),"GetMessagesFromOutcomes: no outcomes passed")
	
	// we can ignore messages with trailing Z-segments if an extension option is set
	Set tIgnoreTrailingZ=pConfig.GetExtensionOption("NOSCANZ")
	
	For tI=1:1:pOutcomes {
	
		// the original message
		Set tOriginalMessageList=pOutcomes(tI).BranchContext.MSR.OriginalMessage()

		// unless this message is excluded by configuration ..
		If 'tIgnoreTrailingZ || ($Extract($List(tOriginalMessageList,*))'="Z") {
			Set pMessageArray($I(pMessageArray))=tOriginalMessageList
		}
	}
}

}
