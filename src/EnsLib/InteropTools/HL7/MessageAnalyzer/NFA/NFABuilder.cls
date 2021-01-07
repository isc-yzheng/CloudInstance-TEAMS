/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Element, EnsLib.InteropTools.HL7.MessageAnalyzer.Node, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Traverser, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Control, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging)

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.Output)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.NFABuilder Extends %RegisteredObject [ Final ]
{

Property Config As Config [ Private ];

Property Logger As Logger [ Private ];

Property StartElement As ElementBase [ Private ];

Property Machine As Machine [ Private ];

Method %OnNew(pConfig As Config, pLogger As Logger) As %Status
{
	Set ..Config=pConfig
	Set ..Logger=pLogger
	Set ..Machine=##class(Machine).%New()
	
	Quit $$$OK
}

Method Generate(TopNode As Base) As NFABuilder
{
	#Dim tTriple,tGenerateContext,tFinalSucc,tFinalFail
	
	Kill tGenerateContext
	Set tTriple=TopNode.GenerateElement(..Machine,.tGenerateContext,"")

	Set ..StartElement=tTriple.In
	
	Set tFinalSucc = ##class(TerminalElement).%New(..Machine,1,$ListBuild("NFABuilder Success"),"")
	Set tFinalFail = ##class(TerminalElement).%New(..Machine,0,$ListBuild("NFABuilder Failure"),"")

	Do tTriple.SetNextLinks($ListBuild(tFinalSucc.ElementName),$ListBuild(tFinalFail.ElementName))
	
	Quit $This
}

Method Optimize()
{
	Set tNodeCount=..Machine.CreatedCount()
	
	// remove LinkElements
	Do {
		Set tPrevNodeCount=tNodeCount
		Do ..OptimizeImpl(.tNodeCount)
	} While tNodeCount'=tPrevNodeCount
	
	// merge NoteProgress and Backtrack elements
	Do ..MarkingOptimization(.tNodeCount)
}

Method OptimizeImpl(ByRef pNodeCount) [ Private ]
{
	#Dim tScanner,tUnseenNames
	
	// detach link nodes
	Do ..StartElement.Traverse(..Machine,##class(OptimizingTraverser).%New(..Machine))
	
	// remove detached nodes
	Do ..RemoveDetachedNodes(..StartElement,.pNodeCount)
}

Method MarkingOptimization(ByRef pNodeCount) [ Private ]
{
	#Dim tScanner,tUnseenNames,tMarker,tRemover
	#Dim tSC As %Status
	
	If ..Config.IsFlagSet("ALLGRAPHS") {
		$$$THROWONERROR(tSC,..StartElement.Digraph(..Machine,..Config))
	}
	
	// collect items to trim
	Set tMarker=##class(MarkingTraverser).%New(..Machine)
	Do ..StartElement.Traverse(..Machine,tMarker)
	
	// detach the items in the trim list from the graph
	Do tMarker.GetTrimList(.tTrim)
	Set tRemover=##class(RemovingTraverser).%New(..Machine,.tTrim)
	Do ..StartElement.Traverse(..Machine,tRemover)
	
	// remove detached nodes
	Do ..RemoveDetachedNodes(..StartElement,.pNodeCount)
}

Method RemoveDetachedNodes(pStartElement As ElementBase, ByRef pNodeCount) [ Private ]
{
	#Dim tScanner,tUnseenNames,tI
	
	Set tScanner=##class(ScanTraverser).%New(..Machine)
	Do pStartElement.Traverse(..Machine,tScanner)
	Set tUnseenNames=tScanner.UnseenNames
	Set tPtrI=0 While $ListNext(tUnseenNames,tPtrI,tElemI) {
		$$$LOGOUTPUTIFCONFIG1X(..Logger,"Deleting "_tElemI,"LOGOPTIMIZE",..Config)
		Do ..Machine.RemoveAt(tElemI)
		Set pNodeCount=pNodeCount-1
	}
}

Method ListAll()
{
	Do ..StartElement.ListAll(..Machine)
}

Method GetStartElement() As ElementBase [ CodeMode = expression ]
{
..StartElement
}

Method MakeControl(pClassName As %String, pBacktracking As %Boolean) As ControlBase
{
	Quit $ClassMethod(pClassName,"%New",..Machine,..GetStartElement().ElementName,..Config,..Logger,pBacktracking)
}

Method Digraph()
{
	Set tSC=##class(ElementBase).Digraph(..Machine,..Config) If $$$ISERR(tSC) {
		$$$LOGOUTPUT(..Logger,$ListBuild("No digraph - "_$$$STATUS(tSC),""))
	}
}

Method NodeCount() As %Integer [ CodeMode = expression ]
{
..Machine.Count()
}

Method GetMachine() As Machine [ CodeMode = expression ]
{
..Machine
}

}
