/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Diff, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging, EnsLib.InteropTools.HL7.MessageAnalyzer.Common)

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Test.ScanningTest Extends %RegisteredObject
{

Property Logger As Logger [ Private, ReadOnly ];

/// The key to the expected results is that:
/// <ul>
///  <li>The major delimiter is "&" which separates alternative difference analyses
///  <li>Next comes "/" which separates regions within a single difference analysis
///  <li>Finally "," separates leaf/message-types in sequence within a region
/// </ul>
ClassMethod AllTests(pLogger As Logger) As %Integer
{
	#Dim tFailureCount
	
	Set tObj=..%New(pLogger)
	
	Set tFailureCount=0

	// simple sequence
	Set tFailureCount=tFailureCount + tObj.Test("A,B,C,D",$ListBuild(	
			$LB("A,D","Leaf[B]#00004,Leaf[C]#00005"),			
			$LB("A,B,C","Leaf[D]#00006"),
			$LB("A,C,D","Leaf[B]#00004"),			
			$LB("A,B,D","Leaf[C]#00005"),
			$LB("A,B","Leaf[C]#00005,Leaf[D]#00006"),
			$LB("A,C","Leaf[B]#00004/Leaf[D]#00006"),
			$LB("A","Leaf[B]#00004,Leaf[C]#00005,Leaf[D]#00006"),
			$LB("A,X,C,D","Leaf[B]#00004,X @2"),
			$LB("A,X","Leaf[B]#00004,Leaf[C]#00005,Leaf[D]#00006,X @2"),
			$LB("A,B,X","Leaf[C]#00005,Leaf[D]#00006,X @3"),
			$LB("A,X,D","Leaf[B]#00004,Leaf[C]#00005,X @2")
		)
	)

	// sequence with simple optional
	Set tFailureCount=tFailureCount + tObj.Test("A,[B],C,D",$ListBuild(
			$LB("A,D","Leaf[C]#00009"),
			$LB("A,B,C","Leaf[D]#00010"),
			$LB("A,B,D","Leaf[C]#00009"),
			$LB("A,B","Leaf[C]#00009,Leaf[D]#00010"),
			$LB("A,C","Leaf[D]#00010"),
			$LB("A","Leaf[C]#00009,Leaf[D]#00010"),
			$LB("A,X,C,D","X @2"),
			$LB("A,X","Leaf[C]#00009,Leaf[D]#00010,X @2"),
			$LB("A,B,X","Leaf[C]#00009,Leaf[D]#00010,X @3"),
			$LB("A,X,D","Leaf[C]#00009,X @2")
		)
	)
	
	// sequence with simple choice
	Set tFailureCount=tFailureCount + tObj.Test("A,<B|C>,D",$ListBuild(
			$LB("A,D","Leaf[B]#00009&Leaf[C]#00013"),
			$LB("A,B,C","B @2/Leaf[D]#00015&Leaf[D]#00015,C @3"),
			$LB("A,B","Leaf[D]#00015"),
			$LB("A,C","Leaf[D]#00015"),
			$LB("A","Leaf[B]#00009,Leaf[D]#00015&Leaf[C]#00013,Leaf[D]#00015"),
			$LB("A,X,C,D","X @2"),
			$LB("A,X","Leaf[B]#00009,Leaf[D]#00015,X @2&Leaf[C]#00013,Leaf[D]#00015,X @2"),
			$LB("A,B,X","Leaf[D]#00015,X @3"),
			$LB("A,X,D","Leaf[B]#00009,X @2&Leaf[C]#00013,X @2")
		)
	)
	
	// sequence with simple repeat
	Set tFailureCount=tFailureCount + tObj.Test("A,{B},C,D",$ListBuild(
			$LB("A,D","Leaf[B]#00006,Leaf[C]#00014"),
			$LB("A,B,C","Leaf[D]#00015"),
			$LB("A,C,D","Leaf[B]#00006"),
			$LB("A,C","Leaf[B]#00006/Leaf[D]#00015"),	
			$LB("A","Leaf[B]#00006,Leaf[C]#00014,Leaf[D]#00015"),
			$LB("A,X,C,D","Leaf[B]#00006,X @2"),
			$LB("A,X","Leaf[B]#00006,Leaf[C]#00014,Leaf[D]#00015,X @2"),
			$LB("A,B,X","Leaf[C]#00014,Leaf[D]#00015,X @3"),
			$LB("A,B,B,X","Leaf[C]#00014,Leaf[D]#00015,X @4"),
			$LB("A,X,D","Leaf[B]#00006,Leaf[C]#00014,X @2"),
			$LB("A,B,D","Leaf[C]#00014"),
			$LB("A,B,B,C","Leaf[D]#00015")
		)
	)
	
	Quit tFailureCount
}

Method %OnNew(pLogger As Logger) As %Status
{
	Set i%Logger=pLogger
	
	Quit $$$OK
}

/// pSamples=$ListBuild($ListBuild(MESSAGE,EXPECTED),..)
Method Test(pPattern As %String, pSamples As %List) As %Integer
{
	#Dim tRigSchema As RigSchema
	#Dim tConfig As Config
	
	Set tConfig=##class(Config).%New()
	Set tRigSchema=##class(Common).MakeRigSchema(pPattern,tConfig,..Logger,1)
	
	Set tFailureCount=0
	Set tPtrI=0 While $ListNext(pSamples,tPtrI,tElemI) {
		Set $ListBuild(tMessageText,tExpected)=tElemI
		Set tFailureCount=tFailureCount+..TestSample(pPattern,tRigSchema,tMessageText,tExpected,tConfig)
	}
	
	Quit tFailureCount
}

ClassMethod TestSample(pPattern As %String, pRigSchema As RigSchema, pMessageText As %String, pExpected As %String, pConfig As Config) As %Integer [ Private ]
{
	Kill tShortestFinalDiffRecords
	Do ##class(Common).RunImplScan(##class(MessageUtils).MessageSegmentTypes(pMessageText),pRigSchema,pConfig,0,1,,.tShortestFinalDiffRecords)
	
	If '$Get(tShortestFinalDiffRecords) {
		Do ..Report(pExpected,pPattern,pMessageText," - got no diff records")
		Quit 1 // 1 failure
	}
	
	Else {
	
		Set tShortestAsString=##class(Diff).DiffRecordsAsString(.tShortestFinalDiffRecords)

		If tShortestAsString'=pExpected {
			Do ..Report(pExpected,pPattern,pMessageText," - got "_tShortestAsString)
			Quit 1 // 1 failure
		}
		
		Quit 0 // no failures
	}
}

ClassMethod Report(pExpected As %String, pPattern As %String, pSample As %String, pCloser As %String = "") [ Private ]
{
	Write "Expected ",pExpected," for ",pPattern," against ",pSample,pCloser,!
}

}
