/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// This class covers validation errors reported for both field length and field repeat length.
/// This is because the changes to the data structure definition are the same in both cases.
/// 
/// Validation flags: l
Class EnsLib.InteropTools.HL7.MessageAnalyzer.Validation.Segment.FieldSizeMax Extends SegmentValidationBase
{

Property IsRepeat As %Boolean [ Private ];

Property FieldIndex As %Integer [ Private ];

Property SegmentStructure As %String [ Private ];

Property Segment As %String [ Private ];

Property HL7Message As Message [ Private ];

Method %OnNew(pChangeKey As %List, pCleanedStatusMessage As %String, pArgs As %List) As %Status
{
	Set ..ChangeKey=pChangeKey
	Set ..CleanedStatusMessage=pCleanedStatusMessage
	Set ..IsRepeat=($ListLength(pArgs)=4)
	If ..IsRepeat {
		Set ..FieldIndex=$List(pArgs,2)
		Set ..SegmentStructure=$List(pArgs,4)
		Set ..Segment=$List(pArgs)
	}
	Else {
		Set ..FieldIndex=$List(pArgs,2)
		Set ..SegmentStructure=$List(pArgs,3)
		Set ..Segment=$List(pArgs)
	}
	Set ..MessageSummary=0
	Quit $$$OK
}

Method AddMessageImpl(pArgs As %List, pHL7Message As Message)
{
	If ..IsRepeat {
		Set $ListBuild(tSegment,tFieldIndex,tRepetition,tSegmentStructure)=pArgs
		Set tSegmentIndex=$Piece(tSegment,":")
		Set tData=pHL7Message.GetValueAt(tSegmentIndex_":"_..FieldIndex_"("_tRepetition_")",,.tSC) $$$THROWONERROR(tSC,tSC)
	}
	Else {
		Set $ListBuild(tSegment,tFieldIndex,tSegmentStructure)=pArgs
		Set tSegmentIndex=$Piece(tSegment,":")
		Set tData=pHL7Message.GetValueAt(tSegmentIndex_":"_..FieldIndex,,.tSC) $$$THROWONERROR(tSC,tSC)
	}
	
	Set tSummary=$Length(tData)
	If tSummary>..MessageSummary {
		Set ..MessageSummary=tSummary
	}	
	
	If ..HL7Message="" {
		Set ..HL7Message=pHL7Message
	}
}

ClassMethod RegisterPatterns(Output pRecords)
{
	$$$SHOULDBEUNDEF(pRecords)
	
	$$$RPPATTERN("ErrGeneral: Field size restriction exceeded in segment")
	
	// 3 args
	$$$RPADDRECORD(" ([^\.]+)\.  Field ([^ ]+) is larger than segment structure ([^ ]+) permits it to be\.","FieldSizeMax",$ListBuild("Segment","Field","SegmentStructure"))

	// 4 args
	$$$RPADDRECORD(" ([^\.]+)\.  Field ([^,]+), repetition ([^ ]+) is larger than segment structure ([^ ]+) permits it to be\.","FieldSizeMax",$ListBuild("Segment","Field","Repetition","SegmentStructure"))
}

ClassMethod OperationKey(pArgs As %List) As %List
{
	If $ListLength(pArgs)=4 {
		Quit $ListBuild("SSSetFieldMaxSize")_$List(pArgs,2,2)_$List(pArgs,4,4)
	}
	Else {
		Quit $ListBuild("SSSetFieldMaxSize")_$List(pArgs,2,3)
	}
}

Method BeforePrompt(pHL7Configuration As HL7Configuration) As %List
{
	Set tExistingMaximum=##class(HL7Configuration).GetSegmentStructure(..SegmentStructure,..FieldIndex,$$$SSFMAXLENGTH)
	
	Set tMaxUsed=..MessageSummary
	Set tLongestFieldMessage="Longest field given in a message is "_tMaxUsed
	
	Quit $ListBuild(
		"Existing maximum for "_$$$SSINFO_" "_$$$FIELDINFO_" is "_tExistingMaximum,
		tLongestFieldMessage
	)
}

Method FixPrompt(pHL7Configuration As HL7Configuration) As %String [ CodeMode = expression ]
{
"Increase the maximum size for "_$$$FIELDINFO_" in "_$$$SSINFO_" from "_##class(HL7Configuration).GetSegmentStructure(..SegmentStructure,..FieldIndex,$$$SSFMAXLENGTH)_" to "_..MessageSummary
}

Method GetFixTarget() As %List [ CodeMode = expression ]
{
$ListBuild("SS",..SegmentStructure)
}

Method FixConfiguration(pHL7Configuration As HL7Configuration, pConfigChangeLog As ConfigChangeLog) As %String
{
	Set tMaxUsed=..MessageSummary
	
	Set tOldValue=##class(HL7Configuration).GetSegmentStructure(..SegmentStructure,..FieldIndex,$$$SSFMAXLENGTH)
	
	$$$ACASSERT(tOldValue<tMaxUsed,"FieldSizeMax: configuration already updated")
	
	Do ##class(HL7Configuration).UpdateSegmentStructure(..SegmentStructure,..FieldIndex,$$$SSFMAXLENGTH,tMaxUsed) // set the field maximum size
	
	Do pConfigChangeLog.LogChange(..%ClassName(1),"","SS",..SegmentStructure,..FieldIndex,tOldValue,tMaxUsed)	
	
	Quit "Updated "_$$$SSINFO_" definition for "_$$$FIELDINFO_": the field maximum length is now "_tMaxUsed
}

Method FixConfigurationCompound(pHL7Configuration As HL7Configuration, pConfigChangeLog As ConfigChangeLog, pCustomVersion As %String, pSchemaName As %String, pLogger As Logger)
{
	$$$ACASSERT(..HL7Message'="","No message passed to FieldSizeMax object")
	
	Set tCompoundUpdate=##class(CompoundUpdate).%New(pHL7Configuration,pConfigChangeLog,pLogger)
	
	Set tSegmentIndex=$Piece(..Segment,":")
	Set tSegmentName=$Piece(..Segment,":",2)
	
	Set tRet=tCompoundUpdate.FieldSizeMaxFix(..HL7Message,pCustomVersion,pSchemaName,tSegmentIndex,tSegmentName,..FieldIndex,..SegmentStructure,..MessageSummary)
	
	If tRet'="" {
		Do pLogger.OutputToLog("ERROR: "_tRet)
	}
}

ClassMethod DescribeChange(pHL7Configuration As HL7Configuration, pClassArgs As %String, pCategory As %String, pSubCategory As %String, pItem As %String, pOldData As %String, pNewData As %String) As %String [ CodeMode = expression ]
{
$ListBuild("Segment structure "_pSubCategory_": set maximum length for "_$$$FIELDINFOX(pHL7Configuration,pSubCategory,pItem)_" to "_pNewData_" (was "_pOldData_")",##class(HL7Configuration).GetSegmentStructure(pSubCategory,pItem,$$$SSFMAXLENGTH))
}

}
