/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace.Menu.CategorySelectionMenu Extends MenuBase
{

Property AvailableCategories As %List [ Private ];

Property CategorizedFixes As CategorizedFixes [ Private ];

Method %OnNew(pAvailableCategories As %List, pCategorizedFixes As CategorizedFixes) As %Status
{
	Set ..AvailableCategories=pAvailableCategories
	Set ..CategorizedFixes=pCategorizedFixes
	Quit $$$OK
}

Method Title() As %List [ CodeMode = expression ]
{
$ListBuild("Select a category of fixes to process")
}

Method MenuOptions() As %List
{
	Set tResult=""
	For tI=1:1:$ListLength(..AvailableCategories) { // this list won't be large enough for $ListNext to be necessary
		Set tCategory=$List(..AvailableCategories,tI)
		Set tOptionText=..CategorizedFixes.Count("pending",tCategory)_" "_..ExpandCategory(tCategory,1)
		Set tResult=tResult_$ListBuild($ListBuild(tCategory,tOptionText))
	}
	
	Quit tResult
}

ClassMethod ExpandCategory(pCategory As %String, pMaybePlural As %Boolean) [ CodeMode = expression ]
{
$Case(pCategory,"CT":"code table","DT":"data structure","SS":"segment structure",:pCategory)_$Select(pMaybePlural:"(s)",1:"")
}

}
