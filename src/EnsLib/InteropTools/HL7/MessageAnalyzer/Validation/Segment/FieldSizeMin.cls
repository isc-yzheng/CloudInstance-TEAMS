/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// This class covers validation errors reported for both field length and field repeat length.
/// This is because the changes to the data structure definition are the same in both cases.
/// 
/// Validation flags: l
Class EnsLib.InteropTools.HL7.MessageAnalyzer.Validation.Segment.FieldSizeMin Extends SegmentValidationBase
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
	Set ..MessageSummary=99999999
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
	If tSummary<..MessageSummary {
		Set ..MessageSummary=tSummary
	}
		
	If ..HL7Message="" {
		Set ..HL7Message=pHL7Message
	}
}

ClassMethod RegisterPatterns(Output pRecords)
{
	$$$SHOULDBEUNDEF(pRecords)
	
	$$$RPPATTERN("ErrGeneral: Field size minimum not met in segment")
	
	// 3 args
	$$$RPADDRECORD(" ([^\.]+)\.  Field ([^ ]+) is smaller than segment structure ([^ ]+) permits it to be\.","FieldSizeMin",$ListBuild("Segment","Field","SegmentStructure"))

	// 4 args
	$$$RPADDRECORD(" ([^\.]+)\.  Field ([^,]+), repetition ([^ ]+) is smaller than segment structure ([^ ]+) permits it to be\.","FieldSizeMin",$ListBuild("Segment","Field","Repetition","SegmentStructure"))
}

ClassMethod OperationKey(pArgs As %List) As %List
{
	If $ListLength(pArgs)=4 {
		Quit $ListBuild("SSSetFieldMinSize")_$List(pArgs,2,2)_$List(pArgs,4,4)
	}
	Else {
		Quit $ListBuild("SSSetFieldMinSize")_$List(pArgs,2,3)
	}
}

Method BeforePrompt(pHL7Configuration As HL7Configuration) As %List
{
	Set tExistingMinimum=##class(HL7Configuration).GetSegmentStructure(..SegmentStructure,..FieldIndex,$$$SSFMINLENGTH)
	
	Set tMinUsed=..MessageSummary
	Set tShortestFieldMessage="Shortest field given in a message is "_tMinUsed
	
	Quit $ListBuild(
		"Existing minimum for "_$$$SSINFO_" "_$$$FIELDINFO_" is "_tExistingMinimum,
		tShortestFieldMessage
	)
}

Method FixPrompt(pHL7Configuration As HL7Configuration) As %String [ CodeMode = expression ]
{
"Reduce the minimum size for "_$$$FIELDINFO_" in "_$$$SSINFO_" from "_##class(HL7Configuration).GetSegmentStructure(..SegmentStructure,..FieldIndex,$$$SSFMINLENGTH)_" to "_..MessageSummary
}

Method GetFixTarget() As %List [ CodeMode = expression ]
{
$ListBuild("SS",..SegmentStructure)
}

Method FixConfiguration(pHL7Configuration As HL7Configuration, pConfigChangeLog As ConfigChangeLog) As %String
{
	Set tMinUsed=..MessageSummary
	
	Set tOldValue=##class(HL7Configuration).GetSegmentStructure(..SegmentStructure,..FieldIndex,$$$SSFMINLENGTH)
	
	$$$ACASSERT(tOldValue>tMinUsed,"FieldSizeMin: configuration already updated")
	
	Do ##class(HL7Configuration).UpdateSegmentStructure(..SegmentStructure,..FieldIndex,$$$SSFMINLENGTH,tMinUsed) // set the field minimum size
	
	Do pConfigChangeLog.LogChange(..%ClassName(1),"","SS",..SegmentStructure,..FieldIndex,tOldValue,tMinUsed)	
	
	Quit "Updated "_$$$SSINFO_" definition for "_$$$FIELDINFO_": the field minimum length is now "_tMinUsed
}

Method FixConfigurationCompound(pHL7Configuration As HL7Configuration, pConfigChangeLog As ConfigChangeLog, pCustomVersion As %String, pSchemaName As %String, pLogger As Logger)
{
	$$$ACASSERT(..HL7Message'="","No message passed to FieldSizeMin object")
	
	Set tCompoundUpdate=##class(CompoundUpdate).%New(pHL7Configuration,pConfigChangeLog,pLogger)
	
	Set tSegmentIndex=$Piece(..Segment,":")
	Set tSegmentName=$Piece(..Segment,":",2)
	
	Set tRet=tCompoundUpdate.FieldSizeMinFix(..HL7Message,pCustomVersion,pSchemaName,tSegmentIndex,tSegmentName,..FieldIndex,..SegmentStructure,..MessageSummary)
	
	If tRet'="" {
		Do pLogger.OutputToLog("ERROR: "_tRet)
	}
}

ClassMethod DescribeChange(pHL7Configuration As HL7Configuration, pClassArgs As %String, pCategory As %String, pSubCategory As %String, pItem As %String, pOldData As %String, pNewData As %String) As %String [ CodeMode = expression ]
{
$ListBuild("Segment structure "_pSubCategory_": set minimum length for "_$$$FIELDINFOX(pHL7Configuration,pSubCategory,pItem)_" to "_pNewData_" (was "_pOldData_")",##class(HL7Configuration).GetSegmentStructure(pSubCategory,pItem,$$$SSFMINLENGTH))
}

}
