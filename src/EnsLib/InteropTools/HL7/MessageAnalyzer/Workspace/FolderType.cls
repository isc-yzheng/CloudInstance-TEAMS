/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging, EnsLib.InteropTools.HL7.MessageAnalyzer.Ensemble)

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace.FolderType Extends %RegisteredObject
{

/// FolderTypeCache(PATH)=$LB(TYPE,SUBTYPE,SUBTYPEARGS)
Property FolderTypeCache As %String [ MultiDimensional, Private ];

Parameter MAGICFILENAMES As %List = {$ListBuild("messages","container")};

Method IsMessagesFolder(pPath As %String) [ CodeMode = expression ]
{
..GetFolderType(pPath)="messages"
}

Method IsContainerFolder(pPath As %String) [ CodeMode = expression ]
{
..GetFolderType(pPath)="container"
}

Method GetFolderType(pPath As %String, Output pSubType As %String, Output pSubTypeArgs) As %String
{
	$$$ACASSERT(pPath'="","GetFolderType: empty path given")
	
	If '$Data(..FolderTypeCache(pPath)) {
		Set tType=..GetFolderTypeFromFolder(pPath,.pSubType,.pSubTypeArgs)
		Set ..FolderTypeCache(pPath)=$ListBuild(tType,$Get(pSubType),$Get(pSubTypeArgs))
		Quit tType
	}
	Else {
		Set $ListBuild(tType,pSubType,pSubTypeArgs)=..FolderTypeCache(pPath)	
		Quit tType
	}
}

/// This can be called directly if no instance with a cache is available
ClassMethod IsMessagesFolderFromFolder(pPath As %String) [ CodeMode = expression ]
{
..GetFolderTypeFromFolder(pPath)="messages"
}

/// This can be called directly if no instance with a cache is available
ClassMethod IsContainerFolderFromFolder(pPath As %String, Output pSubType As %String, Output pSubTypeArgs) [ CodeMode = expression ]
{
..GetFolderTypeFromFolder(pPath,.pSubType,.pSubTypeArgs)="container"
}

/// This can be called directly if no instance with a cache is available
ClassMethod GetFolderTypeFromFolder(pPath As %String, Output pSubType As %String, Output pSubTypeArgs) As %String
{
	$$$ACASSERT(##class(%File).DirectoryExists(pPath),"FolderType: path is not a directory")
			
	Set tPtr=0 While $ListNext(..#MAGICFILENAMES,tPtr,tFileName) {
		
		If ..FileExistsInFolder(pPath,tFileName,.tFullPath) {
			
			Set tContents=$ZStrip(##class(Common).FileContents(tFullPath),"",$Char(13))
			Set tLines=$ListFromString(tContents,$Char(10))
			Set tRawRecord=$ListGet(tLines)
			
			// new format uses '*' as delimiter - a character we don't expect to find in a file/folder path
			If tRawRecord["*" {
				Set pSubType=$Piece(tRawRecord,"*"),pSubTypeArgs=$ListFromString($Piece(tRawRecord,"*",2,*),"*")
				Return tFileName
			}
			
			// .. old format uses ',' as delimiter (and doesn't have schema name or source folder)
			Else {			
				Set tRecord=$ZStrip($ListGet(tLines),"*CW")
				Set pSubType=$Piece(tRecord,","),pSubTypeArgs=$ListFromString($Piece(tRecord,",",2,*))
				Return tFileName
			}
		}
	}
	
	Quit ""
}

/// Return whether a given file should be loaded as a message file
/// <p> Returns 1 unless the file begins with "." or is one of the special filenames associated with MessageAnalyzer workspaces
ClassMethod IsMessageFileName(pPath As %String) As %Boolean
{
	Set tFile=##class(%File).GetFilename(pPath)
	Quit ($Extract(tFile)'=".") && '$ListFind(..#MAGICFILENAMES,tFile)
}

Method WriteManifest(pDir As %String, pLine As %String)
{
	Set tPath=##class(%File).NormalizeFilename("messages",pDir)
	Set tOutputStream=##class(Common).WriteFileStream(tPath,$Char(10))
	$$$THROWONERROR(tSC,tOutputStream.WriteLine(pLine))
	$$$THROWONERROR(tSC,tOutputStream.%Save())
	
	Set ..FolderTypeCache(pDir)="messages"
}

Method WriteContainerFile(pDir As %String, pSubType As %String, pSubTypeArgs As %List = "")
{
	Set tPath=##class(%File).NormalizeFilename("container",pDir)
	Set tOutputStream=##class(Common).WriteFileStream(tPath,$Char(10))
	Set tRecord=$Select(pSubTypeArgs="":pSubType,1:pSubType_"*"_$ListToString(pSubTypeArgs,"*"))
	$$$THROWONERROR(tSC,tOutputStream.WriteLine(tRecord))
	$$$THROWONERROR(tSC,tOutputStream.%Save())
	
	Set ..FolderTypeCache(pDir)="container"
}

ClassMethod LoadFolderSchemas(pMessagesFolder As %String, pRigSchemas As RigSchemaCollection, pConfig As Config, pLogger As Logger, pQuiet As %Boolean = 1)
{
	Do pRigSchemas.ClearLocalSchemas()
	
	// scan the folder for subfolders
	Set tScanner=##class(FolderScanner).%New(pMessagesFolder)
	While tScanner.Next(.tPath,.tIsDir) {
		
		// if it's a directory ..
		If tIsDir {
			
			// get the last segment
			Set tLastSegment=##class(Common).LastFolderSegment(tPath) 
			
			// if the last segment is a generated schema name ..
			If ..IsGeneratedSchemaName(tLastSegment) {			
				Set tSchemaSource=..LoadSchemaSource(tPath)	
				
				$$$DBOUT("Loaded from "_tPath_":")
				$$$DBOUT("- "_tSchemaSource)
				$$$DBOUT("")
				
				If tSchemaSource'="" {			
					Set tRigSchema=##class(Common).MakeRigSchema(tSchemaSource,pConfig,pLogger,pQuiet,tLastSegment)
					Do pRigSchemas.Insert(tRigSchema,1)
				}
			}
		}
	}
}

/// Note: if you change this you must also change the GeneratedSchemaNameRules method
ClassMethod IsGeneratedSchemaName(pName As %String) As %Boolean [ CodeMode = expression ]
{
(pName["_") && ($Piece(pName,"_",*)?1.L)
}

ClassMethod GeneratedSchemaNameRules() As %String [ CodeMode = expression ]
{
"a generated document structure name ends with a '_' followed by one or more lower-case letters"
}

/// For each derived schema in the messages folder: add it to the export object
ClassMethod CollectDerivedSchemasForExport(pMessagesFolder As %String, pExport As Export, ByRef pNewNames)
{
	If '..IsMessagesFolderFromFolder(pMessagesFolder) {$$$THROW("CollectDerivedSchemasForExport: "_pMessagesFolder_" is not a messages folder")}
	
	// scan the folder for subfolders
	Set tScanner=##class(FolderScanner).%New(pMessagesFolder)
	While tScanner.Next(.tPath,.tIsDir) {
		
		// if it's a directory ..
		If tIsDir {
			
			// get the last segment
			Set tLastSegment=##class(Common).LastFolderSegment(tPath) 
			
			// if the last segment is a generated schema name ..
			If ..IsGeneratedSchemaName(tLastSegment) {		
				
				Set tSchemaSource=..LoadSchemaSource(tPath)	
								
				If tSchemaSource'="" {	
					Set tSchemaName=$Get(pNewNames(tLastSegment),tLastSegment)
					$$$ACASSERT('..IsGeneratedSchemaName(tSchemaName),"CollectDerivedSchemasForExport: generated name passed to export: "_tSchemaName)
					Do pExport.AddSchema(tSchemaName,tSchemaSource)
				}
			}
		}
	}
}

/// Return the source of the given derived schema, or "" if not found
ClassMethod DerivedSchemaSource(pMessagesFolder As %String, pDerivedSchemaName As %String) As %String
{
	If '..IsMessagesFolderFromFolder(pMessagesFolder) {$$$THROW("DerivedSchemaSource: "_pMessagesFolder_" is not a messages folder")}
	
	// scan the folder for subfolders
	Set tScanner=##class(FolderScanner).%New(pMessagesFolder)
	While tScanner.Next(.tPath,.tIsDir) {
		
		// if it's a directory ..
		If tIsDir {
			
			// get the last segment
			Set tLastSegment=##class(Common).LastFolderSegment(tPath) 
			
			// if the last segment is a generated schema name and matches the given name ..
			If ..IsGeneratedSchemaName(tLastSegment),tLastSegment=pDerivedSchemaName {		
				
				Set tSchemaSource=..LoadSchemaSource(tPath)	
								
				If tSchemaSource'="" {	
					Return tSchemaSource
				}
			}
		}
	}
	
	Quit ""
}

ClassMethod LoadSchemaSource(pSchemaFolder As %String) [ Private ]
{
	Set tSchemaFilePath=##class(%File).NormalizeFilename("schema",pSchemaFolder)
	If '##class(%File).Exists(tSchemaFilePath) {
		Quit ""
	}
	
	Set tStream=##class(Common).ReadFileStream(tSchemaFilePath)
	Quit tStream.ReadLine()
}

ClassMethod FileExistsInFolder(pFolder As %String, pFileName As %String, Output pFullPath As %String) As %Boolean [ Private ]
{
	Set pFullPath=##class(%File).NormalizeFilename(pFileName,pFolder)
	Quit ##class(%File).Exists(pFullPath)
}

}
