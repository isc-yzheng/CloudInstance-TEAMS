/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Node)

Include (EnsHL7, EnsLib.InteropTools.HL7.MessageAnalyzer.Utils)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Common.PatternUtils [ Abstract ]
{

/// If pSchemaList is empty or not passed: all Ensemble schemas are used
/// <p> Returns $LB($LB(BESTMATCHINGSCHEMA,..),BESTMATCHINGSCORE)
ClassMethod BestMatchingSchemas(pRawBaseSource As %String, pVersion As %String, pSchemaNameList As %List = "") As %List
{
	Set tBaseSource=##class(Common).AsSSF(##class(Common).WithoutVersionPrefixes(pRawBaseSource,pVersion))
	
	Kill tArr // tArr(COMMONALITY,SCHEMANAME)=""
	If pSchemaNameList="" {
		Set tKey="" While 1 {
			Set tKey=$Order($$$vaSchemaGbl(pVersion,"MS",tKey),+1,tRawSource) If tKey="" {Quit}
			Do ..UpdateBestMatchingArray(tBaseSource,tKey,tRawSource,pVersion,.tArr)
		}
	}
	Else {
		Set tPtr=0 While $ListNext(pSchemaNameList,tPtr,tKey) {
			Set tRawSource=$$$vaSchemaGbl(pVersion,"MS",tKey)
			Do ..UpdateBestMatchingArray(tBaseSource,tKey,tRawSource,pVersion,.tArr)
		}
	}
	
	Set tHighestCommonality=$Order(tArr(""),-1)
	If tHighestCommonality="" {
		Quit ""
	}
	
	Set tOut=""
	Set tKey="" While 1 {
		Set tKey=$Order(tArr(tHighestCommonality,tKey)) If tKey="" {Quit}
		Set tOut=tOut_$ListBuild(tKey)
	}
	
	Quit $ListBuild(tOut,tHighestCommonality)
}

ClassMethod PatternCommonality(pPattern1 As %String, pPattern2 As %String) As %Integer
{
	Set tTerms1=##class(Common).SchemaTerms(pPattern1)
	Set tTerms2=##class(Common).SchemaTerms(pPattern2)
	
	Set tCommon1=..CommonElements(tTerms1,tTerms2)
	Set tCommon2=..CommonElements(tTerms2,tTerms1)	
	$$$ACASSERT($ListLength(tCommon1)=$ListLength(tCommon2),"PatternCommonality: internal error - common element lists have different lengths")
	
	Quit $ListLength(tCommon1) - ..SwapCount(tCommon1,tCommon2)
}

/// Return the elements which pListA and pListB both contain, in the order in which they appear in pListB
/// <p> Duplicate elements in either list are ignored
ClassMethod CommonElements(pListA As %List, pListB As %List) As %List
{
	Kill tArrA
	Do ..ListToArray(pListA,.tArrA)
	
	Kill tArrB
	Set tOut=""
	Set tPtr=0 While $ListNext(pListB,tPtr,tElem) {
		If $Data(tArrA(tElem)),'$Data(tArrB(tElem)) {
			Set tOut=tOut_$ListBuild(tElem)
			Set tArrB(tElem)=""
		}
	}
	
	Quit tOut
}

ClassMethod LinearizeChoice(pPattern As %String) As %String
{
	$$$ACASSERT(pPattern["<","LinearizeChoice: pattern contains no choice - "_pPattern)
	$$$ACASSERT($Length(pPattern,"<")=2,"LinearizeChoice: pattern contains more than one choice - "_pPattern)
	$$$ACASSERT(pPattern'["~","LinearizeChoice: pattern is not in simplified format")
	
	Set tPosLessThan=##class(Common).IndexOf(pPattern,"<")
	Set tPosGreaterThan=##class(Common).IndexOf(pPattern,">")
	
	// before "<"
	Set tBeforeChoice=$Extract(pPattern,1,tPosLessThan-1)
	
	// between "<" and ">"
	Set tChoiceInner=$Extract(pPattern,tPosLessThan+1,tPosGreaterThan-1)
	
	// after ">"
	Set tAfterChoice=$Extract(pPattern,tPosGreaterThan+1,*)
	
	// inner parts delimited by "|"
	Set tChoiceParts=$ListFromString(tChoiceInner,"|")
	
	// put [..] around each part
	Set tOut=""
	Set tPtr=0 While $ListNext(tChoiceParts,tPtr,tPart) {
		Set tOut=tOut_$ListBuild("["_tPart_"]")
	}
	
	// return the before and after strings, placed around the option sequence we just made
	Quit tBeforeChoice_$ListToString(tOut)_tAfterChoice
}

ClassMethod Optimize(pPattern As %String, pShowEach As %Boolean = 0) As %String
{
	Set tNextPattern=pPattern
	Do {
		
		If pShowEach {
			Write " - ",tNextPattern,!
		}

		Set tPattern=tNextPattern
		Set tSchema=##class(Common).AsCSF(tPattern)
		Set tLexer=##class(Lexer).%New(tSchema)
		Set tTopNode=##class(Parser).ParseSchema(tLexer)

		Set tNextPattern=tTopNode.OptimizedPattern()
		
	} While tNextPattern'=tPattern
	
	Quit tPattern
}

ClassMethod Basis(pPattern As %String, Output pBasisMessages)
{
	$$$SHOULDBEUNDEF(pBasisMessages)
	
	Set tNode=##class(Common).CompileSchema(pPattern)
	
	Kill tBasisArray
	Do tNode.PatternAlternatives(.tBasisArray)
	
	// remove duplicates
	For tI=1:1:$Get(tBasisArray) {
		Set pBasisMessages("."_tBasisArray(tI))=""
	}
}

ClassMethod BasisNoEmpty(pPattern As %String, Output pBasisMessages)
{
	$$$SHOULDBEUNDEF(pBasisMessages)
	
	Set tNode=##class(Common).CompileSchema(pPattern)
	
	Kill tBasisArray
	Do tNode.PatternAlternatives(.tBasisArray)
	
	// remove duplicates
	For tI=1:1:$Get(tBasisArray) {
		Set tMessage=tBasisArray(tI)
		If tMessage'="" {
			Set pBasisMessages(tMessage)=""
		}
	}
}

ClassMethod PatternAlternatives(pNode As Base, Output pAlternatives)
{
	$$$SHOULDBEUNDEF(pAlternatives)
	
	Kill tRawAlternatives
	Do pNode.PatternAlternatives(.tRawAlternatives)
	
	// remove duplicates
	Kill tArr
	For tI=1:1:$Get(tRawAlternatives) {
		Set tArr("."_tRawAlternatives(tI))=""
	}
	
	// write to counted array
	Set tKey="" While 1 {
		Set tKey=$Order(tArr(tKey)) If tKey="" {Quit}
		Set pAlternatives($I(pAlternatives))=$Extract(tKey,2,*)
	}
}

ClassMethod ListToArray(pList As %List, Output pArr) [ Private ]
{
	$$$SHOULDBEUNDEF(pArr)
	
	Set tPtr=0 While $ListNext(pList,tPtr,tElem) {
		Set pArr(tElem)="" // ignore duplicate terms
	}
}

ClassMethod SwapCount(pListA As %List, pListB As %List) As %Integer [ Private ]
{
	$$$ACASSERT($ListLength(pListA)=$ListLength(pListB),"SwapCount: internal error - given lists have different lengths")
	
	// optimization for simple case
	If pListA=pListB {
		Quit 0
	}
	
	Set tSwapCount=0
	Set tPtrA=0,tPtrB=0 While $ListNext(pListA,tPtrA,tElemA),$ListNext(pListB,tPtrB,tElemB) {
		If tElemA'=tElemB {
			Set tSwapCount=tSwapCount+1
		}
	}
	
	Quit tSwapCount
}

ClassMethod UpdateBestMatchingArray(pBaseSource As %String, pSchemaName As %String, pRawSource As %String, pVersion As %String, ByRef pArray) [ Private ]
{
	Set tVersionlessSource=##class(Common).WithoutVersionPrefixes(pRawSource,pVersion)
	Set tSource=##class(Common).AsSSF(tVersionlessSource)
	Set pArray(..PatternCommonality(pBaseSource,tSource),pSchemaName)=""
}

}
