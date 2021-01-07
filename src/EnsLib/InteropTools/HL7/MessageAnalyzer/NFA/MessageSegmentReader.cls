/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

/// Used to parse messages - processes and returns the message types only
Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.MessageSegmentReader Extends %RegisteredObject
{

Property MessageSegments As %List [ Private ];

Property MessageIndex As %Integer [ InitialExpression = 1, Private ];

Method %OnNew(pMessageSegments As %List) As %Status
{
	Set ..MessageSegments=pMessageSegments

	Quit $$$OK
}

/// Update this object from the given MessageSegmentReader
Method UpdateFrom(pMSR As MessageSegmentReader)
{
	If pMSR.MessageSegments'=..MessageSegments {
		Throw ##class(%Exception.General).%New("MessageSegmentReader has different message segments")
	}
	Set ..MessageIndex=pMSR.MessageIndex
}

Method SetOffset(pMessageIndex As %Integer)
{
	If pMessageIndex="" {$$$FATAL("MessageSegmentReader.SetOffset: passed message index is """"")}
	
	Set ..MessageIndex=pMessageIndex
}

Method Ended() As %Boolean
{
	Quit ..MessageIndex>$ListLength(..MessageSegments)
}

Method ProcessedItems() As %List [ CodeMode = expression ]
{
$List(..MessageSegments,1,..MessageIndex-1)
}

Method RemainingItems() As %List [ CodeMode = expression ]
{
$List(..MessageSegments,..MessageIndex,*)
}

Method RemainingText() As %String [ CodeMode = expression ]
{
$ListToString(..RemainingItems())
}

Method Get(OptionalIndexOffset As %Integer) As %String
{
	Do ..CheckNotEnded()
	Quit $List(..MessageSegments,..MessageIndex+$Get(OptionalIndexOffset,0))
}

Method Next()
{
	Do ..CheckNotEnded()
	Set ..MessageIndex=..MessageIndex+1
}

Method GetOffset() [ CodeMode = expression ]
{
..MessageIndex
}

Method OriginalMessage() As %List [ CodeMode = expression ]
{
..MessageSegments
}

Method Show() As %String [ CodeMode = expression ]
{
$ListToString(..ProcessedItems())_"!"_$ListToString(..RemainingItems())
}

Method CheckNotEnded() [ Private ]
{
	If ..Ended() {
		Throw ##class(%Exception.General).%New("MessageSegmentReader is ended")
	}
}

}
