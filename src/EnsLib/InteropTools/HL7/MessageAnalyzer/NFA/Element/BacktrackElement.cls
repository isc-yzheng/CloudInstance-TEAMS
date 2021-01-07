/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Element.BacktrackElement Extends ElementBase
{

Property ContextVar As %String [ Private ];

Method %OnNew(pMachine As Machine, pContextVar As %String, pProvenance As %List, pSourceOffset As %List) As %Status
{
	
	#Dim tSC As %Status
	
	Set tSC=##super(pMachine,"Backtrack",pProvenance,pSourceOffset) If $$$ISERR(tSC) {Quit tSC}
	Set ..ContextVar=pContextVar
	Set i%SourceOffset=pSourceOffset

	Quit $$$OK
}

Method OnMarkingTraversal(Output pMarkSeen, Output pAlias, Output pDontTrim, pMachine As Machine)
{
	#Dim tSucc,tI,tList
	
	$$$SHOULDBEUNDEF(pMarkSeen)
	$$$SHOULDBEUNDEF(pAlias)
	$$$SHOULDBEUNDEF(pDontTrim)
	
	Do ..CollectSucc("EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Element.BacktrackElement",pMachine,.tSucc)
	If $Get(tSucc) {
		Set tList=""
		For tI=1:1:tSucc {
			Set tName=tSucc(tI).ElementName
			Set pMarkSeen(tName)=""
			Set tList=$ListBuild(tName)_tList // collect Backtrack element names in reverse order
		}
		Set pAlias(tSucc(tSucc).GetContextVar(),1)=tList // last context var is key
	}
}

/// Does NOT advance the lexer - resets it to the context setting
Method AcceptImpl(pMSR As MessageSegmentReader, pBranchContext As BranchContext) As %List
{
	// PATCHED precondition in
	If pBranchContext.Get(..ContextVar)'="" {
		
		If pBranchContext.EnableBacktracking {
			Do pMSR.SetOffset(pBranchContext.Get(..ContextVar))
		}
	}
	
	Quit $ListBuild(1,..SuccNext)
}

Method DigraphColor() As %String [ CodeMode = expression ]
{
"cyan"
}

Method GetContextVar() [ CodeMode = expression ]
{
..ContextVar
}

Method SetContextVar(pContextVar As %String)
{
	Set ..ContextVar=pContextVar
}

}
