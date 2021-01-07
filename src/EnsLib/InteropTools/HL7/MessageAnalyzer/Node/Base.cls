/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.Match.Node, EnsLib.InteropTools.HL7.MessageAnalyzer.Match.Lexer, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Element, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell, EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Derive)

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.DeriveTask)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Node.Base Extends %RegisteredObject [ Abstract ]
{

/// Position of this node in the original source
/// <p> $LB(start,afterend) (1-based)
Property SourceOffset As %List [ Private ];

Method SetSourceOffset(pSourceOffset As %List) [ Final ]
{
	If ..SourceOffset'="" {ZTrap}
	Set ..SourceOffset=pSourceOffset
}

Method GetSourceOffset() As %List [ CodeMode = expression, Final ]
{
..SourceOffset
}

Method Repr() As %String [ Final ]
{
	#Dim tOut,tChildren,tOpener,tCloser,tI
	
	Set tOut=..Label()
	
	Kill tChildren Set tChildren=0
	Do ..GetChildren(.tChildren)
	
	If tChildren {
		Set $ListBuild(tOpener,tCloser)=..Wrapper()
		Set tOut=tOut_tOpener
		For tI=1:1:tChildren {
			If tI'=1 {
				Set tOut=tOut_","
			}
			Set tChildrenRepr=tChildren(tI).Repr()
			If tChildrenRepr[",","[{<("'[$Extract(tChildrenRepr) {
				Set tOut=tOut_"("_tChildrenRepr_")"
			}
			Else {
				Set tOut=tOut_tChildrenRepr
			}
		}
		Set tOut=tOut_tCloser
	}
	
	Quit tOut
}

Method Digraph(pConfig As Config) As %Status [ Final ]
{
	#Dim tDigraph As %CPT.Tree.SimpleDigraph
	#Dim tSC As %Status
	
	Set tDigraph=##class(%CPT.Tree.SimpleDigraph).%New("NODES")

	Set tSC=..DigraphImpl(tDigraph) If $$$ISERR(tSC) {Quit tSC}
		
	Do ##class(Common).ShowDigraph(tDigraph,"node",pConfig)
		
	Quit $$$OK
}

Method GenerateElement(pMachine As Machine, ByRef pGenerateContext, pHierarchy As %List) As ElementTriple [ Abstract ]
{
}

/// Returns pattern in SIMPLIFIED format
/// <p> Order within choices is NOT maintained
Method OptimizedPattern() As %String [ Abstract ]
{
}

/// Returns pattern in SIMPLIFIED format
Method Pattern() As %String [ Abstract ]
{
}

/// Builds a subtree within  a Derive.Tree instance, returning the index to the node
Method BuildDeriveTree(pTreeBuilder As TreeBuilder) As %Integer [ Abstract ]
{
}

/// Returns either a string representing a leaf node, or "" if not a leaf
/// <p> This is the default implementation (for non-leaves)
Method LeafValue() As %String [ CodeMode = expression ]
{
""
}

/// Returns a list of pattern alternatives with the primary one first
Method PatternAlternatives(Output pAlternatives) As %String [ Abstract ]
{
}

Method Show() As %String [ CodeMode = expression, Final ]
{
..%ClassName()_": "_..Repr()
}

/// Return a $List of opener and closer strings (default implementation)
Method Wrapper() As %List [ CodeMode = expression ]
{
$ListBuild("[","]")
}

Method Label() As %String [ Abstract ]
{
}

/// C=>Choice, L=>List, O=>Option, R=>Repeat, ""=>leaf
Method TypeCode() As %String [ Abstract ]
{
}

Method GetChildren(ByRef pChildren) [ Abstract ]
{
}

Method MatchesEmpty() As %Boolean [ Abstract ]
{
}

ClassMethod IsSingleton(pNode As Base, pRequiredNodeTypeCode As %String, pRequiredChildTypeCode As %String)
{
	If pNode.TypeCode()=pRequiredNodeTypeCode {
		Kill tChildren
		Do pNode.GetChildren(.tChildren)
		If $Get(tChildren)=1,tChildren(1).TypeCode()=pRequiredChildTypeCode {
			Quit 1
		}
	} 
	
	Quit 0
}

Method Dump(pIndent As %String = "") [ Final ]
{
	Set tRawLabel=..Label()
	Write pIndent,$$$DEFAULT(tRawLabel,"LIST"),!
	Kill tChildren
	Do ..GetChildren(.tChildren)
	Set tNewIndent=pIndent_" "
	For tI=1:1:$Get(tChildren) {
		Do tChildren(tI).Dump(tNewIndent)
	}
}

Method DigraphImpl(pDigraph As %CPT.Tree.SimpleDigraph) As %Status [ Final, Private ]
{
	#Dim tLabel,tChildren,tI
	#Dim tChildNode As Base
	#Dim tSC As %Status
	
	Set tLabel=..DigraphLabel()
	Do ..GetChildren(.tChildren)
	For tI=1:1:$Get(tChildren) {
		Set tChildNode=tChildren(tI)
		Set tSC=pDigraph.AddEdge(tLabel,tChildNode.DigraphLabel()) If $$$ISERR(tSC) {Return tSC}
		Set tSC=tChildNode.DigraphImpl(pDigraph) If $$$ISERR(tSC) {Return tSC}
	}
	
	Quit $$$OK
}

Method DigraphLabel() As %String [ Final ]
{
	#Dim tLabel,tObjectIndex
	
	Set tLabel=..Label()
	Set tObjectIndex=$Piece($This,"@")
	Quit $Select(tLabel="":"LIST",1:tLabel)_"@"_tObjectIndex
}

}
