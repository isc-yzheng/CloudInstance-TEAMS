/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.HL7.MessageAnalyzer.PackageScanner Extends %RegisteredObject
{

Property Package As %String [ Private ];

Property CurrentClass As %String [ Private ];

Method %OnNew(pPackage As %String) As %Status
{
	Set ..Package=pPackage
	Set ..CurrentClass=..Package // a class with the same name as the package will NOT be returned by this class
	Quit $$$OK
}

/// Returns 1 if a class was found, 0 at the end
Method NextClass(Output pClass As %String) As %Boolean
{
	Set tNextClass=$$$comClassNext(..CurrentClass)
	If (tNextClass="") || '..InPackage(tNextClass) {
		Quit 0
	}

	Set ..CurrentClass=tNextClass
	
	Set pClass=..CurrentClass
	Quit 1
}

Method InPackage(pClass As %String) As %Boolean [ CodeMode = expression, Private ]
{
(..Package_".")=$Extract(pClass,1,$Length(..Package)+1)
}

}
