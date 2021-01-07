/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.HL7, EnsLib.InteropTools.HL7.MessageAnalyzer.Common)

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.SimpleMessage)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Message.SimpleMessage Extends %RegisteredObject
{

Property MessageSegments As %List [ Private ];

Property FSep As %String [ Private ];

Property CSep As %String [ Private ];

Property SubCSep As %String [ Private ];

Property FRepSep As %String [ Private ];

Property EscSep As %String [ Private ];

Method %OnNew(pMessageText As %String) As %Status
{
	Set tSegSep=$Select(pMessageText[$Char(13):$Char(13),pMessageText[$Char(10):$Char(10),1:",")
	Set ..MessageSegments=$ListFromString(pMessageText,tSegSep)
	
	If ..MessageSegments="" {Quit $$$ERROR($$$GeneralError,"SimpleMessage constructor: message is empty")}
	
	Set tMSHSegment=$List(..MessageSegments)
	If $Extract(tMSHSegment,1,3)'="MSH" {Quit $$$ERROR($$$GeneralError,"SimpleMessage constructor: message does not begin with ""MSH""")}
	
	Set ..FSep=$$$DEFAULT($Extract(tMSHSegment,4),"|")
	Set tMSHSegmentField2=$Piece(tMSHSegment,..FSep,2)
	
	Set ..CSep=$$$DEFAULT($Extract(tMSHSegmentField2),"^")
	Set ..FRepSep=$$$DEFAULT($Extract(tMSHSegmentField2,2),"~")
	Set ..EscSep=$$$DEFAULT($Extract(tMSHSegmentField2,3),"\")
	Set ..SubCSep=$$$DEFAULT($Extract(tMSHSegmentField2,4),"&")

	Quit $$$OK
}

Method ToHL7Message(Output pSC = {$$$OK}) As Message [ CodeMode = expression ]
{
##class(Message).ImportFromString(..GetMessageWithSeps($Char(13,10)),.pSC)
}

/// Return the whole message as a string with carriage-return segment-separators (by default)
Method GetMessage(pSegSep As %String = {$Char(13)}) As %String [ CodeMode = expression ]
{
$ListToString(..MessageSegments,pSegSep)
}

/// Return the whole message as a string with carriage-return segment-separators (by default)
/// <p> Separator characters are included in the first segment, even if absent from the original message
Method GetMessageWithSeps(pSegSep As %String = {$Char(13)}) As %String
{
	Set tSeg1=$List(..MessageSegments)
	If $Length(tSeg1)>3 {
		Quit $ListToString(..MessageSegments,pSegSep)
	}
	
	Quit $ListToString($ListBuild(tSeg1_..FSep_..CSep_..FRepSep_..EscSep_..SubCSep)_$List(..MessageSegments,2,*),pSegSep)
}

/// Return the number of segments in the message
Method SegmentCount() As %Integer [ CodeMode = expression ]
{
$ListLength(..MessageSegments)
}

/// Return the pIndex'th message segment
Method SegmentByIndex(pIndex As %Integer) As %String [ CodeMode = expression ]
{
$List(..MessageSegments,pIndex)
}

/// Return the first segment of the given name in the message
Method FirstSegmentByName(pSegmentType As %String) As %String
{
	Set tPtr=0 While $ListNext(..MessageSegments,tPtr,tSegment) {
		If $$$SEGMENTTYPE(tSegment)=pSegmentType {
			Return tSegment
		}
	}
	
	Quit ""
}

/// Return a list of all the indexes at which the given segment name appears
Method SegmentIndexes(pSegmentType As %String) As %List
{
	Set tOut=""
	Set tIndex=1
	Set tPtr=0 While $ListNext(..MessageSegments,tPtr,tSegment) {
		If $$$SEGMENTTYPE(tSegment)=pSegmentType {
			Set tOut=tOut_$ListBuild(tIndex)
		}
		Set tIndex=tIndex+1
	}
	
	Quit tOut
}

/// Given a segment, return a $List of the fields
Method SegmentFields(pSegment As %String) As %List [ CodeMode = expression ]
{
$ListFromString(pSegment,..FSep)
}

/// Given a field, return a $List of the components
Method FieldComponents(pField As %String) As %List [ CodeMode = expression ]
{
$ListFromString(pField,..CSep)
}

/// Given a component, return a $List of the subcomponents
Method ComponentSubcomponents(pComponent As %String) As %List [ CodeMode = expression ]
{
$ListFromString(pComponent,..SubCSep)
}

/// Given a segment, a field index and zero or more of component index, subcomponent index and field repeat index: return the data
/// <p> To omit one of the optional indexes: either pass "" or omit the argument
Method Access(pSegment As %String, pFieldIndex As %Integer, pComponentIndex As %Integer = "", pSubcomponentIndex As %Integer = "", pFieldRepeatIndex As %Integer = "") As %String
{
	Set tRet=$Piece(pSegment,..FSep,pFieldIndex)
	If pComponentIndex'="" {Set tRet=$Piece(tRef,..CSep,pComponentIndex)}
	If pSubcomponentIndex'="" {Set tRet=$Piece(tRef,..SubCSep,pSubcomponentIndex)}
	If pFieldRepeatIndex'="" {Set tRet=$Piece(tRef,..FRepSep,pFieldRepeatIndex)}
	Quit tRet
}

/// Given a segment, a field index, a start component index and an end component index: return a $List of the given components 
Method AccessComps(pSegment As %String, pFieldIndex As %Integer, pStartComponentIndex As %Integer, pEndComponentIndex As %Integer) As %List [ CodeMode = expression ]
{
$ListFromString($Piece($Piece(pSegment,..FSep,pFieldIndex),..CSep,pStartComponentIndex,pEndComponentIndex),..CSep)
}

}
