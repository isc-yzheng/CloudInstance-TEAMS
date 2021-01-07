/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.NFA, EnsLib.InteropTools.HL7.MessageAnalyzer.Message)

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Shell.RigSchemaCollection Extends %RegisteredObject
{

Property RigSchemaByName As array Of RigSchema [ Private ];

/// Maintain this rather than calling O(N) method in array property
Property SchemaCount As %Integer [ InitialExpression = 0, Private ];

Property LocalSchemaNames As %String [ MultiDimensional, Private ];

Method Clear()
{
	Do ..RigSchemaByName.Clear()
	Set ..SchemaCount=0
}

Method Insert(pRigSchema As RigSchema, pIsLocal As %Boolean = 0)
{
	Set tSchemaName=pRigSchema.GetSchemaName()
	$$$ACASSERT('pIsLocal || '$Data(..LocalSchemaNames(tSchemaName)),"RigSchemaCollection.Insert: local schema '"_tSchemaName_"' is already loaded")
	
	Set ..SchemaCount=..SchemaCount+1
	
	$$$THROWONERROR(tSC,..RigSchemaByName.SetAt(pRigSchema,tSchemaName))
	
	If pIsLocal {
		Set ..LocalSchemaNames(tSchemaName)=""
	}
}

Method ClearLocalSchemas()
{
	
	Set tKey="" While 1 {
		Set tKey=$Order(..LocalSchemaNames(tKey)) If tKey="" {Quit}
		Do ..RigSchemaByName.RemoveAt(tKey)
		Set ..SchemaCount=..SchemaCount-1
	}
	
	Kill ..LocalSchemaNames
}

Method NextByName(pSchemaName As %String) As %String [ CodeMode = expression ]
{
..RigSchemaByName.Next(pSchemaName)
}

Method Count() As %Integer [ CodeMode = expression ]
{
..SchemaCount
}

Method GetByName(pSchemaName As %String) As RigSchema [ CodeMode = expression ]
{
..RigSchemaByName.GetAt(pSchemaName)
}

Method MakeMachineCollection() As MachineCollection
{
	Set tMachines=##class(MachineCollection).%New()
	Set tKey="" While 1 {
		Set tKey=..NextByName(tKey) If tKey="" {Quit}
		Set tRigSchema=..GetByName(tKey)
		Set tMachine=tRigSchema.GetMachine()
		Do tMachines.SetAt(tMachine,tKey)
	}
	
	Quit tMachines
}

Method Dump()
{
	Write "RigSchemaCollection",!
	Write "- SchemaCount=",..SchemaCount,!
	Write "- Names:",! 
	Set tOut=""
	Set tKey="" While 1 {
		Set tKey=..RigSchemaByName.Next(tKey) If tKey="" {Quit}
		Set tOut=tOut_$ListBuild(tKey)
	}
	Write "-- ",$ListLength(tOut)," names",!
	Write "-- ",$ListToString(tOut),!
	If ($Data(..LocalSchemaNames)\10)=0 {
		Write "- no local schema names",!
	}
	Else {
		Write "- local schema names:",!
		Set tKey="" While 1 {
			Set tKey=$Order(..LocalSchemaNames(tKey)) If tKey="" {Quit}
			Set tOut=tOut_$ListBuild(tKey)
		}
		Write "-- ",$ListLength(tOut)," local names",!
		Write "-- ",$ListToString(tOut),!
	}
}

}
