/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Derive.PatternChecker Extends %RegisteredObject
{

Property MessageSegmentListList As %List [ Private ];

Method %OnNew(pMessageSegmentListList As %List) As %Status
{
	Set ..MessageSegmentListList=pMessageSegmentListList
	
	Quit $$$OK
}

/// Tries all our messages against the given pattern, returning a list of all the messages (each message being a $List of segments) which did NOT match the pattern
/// <p> - but if an exception is thrown by the matcher then we return $LB($LB(EXCEPTIONMESSAGE)) 
Method CheckPattern(pPattern As %String) As %List
{
	Try {
	
		Set out=""
		Set ptri=0 While $ListNext(..MessageSegmentListList,ptri,elemi) {
			Set record=..ExpandRepeats(elemi)
			Set match=##class(EnsLib.InteropTools.HL7.MessageAnalyzer.API.IdentifyMessages).MessagePassesSchema(record,pPattern)
			If 'match {
				Set out=out_$ListBuild($ListFromString(record))
			}
		}
		
		Return out
	}
	Catch err {
	
		// don't swallow <INTERRUPT> exceptions
		$$$RETHROWINTERRUPT(err)
		
		Return $ListBuild($ListBuild("ERROR: "_err.DisplayString()))
	}
}

ClassMethod ExpandRepeats(pRawRecord As %List) As %String
{
	Set tRawRecordStr=$ListToString(pRawRecord)
	If tRawRecordStr'["{" {
		Quit tRawRecordStr
	}
	
	Set tRawRecordLen=$Length(tRawRecordStr)
	Set tOut=""
	Set tPos=1
	Do {
	
		// find "{"
		Set tPosOpen=##class(Common).IndexOf(tRawRecordStr,"{",tPos)
		If 'tPosOpen {
		
			// no "{" so add remaining record to output and quit the loop
			Set tOut=tOut_$Extract(tRawRecordStr,tPos,*)
			Quit
		}
		
		// add up to before the "{" to the output
		Set tOut=tOut_$Extract(tRawRecordStr,tPos,tPosOpen-1)
		
		// find "}"
		Set tPosClose=##class(Common).IndexOf(tRawRecordStr,"}",tPosOpen+1)
		If 'tPosClose {ZTrap}
		
		// add the inside to the output
		Set tInside=$Extract(tRawRecordStr,tPosOpen+1,tPosClose-1)
		Set tOut=tOut_tInside
		
		// continue from after the "}"
		Set tPos=tPosClose+1
		
	} While tPos<=tRawRecordLen
	
	Quit tOut
}

}
