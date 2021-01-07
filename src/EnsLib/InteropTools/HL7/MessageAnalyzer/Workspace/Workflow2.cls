/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace.Menu, EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging, EnsLib.InteropTools.HL7.MessageAnalyzer.Monitor, EnsLib.InteropTools.HL7.MessageAnalyzer.Message, EnsLib.InteropTools.HL7.MessageAnalyzer.Ensemble, EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell, EnsLib.InteropTools.HL7.MessageAnalyzer.Validation, EnsLib.InteropTools.HL7.MessageAnalyzer.Validation.Segment)

Include (EnsHL7, EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.Workflow, EnsLib.InteropTools.HL7.MessageAnalyzer.Monitor, EnsLib.InteropTools.HL7.MessageAnalyzer.Output)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace.Workflow2 Extends %RegisteredObject
{

Property WorkspaceFolderName As %String [ Private ];

Property Workspace As Workspace [ Private ];

Property SourceFolder As %String [ Private ];

Property Version As %String [ Private ];

Property SchemaName As %String [ Private ];

Property Logger As Logger [ Private ];

Property MenuRunner As MenuRunner [ Private ];

Property MessageCountCache As %Integer [ Private ];

Property GlobalInfo As GlobalInfo [ Private ];

Parameter WORKFLOW2VERSION = 0.9;

Method %OnNew(pWorkspaceFolderName As %String, pSourceFolder As %String, pVersion As %String, pSchemaName As %String, pLogger As Logger) As %Status
{
	Set tRet=##class(Workspace).WorkspaceExists(pWorkspaceFolderName)
	If '(($Data(pWorkspaceFolderName)#10)=1) && ($Length(tRet)<=1) {$$$THROW("Workflow: invalid constructor argument (workspace)")}
	If '(($Data(pSchemaName)#10)=1) || (pSchemaName="") {$$$THROW("Workflow: invalid constructor argument (document structure name)")}
	If '(($Data(pLogger)#10)=1) || '$IsObject(pLogger) || 'pLogger.%IsA("EnsLib.InteropTools.HL7.MessageAnalyzer.Logging.Logger") {$$$THROW("Workflow: invalid constructor argument (logger)")}
	
	Set ..WorkspaceFolderName=pWorkspaceFolderName
	Set ..Workspace=$Select(tRet="":"",1:##class(Workspace).%New(pWorkspaceFolderName))
	Set ..SourceFolder=pSourceFolder
	Set ..Version=pVersion
	Set ..SchemaName=pSchemaName
	Set ..Logger=pLogger
	Set ..MenuRunner=##class(MenuRunner).%New()
	
	Do ..InvalidateMessageCountCache()
	
	Set ..GlobalInfo=##class(GlobalInfo).%New()
	
	// new session
	Set $$$MAS=##class(Session).%New()
	$$$LOGOUTPUT(..Logger,$LB("","Session id is #"_$$$MAS.SessionId))
	
	Quit $$$OK
}

/// Stores default settings and arguments in ^Ens.MA("WORKFLOW","HISTORY",..)
/// <p> Items:
/// <ul>
///  <li> WORKSPACE2
///  <li> LOGFOLDER
///  <li> SCHEMANAME
///  <li> HL7VERSION
///  <li> EXPORTFILE
///  <li> SOURCEPATH
/// </ul>
ClassMethod Interactive()
{
	Do ..InteractiveWithLog(##class(Logger).NullLogger())
}

ClassMethod InteractiveNoET()
{
	Do ..InteractiveWithLogNoET(##class(Logger).NullLogger())
}

ClassMethod InteractiveWithLog(pLogger As Logger = "")
{
	Try {
		Do ..InteractiveWithLogNoET(pLogger)
	}
	
	Catch err {
		Write !!,"FATAL ERROR: ",err.DisplayString(),!
	}
}

ClassMethod InteractiveWithLogNoET(pLogger As Logger = "")
{
	// input the logging destination if needed
	If pLogger="" {
		Set tLogger=##class(Input).MakeLogger() If tLogger="" {Quit}
		Write !
	}
	Else {
		Set tLogger=pLogger
	}
	
	Set tGlobalInfo=##class(GlobalInfo).%New()

	Set tFirstTime=1
	Set tForceNew=0
	Do {
	
		Write !,"HL7 Message Analyzer/2 ",..#WORKFLOW2VERSION,!
		Write "Enter '^' to exit from any prompt",!!
		
		// set up a workflow object, either an existing one or a new one setup by interacting with the user
		If tFirstTime {
		
			Set tWorkflow=..MakeWorkflow(tGlobalInfo,tLogger)
			If tWorkflow="" {Quit} // - the user cancelled
			
			Set tFirstTime=0
		}
		
		Else {
			
			Set tWorkflow=..MakeNewWorkflow(tGlobalInfo,tForceNew,tLogger)
			If tWorkflow="" {Quit} // - the user cancelled
			Set tForceNew=0
		}
		
		// process the workspace
		Set tRestart=tWorkflow.RunWorkflow()
		
		// restarts should force new
		Set tForceNew=1
		
	} While tRestart
}

/// Top-menu loop; returns 0 if the user quits the menu or 1 if they select Restart
Method RunWorkflow() As %Integer
{
	$$$SETMAXSTORE
	
	Set tMenu=$$$MENUWF2TOP("DS","VM","HF","SW")
	
	While 1 {
	
		// describe the workspace
		Do ..DescribeWorkspace()
		
		// run the menu
		Set tSelectionMade=..MenuRunner.RunMenu(tMenu,.tSelectedOption)
		
		// if they cancelled ..
		If 'tSelectionMade {
			Quit  // quit the While loop
		}
		
		// if they selected Setup Workspace ..
		If tSelectedOption="SW" {
			Return 1 // tell the caller
		}
	
		// process menu selection
		Do $Case(tSelectedOption,
			"DS":..RunSchemaDerivation(),
			"VM":##class(Workflow2Validation).%New(..WorkspaceFolderName,..Workspace,..SchemaName,..MenuRunner).RunValidation(),
			"HF":##class(Workflow2History).%New(..MenuRunner).RunHistory()
			)
		
		Write !	
		Write "- - - - -",!
	}
	
	// tell caller: don't restart
	Quit 0
}

Method RunSchemaDerivation() [ Private ]
{
	Write !
	Write "This workspace has ",..MessageCount()," messages",!!
	Write "Document structure derivation can take a long time so you can elect to process just some of them",!
	
	While 1 {
		Set tIn=##class(Input).Input("Enter the percentage of messages to scan",100)
		If tIn="^" {Return} // exit to caller
		If tIn?1.N, tIn>=1, tIn<=100 {Quit} // quit the While loop
		Write " - please enter a whole number between 1 and 100, or ^ to quit",!
	}
	
	If tIn=100 {
		Set tSkipCount=0
	}
	Else {
		Set tSkipCount=100 \ tIn
	}
	
	Write !,"Begin document structure derivation run ..",!
	
	// the workspace folder must exist as a valid workspace
	If ..Workspace="" {ZTrap}
	
	// common flags
	Set tCombine=1
	Set tQuiet=1
	
	// compiled schema
	Set tRigSchemas=##class(RigSchemaCollection).%New()
	Write "Loading document structure definition",!
	Do ##class(Common).ProcessSchemaSelection(..SchemaName,tRigSchemas,..Version,##class(Config).%New(),..Logger,tQuiet)
	
	// pass2 - match freely
	Write "Match messages to document structure: ",..SchemaName,!
	Set tErr=..Workspace.Pass2(tRigSchemas,tCombine,tQuiet,..Logger)
	If tErr'="" {
		Write tErr," (pass2)",!
		Quit
	}
			
	Set tConfig=##class(Config).%New()
	If tSkipCount {
		Write "Processing ",..MessageCount() \ tSkipCount," messages for derivation scan",!
		Do tConfig.SetOptionValue("MESSAGESKIPCOUNTPROC",tSkipCount)
	}
	Set tStartTime=$ZH
	Set tErr=..Workspace.Pass3(tRigSchemas,tCombine,tQuiet,..Logger,.tDerivedSchemaNames,tConfig)
	Set tEndTime=$ZH
	Set tSeconds=$FNumber(tEndTime-tStartTime,,0)
	Write !,"Time to run derivation scan: ",tSeconds," ",..PluralizeSecond(tSeconds),!
	If tErr'="" {
		Write tErr," (pass3)",!
		Quit
	}
	Set tDerivedSchemaCount=$ListLength($Get(tDerivedSchemaNames))
	
	// if there are any new derived schemas ..
	If tDerivedSchemaCount {
	
		// pass2a - match-run to match derived schemas		
		Write "Match messages to derived document structure",!
		Set tErr=..Workspace.Pass2(tRigSchemas,tCombine,tQuiet,..Logger)
		If tErr'="" {
			Write tErr," (pass2a)",!
			Quit
		}	
	}
	
	Else {
		Write !,"No new document structures were derived.",!
	}
	
	// session summary report
	Do ##class(SummaryReport).SessionReport($$$MAS.SessionId,..Logger)	
		
	Write !,"Finished.",!
	
	// summary report on workspace - to current device
	Do ##class(WorkspaceSummary).%New(##class(Logger).%New()).Summary(..WorkspaceFolderName)
					
	// maybe update/export schemas
	Set SHOULDUPDATE=1
	Do ..InteractiveExportOrUpdateSchemas(SHOULDUPDATE,..WorkspaceFolderName)
}

/// Returns $LB(FOLDER,EXISTS?)
ClassMethod WorkspaceFolder(pForceNew As %Boolean) As %List [ Private ]
{
	Set tWorkspaceFolder=$Get($$$WFHISTORYITEMREF("WORKSPACE2"))
	
	// if the folder is set up and pForceNew isn't set ..
	If tWorkspaceFolder'="",'pForceNew {
		
		Set tRet=##class(Workspace).WorkspaceExists(tWorkspaceFolder)
		
		// does not exist ..
		If tRet="" {
			Quit $ListBuild(tWorkspaceFolder,0)
		}
			
		// exists as a valid workspace ..
		If $Length(tRet) = 1 {			
			Quit $ListBuild(tWorkspaceFolder,1)			
		}
			
		// error message ..
		Write tRet,!

		// .. fall through to input ..
	}
	
	Write "Enter the path to the workspace you want to use",!
	Quit ##class(Input).WorkspaceFolder("WORKSPACE2")
}

/// Create a new workspace from messages
Method CreateWorkspace(pKeySpec As %String, pQuiet As %Boolean) As %String [ Private ]
{
	$$$ACASSERT(..Workspace="","CreateWorkspace: workspace object already set up")
	
	Write "Copy messages from source folder to workspace",!
	Kill tRejectedMessages
	Set tErr=##class(Workspace).CreateWorkspace(..WorkspaceFolderName,..SourceFolder,..Version,..SchemaName,pKeySpec,pQuiet,..Logger,.tRejectedMessages)
	If $Get(tRejectedMessages) {
		Write tRejectedMessages," rejected messages:",!
		For tI=1:1:tRejectedMessages {
			Write " ",$Extract(tRejectedMessages(tI),1,30),"...",!
		}
	}
	If tErr'="" {
		Quit tErr
	}
	
	// if the target directory doesn't exist (because no messages were copied in) ..
	If '##class(%File).DirectoryExists(..WorkspaceFolderName) {
		
		Quit "No messages were copied into the workspace"
	}
	
	Set ..Workspace=##class(Workspace).%New(..WorkspaceFolderName)
	
	Quit ""
}

/// Returns "" if OK, otherwise an error message
ClassMethod ClearWorkspace(pTargetFolder As %String) As %String [ Private ]
{
	If ('##class(EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace.FolderType).IsContainerFolderFromFolder(pTargetFolder,.tSubType)) || (tSubType'="root") {
		Quit "'"_pTargetFolder_"' is not a workspace folder!"
	}
	
	If '##class(%File).RemoveDirectoryTree(pTargetFolder) {
		Quit "Unable to remove '"_pTargetFolder_"'"
	}

	Quit ""
}

/// Interact with the user to maybe update the database with derived schemas
Method InteractiveExportOrUpdateSchemas(pShouldUpdate As %Boolean, pWorkspaceFolderName As %String)
{
	If pShouldUpdate {
	
		Kill tAnyDerivedSchemaNames
		Do ..Workspace.GetDerivedSchemaNames(.tAnyDerivedSchemaNames)
		
		If $Data(tAnyDerivedSchemaNames)\10 {
		
			Set tDerivedSchemaName=$Order(tAnyDerivedSchemaNames(""),+1,tDerivedSchemaPath) If tDerivedSchemaName="" {ZTrap}
			
			Set tDerivedSchemaSource=##class(FolderType).DerivedSchemaSource(tDerivedSchemaPath,tDerivedSchemaName)
			
			If tDerivedSchemaSource'="" {
			
				Write !,"This workspace has derived a new document structure based on ",..SchemaName,":",!
				Write !,..SchemaName,!,##class(Common).ParseSchemaSpec(..SchemaName,..Version),!
				Write !,"DERIVED",!,tDerivedSchemaSource,!
				
				Do ..InteractiveUpdateSchemas(pWorkspaceFolderName,tDerivedSchemaSource)
			}
		}	
	}
	
	Else {
	
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
			
			Do ..InteractiveExport(pWorkspaceFolderName,.tByFacility)
		}	
	}
}

/// Interact with the user to maybe update the database with the derived schema
Method InteractiveUpdateSchemas(pWorkspaceFolderName As %String, pDerivedSchemaSource As %String)
{
	Write !,"Updating ",..Version,":",..SchemaName,!
	
	Set tIn=##class(Input).InputYN("Would you like to update the document structure in the database?")
	If tIn="" {Quit}
	If tIn="Y" {
				
		Do ##class(UpdateSchemas).UpdateSchemas(pWorkspaceFolderName,..Version,..SchemaName,pDerivedSchemaSource)
		
		Write !,"Updated document structure ",..Version,":",..SchemaName,!
	}
}

/// Interact with the user to maybe export derived schemas to a .XML file
Method InteractiveExport(pWorkspaceFolderName As %String, ByRef pByFacility)
{
	Set tIn=##class(Input).InputYN("Would you like to write the document structures to an export file?")
	If tIn="" {Quit}
	If tIn="Y" {
		
		Kill tNewNames
		If '##class(Input).SchemaNewNames(.pByFacility,..Version,.tNewNames) {
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

Method DescribeWorkspace() [ Private ]
{
	Set tMessageCount=..MessageCount() // call this before the following Writes because it writes to the screen itself
	
	Write !
	Write "Workspace in ",..WorkspaceFolderName,!
	Write " document structure: ",..Version,":",..SchemaName,!
	Write " ",tMessageCount," unique messages taken from ",..SourceFolder,!
	Write !
}

Method MessageCount() As %Integer [ Private ]
{
	// if the cache is not valid ..
	If ..MessageCountCache="" {
		
		// compute the count
		Set ..MessageCountCache=..Workspace.CountMessages()
	}
	
	Quit ..MessageCountCache
}

Method InvalidateMessageCountCache() [ Private ]
{
	Set ..MessageCountCache=""
}

/// Returns either a Workflow2 object or "" if the user cancelled
ClassMethod MakeWorkflow(pGlobalInfo As GlobalInfo, pLogger As Logger) As Workflow2 [ Private ]
{
	
	// get existing workspace folder, if any
	Set tExisting=..ExistingWorkspaceFolder()
	
	// there is an existing valid workspace folder ..
	If tExisting'="" {
	
		// use the existing setup
		Set $ListBuild(tWorkspaceFolder,tVersion,tSchemaName,tSourceFolder)=tExisting
		Quit ##class(Workflow2).%New(tWorkspaceFolder,tSourceFolder,tVersion,tSchemaName,pLogger)
	}
	
	// .. no existing workspace folder ..
	Else {
	
		// prompt the user for workspace details and make a new workflow
		Quit ..MakeNewWorkflow(pGlobalInfo,1,pLogger)
	}
}

/// Returns "" if not found or invalid, $LB(WORKSPACEFOLDER,VERSION,SCHEMANAME,SOURCEFOLDER) if found and valid
ClassMethod ExistingWorkspaceFolder() As Workflow2 [ Private ]
{
	Set tWorkspaceFolder=$Get($$$WFHISTORYITEMREF("WORKSPACE2"))
	
	// if there is no folder in the history ..
	If tWorkspaceFolder="" {
		Quit ""
	}
				
	// see if the history folder exists as a valid workspace
	Set tRet1=##class(Workspace).WorkspaceExists(tWorkspaceFolder,.tSubTypeArgs)
	
	// if no valid workspace was found ..
	If $Length(tRet1) '= 1 {			
	
		// folder does not exist ..
		If tRet1="" {
			Quit ""
		}

		// exists but not valid
		Set tErrorMessage=tRet1
		Write tErrorMessage,!! // show the error message but don't return it
		Kill $$$WFHISTORYITEMREF("WORKSPACE2") // remove it from the history
		Quit "" // just tell the caller we didn't find anything
	}
	
	// if there aren't enough subtype args in the workspace file ..		
	If $ListLength(tSubTypeArgs) '= 3 {
		Write tWorkspaceFolder_" is a workspace folder created by another version of this utility",! // show the error message but don't return it
		Kill $$$WFHISTORYITEMREF("WORKSPACE2") // remove it from the history
		Quit "" // just tell the caller we didn't find anything
	}
	
	// a valid workspace was found
	Quit $ListBuild(tWorkspaceFolder)_tSubTypeArgs
}

/// Returns "" if not found or invalid, $LB(VERSION,SCHEMANAME,SOURCEFOLDER) if found and valid
ClassMethod GetExistingWorkspaceDetails(pWorkspaceFolder As %String) As Workflow2 [ Private ]
{
	// see if the workspace folder exists as a valid workspace
	Set tRet1=##class(Workspace).WorkspaceExists(pWorkspaceFolder,.tSubTypeArgs)
	
	// if no valid workspace was found ..
	If $Length(tRet1) '= 1 {			
		Quit ""
	}
	
	// if there aren't enough subtype args in the workspace file ..		
	If $ListLength(tSubTypeArgs) '= 3 {
		Quit ""
	}
	
	// a valid workspace was found
	Quit tSubTypeArgs
}

ClassMethod MakeNewWorkflow(pGlobalInfo As GlobalInfo, pForceNew As %Boolean, pLogger As Logger) As Workflow2 [ Private ]
{
	// ask the user to enter the details
	Set tNewWorkspace=..NewWorkspaceFolder(pGlobalInfo,pForceNew)
	If tNewWorkspace="" {Quit ""} // they cancelled
	
	// use what the user entered
	Set $ListBuild(tWorkspaceFolder,tRecreate,tVersion,tSchemaName,tSourceFolder)=tNewWorkspace

	// create the workflow
	Set tWorkflow=##class(Workflow2).%New(tWorkspaceFolder,tSourceFolder,tVersion,tSchemaName,pLogger)
	
	If tRecreate {
	
		// run pass0 (create workspace from messages)
		Set tQuiet=1
		Set tErr=tWorkflow.CreateWorkspace("",tQuiet)
		If tErr'="" {
			Write tErr," (pass0)",!
			Quit ""
		}
		
		// set history now that the workspace has been correctly created
		Set $$$WFHISTORYITEMREF("WORKSPACE2")=tWorkspaceFolder
	}
	
	Quit tWorkflow
}

/// Set up and return workspace folder etc, or "" if cancelled
/// <p> Returns $LB(WORKSPACEFOLDER,RECREATE,HL7VERSION,SCHEMANAME,MESSAGESSOURCE)
ClassMethod NewWorkspaceFolder(pGlobalInfo As GlobalInfo, pForceNew As %Boolean) As %String [ Private ]
{
	// input the workspace folder - unless pForceNew is set: use the history entry if there is one
	Set tRet=..WorkspaceFolder(pForceNew) If tRet="" {Quit ""}
	Set $ListBuild(tWorkspaceFolder,tWorkspaceExists)=tRet
	
	// if the workspace already exists ..
	If tWorkspaceExists {
	
		// count the messages in it
		Set tMessageCount=##class(Workspace).CountMessagesIn(tWorkspaceFolder)
		
		// if there are any messages ..
		If tMessageCount {
		
			Write !,"This workspace already exists, with ",tMessageCount," messages",!
			Set tIn=##class(Input).InputYN("Do you want to clear it and copy new messages into it")
			
			If tIn="^" {Quit ""}
			
			If tIn="N" {
				Set tRet=..GetExistingWorkspaceDetails(tWorkspaceFolder)
				If tRet="" {ZTrap}
				Quit $ListBuild(tWorkspaceFolder,0)_tRet
			}
			
			// tIn="Y" => fall through ..
		}
	}
	
	// kill previous validation stats
	Kill $$$WFPREVVSTATSREF
	
	Write "Using ",tWorkspaceFolder," as a temporary workspace",!
	
	Write !,"Enter a single source file or folder which contains message files to move into the workspace ..",!!

	// input the source path
	Set tSourcePath=##class(Input).SourcePath() If tSourcePath="" {Quit ""}
	
	// if the workspace exists ..
	If tWorkspaceExists {
	
		// clear it
		Set tRet=..ClearWorkspace(tWorkspaceFolder)
		If tRet'="" {
			Write "Fatal error clearing workspace folder: ",tRet,!
			Quit "" // premature exit
		}
	}
	
	Write !

	// input the HL7 version
	Write !,"Enter the schema to use",!
	Set tVersion=##class(Input).Version2(pGlobalInfo,0) If tVersion="" {Quit ""}
	
	// input the name of a schema in that version
	Set tSchemaName=##class(Input).SchemaName2(tVersion) If tSchemaName="" {Quit ""}

	$$$ACASSERT((tVersion'="") && (tSchemaName'="") && $Data($$$vaSchemaGbl(tVersion,"MS",tSchemaName)),"Document structure '"_tVersion_":"_tSchemaName_"' is invalid or does not exist")	
		
	// copy and update message types if necessary
	Set tChangedList=##class(PathUpdater).CopyAndUpdateMessageTypesIfNeeded(tVersion,tSchemaName)
	If tChangedList'="" {
		Write "Copied/updated message type",$Select($ListLength(tChangedList)>1:"s",1:""),": ",$ListToString(tChangedList),!
	}

	Quit $ListBuild(tWorkspaceFolder,1,tVersion,tSchemaName,tSourcePath)
}

Method SamplingCodeFragment() [ Private ]
{
	// pass3 - derive new schema
	Write "Derive new document structure",!
	Set tMinCount=1
	Set tDivide=2
	Set tInitialSkipCount=..MessageCount() \ tMinCount
	Set tConfig=##class(Config).%New()
	Set tI=tInitialSkipCount Do {
	
		Set tNumberOfMessages=..MessageCount() \ tI
		Write tI," -> ",tNumberOfMessages," :",!
		
		Do tConfig.SetOptionValue("MESSAGESKIPCOUNTPROC",tI)
		//Do tConfig.SetFlag("OLDDIFFCOLLECTION",0)

		Set tStartTime=$ZH
		Set tErr=..Workspace.Pass3(tRigSchemas,tCombine,tQuiet,..Logger,.tDerivedSchemaNames,tConfig)
		Set tEndTime=$ZH
		Set tSeconds=$FNumber(tEndTime-tStartTime,,0)
		Write "Time taken: ",tSeconds," ",..PluralizeSecond(tSeconds),!
		
		If tErr'="" {
			Write tErr," (pass3)",!
		}
		Else {			
			Set tDerivedSchemaCount=$ListLength($Get(tDerivedSchemaNames))
			Write " - ",tDerivedSchemaCount," derived document structures",!
		}
		
		Write !
		
		Set tI=tI \ tDivide
		
	} While tI>0 
	
	Quit
}

ClassMethod PluralizeSecond(N As %Integer) As %String [ CodeMode = expression, Private ]
{
$Case(N,1:"second",:"seconds")
}

}
