/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Analysis, EnsLib.InteropTools.HL7.MessageAnalyzer.Test, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Extend, EnsLib.InteropTools.HL7.MessageAnalyzer.Message, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging, EnsLib.InteropTools.HL7.MessageAnalyzer.Monitor, EnsLib.InteropTools.HL7.MessageAnalyzer.Common, EnsLib.InteropTools.HL7.MessageAnalyzer.Union, EnsLib.InteropTools.HL7.MessageAnalyzer.API, EnsLib.InteropTools.HL7.MessageAnalyzer.Validation)

Include (EnsHL7, EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.Output)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Shell.RigImpl Extends %RegisteredObject
{

Property Config As Config [ Private ];

Property Logger As Logger [ Private ];

Property Version As %String [ Private ];

Property RigSchemas As RigSchemaCollection [ Private ];

Property Shortcuts As %String [ MultiDimensional, Private ];

Method %OnNew() As %Status
{
	Set ..Config=##class(Config).%New()
	Set ..Logger=##class(Logger).%New("",0,..Config)
	Set ..RigSchemas=##class(RigSchemaCollection).%New()
	
	Do ##class(StrategyManager).SetExtensionOptions(..Config)	
	
	Quit $$$OK
}

/// Returns inputs to queue
Method ProcessInput(In As %String) As %List
{
	If ..Config.IsFlagSet("ERRORTRAP") {
		Quit ..ProcessInputImpl(In)
	}
	
	Else {
		Try {
			Return ..ProcessInputImpl(In)
		}
		
		Catch (ex) {
			Write !!,"Exception: ",ex.DisplayString(),!!
			Return ""
		}
	}
}

/// Returns inputs to queue
Method ProcessInputImpl(In As %String) As %List [ Private ]
{
	If $Extract(In,1,2)="<<" {
		Quit ..LoadScriptFile($$$TRIM($Extract(In,3,*)))
	}

	Set tStartTime=$ZH
	
	If $Extract(In)="." {
	
		// Shortcuts
		If In'=".","0123456789"[$Extract(In,2) {
			Set shortcutid=$Extract(In,2)
			If $Extract(In,3)="=" {
				Set ..Shortcuts(shortcutid)=$$$TRIM($Piece(In,"=",2,*))
				Write "Defined .",shortcutid,!
				Quit ""
			}
			Else {
				If $Data(..Shortcuts(shortcutid),shortcutexpansion) {
					Quit $ListBuild(shortcutexpansion)
				}
				Else {
					Write "No shortcut defined for .",shortcutid,!
					Quit ""
				}
			}
		}
	
		Do ..Command($Extract(In,2,*))
	}
	ElseIf $Extract(In)="?" {
		Do ..ShowInfo(In)
	}
	ElseIf $$$TRIM(In)="" {
		//
	}
	ElseIf $$$ALLOWEXECUTE,$Extract(In)="!" {
		Do ..Execute($$$TRIM($Extract(In,2,*)))
	}
	Else {
		Do ..ProcessSchemaSelection(In)
	}
	
	Set tEndTime=$ZH
	
	If ..Config.IsFlagSet("TIMECOMMANDS") {
		Write "Time: ",tEndTime-tStartTime,"s",!
	}
	
	Quit ""
}

Method ProcessSchemaSelection(In As %String) [ Private ]
{
	If $Extract(In)="+" {
		Set usein=$Extract(In,2,*)
	}
	Else {
		Set usein=In
		Do ..RigSchemas.Clear()
	}
	
	Do ##class(Common).ProcessSchemaSelection(usein,..RigSchemas,..Version,..Config,..Logger,0)
		
	Write:$X ! Write ..RigSchemas.Count()," schema(s) now loaded - use '?' to summarize, '??' for detail",!
}

Method Command(In As %String)
{
	#Dim command,args,failurecount,raw
	
	Set command=$$$TOUP($$$TRIM($Piece(In," "))),args=$$$TRIM($Piece(In," ",2,*))
	
	// Flags
	If command="F" {
		Do ..CommandFlags(args)
	}
	
	// Options
	ElseIf command="O" {
		Do ..CommandOptions(args)
	}
	
	// Version
	ElseIf command="V" {
		Do ..CommandVersion(args)
	}
	
	// Graph
	ElseIf command="G" {
		Do ..CommandGraph(args)
	}
	
	// Graph Show
	ElseIf command="GS" {
		Do ..CommandGraphShow(args)
	}
	
	// Run
	ElseIf command="R" {
		Do ..CommandRun(args)
	}
	
	// Test
	ElseIf command="T" {
		Set failurecount=##class(BasicTest).AllTests(..Logger) + ##class(AbstractStringsTest).AllTests(..Config,..Logger) + ##class(ScanningTest).AllTests(..Logger) + ##class(PatternOptimizeTest).AllTests(..Logger)
		$$$LOGOUTPUT1(..Logger,$Case(failurecount,0:"All tests passed",1:"1 test failed",:failurecount_" tests failed"))
	}
	
	// Simplify
	ElseIf command="S" {
		Set raw=##class(Common).ParseSchemaSpec(args)
		If raw="" {
			$$$LOGOUTPUT1(..Logger,"Schema not found in version "_##class(Common).SchemaVersion(..Version)_": "_args)
		}
		Else {
			$$$LOGOUTPUT(..Logger,$ListBuild(raw,"=>",##class(Common).SimplifyRawSchema(raw)))
		}
	}
	
	// Complify ;-)
	ElseIf command="C" {
		$$$LOGOUTPUT(..Logger,$ListBuild(args,"=>",##class(Common).PutBackSquiggles(args)))
	}
	
	// Identify
	ElseIf command="I" {
		Do ..CommandIdentify(args)
	}
	
	// Load and analyze abstract patterns from file
	ElseIf command="L" {
		Do ..CommandLoad(args)
	}
	
	// Batch
	ElseIf command="B" {
		Do ##class(EnsLib.InteropTools.HL7.MessageAnalyzer.API.Batch).IniAnalyzeMessages(args)
	}
	
	// Distribute
	ElseIf command="D" {
		Do ..CommandDistribute(args)
	}
	
	// Union
	ElseIf command="U" {
		Do ..CommandUnion(args)
	}
	
	// Examine
	ElseIf command="E" {
		Do ..CommandExamine(args)
	}
	
	// Alternatives
	ElseIf command="A" {
		Do ..CommandAlternatives(args)
	}
	
	// Validate
	ElseIf command="VAL" {
		Do ..CommandValidate(args)
	}
	
	// Configuration Changes
	ElseIf command="CC" {
		Do ..CommandConfigChange(args)
	}
	
	// Optimize
	ElseIf command="OPT" {
		Do ..CommandOptimize(args)
	}
	
	// .. anything else ..
	Else {
		If command'="",command'="?" {
			$$$LOGOUTPUT(..Logger,$ListBuild("- unknown .command",""))
		}
		Do ..ShellHelp()
	}
}

/// Output not written to session
Method ListFlags()
{
	#Dim i
	#Dim flagnames As %List
	
	Set flaginfo=..Config.FlagInfo()
	Set tPtrI=0 While $ListNext(flaginfo,tPtrI,tElemI) {
		Write " ",$List(tElemI)," = ",..Config.IsFlagSet($List(tElemI))," -- ",$List(tElemI,2),!
	}
}

/// Output not written to session
Method ListOptions()
{
	#Dim i
	#Dim optionnames As %List
	
	Set optioninfo=..Config.OptionInfo()
	Set tPtrI=0 While $ListNext(optioninfo,tPtrI,tElemI) {
		Write " ",$List(tElemI)," = """,..Config.GetOptionValue($List(tElemI)),""" -- ",$List(tElemI,2),!
	}
}

Method CommandFlags(Args As %String)
{
	
	#Dim flagname,setting
	
	If Args="" {
	
		Set setflagnames=""
		Set ptr=0 While $ListNext(..Config.FlagNames(),ptr,flagname) {
			If ..Config.IsFlagSet(flagname) {
				Set setflagnames=setflagnames_$ListBuild(flagname)
			}
		}
		
		If setflagnames="" {
			$$$LOGOUTPUT1(..Logger,"No flags are currently set")
		}
		Else {
			$$$LOGOUTPUT1(..Logger,"Set flags: "_$ListToString(setflagnames,", "))
		}
	}
	
	ElseIf Args="*" {
		Do ..ListFlags()
	}
	
	Else {
	
		Set arglist=$ListFromString(Args)
		Set ptr=0 While $ListNext(arglist,ptr,onearg) {
		
			Set flagname=$ZCvt($Piece(onearg,"="),"U"),setting=$Piece(onearg,"=",2)
	
			If '$ListFind(..Config.FlagNames(),flagname) {
				$$$LOGOUTPUT1(..Logger,"- flag '"_flagname_"' not found")
				Do ..ListFlags()
				Quit
			}
			
			If setting="" {
				Do ..Config.SetFlag(flagname,'..Config.IsFlagSet(flagname))
			}
			Else {
				Do ..Config.SetFlag(flagname,setting)
			}
			
			$$$LOGOUTPUT1(..Logger,flagname_" is now "_$Select(..Config.IsFlagSet(flagname):"enabled",1:"disabled"))
		}
	}
}

Method CommandOptions(Args As %String)
{
	
	#Dim flagname,setting
	
	If Args="" {
		Do ..ListOptions()
	}
	Else {
		Set optionname=$ZCvt($Piece(Args,"="),"U"),setting=$Piece(Args,"=",2,*)
		If '$ListFind(..Config.OptionNames(),optionname) {
			$$$LOGOUTPUT1(..Logger,"- option not found")
			Do ..ListOptions()
		}
		Else {
			Do ..Config.SetOptionValue(optionname,setting)
			$$$LOGOUTPUT1(..Logger,optionname_" is now """_..Config.GetOptionValue(optionname)_"""")
		}	
	}
}

Method CommandVersion(Args As %String)
{
	
	Set tOldVersion=..Version
	
	If Args="" {
		$$$LOGOUTPUT1(..Logger,"Version setting: "_..Version)
	}
	ElseIf $ZCvt(Args,"U")="NONE" {
		Set ..Version=""
		$$$LOGOUTPUT1(..Logger,"Version setting cleared")
	}
	ElseIf Args="?" {
		Write "HL7 versions:"
		Set tK="" While 1 {
			Set tK=$Order($$$vaSchemaGbl(tK),-1) If tK="" {Quit}
			Write " ",tK
		}
		Write !
	}		
	Else {
		If '$Data($$$vaSchemaGbl(Args)) {
			$$$LOGOUTPUT1(..Logger,"This is not an HL7 version in Ensemble: "_Args)
		}
		Else {
			Set ..Version=Args
			$$$LOGOUTPUT1(..Logger,"Version set: "_..Version)
		}
	}
	
	// if the version was changed and there were loaded schemas ..
	If ..Version'=tOldVersion,..RigSchemas.Count() > 0 {
	
		// clear loaded schemas
		Do ..RigSchemas.Clear()
		$$$LOGOUTPUT1(..Logger,"(schemas loaded for version "_##class(Common).SchemaVersion(tOldVersion)_" have been cleared)")
	}
}

Method CommandGraph(Args As %String)
{
	Set doneany=0
	For i=1:1:$Length(Args," ") {
		Set arg=$ZCvt($Piece(Args," ",i),"U")
		If arg'="" {
			If arg="NODE" {
				Do ..CheckTopNode()
				Set tKey="" While 1 {
					Set tKey=..RigSchemas.NextByName(tKey) If tKey="" {Quit}
					Do ..RigSchemas.GetByName(tKey).GraphNode()
				}
				Set doneany=1
			}
			ElseIf arg="NFA" {
				Set tKey="" While 1 {
				Set tKey=..RigSchemas.NextByName(tKey) If tKey="" {Quit}
					Do ..RigSchemas.GetByName(tKey).GraphNFA()
				}
				Set doneany=1
			}
			Else {
				$$$LOGOUTPUT1(..Logger,"Unknown graph: "_arg)
			}
		}
	}
	
	If 'doneany {
		$$$LOGOUTPUT1(..Logger,"Valid graph names are NODE and NFA")
	}
}

Method CommandGraphShow(Args As %String)
{
	#Dim i,arg
	
	For i=1:1:$Length(Args," ") {
		Set arg=$Piece(Args," ",i)
		If arg'="" {
			Do ##class(Common).ShowExistingDigraph(arg,..Config)
		}
	}
}

Method CommandRun(Args As %String)
{
	#Dim path,messagetext,succcount,failcount,dashes,failureoutcome
	#Dim file,folder As %File
	#Dim query As %SQL.Statement
	#Dim rs As %SQL.StatementResult
	#Dim tSC As %Status
	
	Do ..CheckTopNode()
	
	Set tProcessor=##class(RunMessageProcessor).%New(..RigSchemas,..Config,..Version,..Logger,0)
	Kill tRejectedMessages
	Do tProcessor.ScanMessages(Args,..Config.IsFlagSet("ABSTRACTMESSAGES"),..Config.GetOptionValue("OUTLIERTHRESHOLD"),,.tRejectedMessages,0)
	Set $ListBuild(tSuccessCount,tFailureCount)=tProcessor.Results()
	Write "Success: ",tSuccessCount,", failure: ",tFailureCount,!
	If $Get(tRejectedMessages) {
		Write tRejectedMessages," rejected messages",!
		If ..Config.IsFlagSet("LOGALLREJECTEDMESSAGES") {
			For tI=1:1:tRejectedMessages {
				Write tI,": ",tRejectedMessages(tI),!
			}
		}
	}
}

Method CommandIdentify(Args As %String)
{
	// if there are no schemas loaded ..
	If ..RigSchemas.Count()=0 {
	
		// load all schemas
		Do ..ProcessSchemaSelection("*")
	}
	
	Set tKey="" While 1 {
		Set tKey=..RigSchemas.NextByName(tKey) If tKey="" {Quit}
		Do ..RigSchemas.GetByName(tKey).CheckNFABuilder()
	}
	
	If Args="" {
		$$$LOGOUTPUT1(..Logger,"- expected message, @file, or @folder to process all files in folder")
		Quit
	}
	
	Set quiet='..Config.IsFlagSet("LOGCONTROL")
	
	If $$$TOUP($Extract(Args,1,2))="C@" {
		Set combine=1
		Set sourceArgs=$Extract(Args,2,*)
	}
	Else {
		Set combine=0
		Set sourceArgs=Args
	}
		
	Set tUseLogger=$Select(..Config.IsFlagSet("LOGIDENTIFY"):..Logger,1:##class(Logger).NullLogger())
		
	Set tErr=##class(Identify).%New(..Config,tUseLogger,..Version,..RigSchemas).ShellIdentify(sourceArgs,combine,quiet)
			
	// report session summary
	$$$LOGOUTPUT1(..Logger,"")
	$$$LOGOUTPUT1(..Logger,"Summary Report")
	Do ##class(SummaryReport).RunReport($$$MAS.SessionId,$$$MAS.RunId,..Logger)
	
	If tErr'="" {
		Write tErr,!
	}
}

Method CommandDistribute(Args As %String)
{
	If ..Version="" {
		Write "The shell version must be set using .V before using .D",!
		Quit
	}
	
	// parse arguments
	Kill tFlags
	Set tErr=..ParseDistributeArgs($Translate(Args,$Char(9)," "),.tSource,.tTarget,.tFlags)
	If tErr'="" {
		Write tErr,!
		Quit
	}
	
	Kill tRejectedMessages
	Set tErr=##class(Distribute).%New(..Config,..Logger).ShellDistribute(tSource,tTarget,..Version,"",.tFlags,0,.tRejectedMessages)
	If $Get(tRejectedMessages) {
		Write tRejectedMessages," rejected messages:",!
		For tI=1:1:tRejectedMessages {
			Write " ",$Extract(tRejectedMessages(tI),1,30),"...",!
		}
	}
	If tErr'="" {
		Write tErr,!
		Quit
	}
}

Method CommandUnion(Args As %String)
{
	// parse arguments
	Kill tFlags
	Set tErr=..ParseUnionArgs($Translate(Args,$Char(9)," "),.tPath,.tFlags)
	If tErr'="" {
		Write tErr,!
		Quit
	}
	
	Set tVersion=##class(Common).SchemaVersion($Get(tFlags("V"),""))
	Set tMessageType=$Get(tFlags("T"),"")
	Set tOmitMatching=$Get(tFlags("M"),0)
	Set tListMessages=$Get(tFlags("L"),0)
	Set tQuiet=$Get(tFlags("Q"),0)
	
	$$$IFSESSION0(StartRun)
	$$$IFSESSION0(StartScan)
	
	Do ##class(Process).%New(tVersion,..Config,..Logger,tQuiet).Process(tPath,tMessageType,tOmitMatching,tListMessages)
}

Method CommandExamine(Args As %String)
{
	// parse arguments
	Kill tFlags
	Set tErr=..ParseExamineArgs($Translate(Args,$Char(9)," "),.tPlainArgs,.tFlags)
	If tErr'="" {
		Write tErr,!
		Quit
	}
	
	Set tVersion=##class(Common).SchemaVersion($Get(tFlags("V"),..Version))
	Set tCompareSchema=$Get(tFlags("S"),"")
	Set tBestMatches=$Get(tFlags("B"),0)
	
	If tBestMatches,tCompareSchema="" {
		Write "Examine: if -b is used then -s must be too",!
		Quit
	}
	
	Set tUseVersion=##class(Common).SchemaVersion(tVersion)
	
	If tBestMatches {
		Set tOut=""
		Set tPtr=0 While $ListNext(tPlainArgs,tPtr,tOneArg) {
			Set tOut=tOut_##class(Common).SchemaSourceList(tOneArg,tUseVersion)
		}
		Write "Comparing with: ",$ListToString(tOut),!		
		Set tBestMatches=##class(PatternUtils).BestMatchingSchemas(tCompareSchema,tUseVersion,tOut)
		If tBestMatches="" {
			Write "No best matches",!
		}
		Else {
			Write "Best matches with score ",$List(tBestMatches,2),": ",$ListToString($List(tBestMatches)),!
		}
	}
	Else {
		Set tPtr=0 While $ListNext(tPlainArgs,tPtr,tOneArg) {
			Do ..ListSchemas(tOneArg,tUseVersion,tCompareSchema)
		}
	}
}

Method CommandAlternatives(Args As %String)
{
	// parse arguments
	Kill tFlags
	Set tErr=..ParseAlternativesArgs($Translate(Args,$Char(9)," "),.tPlainArgs,.tFlags)
	If tErr'="" {
		Write tErr,!
		Quit
	}

	Set tProcess=$Get(tFlags("P"),0)
	Set tList=$Get(tFlags("L"),0)
	Set tMatch=$Get(tFlags("M"),0)
	Set tGenerate=$Get(tFlags("G"),0)
	
	Set version=##class(Common).SchemaVersion(..Version)

	If tMatch {
		$$$IFSESSION0(StartRun)
		$$$LOGOUTPUT1(..Logger,"Session #"_$$$MAS.SessionId_" run #"_$$$MAS.RunId_" begins")
	}	
	
	Set tPtr=0 While $ListNext(tPlainArgs,tPtr,tArg) {
	
		If $ListLength(tPlainArgs)>1 {
			Write !,tArg,!
		}
		
		Set raw=##class(Common).ParseSchemaSpec(tArg)
	
		Set rawnv=##class(Common).WithoutVersionPrefixes(raw,version)
		
		If rawnv="" {
			$$$LOGOUTPUT1(..Logger,"Schema not found in version "_version_": "_tArg)
		}
		Else {
			$$$LOGOUTPUT(..Logger,$ListBuild(rawnv,"=>",##class(Common).SimplifyRawSchema(rawnv)))
			
			Set tNode=##class(Common).CompileSchema(rawnv)
			Kill tAlternatives
			
			Do ##class(PatternUtils).PatternAlternatives(tNode,.tAlternatives)
			Write +$Get(tAlternatives)," messages generated",!
			
			// -l1 and -m1 => match+list ..
			If tList,tMatch {
				Do ..AlternativesMatch(rawnv,1,.tAlternatives)
			}
			
			// .. -l1 => list generated messges ..
			ElseIf tList {
				For tI=1:1:$Get(tAlternatives) {
					Write tAlternatives(tI),!
				}
			}
			
			// .. -m1 => match generated messages against original schema ..
			ElseIf tMatch {	
				Do ..AlternativesMatch(rawnv,0,.tAlternatives)
			}
			
			// -p1 => process (Union) generated messges
			If tProcess {
			
				Kill tMessageArray
				Set tMessageType="mt"
				For tI=1:1:$Get(tAlternatives) {
					Set tMessageArray(tMessageType,tI)=$ListFromString(tAlternatives(tI))
				}
				
				Set tOmitMatchingMessages=0
				Set tProcess=##class(Process).%New(..Version,..Config,..Logger,0) // currently not quiet
				Do tProcess.ProcessMessageType("(shell)",tMessageType,tOmitMatchingMessages,1,.tMessageArray)
			}
			
			If tGenerate {
				Kill tGeneratedMessages
				Do ..GenerateFromAlternatives(.tAlternatives,.tGeneratedMessages)
				If '$Data(tGeneratedMessages) {
					Write "No generated messages",!
				}
				Else {
					Write "Generated messages:",!
					Set tMessage="" While 1 {
						Set tMessage=$Order(tGeneratedMessages(tMessage)) If tMessage="" {Quit}
						Write " ",tMessage,!
					}
				}
			}
		}
	}
}

Method CommandValidate(Args As %String)
{
	// parse arguments
	Kill tFlags
	Set tErr=..ParseValidateArgs($Translate(Args,$Char(9)," "),.tSchema,.tMessageSource,.tFlags)
	If tErr'="" {
		Write tErr,!
		Quit
	}
	
	// parse schema, name
	If tSchema[":" {
		Set tVersion=$Piece(tSchema,":")
		Set tSchemaName=$Piece(tSchema,":",2)
	}
	Else {
		Set tVersion=##class(Common).SchemaVersion(..Version)
		Set tSchemaName=tSchema
	}
	
	Set tMessageSourceReader=##class(MessageSourceReader).%New(tMessageSource,10)
		
	Set tRawValSpec=$Get(tFlags("V"))
	Set tValSpec=$Select(tRawValSpec="":"1",1:tRawValSpec)
	Set tListAll=$Get(tFlags("L"),0)
	Set tDebuggingMode=$Get(tFlags("D"),0) // undocumented
	
	Do ##class(ShellValidate).%New(tVersion_":"_tSchemaName,tMessageSourceReader,tValSpec,tListAll,tDebuggingMode).ShellValidate()
}

Method CommandConfigChange(Args As %String)
{
	// parse arguments
	Kill tFlags
	Set tErr=..ParseConfigChangeArgs($Translate(Args,$Char(9)," "),.tFlags)
	If tErr'="" {
		Write tErr,!
		Quit
	}
	
	Set tGivenDateRange=$$$TOUP($Get(tFlags("D"),"T"))
	Set tOutput=$Get(tFlags("O"),"")

	Set $ListBuild(tStartDate,tEndDate)=$$daterange(tGivenDateRange)
	If tOutput="" {
		Set tLogger=##class(Logger).%New()
	}
	Else {
		Set tOutputStream=##class(Common).WriteFileStream(tOutput,$Char(10))
		Set tLogger=##class(Logger).%New(tOutputStream,1)
	}
	
	Do ##class(ConfigChangeLog).DescribeRangeOfDays(tStartDate,tEndDate,tLogger)
	
	Quit
	
daterange(given)
	If given="ALL" {Quit $ListBuild("","")}
	If (given="T") || (given="TODAY") {Set today=$ZDate($H,3) Quit $ListBuild(today,today)}
	If given[":" {Quit $ListFromString(given,":")}
	Quit $ListBuild(given,given)
}

Method CommandOptimize(Args As %String)
{
	If $$$TRIM(Args)="" {
		Write " - expected a schema pattern as argument",!
		Quit
	}
	
	Do ##class(PatternUtils).Optimize(Args,1)
}

Method CommandLoad(Args As %String)
{
	#Dim path
	
	Set path=Args
	If '##class(%File).Exists(path) {
		$$$LOGOUTPUT1(..Logger," - "_path_" is not a file")
	}
	
	Set filetext=$ZStrip(##class(Common).FileContents(path),"*",$Char(13))
	Set csv=filetext[","
	Set lines=$ListFromString(filetext,$Char(10))

	Set tAS=##class(EnsLib.InteropTools.HL7.MessageAnalyzer.Analysis.AbstractStrings).%New(lines,csv,..Config,..Logger)
	Do tAS.GetCollections(.tCollections)

	// for each collection, ignoring outlier collections
	Set tPatterns=""
	For tI=1:1:tCollections {
		Set tColl=tCollections(tI)
		Set $ListBuild(tError,tOnePattern)=tColl.DerivePattern("Collection"_tI)
		If tError="" {
			Set tPatterns=tPatterns_$ListBuild(tOnePattern)
		}
		Else {
			$$$LOGOUTPUT1(..Logger,"Failed to derive pattern for '"_tColl.ShowCLIList()_"': "_tError)
		}
	}
	
	If tPatterns="" {
		$$$LOGOUTPUT1(..Logger,"No patterns derived")
	}
	Else {
		$$$LOGOUTPUT1(..Logger,##class(Common).ListToPattern(tPatterns))
	}
}

Method ShowSettings()
{
	Do ..ShowGlobalSettings()
	
	If $Data(..Shortcuts)\10 {
		Write !,"Shortcuts:",!
		Set shortcutid="" While 1 {
			Set shortcutid=$Order(..Shortcuts(shortcutid),+1,shortcutexpansion) If shortcutid="" {Quit}
			Write " .",shortcutid,"=",shortcutexpansion,!
		}
	}
}

ClassMethod ShowGlobalSettings() [ Private ]
{
	If '$$$ANYGLOBALSETTINGS {
		Write "No global settings",!
	}
	Else {
		Write "Global settings in "_$$$GLOBALSETTINGSNAME_":",!
		Set tKey="" While 1 {
			Kill tData
			Set tKey=$Order($$$GLOBALSETTING(tKey),+1,tData) If tKey="" {Quit}
			Write " ",tKey
			If $Data(tData) {
				Write " = ",tData
			}
			If $Data($$$GLOBALSETTING(tKey))\10 {
				Write " ..."
			}
			Write !
		}
	}
}

Method Execute(pCOS As %String) [ Private ]
{
	#Dim tErr As %Exception.AbstractException
	
	Try {
		Xecute pCOS
	}
	Catch (tErr) {
		Use 0
		Write !,$$$STATUS(tErr.AsStatus()),!
	}
}

ClassMethod LoadScriptFile(pInputLine As %String) As %List [ Private ]
{
	Kill tFreeArgs
	Kill tFlags
	Set tErr=##class(ArgumentParser).%New("Script","").ParseArguments(pInputLine,.tFreeArgs,.tFlags)
	If tErr'="" {
		Write tErr,!
		Quit ""
	}
	
	If '$Get(tFreeArgs) {
		Quit ""
	}
	
	Set tInputFile=tFreeArgs(1)	
	Set tRawInput=..InputFromScriptFile(tInputFile)
	
	Set tInput=$Select(
		tFreeArgs>1:..SubstituteScriptArgs(tRawInput,.tFreeArgs,2),
		1:tRawInput)
		
	Quit tInput
}

ClassMethod InputFromScriptFile(pInputFile As %String) As %List [ Private ]
{
	// the extension MUST be .shell - if the path doesn't end with it then this code appends it
	Set tFile=$Select($$EndsWith(pInputFile,".shell"):pInputFile,1:pInputFile_".shell")
	
	// default folder for scripts
	If $Data($$$GLOBALSETTING("SCRIPTPATH"),tScriptPath)#10 {
		Set tPath=##class(%File).NormalizeFilename(tFile,tScriptPath)
	}
	Else {
		Set tPath=tFile
	}
	
	// check file existence
	If '##class(%File).Exists(tPath) {
		Write "Script file not found: ",tPath,!
		Quit ""
	}
	
	// open the script file and collect the lines in tInputs
	Set tInputStream=##class(Common).ReadFileStream(tPath)
	Set tInputs=""
	While 'tInputStream.AtEnd {
		Set tLine=tInputStream.ReadLine(,.tSC) If $$$ISERR(tSC) {$$$ThrowStatus(tSC)}
		Set tInputs=tInputs_$ListBuild(tLine)
	}
	
	// show the user the script lines
	Set tResult=""
	Write "Inputs:",!
	Set tPtrI=0 While $ListNext(tInputs,tPtrI,tItemI) {
		If $$$TRIM(tItemI)'="" {
			Write tItemI,!
			Set tResult=tResult_$ListBuild(tItemI)
		}
	}
	Write "--",!!
	
	// return the script lines
	Quit tResult
	
EndsWith(str,endstr)
	Quit $Extract(str,*-($Length(endstr)-1),*)=endstr
}

ClassMethod SubstituteScriptArgs(pRawInput As %List, ByRef pArgs, pArgStart As %Integer = 1) As %List [ Private ]
{
	Set tOut=""
	Set tPtr=0 While $ListNext(pRawInput,tPtr,tLine) {
		Set tOut=tOut_$ListBuild(..SubstituteLine(tLine,.pArgs,pArgStart))
	}
	
	Quit tOut
}

ClassMethod SubstituteLine(pLine As %String, ByRef pArgs, pArgStart As %Integer = 1) As %String [ Private ]
{
	If pLine'["`" {
		Quit pLine
	}
	
	Set tParts=$ListFromString(pLine,"`")
	Set tOut=$List(tParts)
	Set tRestParts=$List(tParts,2,*)
	Set tPtr=0 While $ListNext(tRestParts,tPtr,tElem) {
		If tElem'="","123456789"[$Extract(tElem) {
			Set tOut=tOut_$Get(pArgs($Extract(tElem)+pArgStart-1))_$Extract(tElem,2,*)
		}
		Else {
			Set tOut=tOut_"`"_tElem
		}
	}
	
	Quit tOut
}

Method ShowInfo(pIn As %String) [ Private ]
{
	If ..RigSchemas.Count()=0 {
		Write "No schemas are currently loaded",!
	}
	Else {
		Set tLimit=5
		Set tShouldLimitOutput=(pIn'="??")
		Set tI=0
		Set tKey="" While 1 {
			Set tKey=..RigSchemas.NextByName(tKey) If tKey="" {Quit}
			Set tI=tI+1
			If tShouldLimitOutput,tI>tLimit {
				Write "... ",(..RigSchemas.Count()-tI+1)," more schema(s) - to list all schemas use '??'",!
				Quit
			}
			Set tSchemaDef=..RigSchemas.GetByName(tKey)
			Write tSchemaDef.GetSchemaName(),": ",tSchemaDef.GetSchemaSpec(),!
		}
	}
	
	Write "(enter .? for help on shell commands)",!
}

ClassMethod ListSchemas(pSchemaSpecs As %String, pVersion As %String, pCompareSchema As %String) [ Private ]
{
	Set tSpecList=$ListFromString(pSchemaSpecs," ")
	Set tPtr=0 While $ListNext(tSpecList,tPtr,tRawSpec) {
		Set tSpec=$$$TRIM(tRawSpec)
		If tSpec'="" {
			Do ..ListSchemaSpec(tSpec,pVersion,pCompareSchema)
		}
	}
}

ClassMethod ListSchemaSpec(pSpec As %String, pVersion As %String, pCompareSchema As %String) [ Private ]
{
	If $Extract(pSpec,*)="*" {
		Set tPrefix=$Extract(pSpec,1,*-1)
		If tPrefix'="",$Data($$$vaSchemaGbl(pVersion,"MS",tPrefix)) {
			Do ..ListOneSchema(tPrefix,pVersion,pCompareSchema)
		}
		Set tKey=tPrefix
		Set tLenPrefix=$Length(tPrefix)
		While 1 {
			Set tKey=$Order($$$vaSchemaGbl(pVersion,"MS",tKey)) If tKey="" {Quit}
			If $Extract(tKey,1,tLenPrefix)'=tPrefix {Quit}
			Do ..ListOneSchema(tKey,pVersion,pCompareSchema)
		}
	}
	Else {
		If $Data($$$vaSchemaGbl(pVersion,"MS",pSpec)) {
			Do ..ListOneSchema(pSpec,pVersion,pCompareSchema)
		}
		Else {
			Write " - schema '",pSpec,"' not found in version ",pVersion,!
		}
	}
}

ClassMethod ListOneSchema(pSchemaName As %String, pVersion As %String, pCompareSchema As %String) [ Private ]
{
	Set tRawSchemaSource=##class(Common).SimplifyRawSchema($$$vaSchemaGbl(pVersion,"MS",pSchemaName))
	Set tSchemaSource=##class(Common).WithoutVersionPrefixes(tRawSchemaSource,pVersion)
	Write !,pSchemaName,": ",tSchemaSource,!
	If pCompareSchema'="" {
		Write " - commonality score is ",##class(PatternUtils).PatternCommonality(pCompareSchema,tSchemaSource),!
	}
}

Method CheckTopNode() [ Private ]
{
	If ..RigSchemas.Count()=0 {Throw ##class(%Exception.General).%New("No schema has been compiled")}
}

/// Returns either an error message or "" 
ClassMethod ParseDistributeArgs(pArgs As %String, Output pSource As %String, Output pDest As %String, Output pFlags) As %String [ Private ]
{
	$$$SHOULDBEUNDEF(pFlags)

	Kill tFreeArgs
	Set tErr=##class(ArgumentParser).%New("Distribute","KDMCQ").ParseArguments(pArgs,.tFreeArgs,.pFlags)
	If tErr'="" {
		Quit tErr
	}
	
	If $Get(tFreeArgs)<2 {
		Quit "Distribute: source and destination are required"
	}
	
	If $Get(tFreeArgs)>2 {
		Quit "Distribute: too many non-flag arguments - expected just source and destination"
	}
	
	Set pSource=tFreeArgs(1)
	Set pDest=tFreeArgs(2)
	
	Quit ""
}

/// Returns either an error message or "" 
ClassMethod ParseUnionArgs(pArgs As %String, Output pPath As %String, Output pFlags) As %String [ Private ]
{
	$$$SHOULDBEUNDEF(pFlags)

	Kill tFreeArgs
	Set tErr=##class(ArgumentParser).%New("Union","QVTML").ParseArguments(pArgs,.tFreeArgs,.pFlags)
	If tErr'="" {
		Quit tErr
	}
	
	If $Get(tFreeArgs)<1 {
		Quit "Union: message source file/folder path is required"
	}
	
	If $Get(tFreeArgs)>1 {
		Quit "Union: too many non-flag arguments - expected just messages source"
	}
	
	Set pPath=tFreeArgs(1)
	
	Quit ""
}

/// Returns either an error message or "" 
ClassMethod ParseExamineArgs(pArgs As %String, Output pPlainArgs As %List, Output pFlags) As %String [ Private ]
{
	$$$SHOULDBEUNDEF(pFlags)

	Kill tFreeArgs
	Set tErr=##class(ArgumentParser).%New("Examine","VSB").ParseArguments(pArgs,.tFreeArgs,.pFlags)
	If tErr'="" {
		Quit tErr
	}
	
	If $Get(tFreeArgs)<1 {
		Quit "Examine: at least one schema name or partial name is required"
	}
	
	Set pPlainArgs=""
	For tI=1:1:tFreeArgs {
		Set pPlainArgs=pPlainArgs_$ListBuild(tFreeArgs(tI))
	}
	
	Quit ""
}

/// Returns either an error message or "" 
ClassMethod ParseAlternativesArgs(pArgs As %String, Output pPlainArgs As %List, Output pFlags) As %String [ Private ]
{
	$$$SHOULDBEUNDEF(pFlags)

	Kill tFreeArgs
	Set tErr=##class(ArgumentParser).%New("Alternatives","PLMG").ParseArguments(pArgs,.tFreeArgs,.pFlags)
	If tErr'="" {
		Quit tErr
	}
	
	If $Get(tFreeArgs)<1 {
		Quit "Alternatives: at least one schema name or partial name is required"
	}
	
	Set pPlainArgs=""
	For tI=1:1:tFreeArgs {
		Set pPlainArgs=pPlainArgs_$ListBuild(tFreeArgs(tI))
	}
	
	Quit ""
}

Method AlternativesMatch(pSchemaSpec As %String, pListMessages As %Boolean, ByRef pAlternatives) [ Private ]
{
	$$$IFSESSION0(StartRun)
	$$$IFSESSION0(StartScan)

	Set tIdentifyMessages=##class(IdentifyMessages).%New(..Config,..Logger,..Version)
	Do tIdentifyMessages.LoadSchemas(pSchemaSpec)
	Set (tMatchedCount,tMismatchedCount)=0
	For tI=1:1:$Get(pAlternatives) {
		If pListMessages {
			Write pAlternatives(tI),!
		}
		If tIdentifyMessages.IdentifyMatchingSchemas(pAlternatives(tI),1)'="" {
			If $I(tMatchedCount)
			If pListMessages {
				Write " - matched",!
			}
		}
		Else {
			If $I(tMismatchedCount)
			If pListMessages {
				Write " - matched",!
			}
		}
	}
	Write tMatchedCount," matches, ",tMismatchedCount," mismatches",!
}

ClassMethod GenerateFromAlternatives(ByRef pAlternatives, Output pGeneratedMessages) [ Private ]
{
	$$$SHOULDBEUNDEF(pGeneratedMessages)
	
	For tI=1:1:$Get(pAlternatives) {
		Do ..GeneratedFromAlternativesOne(pAlternatives(tI),.pGeneratedMessages)
	}
}

ClassMethod GeneratedFromAlternativesOne(pMessageString As %String, Output pGeneratedMessages) [ Private ]
{
	Set tGenerateCount=3
	Set tChangeCount=1
	
	For tI=1:1:tGenerateCount {
		Set pGeneratedMessages(..MutateMessage(pMessageString,tChangeCount))=""
	}
}

ClassMethod MutateMessage(pMessageString As %String, pChangeCount As %Integer) As %String [ Private ]
{
	Set tMessage=pMessageString
	For tI=1:1:pChangeCount {
	
		Set tPosition=$Random($Length(pMessageString,",")-1)+2
		
		Set tOperation=$Random(3)
		
		// insert
		If tOperation=0 {
			Set tMessage=$Piece(tMessage,",",1,tPosition)_",III,"_$Piece(tMessage,",",tPosition+1,*)
		}
		
		// delete
		ElseIf tOperation=1 {
			Set tMessage=$Piece(tMessage,",",1,tPosition-1)_","_$Piece(tMessage,",",tPosition+1,*)
		}
		
		// replace
		Else {
			Set $Piece(tMessage,",",tPosition-1)="RRR"
		}
	}
	
	Quit tMessage
}

/// Returns either an error message or "" 
ClassMethod ParseValidateArgs(pArgs As %String, Output pSchema As %String, Output pMessageSource As %String, Output pFlags) As %String [ Private ]
{
	$$$SHOULDBEUNDEF(pFlags)

	Kill tFreeArgs
	Set tErr=##class(ArgumentParser).%New("Validate","VLD").ParseArguments(pArgs,.tFreeArgs,.pFlags)
	If tErr'="" {
		Quit tErr
	}
	
	If $Get(tFreeArgs)<2 {
		Quit "Validate: schema and messages source arguments are required"
	}
	
	If $Get(tFreeArgs)>2 {
		Quit "Validate: too many non-flag arguments - expected just schema and messages source"
	}
	
	Set pSchema=tFreeArgs(1)
	Set pMessageSource=tFreeArgs(2)
	
	Quit ""
}

/// Returns either an error message or "" 
ClassMethod ParseConfigChangeArgs(pArgs As %String, Output pFlags) As %String [ Private ]
{
	$$$SHOULDBEUNDEF(pFlags)

	Kill tFreeArgs
	Set tErr=##class(ArgumentParser).%New("Validate","DO").ParseArguments(pArgs,.tFreeArgs,.pFlags)
	If tErr'="" {
		Quit tErr
	}
	
	If $Get(tFreeArgs)>0 {
		Quit "Validate: no non-flag arguments were expected"
	}
	
	Quit ""
}

/// Output not written to session
Method ShellHelp() [ Private ]
{
	
	Write "'^', 'exit', 'quit' or 'q' exits",!
	Write !
	Write "Anything else which does not begin with '?' or '.' is taken to be one or more schema specs separated by '+' characters.",!
	Write !
	Write "A schema spec can be entered as one of the following:",!
	Write "- raw schema text",!
	Write "- simplified schema format (sequencing '~'s become ','s, all other '~'s are simply removed)",!
	Write "- the name of an Ensemble schema",!
	Write "- a prefix of an Ensemble schema name followed by '*'",!
	Write !
	Write "Start a line with '+' to load new schema(s) without clearing existing ones",!
	Write !
	Write "?                   - list up to 5 loaded schemas",!
	Write "??                  - list all loaded schemas",!
	Write !
	Write ".?                  - this help",!
	Write ".F FLAGNAME=SETTING - set debugging flag, SETTING is 0 or 1, omit SETTING to toggle",!
	Write "                    - multiple arguments (separated by commas) can be given",!
	Write ".F *                - list flag names and their settings",!
	Write ".F                  - list the names of flags which are currently set to 1",!
	Write ".O OPTIONNAME=SETTING - set an option",!
	Write ".O                  - list option names and their settings",!
	Write ".V VERSION          - auto-prefix unprefixed message codes with ""VERSION:""",!
	Write ".V                  - show version setting",!
	Write ".V NONE             - clear version setting",!
	Write ".V ?                - list HL7 versions present in Ensemble",!
	Write !
	Write ".G WHICH            - compute and optionally show a graph (SHOWGRAPHS in global), each argument is one of:",!
	Write "                      - NFA: the current NFA",!
	Write "                      - NODE: the current node tree",!
	Write ".GS BASEFILENAME    - show a graph file which has already been computed - e.g. '.GS Collection1'",!
	Write ".R MESSAGE          - run the NFA(s) on the given comma-separated list of message type codes",!
	Write ".R @FILE            - run the NFA(s) on the given message-file FILE",!
	Write ".R @FOLDER          - run the NFA(s) on every message-file in FOLDER",!
	Write ".R @                - run on the default folder in the configuration",!
	Write ".T                  - run regression tests",!
	Write ".S RAWSPEC          - show simplified form of given schema spec",!
	Write ".C SPEC             - show schema spec form of given simplified form",!
	Write ".I MESSAGE          - identify the given comma-separated list of message type codes against the loaded NFA(s)",!
	Write "                      - multiple comma-separated messages can be given using ""+"" as a delimiter",!
	Write ".I @FILE            - identify the given message-file FILE against the loaded NFA(s)",!
	Write ".I @FOLDER          - identify every message-file (separately) in FOLDER against the loaded NFA(s)",!
	Write ".I C@FOLDER         - identify every message-file (combined) in FOLDER against the loaded NFA(s)",!
	Write ".I @                - identify message-files in the default folder in the configuration against the loaded NFA(s)",!
	Write !
	Write ".B FILE             - run a batch message analysis, using FILE as the ini-style configuration file (see EnsLib.InteropTools.HL7.MessageAnalyzer.API.Batch class)",!
	Write !
	Write ".D FLAGS SRC DST    - distribute messages from SRC to DST",!
	Write "                      FLAGS is a list of optional arguments of the form -XYYY where X is a letter identifying the flag and YYY is the value",!
	Write "                         -kKEYSPEC .. KEYSPEC must be one of S, R or S...R where '...' can be anything that doesn't contain a space",!
	Write "                         -dBOOLEAN .. pass -d0 to select file-based target format",!
	Write "                         -mBOOLEAN .. pass -m1 to distribute by message type as well as by facility",!
	Write "                         -cBOOLEAN .. pass -c0 to get a report for each message source (doesn't affect file actions)",!
	Write "                         -qBOOLEAN .. pass -q0 for more output",!
	Write "                         ... BOOLEAN is either 0 or 1",!	
	Write "                      SRC is a file/folder containing messages",!
	Write "                      DST is a folder which must *NOT* currently exist",!
	Write !
	Write ".U FLAGS MESSAGES   - perform union analysis of file/folder MESSAGES",!
	Write "                      FLAGS is a list of optional arguments of the form -XYYY where X is a letter identifying the flag and YYY is the value",!
	Write "                         -vVERSION .. sets HL7 version to use - default is shell version",!
	Write "                         -tTYPE    .. if given, only messages with message type TYPE are processed",!
	Write "                         -mBOOLEAN .. pass -m1 to omit messages which match the schema associated with the message type",!
	Write "                         -lBOOLEAN .. pass -l1 to list all original messages",!
	Write "                         -qBOOLEAN .. pass -q1 for less output",!
	Write !
	Write ".E FLAGS SCHEMASPEC .. - examine schemas whose name matches or equals any of the arguments",!
	Write "                         FLAGS is a list of optional arguments of the form -XYYY where X is a letter identifying the flag and YYY is the value",!
	Write "                             -vVERSION      .. sets HL7 version to use - default is shell version",!
	Write "                             -vSCHEMASOURCE .. reference schema source to compare",!
	Write "                             -bBOOLEAN      .. pass 1 to find 'best' matching schemas to the reference schema",!
	Write !
	Write ".A FLAGS SCHEMASPEC .. show message alternatives for the given schema(s)",!
	Write "                         FLAGS is a list of optional arguments of the form -XYYY where X is a letter identifying the flag and YYY is the value",!
	Write "                             -pBOOLEAN      .. pass 1 to process the alternative-messages using Union",!
	Write "                             -lBOOLEAN      .. pass 1 to list the alternative-messages",!
	Write "                             -mBOOLEAN      .. pass 1 to match alternative-messages against the given schema",!
	Write "                             -gBOOLEAN      .. pass 1 to generate variants of the alternative-messages",!
	Write !
	Write ".OPT PATTERN        .. optimize the given pattern",!
	Write !
	Write ".VAL FLAGS SCHEMA MESSAGES .. validate the given messages against the given schema",!
	Write "                              FLAGS is a list of optional arguments of the form -XYYY where X is a letter identifying the flag and YYY is the value",!
	Write "                                   -vXXXX     .. XXXX is the flags (valspec) to pass to the HL7 validator, if not given it defaults to '1'",!        
	Write "                                   -lBOOLEAN  .. pass 1 to list all validation messages, not just the matched ones",!        
	//                                        -d1        .. set debugging mode (undocumented)
	Write "                              SCHEMA is the name of the schema to use, optionally with a 'VERSION:' prefix",!
	Write "                              MESSAGES is the name of a file or folder containing messages",!
	Write !
	Write ".CC FLAGS           .. list config changes",!
	Write "                              FLAGS is a list of optional arguments of the form -XYYY where X is a letter identifying the flag and YYY is the value",!
	Write "                                   -dXXXX .. specifies the dates to show: A/ALL for all, T/TODAY for today, YYYY-MM-DD for that date,YYYY-MM-DD:YYYY-MM-DD for a range of dates",!
	Write "                                             - -dTODAY is the default",!
	Write "                                   -oXXXX .. specifies a target file to write the output to - if not given then output is to the screen",! 
	Write !
	Write ".L FILE             - load and analyze abstract patterns from FILE",!
	Write !
	Write "<< FILE             - process shell inputs from FILE.shell",!
	Write "                      - the actual script file MUST have the .shell extension but you need not include the "".shell"" after the ""<<""",!
	Write "                      - the FILE - or any other argument - must be enclosed in ""..."" if it contains spaces",!
	Write "                      - further arguments following FILE may be given, separated by spaces; the script refers to arguments using `1, `2 etc., up to `9",! 
	Write !
	Write ".N=COMMAND          - where N is a single decimal digit: defines .N as a shortcut for running COMMAND",!
	Write ".N                  - executes the command defined as shortcut .N",!
	Write !
	Write "Multiple entries of any of the above can be entered on a single line by separating entries with a ';'",!
	Write !
	Do ..ShowSettings()
}

/// Back door for Rig class
Method GetConfigOption(pOptionName As %String) As %String [ CodeMode = expression ]
{
..Config.GetOptionValue(pOptionName)
}

}
