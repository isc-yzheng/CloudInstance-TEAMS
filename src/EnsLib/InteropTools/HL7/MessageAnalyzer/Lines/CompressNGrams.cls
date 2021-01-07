/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Lines.CompressNGrams
{

/// Find any repeating groups in ..Lines and replace them with symbols
ClassMethod Compress(pLinesSymbols As LinesSymbols)
{
	Set tLines=pLinesSymbols.GetLines()
	
	// Find ngrams in each record
	Kill tNGrams
	Set tPtrI=0 While $ListNext(tLines,tPtrI,tElemI) {
		Do ##class(NGrams).FindNGrams(tElemI,.tNGrams)
	}
	
	// no ngrams => nothing to do
	If '($Data(tNGrams)\10) {
		Quit
	}
	
	// remove any ngrams containing shorter ngrams
	Do ##class(NGrams).RemoveCompoundNGrams(.tNGrams) 
	
	// assign symbols to ngrams
	Kill tSymbols
	Set tK="" While 1 {
		Set tK=$Order(tNGrams(tK)) If tK="" {Quit}
		Set tSymbols(tK)=pLinesSymbols.SymbolForValue("{"_tK_"}")
	}
	
	// Replace ngrams in each record with symbols
	Set tOut=..NGramsToSymbols(tLines,.tNGrams,.tSymbols)
		
	// update pLinesSymbols with our changes
	Do pLinesSymbols.SetLines(tOut)
}

/// Replace ngrams in each record with symbols
ClassMethod NGramsToSymbols(pLines As %List, ByRef pNGrams, ByRef pSymbols) As %List [ Private ]
{
	Set tOut=""
	Set tPtr=0 While $ListNext(pLines,tPtr,tElem) {
	
		Set tRecord=$ListToString(tElem)
		Set tK="" While 1 {
			Set tK=$Order(pNGrams(tK)) If tK="" {Quit}
			Set tKLen=$Length(tK)
			Set tKSymbol=pSymbols(tK)
			Set tStart=1
			While 1 {
				Set tOffset=##class(Common).IndexOf(tRecord,tK,tStart)
				If 'tOffset {
					Quit
				}
				
				Set tP=tOffset+tKLen+1
				Set tRecordLen=$Length(tRecord)
				
				While tP<tRecordLen,$Extract(tRecord,tP,tP+tKLen-1)=tK {
					Set tP=tP+tKLen+1
				}

				Set tReplacement=tKSymbol
				
				Set $Extract(tRecord,tOffset,tP-2)=tReplacement				
				Set tStart=tOffset+$Length(tReplacement)
			}
		}
		
#if 0
		Set tOldRecord=$ListToString(tElem)
		If tRecord'=tOldRecord {
			Write "CHANGED: ",!
			Write " ",tOldRecord,!
			Write " ",tRecord,!
		}
#endif
		
		Set tOut=tOut_$ListBuild($ListFromString(tRecord))
	}
	
	Quit tOut
}

}
