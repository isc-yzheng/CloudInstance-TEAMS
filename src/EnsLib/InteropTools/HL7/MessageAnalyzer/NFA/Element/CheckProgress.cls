/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Element.CheckProgress Extends ElementBase
{

Property ContextVar As %String [ Private ];

Method %OnNew(pMachine As Machine, pContextVar As %String, pProvenance As %List, pSourceOffset As %List) As %Status
{
	
	#Dim tSC As %Status
	
	Set tSC=##super(pMachine,"CheckProgress",pProvenance,pSourceOffset) If $$$ISERR(tSC) {Quit tSC}
	Set ..ContextVar=pContextVar
	Set i%SourceOffset=pSourceOffset

	Quit $$$OK
}

Method OnMarkingTraversal(Output pMarkSeen, Output pAlias, Output pDontTrim, pMachine As Machine)
{
	$$$SHOULDBEUNDEF(pMarkSeen)
	$$$SHOULDBEUNDEF(pAlias)
	$$$SHOULDBEUNDEF(pDontTrim)

	Set pDontTrim(..ContextVar)=""
}

/// Does NOT advance the lexer - just returns the success link unless there is no progress, in which case it fails
Method AcceptImpl(pMSR As MessageSegmentReader, pBranchContext As BranchContext) As %List
{
	If pMSR.GetOffset()=pBranchContext.Get(..ContextVar) {
		Quit $ListBuild(1,..FailNext)
	}
	
	Quit $ListBuild(1,..SuccNext)
}

Method DigraphColor() As %String [ CodeMode = expression ]
{
"magenta"
}

Method GetContextVar() [ CodeMode = expression ]
{
..ContextVar
}

}
