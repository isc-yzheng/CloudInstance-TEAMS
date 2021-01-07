/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

/// Scans a single folder, returning each file/folder (except where the file name begins with ".") in successive calls to Next 
Class EnsLib.InteropTools.HL7.MessageAnalyzer.FolderScanner Extends %RegisteredObject
{

Property ResultSet As %SQL.StatementResult [ Private, ReadOnly ];

Method %OnNew(pFolder As %String) As %Status
{
	$$$ACASSERT(pFolder'="","FolderScanner: no folder passed to constructor")
	If '##class(%File).DirectoryExists(pFolder) {$$$THROW("FileHandler constructor: argument is not a directory - "_pFolder)}

	Set tQuery=##class(%SQL.Statement).%New()
	$$$THROWONERROR(tSC,tQuery.%PrepareClassQuery("%File","FileSet"))
	
	Set i%ResultSet=tQuery.%Execute(pFolder)

	Quit $$$OK
}

/// Returns 1 if a file/folder was found, 0 at the end
Method Next(Output pPath As %String, Output pIsDir As %Boolean) As %Boolean
{
	While ..ResultSet.%Next() {		
		Set pPath=..ResultSet.%Get("Name")
		If ..IsAcceptablePath(pPath) {
			Set pIsDir=(..ResultSet.%Get("Type")="D")
			Return 1
		}
	}
	
	Kill pPath,pIsDir
	Quit 0
}

ClassMethod IsAcceptablePath(pPath As %String) As %Boolean [ Private ]
{
	Set tFilename=##class(%File).GetFilename(pPath)
	If $Extract(tFilename)="." {Quit 0} // reject a filename which begins with a "."
	Quit 1
}

/// PATCHED TEMPORARY
ClassMethod Test(pFolder As %String = "")
{
	If pFolder="" {Read "folder:",pFolder}
	Set tScanner=..%New(pFolder)
	
	While tScanner.Next(.tPath,.tIsDir) {
		Write $Select(tIsDir:"folder ",1:"file "),tPath,!
	}
}

}
