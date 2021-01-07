/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.HL7, EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Message)

Include EnsHL7

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Generate.Validate Extends %RegisteredObject
{

ClassMethod MakeMessage(pMessageFilePath As %String, pVersion As %String = "", pSchemaName As %String = "", Output pValidSC As %Status) As Message
{
	Set pValidSC=$$$OK
	
	Set pMessageObj=##class(Message).ImportFromLibraryStream(##class(Common).ReadFileStream(pMessageFilePath))
	
	If pSchemaName="" {	
		Set tMessageText=##class(Common).FileContents(pMessageFilePath)
		Set tSimpleMessage=##class(SimpleMessage).%New(tMessageText)
		Set tAssociatedSchema=..MessageTypeToSchemaName(tSimpleMessage,pVersion)
		If tAssociatedSchema="" {
			Set pValidSC=$$$ERROR($$$GeneralError,"No schema obtainable from messagetype")
			Quit ""
		}
		Set tFullSchema=tAssociatedSchema
	}
	Else {
		Set tFullSchema=$Select(pSchemaName[":":pSchemaName,1:pVersion_":"_pSchemaName)
	}
	
	Kill %objlasterror
	Set pMessageObj.DocType=tFullSchema
	Set pValidSC=$Get(%objlasterror,$$$OK)
	
	Quit pMessageObj
}

ClassMethod MessageTypeToSchemaName(pSimpleMessage As SimpleMessage, pVersion As %String = "") As %String
{
	Set tMSHSegment=pSimpleMessage.SegmentByIndex(1)
	Set tMessageTypeComps=pSimpleMessage.AccessComps(tMSHSegment,9,1,2)
	Set tMessageType=$List(tMessageTypeComps)_"_"_$List(tMessageTypeComps,2)
	Set tUseVersion=##class(Common).SchemaVersion(pVersion)
	Quit $Select(tMessageType="_":"",1:$Get($$$vaSchemaGbl(tUseVersion,"MT",tMessageType)))
}

}
