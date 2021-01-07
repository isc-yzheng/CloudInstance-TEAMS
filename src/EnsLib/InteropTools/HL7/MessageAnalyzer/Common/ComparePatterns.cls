/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Node)

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

/// Comparison by segment
Class EnsLib.InteropTools.HL7.MessageAnalyzer.Common.ComparePatterns Extends %RegisteredObject
{

Property LPattern As %String [ Private ];

Property RPattern As %String [ Private ];

Property LTopNode As Base [ Private ];

Property RTopNode As Base [ Private ];

Method %OnNew(pLPattern As %String, pRPattern As %String) As %Status
{
	Set ..LPattern=pLPattern
	Set ..RPattern=pRPattern
	
	Set ..LTopNode=##class(Common).CompileSchema(..LPattern)
	Set ..RTopNode=##class(Common).CompileSchema(..RPattern)
	
	Quit $$$OK
}

/// Returns a $List of $Lists
/// <p> Each entry of the outer list takes the form $LB(LEFT,RIGHT)
Method Compare() As %List
{
	Kill tLTopChildNodes
	Kill tLTopChildReprs
	Do ..GetChildReprs(..LTopNode,.tLTopChildNodes,.tLTopChildReprs)
	
	Kill tRTopChildNodes
	Kill tRTopChildReprs
	Do ..GetChildReprs(..RTopNode,.tRTopChildNodes,.tRTopChildReprs)
	
	Set tOut=""
	Set tPOut=""
	Set (tLP,tRP)=1
	While 1 {
		
		// extract a chunk
		Set tRet=..ExtractChunk(.tLTopChildReprs,tLP,.tRTopChildReprs,tRP)
		If tRet="" {
			Quit  // quit the loop
		}
				
		// the new pointers
		Set $ListBuild(tNewLP,tNewRP)=tRet
		$$$ACASSERT((tNewLP'=tLP)||(tNewRP'=tRP),"Compare: no movement")
		
		If 0 {
			Do ..CrossCompareBases(tLP,tNewLP-1,tRP,tNewRP-1,.tLTopChildReprs,.tRTopChildReprs)
		}
		
		// extract the left and right parts of the chunk
		Set tLeft=..NodesRepr(.tLTopChildReprs,tLP,tNewLP-1)
		Set tRight=..NodesRepr(.tRTopChildReprs,tRP,tNewRP-1)
		
		// append the segment to the output
		Set tOut=tOut_$ListBuild($ListBuild(tLeft,tRight))
		
		// append the pointers to the output
		Set tPOut=tPOut_$ListBuild($ListBuild(tNewLP,tNewRP))
		
		// advance the pointers
		Set tLP=tNewLP,tRP=tNewRP
	}

	If 1 {
		$$$ACASSERT($ListLength(tOut)=$ListLength(tPOut),"MISMATCH")
		Set (tLP,tRP)=1
		For tI=1:1:$ListLength(tOut) {

			Set $ListBuild(tLeft,tRight)=$List(tOut,tI)
			Set $ListBuild(tNewLP,tNewRP)=$List(tPOut,tI)
			
			//**
			
			Set tLNode=##class(Common).CompileSchema(tLeft)
			Set tRNode=##class(Common).CompileSchema(tRight)
			
			Set tLTypeCode=tLNode.TypeCode()
			Set tRTypeCode=tRNode.TypeCode()
			
			// if they are of the same type and not leaves ..
			If tLTypeCode=tRTypeCode,tLTypeCode'="" {
				
				// if they are repeat/optional ..
				If "RO"[tLTypeCode {
					Set tLeftInside=$Extract(tLeft,2,*-1)
					Set tRightInside=$Extract(tRight,2,*-1)
					Write tLeftInside," ~~ ",tRightInside,!
					Set tRet=##class(ComparePatterns).%New(tLeftInside,tRightInside).Compare()
					If tRet'="" {						
						Do ..ListChanges(tRet)
					}
				}
				
				// .. if they are lists ..
				ElseIf tLTypeCode="L" {
					Do ..CrossCompareListPatterns(tLNode,tRNode)
				}
			}
		
			// advance the pointers
			Set tLP=tNewLP,tRP=tNewRP
		}
	}
			
	Quit tOut
}

ClassMethod CrossCompareListPatterns(pLNode As Base, pRNode As Base) [ Private ]
{
	Kill tLChildReprs
	Do ..GetListReprs(pLNode,.tLChildReprs)
	Kill tRChildReprs
	Do ..GetListReprs(pRNode,.tRChildReprs)
	
	Do ..CrossComparePatterns(1,$Get(tLChildReprs),1,$Get(tRChildReprs),.tLChildReprs,.tRChildReprs)
}

ClassMethod GetListReprs(pNode As Base, Output pChildReprs) [ Private ]
{
	$$$SHOULDBEUNDEF(pChildReprs)
	
	Kill tChildren
	Do pNode.GetChildren(.tChildren)
	
	For tI=1:1:$Get(tChildren) {
		Set pChildReprs(tI)=tChildren(tI).Pattern()
	}
	Set pChildReprs=$Get(tChildren)
}

ClassMethod CrossComparePatterns(pStartLP As %Integer, pEndLP As %Integer, pStartRP As %Integer, pEndRP As %Integer, ByRef pLTopChildReprs, ByRef pRTopChildReprs) [ Private ]
{
			

	BREAK
	
	Kill tCompare
	For tL=pStartLP:1:pEndLP {
		Set tLeft=pLTopChildReprs(tL)
		If tLeft'?.AN {
			For tR=pStartRP:1:pEndRP {
				Set tRight=pRTopChildReprs(tR)
				If tRight'?.AN {
					Set tCompare(tL,tR)=$ListBuild(tLeft,tRight,##class(ComparePatterns).%New(tLeft,tRight).Compare())
				}
			}
		}
	}
	
	ZWrite tCompare
}

ClassMethod CrossCompareBases(pStartLP As %Integer, pEndLP As %Integer, pStartRP As %Integer, pEndRP As %Integer, ByRef pLTopChildReprs, ByRef pRTopChildReprs) [ Private ]
{
			
	// get all bases
	Kill tLBases
	For tL=pStartLP:1:pEndLP {
		Kill tBasis
		Do ##class(PatternUtils).BasisNoEmpty(pLTopChildReprs(tL),.tBasis)
		Merge tLBases(tL)=tBasis
	}			 
	Kill tRBases
	For tR=pStartRP:1:pEndRP {
		Kill tBasis
		Do ##class(PatternUtils).BasisNoEmpty(pRTopChildReprs(tR),.tBasis)
		Merge tRBases(tR)=tBasis
	}
	
	// compare all pairs of bases
	For tL=pStartLP:1:pEndLP {
		Kill tLBasis
		Merge tLBasis=tLBases(tL)
		For tR=pStartRP:1:pEndRP {
			Kill tRBasis
			Merge tRBasis=tRBases(tR)
			Set tRet=..CompareBases(.tLBasis,.tRBasis)
			Write "-",!
			Write " ",tL,": ",pLTopChildReprs(tL),!
			Write " ",tR,": ",pRTopChildReprs(tR),!
			Write " - ",$Case(tRet,-1:"<<",+1:">>",0:"==",:"##"),!
			
		}
	}
}

/// Returns $LB(NEWLP,NEWRP) except at the end of the comparison when "" is returned
Method ExtractChunk(ByRef pLTopChildReprs, pLP As %Integer, ByRef pRTopChildReprs, pRP As %Integer) As %List [ Private ]
{
	// if there's a common prefix: return it
	Set tRet=..CommonPrefix(.pLTopChildReprs,pLP,.pRTopChildReprs,pRP)
	If tRet'="" {
		Quit tRet
	}
	
	// return a mismatch
	Quit ..MismatchingChunk(.pLTopChildReprs,pLP,.pRTopChildReprs,pRP)
}

/// Returns $LB(NEWLP,NEWRP) unless there is no common prefix when "" is returned
Method CommonPrefix(ByRef pLTopChildReprs, pLP As %Integer, ByRef pRTopChildReprs, pRP As %Integer) As %List [ Private ]
{
	Set tCommonPrefix=""
	Set tNewLP=pLP
	Set tNewRP=pRP
	While tNewLP<=pLTopChildReprs, tNewRP<=pRTopChildReprs, pLTopChildReprs(tNewLP)=pRTopChildReprs(tNewRP) {
		Set tNewLP=tNewLP+1
		Set tNewRP=tNewRP+1
	}
	
	If tNewLP=pLP {
		Quit ""
	}
	
	Quit $ListBuild(tNewLP,tNewRP)
}

/// Returns $LB(NEWLP,NEWRP) unless both scans are finished, in which case "" is returned
Method MismatchingChunk(ByRef pLTopChildReprs, pLP As %Integer, ByRef pRTopChildReprs, pRP As %Integer) As %List [ Private ]
{
	Set tLEnded=pLP>pLTopChildReprs
	Set tREnded=pRP>pRTopChildReprs
	
	If tLEnded, tREnded {
		//w "both ended",!
		Quit "" // both pointers ended => ""
	}
	
	If tLEnded {
		//w "left ended",!
		Quit $ListBuild(pLP,pRTopChildReprs+1) // left ended => rest of right
	}
	
	If tREnded {
		//w "right ended",!
		Quit $ListBuild(pLTopChildReprs+1,pRP) // right ended => rest of left
	}

	Set tNextLPInR=..IndexOf(.pRTopChildReprs,pLTopChildReprs(pLP),pRP+1)
	Set tNextRPInL=..IndexOf(.pLTopChildReprs,pRTopChildReprs(pRP),pLP+1)
	
	If 'tNextLPInR, 'tNextRPInL {
		//w "neither current in other string",!		
		Quit $ListBuild(pLP+1,pRP+1) // // neither current character occurs later in the other string => the rest of both strings
		// TODO skip current item in both 
	}
	
	If tNextLPInR, 'tNextRPInL {
		//w "left current is in right",!
		Quit $ListBuild(pLP,tNextLPInR) // left current character occurs later in right => catch up in right 
	}
	
	If 'tNextLPInR, tNextRPInL {
		//w "right current is in left",!
		Quit $ListBuild(tNextRPInL,pRP) // right current character occurs later in left => catch up in left
	}
	
	If (tNextLPInR-pRP) < (tNextRPInL-pLP) {
		//w "left current is first in right",!
		Quit $ListBuild(pLP,tNextLPInR) // distance to left current character in right comes first => catch up in right
	}
	
	//w "right current is first or equidistant in left",!
	Quit $ListBuild(tNextRPInL,pRP) // distance to right current character in left comes first or at the same distance => catch up in left
}

ClassMethod IndexOf(ByRef pReprArray, pRepr As %String, pStartIndex As %Integer = 1) [ Private ]
{
	Set tP=pStartIndex
	While tP<=pReprArray, pReprArray(tP)'=pRepr {
		Set tP=tP+1
	}
	
	Quit $Select(tP>pReprArray:0,1:tP)
}

ClassMethod NodesRepr(ByRef pChildReprs, pStartIndex As %Integer, pEndIndex As %Integer) As %String [ Private ]
{
	Set tOut=""
	For tI=pStartIndex:1:pEndIndex {
		Set tOut=tOut_$ListBuild(pChildReprs(tI))
	}
	
	Quit $ListToString(tOut)
}

ClassMethod GetChildReprs(pNode As Base, Output pChildNodes, Output pChildReprs) [ Private ]
{
	$$$SHOULDBEUNDEF(pChildReprs)
	$$$SHOULDBEUNDEF(pChildNodes)
	
	Do pNode.GetChildren(.pChildNodes)
	
	For tI=1:1:$Get(pChildNodes) {
		Set pChildReprs(tI)=pChildNodes(tI).Pattern()
	}
	Set pChildReprs=$Get(pChildNodes)
}

ClassMethod Test()
{
	While 1 {
	
		Read "Left  pattern:",tLPattern,! If tLPattern="" {Quit}
		Read "Right pattern:",tRPattern,! If tRPattern="" {Quit}
		
		Set tComparePatterns=##class(ComparePatterns).%New(tLPattern,tRPattern)
		Set tRet=tComparePatterns.Compare()
		
		Do ..ListChanges(tRet)
	}
}

ClassMethod ListChanges(pRet As %List) [ Private ]
{
			
	Write "Compare:",!
	Set tPtr=0 While $ListNext(pRet,tPtr,tChunk) {
	
		Set $ListBuild(tLeft,tRight)=tChunk
		
		If tLeft="" {
			Write " INS ",tRight,!
		}
		ElseIf tRight="" {
			Write " DEL ",tLeft,!
		}
		Else {
			If tLeft=tRight {
				Write " EQL ",tLeft,!
			}
			Else {
				Write " CHG ",tLeft," ~~ ",tRight,!
			}
		}
	}
}

/// Returns: 0=>same, +1=>pBasis1 is a superset of pBasis2, -1=>pBasis1 is a subset of pBasis2, "" => none of the preceding
ClassMethod CompareBases(ByRef pBasis1, ByRef pBasis2) As %Integer [ Private ]
{
	Kill tOnly1
	Kill tOnly2 Merge tOnly2=pBasis2
	Kill tBoth
	Set tKey1="" While 1 {
		
		Set tKey1=$Order(pBasis1(tKey1)) If tKey1="" {Quit}
		
		If $Data(pBasis2(tKey1)) {
			Set tBoth(tKey1)=""
			Kill tOnly2(tKey1)
		}
		Else {
			Set tOnly1(tKey1)=""
		}
	}
	
	Set tAny1=$Data(tOnly1)\10
	Set tAny2=$Data(tOnly2)\10
	Set tAnyBoth=$Data(tBoth)\10
	
	If 'tAny1,'tAny2 {Quit 0} // identical
	ElseIf 'tAny1 {Quit -1} // #1 subset of #2
	ElseIf 'tAny2 {Quit +1} // #1 superset of #2
	Else {Quit ""} // none of the above
}

}
