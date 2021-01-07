/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Element.SinkElement Extends ElementBase
{

Method %OnNew(pMachine As Machine, pDummy, pProvenance As %List, pSourceOffset As %List) As %Status
{
	
	#Dim tSC As %Status
	
	Set tSC=##super(pMachine,"SINK",pProvenance,pSourceOffset) If $$$ISERR(tSC) {Quit tSC}
	Set i%SourceOffset=pSourceOffset

	Quit $$$OK
}

/// Does NOT advance the lexer - just returns the link
Method AcceptImpl(pMSR As MessageSegmentReader, pBranchContext As BranchContext) As %List
{
	Quit $ListBuild(0,"")
}

Method DigraphColor() As %String [ CodeMode = expression ]
{
"yellow"
}

}
