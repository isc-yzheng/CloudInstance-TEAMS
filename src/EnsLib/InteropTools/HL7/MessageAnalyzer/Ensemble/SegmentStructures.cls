/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (EnsHL7, EnsLib.InteropTools.HL7.MessageAnalyzer.Utils)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Ensemble.SegmentStructures Extends %RegisteredObject
{

Property Version As %String [ Private ];

Property VersionBase As %String [ Private ];

/// SegmentStructures(SEGMENTNAME)=DESCRIPTION
Property SegmentStructures As array Of %String [ Private ];

Method %OnNew(pVersion As %String) As %Status
{
	Set ..Version=pVersion
	Set ..VersionBase=$Get($$$vaSchemaGbl(..Version,"base"))
	Quit $$$OK
}

Method AnyData() As %Boolean [ CodeMode = expression ]
{
..SegmentStructures.Next("")'=""
}

Method Next(pKey) As %String [ CodeMode = expression ]
{
..SegmentStructures.Next(pKey)
}

Method GetAt(pKey) As %String [ CodeMode = expression ]
{
..SegmentStructures.GetAt(pKey)
}

Method Prepare(pSchemaName As %String, pSchemaSource As %String) As %String
{
	Set tSpecials="~[]{}<|>"
	Set tLenSchemaSource=$Length(pSchemaSource)
	Set tPos=1
	Set tOut=""
	While tPos <= tLenSchemaSource {
	
		Set tStartPos=tPos
		While tPos <= tLenSchemaSource, tSpecials[$Extract(pSchemaSource,tPos) {
			Set tPos=tPos+1
		}
		Set tOut=tOut_$Extract(pSchemaSource,tStartPos,tPos-1)
		
		Set tStartPos=tPos
		While tPos <= tLenSchemaSource, tSpecials'[$Extract(pSchemaSource,tPos) {
			Set tPos=tPos+1
		}
		
		If tPos'=tStartPos {

			Set tName=$Extract(pSchemaSource,tStartPos,tPos-1)
			
			Set tOut=tOut_..PrepareOne(tName)
		}
	}
	
	Quit tOut
}

Method PrepareOne(pName As %String) [ Private ]
{
	// if the name is unqualified ..
	If pName'[":" {
	
		// if there's a base version and this name exists there ..
		If ..VersionBase'="",$Data($$$vaSchemaGbl(..VersionBase,"SS",pName)) {

			// qualify the name with the base version
			Quit "base:"_pName
		}
		Else {
		
			// if the name does not exist in the primary version ..
			If '$Data($$$vaSchemaGbl(..Version,"SS",pName)) {

				// add the name to the primary version
				$$$THROWONERROR(tSC,..SegmentStructures.SetAt(pName,pName))
			}
			
			// qualify the name with the primary version
			Quit ..Version_":"_pName
		}
	}
	
	// .. the name is qualified ..
	Else {
	
		// return the name as-is
		Quit pName
	}
}

}
