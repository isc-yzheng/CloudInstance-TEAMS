/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.DeriveTask)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Derive.TreeBuilder Extends %RegisteredObject
{

Property Tree As Tree [ Private ];

Property Level As %Integer [ Private ];

Property Pending As %String [ MultiDimensional, Private ];

Method %OnNew() As %Status
{
	Set ..Tree=""
	Set ..Level=0
	Set ..Pending=""
	Quit $$$OK
}

ClassMethod PatternToTree(pPattern As %String, Output pFocusIndex As %Integer) As Tree
{
	Set tBuilder=##class(EnsLib.InteropTools.HL7.MessageAnalyzer.Derive.TreeBuilder).%New()
	Set tSchema=##class(EnsLib.InteropTools.HL7.MessageAnalyzer.Common).AsCSF(pPattern)
	
	Set tLexer=##class(EnsLib.InteropTools.HL7.MessageAnalyzer.Lexer).%New(tSchema)
	Set tTopNode=##class(EnsLib.InteropTools.HL7.MessageAnalyzer.Parser).ParseSchema(tLexer)
	
	Do tTopNode.BuildDeriveTree(tBuilder)
	Set tTree=tBuilder.GetTree()
	
	Set pFocusIndex=..FindChoice(tTree)
	
	Quit tTree
}

/// pChildren(1..pChildren)=NODE
/// <p> Where NODE has:
/// <ul>
///  <li> a method BuildDeriveTree which takes a tree builder and returns an index into the new tree
///  <li> a method LeafValue which returns either a string representing a leaf node, or "" if not a leaf
/// </ul>
/// <p> (NODE is currently expected to be a subclass of EnsLib.InteropTools.HL7.MessageAnalyzer.Node.Base)
Method WriteStructure(pNodeType As %String, ByRef pChildren) As %Integer
{
	// if this is a sequence ..
	If pNodeType=$$$STYPE {
	
		$$$ACASSERT($Get(pChildren),"WriteStructure: sequence is empty")
		
		Quit ..WriteSequence(.pChildren)			
	}
	
	// .. otherwise ..
	Else {
	
		Set ..Level=..Level+1
		
		// write structure head
		Set tStructureIndex=..Commit(pNodeType)
		
		// add children
		Do ..AddChildren(tStructureIndex,.pChildren)
		
		Set ..Level=..Level-1
		
		Quit tStructureIndex
	}
}

Method AddChildren(pStructureIndex As %Integer, ByRef pChildren) [ Private ]
{
	For tI=1:1:$Get(pChildren) {
		Set tSubIndex=pChildren(tI).BuildDeriveTree($This)
		Do ..Tree.AddReference(pStructureIndex,tSubIndex)
	}
}

Method GetTree() As Tree
{
	If ..Level'=0 {ZTrap}
	
	Quit ..Tree
}

ClassMethod FindChoice(pTree As Tree) As %Integer [ Private ]
{
	For tI=1:1:pTree.Count() {
		Set tNode=pTree.GetNodeAt(tI)
		Set tNodeType=$$$NODETYPE(tNode)
		If tNodeType="C" {
			Return tI
		}
	}
	
	// no choices - return 1 as a safe index for soft failure
	Quit 1
}

Method Commit(pNodeType As %String) As %Integer [ Private ]
{
	// if the tree hasn't been created yet ..
	If ..Tree="" {
		Kill tTreeArr
		Set tTreeArr(1)=$$$NODE(pNodeType)
		Set tTopIndex=1
		Set ..Tree=##class(Tree).%New(.tTreeArr,tTopIndex)
		Quit 1	
	}
	
	Else {
		Quit ..Tree.NewTopLevelEntry($$$NODE(pNodeType))
	}
}

Method WriteSequence(ByRef pChildren) As %Integer [ Private ]
{
	Set tPending=""
	Kill tSequence

	For tI=1:1:pChildren {
	
		Set tNode=pChildren(tI)
		
		Set tLeaf=tNode.LeafValue()
	
		// if it's a leaf ..
		If tLeaf'="" {
		
			// add it to the pending list
			Set tPending=tPending_$ListBuild(tLeaf)
		}
		
		// .. not a leaf ..
		Else {
			
			// flush any leaves and add the node to the sequence
			Do flush	
			Set tSequence($I(tSequence))=tNode
		}
	}
	
	Do flush
	
	$$$ACASSERT($Get(tSequence),"WriteSequence: sequence is empty")

	// if there's only one item: return it without a sequence wrapper
	If tSequence=1 {
		Quit $$writeitem(tSequence(1))
	}
	
	/// create a sequence
	Set tStructureIndex=..Commit($$$STYPE)
	
	/// add entries to it
	For tI=1:1:tSequence {

		// create entry for item 
		Set tTreeIndex=$$writeitem(tSequence(tI))
		
		// add item to sequence
		Do ..Tree.AddReference(tStructureIndex,tTreeIndex)
	}
	
	Quit tStructureIndex
	
flush
	If tPending'="" {
		Set tSequence($I(tSequence))=tPending
		Set tPending=""
	}
	Quit
	
writeitem(item)
	
	If '$IsObject(item) {
	
		// a $List
		Quit ..Tree.NewTopLevelEntry($$$PLAINNODE(item))
	}
		
	Else {
		
		// a structure
		Quit item.BuildDeriveTree($This)		
	}
}

/// TODO REMOVE
Method Indent() As %String [ CodeMode = expression, Private ]
{
$Justify("",..Level)
}

}
