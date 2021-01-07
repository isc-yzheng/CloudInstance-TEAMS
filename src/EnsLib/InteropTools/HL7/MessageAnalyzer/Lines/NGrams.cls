/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

/// Basic NGram determination, used by the CompressNGrams wrapper class 
Class EnsLib.InteropTools.HL7.MessageAnalyzer.Lines.NGrams
{

/// Given a list of names note any ngrams as pNGrams(NGRAMLIST)="" where NGRAMLIST is a string of comma-separated names
ClassMethod FindNGrams(pItemList As %List, ByRef pNGrams)
{
	$$$ACASSERT(pItemList'="","FindNGrams: invalid argument - empty list")
	
	// create an array of items with a cross-reference to it
	Kill tArr // tArr(1..*)=ITEM
	Kill tXref // tXref(ITEM,INDEX)=""
	Set tIndex=1
	Set tPtr=0 While $ListNext(pItemList,tPtr,tElem) {
		Set tArr($I(tArr))=tElem
		Set tXref(tElem,tIndex)=""
		Set tIndex=tIndex+1
	}
	
	// the index into tArr starts at 1 and runs up to tArr-3 because we're not interested in shorted runs
	Set tIndex=1
	While tIndex <= (tArr-3) {
	
		Set tItem=tArr(tIndex)
		
		// if the item appears later in tArr ..
		If $Order(tXref(tItem,tIndex))'="" {
		
			// if a run is present: return the index following it in tNextIndex, otherwise return 0
			Set tNextIndex=..FindRuns(tItem,tIndex,.tArr,.tXref,.tRunLength)
			
			// if there is a run ..
			If tNextIndex {			
			
				// note it
				Set pNGrams($ListToString($List(pItemList,tIndex,tIndex+tRunLength-1)))=""
				
				// move after it		
				Set tIndex=tNextIndex
			}
			
			// .. no run ..
			Else {
			
				// just go on to the following item in tArr
				Set tIndex=tIndex+1
			}
		}
		
		// .. item doesn't appear again ..
		Else {		
		
			// just go on to the following item in tArr
			Set tIndex=tIndex+1
		}
	}
}

/// Remove (from pNGrams) any ngrams which are contained in larger  ngrams
ClassMethod RemoveCompoundNGrams(ByRef pNGrams)
{
	Set tK="" While 1 {
	
		Set tK=$Order(pNGrams(tK)) If tK="" {Quit}

		Set tL=tK While 1 {

			Set tL=$Order(pNGrams(tL)) If tL="" {Quit}

			Set tRet=..CompareCSV(tK,tL)
			
			// tK has tL as a sublist ..
			If tRet=+1 {
				Kill pNGrams(tL)
				// carry on around the tL loop
			}
			
			// .. tL has tK as a sublist ..
			ElseIf tRet=-1 {
				Kill pNGrams(tK)
				Quit
			}
		}
	}
}

/// Like $ListFromString but takes account of {...} where the '...' includes commas
ClassMethod ListFromStringWithRepeats(pString As %String) As %List
{
	// optimization: if there are no {...} then just use plain $ListFromString
	If pString'["{" {
		Quit $ListFromString(pString)
	}
	
	// scan the string and build tOut with the $List
	Set tLen=$Length(pString)
	Set tOut=""
	Set tPos=1
	Do {
	
		// find "{" at or after the current index
		Set tPosOpen=##class(Common).IndexOf(pString,"{",tPos)
		If 'tPosOpen {
		
			// no "{" so add the rest of the string to the output list and quit the loop
			Set tOut=tOut_..ListFromStringTrimCommas($Extract(pString,tPos,*))
			Quit
		}
		
		// add up to before the "{" to the output
		Set tOut=tOut_..ListFromStringTrimCommas($Extract(pString,tPos,tPosOpen-1))
		
		// find "}"
		Set tPosClose=##class(Common).IndexOf(pString,"}",tPosOpen+1)
		If 'tPosClose {ZTrap}
		
		// add {XXX} to the output
		Set tInside=$Extract(pString,tPosOpen+1,tPosClose-1)
		Set tOut=tOut_$ListBuild("{"_tInside_"}")
		
		// continue from after the "}"
		Set tPos=tPosClose+1
		
	} While tPos<=tLen
	
	Quit tOut
}

/// Returns index after runs, or 0 if no run found
ClassMethod FindRuns(pItem As %String, pIndex As %Integer, ByRef pArr, ByRef pXref, Output pRunLength As %Integer) As %Integer [ Private ]
{
	// the index of the next occurrence of pItem after pIndex
	Set tItemIndex=$Order(pXref(pItem,pIndex))
	
	// the length of the run (the first run)
	Set pRunLength=tItemIndex-pIndex
	
	// if the first run is just pItem OR if there isn't a following run (the second run) ..
	If (pRunLength<2) || '..FindOneRun(pIndex,pRunLength,tItemIndex,.pArr) {
	
		// return 'no run found'
		Quit 0
	}
	
	// scan for runs following the second run
	While 1 {
	
		// the item index after this run
		Set tNextItemIndex=$Order(pXref(pItem,tItemIndex))
		If tNextItemIndex'=(tItemIndex+pRunLength) { // covers case of tNextItemIndex="" too
			Quit  // quit the loop
		}
		
		// see if it's a run
		If '..FindOneRun(pIndex,pRunLength,tNextItemIndex,.pArr) {
			Quit  // quit the loop
		}
		
		Set tItemIndex=tNextItemIndex
	}
		
	Quit tItemIndex+pRunLength
}

/// See if the run at pItemIndex matches the items at pIndex
ClassMethod FindOneRun(pIndex As %Integer, pRunLength As %Integer, pItemIndex As %Integer, ByRef pArr) As %Boolean [ Private ]
{
	If (pItemIndex+(pRunLength-1)) > pArr {
		Quit 0
	}
	
	For tI=1:1:pRunLength-1 {
		If pArr(pItemIndex+tI)'=pArr(pIndex+tI) {
			Return 0
		}
	}

	Quit 1
}

/// Return -1 if pCSV1 <: pCSV2, +1 if pCSV1 >: pCSV2, 0 otherwise
/// <p> the '<:' above means "is sublist of"; the ':>' means "has as a sublist"
ClassMethod CompareCSV(pCSV1 As %String, pCSV2 As %String) As %Integer [ Private ]
{
	// in the tests below we double up the containing list to detect cyclic shifts
	
	If $Length(pCSV1)<$Length(pCSV2) {
		Quit (pCSV2_","_pCSV2)[pCSV1 // TODO would a loop be faster?
	}
	
	Else {
		Quit (pCSV1_","_pCSV1)[pCSV2 // TODO would a loop be faster?
	}
}

/// Like $ListFromString but a comma at the beginning or end of the string is first removed
ClassMethod ListFromStringTrimCommas(pString As %String) As %List [ Private ]
{
	Set tStart=$Select($Extract(pString)=",":2,1:1)
	Set tEndDecr=$Select($Extract(pString,*)=",":1,1:0)
	Quit $ListFromString($Extract(pString,tStart,*-tEndDecr))
}

}
