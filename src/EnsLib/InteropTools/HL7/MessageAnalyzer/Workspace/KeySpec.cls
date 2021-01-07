/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer.Message

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.SimpleMessage)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace.KeySpec Extends %RegisteredObject
{

Property KeySpec As %String [ Private ];

Parameter ACCESSORS As %List = {$LB($LB("SA","Sending Application"),$LB("SF","Sending Facility"),$LB("RA","Receiving Application"),$LB("RF","Receiving Facility"),$LB("PF","PID Last Update Facility"))};

Method %OnNew(pKeySpec As %String) As %Status
{
	Set ..KeySpec=pKeySpec
	Quit $$$OK
}

/// Returns $LB($LB(SHORTNAME,LONGNAME),..)
ClassMethod Accessors() As %List [ CodeMode = expression ]
{
..#ACCESSORS
}

ClassMethod ShortNames() As %String [ CodeMode = expression ]
{
$ListToString(..ShortNameList(),", ")
}

ClassMethod ShortNameList() As %String
{
	Set tOut=""
	Set tPtr=0 While $ListNext(..#ACCESSORS,tPtr,tElem) {
		Set tOut=tOut_$ListBuild($List(tElem))
	}
	
	Quit tOut
}

ClassMethod IsValidShortNameList(pStr As %String) As %Boolean
{
	Set tShortNameList=..ShortNameList()
	For tI=1:1:$Length(pStr,",") {
		If '$ListFind(tShortNameList,$Piece(pStr,",",tI)) {
			Return 0
		}
	}
	
	Quit 1
}

Method KeySpecKeyFor(pFullMessage As %String) As %String
{
	If ..KeySpec="" {
		Quit "ALL"
	}
	
	Set tSimpleMessage=##class(SimpleMessage).%New(pFullMessage)
	If '$IsObject(tSimpleMessage) {			
		$$$ThrowStatus(%objlasterror)
	}
	
	Set tKeySpec=..KeySpec
	
	Set tOut=""
	For tI=1:1:$Length(tKeySpec,",") {
		Set tOut=tOut_$ListBuild(..ExpandKey(tSimpleMessage,$Piece(tKeySpec,",",tI)))
	}
	
	Quit $ListToString(tOut,"-")
}

ClassMethod ExpandKey(pSimpleMessage As SimpleMessage, pKeyCode As %String) As %String [ Private ]
{
	Quit $Case(pKeyCode,
		"SA":$$$DEFAULT($ListToString($$$SMMSHSENDINGAPPLICATION(pSimpleMessage),"^"),"NOSA"),
		"SF":$$$DEFAULT($ListToString($$$SMMSHSENDINGFACILITY(pSimpleMessage),"^"),"NOSF"),
		"RA":$$$DEFAULT($ListToString($$$SMMSHRECEIVINGAPPLICATION(pSimpleMessage),"^"),"NORA"),
		"RF":$$$DEFAULT($ListToString($$$SMMSHRECEIVINGFACILITY(pSimpleMessage),"^"),"NORF"),
		"PF":$$$DEFAULT(..PIDLastUpdateFacility(pSimpleMessage),"NOPF"),
		:$$$THROWE("KeySpec: unknown key code - "_pKeyCode))
}

/// Return the PID Last Update Facility
ClassMethod PIDLastUpdateFacility(pSimpleMessage As SimpleMessage) As %String [ Private ]
{
	Set tFirstPIDSegment=pSimpleMessage.FirstSegmentByName("PID")
	Quit pSimpleMessage.Access(tFirstPIDSegment,34)
}

}
