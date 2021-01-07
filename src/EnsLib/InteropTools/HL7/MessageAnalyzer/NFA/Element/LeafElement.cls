/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Element.LeafElement Extends ElementBase
{

Property MessageType As %String [ Private ];

Method %OnNew(pMachine As Machine, pMessageType As %String, pProvenance As %List, pSourceOffset As %List) As %Status
{
	
	#Dim tSC As %Status
	
	Set tSC=##super(pMachine,"Leaf["_pMessageType_"]",pProvenance,pSourceOffset) If $$$ISERR(tSC) {Quit tSC}
	Set ..MessageType=pMessageType
	Set i%SourceOffset=pSourceOffset

	Quit $$$OK
}

Method AcceptImpl(pMSR As MessageSegmentReader, pBranchContext As BranchContext) As %List
{
	If 'pMSR.Ended(),..MatchMessageType(pMSR.Get(),..MessageType) {
		Do pBranchContext.Bind(pMSR.GetOffset(),pMSR.Get(),..Provenance,..GetSourceOffset())
		Do pMSR.Next()
		Quit $ListBuild(1,..SuccNext)
	}
	Else {
		Quit $ListBuild(0,..FailNext)
	}
}

Method MatchMessageType(pMessageType1 As %String, pMessageType2 As %String) [ Private ]
{
	#Dim tVersion1,tId1,tVersion2,tId2
	
	If pMessageType1[":" {
		Set tVersion1=$Piece(pMessageType1,":")
		Set tId1=$Piece(pMessageType1,":",2)
	}
	Else {
		Set tVersion1=""
		Set tId1=pMessageType1
	}
	
	If pMessageType2[":" {
		Set tVersion2=$Piece(pMessageType2,":")
		Set tId2=$Piece(pMessageType2,":",2)
	}
	Else {
		Set tVersion2=""
		Set tId2=pMessageType2
	}

	If tVersion1'="",tVersion2'="" {
		Quit pMessageType1=pMessageType2
	}
	
	Quit tId1=tId2
}

}
