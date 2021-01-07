/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.Logging, EnsLib.InteropTools.HL7.MessageAnalyzer.Common)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Test.PatternOptimizeTest Extends %RegisteredObject
{

Property Logger As Logger [ Private, ReadOnly ];

ClassMethod AllTests(pLogger As Logger) As %Integer
{
	#Dim tFailureCount
	
	Set tObj=..%New(pLogger)
	
	Set tFailureCount=0

	Set tFailureCount=tFailureCount + tObj.Test("A","A")
	Set tFailureCount=tFailureCount + tObj.Test("[A]","[A]")
	Set tFailureCount=tFailureCount + tObj.Test("{A}","{A}")
	Set tFailureCount=tFailureCount + tObj.Test("A,B","A,B")

	Set tFailureCount=tFailureCount + tObj.Test("[[A]],B","[A],B")
	Set tFailureCount=tFailureCount + tObj.Test("{{A}},B","{A},B")
	
	Set tFailureCount=tFailureCount + tObj.Test("[{A}],A","{A}")
	Set tFailureCount=tFailureCount + tObj.Test("[{A}],[A]","[{A}]")
	Set tFailureCount=tFailureCount + tObj.Test("[{A}],{A}","{A}")
	Set tFailureCount=tFailureCount + tObj.Test("{A},A","{A}")
	Set tFailureCount=tFailureCount + tObj.Test("[A],A","{A}")
	Set tFailureCount=tFailureCount + tObj.Test("{A},[A]","{A}")

	Set tFailureCount=tFailureCount + tObj.Test("A,[{A}]","{A}")
	Set tFailureCount=tFailureCount + tObj.Test("[A],[{A}]","[{A}]")
	Set tFailureCount=tFailureCount + tObj.Test("{A},[{A}]","{A}")
	Set tFailureCount=tFailureCount + tObj.Test("A,{A}","{A}")
	Set tFailureCount=tFailureCount + tObj.Test("A,[A]","{A}")
	Set tFailureCount=tFailureCount + tObj.Test("[A],{A}","{A}")

	Quit tFailureCount
}

Method %OnNew(pLogger As Logger) As %Status
{
	Set i%Logger=pLogger
	
	Quit $$$OK
}

Method Test(pPattern As %String, pExpectedOptimizedPattern As %String) As %Integer
{
	Set tActualOptimizedPattern=##class(PatternUtils).Optimize(pPattern)
	If tActualOptimizedPattern'=pExpectedOptimizedPattern {
		Do ..Report(pPattern,pExpectedOptimizedPattern,tActualOptimizedPattern)
		Quit 1 // 1 failure
	}
	Else {
		Quit 0 // no failures
	}
}

ClassMethod Report(pPattern As %String, pExpectedOptimizedPattern As %String, pActualOptimizedPattern As %String) [ Private ]
{
	Write "Expected ",pPattern," to optimize to ",pExpectedOptimizedPattern,",  actual: ",pActualOptimizedPattern,!
}

}
