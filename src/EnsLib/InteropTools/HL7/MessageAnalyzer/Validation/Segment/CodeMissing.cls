/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Validation flags: t
Class EnsLib.InteropTools.HL7.MessageAnalyzer.Validation.Segment.CodeMissing Extends SegmentValidationBase
{

Property Value As %String [ Private ];

Property CodeTable As %String [ Private ];

Property Segment As %String [ Private ];

Property FieldIndex As %Integer [ Private ];

Property ComponentIndex As %Integer [ Private ];

Property SubcomponentIndex As %Integer [ Private ];

Property HL7Message As Message [ Private ];

Method %OnNew(pChangeKey As %List, pCleanedStatusMessage As %String, pArgs As %List) As %Status
{
	Set ..ChangeKey=pChangeKey
	Set ..CleanedStatusMessage=pCleanedStatusMessage
	Set ..Value=$List(pArgs)
	Set ..Segment=$List(pArgs,2)
	Set ..FieldIndex=$List(pArgs,3)
	Set ..ComponentIndex=$List(pArgs,5)
	Set ..SubcomponentIndex=$List(pArgs,6)
	Set ..CodeTable=$List(pArgs,7)
	Set ..HL7Message=""
	Quit $$$OK
}

Method AddMessageImpl(pArgs As %List, pHL7Message As Message)
{
	If ..HL7Message="" {
		Set ..HL7Message=pHL7Message
	}
}

ClassMethod RegisterPatterns(Output pRecords)
{
	$$$SHOULDBEUNDEF(pRecords)

	$$$RPPATTERN("ErrGeneral: Invalid value")
	$$$RPADDRECORD(" '([^']+)' appears in segment ([^,]+), field ([^,]+), repetition ([^,]+), component ([^,]+), subcomponent ([^,]+), but does not appear in code table (.+)\.","CodeMissing",$ListBuild("Value","Segment","Field","Repetition","Component","Subcomponent","CodeTable"))
}

ClassMethod OperationKey(pArgs As %List) As %List
{
	Quit $ListBuild("CTAddCode")_$List(pArgs,1,1)_$List(pArgs,7,7)
}

Method BeforePrompt(pHL7Configuration As HL7Configuration) As %List
{
	Set tMessage=..WhitespaceMessage(pHL7Configuration)
	Quit $Select(tMessage="":"",1:$ListBuild(tMessage))
}

Method FixPrompt(pHL7Configuration As HL7Configuration) As %String [ CodeMode = expression ]
{
"Add code '"_..Value_"' to "_$$$CTINFO
}

Method GetFixTarget() As %List [ CodeMode = expression ]
{
$ListBuild("CT",..CodeTable)
}

Method FixConfiguration(pHL7Configuration As HL7Configuration, pConfigChangeLog As ConfigChangeLog) As %String
{
	$$$ACASSERT('##class(HL7Configuration).ExistsInCodeTable(..CodeTable,..Value),"CodeMissing: configuration already updated")

	Do pHL7Configuration.AddToCodeTable(..CodeTable,..Value) // add the code to the table
	
	Do pConfigChangeLog.LogChange(..%ClassName(1),"","CT",..CodeTable,..Value,0,1)
	
	Quit "Updated "_$$$CTINFO_": added code '"_..Value_"'"
}

Method FixConfigurationCompound(pHL7Configuration As HL7Configuration, pConfigChangeLog As ConfigChangeLog, pCustomVersion As %String, pSchemaName As %String, pLogger As Logger)
{
	$$$ACASSERT(..HL7Message'="","No message passed to CodeMissing object")
	
	Set tCompoundUpdate=##class(CompoundUpdate).%New(pHL7Configuration,pConfigChangeLog,pLogger)
	
	Set tSegmentIndex=$Piece(..Segment,":")
	Set tSegmentName=$Piece(..Segment,":",2)
	Set tRet=tCompoundUpdate.CodeMissingFix(..HL7Message,pCustomVersion,pSchemaName,tSegmentIndex,tSegmentName,..FieldIndex,..ComponentIndex,..SubcomponentIndex,..CodeTable,..Value)
	If tRet'="" {
		Do pLogger.OutputToLog("ERROR: "_tRet)
	}
}

ClassMethod DescribeChange(pHL7Configuration As HL7Configuration, pClassArgs As %String, pCategory As %String, pSubCategory As %String, pItem As %String, pOldData As %String, pNewData As %String) As %List [ CodeMode = expression ]
{
$ListBuild("Code table "_pSubCategory_": add code '"_pItem_"'",##class(HL7Configuration).ExistsInCodeTable(pSubCategory,pItem))
}

/// If the code has leading or trailing whitespace return a message warning the user about it; otherwise return ""
Method WhitespaceMessage(pHL7Configuration As HL7Configuration) As %String [ Private ]
{
	// strip whitespace from the code
	Set tTrimmedCode=$$$TRIM(..Value)
	If tTrimmedCode=..Value {
		Quit ""  // no whitespace around the code
	}
	
	Set tBasicMessage="WARNING: Missing code '"_..Value_"' begins and/or ends with whitespace"
	
	// if the stripped code is in the table ..
	If tTrimmedCode'="",##class(HL7Configuration).ExistsInCodeTable(..CodeTable,tTrimmedCode) {
		Quit tBasicMessage_" but the code exists in the table without whitespace"
	}
	
	Quit tBasicMessage
}

}
