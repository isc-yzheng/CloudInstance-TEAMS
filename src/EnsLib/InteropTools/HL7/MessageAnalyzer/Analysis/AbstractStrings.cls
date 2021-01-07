/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging)

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.Output)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Analysis.AbstractStrings Extends %RegisteredObject
{

Property Config As Config [ Private ];

Property Logger As Logger [ Private ];

/// Lines(..)=$LB(El,El,...)
Property Lines As list Of %List [ Private ];

/// CountedLines(..)=$LB(El,El,..)
Property CountedLines As list Of %List [ Private ];

Property LogDetail As %Boolean [ Private ];

/// Given a list of lines in the form of character strings or CSV records (as per pCSV), a session logger and a logging flag for this module
Method %OnNew(pLines As %List, pCSV As %Boolean, pConfig As Config, pLogger As Logger) As %Status
{
	Set ..Config=pConfig
	Set ..Logger=pLogger
	
	// make ..Lines (see Property definition)
	Do ..MakeLines(pLines,pCSV)
	
	// make ..CountedLines (see Property definition)
	Do ..MakeCountedLines()
	
	Set ..LogDetail=..Config.IsFlagSet("LOGABSTRACTSTRINGS")
	
	Quit $$$OK
}

/// Set pColl(1..*) to the collections derived from the inputs
Method GetCollections(Output pCollections)
{
	$$$SHOULDBEUNDEF(pCollections)
	
	// make table
	Do ..MakeTable(.tTable)

	// partition into disjunct collections of sets
	Do ..MakeCollections(.tTable,.tColl)
	
	$$$ACASSERT($Data(tCountedLines)=0,"tCountedLines already exists")
	
	For tI=1:1:..CountedLines.Count() {
		Set tCountedLines(tI)=..CountedLines.GetAt(tI)
	}
	Set tCountedLines=..CountedLines.Count()
	
	// for each collection, ignoring outlier collections
	Set tCollKey="" While 1 {
		Set tCollKey=$Order(tColl(tCollKey),+1,tCLIList) If tCollKey="" {Quit}
		Set pCollections($I(pCollections))=##class(AbstractStringsCollection).%New(.tCountedLines,tCLIList,..Config,..Logger)
	}
	
	If '$Get(pCollections) {$$$FATAL("GetCollections: no collections found")}
}

// pTable(ELEMENT,COUNTEDLINEINDEX)=""

Method MakeTable(Output pTable) [ Private ]
{
	#Dim tI,tLine,tJ
	
	$$$SHOULDBEUNDEF(pTable)
	
	// for each counted line ..
	For tI=1:1:..CountedLines.Count() {
	
		Set tLine=..CountedLines.GetAt(tI)
		
		// for each element in the line ..
		Set tPtrJ=0 While $ListNext(tLine,tPtrJ,tElemJ) {
			Set pTable(tElemJ,tI)="" // associate the element with the counted-line-index
		}
	}
	
	If ..LogDetail {
		#Dim tElement,tCountedLineIndex
		$$$LOGOUTPUTWRITEIF1(..Logger,"Table",..LogDetail)
		Set tElement="" While 1 {
			Set tElement=$Order(pTable(tElement)) If tElement="" {Quit}
			Set tLine=" "_tElement_":"
			Set tCountedLineIndex="" While 1 {
				Set tCountedLineIndex=$Order(pTable(tElement,tCountedLineIndex)) If tCountedLineIndex="" {Quit}
				Set tLine=tLine_" "_tCountedLineIndex
			}
			$$$LOGOUTPUTWRITEIF1(..Logger,tLine,..LogDetail)
		}
		$$$LOGOUTPUTWRITEIF1(..Logger,"",..LogDetail)
	}
}

/// pColl(1..*)=$LB(COUNTEDLINEINDEX,COUNTEDLINEINDEX,..)
Method MakeCollections(ByRef pTable, Output pColl) [ Private ]
{
	#Dim tCountedLineIndex,tCLIGroup,tGroup,tElement
	
	$$$SHOULDBEUNDEF(pColl)
	
	// tCLIGroup(COUNTEDLINEINDEX)=GROUPINDEX
	// tGroup(GROUPINDEX)=$LB(COUNTEDLINEINDEX,COUNTEDLINEINDEX,...)
	
	// create a one-index group for each counted-line-index
	For tCountedLineIndex=1:1:..CountedLines.Count() {
		Set tCLIGroup(tCountedLineIndex)=tCountedLineIndex
		Set tGroup(tCountedLineIndex)=$ListBuild(tCountedLineIndex)
	}
	
	// for each element ..
	Set tElement="" While 1 {
	
		Set tElement=$Order(pTable(tElement)) If tElement="" {Quit}
		
		Kill tElementGroups
		
		// for each counted-line that the element is in ..
		Set tElementCLI="" While 1 {
			
			Set tElementCLI=$Order(pTable(tElement,tElementCLI)) If tElementCLI="" {Quit}

			// tElementGroups(GROUPINDEX)=""
			Set tElementGroups(tCLIGroup(tElementCLI))=""
		}
		
		// - merge all groups which this element is a part of -
		
		// all groups will be merged into tFirstGI
		Set tFirstGI=$Order(tElementGroups(""))
		
		// for every other group which this element is a part of .. 
		Set tGI=tFirstGI While 1 {
		
			Set tGI=$Order(tElementGroups(tGI)) If tGI="" {Quit}
			
			// the counted-line-indexes associated with this group
			Set tCLIList=tGroup(tGI)
			
			// append the counted-line-indexes to the FIRST group
			Set tGroup(tFirstGI)=tGroup(tFirstGI)_tCLIList
			
			// point each counted-line-index to the FIRST group
			Set tPtrI=0 While $ListNext(tCLIList,tPtrI,tElemI) {
				Set tCLIGroup(tElemI)=tFirstGI
			}
			
			// remove this group
			Kill tGroup(tGI)
		}
	}
	
	// return results
	Merge pColl=tGroup
	
	If ..LogDetail {
		$$$LOGOUTPUTWRITEIF1(..Logger,"Collections",..LogDetail)
		Set tKey="" While 1 {
			Set tKey=$Order(pColl(tKey),+1,tData) If tKey="" {Quit}
			$$$LOGOUTPUTWRITEIF1(..Logger," "_tKey_": "_$ListToString(tData),..LogDetail)
		}
	}
}

/// Given a list of raw lines and a flag to determine whether they're seen as being made up of individual characters or of CSV fields: set up ..Lines
Method MakeLines(pLines As %List, pCSV As %Boolean) [ Private ]
{
	#Dim tNonEmptyLines,tI,tLine
	
	// set tNonEmptyLines to a list of the lines which are non-empty (where non-empty means not just whitespace)
	Set tNonEmptyLines=""
	Set tPtrI=0 While $ListNext(pLines,tPtrI,tElemI) {
		Set tLine=$$$TRIM(tElemI)
		If tLine'="" {
			Set tNonEmptyLines=tNonEmptyLines_$ListBuild(tLine)
		}
	}
	
	// if the lines are to be considered as CSV fields ..
	If pCSV {
		Set tPtrI=0 While $ListNext(tNonEmptyLines,tPtrI,tElemI) {
			Do ..Lines.Insert($ListFromString(tElemI))
		}
	}
	
	// .. the lines are to be considered as character sequences ..
	Else {
		Set tPtrI=0 While $ListNext(tNonEmptyLines,tPtrI,tElemI) {
			Do ..Lines.Insert(..ToCharList(tElemI))
		}
	}
	
	If ..Lines.Count()=0 {
		Throw ##class(AnalysisException).%New("<ABSTRACTSTRINGS>",,,"MakeLines: no lines in input")
	}
}

/// ..Lines -> ..CountedLines
Method MakeCountedLines() [ Private ]
{
	#Dim tI,tLine,tArr
	
	$$$LOGOUTPUTWRITEIF1(..Logger,"Counted Lines",..LogDetail)
	
	// tArr(LINE)=""
	Kill tArr
	For tI=1:1:..Lines.Count() {
		Set tLine=..Lines.GetAt(tI)
		Set tArr(##class(Common).RawHash(tLine))=tLine
	}
	
	// ..CountedLines(..)=$LB(El,El,...)
	Set tKey="" While 1 {
		Set tKey=$Order(tArr(tKey),+1,tLine) If tKey="" {Quit}
		Do ..CountedLines.Insert(tLine)
		$$$LOGOUTPUTWRITEIF1(..Logger," "_..CountedLines.Count()_": "_$ListToString(tLine),..LogDetail)
	}
	
	$$$LOGOUTPUTWRITEIF1(..Logger,"",..LogDetail)
}

/// Given a string: return a list of all its characters
ClassMethod ToCharList(pStr As %String) As %List [ Private ]
{
	Set tList=""
	For tI=1:1:$Length(pStr) {
		Set tList=tList_$ListBuild($Extract(pStr,tI))
	}
	
	Quit tList
}

}
