/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Outcome, EnsLib.InteropTools.HL7.MessageAnalyzer)

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Extend.Extensions.ExtendSequence Extends Extend [ Final ]
{

/// Format is standard unsimplified schema
Property Pattern As %String [ Private ];

/// Insert at this point in the old schema (assumed non-simple)
Property InsertAtOffset As %Integer [ Private ];

Method %OnNew(pPattern As %String, pInsertAtOffset As %Integer) As %Status
{
	If pPattern'?1.AN,'##class(Common).IsStandardSchema(pPattern) {
		$$$THROW("ExtendSequence: original pattern must be in standard unsimplified format")
	}
	
	Set ..Pattern=##class(Common).AsCSF(pPattern)
	Set ..InsertAtOffset=pInsertAtOffset
	
	Quit $$$OK
}

Method Describe() As %String
{
	Quit "ExtendSequence: insert new pattern into schema: "_..Pattern_" at offset "_..InsertAtOffset
}

/// Given a schema (unsimplified), return the schema with the pattern applied
Method Apply(pSchema As %String) As %String
{
	
	If '##class(Common).IsStandardSchema(pSchema) {
		$$$THROW("ExtendSequence: schema to be patched must be in standard unsimplified format")
	}

	If ..IsAppend(pSchema) {
		Set tResult=pSchema_"~"_..Pattern
	}
	Else {
		Set tResult=..InsertAt(pSchema,..InsertAtOffset,..Pattern)
	}
	
	Quit tResult
}

Method IsAppend(pSchema As %String) As %Boolean [ CodeMode = expression, Private ]
{
..InsertAtOffset=($Length(pSchema)+1)
}

ClassMethod InsertAt(tOuterString As %String, tInsertAtOffset As %Integer, tStringToInsert As %String) As %String [ Private ]
{
	$$$ACASSERT((tInsertAtOffset>1) && (tInsertAtOffset<=$Length(tOuterString)),"InsertAt: offset out of range")
	// - we don't accept length+1 because our caller handles it
	
	Quit $Extract(tOuterString,1,tInsertAtOffset-1)_tStringToInsert_"~"_$Extract(tOuterString,tInsertAtOffset,*)
}

}
