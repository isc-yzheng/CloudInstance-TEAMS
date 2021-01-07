/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.Logging, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell, EnsLib.InteropTools.HL7.MessageAnalyzer.Message)

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.API.DistributeMessages Extends %RegisteredObject
{

Property Config As Config [ Private ];

Property Logger As Logger [ Private ];

Property KeySpec As %String [ Private ];

Property ToDirectories As %Boolean [ Private ];

Property ByMessageType As %Boolean [ Private ];

/// Given a config, a logger, a key spec and a list of Config flag names to set
/// <p> You can default the config or logger but you must omit the argument, you can't pass ""
Method %OnNew(pConfig As Config, pLogger As Logger, pKeySpec As %String, pToDirectories As %Boolean, pByMessageType As %Boolean) As %Status
{
	$$$ACASSERT($Get(pConfig,"X")'="","DistributeMessages: config must not be passed as """"")
	$$$ACASSERT($Get(pLogger,"X")'="","DistributeMessages: logger must not be passed as """"")

	Set ..Config=$Get(pConfig,##class(Config).%New())
	Set ..Logger=$Get(pLogger,##class(Logger).%New("",0,..Config))
	Set ..KeySpec=pKeySpec
	Set ..ToDirectories=pToDirectories
	Set ..ByMessageType=pByMessageType
	
	Quit $$$OK
}

/// Given a message source
/// <p> Load the messages and write them to a file or directory associated with the key spec (..ToDirectories controls which)
/// <p> The message source is a path to a file or folder
Method Distribute(pMessageSource As %String, pSetConfigFlags As %List, pTargetDir As %String, pVersion As %String, pOptionalSchemaName As %String, pCombine As %Boolean, pQuiet As %Boolean, Output pRejectedMessages)
{
	$$$SHOULDBEUNDEF(pRejectedMessages)
	
	// make a copy of Config and set the given flags
	Set tConfig=..Config.Clone()
	Set tPtr=0 While $ListNext(pSetConfigFlags,tPtr,tFlagName) {
		Do tConfig.SetFlag(tFlagName,1)
	}
	
	// distribute the messages
	Set tProcessor=##class(DistributeMessageProcessor).%New(tConfig,..Logger,pMessageSource,pTargetDir,pVersion,pOptionalSchemaName,pCombine,..KeySpec,..ToDirectories,..ByMessageType,pQuiet)
	Kill pRejectedMessages // technically redundant but it follows the pattern for Output arguments
	Do tProcessor.ScanMessages("@"_pMessageSource,tConfig.IsFlagSet("ABSTRACTMESSAGES"),tConfig.GetOptionValue("OUTLIERTHRESHOLD"),tConfig.IsFlagSet("MAKELIGHTMESSAGEFILES"),.pRejectedMessages,pQuiet)
	If $Get(pRejectedMessages) {
		Do ..Logger.OutputToLog(pRejectedMessages_" rejected messages")
		If tConfig.IsFlagSet("LOGALLREJECTEDMESSAGES") {
			For tI=1:1:pRejectedMessages {
				Do ..Logger.OutputToLog(tI_": "_pRejectedMessages(tI))
			}
		}
	}		
	
	// process reports
	Set tReportCount=tProcessor.GetReportCount()
	For tR=1:1:tReportCount {
		Do tProcessor.Report(tR,"",tConfig,..Logger)
	}
}

}
