/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Lines.CompressMultiGrams
{

/// Find any multigrams in ..Lines and replace them with symbols
ClassMethod Compress(pLinesSymbols As LinesSymbols)
{
	Set tLines=pLinesSymbols.GetLines()
	
	// convert lines to array
	Kill tMessageArray
	Do ..ListOfListsToMessageArray(tLines,.tMessageArray)
	
	// process array
	Do ..AnalyzeMultiGrams(.tMessageArray,pLinesSymbols)		
	
	// convert message array to a list of lists
	Set tLines=..MessageArrayToListOfLists(.tMessageArray)
	
	// update pLinesSymbols with our changes
	Do pLinesSymbols.SetLines(tLines)
}

/// NOTE: patches pMessageArray directly
ClassMethod AnalyzeMultiGrams(ByRef pMessageArray, pLinesSymbols As LinesSymbols) [ Private ]
{
	$$$ACASSERT($Data(pMessageArray)\10,"AnalyzeMultiGrams: no messages given")
	
	// find the number of occurrences of each segment in any one message
	Kill tOccCount // tOccCount(SEG,SEGLISTHASH)=COUNT (in that message)	
	Set tSegListHash="" While 1 {		
		Set tSegListHash=$Order(pMessageArray(tSegListHash),+1,tSegList) If tSegListHash="" {Quit}
		Set tPtr=0 While $ListNext(tSegList,tPtr,tSegment) {
			If $I(tOccCount(tSegment,tSegListHash))
		}
	}
	
	// order by the counts
	Kill tOccSegMessage // tOccSegMessage(COUNT,SEG,SEGLISTHASH)=""
	Set tSegment="" While 1 {	
		Set tSegment=$Order(tOccCount(tSegment)) If tSegment="" {Quit}		
		Set tSegListHash="" While 1 {		
			Set tSegListHash=$Order(tOccCount(tSegment,tSegListHash),+1,tCountSM) If tSegListHash="" {Quit}			
			Set tOccSegMessage(tCountSM,tSegment,tSegListHash)=""
		}
	}
	
	// use the FIRST such segment - we can do another pass if necessary
	Set tSeedSegment=..SeedSegment(.tOccCount,.tOccSegMessage)
	If tSeedSegment'="" {
	
		// copy the message array message-type subnodes to an array of unprocessed hashes
		Kill tUnprocessed // tUnprocessed(SEGLISTHASH)=SEGLIST - exists if the message has not been processed
		Merge tUnprocessed=pMessageArray
			
		Kill tStrips // tStrips(SEGLISTHASH)=$LB(POSSTART,POSEND)
		Kill tTodo // tTodo(SEGMENT)="" if SEGMENT appears in any strip
		
		// kick it off with the seed segment
		Set tTodo(tSeedSegment)=""
		
		// as long as there are unprocessed messages and unscanned segments	
		Kill tScannedSegments // tScannedSegments(SEGMENT)="" if SEGMENT has been scanned
		While $Data(tUnprocessed)\10, $Data(tTodo)\10 {
		
			Set tSegment=$Order(tTodo(""))
			Kill tTodo(tSegment)
			Set tScannedSegments(tSegment)=""
			
			Do ..ScanMessages(.tUnprocessed,tSegment,.tStrips,.tTodo,.tScannedSegments)		
		}
		
		// now extend each strip left and right by any scanned segments
		Set tSegListHash="" While 1 {
			Set tSegListHash=$Order(tStrips(tSegListHash),+1,tRet) If tSegListHash="" {Quit}
			Set tSegList=pMessageArray(tSegListHash)
			Set tNewExtent=..ExtendStrip(tRet,tSegList,.tScannedSegments)
			Set tStrips(tSegListHash)=tNewExtent
		}
					
		// patch messages by replacing strips with a symbol
		Set tPattern=..SegmentPattern(.tScannedSegments)
		Set tSymbol=pLinesSymbols.SymbolForValue(tPattern)
		Set tWrappedSymbol=$ListBuild(tSymbol)
		Set tSegListHash="" While 1 {
			Set tSegListHash=$Order(tStrips(tSegListHash),+1,tRet) If tSegListHash="" {Quit}
			Set $ListBuild(tStartPos,tEndPos)=tRet
			Set $List(pMessageArray(tSegListHash),tStartPos,tEndPos)=tWrappedSymbol
		}
	}
}

ClassMethod ScanMessages(ByRef pUnprocessed, pSegment As %String, ByRef pStrips, ByRef pTodo, ByRef pScannedSegments) [ Private ]
{
	// find all the strips containing the given segment
	Set tSegListHash="" While 1 {
		
		Set tSegListHash=$Order(pUnprocessed(tSegListHash),+1,tSegList) If tSegListHash="" {Quit}

		Set tRet=..MessageStrip(tSegList,pSegment,.pTodo,.pScannedSegments)
		If tRet'="" {
			Set pStrips(tSegListHash)=tRet			
			Kill pUnprocessed(tSegListHash)	
		}
	}
}

/// Returns $LB(STARTPOS,ENDPOS) or "" if no strip found; pSegsUsed(SEGMENT) is set for each segment name used in the strip
ClassMethod MessageStrip(pSegList As %List, pSegment As %String, ByRef pTodo, ByRef pScannedSegments) As %List [ Private ]
{
	// the first occurrence of the segment in the seglist
	Set tPosFirst=$ListFind(pSegList,pSegment)
	If tPosFirst=0 {
		Quit "" // - not found, so no strip
	}
	
	Set tPosLast=$$findlast(pSegList,pSegment)
	ZTrap:tPosLast=0  // we should at least find the first occurrence! 
	
	// find all the other segment types between the the first and last occurrence of the segment
	For tI=tPosFirst+1:1:tPosLast-1 {
		Set tItem=$List(pSegList,tI)
		If '$Data(pScannedSegments(tItem)) {
			Set pTodo(tItem)=""
		}
	}
	
	// return the strip
	Quit $ListBuild(tPosFirst,tPosLast)
		
	
findlast(list,item)
	
	For i=$ListLength(list):-1:1 {
		If $List(list,i)=item {
			Return i
		}
	}
	
	Quit 0
}

/// Given pExtent ($LB(STARTPOS,ENDPOS)), a message segment list and an array of scanned segments
/// <p> Return an updated extent
ClassMethod ExtendStrip(pExtent As %List, pSegList As %List, ByRef pScannedSegments) As %List [ Private ]
{
	
	Set $ListBuild(tPosStart,tPosEnd)=pExtent
	
	Set tP=tPosStart-1
	While tP>=1,$Data(pScannedSegments($List(pSegList,tP))) {
		Set tP=tP-1
	}
	Set tNewPosStart=tP+1
	
	Set tP=tPosEnd+1
	While tP<=$ListLength(pSegList),$Data(pScannedSegments($List(pSegList,tP))) {
		Set tP=tP+1
	}
	Set tNewPosEnd=tP-1
	
	Quit $ListBuild(tNewPosStart,tNewPosEnd)
}

ClassMethod SegmentPattern(ByRef pScannedSegments) As %String [ Private ]
{
	$$$ACASSERT($Data(pScannedSegments)\10,"SegmentPattern: no segments passed")
	
	Set tFirstKey=$Order(pScannedSegments(""))
	Set tSecondKey=$Order(pScannedSegments(tFirstKey))
	If tSecondKey="" {
		Set tOpen="",tClose=""
	}
	Else {
		Set tOpen="[",tClose="]"
	}
	
	Set tOut=""
	Set tSegment="" While 1 {
		Set tSegment=$Order(pScannedSegments(tSegment)) If tSegment="" {Quit}
		Set tOut=tOut_$ListBuild(tOpen_tSegment_tClose)
	}
	
	Quit "{"_$ListToString(tOut,",")_"}"
}

ClassMethod ListOfListsToMessageArray(pLines As %List, Output pMessageArray) [ Private ]
{
	$$$SHOULDBEUNDEF(pMessageArray)
	
	Set tPtr=0 While $ListNext(pLines,tPtr,tMessage) {
		Set pMessageArray(##class(Common).RawHash(tMessage))=tMessage
	}
}

ClassMethod MessageArrayToListOfLists(ByRef pMessageArray) As %List [ Private ]
{
	Set tOut=""
	Set tSegListHash="" While 1 {
		Set tSegListHash=$Order(pMessageArray(tSegListHash),+1,tMessage) If tSegListHash="" {Quit}
		Set tOut=tOut_$ListBuild(tMessage)
	}
	
	Quit tOut
}

ClassMethod SeedSegment(ByRef pOccCount, ByRef pOccSegMessage) As %String [ Private ]
{
	// scan the counts (highest first)
	Set tCount="" While 1 {

		Set tCount=$Order(pOccSegMessage(tCount),-1) If tCount="" {Quit}
		If tCount<3 {Quit}
		
		// scan the segments with that count
		Set tSegment="" While 1 {
		
			Set tSegment=$Order(pOccSegMessage(tCount,tSegment)) If tSegment="" {Quit}
			
			// if the segment appears in at least 2 messages ..
			Set tFirstSegListHash=$Order(pOccCount(tSegment,""))
			ZTrap:tFirstSegListHash=""
			If $Order(pOccCount(tSegment,tFirstSegListHash))'="" {
				Return tSegment
			}
		}
	}
	
	Quit ""
}

}
