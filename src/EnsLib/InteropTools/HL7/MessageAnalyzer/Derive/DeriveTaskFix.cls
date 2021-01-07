/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging)

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.DeriveTask, EnsLib.InteropTools.HL7.MessageAnalyzer.Output)

/// Common code for Prefix/Suffix heuristics 
Class EnsLib.InteropTools.HL7.MessageAnalyzer.Derive.DeriveTaskFix [ Abstract ]
{

ClassMethod StepImpl(pCaller As %String, pIndex As %Integer, pTree As Tree, pType As %String, pAnySpecial As %Boolean, ByRef pItems, pConfig As Config, pLogger As Logger) As Tree
{
	$$$ACASSERT((pCaller="DeriveTaskPrefix") || (pCaller="DeriveTaskSuffix"),"DeriveTaskFix: caller should be either DeriveTaskPrefix or DeriveTaskSuffix")
	
	Set tIsPrefix=pCaller="DeriveTaskPrefix"
	
	If pType="C" {
		
		If $Get(pItems)>1 {
		
			Set tNewTree=pTree.Clone()
			
			// look for a common prefix/suffix
			Kill tFirstOrLast
			Kill tEmptyItems
			Set tPlainNonEmptyCount=0
			For tI=1:1:pItems {
				
				// unless it's a structure ..
				If $Data(pItems(tI),tItem)#10 {
					If tItem="" {
						Set tEmptyItems(tI)=""
					}
					Else {
						Set tFirstOrLastString=$Select(tIsPrefix:$List(tItem),1:$List(tItem,*))
						Set tFirstOrLast(tFirstOrLastString,tI)=""
						Set tPlainNonEmptyCount=tPlainNonEmptyCount+1
					}
				}				
			}

			// if there at least 2 plain non-empty items ..
			If tPlainNonEmptyCount>=2 {
			
				// get the first plain item prefix/suffix
				Set tK1=$Order(tFirstOrLast(""))

				// if ALL the items have a common prefix/suffix ..
				If $Order(tFirstOrLast(tK1))="" {				
					Do ..PerformStep(tIsPrefix,pIndex,tNewTree,tK1)					
					Quit tNewTree
				}
				
				// if ANY item has a repeated prefix/suffix
				Set tFix=..AnyRepeated(tIsPrefix,.pItems,.tFirstOrLast)
				If tFix'="" {
					Do ..PerformStep(tIsPrefix,pIndex,tNewTree,tFix)
					Quit tNewTree
				}
				
				// if more than one item has a common prefix ..
				Set tFix=..AnyInCommon(.tFirstOrLast)
				If tFix'="" {
					Do ..PerformStep(tIsPrefix,pIndex,tNewTree,tFix)		
					Quit tNewTree
				}				
			}
		}
	}
	
	Else {
		$$$THROW(pCaller_": Don't know how to handle node type '"_pType_"'")
	}
	
	Quit ""
}

ClassMethod AnyRepeated(pIsPrefix As %Boolean, ByRef pItems, ByRef pFirstOrLast) [ Private ]
{
	Set tK1="" While 1 {
		Set tK1=$Order(pFirstOrLast(tK1)) If tK1="" {Quit}
		Set tK2="" While 1 {
			Set tK2=$Order(pFirstOrLast(tK1,tK2)) If tK2="" {Quit}
			Set tItem=pItems(tK2)
			If $ListLength(tItem)>=2 {
				Set tAdjKey=$Select(pIsPrefix:$List(tItem,2),1:$List(tItem,*-1))
				If tAdjKey=tK1 {Return tK1}
			}
		}
	}
	
	Quit ""
}

ClassMethod AnyInCommon(ByRef pFirstOrLast) [ Private ]
{
	Set tK1="" While 1 {
		Set tK1=$Order(pFirstOrLast(tK1)) If tK1="" {Quit}
		Set tCount=0
		Set tK2="" While 1 {
			Set tK2=$Order(pFirstOrLast(tK1,tK2)) If tK2="" {Quit}
			Set tCount=tCount+1
		}
		If tCount>1 {Return tK1}
	}
	
	Quit ""
}

ClassMethod PerformStep(pIsPrefix As %Boolean, pIndex As %Integer, pTree As Tree, pFix As %String) [ Private ]
{
	// remove any prefix/suffix strings from all items
	If pIsPrefix {
		Set $ListBuild(tOpt,tRep)=..StripFirst(pIndex,pFix,pTree)
	}
	Else {
		Set $ListBuild(tOpt,tRep)=..StripLast(pIndex,pFix,pTree)
	}
	
	// add node for new item made of a single prefix/suffix string
	Set tNewItemIndex=pTree.NewTopLevelEntry($$$PLAINNODE($ListBuild(pFix)))
	
	// if repeat is needed ..
	If tRep {
	
		// create a repeat node and wrap the new prefix/suffix string node in it
		Set tNewItemIndex=##class(TreeModel).CreateRepeat(tNewItemIndex,pTree,"")
	}
	
	// if optional is needed ..
	If tOpt {
	
		// create an optional node and wrap the new prefix/suffix string node in it
		Set tNewItemIndex=##class(TreeModel).CreateOptional(tNewItemIndex,pTree,"")
	}
	
	// create a sequence if necessary
	Set tParentIndex=pTree.GetParentIndex(pIndex)
	Set tSequenceIndex=##class(TreeModel).CreateSequenceIfNeeded(pIndex,tParentIndex,pTree,"")
	
	// insert the (possibly wrapped) prefix/suffix node into the sequence
	If pIsPrefix {
		Do pTree.AddReferenceBefore(tSequenceIndex,tNewItemIndex,pIndex)
	}
	Else {
		Do pTree.AddReferenceAfter(tSequenceIndex,tNewItemIndex,pIndex)
	}
}

/// For each plain node pointed to by the given index: remove as many of the given strings from the front as possible 
ClassMethod StripFirst(pIndex As %Integer, pPrefix As %String, pNewTree As Tree) [ Private ]
{
	// for each item in the node at pIndex ..
	Set tOpt=0
	Set tRep=0
	Set tN=pNewTree.NodeCount(pIndex)
	For tI=1:1:tN {
	
		// the index of the node pointed to by this item
		Set tPtrIndex=pNewTree.GetPointerAt(pIndex,tI)
		
		// the node pointed to by this item
		Set tNode=pNewTree.GetNodeAt(tPtrIndex)
		
		// if it's a structure ..
		If $$$NODETYPE(tNode)'="" {
			
			// leave it unchanged and set 'optional'
			Set tOpt=1
		}
		
		// .. plain text ..
		Else {
		
			// node content
			Set tNodeContent=$$$EXTRACTPLAIN(tNode)
			
			// count the prefix items
			Set tPrefixCount=0
			Set tPtrJ=0 While $ListNext(tNodeContent,tPtrJ,tElemJ),tElemJ=pPrefix {
				Set tPrefixCount=tPrefixCount+1
			}
			
			If tPrefixCount<1 {
				Set tOpt=1
			}
			ElseIf tPrefixCount>1 {
				Set tRep=1
			}
			
			// update the pointed-to node by removing the common prefix items
			Do pNewTree.SetNodeAt($$$PLAINNODE($List(tNodeContent,tPrefixCount+1,*)),tPtrIndex)
		}
	}
	
	Quit $ListBuild(tOpt,tRep)
}

/// For each plain node pointed to by the given index: remove as many of the given strings from the end as possible
ClassMethod StripLast(pIndex As %Integer, pSuffix As %String, pNewTree As Tree) [ Private ]
{
	// for each item in the node at pIndex ..
	Set tOpt=0
	Set tRep=0
	Set tN=pNewTree.NodeCount(pIndex)
	For tI=1:1:tN {
	
		// the index of the node pointed to by this item
		Set tPtrIndex=pNewTree.GetPointerAt(pIndex,tI)
		
		// the node pointed to by this item
		Set tNode=pNewTree.GetNodeAt(tPtrIndex)
		
		// if it's a structure ..
		If $$$NODETYPE(tNode)'="" {
			
			// leave it unchanged and set 'optional'
			Set tOpt=1
		}
		
		// .. plain text ..
		Else {
				
			// node content
			Set tNodeContent=$$$EXTRACTPLAIN(tNode)
			Set tNodeContentLength=$ListLength(tNodeContent)
			
			// count the suffix items
			Set tJ=tNodeContentLength
			While tJ>0,$List(tNodeContent,tJ)=pSuffix {
				Set tJ=tJ-1
			}
			
			If tJ=tNodeContentLength {
				Set tOpt=1
			}
			ElseIf tJ<(tNodeContentLength-1) {
				Set tRep=1
			}
			
			// update the pointed-to node by removing the common suffix
			Do pNewTree.SetNodeAt($$$PLAINNODE($List(tNodeContent,1,tJ)),tPtrIndex)
		}
	}
	
	Quit $ListBuild(tOpt,tRep)
}

}
