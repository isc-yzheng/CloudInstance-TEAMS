/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging, EnsLib.InteropTools.HL7.MessageAnalyzer.Monitor, EnsLib.InteropTools.HL7.MessageAnalyzer.Message, EnsLib.InteropTools.HL7.MessageAnalyzer.Ensemble, EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell)

Include (EnsHL7, EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.Workflow, EnsLib.InteropTools.HL7.MessageAnalyzer.Monitor, EnsLib.InteropTools.HL7.MessageAnalyzer.Output)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace.Workflow Extends %RegisteredObject
{

Property WorkspaceFolderName As %String [ Private ];

Property Workspace As Workspace [ Private ];

Property Logger As Logger [ Private ];

Method %OnNew(pWorkspaceFolderName As %String, pLogger As Logger) As %Status
{
	Set tRet=##class(Workspace).WorkspaceExists(pWorkspaceFolderName)
	If '(($Data(pWorkspaceFolderName)#10)=1) && ($Length(tRet)<=1) {$$$THROW("Workflow: invalid constructor argument (workspace)")}
	If '(($Data(pLogger)#10)=1) || '$IsObject(pLogger) || 'pLogger.%IsA("EnsLib.InteropTools.HL7.MessageAnalyzer.Logging.Logger") {$$$THROW("Workflow: invalid constructor argument (logger)")}
	
	Set ..WorkspaceFolderName=pWorkspaceFolderName
	Set ..Workspace=$Select(tRet="":"",1:##class(Workspace).%New(pWorkspaceFolderName))
	Set ..Logger=pLogger
	
	// new session
	Set $$$MAS=##class(Session).%New()
	$$$LOGOUTPUT(..Logger,$LB("","Session id is #"_$$$MAS.SessionId))
	
	Quit $$$OK
}

/// Stores default settings and arguments in ^Ens.MA("WORKFLOW","HISTORY",..)
/// <p> Items:
/// <ul>
///  <li> WORKSPACE
///  <li> LOGFOLDER
///  <li> HL7VERSION
///  <li> GROUPBY
///  <li> EXPORTFILE
ClassMethod Interactive()
{
	Do ..InteractiveWithLog(##class(Logger).NullLogger())
}

ClassMethod InteractiveWithLog(pLogger As Logger = "")
{
	Write "HL7 Message Analyzer V0.3",!
	Write "Enter '^' to exit from any prompt",!!
	
	// input the logging destination if needed
	If pLogger="" {
		Set tLogger=##class(Input).MakeLogger() If tLogger="" {Quit}
		Write !
	}
	Else {
		Set tLogger=pLogger
	}
	
	Set tGlobalInfo=##class(GlobalInfo).%New()

	// input the workspace folder
	Write "Enter the path to the workspace you want to use",!
	Set tRet=##class(Input).WorkspaceFolder("WORKSPACE") If tRet="" {Quit}
	Set $ListBuild(tWorkspaceFolder,tWorkspaceExists)=tRet
	
	// if the workspace doesn't already exist ..
	If 'tWorkspaceExists {
	
		Write "Workspace does not currently exist",!
		Write !,"Enter a single source file or folder which contains message files to move into the workspace ..",!!

		// input the source path
		Set tSourcePath=##class(Input).SourcePath() If tSourcePath="" {Quit}
		
		// input the HL7 version
		Write !,"Enter the schema to use",!
		Set tVersion=##class(Input).Version(tGlobalInfo) If tVersion="" {Quit}

		Write !
		Write "Messages can be grouped by one or more of the following 2-letter codes:",!
		Set tAccessors=##class(KeySpec).Accessors()
		Set tPtr=0 While $ListNext(tAccessors,tPtr,tOneAccessor) {
			Set $ListBuild(tShortName,tLongName)=tOneAccessor
			Write " ",tShortName," - ",tLongName,!
		}
		Write !
		Write "Enter one or more codes, separated by commas ..",!
		Set tGroupBy=##class(Input).GroupBy() If tGroupBy="" {Quit}
		Set tKeySpec=tGroupBy
		
		// create the workflow
		Set tWorkflow=##class(Workflow).%New(tWorkspaceFolder,tLogger)
		
		// run pass0 (create workspace from messages)
		Set tQuiet=1
		Kill tRejectedMessages
		Set tErr=tWorkflow.CreateWorkspace(tSourcePath,tVersion,tKeySpec,tQuiet)
		If tErr'="" {
			Write tErr," (pass0)",!
			Quit
		}
	}
	
	// .. the workspace already exists ..
	Else {
	
		Write "Workspace currently exists",!		
		
		// create the workflow
		Set tWorkflow=##class(Workflow).%New(tWorkspaceFolder,tLogger)
		
		// show the workspace HL7 version
		Set tVersion=tWorkflow.Workspace.GetWorkspaceVersion()
		Write "Schema is ",tVersion,!
	}
							
	// process the workspace
	Do tWorkflow.RunWorkflow()
			
	// maybe export schemas
	Do tWorkflow.InteractiveExport(tWorkspaceFolder)
}

/// Process the workspace
Method RunWorkflow()
{
	Write !,"Begin run ..",!
	
	$$$SETMAXSTORE
	
	// the workspace folder must exist as a valid workspace
	If ..Workspace="" {ZTrap}
	
	// common flags
	Set tCombine=1
	Set tQuiet=1
	
	// compiled schemas
	Set tRigSchemas=##class(RigSchemaCollection).%New()
	Write "Loading document structure definitions",!
	Do ##class(Common).ProcessSchemaSelection("*",tRigSchemas,..Workspace.GetWorkspaceVersion(),##class(Config).%New(),..Logger,tQuiet)
	
	// pass1 - match using message type
	Write "Match messages to document structures associated with message type",!
	Set tErr=..Workspace.Pass1(tRigSchemas,tCombine,tQuiet,..Logger)
	If tErr'="" {
		Write tErr," (pass1)",!
		Quit
	}
				
	// pass2 - match freely
	Write "Match messages to any loaded document structure",!
	Set tErr=..Workspace.Pass2(tRigSchemas,tCombine,tQuiet,..Logger)
	If tErr'="" {
		Write tErr," (pass2)",!
		Quit
	}
		
	// pass3 - derive new schemas
	Write "Derive new document structures",!
	Set tErr=..Workspace.Pass3(tRigSchemas,tCombine,tQuiet,..Logger,.tDerivedSchemaNames)
	If tErr'="" {
		Write tErr," (pass3)",!
		Quit
	}
	Set tDerivedSchemaCount=$ListLength($Get(tDerivedSchemaNames))
	
	// if there are any new derived schemas ..
	If tDerivedSchemaCount {
	
		// pass2a - match-run to match derived schemas		
		Write "Match messages to any loaded document structure",!
		Set tErr=..Workspace.Pass2(tRigSchemas,tCombine,tQuiet,..Logger)
		If tErr'="" {
			Write tErr," (pass2a)",!
			Quit
		}	
	}
	
	// session summary report
	Do ##class(SummaryReport).SessionReport($$$MAS.SessionId,..Logger)	
		
	Write !,"Finished.",!
	
	// summary report on workspace - to current device
	Do ##class(WorkspaceSummary).%New(##class(Logger).%New()).Summary(..WorkspaceFolderName)
}

/// Create a new workspace from messages
Method CreateWorkspace(pSourcePath As %String, pVersion As %String, pKeySpec As %String, pQuiet As %Boolean) As %String
{
	$$$ACASSERT(..Workspace="","CreateWorkspace: workspace object already set up")
	
	Write "Copy messages from source folder to workspace",!
	Kill tRejectedMessages
	Set tErr=##class(Workspace).CreateWorkspace(..WorkspaceFolderName,pSourcePath,pVersion,"",pKeySpec,pQuiet,..Logger,.tRejectedMessages)
	If $Get(tRejectedMessages) {
		Write tRejectedMessages," rejected messages:",!
		For tI=1:1:tRejectedMessages {
			Write " ",$Extract(tRejectedMessages(tI),1,30),"...",!
		}
	}
	If tErr'="" {
		Quit tErr
	}
	
	Set ..Workspace=##class(Workspace).%New(..WorkspaceFolderName)
	
	Quit ""
}

/// Interact with the user to maybe export derived schemas to a .XML file
Method InteractiveExport(pWorkspaceFolderName As %String)
{
	Kill tAnyDerivedSchemaNames
	Do ..Workspace.GetDerivedSchemaNames(.tAnyDerivedSchemaNames)
	
	If $Data(tAnyDerivedSchemaNames)\10 {
	
		Kill tByFacility
		Set tKey="" While 1 {
			Set tKey=$Order(tAnyDerivedSchemaNames(tKey),+1,tParentFolder) If tKey="" {Quit}
			Set tByFacility(tParentFolder,tKey)=""
		}
		
		Write !,"This workspace has derived document structures in these facilities:",!
		Set tParentFolder="" While 1 {
			Set tParentFolder=$Order(tByFacility(tParentFolder)) If tParentFolder="" {Quit}
			Write !," ",##class(Common).LastFolderSegment(tParentFolder),!
			Set tKey="" While 1 {
				Set tKey=$Order(tByFacility(tParentFolder,tKey)) If tKey="" {Quit}
				Write "  ",tKey,!
			}
		}
		Write !
		Set tIn=##class(Input).InputYN("Would you like to write the document structures to an export file?")
		If tIn="" {Quit}
		If tIn="Y" {
			
			Kill tNewNames
			If '##class(Input).SchemaNewNames(.tByFacility,..Workspace.GetWorkspaceVersion(),.tNewNames) {
				Quit
			}
			
			Write !,"If no extension is given, .HL7 will be used",!
			Write "Any existing file will be overwritten",!
			Set tTargetExportFile=##class(Input).ExportFile()
			If tTargetExportFile="" {Quit}
			
			Do ##class(ExportSchemas).ExportDerivedSchemas(pWorkspaceFolderName,tTargetExportFile,.tNewNames)
			
			Write !,"Exported document structures to ",tTargetExportFile,".",!
		}
	}
}

}
