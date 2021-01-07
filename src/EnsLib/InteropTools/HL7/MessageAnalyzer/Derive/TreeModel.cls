/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer.Lines

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.DeriveTask)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Derive.TreeModel [ Abstract ]
{

/// If the parent of node at the given index is NOT a sequence node: create a sequence node and point it to the node at the given index
/// <p> Returns the index of the sequence node (new or old)  
ClassMethod CreateSequenceIfNeeded(pIndex As %Integer, pParentIndex As %Integer, pNewTree As Tree, pTreeRefs As TreeRefs) As %Integer
{
	
	// if the parent is NOT a sequence ..
	If (pParentIndex=0) || ($$$NODETYPE(pNewTree.GetNodeAt(pParentIndex))'="S") {

		// create a new sequence node
		Quit ..CreateSequence(pIndex,pParentIndex,pNewTree,pTreeRefs)
	}
	Else {
		Quit pParentIndex
	}
}

/// Create a sequence node and point it to the node at the given index
/// <p> Returns the index of the new sequence node  
ClassMethod CreateSequence(pIndex As %Integer, pParentIndex As %Integer, pNewTree As Tree, pTreeRefs As TreeRefs) As %Integer
{
	
	// create a new sequence node
	Set tNewIndex=pNewTree.NewTopLevelEntry($$$SNODE)
	
	// add the given node to the sequence
	Do pNewTree.AddReference(tNewIndex,pIndex)
	
	// update references to the given node
	Do pNewTree.ChangeReferences(tNewIndex,pIndex,pTreeRefs)
	
	Quit tNewIndex
}

/// Creates a new repeat node and replaces the node at pContainedIndex, which the repeat node adopts.  Returns the index to the new repeat node.
ClassMethod CreateRepeat(pContainedIndex As %Integer, pNewTree As Tree, pTreeRefs As TreeRefs) As %Integer
{
	// create a new repeat node
	Set tNewIndex=pNewTree.NewTopLevelEntry($$$RNODE)

	// add the contained index as a reference
	Do pNewTree.AddReference(tNewIndex,pContainedIndex)

	// update references to the given node
	Do pNewTree.ChangeReferences(tNewIndex,pContainedIndex,pTreeRefs)
	
	Quit tNewIndex
}

/// Creates a new optional node and replaces the node at pIndex, which the optional node adopts.  Returns the index to the new optional node.
ClassMethod CreateOptional(pIndex As %Integer, pNewTree As Tree, pTreeRefs As TreeRefs) As %Integer
{
	// create a new optional node
	Set tNewIndex=pNewTree.NewTopLevelEntry($$$ONODE)
	
	// add the given node to the optional
	Do pNewTree.AddReference(tNewIndex,pIndex)
	
	// update references to the given node
	Do pNewTree.ChangeReferences(tNewIndex,pIndex,pTreeRefs)
	
	Quit tNewIndex
}

/// Given the index of a Choice node with all-plain children, return a %List in the format expected by the AbstractStrings constructor
ClassMethod AsAbstractStringsLines(pTree As Tree, pIndex As %Integer) As %List
{
	$$$ACASSERT($IsObject(pTree) && pIndex,"Invalid arguments to AsAbstractStringsLines")
	
	Set tNode=pTree.GetNodeAt(pIndex)
	If $$$NODETYPE(tNode)'="C" {
		$$$FATAL("AsAbstractStringsLines called with a non-choice node: '"_$$$NODETYPE(tNode)_"'")
	}
	
	Set tNodeCount=pTree.NodeCount(pIndex)
	Set tOut=""
	For tI=1:1:tNodeCount {
		Set tPointerIndex=pTree.GetPointerAt(pIndex,tI)
		Set tPointerNode=pTree.GetNodeAt(tPointerIndex)
		If $$$NODETYPE(tPointerNode)'="" {
			$$$FATAL("AsAbstractStringsLines called with a non-plain child node: '"_$$$NODETYPE(tPointerNode)_"'")
		}
		
		Set tPointerList=$ListToString($$$EXTRACTPLAIN(tPointerNode))
		$$$ACASSERT(tPointerList'["{","AsAbstractStringsLines: record contains '{'")
	
		Set tOut=tOut_$ListBuild(tPointerList)
	}
	
	Quit tOut
}

ClassMethod IsChoiceWithEmptyString(pTree As Tree, pIndex As %Integer) As %Boolean
{
	Set tNode=pTree.GetNodeAt(pIndex)
	Set tNodeType=$$$NODETYPE(tNode)
	If tNodeType="C" {
		Set tNodeChildCount=pTree.NodeCount(pIndex)
		For tI=1:1:tNodeChildCount {
			Set tChildIndex=pTree.GetPointerAt(pIndex,tI)
			Set tChildNode=pTree.GetNodeAt(tChildIndex)
			Set tChildNodeType=$$$NODETYPE(tChildNode)
			If tChildNodeType="" {
				Set tChildData=$$$EXTRACTPLAIN(tChildNode)
				If tChildData="" {
					Return 1
				}
			}
		}
	}
	
	Quit 0
}

/// Replaces any symbols from pLinesSymbols in the tree with their definitions
/// <p> Returns 1 if any symbols were replaced
ClassMethod ReplaceSymbols(pTree As Tree, pLinesSymbols As LinesSymbols) As %Boolean
{
	Set tReplacedAny=0
	For tI=1:1:pTree.Count() {
		Set tNode=pTree.GetNodeAt(tI)
		If $$$NODETYPE(tNode)="" {
			Set tData=$$$EXTRACTPLAIN(tNode)
			If ##class(LinesSymbols).ListHasSymbol(tData) {
				Set tNewData=$ListFromString(pLinesSymbols.SubstituteSymbolsIn($ListToString(tData)))
				Do pTree.SetNodeAt($$$PLAINNODE(tNewData),tI)
				Set tReplacedAny=1
			}
		}
	}
	
	Quit tReplacedAny
}

}
