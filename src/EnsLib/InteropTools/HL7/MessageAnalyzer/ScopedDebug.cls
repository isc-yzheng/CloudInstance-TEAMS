/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Create an instance of this class to set %MADB and then restore its old value when this instance is destroyed (i.e. which usually means when the variable goes out of scope)
Class EnsLib.InteropTools.HL7.MessageAnalyzer.ScopedDebug Extends %RegisteredObject
{

Property OldMADB As %Boolean [ Private ];

Method %OnNew(pShouldDebug As %Boolean = 1) As %Status
{
	Set ..OldMADB=$Get(%MADB)
	Set %MADB=pShouldDebug
	Quit $$$OK
}

Method %OnClose() As %Status
{
	Set %MADB=..OldMADB
	Quit $$$OK
}

}
