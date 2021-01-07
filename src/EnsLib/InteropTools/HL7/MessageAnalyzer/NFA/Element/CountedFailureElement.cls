/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Element.CountedFailureElement Extends ElementBase
{

Property FailureLimit As %Integer [ Private ];

Property FailuresSeen As %Integer [ InitialExpression = 0, Private ];

Method %OnNew(pMachine As Machine, pFailureLimit, pProvenance As %List, pSourceOffset As %List) As %Status
{
	#Dim tSC As %Status
	
	Set tSC=##super(pMachine,"CountedFailure",pProvenance,pSourceOffset) If $$$ISERR(tSC) {Quit tSC}
	Set ..FailureLimit=pFailureLimit
	Set i%SourceOffset=pSourceOffset

	Quit $$$OK
}

/// Does NOT advance the lexer - just returns the success link
Method AcceptImpl(pMSR As MessageSegmentReader, pBranchContext As BranchContext) As %List
{
	Set ..FailuresSeen=..FailuresSeen+1
	If ..FailuresSeen=..FailureLimit {Quit $ListBuild(0,..FailNext)}
	
	Quit $ListBuild(1,..SuccNext)
}

Method DigraphColor() As %String [ CodeMode = expression ]
{
"red"
}

}
