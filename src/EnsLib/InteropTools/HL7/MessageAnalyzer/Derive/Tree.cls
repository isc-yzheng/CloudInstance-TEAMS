/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.DeriveTask, EnsLib.InteropTools.HL7.MessageAnalyzer.Utils)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Derive.Tree Extends %RegisteredObject
{

/// Tree(I,...) is a subtree - the top level is NOT ordered in any way
/// <p> Tree(I) itself is a $List: $LB(1,X) is a special node of type X, otherwise the items after the first "0" of $LB(0,X1,X2,...) is a list of leaf strings (message types)
/// <p> Special node types are C=choice, S=sequence, O=optional, R=repeat, OR=optional repeat
/// <p> A special node has 1..N subscripts (whose order is significant for type S) where the values are indexes into the top level of Tree 
Property Tree As %List [ MultiDimensional, Private ];

/// Indicates the index of the root node in Tree
Property TopIndex As %Integer [ Private ];

Method %OnNew(ByRef pTree, pTopIndex As %Integer) As %Status
{
	If $Data(pTree(pTopIndex))#10=0 {
		$$$FATAL("Top index ("_pTopIndex_") not found in tree passed to Derive.Tree constructor")
	}
	
	Merge ..Tree=pTree
	Set ..TopIndex=pTopIndex
	
	Quit $$$OK
}

Method Clone() As Tree
{
	Merge tTree=..Tree

	Quit ##class(Tree).%New(.tTree,..TopIndex)
}

Method ReplaceWith(pTree As Tree)
{
	Kill ..Tree
	Merge ..Tree=pTree.Tree
	Set ..TopIndex=pTree.TopIndex
}

Method Pattern(pIndex As %Integer, pQuotePlainValues As %Boolean = 0) As %String
{
	Set tIndex=$Get(pIndex,..GetTopIndex())
	Set tNode=..GetNodeAt(tIndex)
	Set tType=$$$NODETYPE(tNode)
	If tType="" {
		Set tValue=$ListToString($$$EXTRACTPLAIN(tNode))
		If pQuotePlainValues {
			Quit """"_tValue_""""
		}
		Else {
			Quit tValue
		}
	}
	
	Set tSubPatterns=..SubPatterns(tIndex,pQuotePlainValues)
	Quit $Case(tType,
		"C":"<"_$ListToString(tSubPatterns,"|")_">",
		"S":$ListToString(tSubPatterns,","),
		"O":"["_$$$SINGLE(tSubPatterns)_"]",
		"R":"{"_$$$SINGLE(tSubPatterns)_"}",
		"OR":"[{"_$$$SINGLE(tSubPatterns)_"}]",
		:$$$THROWE("unknown node type: "_tType)
	)
}

/// Create a new top-level tree entry for the given node, returning the index
Method NewTopLevelEntry(pNode As %List) As %Integer
{
	Set tNewIndex=$Order(..Tree(""),-1)+1
	Set ..Tree(tNewIndex)=pNode
	Quit tNewIndex
}

/// Add the given pointer pPointerIndex to the end of the entry at pIndex
Method AddReference(pIndex As %Integer, pPointerIndex As %Integer)
{
	Set tNewIndex=$Order(..Tree(pIndex,""),-1)+1
	Set ..Tree(pIndex,tNewIndex)=pPointerIndex
}

/// In the pIndex subtree: add the given pointer pPointerIndex before the subentry containing pBeforeThisPointerIndex
Method AddReferenceBefore(pIndex As %Integer, pPointerIndex As %Integer, pBeforeThisPointerIndex As %Integer)
{
	Set tSubIndex=..FindPointerIndex(pIndex,pBeforeThisPointerIndex) 
	Set tN=..NodeCount(pIndex)
	For tI=tN:-1:tSubIndex {
		Set ..Tree(pIndex,tI+1)=..Tree(pIndex,tI)
	}
	Set ..Tree(pIndex,tSubIndex)=pPointerIndex
}

/// In the pIndex subtree: add the given pointer pPointerIndex after the subentry containing pAfterThisPointerIndex
Method AddReferenceAfter(pIndex As %Integer, pPointerIndex As %Integer, pAfterThisPointerIndex As %Integer)
{
	Set tSubIndex=..FindPointerIndex(pIndex,pAfterThisPointerIndex) 
	Set tN=..NodeCount(pIndex)
	For tI=tN:-1:tSubIndex+1 {
		Set ..Tree(pIndex,tI+1)=..Tree(pIndex,tI)
	}
	Set ..Tree(pIndex,tSubIndex+1)=pPointerIndex
}

/// Change all references to pPointerIndex to refer to pIndex instead
/// <p> References in pIndex are NOT changed
Method ChangeReferences(pIndex As %Integer, pPointerIndex As %Integer, pTreeRefs As TreeRefs)
{
	Set tN=+$Order(..Tree(""),-1)
	For tI=1:1:tN {
		If tI'=pIndex {
			Set tS=+$Order(..Tree(tI,""),-1)
			For tJ=1:1:tS {
				If ..Tree(tI,tJ)=pPointerIndex {
					Set ..Tree(tI,tJ)=pIndex
				}
			}
		}
	}
	
	If ..TopIndex=pPointerIndex {
		Set ..TopIndex=pIndex
	}
	
	If pTreeRefs'="" {
		Do pTreeRefs.ChangeRefs(pPointerIndex,pIndex)
	}
}

/// Return the top-level node at the given index
Method GetNodeAt(pIndex As %Integer) As %List [ CodeMode = expression ]
{
..Tree(pIndex)
}

Method SetNodeAt(pNode As %List, pIndex As %Integer)
{
	Set ..Tree(pIndex)=pNode
}

/// Return the pointer index at the given top-level index and pointer key
Method GetPointerAt(pIndex As %Integer, pPointerKey As %Integer) As %Integer [ CodeMode = expression ]
{
..Tree(pIndex,pPointerKey)
}

Method DeletePointerAt(pIndex As %Integer, pPointerKey As %Integer)
{
	Set tNodeCount=..NodeCount(pIndex)
	For tI=pPointerKey:1:tNodeCount-1 {
		Set ..Tree(pIndex,tI)=..Tree(pIndex,tI+1)
	}
	Kill ..Tree(pIndex,tNodeCount)
}

Method DeleteAllPointersAt(pIndex As %Integer)
{
	Set tNodeCount=..NodeCount(pIndex)
	For tI=1:1:tNodeCount {
		Kill ..Tree(pIndex,tI)
	}
}

/// Given Tree(pIndex,pPointerKey)=INDEX, where Tree(INDEX) has exactly one child TREE(INDEX,1)=CHILDINDEX
/// <p> Insert Tree(pIndex,NEWPOINTERKEY)=CHILDINDEX after pPointerKey and delete Tree(pIndex,pPointerKey) 
Method ReplacePointerAt(pIndex As %Integer, pPointerKey As %Integer)
{
	Set tPointerIndex=..Tree(pIndex,pPointerKey)
	Set tPointerNodeCount=..NodeCount(tPointerIndex)
	If tPointerNodeCount'=1 {
		$$$FATAL("ReplacePointerAt: node to be replaced does not have exactly 1 child")
	}
	
	Set tChildPointerIndex=..Tree(tPointerIndex,1)
	Do ..AddReferenceAfter(pIndex,tChildPointerIndex,tPointerIndex)
	
	Do ..DeletePointerAt(pIndex,pPointerKey)
}

Method Count() As %Integer [ CodeMode = expression ]
{
+$Order(..Tree(""),-1)
}

Method NodeCount(pIndex As %Integer) As %Integer [ CodeMode = expression ]
{
+$Order(..Tree(pIndex,""),-1)
}

Method GetTopIndex() As %Integer [ CodeMode = expression ]
{
..TopIndex
}

Method SetTopIndex(pNewTopIndex As %Integer)
{
	Set ..TopIndex=pNewTopIndex
}

Method FindPointerIndex(pIndex As %Integer, pPointerIndex As %Integer) As %Integer
{
	Set tN=..NodeCount(pIndex)
	For tI=1:1:tN {
		If ..Tree(pIndex,tI)=pPointerIndex {Return tI}
	}
	
	$$$FATAL("FindPointerIndex: in subtree at index "_pIndex_" can't find pointer index value "_pPointerIndex)
}

/// This is not a method you want to call often - it searches the tree
/// <p> Returns 0 if this is the root node
/// <p> Throws an exception if this is not the root node and no parent is found in the tree (probably a detached node)
Method GetParentIndex(pIndex As %Integer) As %Integer
{
	If pIndex=..GetTopIndex() {
		Quit 0
	}
	
	Set tTreeCount=..Count()
	For tI=1:1:tTreeCount {
		If tI'=pIndex { // we don't have cycles so no point checking the index we're searching for
			Set tNodeCount=..NodeCount(tI)
			For tJ=1:1:tNodeCount {
				If ..Tree(tI,tJ)=pIndex {
					Return tI
				}	
			}
		}
	}
	
	$$$FATAL("GetParentIndex: no parent found for index "_pIndex)
}

Method SubPatterns(pIndex As %Integer, pQuotePlainValues As %Boolean) As %List [ Private ]
{
	Set tOut=""
	Set tN=..NodeCount(pIndex)
	For tI=1:1:tN {
		Set tPtrIndex=..GetPointerAt(pIndex,tI)
		Set tOut=tOut_$ListBuild(..Pattern(tPtrIndex,pQuotePlainValues))
	}
	
	Quit tOut
}

Method Dump()
{
	Write "TopIndex=",..TopIndex,!
	Set tN=..Count()
	For tI=1:1:tN {
		Write " ",tI,": ",$ListToString(..GetNodeAt(tI)),!
		Set tS=..NodeCount(tI)
		For tJ=1:1:tS {
			Write "  ",tJ,": ",..GetPointerAt(tI,tJ),!
		}
	}
	
	Try {
		Set tPattern=..Pattern()
	}
	Catch (err) {
		Set tPattern="(unstable tree - optimizing?)"
	}
	Write "- pattern=",tPattern,!
}

}
