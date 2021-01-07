/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// This class covers validation errors reported for both components and subcomponents.
/// This is because the changes to the data structure definition are the same in both cases.
/// 
/// Validation flags: i (component), w (subcomponent)
Class EnsLib.InteropTools.HL7.MessageAnalyzer.Validation.Segment.FieldComponentSizeMax Extends SegmentValidationBase
{

Property IsSubcomponent As %Boolean [ Private ];

Property ComponentIndex As %Integer [ Private ];

Property DataStructure As %String [ Private ];

Property Segment As %String [ Private ];

Property FieldIndex As %Integer [ Private ];

Property HL7Message As Message [ Private ];

Method %OnNew(pChangeKey As %List, pCleanedStatusMessage As %String, pArgs As %List) As %Status
{
	Set ..ChangeKey=pChangeKey
	Set ..CleanedStatusMessage=pCleanedStatusMessage
	Set ..IsSubcomponent=($ListLength(pArgs)=6)
	If ..IsSubcomponent {
		Set ..ComponentIndex=$List(pArgs,5) // actually the subcomponent as named in the status error message
		Set ..DataStructure=$List(pArgs,6)
		Set ..Segment=$List(pArgs)
		Set ..FieldIndex=$List(pArgs,2)
	}
	Else {
		Set ..ComponentIndex=$List(pArgs,4)
		Set ..DataStructure=$List(pArgs,5)
		Set ..Segment=$List(pArgs)
		Set ..FieldIndex=$List(pArgs,2)
	}
	Set ..MessageSummary=0
	Quit $$$OK
}

Method AddMessageImpl(pArgs As %List, pHL7Message As Message)
{
	If ..IsSubcomponent {
		Set $ListBuild(tSegment,tFieldIndex,tRepetition,tComponentIndex,tSubcomponent,tDataStructure)=pArgs
		Set tSegmentIndex=$Piece(tSegment,":")
		Set tData=pHL7Message.GetValueAt(tSegmentIndex_":"_tFieldIndex_"("_tRepetition_")."_tComponentIndex_"."_..ComponentIndex,,.tSC) $$$THROWONERROR(tSC,tSC)
	}
	Else {
		Set $ListBuild(tSegment,tFieldIndex,tRepetition,tComponentIndex,tDataStructure)=pArgs		
		Set tSegmentIndex=$Piece(tSegment,":")
		Set tData=pHL7Message.GetValueAt(tSegmentIndex_":"_tFieldIndex_"("_tRepetition_")."_..ComponentIndex,,.tSC) $$$THROWONERROR(tSC,tSC)
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

	// 5 args
	$$$RPPATTERN("ErrGeneral: Component size restriction exceeded in segment")
	$$$RPADDRECORD(" ([^\.]+)\.  Field ([^,]+), repetition ([^,]+), component ([^ ]+) is larger than data structure ([^ ]+) permits it to be\.","FieldComponentSizeMax",$ListBuild("Segment","Field","Repetition","Component","DataStructure"))
	
	// 6 args
	$$$RPPATTERN("ErrGeneral: Subcomponent size restriction exceeded in segment")
	$$$RPADDRECORD(" ([^\.]+)\.  Field ([^,]+), repetition ([^,]+), component ([^,]+), subcomponent ([^ ]+) is larger than data structure ([^ ]+) permits it to be\.","FieldComponentSizeMax",$ListBuild("Segment","Field","Repetition","Component","Subcomponent","DataStructure"))
}

ClassMethod OperationKey(pArgs As %List) As %String
{
	Quit $ListBuild("DSSetComponentMaxSize")_$List(pArgs,*,*) // the data structure and relevant component/subcomponent are the last two args for both component and subcomponent
}

Method BeforePrompt(pHL7Configuration As HL7Configuration) As %List
{
	Set tExistingMaximum=##class(HL7Configuration).GetDataStructure(..DataStructure,..ComponentIndex,$$$DTCMAXLENGTH)

	Set tMaxUsed=..MessageSummary
	Set tLongestComponentMessage="Longest component/subcomponent given in a message is "_tMaxUsed
	
	Quit $ListBuild(
		"Existing maximum for "_$$$DTINFO_" "_$$$COMPINFO_" is "_tExistingMaximum,
		tLongestComponentMessage
	)
}

Method FixPrompt(pHL7Configuration As HL7Configuration) As %String [ CodeMode = expression ]
{
"Increase the maximum size for "_$$$COMPINFO_" in "_$$$DTINFO_" from "_##class(HL7Configuration).GetDataStructure(..DataStructure,..ComponentIndex,$$$DTCMAXLENGTH)_" to "_..MessageSummary
}

Method GetFixTarget() As %List [ CodeMode = expression ]
{
$ListBuild("DT",..DataStructure)
}

Method FixConfiguration(pHL7Configuration As HL7Configuration, pConfigChangeLog As ConfigChangeLog) As %String
{
	Set tMaxUsed=..MessageSummary
	
	Set tOldValue=##class(HL7Configuration).GetDataStructure(..DataStructure,..ComponentIndex,$$$DTCMAXLENGTH)
	
	$$$ACASSERT(tOldValue<tMaxUsed,"FieldComponentSizeMax: configuration already updated")
	
	Do ##class(HL7Configuration).UpdateDataStructure(..DataStructure,..ComponentIndex,$$$DTCMAXLENGTH,tMaxUsed) // set the component maximum size
	
	Do pConfigChangeLog.LogChange(..%ClassName(1),"","DT",..DataStructure,..ComponentIndex,tOldValue,tMaxUsed)
	
	Quit "Updated "_$$$DTINFO_" definition for "_$$$COMPINFO_": the component maximum length is now "_tMaxUsed
}

Method FixConfigurationCompound(pHL7Configuration As HL7Configuration, pConfigChangeLog As ConfigChangeLog, pCustomVersion As %String, pSchemaName As %String, pLogger As Logger)
{
	$$$ACASSERT(..HL7Message'="","No message passed to FieldComponentSizeMax object")
	
	Set tCompoundUpdate=##class(CompoundUpdate).%New(pHL7Configuration,pConfigChangeLog,pLogger)
	
	Set tSegmentIndex=$Piece(..Segment,":")
	Set tSegmentName=$Piece(..Segment,":",2)
	
	Set tMaxUsed=..MessageSummary

	If ..IsSubcomponent {	
		Set tRet=tCompoundUpdate.FieldSizeMaxFixSubComp(..HL7Message,pCustomVersion,pSchemaName,tSegmentIndex,tSegmentName,..FieldIndex,..ComponentIndex,..DataStructure,tMaxUsed)
	}
	Else {
		Set tRet=tCompoundUpdate.FieldSizeMaxFixComp(..HL7Message,pCustomVersion,pSchemaName,tSegmentIndex,tSegmentName,..FieldIndex,..ComponentIndex,..DataStructure,tMaxUsed)
	}
	
	If tRet'="" {
		Do pLogger.OutputToLog("ERROR: "_tRet)
	}
}

ClassMethod DescribeChange(pHL7Configuration As HL7Configuration, pClassArgs As %String, pCategory As %String, pSubCategory As %String, pItem As %String, pOldData As %String, pNewData As %String) As %String [ CodeMode = expression ]
{
$ListBuild("Data structure "_pSubCategory_": set maximum length for "_$$$COMPINFOX(pHL7Configuration,pSubCategory,pItem)_" to "_pNewData_" (was "_pOldData_")",##class(HL7Configuration).GetDataStructure(pSubCategory,pItem,$$$DTCMAXLENGTH))
}

}
