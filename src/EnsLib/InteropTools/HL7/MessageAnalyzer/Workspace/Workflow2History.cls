/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace.Menu, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging, EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Validation)

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Workflow

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace.Workflow2History Extends %RegisteredObject
{

Property MenuRunner As MenuRunner [ Private ];

Method %OnNew(pMenuRunner As MenuRunner) As %Status
{
	Set ..MenuRunner=pMenuRunner
	Quit $$$OK
}

Method RunHistory()
{
	// run the history top menu
	Set tMenu=$$$MENUWF2HISTORYTOP("LA","LT","LR")
	
	While ..MenuRunner.RunMenu(tMenu,.tSelectedOption) {
	
		Do $Case(tSelectedOption,
			"LA":..ListAll(),
			"LT":..ListToday(),
			"LR":..ListRange()
			)
	}
}

Method ListAll() [ Private ]
{
	Do ..List("","")
}

Method ListToday() [ Private ]
{
	Set tToday=$ZDate($H,3)
	Do ..List(tToday,tToday)
}

Method ListRange() [ Private ]
{
	Set tStartDate=##class(Input).Date("start")
	If tStartDate="" {Quit}

	Set tEndDate=##class(Input).Date("end")
	If tEndDate="" {Quit}
	
	Do ..List($ZDate(tStartDate,3),$ZDate(tEndDate,3))
}

Method List(pStartDate As %String, pEndDate As %String) [ Private ]
{
	Set tOutput=..InputReportDest()
	If tOutput="^" {Quit}
	
	If tOutput="" {
		Set tLogger=##class(Logger).%New()
	}
	Else {
		Set tOutputStream=##class(Common).WriteFileStream(tOutput,$Char(10))
		Set tLogger=##class(Logger).%New(tOutputStream,1)
	}
	
	Do ##class(ConfigChangeLog).DescribeRangeOfDays(pStartDate,pEndDate,tLogger)
}

/// Returns one of: a file path, "" for output to the screen, or "^" to cancel
ClassMethod InputReportDest() As %String [ Private ]
{
	Write "Select report destination: just hit ENTER for screen output or enter a file path",!
	
	Do {
		Set tPath=##class(Input).Input("File path")
		If (tPath="^") || (tPath="") {Quit}		
	} While '..ValidatePath(tPath)
	
	Quit tPath
}

ClassMethod ValidatePath(pPath As %String) As %Boolean [ Private ]
{
	If ##class(%File).DirectoryExists(pPath) {
		Write "Selected path is a directory",!
		Quit 0
	}
	
	If ##class(%File).Exists(pPath) {
		Write "Selected file already exists",!
		Set tYN=##class(Input).InputYN("Do you want to overwrite it")
		Quit (tYN="Y")
	}
	
	Quit 1
}

}
