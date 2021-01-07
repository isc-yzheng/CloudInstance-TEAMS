/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Union, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell)

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Common.ComparePatternsByBasis Extends %RegisteredObject
{

ClassMethod ComparePatterns(pLeftPattern As %String, pRightPattern As %String)
{
	Kill tLeftBasis
	Do ##class(PatternUtils).Basis(pLeftPattern,.tLeftBasis)
	$$$ACASSERT($Data(tLeftBasis)\10,"ComparePatterns: no basis messages for left pattern")

	Kill tRightBasis
	Do ##class(PatternUtils).Basis(pRightPattern,.tRightBasis)
	$$$ACASSERT($Data(tRightBasis)\10,"ComparePatterns: no basis messages for right pattern")
	
	Kill tLeftOnly
	Kill tRightOnly Merge tRightOnly=tRightBasis
	Kill tBoth
	Set tLeftKey="" While 1 {
		
		Set tLeftKey=$Order(tLeftBasis(tLeftKey)) If tLeftKey="" {Quit}
		
		If $Data(tRightBasis(tLeftKey)) {
			Set tBoth(tLeftKey)=""
			Kill tRightOnly(tLeftKey)
		}
		Else {
			Set tLeftOnly(tLeftKey)=""
		}
	}
	
	Do ..Show("left only",.tLeftOnly)
	Do ..Show("right only",.tRightOnly)
	Do ..Show("both",.tBoth)
	
	Kill tAllMessages
	Merge tAllMessages=tLeftBasis
	Merge tAllMessages=tRightBasis
	Write ..Pattern(.tAllMessages)
}

ClassMethod Pattern(ByRef pMessageArray) As %String
{
	Set tOut=""
	Set tKey="" While 1 {
		Set tKey=$Order(pMessageArray(tKey)) If tKey="" {Quit}
		Set tOut=tOut_$ListBuild($ListFromString($Extract(tKey,2,*)))
	}
	
	Quit ##class(DerivePattern).%New(##class(Config).%New(),##class(Logger).%New(),1).FindPattern(tOut)
}

ClassMethod Show(pTitle As %String, ByRef pArr) [ Private ]
{
	Write pTitle,!
	Set tKey="" While 1 {
		Set tKey=$Order(pArr(tKey)) If tKey="" {Quit}
		Write " ",$Extract(tKey,2,*),!
	}
}

}
