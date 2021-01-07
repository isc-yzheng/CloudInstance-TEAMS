/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Element.TerminalElement Extends ElementBase
{

Property IsSuccess As %Boolean [ Private ];

Method %OnNew(pMachine As Machine, pIsSuccess As %String, pProvenance As %List, pSourceOffset As %List) As %Status
{
	
	#Dim tSC As %Status
	
	Set tSC=##super(pMachine,"Terminal["_$Select(pIsSuccess:"SUCCESS",1:"FAILURE")_"]",pProvenance,pSourceOffset) If $$$ISERR(tSC) {Quit tSC}
	Set ..IsSuccess=pIsSuccess
	Set i%SourceOffset=pSourceOffset
	
	Quit $$$OK
}

/// Does NOT advance the lexer - just returns the link
Method AcceptImpl(pMSR As MessageSegmentReader, pBranchContext As BranchContext) As %List
{
	Quit $ListBuild(..IsSuccess,..SuccNext)
}

Method DigraphColor() As %String [ CodeMode = expression ]
{
$Select(..IsSuccess:"green",1:"red")
}

}
