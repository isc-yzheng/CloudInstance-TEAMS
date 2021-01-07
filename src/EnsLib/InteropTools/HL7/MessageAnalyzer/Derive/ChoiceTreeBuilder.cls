/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.DeriveTask)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Derive.ChoiceTreeBuilder
{

/// Puts "{XXX}" items into the tree as literals or as subtrees
ClassMethod MakeTree(pStrings As %List, pRepeatAsSubtrees As %Boolean) As Tree
{
	// create initial tree
	Kill tTreeArr
	Set tTreeArr(1)=$$$CNODE // top-level node at #1: a choice node
	Set tTopIndex=1
	Set tTree=##class(Tree).%New(.tTreeArr,tTopIndex)	
	
	Set tPtrI=0 While $ListNext(pStrings,tPtrI,tElemI) {
	
		// if it has a repeat ..
		Set tElemIStr=$ListToString(tElemI)
		If tElemIStr["{" {
			
			$$$ACASSERT(tElemIStr["}","MakeTree: invalid pStrings argument")
			
			If pRepeatAsSubtrees {
				Set tTreeIndex=..MakeTreeRepeatAsSubtree(tTree,tElemI)
			}
			Else {
				Set tTreeIndex=..MakeTreeRepeatAsLiteral(tTree,tElemI)
			}
		}
		
		// .. no repeats ..
		Else {
		
			// write the string as a plain node
			Set tTreeIndex=tTree.NewTopLevelEntry($$$PLAINNODE(tElemI))
		}
				
		// point to the new node from the choice node
		Do tTree.AddReference(1,tTreeIndex)
	}
	
	Quit tTree
}

/// Writes the given element to the tree as a sequence of plain records and repeat-nodes
ClassMethod MakeTreeRepeatAsSubtree(pTree As Tree, pElemI As %List) As %Integer [ Private ]
{
	// write new top node as a sequence node
	Set tTreeIndex=pTree.NewTopLevelEntry($$$SNODE)
	
	Set tSequenceStart=1
	Set tItemIndex=1
	Set tPtrJ=0 While $ListNext(pElemI,tPtrJ,tElemJ) {
	
		// if it is a repeat ..
		If $Extract(tElemJ)="{" {
		
			$$$ACASSERT($Extract(tElemJ,*)="}","MakeTreeRepeatAsSubtree: invalid pStrings argument item")
			
			// write pending items - if any
			If tSequenceStart'=tItemIndex {
			
				// write the string as a plain node and point the sequence to it
				Set tPlainTreeIndex=pTree.NewTopLevelEntry($$$PLAINNODE($List(pElemI,tSequenceStart,tItemIndex)))
				Do pTree.AddReference(tTreeIndex, tPlainTreeIndex)

				// update sequence start index
				Set tSequenceStart=tItemIndex+1
			}
			
			// write this item as a repeat and point the sequence to it
			Set tRepeatTreeIndex=pTree.NewTopLevelEntry($$$RNODE)
			Do pTree.AddReference(tTreeIndex, tRepeatTreeIndex)
			Set tRPlainTreeIndex=pTree.NewTopLevelEntry($$$PLAINNODE($ListFromString($Extract(tElemJ,2,*-1))))
			Do pTree.AddReference(tRepeatTreeIndex, tRPlainTreeIndex)
		}
		
		Set tItemIndex=tItemIndex+1
	}
	
	// write pending items - if any
	If tSequenceStart'=tItemIndex {
	
		// write the string as a plain node and point the sequence to it
		Set tPlainTreeIndex=pTree.NewTopLevelEntry($$$PLAINNODE($List(pElemI,tSequenceStart,tItemIndex)))
		Do pTree.AddReference(tTreeIndex, tPlainTreeIndex)
	}
	
	Quit tTreeIndex
}

/// Writes the given element to the tree as a plain record
ClassMethod MakeTreeRepeatAsLiteral(pTree As Tree, pElemI As %List) As %Integer [ Private ]
{
	// write element to tree as a plain node
	Quit pTree.NewTopLevelEntry(pElemI)
}

}
