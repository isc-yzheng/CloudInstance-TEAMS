/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.NFA, EnsLib.InteropTools.HL7.MessageAnalyzer.Node, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Control, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging)

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Output

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Shell.RigSchema Extends %RegisteredObject
{

Property SchemaName As %String [ Private ];

Property SchemaSpec As %String [ Private ];

Property TopNode As Base [ Private ];

Property Config As Config [ Private ];

Property Logger As Logger [ Private ];

Property NFABuilder As NFABuilder [ Private ];

Method %OnNew(pSchemaName As %String, pSchemaSpec As %String, pTopNode As Base, pConfig As Config, pLogger As Logger) As %Status
{
	Set ..SchemaName=pSchemaName
	Set ..SchemaSpec=pSchemaSpec
	Set ..TopNode=pTopNode
	Set ..Config=pConfig
	Set ..Logger=pLogger
	
	Quit $$$OK
}

Method GetSchemaName() As %String [ CodeMode = expression ]
{
..SchemaName
}

Method GetSchemaSpec() As %String [ CodeMode = expression ]
{
..SchemaSpec
}

Method ListNode()
{
	#Dim tChildren,tI
	
	Kill tChildren Set tChildren=0
	Do ..TopNode.GetChildren(.tChildren)
	If tChildren=0 {
		$$$LOGOUTPUT1(..Logger,..TopNode.Repr())
	}
	Else {
		For tI=1:1:tChildren {
			$$$LOGOUTPUT1(..Logger,tChildren(tI).Repr())
		}
	}
}

Method GraphNode()
{
	#Dim tSC As %Status
	
	$$$THROWONERROR(tSC,..TopNode.Digraph(..Config))
}

Method GenerateNFA(pQuiet As %Boolean = 0)
{
	Set ..NFABuilder=##class(NFABuilder).%New(..Config,..Logger).Generate(..TopNode)
	
	$$$LOGOUTPUTWRITEIF1(..Logger,"NFABuilder:",'pQuiet)
	If ..Config.IsFlagSet("LOGGENERATED") {
		Do ..ListNFA()
	}
	
	If ..Config.IsFlagSet("ALLGRAPHS") {
		Do ..GraphNFA()
	}
	
	$$$LOGOUTPUTWRITEIF1(..Logger,..NFANodeCount()_" NFA nodes (generated)",'pQuiet)
		
	$$$LOGOUTPUTWRITEIF1(..Logger,"Optimize:",'pQuiet)
	Do ..NFABuilder.Optimize()
	If ..Config.IsFlagSet("LOGGENERATED") {
		Do ..ListNFA()}
	If ..Config.IsFlagSet("ALLGRAPHS") {
		Do ..GraphNFA()
	}
	$$$LOGOUTPUTWRITEIF1(..Logger,..NFANodeCount()_" NFA nodes (optimized)",'pQuiet)
}

Method ListNFA()
{
	Do ..CheckNFABuilder()
	Do ..NFABuilder.ListAll()
}

Method NFANodeCount() As %Integer [ CodeMode = expression ]
{
..NFABuilder.NodeCount()
}

Method OptimizeNFA()
{
	Do ..CheckNFABuilder()
	Do ..NFABuilder.Optimize()
}

Method GraphNFA()
{
	Do ..CheckNFABuilder()
	Do ..NFABuilder.Digraph()
}

Method MakeControl(pClassName As %String, pBacktracking As %Boolean) As ControlBase
{
	Do ..CheckNFABuilder()
	Quit ..NFABuilder.MakeControl(pClassName,pBacktracking)
}

Method GetMachine() As Machine
{
	Do ..CheckNFABuilder()
	Quit ..NFABuilder.GetMachine()
}

Method CheckNFABuilder()
{
	If ..NFABuilder="" {Throw ##class(%Exception.General).%New("No NFA has been generated")}
}

}
