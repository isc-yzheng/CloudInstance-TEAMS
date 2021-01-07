/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Lines.CompressRepeats
{

/// Find any repeated occurrences of any name in the pLinesSymbols lines and replace them with symbols
ClassMethod Compress(pLinesSymbols As LinesSymbols)
{
	// copy lines to a working local
	Set tLines=pLinesSymbols.GetLines()

	// find repeated symbols and encode as "{..}" in tOut
	Set tEncoded=..FindRepeats(tLines)
	
	// encode repeats ("{..}") as symbols
	Set tReplaced=..RepeatsToSymbols(tEncoded,pLinesSymbols)
	
	// update pLinesSymbols with our changes
	Do pLinesSymbols.SetLines(tReplaced)
}

/// Find any repeated occurrences of any name in pLines and replace them with symbols
ClassMethod FindRepeats(pOldLines As %List) As %List [ Private ]
{
	// for each line: find repeated names
	Set tOut=""
	Set tPtrI=0 While $ListNext(pOldLines,tPtrI,tElemI) {

		// for each name in the line ..
		Set tLineOut=""
		Set tCurrent=""
		Set tPtrJ=0 While $ListNext(tElemI,tPtrJ,tElemJ) {
		
			// if this name matches the previous one ..
			If tElemJ=tCurrent {
				Set tRepeated=1
			}
			
			// .. doesn't match previous ..
			Else {
			
				// flush the current name
				If tCurrent'="" {
					Set tLineOut=tLineOut_$ListBuild($Select(tRepeated:"{"_tCurrent_"}",1:tCurrent))
				}
				
				// new current name, not (yet) repeated
				Set tCurrent=tElemJ
				Set tRepeated=0
			}
		}

		// flush the current name
		If tCurrent'="" {
			Set tLineOut=tLineOut_$ListBuild($Select(tRepeated:"{"_tCurrent_"}",1:tCurrent))
		}
		
		// add the new line to the new list of lines
		Set tOut=tOut_$ListBuild(tLineOut)
	}
	
	Quit tOut
}

/// For each {..} entry in pOldLines: create a symbol for the entry if necessary and replace the entry with the symbol
ClassMethod RepeatsToSymbols(pOldLines As %List, pLinesSymbols As LinesSymbols) As %List [ Private ]
{
	// for each line ..
	Set tNewLines=""
	Set tPtrI=0 While $ListNext(pOldLines,tPtrI,tLine) {

		// if there are ANY {..} entries in this line (this guard is an optimization) ..
		If $ListToString(tLine)["{" {

			// for each entry in the line ..
			Set tNewOneLine=""
			Set tPtrJ=0 While $ListNext(tLine,tPtrJ,tMessageSegmentType) {
			
				// if this entry begins with "{" ..
				If $Extract(tMessageSegmentType)="{" {
				
					// get a symbol for the name and write the symbol to the new line
					Set tSymbol=pLinesSymbols.SymbolForValue(tMessageSegmentType)
					Set tNewOneLine=tNewOneLine_$ListBuild(tSymbol)
				}
				Else {
				
					// write the unchanged entry to the new line
					Set tNewOneLine=tNewOneLine_$ListBuild(tMessageSegmentType)
				}
			}
			
			// add the new line to the new list of lines
			Set tNewLines=tNewLines_$ListBuild(tNewOneLine)
		}
		
		// .. NO {..} entries in this line ..
		Else {
		
			// add the unchanged line to the new list of lines
			Set tNewLines=tNewLines_$ListBuild(tLine)
		}
	}
	
	Quit tNewLines
}

}
