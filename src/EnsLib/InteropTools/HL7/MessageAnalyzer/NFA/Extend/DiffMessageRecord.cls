/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Extend.DiffMessageRecord Extends %RegisteredObject
{

Property MessageSegmentTypes As %List [ Private ];

Property SegmentOffsets As %List [ Private ];

Method %OnNew(pMessageSegmentTypes As %List, pSegmentOffsets As %List) As %Status
{
	$$$ACASSERT((pMessageSegmentTypes'="") && ($ListLength(pMessageSegmentTypes)=$ListLength(pSegmentOffsets)),"DiffMessageRecord: bad arguments passed to constructor")
	
	Set ..MessageSegmentTypes=pMessageSegmentTypes
	Set ..SegmentOffsets=pSegmentOffsets
	
	Quit $$$OK
}

Method GetMessageSegmentTypes() As %List [ CodeMode = expression ]
{
..MessageSegmentTypes
}

Method GetSegmentOffsets() As %List [ CodeMode = expression ]
{
..SegmentOffsets
}

Method Show(pSchemaSource As %String = "") As %String [ CodeMode = expression ]
{
$ListToString(..MessageSegmentTypes)_" "_..ShowSegmentOffsets(pSchemaSource)
}

Method ShowSegmentOffsets(pSchemaSource) As %String [ Private ]
{
	Set tSegmentOffsets=..SegmentOffsets
	
	Set tOut=""
	Set tPtr=0 While $ListNext(tSegmentOffsets,tPtr,tElem) {
		Set $ListBuild(tStartOffset,tAfterEndOffset)=tElem
		Set tOffsetExpansion=$ListBuild($Select(
			pSchemaSource=""||1:tStartOffset_"-"_tAfterEndOffset, // TOPATCH-PATCHED
			1:$Extract(pSchemaSource,tStartOffset,tAfterEndOffset-1)))
		Set tOut=tOut_tOffsetExpansion
	}
	
	Quit "["_$ListToString(tOut)_"]"
}

}
