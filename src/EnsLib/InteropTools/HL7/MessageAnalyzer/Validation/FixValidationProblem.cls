/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.Validation.Segment, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging)

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.Validation)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Validation.FixValidationProblem Extends %RegisteredObject
{

Property HL7Configuration As HL7Configuration [ Private ];

Property ConfigChangeLog As ConfigChangeLog [ Private ];

Property CustomVersion As %String [ Private ];

Property SchemaName As %String [ Private ];

Method %OnNew(pHL7Configuration As HL7Configuration, pConfigChangeLog As ConfigChangeLog, pCustomVersion As %String, pSchemaName As %String) As %Status
{
	Set ..HL7Configuration=pHL7Configuration
	Set ..ConfigChangeLog=pConfigChangeLog
	Set ..CustomVersion=pCustomVersion
	Set ..SchemaName=pSchemaName
	Quit $$$OK
}

/// Returns 1 to quit the caller
Method Fix(pInstance As SegmentValidationBase, ByRef pLog, ByRef pErrorList)
{
	// show and log fix-prompt and the number of messages it applies to
	Set tFixPrompt=pInstance.FixPrompt(..HL7Configuration)
	Set tMessageCount=pInstance.HL7MessageCount()
	Set tFixPromptAndCount=tFixPrompt_" ("_tMessageCount_" "_$$messages(tMessageCount)_")"
	Write "- ",tFixPromptAndCount,!
	Set pLog($I(pLog))=""
	Set pLog($I(pLog))=tFixPromptAndCount
		
	// fix this one
	Set tLogMessages=..FixImpl(pInstance,.tError)
	If tError'="" {
		Set pErrorList($I(pErrorList))=tError
	}
	If tLogMessages'="" {
		For tI=1:1:$ListLength(tLogMessages) { // this list is not expected to be large enough to require $ListNext
			Set pLog($I(pLog))=" "_$List(tLogMessages,tI)
		}
	}
	
	Quit
	
messages(messagecount)
	Quit $Select(messagecount=1:"message",1:"messages")
}

/// Returns a $List of log messages, or "" if none.
Method FixImpl(pInstance As SegmentValidationBase, Output pError As %String) As %List [ Private ]
{
	// initial default
	Set pError=""
	
	Set tValidationErrorVersion=$Piece($List(pInstance.GetFixTarget(),2),":")
	If tValidationErrorVersion=..CustomVersion {
		Quit $ListBuild(pInstance.FixConfiguration(..HL7Configuration,..ConfigChangeLog))
	}
	
	Set tStream=##class(%Stream.GlobalCharacter).%New()
	Set tErr=""
	Try {
		Do pInstance.FixConfigurationCompound(..HL7Configuration,..ConfigChangeLog,..CustomVersion,..SchemaName,##class(Logger).%New(tStream))
	}
	Catch tErr {
		Set pError=tErr.DisplayString()
		// fall through ..
	}
	
	Set tOut=""
	$$$THROWONERROR(tSC,tStream.Rewind())
	While 'tStream.AtEnd {
		Set tOut=tOut_$ListBuild(tStream.ReadLine(,.tSC)) If $$$ISERR(tSC) {$$$ThrowStatus(tSC)}
	}
	
	If tErr'="" {
		Set tOut=tOut_$ListBuild(tErr.DisplayString())
	}
	
	Quit tOut
}

Method AskUser(pInstance As SegmentValidationBase, ByRef pShouldPrompt) As %String [ Private ]
{
	
	Do {
		Write pInstance.FixPrompt(..HL7Configuration)
		Read "? (Y/N) ",tIn,!
		Set tUIn=$$$TOUP(tIn)
	} While ($Length(tUIn)'=1) || ("YNAQ^"'[tUIn)
	
	// if they selected auto-fix ..
	If tUIn="A" {
		Set tUIn="Y"
		Set pShouldPrompt=0
	}
	
	Quit tUIn
}

}
