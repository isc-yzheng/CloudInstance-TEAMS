/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell)

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace.Workspace Extends %RegisteredObject
{

Property WorkspaceFolder As %String [ Private ];

Property WorkspaceVersion As %String [ Private ];

Property DerivedSchemaNames As %String [ MultiDimensional, Private ];

Method %OnNew(pWorkspaceFolder As %String) As %Status
{
	Set tRet=..WorkspaceExists(pWorkspaceFolder)
	If tRet="" {
		$$$THROW("Workspace '"_pWorkspaceFolder_"' does not exist")
	}
	If $Length(tRet)>1 {
		$$$THROW(tRet)
	}
	
	Set ..WorkspaceFolder=pWorkspaceFolder
	
	Do ##class(FolderType).GetFolderTypeFromFolder(..WorkspaceFolder,,.tRecord)
	Set ..WorkspaceVersion=$List(tRecord)
	
	Do ..LoadDerivedSchemaNames()
	
	Quit $$$OK
}

Method GetWorkspaceVersion() As %String [ CodeMode = expression ]
{
..WorkspaceVersion
}

Method GetDerivedSchemaNames(Output pDerivedSchemaNames)
{
	$$$SHOULDBEUNDEF(pDerivedSchemaNames)
	
	Merge pDerivedSchemaNames=..DerivedSchemaNames
}

/// Returns:
/// <p>
/// <ul>
///  <li> "" => does not exist
///  <li> 1 => exists as a workspace folder
///  <li> "..." => error message (length > 1)
ClassMethod WorkspaceExists(pWorkspaceFolder As %String, Output pSubTypeArgs) As %Boolean
{
	If ##class(%File).DirectoryExists(pWorkspaceFolder) {
			
		If ##class(EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace.FolderType).IsContainerFolderFromFolder(pWorkspaceFolder,.tSubType,.pSubTypeArgs), tSubType="root" {			
			Quit 1
		}
			
		Quit "Folder '"_pWorkspaceFolder_"' exists but it is not a workspace folder"
	}
		
	If ##class(%File).Exists(pWorkspaceFolder) {
		Quit pWorkspaceFolder_" is an ordinary file, a folder is needed here"
	}
	
	Quit ""
}

/// Returns "" if OK, otherwise an error message
/// <p> Note: a session must be active before this is called
ClassMethod CreateWorkspace(pWorkspaceFolderName As %String, pSourcePath As %String, pVersion As %String, pOptionalSchemaName As %String, pKeySpec As %String, pQuiet As %Boolean, pLogger As Logger, Output pRejectedMessages) As %String
{
	$$$SHOULDBEUNDEF(pRejectedMessages)
	
	Set tConfig=##class(Config).%New()
	Kill tDistributeFlags
	Set tDistributeFlags("K")=pKeySpec
	Set tDistributeFlags("Q")=pQuiet
	Kill pRejectedMessages // technically redundant but it follows the pattern for Output arguments
	Quit ##class(Distribute).%New(tConfig,pLogger).ShellDistribute(pSourcePath,pWorkspaceFolderName,pVersion,pOptionalSchemaName,.tDistributeFlags,pQuiet,.pRejectedMessages)
}

/// pass1 - match using message type
Method Pass1(pRigSchemas As RigSchemaCollection, pCombine As %Boolean, pQuiet As %Boolean, pLogger As Logger) As %String
{
	
	Set tConfig=##class(Config).%New()
	Do tConfig.SetFlag("MESSAGETYPEONLY",1)
	Quit ##class(Identify).%New(tConfig,pLogger,..WorkspaceVersion,pRigSchemas).ShellIdentify("@"_..WorkspaceFolder,pCombine,pQuiet,$This)
}

/// pass2 - match freely
Method Pass2(pRigSchemas As RigSchemaCollection, pCombine As %Boolean, pQuiet As %Boolean, pLogger As Logger) As %String
{
	Set tConfig=##class(Config).%New()
	Do tConfig.SetOptionValue("MESSAGETYPEMAPPINGS","*=")
	Quit ##class(Identify).%New(tConfig,pLogger,..WorkspaceVersion,pRigSchemas).ShellIdentify("@"_..WorkspaceFolder,pCombine,pQuiet,$This)
}

/// pass3 - derive new schemas
Method Pass3(pRigSchemas As RigSchemaCollection, pCombine As %Boolean, pQuiet As %Boolean, pLogger As Logger, Output pDerivedSchemaNames As %List, pConfig As Config = {##class(Config).%New()}) As %String
{
	Do pConfig.SetFlag("ENABLESCANEXTENSION",1)
	Do pConfig.SetFlag("ENABLEAPPENDZ",1)
	Do pConfig.SetFlag("LIMITDIFFCHANGES",1)
	Do pConfig.SetOptionValue("MESSAGETYPEMAPPINGS","*=")
	
	Quit ##class(Identify).%New(pConfig,pLogger,..WorkspaceVersion,pRigSchemas).ShellIdentify("@"_..WorkspaceFolder,pCombine,pQuiet,$This,.pDerivedSchemaNames)
}

Method MakeSchemaDirectory(pMessagesFolder As %String, pBaseSchemaName As %String, pSchemaSource As %String) As %String
{
	Set tNewSchemaName=..GetNewSchemaName(pMessagesFolder,pBaseSchemaName)
	
	Set tSchemaFolderPath=##class(%File).NormalizeDirectory(tNewSchemaName,pMessagesFolder)
	
	If ##class(%File).DirectoryExists(tSchemaFolderPath) {
		$$$THROW("MakeSchemaDirectory: folder already exists - "_tSchemaFolderPath)
	}
	
	If '##class(%File).CreateDirectory(tSchemaFolderPath) {
		$$$THROW("MakeSchemaDirectory: document structure subdirectory '"_tSchemaFolderPath_"' does not exist and cannot be created")
	}
	
	Do ..WriteSchemaFile(tSchemaFolderPath,pSchemaSource)
	
	Quit tNewSchemaName
}

Method CountMessages() As %Integer
{
	Quit ..CountMessagesIn(..WorkspaceFolder)
}

ClassMethod CountMessagesIn(pWorkspaceFolder As %String) As %Integer
{
	Set tMessageCount=0

	Write "Counting messages .. "
	
	// scan the workspace folder for subfolders
	Set tWorkspaceScanner=##class(FolderScanner).%New(pWorkspaceFolder)
	While tWorkspaceScanner.Next(.tPath,.tIsDir) {
		
		// if it's a directory which is a messages folder ..
		If tIsDir, ##class(FolderType).IsMessagesFolderFromFolder(tPath) {
			
			// scan the messages folder recursively for message files
			Set tMessagesScanner=##class(NestedFolderScanner).%New(tPath,2) // maxdepth=2: currently a messages folder can contain schema subfolders which themselves contain messages
			While tMessagesScanner.Next(.tMPath) {
			
				// if it's valid as a message file name ..
				If ##class(FolderType).IsMessageFileName(tMPath) {
					
					// count it
					If $I(tMessageCount)
				}
			}
		}
	}		
	
	Write "done",!
	
	Quit tMessageCount
}

/// Scan ..DerivedSchemaNames, noting any which have pBaseSchemaName as a prefix, returning the next available name with that suffix
/// <p> The naming scheme is to append "_a" the first time, "_b" the second time, and so on.  Following "_z" is "_aa", and so on.
Method GetNewSchemaName(pDir As %String, pBaseSchemaName As %String) As %String [ Private ]
{
	Set tLenBaseSchemaName=$Length(pBaseSchemaName)
	
	// find the highest key which begins with the base schema name
	Set tPrevKey=$Order(..DerivedSchemaNames(pBaseSchemaName_"~"),-1)
	
	// if the key does NOT begin with the base schema name ..
	If $Extract(tPrevKey,1,tLenBaseSchemaName)'=pBaseSchemaName {
		
		// return just "_a" appended
		Set tNewName=pBaseSchemaName_"_a"
	}
	
	// .. an existing key beginning with base schema name ..
	Else {

		// the suffix which follows the last existing one
		Set tLastSuffix=$Extract(tPrevKey,tLenBaseSchemaName+1,*)
		Set tNextSuffix=..NextSuffix(tLastSuffix)
		Set tNewName=pBaseSchemaName_tNextSuffix
	}
	
	Set ..DerivedSchemaNames(tNewName)=pDir
	Quit tNewName
}

ClassMethod NextSuffix(pSuffix As %String) As %String [ Private ]
{
	$$$ACASSERT(pSuffix?1"_"1.L,"NextSuffix: invalid suffix passed - "_pSuffix)
	
	Set tLast=$Extract(pSuffix,*)
	Set tNext=$Select(tLast="z":"aa",1:$Char($Ascii(tLast)+1))
	
	Quit $Extract(pSuffix,1,*-1)_tNext
}

Method LoadDerivedSchemaNames() [ Private ]
{
	// scan the workspace folder for subfolders
	Set tWorkspaceScanner=##class(FolderScanner).%New(..WorkspaceFolder)
	While tWorkspaceScanner.Next(.tPath,.tIsDir) {
		
		// if it's a directory which is a messages folder ..
		If tIsDir, ##class(FolderType).IsMessagesFolderFromFolder(tPath) {
			
			// scan the messages folder for subfolders
			Set tMessagesScanner=##class(FolderScanner).%New(tPath)
			While tMessagesScanner.Next(.tMPath,.tMIsDir) {
			
				// if it's a directory ..
				If tMIsDir {
				
					// get the last segment
					Set tLastSegment=##class(Common).LastFolderSegment(tMPath) 
					
					// if the last segment is a generated schema name ..
					If ##class(FolderType).IsGeneratedSchemaName(tLastSegment) {		
						
						If $Data(..DerivedSchemaNames(tLastSegment)) {
							$$$THROW("LoadDerivedSchemaNames: duplicate derived document structure name - "_tLastSegment)
						}
						
						Set ..DerivedSchemaNames(tLastSegment)=tPath
					}
				}
			}
		}
	}
}

ClassMethod WriteSchemaFile(pDir As %String, pLine As %String) [ Private ]
{
	Set tPath=##class(%File).NormalizeFilename("schema",pDir)
	Set tOutputStream=##class(Common).WriteFileStream(tPath,$Char(10))
	$$$THROWONERROR(tSC,tOutputStream.WriteLine(pLine))
	$$$THROWONERROR(tSC,tOutputStream.%Save())
}

}
