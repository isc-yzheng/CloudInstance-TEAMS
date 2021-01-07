/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer.Shell

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Message.MatchCache Extends %RegisteredObject
{

Property RigSchemaIndex As RigSchemaIndex [ Private ];

/// Cache(MATCHCOUNT,RIGSCHEMAINDEX)=""
Property Cache As %String [ MultiDimensional, Private ];

Property CachedOrder As %List [ Private ];

Method %OnNew(pRigSchemaIndex As RigSchemaIndex) As %Status
{
	Set ..RigSchemaIndex=pRigSchemaIndex
	Set ..CachedOrder=..NormalOrder(..RigSchemaIndex)
	
	Quit $$$OK
}

Method SchemaOrder() As %List [ CodeMode = expression ]
{
..CachedOrder
}

Method OnMatch(pRigSchemaIndex As %Integer)
{
	Set tMatchCount="" While 1 {
	
		Set tMatchCount=$Order(..Cache(tMatchCount)) If tMatchCount="" {Quit}
		
		If $Data(..Cache(tMatchCount,pRigSchemaIndex)) {
			Kill ..Cache(tMatchCount,pRigSchemaIndex)
			Set ..Cache(tMatchCount+1,pRigSchemaIndex)=""
			Set ..CachedOrder=..ComputeOrder()
			Return
		}
	}
	
	Set ..Cache(1,pRigSchemaIndex)=""
	Set ..CachedOrder=..ComputeOrder()
}

ClassMethod NormalOrder(pRigSchemaIndex As RigSchemaIndex) As %List
{
	Set tOut=""	
	For tI=1:1:pRigSchemaIndex.Count() {
		Set tOut=tOut_$ListBuild(tI)
	}
	
	Quit tOut
}

Method ComputeOrder() As %List
{
	Set tOut=""
	Set tMatchCount="" While 1 {
		Set tMatchCount=$Order(..Cache(tMatchCount),-1) If tMatchCount="" {Quit}
		Set tRigSchemaIndex="" While 1 {
			Set tRigSchemaIndex=$Order(..Cache(tMatchCount,tRigSchemaIndex)) If tRigSchemaIndex="" {Quit}
			Set tOut=tOut_$ListBuild(tRigSchemaIndex)
			Set tSeen(tRigSchemaIndex)=""
		}
	}
	
	For tI=1:1:..RigSchemaIndex.Count() {
		If '$Data(tSeen(tI)) {
			Set tOut=tOut_$ListBuild(tI)
		}
	}
	
	Quit tOut
}

}
