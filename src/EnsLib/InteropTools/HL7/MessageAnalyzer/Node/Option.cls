/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Node.Option Extends EnsLib.InteropTools.HL7.MessageAnalyzer.Node.Base
{

Property Body As Base [ Private ];

Method %OnNew(pBody As Base) As %Status
{
	Set ..Body = pBody
	Quit $$$OK
}

Method GenerateElement(pMachine As Machine, ByRef pGenerateContext, pHierarchy As %List) As ElementTriple
{
	#Dim tHierarchy,tFinalSucc As %List
	#Dim tTriple As ElementTriple
	#Dim tFinalSuccess As LinkElement
	
	Set tHierarchy=pHierarchy_$ListBuild(..DigraphLabel())

	// the optional node
	Set tTriple=..Body.GenerateElement(pMachine,.pGenerateContext,tHierarchy)
	
	// final success
	Set tFinalSuccess=##class(LinkElement).%New(pMachine,,$ListBuild(..DigraphLabel()_" Success"),..SourceOffset)
	Set tFinalSucc=$ListBuild(tFinalSuccess.ElementName)
	
	// point the optional node's succ+fail links to final success
	Do tTriple.SetNextLinks(tFinalSucc,tFinalSucc)
	
	Quit ##class(ElementTriple).%New(tTriple.In,tFinalSuccess,"")
}

Method OptimizedPattern() As %String
{
	
	Set tOptimizedPattern=..Body.OptimizedPattern()
		
	If ..IsSingleton(..Body,"L","O") {
		Quit tOptimizedPattern // don't put more [..] around it
	}
	Else {
		Quit "["_tOptimizedPattern_"]"
	}
}

Method Pattern() As %String [ CodeMode = expression ]
{
"["_..Body.Pattern()_"]"
}

Method BuildDeriveTree(pTreeBuilder As TreeBuilder) As %Integer
{
	Kill tChildren
	Do ..GetChildren(.tChildren)
	Quit pTreeBuilder.WriteStructure($$$OTYPE,.tChildren)
}

Method PatternAlternatives(Output pAlternatives) As %String
{
	$$$SHOULDBEUNDEF(pAlternatives)
	Set tBase=..Body.PatternAlternatives(.pAlternatives)
	Set pAlternatives($I(pAlternatives))=""
	
	Quit tBase
}

Method Label() As %String [ CodeMode = expression ]
{
"OPTION"
}

Method TypeCode() As %String [ CodeMode = expression ]
{
"O"
}

Method GetChildren(ByRef pChildren)
{
	Set pChildren($I(pChildren))=..Body
}

Method MatchesEmpty() As %Boolean [ CodeMode = expression ]
{
1
}

}
