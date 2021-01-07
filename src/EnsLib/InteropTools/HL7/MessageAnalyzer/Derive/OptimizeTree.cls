/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.DeriveTask)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Derive.OptimizeTree Extends %RegisteredObject
{

Property Tree As Tree [ Private ];

Method %OnNew(pTree As Tree) As %Status
{
	$$$ACASSERT($Data(pTree) && $IsObject(pTree) && pTree.%IsA("EnsLib.InteropTools.HL7.MessageAnalyzer.Derive.Tree"),"OptimizeTree: Invalid constructor arguments")
	Set ..Tree=pTree
	
	Quit $$$OK
}

/// <p> Choice:
/// <br> - empty => choice node is removed
/// <br> - repeated nodes => remove all but one of each set of repeated nodes (do the single node heuristic AFTER this)
/// <br> - single node => replace choice node with its contents
Method OptimizeTree(pTreeRefs As TreeRefs)
{
	Set tIndex=..Tree.GetTopIndex()

	If $$$DBFLAG {
		Write "Start OptimizeTree @",tIndex,!
		Do ..Tree.Dump()
	}

	Do ..OptimizeSubtree(tIndex,pTreeRefs)
	
	If $$$DBFLAG {
		Write "End OptimizeTree @",tIndex,!
		Do ..Tree.Dump()
	}
}

Method OptimizeSubtree(pIndex As %Integer, pTreeRefs As TreeRefs) [ Private ]
{
	Set tKillList=""
	Set tReplaceList=""
	Do ..OptimizeChild(pIndex,pTreeRefs,.tKillList,.tReplaceList)
	
	Do ..OptimizeProcessActions2(,pIndex,pTreeRefs,tKillList,tReplaceList)
}

Method OptimizeChild(pIndex As %Integer, pTreeRefs As TreeRefs, ByRef pKillList As %List, ByRef pReplaceList As %List) [ Private ]
{
	Set $ListBuild(tAction,tReplaceIndex)=..OptimizeTreeImpl(pIndex,pTreeRefs)
			
	// delete this node ..
	If tAction=1 {
		Set pKillList=$ListBuild(pIndex)_pKillList // construct in reverse order to minimize shuffling on delete
	}
	
	// replace this node ..
	ElseIf tAction=2 {
		Set pReplaceList=$ListBuild(tReplaceIndex)_pReplaceList // construct in reverse order to minimize shuffling on delete
	}
}

Method OptimizeProcessActions2(pParentIndex As %Integer, pIndex As %Integer, pTreeRefs As TreeRefs, pKillList As %List, pReplaceList As %List) [ Private ]
{
	If (pKillList'="") || (pReplaceList'="") {
	
		// delete children in kill list
		Set tPtrI=0 While $ListNext(pKillList,tPtrI,tElemI) {
			Do ..Tree.DeletePointerAt(pIndex,tElemI)
		}
		
		// replace children in replacement list
		Set tPtrI=0 While $ListNext(pReplaceList,tPtrI,tElemI) {
		
			// toplevel
			If '$Data(pParentIndex) {
				$$$ACASSERT(pIndex=..Tree.GetTopIndex(),"no parent index but index arg not topindex")
				$$$ACASSERT(..Tree.NodeCount(pIndex)=1,"index has more than one subnode")
				Do ..Tree.SetTopIndex(..Tree.GetPointerAt(pIndex,1))
			}
			Else {
				Set tParentPointerKey=..Tree.FindPointerIndex(pParentIndex,tElemI)			
				Do ..Tree.ReplacePointerAt(pParentIndex,tParentPointerKey)
			}
		}	
	}
}

/// Returns:
/// <br> 0 => no action
/// <br> 1 => delete this node
/// <br> 2 => replace this node with its contents
Method OptimizeTreeImpl(pIndex As %Integer, pTreeRefs As TreeRefs) As %Integer [ Private ]
{
	Set tNode=..Tree.GetNodeAt(pIndex)
	Set tNodeType=$$$NODETYPE(tNode)
	
	// a structure
	If tNodeType'="" {
	
		Set tNodeCount=..Tree.NodeCount(pIndex)
		
		// optimize the children
		For tPtrIndex=1:1:tNodeCount {
		
			Set tChildIndex=..Tree.GetPointerAt(pIndex,tPtrIndex)
			
			Set tKillList=""
			Set tReplaceList=""
			Do ..OptimizeChild(tChildIndex,pTreeRefs,.tKillList,.tReplaceList)
				
			// process deletes and replaces
			Do ..OptimizeProcessActions2(pIndex,tChildIndex,pTreeRefs,tKillList,tReplaceList)
		}
		
		Set tNodeCount=..Tree.NodeCount(pIndex)
		If tNodeCount=0 {
		
			// no children left => delete this node too
			$$$DBOUT("Optimize deleting #"_pIndex_" - no children left")
			Quit $ListBuild(1,"")
		}
		
		If $$$DBFLAG {
			Write "OptimizeTree @",pIndex," after optimizing children",!
			Do ..Tree.Dump()
		}
		
		// sequence
		If tNodeType="S" {

			// remove empty strings
			Set tToDelete=""
			For tPtrIndex=1:1:tNodeCount {
				Set tChildIndex=..Tree.GetPointerAt(pIndex,tPtrIndex)
				Set tChildNode=..Tree.GetNodeAt(tChildIndex)
				Set tChildType=$$$NODETYPE(tChildNode)
				If tChildType="",$$$EXTRACTPLAIN(tChildNode)="" {
					Set tToDelete=$ListBuild(tPtrIndex)_tToDelete // reverse order, otherwise deletes mess up indexes
				}
			}
			
			Set tPtrI=0 While $ListNext(tToDelete,tPtrI,tElemI) {
				$$$DBOUT("Optimize deleting #"_pIndex_"."_tElemI_" - empty string in sequence")
				Do ..Tree.DeletePointerAt(pIndex,tElemI)
			}
		}

		// choice
		ElseIf tNodeType="C" {
		
			// squash repeated nodes
			Kill tNameUsed
			For tPtrIndex=1:1:tNodeCount {
				Set tSquashNode=..Tree.GetNodeAt(..Tree.GetPointerAt(pIndex,tPtrIndex))
				If $$$NODETYPE(tSquashNode)="" {
					Set tName=$ListBuild(".")_$$$EXTRACTPLAIN(tSquashNode) // avoid empty subscript
					Set tNameUsed(tName,tPtrIndex)=""
				}
			}
			
			Kill tToSquash
			Set tK1="" While 1 {
				Set tK1=$Order(tNameUsed(tK1)) If tK1="" {Quit}
				Set tK2=$Order(tNameUsed(tK1,"")) While 1 {
					Set tK2=$Order(tNameUsed(tK1,tK2)) If tK2="" {Quit}
					Set tToSquash(tK2)=""
				}
			}
			
			Set tK2="" While 1 {
				Set tK2=$Order(tToSquash(tK2),-1) If tK2="" {Quit} // delete in reverse order to avoid invalidating indexes!
				$$$DBOUT("Optimize deleting #"_pIndex_"."_tK2_" - repeated element in choice")
				Do ..Tree.DeletePointerAt(pIndex,tK2)
			}
			
			Set tNodeCount=..Tree.NodeCount(pIndex)
			
			If tNodeCount=1 {
				
				// replace choice node with its contents
				$$$DBOUT("Optimize replacing #"_pIndex_" with its contents - choice now empty")
				Quit $ListBuild(2,pIndex)
			}
		}

		// optional
		ElseIf tNodeType="O" {
		}

		// repeat
		ElseIf tNodeType="R" {
		}
		
		// .. anything else ..
		Else {
			$$$FATAL("OptimizeTreeImpl: unknown node type: '"_tNodeType_"'")
		}
	}
	
	// a plain item
	Else {
	
		Set tValue=$$$EXTRACTPLAIN(tNode)
		
		// if it's an empty list ..
		If tValue="" {
	
			// get parent node type
			Set tParentIndex=..Tree.GetParentIndex(pIndex)
			$$$ACASSERT(tParentIndex,"OptimizeTreeImpl: plain node has top-level as parent")
			Set tParentType=$$$NODETYPE(..Tree.GetNodeAt(tParentIndex))
			
			// if the parent is NOT a choice
			If tParentType'="C" {
				
				// this node should be deleted
				$$$DBOUT("Optimize deleting #"_pIndex_" - empty string in non-choice")
				Quit $ListBuild(1,"")
			}
		}
	}
	
	Quit $ListBuild(0,"")
}

}
