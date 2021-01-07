/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell, EnsLib.InteropTools.HL7.MessageAnalyzer.Analysis, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging)

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Output

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Test.AbstractStringsTest Extends %RegisteredObject [ Final ]
{

ClassMethod AllTests(pConfig As Config, pLogger As Logger) As %Integer
{
	Set tObj=..%New(pConfig,pLogger)
	
	Do tObj.Test($LB("A,B,C,D,E"),"A,B,C,D,E")
	Do tObj.Test($LB("A,B,C,D,E","A,B,C,D,E"),"A,B,C,D,E")
	Do tObj.Test($LB("A,B,C,D,E","A,B,C,D"),"A,B,C,D,[E]")
	Do tObj.Test($LB("A,B,C,D,E","A,C,D"),"A,[B],C,D,[E]")
	Do tObj.Test($LB("A,B,C,D,E","A,B,C,C,D,E"),"A,B,{C},D,E")
	Do tObj.Test($LB("A,B,C,D,E","A,B,C,C,D,E","A,B,D,E"),"A,B,[{C}],D,E")
	Do tObj.Test($LB("A,B,C,D,E","A,B,D,E","A,B,C,D","P,Q,R,S","P,Q,R","Q,R,S","P,S","Q,S","P,R","P,Q,Q,R,S"),"<[P],[{Q}],[R],[S]|A,B,[C],D,[E]>")
	Do tObj.Test($LB("F,G,H,I,J","F,G,H,I","G,H,I,J","F,G,H","G,H,I","F,G","G,H","H,I","I,J"),"[F],[G],[H],[I],[J]")
	Do tObj.Test($LB("A,B,C,D","A,C,B,D","A,C,D","A,B,D"),"{[A],[B],[C],[D]}")
	Do tObj.Test($LB("A,B,C,D,E","A,B,D,C,E","A,B,C,D"),"<A,B,C,D,[E]|A,B,D,C,E>")
	Do tObj.Test($LB("A,B,C,D,E","A,B,D,C,E","A,B,C,D","B,D,C,E"),"<A,B,C,D,[E]|[A],B,D,C,E>")
	
	Quit tObj.FailureCount
}

Property Config As Config [ Private, ReadOnly ];

Property Logger As Logger [ Private, ReadOnly ];

Property TestID As %Integer [ Private ];

Property FailureCount As %Integer [ Private ];

Method %OnNew(pConfig As Config, pLogger As Logger) As %Status
{
	Set i%Config=pConfig
	Set i%Logger=pLogger
	Set ..TestID=0
	Set ..FailureCount=0
	
	Quit $$$OK
}

Method Test(pSample As %List, pExpectedPattern As %String)
{
	Set ..TestID=..TestID + 1
	Set ..FailureCount=..FailureCount + ..TestImpl(pSample,pExpectedPattern)
}

Method TestImpl(pSample As %List, pExpectedPattern As %String) As %Integer [ Private ]
{
	Set tAS=##class(AbstractStrings).%New(pSample,1,..Config,..Logger)
	Do tAS.GetCollections(.tCollections)
	
	// for each collection
	Set tPatterns=""
	For tI=1:1:tCollections {
		Set tColl=tCollections(tI)
		Set $ListBuild(tError,tOnePattern)=tColl.DerivePattern("Collection_"_..TestID_"_"_tI)
		If tError="" {
			Set tPatterns=tPatterns_$ListBuild(tOnePattern)
		}
		Else {
			$$$LOGOUTPUT1(..Logger,"Failed to derive pattern for '"_tColl.ShowCLIList()_"': "_tError)
			Quit 1 // 1 failure
		}
	}
	
	If tPatterns="" {
		$$$LOGOUTPUT1(..Logger,"No patterns derived")
		Quit 1 // 1 failure
	}
	Else {
		Set tObservedPattern=##class(Common).ListToPattern(tPatterns)
		If tObservedPattern'=pExpectedPattern {
			$$$LOGOUTPUT1(..Logger,"Test on "_pSample_" failed:")
			$$$LOGOUTPUT1(..Logger," expected: "_pExpectedPattern)
			$$$LOGOUTPUT1(..Logger," observed: "_tObservedPattern,)
			Quit 1 // 1 failure
		}
	}
	
	Quit 0 // no failures
}

}
