/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Ensemble)

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace.ExportSchemas [ Abstract ]
{

/// Export derived schemas to a .XML file
ClassMethod ExportDerivedSchemas(pWorkspaceFolderName As %String, pTargetExportFile As %String, ByRef pNewNames)
{
	If '##class(FolderType).IsContainerFolderFromFolder(pWorkspaceFolderName,.tSubType,.tSubTypeArgs) || (tSubType'="root") {$$$FATAL("ExportDerivedSchemas: "_pWorkspaceFolderName_" is not a workspace folder")}

	Set tVersion=$Piece(tSubTypeArgs,",")
	
	Set tExport=##class(Export).%New(tVersion)
	
	// scan the folder for subfolders
	Set tScanner=##class(FolderScanner).%New(pWorkspaceFolderName)
	While tScanner.Next(.tPath,.tIsDir) {
	
		// if it's a directory ..
		If tIsDir {
		
			// if it's a messages folder ..
			If ##class(FolderType).IsMessagesFolderFromFolder(tPath) {	
				Do ##class(FolderType).CollectDerivedSchemasForExport(tPath,tExport,.pNewNames)
			}
		}
	}
	
	Do ..SaveExportFile(tVersion,tExport,pTargetExportFile)
}

/// Save the Export object to a file
ClassMethod SaveExportFile(pFileName As %String, pExport As Export, pTargetExportFile As %String) [ Private ]
{
	// save the existing definitions to a temporary file
	Set tDocumentName=pExport.GetVersion()_".hl7"
	Set tTempPath=##class(%File).TempFilename()
	$$$THROWONERROR(tSC,$System.OBJ.Export(tDocumentName,tTempPath,"/displaylog=0"))
	
	// open a stream on the temporary file
	Set tTempStream=##class(Common).ReadFileStream(tTempPath)
	
	// open a stream to write to the .HL7 file
	Set tStream=##class(Common).WriteFileStream(pTargetExportFile,$Char(10))
	
	// write the .HL7 file
	Do pExport.WriteStreamWithExistingDefinitions(tStream,tTempStream)
	
	// save the file
	$$$THROWONERROR(tSC,tStream.%Save())
}

}
