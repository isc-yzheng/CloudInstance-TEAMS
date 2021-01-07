/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsLib.InteropTools.HL7.MessageAnalyzer.SimpleMessage

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Common.MessageUtils [ Abstract ]
{

/// Given a message in either lines or csv format: return just the message segment types as a list
ClassMethod MessageSegmentTypes(pMessage As %String) As %List
{
	Set tUseMessage=..ToMessage(pMessage)
	Set tLines=$ListFromString(tUseMessage,$Char(10))
	Set tFSep=$$$FIELDDELIMITER(tUseMessage)
	
	Set tMessageSegmentTypes=""
	Set tPtrI=0 While $ListNext(tLines,tPtrI,tElemI) {
		Set tType=$Piece(tElemI,tFSep)
		If tType'="" {
			Set tMessageSegmentTypes=tMessageSegmentTypes_$ListBuild(tType)
		}
	}
	
	Quit tMessageSegmentTypes
}

ClassMethod ToMessage(Text As %String) As %String [ Private ]
{
	If Text[$Char(10) {
		Quit $ZStrip(Text,"*",$Char(13))
	}
	Else {
		Quit $Translate(Text,",",$Char(10))
	}
}

}
