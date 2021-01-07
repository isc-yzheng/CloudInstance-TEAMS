/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace.Menu.ValidationTopMenu Extends MenuBase
{

/// Selected(MENUTAG)=BOOLEAN - 0 (or missing) means unselected, 1 means selected
Property Selected As %Boolean [ MultiDimensional, Private ];

Method Title() As %List [ CodeMode = expression ]
{
$ListBuild("Workflow/2 - Validation")
}

Method MenuOptions() As %List
{
	If $$$WFOLDMENUS {
		Quit $ListBuild(
			$ListBuild("SF",..Sel("SF")_"Select Field Validation","SF"),
			$ListBuild("SC",..Sel("SC")_"Select Component Validation","SC"),
			$ListBuild("ST",..Sel("ST")_"Select Code Table Validation","ST"),
			$ListBuild("GO","Start Validation","GO")
			)
	}
	Else {
		Quit $ListBuild(
			$ListBuild("SF","Select Field Validation "_..Sel("SF"),"SF"),
			$ListBuild("SC","Select Component Validation "_..Sel("SC"),"SC"),
			$ListBuild("ST","Select Code Table Validation "_..Sel("ST"),"ST"),
			$ListBuild("GO","Start Validation","GO")
			)
	}
}

Method ToggleSelected(pMenuTag As %String)
{
	Set ..Selected(pMenuTag)='$Get(..Selected(pMenuTag),0)
}

Method SelectedOptions() As %List
{
	Set tRet=""
	For tI="SF","SC","ST" {
		If $Get(..Selected(tI),0) {
			Set tRet=tRet_$ListBuild(tI)
		}
	}
	
	Quit tRet
}

Method Sel(pMenuTag As %String) As %String [ CodeMode = expression, Private ]
{
"["_$Select($Get(..Selected(pMenuTag)):"X",1:" ")_"] "
}

}
