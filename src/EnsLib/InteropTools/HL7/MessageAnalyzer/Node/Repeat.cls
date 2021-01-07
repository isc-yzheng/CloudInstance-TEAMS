/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Node.Repeat Extends EnsLib.InteropTools.HL7.MessageAnalyzer.Node.Base
{

Property Body As Base [ Private ];

Method %OnNew(pBody As Base) As %Status
{
	Set ..Body = pBody
	Quit $$$OK
}

Method GenerateElement(pMachine As Machine, ByRef pGenerateContext, pHierarchy As %List) As ElementTriple
{
	#Dim tContextKey,tProgressVarName1,tProgressVarName2
	#Dim tHierarchy,tFinalItemSucc,tFinalItemFail As %List
	#Dim tTriple1,tTriple2 As ElementTriple
	#Dim tFinalSuccess,tFinalFailure As LinkElement
	#Dim tNoteProgress1,tNoteProgress2 As NoteProgress
	#Dim tCheckProgress1,tCheckProgress2 As CheckProgress
	
	Set tHierarchy=pHierarchy_$ListBuild(..DigraphLabel())

	If ..Body.MatchesEmpty() {
		Set tContextKey="Repeat.Progress"
	}
	Else {
		Set tContextKey=""
	}
	
	// generate 2 element triples from the body node
	Set tTriple1=..Body.GenerateElement(pMachine,.pGenerateContext,tHierarchy)
	Set tTriple2=..Body.GenerateElement(pMachine,.pGenerateContext,tHierarchy)
	
	// final success
	Set tFinalSuccess=##class(LinkElement).%New(pMachine,,$ListBuild(..DigraphLabel()_" Success"),..SourceOffset)
	Set tFinalItemSucc=$ListBuild(tFinalSuccess.ElementName)
	
	// final failure
	Set tFinalFailure=##class(LinkElement).%New(pMachine,,$ListBuild(..DigraphLabel()_" Failure"),..SourceOffset)
	Set tFinalItemFail=$ListBuild(tFinalFailure.ElementName)
	
	// if we need to check for progress ..
	If tContextKey'="" {
	
		// create two progress noter + progress checker pairs
		Set tProgressVarName1=tContextKey_$I(pGenerateContext(tContextKey))
		Set tNoteProgress1=##class(NoteProgress).%New(pMachine,tProgressVarName1,tHierarchy,..SourceOffset)
		Set tCheckProgress1=##class(CheckProgress).%New(pMachine,tProgressVarName1,tHierarchy,..SourceOffset)
		Set tProgressVarName2=tContextKey_$I(pGenerateContext(tContextKey))
		Set tNoteProgress2=##class(NoteProgress).%New(pMachine,tProgressVarName2,tHierarchy,..SourceOffset)
		Set tCheckProgress2=##class(CheckProgress).%New(pMachine,tProgressVarName2,tHierarchy,..SourceOffset)
		
		// point the first noter to the first body
		Do tNoteProgress1.SetNext($ListBuild(tTriple1.In.ElementName),"")
		
		// point the first body to the first checker/fail
		Do tTriple1.SetNextLinks($ListBuild(tCheckProgress1.ElementName),tFinalItemFail)
		
		// point the first checker to the second noter/succ
		Do tCheckProgress1.SetNext($ListBuild(tNoteProgress2.ElementName),tFinalItemSucc)
		
		// point the second noter to the second body
		Do tNoteProgress2.SetNext($ListBuild(tTriple2.In.ElementName),"")
		
		// point the second body to the second checker/succ
		Do tTriple2.SetNextLinks($ListBuild(tCheckProgress2.ElementName),tFinalItemSucc)
		
		// point the second checker to the second noter/succ
		Do tCheckProgress2.SetNext($ListBuild(tNoteProgress2.ElementName),tFinalItemSucc)

		// start at first noter
		Quit ##class(ElementTriple).%New(tNoteProgress1,tFinalSuccess,tFinalFailure)
	}
	
	// .. no need to check for progress ..
	Else {
	
		// point the first body to second body/fail
		Do tTriple1.SetNextLinks($ListBuild(tTriple2.In.ElementName),tFinalItemFail)
		
		// point the second body to itself/succ
		Do tTriple2.SetNextLinks($ListBuild(tTriple2.In.ElementName),tFinalItemSucc)
	
		// start at first body
		Quit ##class(ElementTriple).%New(tTriple1.In,tFinalSuccess,tFinalFailure)
	}
}

Method OptimizedPattern() As %String
{
	
	Set tOptimizedPattern=..Body.OptimizedPattern()
	
	If ..IsSingleton(..Body,"L","R") {
		Quit tOptimizedPattern // don't put more {..} around it
	}
	Else {
		Quit "{"_tOptimizedPattern_"}"
	}
}

Method Pattern() As %String [ CodeMode = expression ]
{
"{"_..Body.Pattern()_"}"
}

Method BuildDeriveTree(pTreeBuilder As TreeBuilder) As %Integer
{
	Kill tChildren
	Do ..GetChildren(.tChildren)
	Quit pTreeBuilder.WriteStructure($$$RTYPE,.tChildren)
}

Method PatternAlternatives(Output pAlternatives) As %String
{
	$$$SHOULDBEUNDEF(pAlternatives)
	
	Set tBase=..Body.PatternAlternatives(.pAlternatives)
	
	Set tEndIndex=pAlternatives
	For tI=1:1:tEndIndex {
		Set tAlt=pAlternatives(tI)
		If tAlt="" {
			Set pAlternatives($I(pAlternatives))=""
		}
		Else {
			Set pAlternatives($I(pAlternatives))=tAlt_","_tAlt
		}
	}
	
	Quit tBase
}

Method Label() As %String [ CodeMode = expression ]
{
"REPEAT"
}

Method TypeCode() As %String [ CodeMode = expression ]
{
"R"
}

Method GetChildren(ByRef pChildren)
{
	Set pChildren($I(pChildren))=..Body
}

Method MatchesEmpty() As %Boolean
{
	#Dim tChildren,tI
	
	Kill tChildren
	Do ..GetChildren(.tChildren)
	For tI=1:1:$Get(tChildren) {
		If 'tChildren(tI).MatchesEmpty() {
			Return 0
		}
	}
	
	Quit 1
}

}
