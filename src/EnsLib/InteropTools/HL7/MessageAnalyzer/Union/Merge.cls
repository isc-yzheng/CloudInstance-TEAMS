/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Common, EnsLib.InteropTools.HL7.MessageAnalyzer.Node)

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Union.Merge [ Abstract ]
{

ClassMethod Merge(pBaseName As %String, pBasePattern As %String, pDerivedPattern As %String) As %String
{
	Set tRet=..Split(pBaseName,pBasePattern,pDerivedPattern)
	
	// PATCHED	
	Write pBaseName,":",!
	Set tPtr=0 While $ListNext(tRet,tPtr,tTriple) {
		Write "=",$List(tTriple),!
		Write " base: ",$List(tTriple,2),!
		Write " drvd: ",$List(tTriple,3),!
	}
	
	Quit ""
}

/// Return: $LB(TRIPLE,..) where TRIPLE is $LB(ANCHOR,FOLLOWINGBASESEGMENT,FOLLOWINGDERIVEDSEGMENT)
ClassMethod Split(pBaseName As %String, pBasePattern As %String, pDerivedPattern As %String) As %List [ Private ]
{
	Set $ListBuild(tBaseTerms,tBaseCodes)=..TopLevelAnchorableTerms(pBasePattern)	
	Set $ListBuild(tDerivedTerms,tDerivedCodes)=..TopLevelAnchorableTerms(pDerivedPattern)
	
	Set tCommonTerms=..CommonTerms(tBaseTerms,tDerivedTerms)
	
	Kill tArr // tArr(1..tArr,1)=ANCHOR; tArr(1..tArr,2)=FOLLOWINGBASESEGMENT; tArr(1..tArr,2)=FOLLOWINGDERIVEDSEGMENT
	Set (tBasePos,tDerivedPos)=1
	Set tPtr=0 While $ListNext(tCommonTerms,tPtr,tElem) {
		Set $ListBuild(tTerm,tBaseIndex,tDerivedIndex)=tElem
		Set tQualifiedBaseTerm=$$qualifyterm(tTerm,$List(tBaseCodes,tBaseIndex))
		Set tQualifiedDerivedTerm=$$qualifyterm(tTerm,$List(tDerivedCodes,tDerivedIndex))
		Set tBaseTermPos=##class(Common).IndexOf(pBasePattern,tQualifiedBaseTerm,tBasePos)
		Set tDerivedTermPos=##class(Common).IndexOf(pDerivedPattern,tQualifiedDerivedTerm,tDerivedPos)
		If (tBaseTermPos=0) || (tDerivedTermPos=0) {ZTrap}
		Set tAnchor=$Select($Length(tQualifiedBaseTerm)>$Length(tQualifiedDerivedTerm):tQualifiedBaseTerm,1:tQualifiedDerivedTerm)
		Set tArr($I(tArr),1)=tAnchor
		If tArr'=1 {
			Set tArr(tArr-1,2)=$Extract(pBasePattern,tBasePos,tBaseTermPos-1)
			Set tArr(tArr-1,3)=$Extract(pDerivedPattern,tDerivedPos,tDerivedTermPos-1)
		}
		Set tBasePos=tBaseTermPos+$Length(tQualifiedBaseTerm)
		Set tDerivedPos=tDerivedTermPos+$Length(tQualifiedDerivedTerm)
	}
	
	If '$Get(tArr) {
		Quit ""
	}
	
	Set tArr(tArr,2)=$Extract(pBasePattern,tBasePos,*)
	Set tArr(tArr,3)=$Extract(pDerivedPattern,tDerivedPos,*)
	
	Set tOut=""
	For tI=1:1:tArr {
		Set tOut=tOut_$ListBuild($ListBuild(tArr(tI,1),$Get(tArr(tI,2)),$Get(tArr(tI,3))))
	}
	
	Quit tOut
	
qualifyterm(term,codes)
	Quit $Case(codes,
		"":term,
		"O":"["_term_"]",
		"R":"{"_term_"}",
		"OR":"[{"_term_"}]")
}

/// Returns $LB($LB(LEAF,..),$LB(TYPECODES,..))
ClassMethod TopLevelAnchorableTerms(pPattern As %String) As %List [ Private ]
{
	Set tTopNode=..Compile(pPattern)
	
	Kill tTopChildren
	Do tTopNode.GetChildren(.tTopChildren)
	If '$Get(tTopChildren) {ZTrap}
	
	Set tOutLeafs=""
	Set tOutCodes=""
	For tI=1:1:tTopChildren {
		Set tNode=tTopChildren(tI)
		Kill tLeaf
		Kill tTypeCodes
		If ..Anchorable(tNode,.tLeaf,.tTypeCodes),'$$multiple(tLeaf) {
			Set tOutLeafs=tOutLeafs_$ListBuild(tLeaf)
			Set tOutCodes=tOutCodes_$ListBuild(tTypeCodes)
		}
	}
	
	Quit $ListBuild(tOutLeafs,tOutCodes)
	
multiple(leaf)
	Quit $Length(pPattern,leaf)>2
}

/// Returns $LB($LB(TERM,BASEINDEX,DERIVEDINDEX),..)
ClassMethod CommonTerms(pBaseTerms As %List, pDerivedTerms As %List) As %List [ Private ]
{
	Set (tBaseIndex,tDerivedIndex)=1
	Set tBaseLength=$ListLength(pBaseTerms)
	Set tDerivedLength=$ListLength(pDerivedTerms)
	
	Set tOut=""
	While tBaseIndex<tBaseLength, tDerivedIndex<tDerivedLength {
		
		Set tB=$List(pBaseTerms,tBaseIndex)
		Set tD=$List(pDerivedTerms,tDerivedIndex)
				
		If tB=tD {
			Set tOut=tOut_$ListBuild($ListBuild(tB,tBaseIndex,tDerivedIndex))
			Set tBaseIndex=tBaseIndex+1
			Set tDerivedIndex=tDerivedIndex+1
		}
		
		Else {
			
			Set tDInB=$ListFind(pBaseTerms,tD,tBaseIndex)
			Set tBInD=$ListFind(pDerivedTerms,tB,tDerivedIndex)
			
			// if neither of the terms appears in the other list ..
			If tDInB=0,tBInD=0 {
			
				// skip both
				Set tBaseIndex=tBaseIndex+1
				Set tDerivedIndex=tDerivedIndex+1				
			}
			
			// .. B is found in D ..
			ElseIf tDInB=0 {
				
				// skip to the B in D
				Set tDerivedIndex=tBInD
			}
			
			// .. D is found in B ..
			ElseIf tBInD=0 {

				// skip to the D in B
				Set tBaseIndex=tDInB
			}
			
			// .. each occurs in the other list ..
			Else {
			
				// how far along the D is in B, and the B in D (relative to the current position)
				Set tDRel=tDInB-tBaseIndex
				Set tBRel=tBInD-tDerivedIndex
				
				// if the D in B is closer than the B in D ..
				If tDRel < tBRel {
				 
					// skip to the D in B
					Set tBaseIndex=tDInB
				}
				
				// .. otherwise
				Else {
				
					// skip to the B in D
					Set tDerivedIndex=tBInD
				}
			}
		}
	}
	
	Quit tOut
}

ClassMethod Anchorable(pNode As Base, Output pLeaf, Output pTypeCodes) As %Boolean [ Private ]
{
	$$$SHOULDBEUNDEF(pLeaf)
	$$$SHOULDBEUNDEF(pTypeCodes)
	
	Set tN=pNode
	Set pTypeCodes=""
	Do {
		Set tType=tN.TypeCode()
		
		If (tType="C") || (tType="L") {
			Return 0 // choices and lists can't be anchors
		}
		
		// leaf nodes are returned with success
		If tType="" {
			Set pLeaf=tN.LeafValue()
			Return 1
		}
		
		// .. otherwise it's a structure ..
		
		Set tN=..SingleGrandchild(tN) // structures all have a List as their child
		If tN="" {
			Return 0 // more than one grandchild means it can't be an anchor
		}
		Set pTypeCodes=pTypeCodes_tType
		
	} While $Length(pTypeCodes)<3
	
	Quit 0
}

/// If the given node has a grandchild with no siblings: return it - otherwise return ""
ClassMethod SingleGrandchild(pNode As Base) As Base [ Private ]
{
	Set tOnlyChild=..SingleChild(pNode)
	If tOnlyChild="" {
		Quit ""
	}
	
	Quit ..SingleChild(tOnlyChild)
}

/// If the given node has a child with no siblings: return it - otherwise return ""
ClassMethod SingleChild(pNode As Base) As Base [ Private ]
{
	Kill tChildren
	Do pNode.GetChildren(.tChildren)
	
	If $Get(tChildren)'=1 {
		Quit ""
	}
	
	Quit tChildren(1)
}

ClassMethod Compile(pPattern As %String) As Base [ Private ]
{
	Try {
		Return ##class(Common).CompileSchema(pPattern)
	}
	Catch err {
		Write "- unable to parse schema '"_pRawSchema_"'",!
		Write "- error: ",err.DisplayString(),!
		Write "- schema source: ",schemadefinition,!
		Write !
		Return ""
	}
}

}
