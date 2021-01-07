/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging, EnsLib.InteropTools.HL7.MessageAnalyzer.Common)

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Test.BasicTest Extends %RegisteredObject
{

Property Logger As Logger [ Private, ReadOnly ];

ClassMethod AllTests(pLogger As Logger) As %Integer
{
	#Dim tFailureCount
	
	Set tObj=..%New(pLogger)
	
	Set tFailureCount=0
	Set tFailureCount=tFailureCount + tObj.Test("A","A",$ListBuild("A"),$ListBuild("B"))
	Set tFailureCount=tFailureCount + tObj.Test("A,B","A,B",$ListBuild("A,B"),$ListBuild("A"))
	Set tFailureCount=tFailureCount + tObj.Test("[A],B","(A,)?B",$ListBuild("B","A,B"),$ListBuild("A"))
	Set tFailureCount=tFailureCount + tObj.Test("{A},B","(A,)+B",$ListBuild("A,B","A,A,B","A,A,A,B"),$ListBuild("A","B"))
	Set tFailureCount=tFailureCount + tObj.Test("[{A}],B","(A,)*B",$ListBuild("B","A,B","A,A,B","A,A,A,B"),$ListBuild("A"))
	Set tFailureCount=tFailureCount + tObj.Test("<A|B>","A|B",$ListBuild("A","B"),$ListBuild("A,B"))
	Set tFailureCount=tFailureCount + tObj.Test("<A,B|A,C>","A,B|A,C",$ListBuild("A,B","A,C"),$ListBuild("A"))
	Set tFailureCount=tFailureCount + tObj.Test("A,[B,C],D","A,(B,C,)?D",$ListBuild("A,D","A,B,C,D"),$ListBuild("A","A,B,C","A,B,D"))
	
	Quit tFailureCount
}

Method %OnNew(pLogger As Logger) As %Status
{
	Set i%Logger=pLogger
	
	Quit $$$OK
}

Method Test(pPattern As %String, pRegex As %String, pMatches As %List, pMismatches As %List) As %Integer
{
	#Dim tFailureCount
	#Dim tRigSchema As RigSchema
	#Dim tConfig As Config
	#Dim tRegexMatcher As %Regex.Matcher
	
	Set tConfig=##class(Config).%New()
	Set tRigSchema=##class(Common).MakeRigSchema(pPattern,tConfig,..Logger,1)
	Set tRegexMatcher=##class(%Regex.Matcher).%New(pRegex)
	
	Set tFailureCount=0
	Set tFailureCount=tFailureCount + ..TestSamples(pPattern,tRigSchema,pRegex,tRegexMatcher,pMatches,1,tConfig)
	Set tFailureCount=tFailureCount + ..TestSamples(pPattern,tRigSchema,pRegex,tRegexMatcher,pMismatches,0,tConfig)
	
	Quit tFailureCount
}

ClassMethod TestSamples(pPattern As %String, pRigSchema As RigSchema, pRegex As %String, pRegexMatcher As %Regex.Matcher, pSampleList As %List, pShouldMatch As %Boolean, pConfig As Config) As %Integer [ Private ]
{
	#Dim tI,tSample,tFailureCount
	
	Set tFailureCount=0
	Set tPtrI=0 While $ListNext(pSampleList,tPtrI,tElemI) {
		Set tSample=tElemI
		Set tSampleTypes=##class(MessageUtils).MessageSegmentTypes(tSample)
		If ..TestNFA(pRigSchema,tSampleTypes,pConfig)'=pShouldMatch {
			Do ..Report(pShouldMatch,"schema:"_pPattern,tSample)
			Set tFailureCount=tFailureCount+1
		}
		If pRegexMatcher.Match(tSample)'=pShouldMatch {
			Do ..Report(pShouldMatch,"regex:"_pRegex,tSample)
			Set tFailureCount=tFailureCount+1
		}
	}
	
	Quit tFailureCount
}

ClassMethod TestNFA(pRigSchema As RigSchema, pSampleTypes As %List, pConfig As Config) As %Boolean [ CodeMode = expression, Private ]
{
$List(##class(Common).RunImplMatch(pSampleTypes,pRigSchema,pConfig,1))
}

ClassMethod Report(pShouldHaveMatched As %Boolean, pPattern As %String, pSample As %String) [ Private ]
{
	Write "Expected ",$Select(pShouldHaveMatched:"MATCH",1:"MISMATCH")," for ",pPattern," against ",pSample,!
}

}
