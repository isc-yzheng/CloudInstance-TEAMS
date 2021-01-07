/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace.Menu.StaticMenu Extends MenuBase
{

Property StaticTitle As %String [ Private ];

Property StaticMenuOptions As %List [ Private ];

Method %OnNew(pStaticTitle As %String, pStaticMenuOptions As %List) As %Status
{
	Set ..StaticTitle=pStaticTitle
	Set ..StaticMenuOptions=pStaticMenuOptions
	Quit $$$OK
}

Method Title() As %List [ CodeMode = expression ]
{
..StaticTitle
}

Method MenuOptions() As %List [ CodeMode = expression ]
{
..StaticMenuOptions
}

}
