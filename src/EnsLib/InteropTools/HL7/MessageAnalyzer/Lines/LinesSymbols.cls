/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging, EnsLib.InteropTools.HL7.MessageAnalyzer.Derive)

Include EnsLib.InteropTools.HL7.MessageAnalyzer.DeriveTask

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Lines.LinesSymbols Extends %RegisteredObject
{

/// Each element of Lines is a $List of message segment types - e.g. ..Lines=$LB($LB("MSH","PID","NTE"),$LB("MSH","ZAL","AL1"),..)
Property Lines As %List [ Private ];

/// Each entry represents a symbol ZZZnnn where the 'nnn' is the index in this list padded with leading zeroes
/// <p> For example, the symbol for the 23'rd entry would be "ZZZ023"
/// <p> The value at an entry is the pattern text to substitute for the symbol
/// <p> ..Symbols is the count
Property Symbols As %String [ MultiDimensional, Private ];

/// Back-references from values in Symbols to the symbol name
/// <p> For example, if ..Symbols(23)="{OBX}" then ..SymbolValues("{OBX}")=23
Property SymbolValues As %Integer [ MultiDimensional, Private ];

Method %OnNew(pLines As %List) As %Status
{
	Set ..Lines=pLines	
	Set ..Symbols=0
	Quit $$$OK
}

Method Clone() As LinesSymbols
{
	Set tNewLinesSymbols=##class(LinesSymbols).%New(..Lines)
	Merge tNewLinesSymbols.Symbols=..Symbols
	Merge tNewLinesSymbols.SymbolValues=..SymbolValues
	
	Quit tNewLinesSymbols
}

/// Remove any duplicate lines - do this after all symbol-creating operations for best results
Method MakeLinesUnique()
{
	Set tLines=..Lines

	// copy a hash for each line to an array
	Kill tSeen
	Set tPtrI=0 While $ListNext(tLines,tPtrI,tElemI) {
		Set tRawHash=##class(Common).RawHash(tElemI)
		Set tSeen(tRawHash)=tElemI
	}
	
	// construct a list from the array data
	Set tOut=""
	Set tRawHash="" While 1 {
		Set tRawHash=$Order(tSeen(tRawHash),+1,tData) If tRawHash="" {Quit}
		Set tOut=tOut_$ListBuild(tData)
	}
	
	Set ..Lines=tOut
}

/// Return the lines in their symbol form, as a $List of CSV strings
Method SymbolicLinesCSV() As %List
{
	Set tOut=""
	Set tPtr=0 While $ListNext(..Lines,tPtr,tLine) {
		Set tOut=tOut_$ListBuild($ListToString(tLine))
	}
	
	Quit tOut
}

/// Return the lines in their symbol form, as a $List of $List of message segment types (and symbol names)
Method GetLines() As %List [ CodeMode = expression ]
{
..Lines
}

/// Update ..Lines from a $List of $List of message segment types (and symbol names)
Method SetLines(pLines As %List)
{
	Set ..Lines=pLines
}

/// Return the given pattern string with any symbol references replaced by their values
Method SubstituteSymbolsIn(pPattern As %String) As %String
{
	Set tPattern=pPattern
	
	// scan symbols in reverse order to avoid substituting for Z1 at the start of Z10, etc
	For tI=..Symbols:-1:1 {
		Set tPattern=$Replace(tPattern,..IndexToSymbol(tI),..Symbols(tI))
	}
	
	Quit tPattern
}

/// In the given tree, replace all symbol references in plain nodes with the symbol value
Method FixupTree(pTree As Tree)
{
	
	// for each tree node ..
	For tI=1:1:pTree.Count() {
	
		Set tNode=pTree.GetNodeAt(tI)		
		Set tNodeType=$$$NODETYPE(tNode)
		
		// if it's a plain node ..
		If tNodeType="" {
		
			Set tPlainList=$$$EXTRACTPLAIN(tNode)
			
			// if the list includes a symbol ..
			If ..ListHasSymbol(tPlainList) {
			
				// create a new list with the symbols replaced
				Set tOut=""
				Set tPtrJ=0 While $ListNext(tPlainList,tPtrJ,tElemJ) {
					If ..IsSymbolName(tElemJ) {
						Set tIndex=+$Extract(tElemJ,4,*)
						If (tIndex<1) || (tIndex>..Symbols) {ZTrap}
						Set tOut=tOut_$ListBuild(..Symbols(tIndex))
					}
					Else {
						Set tOut=tOut_$ListBuild(tElemJ)
					}
				}
				
				// update the tree node with the new list
				Do pTree.SetNodeAt($$$PLAINNODE(tOut),tI)
			}
		}
	}
}

/// Return whether the given name is a symbol name
ClassMethod IsSymbolName(pName As %String) As %Boolean [ CodeMode = expression ]
{
$Extract(pName,1,3)="ZZZ"
}

/// Return whether the given list includes any symbols
ClassMethod ListHasSymbol(pList As %List) As %Boolean [ CodeMode = expression ]
{
$ListToString(pList)["ZZZ"
}

/// Dump symbols to the given logger, defaulting to the current output device
Method DumpSymbols(pLogger As Logger = {##class(Logger).%New()})
{
	For tI=1:1:..Symbols {
		Do pLogger.OutputToLog(" "_..IndexToSymbol(tI)_"="_..Symbols(tI))
	}
}

/// If pValue already has a symbol: return it
/// <p> Otherwise: add a symbol for pValue and return it
Method SymbolForValue(pValue As %String) As %String
{
	If $Data(..SymbolValues(pValue),tOldValue) {
		Quit ..IndexToSymbol(tOldValue)
	}
	
	Set tSymbol=..NextSymbol()
	Set ..Symbols($I(..Symbols))=pValue
	Set ..SymbolValues(pValue)=..Symbols
		
	Quit tSymbol
}

Method NextSymbol() As %String [ CodeMode = expression, Private ]
{
..IndexToSymbol(..Symbols+1)
}

ClassMethod IndexToSymbol(pIndex As %Integer) As %String [ CodeMode = expression, Private ]
{
"ZZZ"_##class(Common).LZ(pIndex,3)
}

}
