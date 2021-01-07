/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.Shell, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging)

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.DeriveTask, EnsLib.InteropTools.HL7.MessageAnalyzer.Output)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Derive.TreeTask Extends %RegisteredObject [ Final ]
{

Property Tree As Tree [ Private ];

Property FocusIndex As %Integer [ Private ];

Property Heuristic As %String [ Private ];

/// $LB($LB(HEURISTIC,RESULTINGPATTERN),...)
Property History As %List [ Private ];

Property Config As Config [ Private ];

Property Logger As Logger [ Private ];

/// If present, has a method called CheckPattern which takes a string (the pattern) and returns either "" (pattern is OK) or an error message
Property PatternChecker As %RegisteredObject [ Private ];

/// heuristic classes are in the same package as this class
Parameter HEURISTICPACKAGE;

Method %OnNew(pTree As Tree, pFocusIndex As %Integer, pHeuristic As %String, pHistory As %List, pConfig As Config, pLogger As Logger, pPatternChecker As %RegisteredObject = "") As %Status
{
	$$$ACASSERT($IsObject(pTree) && (pFocusIndex>0) && (pHeuristic'="") && (pHeuristic'["."),"Invalid constructor arguments for TreeTask")
	
	Set ..Tree=pTree
	Set ..FocusIndex=pFocusIndex
	Set ..Heuristic=pHeuristic
	Set ..History=pHistory
	Set ..Config=pConfig
	Set ..Logger=pLogger
	Set ..PatternChecker=pPatternChecker
	
	Quit $$$OK
}

Method GetTree() As Tree [ CodeMode = expression ]
{
..Tree
}

Method GetFocusIndex() As %Integer [ CodeMode = expression ]
{
..FocusIndex
}

Method GetHeuristic() As %String [ CodeMode = expression ]
{
..Heuristic
}

Method GetHistory() As %List [ CodeMode = expression ]
{
..History
}

/// Returns new Tree if the tree was changed, "" otherwise
Method Step() As Tree
{
	Set tIndex=..FocusIndex
	Set tNode=..Tree.GetNodeAt(tIndex)
	Set tType=$$$NODETYPE(tNode)
	
	// if the focus node is not a Choice: return "" because none of the heuristics handle anything but choices
	// (this happens when the Choice node is eliminated)
	If tType'="C" {
		Quit ""
	}
	
	// tItems(1..*)
	// - tItems(I) .. only defined for non-special, holds a plain list of strings if present
	// - tItems(I,0) .. the pointer index
	// - tItems(I,1) .. only defined for special, holds the special type code
	Kill tItems
	Set tAnySpecial=..MakeItemIndex(..Tree,tIndex,.tItems)
	
	Set tRet=..StepImplDefault(tType,tAnySpecial,.tItems)
	If tRet="" {
		Quit ""
	}
	
	If ..PatternChecker'="" {
		If '..CheckPattern("applying "_..Heuristic,..Tree.Pattern(),tRet.Pattern()) {
			Quit ""
		}
	}
	
	Set tRet=##class(TopLevel).OptimizeTree(tRet)
	
	If ..PatternChecker'="" {
		If '..CheckPattern("applying "_..Heuristic_" and optimizing",..Tree.Pattern(),tRet.Pattern()) {
			Quit ""
		}
	}
	
	If ..Heuristic'="DeriveTaskOptional" {
		Set tHIndex=..FocusIndex
		Set tHNode=tRet.GetNodeAt(tHIndex)
		Set tHType=$$$NODETYPE(tHNode)
	
		Kill tHItems
		Set tHAnySpecial=..MakeItemIndex(tRet,tHIndex,.tHItems)
	
		Set tHRet=..StepImpl("EnsLib.InteropTools.HL7.MessageAnalyzer.Derive.DeriveTaskOptional",tRet,tHType,tHAnySpecial,.tHItems)
		Quit $Select(tHRet="":tRet,1:##class(TopLevel).OptimizeTree(tHRet))
	}
	
	Quit tRet
}

Method Show() As %String [ CodeMode = expression ]
{
"TreeTask "_..Tree.Pattern()_" @"_..FocusIndex_" ["_..Heuristic_"]"_" -- "_..ShowHistory()
}

/// Return a fully-qualified class name for the Heuristic property - assuming it's in the package (relative to this class) given by the HEURISTICPACKAGE parameter 
Method HeuristicClass() As %String [ CodeMode = expression, Private ]
{
$Piece(..%ClassName(1),".",1,*-1)_..#HEURISTICPACKAGE_"."_..Heuristic
}

Method StepImplDefault(pType As %String, pAnySpecial As %Boolean, ByRef pItems) As Tree [ CodeMode = expression, Private ]
{
..StepImpl(..HeuristicClass(),..Tree,pType,pAnySpecial,.pItems)
}

Method StepImpl(pHeuristic As %String, pTree As Tree, pType As %String, pAnySpecial As %Boolean, ByRef pItems) As Tree [ CodeMode = expression, Private ]
{
$ClassMethod(pHeuristic,"StepImpl",..FocusIndex,pTree,pType,pAnySpecial,.pItems,..Config,..Logger)
}

/// Returns whether any special items were found
ClassMethod MakeItemIndex(pTree As Tree, pIndex As %Integer, Output pItems) As %Boolean [ Private ]
{
	$$$SHOULDBEUNDEF(pItems)
		
	Set tAnySpecial=0
	
	Set tN=pTree.NodeCount(pIndex)
	For tI=1:1:tN {
		Set tPtrIndex=pTree.GetPointerAt(pIndex,tI)
		Set tItemIndex=$I(pItems)
		Set pItems(tItemIndex,0)=tPtrIndex
		Set tItemNode=pTree.GetNodeAt(tPtrIndex)
		Set tItemType=$$$NODETYPE(tItemNode)
		If tItemType="" {
			Set pItems(tItemIndex)=$$$EXTRACTPLAIN(tItemNode) // plain list
		}
		Else {
			Set pItems(tItemIndex,1)=tItemType
			Set tAnySpecial=1
		}
	}
	
	Quit tAnySpecial
}

Method ShowHistory() As %String [ Private ]
{
	Set tOut=""
	Set tPtrI=0 While $ListNext(..History,tPtrI,tElemI) {
		Set tOut=tOut_$ListBuild($List(tElemI)_" :- "_$List(tElemI,2))
	}
	
	Quit $ListToString(tOut,$Char(13,10))
}

/// If there is a problem: logs to session and returns 0, otherwise logs nothing and returns 1
Method CheckPattern(pDescription As %String, pOldPattern As %String, pNewPattern As %String) As %Boolean [ Private ]
{
	If ..IsValidPattern(pNewPattern) {
		Set tErr=..PatternChecker.CheckPattern(pNewPattern)
		If tErr'="" {
			$$$LOGOUTPUT1(..Logger,"*** "_$ListLength(tErr)_" messages did not match")
			$$$LOGOUTPUT1(..Logger,"- after "_pDescription)
			$$$LOGOUTPUT1(..Logger,"- old pattern: "_pOldPattern)
			$$$LOGOUTPUT1(..Logger,"- new pattern: "_pNewPattern)
			$$$LOGOUTPUT1(..Logger,"- history: "_..ShowHistory())
			$$$LOGOUTPUT1(..Logger,"- messages:")
			Set tPtr=0 While $ListNext(tErr,tPtr,tElem) {
				$$$LOGOUTPUT1(..Logger," "_$ListToString(tElem))
			}
			$$$LOGOUTPUT1(..Logger,"")
			Quit 0
		}
	}
	
	Quit 1
}

ClassMethod IsValidPattern(pPattern As %String) As %Boolean [ CodeMode = expression ]
{
(pPattern'["<|") && (pPattern'["||") && (pPattern'["|>")
}

}
