/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace, EnsLib.InteropTools.HL7.MessageAnalyzer.Validation)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace.Menu.SubCategorySelectionMenu Extends MenuBase
{

Property SchemaVersion As %String;

Property Category As %String [ Private ];

Property AvailableSubCategories As %List [ Private ];

Property CategorizedFixes As CategorizedFixes [ Private ];

Method %OnNew(pSchemaVersion As %String, pCategory As %String, pAvailableSubCategories As %List, pCategorizedFixes As CategorizedFixes) As %Status
{
	Set ..SchemaVersion=pSchemaVersion	
	Set ..Category=pCategory
	Set ..AvailableSubCategories=pAvailableSubCategories
	Set ..CategorizedFixes=pCategorizedFixes
	Quit $$$OK
}

Method Title() As %List [ CodeMode = expression ]
{
$ListBuild("Select a "_##class(CategorySelectionMenu).ExpandCategory(..Category,0)_" to process")
}

Method MenuOptions() As %List
{
	Kill tUsedIn // tUsedIn(CODE,VERSION)=""
	For tI=1:1:$ListLength(..AvailableSubCategories) { // this list won't be large enough for $ListNext to be necessary
		Set tSubCategory=$List(..AvailableSubCategories,tI)
		Set tCode=$Piece(tSubCategory,":",2)
		If $I(tUsedIn(tCode))
	}

	Set tResult=""
	For tI=1:1:$ListLength(..AvailableSubCategories) { // this list won't be large enough for $ListNext to be necessary
		Set tSubCategory=$List(..AvailableSubCategories,tI)
		Set tOptionText=tSubCategory_" "_##class(HL7Configuration).GetStructureName(tSubCategory,..Category)_" ("_..CategorizedFixes.Count("pending",..Category,tSubCategory)_")"
		Set tResult=tResult_$ListBuild($ListBuild(tSubCategory,tOptionText))
	}
	
	Quit tResult
}

}
