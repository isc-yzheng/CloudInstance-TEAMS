/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

/// Simple character comparison
Class EnsLib.InteropTools.HL7.MessageAnalyzer.Common.ComparePatternsByChar Extends %RegisteredObject
{

Property LPattern As %String [ Private ];

Property RPattern As %String [ Private ];

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

Method %OnNew(pLPattern As %String, pRPattern As %String) As %Status
{
	Set ..LPattern=pLPattern
	Set ..RPattern=pRPattern
	Quit $$$OK
}

/// Returns a $List of $Lists
/// <p> Each entry of the outer list takes the form $LB(LEFT,RIGHT)
Method Compare() As %List
{
	Set tOut=""
	Set (tLP,tRP)=1
	While 1 {
	
		// extract a segment
		Set tRet=..ExtractSegment(tLP,tRP)
		If tRet="" {
			Quit  // quit the loop
		}
		
		// the new pointers
		Set $ListBuild(tNewLP,tNewRP)=tRet
		$$$ACASSERT((tNewLP'=tLP)||(tNewRP'=tRP),"compare: no movement")
		
		// extract the left and right parts of the segment
		Set tLeft=$Extract(..LPattern,tLP,tNewLP-1)
		Set tRight=$Extract(..RPattern,tRP,tNewRP-1)
				
		// append the segment to the output
		Set tOut=tOut_$ListBuild($ListBuild(tLeft,tRight))
		
		// advance the pointers
		Set tLP=tNewLP,tRP=tNewRP
	}
	
	Quit tOut
}

ClassMethod ListChanges(pRet As %List)
{
			
	Write "Compare:",!
	Set tPtr=0 While $ListNext(pRet,tPtr,tSegment) {
	
		Set $ListBuild(tLeft,tRight)=tSegment
		
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

/// Returns $LB(NEWLP,NEWRP) except at the end of the comparison when "" is returned
Method ExtractSegment(pLP As %Integer, pRP As %Integer) As %List [ Private ]
{
	// if there's a common prefix: return it
	Set tRet=..CommonPrefix(pLP,pRP)
	If tRet'="" {
		Quit tRet
	}
	
	// return a mismatch
	Quit ..MismatchingSegment(pLP,pRP)
}

/// Returns $LB(NEWLP,NEWRP) unless there is no common prefix when "" is returned
Method CommonPrefix(pLP As %Integer, pRP As %Integer) As %List [ Private ]
{
	Set tCommonPrefix=""
	Set tNewLP=pLP
	Set tNewRP=pRP
	While tNewLP<=$Length(..LPattern), tNewRP<=$Length(..RPattern), $Extract(..LPattern,tNewLP)=$Extract(..RPattern,tNewRP) {
		Set tNewLP=tNewLP+1
		Set tNewRP=tNewRP+1
	}
	
	If tNewLP=pLP {
		Quit ""
	}
	
	Quit $ListBuild(tNewLP,tNewRP)
}

/// Returns $LB(NEWLP,NEWRP) unless both scans are finished when "" is returned
Method MismatchingSegment(pLP As %Integer, pRP As %Integer) As %List [ Private ]
{
	Set tLEnded=pLP>$Length(..LPattern)
	Set tREnded=pRP>$Length(..RPattern)
	
	If tLEnded, tREnded {
		//w "both ended",!
		Quit "" // both pointers ended => ""
	}
	
	If tLEnded {
		//w "left ended",!
		Quit $ListBuild(pLP,$Length(..RPattern)+1) // left ended => rest of right
	}
	
	If tREnded {
		//w "right ended",!
		Quit $ListBuild($Length(..LPattern)+1,pRP) // right ended => rest of left
	}
	
	Set tNextLPInR=##class(Common).IndexOf(..RPattern,$Extract(..LPattern,pLP),pRP+1)
	Set tNextRPInL=##class(Common).IndexOf(..LPattern,$Extract(..RPattern,pRP),pLP+1)
	
	If 'tNextLPInR, 'tNextRPInL {
		//w "neither current in other string",!
		Quit $ListBuild($Length(..LPattern)+1,$Length(..RPattern)+1) // // neither current character occurs later in the other string => the rest of both strings
		// TODO just skip either until a match is found 
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

}
