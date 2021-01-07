/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Extend.Extensions.ExtendReplace Extends Extend [ Final ]
{

/// Format is standard unsimplified schema
Property NewSchema As %String [ Private ];

Method %OnNew(pNewSchema As %String) As %Status
{
	If pNewSchema'?1.AN,'##class(Common).IsStandardSchema(pNewSchema) {
		$$$THROW("ExtendReplace: new schema must be in standard unsimplified format")
	}
	
	Set ..NewSchema=##class(Common).AsCSF(pNewSchema)
	
	Quit $$$OK
}

Method Describe() As %String [ CodeMode = expression ]
{
"ExtendReplace: replace old schema entirely with: "_..NewSchema
}

/// Given a schema (unsimplified), return the schema with the pattern applied
Method Apply(pSchema As %String) As %String [ CodeMode = expression ]
{
..NewSchema
}

}
