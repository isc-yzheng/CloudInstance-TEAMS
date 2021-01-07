/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Element.NoteProgress Extends ElementBase
{

Property ContextVar As %String [ Private ];

Method %OnNew(pMachine As Machine, pContextVar As %String, pProvenance As %List, pSourceOffset As %List) As %Status
{
	
	#Dim tSC As %Status
	
	Set tSC=##super(pMachine,"NoteProgress",pProvenance,pSourceOffset) If $$$ISERR(tSC) {Quit tSC}
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

	Do ..CollectSucc("EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Element.NoteProgress",pMachine,.tSucc)
	If $Get(tSucc) {
		Set tList=""
		For tI=1:1:tSucc {
			Set tName=tSucc(tI).ElementName
			Set pMarkSeen(tName)=""
			Set tList=tList_$ListBuild(tName) // collect NoteProgress element names in forward order
		}
		Set pAlias(..ContextVar,0)=tList // first context var is key
	}
}

/// Does NOT advance the lexer - just returns the success link
Method AcceptImpl(pMSR As MessageSegmentReader, pBranchContext As BranchContext) As %List
{
	Do pBranchContext.Set(..ContextVar,pMSR.GetOffset())
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
