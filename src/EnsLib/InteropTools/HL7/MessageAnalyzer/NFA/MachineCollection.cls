/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.MachineCollection Extends %RegisteredObject
{

/// Machines.GetAt(SCHEMAKEY)
Property Machines As array Of Machine [ Private ];

Method SetAt(pMachine As Machine, pSchemaName As %String)
{
	$$$THROWONERROR(tSC,..Machines.SetAt(pMachine,pSchemaName))
}

Method GetAt(pSchemaName As %String) As Machine [ CodeMode = expression ]
{
..Machines.GetAt(pSchemaName)
}

}
