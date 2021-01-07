/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.Workflow)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace.Menu.MenuBase Extends %RegisteredObject [ Abstract ]
{

/// Run the given menu:
/// <p> - if they select an option: return 1 and set pSelectedOption to the selected options tag
/// <p> - if they enter "^": return 0 and set pSelectedOption to ""
Method RunMenu(Output pSelectedOption As %String) As %Boolean [ Final ]
{
	Write !,"-----",! // before a menu is shown
			
	Set tTitle=..Title()
	For tI=1:1:$ListLength(tTitle) { // we assume that the list will never be long enough to justify using $ListNext
		Write $List(tTitle,tI),!
	}
	
	Write !
	
	Set tOptions=..MenuOptions()
	$$$ACASSERT(tOptions'="","RunMenu: no options given")
	
	Do ..ShowOptions(tOptions)
	
	Write !
	
	While 1 {
		
		Read "Enter one of the above options, ^ to go back a level: ",tIn,!
		
		If tIn'="" {
		
			If tIn="^" {
				Set pSelectedOption=""
				Return 0 // they typed '^'
			}
			
			Set tInNum=+tIn
			If tInNum'[".", tInNum>=1, tInNum<=$ListLength(tOptions) {
				Set pSelectedOption=$List($List(tOptions,tInNum))
				Return 1 // they selected an option number
			}
			
			Else {
				For tI=1:1:$ListLength(tOptions) { // we assume that the list will never be long enough to justify using $ListNext
					Set tExtraKeys=$ListGet($List(tOptions,tI),3)
					If $$$TOUP(tExtraKeys)=$$$TOUP(tIn) {
						Set pSelectedOption=$List($List(tOptions,tI))
						Return 1 // they selected a shortcut
					}
				}
			}
		}
	}
}

/// Should return a $List of title lines
Method Title() As %List [ Abstract ]
{
}

/// Should return a $List of menu items
/// <p> A menu item has this form: $ListBuild(TAG,TEXT,EXTRAKEYS)
/// <ul>
///  <li> TAG is what is returned when this item is selected
///  <li> TEXT is the text representing this item, written to the menu display
///  <li> EXTRAKEYS is a string which can be entered instead of the menu line number - "" means no such string and this list item can be omitted in this case
/// </ul>
Method MenuOptions() As %List [ Abstract ]
{
}

ClassMethod ShowOptions(pOptions As %List)
{
	Set tIWidth=$Length($ListLength(pOptions))
	Set tOldMenus=$$$WFOLDMENUS
	For tI=1:1:$ListLength(pOptions) { // we assume that the list will never be long enough to justify using $ListNext
		If tOldMenus {
			Write " ",$Justify(tI,tIWidth),". ",..OptionText($List(pOptions,tI)),!
		}
		Else {
			Write " [",$Justify(tI,tIWidth),"] ",..OptionText($List(pOptions,tI)),!
		}
	}
}

ClassMethod OptionText(pOneOption As %List) As %String [ Private ]
{
	Set tExtraKeys=$ListGet(pOneOption,3)
	If (tExtraKeys="") || '$$$WFOLDMENUS {
		Quit $List(pOneOption,2)
	}
	Else {
		Quit $List(pOneOption,2)_" ["_tExtraKeys_"]"
	}
}

}
