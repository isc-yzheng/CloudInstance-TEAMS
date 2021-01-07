/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace.Menu.MenuRunner Extends %RegisteredObject
{

Property LastWasExit As %Boolean [ InitialExpression = 0, Private ];

/// Run the given menu:
/// <p> - if they select an option: return 1 and set pSelectedOption to the selected options tag
/// <p> - if they enter "^": return 0 and set pSelectedOption to ""
Method RunMenu(pMenu As MenuBase, Output pSelectedOption As %String) As %Boolean
{
	Set tOptions=pMenu.MenuOptions()
	$$$ACASSERT(tOptions'="","RunMenu: no options given")
	
	// if there's only one option ..
	If $ListLength(tOptions)=1 {
	
		// if we exited from the last menu that was invoked ..
		If ..LastWasExit {
		
			// exit again (leaving LastWasExit set)
			Set pSelectedOption=""
			Quit 0
		}
		
		// .. didn't exit last time ..
		Else {
		
			Set tOnlyOption=$List(tOptions)
			
			// write out the option text (without shortcuts)
			Write $List(tOnlyOption,2),!!
			
			// return the option tag as the result
			Set ..LastWasExit=0
			Set pSelectedOption=$List(tOnlyOption)
			Quit 1
		}
	}
	
	// .. more than one option ..
	Else {
		If pMenu.RunMenu(.pSelectedOption) {
			Set ..LastWasExit=0
			Quit 1
		}
		Else {
			Set ..LastWasExit=1
			Quit 0
		}
	}
}

/// A client must call this if it is going to quit back to a menu - if it doesn't, it will just be reinvoked if the parent menu has only a single option
Method Quitting()
{
	Set ..LastWasExit=1
}

}
