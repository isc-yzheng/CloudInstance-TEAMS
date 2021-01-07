/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Create as-needed to provide a snapshot mapping between schema name and an integer index
Class EnsLib.InteropTools.HL7.MessageAnalyzer.Shell.RigSchemaIndex Extends %RegisteredObject
{

Property RigSchemaList As list Of RigSchema [ Private ];

Property RigSchemaByName As array Of RigSchema [ Private ];

Property RigSchemaNameToIndex As array Of %Integer [ Private ];

Method %OnNew(pRigSchemas As RigSchemaCollection) As %Status
{
	Set tI=0
	Set tKey="" While 1 {
		Set tKey=pRigSchemas.NextByName(tKey) If tKey="" {Quit}
		Set tI=tI+1
		Set tSchema=pRigSchemas.GetByName(tKey)
		Set tSchemaName=tSchema.GetSchemaName()
		$$$THROWONERROR(tSC,..RigSchemaList.Insert(tSchema))
		$$$THROWONERROR(tSC,..RigSchemaByName.SetAt(tSchema,tSchemaName))
		$$$THROWONERROR(tSC,..RigSchemaNameToIndex.SetAt(tI,tSchemaName))
	}
	
	Quit $$$OK
}

Method Count() As %Integer [ CodeMode = expression ]
{
..RigSchemaList.Count()
}

Method GetAt(pIndex As %Integer) As RigSchema [ CodeMode = expression ]
{
..RigSchemaList.GetAt(pIndex)
}

Method GetByName(pSchemaName As %String) As RigSchema [ CodeMode = expression ]
{
..RigSchemaByName.GetAt(pSchemaName)
}

Method SchemaIndex(pSchemaName As %String) As %Integer [ CodeMode = expression ]
{
+..RigSchemaNameToIndex.GetAt(pSchemaName)
}

Method MatchingSchemaIndexes(pSchemaNamePrefix As %String) As %List
{
	Set tOut=""
	
	If pSchemaNamePrefix'="",..RigSchemaByName.IsDefined(pSchemaNamePrefix) {
		Set tOut=tOut_$ListBuild(..RigSchemaNameToIndex.GetAt(pSchemaNamePrefix))
	}
	
	Set lPrefix=$Length(pSchemaNamePrefix)
	Set tKey=pSchemaNamePrefix While 1 {
		Set tKey=..RigSchemaByName.Next(tKey) If tKey="" {Quit}
		If $Extract(tKey,1,lPrefix)'=pSchemaNamePrefix {Quit}
		Set tOut=tOut_$ListBuild(..RigSchemaNameToIndex.GetAt(tKey))
	}
	
	Quit tOut
}

}
