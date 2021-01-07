/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer.Shell

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Logging.Logger Extends %RegisteredObject
{

Property OutputStream As %Stream.Object [ Private ];

Property SaveOnClose As %Boolean [ Private ];

Property Config As Config [ Private ];

Method %OnNew(pOutputStream As %Stream.Object = "", pSaveOnClose As %Boolean = 0, pConfig As Config) As %Status
{
	Set i%OutputStream=pOutputStream
	Set ..SaveOnClose=pSaveOnClose
	Set ..Config=$Select($Data(pConfig)&&$IsObject(pConfig):pConfig,1:##class(Config).%New())
	Quit $$$OK
}

ClassMethod NullLogger() As Logger [ CodeMode = expression ]
{
##class(Logger).%New(##class(%Stream.NullCharacter).%New(),0)
}

Method %OnClose() As %Status
{
	If i%OutputStream'="",..SaveOnClose {
		$$$THROWONERROR(tSC,i%OutputStream.%Save())
	}
}

Method OutputListToLog(pList As %List, pSecondArgDoNotUse)
{
	$$$ACASSERT('$Data(pSecondArgDoNotUse),"Logger: extra args passed to OutputListToLog method")
	
	Set tPtr=0 While $ListNext(pList,tPtr,tLine) {
		Do ..OutputToLog(tLine)
	}
}

Method OutputToLog(pLine As %String, pSecondArgDoNotUse)
{
	$$$ACASSERT('$Data(pSecondArgDoNotUse),"Logger: extra args passed to OutputToLog method")
	
	If i%OutputStream="" {
		Write pLine,!
	}
	Else {
		$$$THROWONERROR(tSC,i%OutputStream.WriteLine(pLine))
	}
}

Method OutputListToLogIfFlag(pList As %List, pFlagName As %String)
{
	If ..Config.IsFlagSet(pFlagName) {
		Do ..OutputListToLog(pList)
	}
}

Method ShowStream(pDescription)
{
	If i%OutputStream'="" {
		Write !,"-----",!,pDescription,!
		$$$THROWONERROR(tSC,i%OutputStream.Rewind())
		If i%OutputStream.AtEnd {
			Write " - empty",!
		}
		Else {
			Do {
				Set tLine=i%OutputStream.ReadLine(,.tSC)
				If $$$ISERR(tSC) {$$$ThrowStatus(tSC)}
				Write tLine,!
			} While 'i%OutputStream.AtEnd
		}
	}
}

Method Dump()
{
	Write "Logger",!
	Write " output to ",$Select(i%OutputStream="":"terminal",1:"stream"),!
	Write " saveonclose=",..SaveOnClose,!
	Write " config=",..Config.Repr(),!
}

}
