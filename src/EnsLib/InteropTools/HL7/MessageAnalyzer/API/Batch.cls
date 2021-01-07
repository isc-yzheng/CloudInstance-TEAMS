/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.API.Batch Extends %RegisteredObject
{

/// Given EITHER a path to an ini-style file OR an explicit string representing the ini-style file (string must contain at least one $Char(10))
/// <br> Analyze message files as given in the ini file and write reports to destinations specified in the ini file
/// <p>
/// <p> An ini file consists of <i>sections</i>, each containing one or more <i>key assignments</i>.
/// <br> - a <i>sections</i> is a section name in square brackets
/// <br> - a <i>key assignment</i> is of the form <b>KEY=VALUE</b>
/// <p>
/// <p> The ini file in this case has two types of section: <i>SETUP</i> and <i>MESSAGES</i>
/// <p>
/// <p> Just one <i>SETUP</i> section can appear in the ini file.  It has the following keys:
/// <ul>
/// <li> DEBUG - controls extra logging - default is 0 (no extra logging)
/// <li> SCHEMASPEC - a list or wildcard specification of schemas to load (format as in the shell) - if omitted the schemas are loaded for each message file as specified in the <i>MESSAGES</i> section
/// <li> SETFLAGS - a comma-separated list of flag names to be set (as in the shell) - if omitted: no flags are set
/// <li> BASEPATH - a path to a directory which is used as a base path for file specs in the ini file - if omitted the effective base path is the current working directory
/// </ul>
/// <p>
/// <p> Any number of <i>MESSAGES</i> sections can appear in the ini file.  Each has the following keys:
/// <ul>
/// <li> MESSAGEFILE - file or folder containing HL7 messages (possibly stripped down)
/// <li> QUIET - controls reporting level - default is 1 (minimal reporting)
/// <li> SCHEMASPEC - like the SCHEMASPEC in the <i>SETUP</i> section but applies only to these messages
/// <li> COMBINE - determins whether source message files are combined and analyzed together - default is 0 (don't combine)
/// <li> LOGOUTPUT - target file for general logging output - default is to log to the current device
/// <li> OUTPUT - target file for structured output of analysis records - default is to output this to the current device
/// </ul>
ClassMethod IniAnalyzeMessages(pIniFileSource As %String)
{
	//[SETUP]
	//	DEBUG:<0>
	//	SCHEMASPEC:<>
	//	SETFLAGS:<>
	//  BASEPATH:<> (default is no base path)
	//[MESSAGES]
	//	MESSAGEFILE:
	//  QUIET:<1>
	//	SCHEMASPEC:<>
	//  COMBINE:<0>
	//	LOGOUTPUT:<> (default is console)
	//	OUTPUT:<> (default is console)
	
	Set tSectionSpec="SETUP,MESSAGES*"
	
	If pIniFileSource[$Char(10) {
		Set tIniFile=##class(IniFile).FromString(tSectionSpec,pIniFileSource)
	}
	Else {
		Set tIniFile=##class(IniFile).FromFile(tSectionSpec,pIniFileSource)
	}
	
	// initial defaults for setup
	Kill tSetup
	Set tSetup("DEBUG")=0
	Set tSetup("SCHEMASPEC")="" // "" => NO schemas loaded - MESSAGES must specify this instead
	Set tSetup("SETFLAGS")=""
	Set tSetup("BASEPATH")=""
	
	// load SETUP section keys
	Do tIniFile.GetSingleSection("SETUP",.tSetup)
	
	// check base path (if it doesn't exist the call to NormalizeFileName returns "")
	If tSetup("BASEPATH")'="",'##class(%File).DirectoryExists(tSetup("BASEPATH")) {$$$THROW("BASEPATH setting is given but is not a valid directory - "_tSetup("BASEPATH"))}
	
	// load SETUP.SCHEMASPEC if given
	If tSetup("SCHEMASPEC")'="" {
		Set tSetupIdentifyMessages=##class(EnsLib.InteropTools.HL7.MessageAnalyzer.API.IdentifyMessages).%New()
		Do tSetupIdentifyMessages.LoadSchemas(tSetup("SCHEMASPEC"),'tSetup("DEBUG"))
	}
	
	// scan MESSAGES sections
	Set tMessageSectionCount=tIniFile.GetMultiSectionCount("MESSAGES")
	For tI=1:1:tMessageSectionCount {
	
		If tSetup("DEBUG") {
			Write "MESSAGES#",tI,!
		}

		// initial defaults for messages
		Kill tMessages
		Set tMessages("QUIET")=1
		Set tMessages("SCHEMASPEC")="" // "" => use SETUP.SCHEMASPEC
		Set tMessages("COMBINE")=0
		Set tMessages("LOGOUTPUT")=""
		Set tMessages("OUTPUT")=""
		
		// load MESSAGES section keys
		Do tIniFile.GetMultiSectionAtIndex("MESSAGES",tI,.tMessages)
		
		If '$Data(tMessages("MESSAGEFILE")) {$$$THROW("Missing MESSAGEFILE in section MESSAGES#"_tI)}
		
		Set tMessageSource=..InBasePath(tSetup("BASEPATH"),tMessages("MESSAGEFILE"))
		Set tQuiet=tMessages("QUIET")
		Set tCombine=tMessages("COMBINE") 		
		Set tFlags=$ListFromString(tSetup("SETFLAGS"))
		Set tOutput=##class(EnsLib.InteropTools.HL7.MessageAnalyzer.Logging.Logger).%New(..AsStream(tSetup("BASEPATH"),tMessages("OUTPUT")),1)
		Set tLogOutput=##class(EnsLib.InteropTools.HL7.MessageAnalyzer.Logging.Logger).%New(..AsStream(tSetup("BASEPATH"),tMessages("LOGOUTPUT")),1)

		// if there is NO message-level schema spec ..
		If tMessages("SCHEMASPEC")="" {
			
			// if there is NO setup-level schema spec either ..
			If tSetup("SCHEMASPEC")="" {
				$$$THROW("No SCHEMASPEC given for either SETUP or MESSAGES#"_tI_" section")
			}
			
			Set tIdentifyMessages=tSetupIdentifyMessages
		}
		
		// .. there IS a message-level schema spec ..
		Else {		
			Set tIdentifyMessages=##class(EnsLib.InteropTools.HL7.MessageAnalyzer.API.IdentifyMessages).%New()
			Do tIdentifyMessages.LoadSchemas(tMessages("SCHEMASPEC"),'tSetup("DEBUG"))
		}
		
		Do tIdentifyMessages.AnalyzeMessages(tMessageSource,tCombine,tFlags,tQuiet,tOutput,tLogOutput)
		
		If tSetup("DEBUG") {
			If tMessages("OUTPUT")'="" {
				Do tOutput.ShowStream("Primary Output")
			}
			If tMessages("LOGOUTPUT")'="" {
				Do tLogOutput.ShowStream("Log Output")
			}
		}		
	}
}

ClassMethod AsStream(pOptBasePath As %String, pOptPath As %String) As %Stream.Object [ CodeMode = expression, Private ]
{
$Select(pOptPath="":"",1:##class(Common).WriteFileStream(..InBasePath(pOptBasePath,pOptPath),$C(10)))
}

ClassMethod InBasePath(pOptBasePath As %String, pRelativePath As %String) As %String [ CodeMode = expression, Private ]
{
$Select(pOptBasePath="":pRelativePath,1:##class(%File).NormalizeFilename(pRelativePath,pOptBasePath))
}

}
