/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace.Menu, EnsLib.InteropTools.HL7.MessageAnalyzer.Validation, EnsLib.InteropTools.HL7.MessageAnalyzer.Validation.Segment)

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace.Workflow2ValidationByCategory Extends %RegisteredObject
{

Property SchemaVersion As %String;

Property HL7Configuration As HL7Configuration [ Private ];

Property CategorizedFixes As CategorizedFixes [ Private ];

Property MessageCount As %Integer [ Private ];

Property MenuRunner As MenuRunner [ Private ];

Method %OnNew(pSchemaVersion As %String, pHL7Configuration As HL7Configuration, pCategorizedFixes As CategorizedFixes, pMessageCount As %Integer, pMenuRunner As MenuRunner) As %Status
{
	Set ..SchemaVersion=pSchemaVersion
	Set ..HL7Configuration=pHL7Configuration
	Set ..CategorizedFixes=pCategorizedFixes
	Set ..MessageCount=pMessageCount
	Set ..MenuRunner=pMenuRunner
	
	Quit $$$OK
}

Method ProcessByCategory()
{
	Write !,..CategorizedFixes.Count()," auto-fixable validation error(s) found",!
	
	Write !,"You will now be prompted to select one or more validation errors to be auto-fixed.",!
	
	Write !,"In the following menus entering '^' will go back up a level, retaining any selections you've made.  When you exit from",!
	Write "the 'Select a category of fixes to process' menu you will be asked whether you want to auto-fix any errors you've selected.",! 
	
	Set tShouldPrompt=1
	
	While 1 {
	
		Set tCategoryKeys=..CategorizedFixes.Keys("pending")
		If tCategoryKeys="" {Quit} // no more left with pending status

		Set tMenu=##class(CategorySelectionMenu).%New(tCategoryKeys,..CategorizedFixes)	
		If '..MenuRunner.RunMenu(tMenu,.tSelectedOption) {Quit} // user exited
		
		Do ..ProcessOneCategory(1,tSelectedOption)
	}
}

Method ProcessOneCategory(ByRef pShouldPrompt As %Boolean, pCategory As %String) [ Private ]
{
	While 1 {
	
		Set tSubCategoryKeys=..CategorizedFixes.Keys("pending",pCategory)
		If tSubCategoryKeys="" {Quit} // no more left with pending status
		
		Set tMenu=##class(SubCategorySelectionMenu).%New(..SchemaVersion,pCategory,tSubCategoryKeys,..CategorizedFixes)			
		If '..MenuRunner.RunMenu(tMenu,.tSubCategory) {Quit} // user exited
	
		Do ..ProcessOneSubCategory(.pShouldPrompt,pCategory,tSubCategory)
	}
}

Method ProcessOneSubCategory(ByRef pShouldPrompt As %Boolean, pCategory As %String, pSubCategory As %String) [ Private ]
{
	While 1 {
	
		Set tOperationKeys=..CategorizedFixes.Keys("pending",pCategory,pSubCategory)
		If tOperationKeys="" {Quit} // no more left with pending status
		
		Set tMenu=##class(OperationSelectionMenu).%New(pCategory,pSubCategory,tOperationKeys,..HL7Configuration,..CategorizedFixes)			
		If '..MenuRunner.RunMenu(tMenu,.tOperation) {Quit} // user exited
		
		If ..ProcessOneOperation(.pShouldPrompt,pCategory,pSubCategory,tOperation) {
			Quit  // quit the While loop
		}
	}
}

Method ProcessOneOperation(ByRef pShouldPrompt As %Boolean, pCategory As %String, pSubCategory As %String, pOperationKey As %String) As %Boolean [ Private ]
{
	#Dim tInstance As SegmentValidationBase
	
	Set tInstance=..CategorizedFixes.Instance("pending",pCategory,pSubCategory,pOperationKey)
	
	// show status message and the number of messages it applies to
	Write !,tInstance.DecoratedCleanedStatusMessage()
	Set tMessageCount=tInstance.HL7MessageCount()
	If tMessageCount>1 {Write " (representative)"}
	Write !
	Write " - in ",tMessageCount," message(s) - ",..PercentageOfTotalMessages(tMessageCount),"% of total",!!
	
	// show the pre-prompt, if any
	Set tPrePrompt=tInstance.BeforePrompt(..HL7Configuration)
	If tPrePrompt'="" {
		Write !
		Set tPtr=0 While $ListNext(tPrePrompt,tPtr,tPrePromptLine) {
			Write tPrePromptLine,!
		}
		Write !
	}
	
	Set tPrompt=tInstance.FixPrompt(..HL7Configuration)
	
	// if we're in auto-fix-mode ..
	If 'pShouldPrompt {
		Set uin="Y"
	}
	Else {
		Set uin=..AskUser(tPrompt,.pShouldPrompt)
		Write !
	}
	
	// if we should fix this one ..
	If uin="Y" {
		Do ..CategorizedFixes.QueueForFix(pCategory,pSubCategory,pOperationKey)		
		Write "Queued for fix: ",tPrompt,! // for now
	}
	ElseIf uin="N" {
		Do ..MenuRunner.Quitting() // if this is NOT done and the parent menu has only a single item: this method will be invoked again with the same operation ...
	}
	ElseIf "Q^"[uin {
		Quit 1 // quit the caller
	}
	
	Quit 0
}

ClassMethod AskUser(pPrompt As %String, ByRef pShouldPrompt) As %String [ Private ]
{
	
	Do {
		Write pPrompt
		Read "? (Y/N) ",tIn,!
		Set tUIn=$$$TOUP(tIn)
	} While ($Length(tUIn)'=1) || ("YNAQ^"'[tUIn)
	
	// if they selected auto-fix ..
	If tUIn="A" {
		Set tUIn="Y"
		Set pShouldPrompt=0
	}
	
	Quit tUIn
}

Method PercentageOfTotalMessages(pOperationMessageCount As %Integer) [ Private ]
{
	Set tPercentage=$Piece((pOperationMessageCount/..MessageCount)*100,".")
	If 'tPercentage {
		Quit "<1"  // rather than "0%" say "<1%" 
	}
	
	Quit tPercentage
}

}
