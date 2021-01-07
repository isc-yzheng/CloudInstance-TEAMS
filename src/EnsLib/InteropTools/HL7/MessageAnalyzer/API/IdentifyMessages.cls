/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell, EnsLib.InteropTools.HL7.MessageAnalyzer.Message, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging, EnsLib.InteropTools.HL7.MessageAnalyzer.Common)

/// API to the message-identification facility
Class EnsLib.InteropTools.HL7.MessageAnalyzer.API.IdentifyMessages Extends %RegisteredObject
{

Property Config As Config [ Private ];

Property Logger As Logger [ Private ];

Property Version As %String [ Private ];

Property RigSchemas As RigSchemaCollection [ Private ];

/// The arguments are constructed with sensible defaults if omitted but if you want to set Config flags or options you will need to construct and
/// configure your own Config object and pass that.
Method %OnNew(pConfig As Config, pLogger As Logger, pVersion As %String = "") As %Status
{
	Set ..Config=$Get(pConfig,##class(Config).%New())
	Set ..Logger=$Get(pLogger,##class(Logger).%New("",0,..Config))
	Set ..Version=pVersion
	Set ..RigSchemas=##class(RigSchemaCollection).%New()
	
	Quit $$$OK
}

/// Given a string which would be acceptable to enter into the shell (RigImpl): load the given schemas into this object.
/// <p> - this can be an explicit schema definition, a single schema name, or something using "+" or the "*" suffix
/// <p> - this method can be called more than once and the schemas accumulate - they are NOT cleared before each load
/// This method will take an appreciable time (perhaps 30s or more) to load all schemas (i.e. when passing "*") but it only needs to
/// be done once and any number of messages can subsequently be processed using IdentifyMatchingSchemas or AnalyzeMessages.
Method LoadSchemas(pSchemaSpec As %String, pQuiet As %Boolean = 1)
{
	Do ##class(Common).ProcessSchemaSelection(pSchemaSpec,..RigSchemas,..Version,..Config,..Logger,pQuiet)
}

/// Return a list of loaded schema names
Method LoadedSchemaNames() As %List
{
	Set tOut=""
	Set tKey="" While 1 {
		Set tKey=..RigSchemas.NextByName(tKey) If tKey="" {Quit}
		Set tOut=tOut_$ListBuild(tKey)
	}
	
	Quit tOut
}

/// Given a message as a CSV string of message types (e.g. "MSH,PID,PVN"): return $LB($LB(SCHEMANAME,SCHEMASPEC),..) with all schemas that match the message exactly.
Method IdentifyMatchingSchemas(pMessageSpec As %String, pQuiet As %Boolean = 1, pMessageType As %String = "") As %List
{
	Set tProcessor=##class(IdentifyMessageProcessor).%New(..RigSchemas,..Config,..Version,"",0,pQuiet)
	
	Set tMessage=##class(MessageUtils).MessageSegmentTypes(pMessageSpec)
	Set tMessageReport=tProcessor.IdentifyImplMatch(,pMessageType,tMessage,1,"",pQuiet)
	
	Quit tMessageReport.GetMatchingSchemas()
}

/// Given a message source, a list of Config flag names to set and a couple of loggers
/// <p> Load the messages and classify by schema
/// <p> The message source is a path to a file or folder
/// <p> The schema is taken from the message type if given, otherwise it is one of:
/// <ul>
///  <li> Some existing schema which matches all the relevant messages
///  <li> A schema which has been modified to match any originally-mismatching messages
///  <li> The schema which most nearly matches the messages but which the program was unable to modify to match completely
Method AnalyzeMessages(pMessageSource As %String, pCombine As %Boolean, pSetConfigFlags As %List, pQuiet As %Boolean, pOutput As Logger, pLogOutput As Logger)
{
	Set tUseLogOutput=$Select(pLogOutput="":..Logger,1:pLogOutput)
		
	// make a copy of Config and set the given flags
	Set tConfig=..Config.Clone()
	Set tPtr=0 While $ListNext(pSetConfigFlags,tPtr,tFlagName) {
		Do tConfig.SetFlag(tFlagName,1)
	}
	
	// analyze the messages
	Set tProcessor=##class(IdentifyMessageProcessor).%New(..RigSchemas,tConfig,..Version,tUseLogOutput,pCombine,pQuiet)
	Kill tRejectedMessages
	Do tProcessor.ScanMessages("@"_pMessageSource,tConfig.IsFlagSet("ABSTRACTMESSAGES"),tConfig.GetOptionValue("OUTLIERTHRESHOLD"),tConfig.IsFlagSet("MAKELIGHTMESSAGEFILES"),.tRejectedMessages,pQuiet)
	If $Get(tRejectedMessages) {
		Do tUseLogOutput.OutputToLog(tRejectedMessages_" rejected messages")
		If tConfig.IsFlagSet("LOGALLREJECTEDMESSAGES") {
			For tI=1:1:tRejectedMessages {
				Do tUseLogOutput.OutputToLog(tI_": "_tRejectedMessages(tI))
			}
		}
	}		
	
	// process reports
	Set tReportCount=tProcessor.GetReportCount()
	For tR=1:1:tReportCount {
	
		Kill tStrategyManagers
		Do tProcessor.Report(tR,..RigSchemas.MakeMachineCollection(),tConfig,tUseLogOutput,.tStrategyManagers)
		
		// run extensions
		If '$Get(tStrategyManagers) {
			Do tUseLogOutput.OutputToLog("No strategies were found")
		}
		
		Else {
			Do tUseLogOutput.OutputToLog("")
			Do tUseLogOutput.OutputToLog("Running strategies ("_tStrategyManagers_") to find extensions:")
			For tI=1:1:tStrategyManagers {
			
				Set tSM=tStrategyManagers(tI)
				Set tBestSchema=tSM.GetBestSchemaName()
				
				Do tUseLogOutput.OutputToLog("")
				Do tUseLogOutput.OutputToLog("Finding extensions for "_tBestSchema)
				Kill tExtensions
				Do tSM.Extend(.tExtensions,tConfig,..RigSchemas)
				
				If '$Get(tExtensions) {
					Do tUseLogOutput.OutputToLog("- no extensions proposed for "_tBestSchema)

					// output record: noextend`BESTSCHEMA
					Do pOutput.OutputToLog("noextend`"_tBestSchema)
				}
				Else {
					For k=1:1:tExtensions {
						Do tUseLogOutput.OutputToLog(" - "_tExtensions(k).Describe())
						Set tSchemaSource=##class(Common).ParseSchemaSpec(tBestSchema,..Version)
						If tSchemaSource="" {ZTrap}
						Set tNewSchemaSource=tExtensions(k).Apply(tSchemaSource)
						Do tUseLogOutput.OutputToLog("   - new schema source: "_tNewSchemaSource)
						
						// output record: extend`BESTSCHEMA`EXTENTIONDESCRIPTION`NEWSCHEMASOURCE
						Do pOutput.OutputToLog("extend`"_tBestSchema_"`"_tExtensions(k).Describe()_"`"_tNewSchemaSource)
					}
				}
			}
		}
	}
}

/// Quick call to check a single message against a single schema specification
/// <p> Given a message as a CSV string of message types (e.g. "MSH,PID,PVN") and a schema name/spec: return 1 if the message matches, 0 otherwise
ClassMethod MessagePassesSchema(pMessageSpec As %String, pSchemaSpec As %String, pVersion As %String = "") As %Boolean
{
	Set tIM=##class(EnsLib.InteropTools.HL7.MessageAnalyzer.API.IdentifyMessages).%New(,,pVersion)
	Do tIM.LoadSchemas(pSchemaSpec)
	Set tMatchingSchemas=tIM.IdentifyMatchingSchemas(pMessageSpec,1)
	Quit tMatchingSchemas'=""
}

/// Quick call to check a list of messages against a single schema specification
/// <p> Given a message as a $List of CSV strings of message types (typical CSV string: "MSH,PID,PVN") and a schema name/spec: return 1 if every message matches, 0 otherwise
ClassMethod MessageListPassesSchema(pMessageSpecList As %List, pSchemaSpec As %String) As %Boolean
{
	Set tIM=##class(EnsLib.InteropTools.HL7.MessageAnalyzer.API.IdentifyMessages).%New()
	Do tIM.LoadSchemas(pSchemaSpec)
	Set tPtrI=0 While $ListNext(pMessageSpecList,tPtrI,tElemI) {
		Set tMessage=##class(MessageUtils).MessageSegmentTypes(tElemI)
		Set tMatchingSchemas=tIM.IdentifyMatchingSchemas(tMessage,1)
		If tMatchingSchemas="" {
			Return 0
		}
	}
	
	Quit 1
}

}
