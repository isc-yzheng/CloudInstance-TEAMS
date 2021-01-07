/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Shell.Config Extends %RegisteredObject
{

Property Flags As array Of %Boolean [ Private ];

Property Options As array Of %String [ Private ];

/// NOSCANZ=0/1 - don't apply Scan extension if the last type of the message is a Z-segment (temporary option) 
Property ExtensionOptions As array Of %String [ Private ];

Property NewSchemaNameIndex As %Integer [ InitialExpression = 0, Private ];

Method %OnNew() As %Status
{
	#Dim tPtrI,tElemI
	#Dim tFlagInfo As %List
	
	Set tFlagInfo=..FlagInfo()
	Set tPtrI=0 While $ListNext(tFlagInfo,tPtrI,tElemI) {
		$$$THROWONERROR(tSC,..Flags.SetAt(0,$List(tElemI)))
	}
	
	Set tOptionInfo=..OptionInfo()
	Set tPtrI=0 While $ListNext(tOptionInfo,tPtrI,tElemI) {
		$$$THROWONERROR(tSC,..Options.SetAt("",$List(tElemI)))
	}
	
	// PATCHED PATCH
	Do ..SetFlag("OLDDIFFCOLLECTION",1)
	
	Quit $$$OK
}

Method Repr() As %String
{
	Quit $This_" flags:"_..SetFlags()_"; options:"_..SetOptions()
}

Method SetFlags() As %String
{
	Set tFlagNames=..FlagNames()
	
	Set tOut=""
	Set tPtrI=0 While $ListNext(tFlagNames,tPtrI,tElemI) {
		If ..IsFlagSet(tElemI) {
			Set tOut=tOut_$ListBuild(tElemI)
		}
	}
	
	Quit $ListToString(tOut)
}

Method SetOptions() As %String
{
	Set tOptionNames=..OptionNames()
	
	Set tOut=""
	Set tPtrI=0 While $ListNext(tOptionNames,tPtrI,tElemI) {
		Set tValue=..GetOptionValue(tElemI)
		If tValue'="" {
			Set tOut=tOut_$ListBuild(tElemI_"="_tValue)
		}
	}
	
	Quit $ListToString(tOut)
}

Method Clone() As Config
{
	Set tNewConfig=##class(Config).%New()
	
	Set tK="" While 1 {
		Set tK=..Flags.Next(tK) If tK="" {Quit}
		$$$THROWONERROR(tSC,tNewConfig.Flags.SetAt(..Flags.GetAt(tK),tK))
	}
	
	Set tK="" While 1 {
		Set tK=..Options.Next(tK) If tK="" {Quit}
		$$$THROWONERROR(tSC,tNewConfig.Options.SetAt(..Options.GetAt(tK),tK))
	}
	
	Quit tNewConfig
}

Method IsFlagSet(pFlag As %String) As %Boolean [ CodeMode = expression ]
{
..Flags.GetAt(pFlag)
}

Method SetFlag(pFlag As %String, pSetting As %Boolean)
{
	$$$THROWONERROR(tSC,..Flags.SetAt(pSetting,pFlag))
}

Method FlagNames() As %List [ CodeMode = expression ]
{
..JustNames(..FlagInfo())
}

Method FlagInfo() As %List [ CodeMode = expression ]
{
$ListBuild(
	$LB("ERRORTRAP", "don't trap errors in shell, allow them to be debugged"),
	$LB("TIMECOMMANDS", "show how long each command takes to run"),
	$LB("FINDALLMATCHINGSCHEMAS", "don't stop at the first matching schema for a message - find them all"),
	$LB("LOGBRANCH", "log Branch operations"),
	$LB("LOGCONTROL", "log Control operations"),
	$LB("LOGOPTIMIZE", "log optimization of NFA"),
	$LB("LOGGENERATED", "list NFA before and after optimization"),
	$LB("ALLGRAPHS", "show graphs for nodes and nfa as they are created"),
	$LB("DEPTHFIRST", "process branches in order rather than maintaining all lexers around the same position"),
	$LB("LOGREMAINING", "after a failure, log the last succeeding element in the NFA and what remains in the message"),
	$LB("GRAPHREMAINING", "after a failure, show a graph for what follows the last succeeding element in the NFA"),
	$LB("LOGAPPENDZ", "log operations determining a pattern to match appended Z-segments"),
	$LB("ENABLEAPPENDZ", "enable the append-Z extension"),
	$LB("SCANNINGCONTROL", "use scanning control instead of matching control"),
	$LB("LOGSCANNINGCONTROL", "log scanning control working"),
	$LB("ENABLESCANEXTENSION", "enable the Scan extension"),
	$LB("GRAPHSCANNINGCONTROL", "show ScanningControl graph for each run"),
	$LB("ABSTRACTMESSAGES", "allow messages which do not begin with 'MSH'"),
	$LB("IDENTIFYLISTMESSAGES", "list all mismatching messages in identify run"),
	$LB("MAKELIGHTMESSAGEFILES", "in Identify (.I) command: make new message files with only unique messages"),
	$LB("LOGALLDIFFCASES", "list all diff-cases in message report (otherwise capped at 10) and show original records too"),
	$LB("LOGALLREJECTEDMESSAGES", "list all messages rejected by the loader because they don't match the expected format")	,
	$LB("COMPRESSTOTREE","encode repeated items into tree structures"),
	$LB("LOGABSTRACTSTRINGS", "log details of AbstractStrings[Collection] working"),
	$LB("GRAPHABSTRACTSTRINGS", "show graph for AbstractStringsCollection working"),
	$LB("SHOWALLDERIVERESULTS", "show derived results other than the 'best' ones"),
	$LB("MERGEADTMESSAGES", "group all ADT_XXX message types together when deriving schemas"),
	$LB("CHECKDERIVEDPATTERNS", "check derived patterns against diff records"),
	$LB("CHECKDERIVEDPATTERNSDETAIL", "check derived patterns against diff records while heuristics are applied and tree-optimization is performed"),
	$LB("LIMITDIFFCHANGES", "derive pattern using only some parts of the diff records"),
	$LB("LOGSCANEXTENSION", "log behavior of Scan extension"),
	$LB("LOGIDENTIFY", "log .I message-processing messages"),
	$LB("MESSAGETYPEONLY", "only process messages which have a message type"),
	$LB("OLDDIFFCOLLECTION", "use old DiffCollection class (temporary flag)")
	)
}

Method GetOptionValue(pOption As %String) As %String [ CodeMode = expression ]
{
..Options.GetAt(pOption)
}

Method SetOptionValue(pOption As %String, pSetting As %String)
{
	$$$THROWONERROR(tSC,..Options.SetAt(pSetting,pOption))
}

Method OptionNames() As %List [ CodeMode = expression ]
{
..JustNames(..OptionInfo())
}

Method OptionInfo() As %List [ CodeMode = expression ]
{
$ListBuild(
	$LB("OUTLIERTHRESHOLD","a fraction which determines when messages are rejected as outliers - e.g. 0.05 to reject up to 5%"),
	$LB("MESSAGESKIPCOUNT", "process every N'th message in message files (for sampling a message corpus)"),
	$LB("MESSAGESKIPCOUNTPROC", "MessageProcessor should process every N'th message (better sampling of a message corpus)"),
	$LB("MESSAGETYPEMAPPINGS", "comma-delimited list of MESSAGETYPE=SCHEMA where MESSAGETYPE can be a wildcard ending with ""*"" and SCHEMA can be empty"),
	$LB("BRANCHCOUNTLIMIT", "how many control branches can be active at any one time - default 15"),
	$LB("BRANCHTOTALLIMIT", "how many control branches in total can be used for any one scan - default 150")
	)
}

Method SettingsGlobalInfo() As %List [ CodeMode = expression ]
{
$ListBuild(
	$LB("ALLOWEXECUTE", "set at *compile* time to allow '!XXX' syntax in the shell to execute ObjectScript code"),
	$LB("DOTPATH", "where to write .dot files (graphs)"),
	$LB("MESSAGESDIR", "directory used for '.I @' and '.R @'"),
	$LB("NOSCANZ", "don't process messages ending with Z-segments in the Scan extension"), 
	$LB("SCRIPTPATH", "default folder for shell scripts (<<xxx)"),
	$LB("SHOWGRAPHS", "whether to automatically show graphs when generated")
	)
}

Method SetExtensionOption(pOptionName As %String, pOptionValue As %String)
{
	If pOptionValue="" {
		Do ..ExtensionOptions.RemoveAt(pOptionName)
	}
	Else {
		$$$THROWONERROR(tSC,..ExtensionOptions.SetAt(pOptionValue,pOptionName))
	}
}

Method GetExtensionOption(pOptionName As %String) As %String [ CodeMode = expression ]
{
..ExtensionOptions.GetAt(pOptionName)
}

Method SchemaName(pSchema As %String) As %String
{
	If pSchema'[",",pSchema'["~" {
		Quit pSchema
	}
	
	Quit ..NewSchemaName()
}

Method NewSchemaName() As %String [ Private ]
{
	Set ..NewSchemaNameIndex=..NewSchemaNameIndex+1
	Quit "UNK_"_##class(Common).LZ(..NewSchemaNameIndex,4)
}

ClassMethod JustNames(pInfo As %List) As %List [ Private ]
{
	Set tOut=""
	Set tPtrI=0 While $ListNext(pInfo,tPtrI,tElemI) {
		Set tOut=tOut_$ListBuild($List(tElemI))
	}
	
	Quit tOut
}

}
