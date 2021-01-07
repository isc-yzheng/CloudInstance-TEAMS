/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging, EnsLib.InteropTools.HL7.MessageAnalyzer.Message, EnsLib.InteropTools.HL7.MessageAnalyzer.Monitor, EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace, EnsLib.InteropTools.HL7.MessageAnalyzer.Common)

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.Output)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Shell.Identify Extends %RegisteredObject
{

Property Config As Config [ Private ];

Property Logger As Logger [ Private ];

Property Version As %String [ Private ];

Property RigSchemas As RigSchemaCollection [ Private ];

Method %OnNew(pConfig As Config, pLogger As Logger, pVersion As %String, pRigSchemas As RigSchemaCollection) As %Status
{
	Set ..Config=pConfig
	Set ..Logger=pLogger
	Set ..RigSchemas=pRigSchemas
	Set ..Version=pVersion
	
	Quit $$$OK
}

/// Do a single Identify run on a set of messages
/// <p> The argument is expected to begin with "@" if it's a path
/// <p> Returns "" if OK, otherwise an error message
/// <p> Does NOT auto-load schemas if none are loaded on entry
Method ShellIdentify(Args As %String, pCombine As %Boolean, pQuiet As %Boolean, pWorkspace As Workspace = "", Output pDerivedSchemaNames As %List) As %String
{
	
	If ..Config.IsFlagSet("SCANNINGCONTROL") {
		Quit ..ShellIdentifyScanningControl(Args,pQuiet)
	}
	
	$$$IFSESSION0(StartRun)
	If 'pQuiet {
		$$$LOGOUTPUT1(..Logger,"Session #"_$$$MAS.SessionId_" run #"_$$$MAS.RunId_" begins")
	} 
	
	Set tProcessor=##class(IdentifyMessageProcessor).%New(..RigSchemas,..Config,..Version,..Logger,pCombine,pQuiet)
	Kill tRejectedMessages
	Do tProcessor.ScanMessages(Args,..Config.IsFlagSet("ABSTRACTMESSAGES"),..Config.GetOptionValue("OUTLIERTHRESHOLD"),..Config.IsFlagSet("MAKELIGHTMESSAGEFILES"),.tRejectedMessages,pQuiet)

	If 'pQuiet { 
		If $Get(tRejectedMessages) {
			$$$LOGOUTPUT1(..Logger,tRejectedMessages_" rejected messages")
			If ..Config.IsFlagSet("LOGALLREJECTEDMESSAGES") {
				For tI=1:1:tRejectedMessages {
					$$$LOGOUTPUT1(..Logger,tI_": "_tRejectedMessages(tI))
				}
			}
		}		
	}
		
	Do ..ProcessIdentifyReports(tProcessor,..Logger,pWorkspace,.pDerivedSchemaNames)
	
	If 'pQuiet {

		// report session summary
		$$$LOGOUTPUT1(..Logger,"")
		$$$LOGOUTPUT1(..Logger,"Summary Report")
		Do ##class(SummaryReport).RunReport($$$MAS.SessionId,$$$MAS.RunId,..Logger)
	}
	
	Quit ""
}

/// Returns "" if OK, otherwise an error message
Method ShellIdentifyScanningControl(Args As %String, pQuiet As %Boolean) As %String [ Private ]
{
	
		If $Extract(Args)="@" {
			Quit "Identify: The '@' format is not supported when the SCANNINGCONTROL flag is given"
		}
		
		Do ..IdentifyImplScan(Args,quiet)
		
		Quit ""
}

Method ProcessIdentifyReports(pProcessor As IdentifyMessageProcessor, pLogger As Logger, pWorkspace As Workspace, Output pDerivedSchemaNames As %List) [ Private ]
{
	
	Set tReportCount=pProcessor.GetReportCount()
	For tR=1:1:tReportCount {
	
		Set tParentFolders=pProcessor.GetMessageParentFolders(tR)
		If $ListLength(tParentFolders)=1 {
			Set tRawMessagesFolder=$List(tParentFolders)
			Set tMessagesFolder=$Select(##class(FolderType).IsMessagesFolderFromFolder(tRawMessagesFolder):tRawMessagesFolder,1:"")
		}
		Else {
			Set tMessagesFolder=""
		}
		
		Kill tStrategyManagers
		Do pProcessor.Report(tR,..RigSchemas.MakeMachineCollection(),..Config,pLogger,.tStrategyManagers) // FIXME create one machine collection only, if possible
		
		If '$Get(tStrategyManagers) {
			$$$LOGOUTPUT1(pLogger,"No strategies were found")
		}		
		Else {
			$$$LOGOUTPUT(pLogger,$ListBuild("Running strategies to find extensions:"))
			Do ..RunStrategies(tMessagesFolder,pLogger,pWorkspace,.tStrategyManagers,.pDerivedSchemaNames)
		}
	}
}

/// pMessagesFolder should be passed as "" if it has no 'messages' file
Method RunStrategies(pMessagesFolder As %String, pLogger As Logger, pWorkspace As Workspace, ByRef pStrategyManagers, Output pDerivedSchemaNames As %List = "") [ Private ]
{
	For tI=1:1:pStrategyManagers {
	
		Set tSM=pStrategyManagers(tI)
		Set tBestSchema=tSM.GetBestSchemaName()
		
		$$$LOGOUTPUT(pLogger,$ListBuild("","Finding extensions for "_tBestSchema))
		Kill tExtensions
		Do tSM.Extend(.tExtensions,..Config,..RigSchemas)
		
		If '$Get(tExtensions) {
			$$$LOGOUTPUT1(pLogger,"- no extensions proposed for "_tBestSchema)
		}
		Else {
			For k=1:1:tExtensions {
			
				$$$LOGOUTPUT1(pLogger," - "_tExtensions(k).Describe())
				Set tSchemaSource=##class(Common).ParseSchemaSpec(tBestSchema,..Version)
				If tSchemaSource="" {ZTrap}
				Set tNewSchemaSource=tExtensions(k).Apply(tSchemaSource)
				$$$LOGOUTPUT1(pLogger,"   - new schema source: "_tNewSchemaSource)
				
				$$$IFSESSION(ScanEvent("DerivedSchema",$LB("SchemaName",tBestSchema),$LB("OldSchemaSource",tSchemaSource),$LB("NewSchemaSource",tNewSchemaSource),$LB("Extension",tExtensions(k).Describe())))
				
				If pMessagesFolder'="" {
					Set tNewSchemaName=pWorkspace.MakeSchemaDirectory(pMessagesFolder,tBestSchema,tNewSchemaSource)
					Set pDerivedSchemaNames=pDerivedSchemaNames_$ListBuild(tNewSchemaName)
					$$$IFSESSION(ScanEvent("WriteDerivedSchema",$LB("BaseSchemaName",tBestSchema),$LB("NewSchemaName",tNewSchemaName),$LB("NewSchemaSource",tNewSchemaSource),$LB("TargetFolder",pMessagesFolder)))
				}
			}
		}
	}
}

/// Invalid if more than one schema is set up
Method IdentifyImplScan(MessageText As %String, Quiet As %Boolean) [ Private ]
{
	If ..RigSchemas.Count()>1 {
		$$$FATAL("IdentifyImplScan: more than one schema is selected")
	}
	
	Set tFirstSchemaName=..RigSchemas.NextByName("")
	Kill tShortestFinalDiffRecords
	Kill tFailureOutcome
	Do ##class(Common).RunImplScan(##class(MessageUtils).MessageSegmentTypes(MessageText),..RigSchemas.GetByName(tFirstSchemaName),..Config,0,Quiet,.tFailureOutcome,.tShortestFinalDiffRecords)
	
	// if it's a control failure ..
	If tFailureOutcome.FailureOutcomeType()=$$$FOCONT {
		Write "Control failure",!
	}
	
	Else {
	
		If '$Get(tShortestFinalDiffRecords) {
			Write "No diff records",!
		}
		Else {
			Write "Shortest diff records",!
			For tI=1:1:tShortestFinalDiffRecords {
				Write tShortestFinalDiffRecords(tI).Show(),!
			}
		}
	}
}

}
