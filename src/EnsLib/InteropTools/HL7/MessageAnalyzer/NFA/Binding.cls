/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Binding Extends %RegisteredObject
{

Property MessageText As %String [ Private ];

Property Hierarchy As %List [ Private ];

Property SourceOffset As %List [ Private ];

Method %OnNew(pMessageText As %String, pHierarchy As %List, pSourceOffset As %List = "") As %Status
{
	Set ..MessageText=pMessageText
	Set ..Hierarchy=pHierarchy
	Set ..SourceOffset=pSourceOffset
	Quit $$$OK
}

Method GetSourceOffset() As %List [ CodeMode = expression ]
{
..SourceOffset
}

Method Report() As %String [ CodeMode = expression ]
{
..MessageText_$Select(..Hierarchy="":"",1:" @"_$ListToString(..Hierarchy,":"))
}

}
