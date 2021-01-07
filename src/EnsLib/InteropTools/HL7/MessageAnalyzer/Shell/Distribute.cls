/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer.Logging

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.Output)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Shell.Distribute Extends %RegisteredObject
{

Property Config As Config [ Private ];

Property Logger As Logger [ Private ];

Method %OnNew(pConfig As Config, pLogger As Logger) As %Status
{
	Set ..Config=pConfig
	Set ..Logger=pLogger
	
	Quit $$$OK
}

/// Do a single Distribute run on a set of messages
/// <p> Returns "" if OK, otherwise an error message
Method ShellDistribute(pSource As %String, pTarget As %String, pVersion As %String, pOptionalSchemaName As %String, ByRef pFlags, pQuiet As %Boolean, Output pRejectedMessages) As %String
{
	$$$SHOULDBEUNDEF(pRejectedMessages)
	Set err=$$checkbool("DMCQ",.pFlags)
	If err'="" {
		Quit err
	}
	
	Set tKeySpec=$Get(pFlags("K"),"SF")
	Set tToDirs=$Get(pFlags("D"),1)
	Set tByMessageType=$Get(pFlags("M"),0)
	
	$$$IFSESSION0(StartRun)
	If 'pQuiet {
		$$$LOGOUTPUT1(..Logger,"Session #"_$$$MAS.SessionId_" run #"_$$$MAS.RunId_" begins")
	} 

	Set tDist=##class(EnsLib.InteropTools.HL7.MessageAnalyzer.API.DistributeMessages).%New(..Config,..Logger,tKeySpec,tToDirs,tByMessageType)
	
	Set configflags="" // no need for these if we're passing our own config
	Set tCombine=$Get(pFlags("C"),1)
	Set tQuiet=$Get(pFlags("Q"),1)
	
	Kill pRejectedMessages // technically redundant but it follows the pattern for Output arguments
	Do tDist.Distribute(pSource,configflags,pTarget,pVersion,pOptionalSchemaName,tCombine,tQuiet,.pRejectedMessages)
	
	Quit ""
	
checkbool(flagcodes,flags)
	
	For i=1:1:$Length(flagcodes) {
		Set thisflagcode=$Extract(flagcodes,i)
		If "01"'[$Get(flags(thisflagcode)) { // this is true for $Get returning "" as well as it returning "0" or "1"
			Return "Flag "_thisflagcode_" should be set to 0 or 1"
		}
	}
	
	Quit ""
}

}
