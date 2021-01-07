/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Extend.Extensions.Extend Extends %RegisteredObject [ Abstract ]
{

Method Describe() As %String [ Abstract ]
{
}

/// Given a schema (unsimplified), return the schema with the pattern applied
Method Apply(pSchema As %String) As %String [ Abstract ]
{
}

}
