/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Scans a folder and its subfolders (to a given depth), returning each file (except where the file name begins with ".") in successive calls to Next
Class EnsLib.InteropTools.HL7.MessageAnalyzer.NestedFolderScanner Extends %RegisteredObject
{

Property Stack As list Of FolderScanner [ Private ];

/// MaxDepth=1 means that only the given folder is scanned
Property MaxDepth As %Integer [ Private ];

Method %OnNew(pFolder As %String, pMaxDepth As %Integer) As %Status
{
	Do ..Push(pFolder)
	Set ..MaxDepth=pMaxDepth
	Quit $$$OK
}

/// Returns 1 if a file was found, 0 at the end
Method Next(Output pPath As %String) As %Boolean
{
	// until we either find a file or run out of files ..
	While 1 {

		// if there is a file/folder in the current folder scanner ..
		If ..Peek().Next(.tPath,.tIsDir) {
		
			// if it's a folder ..
			If tIsDir {
			
				// if we can push another folder ..
				If ..CanPush() {
				
					// push this one
					Do ..Push(tPath)
				}
				
				// .. fall through to another iteration ..		
			}
			
			// .. it's a file ..
			Else {
				Set pPath=tPath
				Return 1 // success!
			}
		}
		
		// .. no more files/folders in the current folder scanner ..
		Else {
			
			// throw away the finished folder scanner
			Do ..Pop()
			
			// if we've run out of folder scanners ..
			If ..Empty() {
				Kill pPath
				Return 0 // failure!
			}
				
			// .. fall through to another iteration ..		
		}
	}
}

Method Push(pFolder As %String) [ Private ]
{
	Set tFolderScanner=##class(FolderScanner).%New(pFolder)
	$$$THROWONERROR(tSC,..Stack.Insert(tFolderScanner))
}

Method Pop() [ Private ]
{
	Do ..Stack.RemoveAt(..Stack.Count())
}

Method Peek() As FolderScanner [ CodeMode = expression, Private ]
{
..Stack.GetAt(..Stack.Count())
}

Method Empty() As %Boolean [ CodeMode = expression, Private ]
{
..Stack.Count()=0
}

Method CanPush() As %Boolean [ CodeMode = expression, Private ]
{
..Stack.Count() < ..MaxDepth
}

}
