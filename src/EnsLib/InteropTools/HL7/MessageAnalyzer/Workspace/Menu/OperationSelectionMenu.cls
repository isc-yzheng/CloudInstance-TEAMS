/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace, EnsLib.InteropTools.HL7.MessageAnalyzer.Validation)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace.Menu.OperationSelectionMenu Extends MenuBase
{

Property Category As %String [ Private ];

Property SubCategory As %String [ Private ];

Property AvailableOperations As %List [ Private ];

Property HL7Configuration As HL7Configuration [ Private ];

Property CategorizedFixes As CategorizedFixes [ Private ];

Method %OnNew(pCategory As %String, pSubCategory As %String, pAvailableOperations As %List, pHL7Configuration As HL7Configuration, pCategorizedFixes As CategorizedFixes) As %Status
{
	Set ..Category=pCategory
	Set ..SubCategory=pSubCategory
	Set ..AvailableOperations=pAvailableOperations
	Set ..HL7Configuration=pHL7Configuration
	Set ..CategorizedFixes=pCategorizedFixes
	Quit $$$OK
}

Method Title() As %List [ CodeMode = expression ]
{
$ListBuild("Select a fix to process")
}

Method MenuOptions() As %List
{
	Set tResult=""
	For tI=1:1:$ListLength(..AvailableOperations) { // this list won't be large enough for $ListNext to be necessary
		Set tOperationKey=$List(..AvailableOperations,tI)
		Set tInstance=..CategorizedFixes.Instance("pending",..Category,..SubCategory,tOperationKey)
		Set tOptionText=tInstance.FixPrompt(..HL7Configuration)
		Set tResult=tResult_$ListBuild($ListBuild(tOperationKey,tOptionText))
	}
	
	Quit tResult
}

}
