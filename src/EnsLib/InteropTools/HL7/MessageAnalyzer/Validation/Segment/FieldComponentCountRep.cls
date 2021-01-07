/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// This class covers validation errors reported for both components and subcomponents.
/// This is because the changes to the data structure definition are the same in both cases.
/// 
/// Validation flags: g (component), p (subcomponent)
Class EnsLib.InteropTools.HL7.MessageAnalyzer.Validation.Segment.FieldComponentCountRep Extends SegmentValidationBase
{

Property IsSubcomponent As %Boolean [ Private ];

Property DataStructure As %String [ Private ];

Property Segment As %String [ Private ];

Property FieldIndex As %Integer [ Private ];

/// Only present when IsSubcomponent is true
Property ComponentIndex As %Integer [ Private ];

Property HL7Message As Message [ Private ];

Method %OnNew(pChangeKey As %List, pCleanedStatusMessage As %String, pArgs As %List) As %Status
{
	Set ..ChangeKey=pChangeKey
	Set ..CleanedStatusMessage=pCleanedStatusMessage

	Set ..IsSubcomponent=($ListLength(pArgs)=5)	
	If ..IsSubcomponent {
		Set ..DataStructure=$List(pArgs,5)
		Set ..ComponentIndex=$List(pArgs,4)
	}
	Else {
		Set ..DataStructure=$List(pArgs,4)
		Set ..ComponentIndex=""
	}
	
	Set ..Segment=$List(pArgs)
	Set ..FieldIndex=$List(pArgs,2)
	Set ..HL7Message=""
	Set ..MessageSummary=0
	Quit $$$OK
}

Method AddMessageImpl(pArgs As %List, pHL7Message As Message)
{
	If ..IsSubcomponent {
		Set $ListBuild(tSegment,tFieldIndex,tRepetition,tComponentIndex,tDummyDataStructure)=pArgs
		Set tSegmentIndex=$Piece(tSegment,":")
		Set tData=pHL7Message.GetValueAt(tSegmentIndex_":"_tFieldIndex_"("_tRepetition_")."_tComponentIndex,,.tSC) $$$THROWONERROR(tSC,tSC)
		Set tSummary=$Length(tData,pHL7Message.SS)
	}
	Else {
		Set $ListBuild(tSegment,tFieldIndex,tRepetition,tDummyDataStructure)=pArgs
		Set tSegmentIndex=$Piece(tSegment,":")
		Set tData=pHL7Message.GetValueAt(tSegmentIndex_":"_tFieldIndex_"("_tRepetition_")",,.tSC) $$$THROWONERROR(tSC,tSC)
		Set tSummary=$Length(tData,pHL7Message.CS)
	}
	
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
	
	// 4 args
	$$$RPPATTERN("ErrGeneral: Field data structure not obeyed in segment")
	$$$RPADDRECORD(" ([^\.]+)\.  Field ([^,]+), repetition ([^ ]+) has more components than permitted by data structure (.+)\.","FieldComponentCountRep",$ListBuild("Segment","Field","Repetition","DataStructure"))
	
	// 5 args
	$$$RPPATTERN("ErrGeneral: Component data structure not obeyed in segment")
	$$$RPADDRECORD(" ([^\.]+)\.  Field ([^,]+), repetition ([^,]+), component ([^ ]+) has more subcomponents than permitted by data structure (.+)\.","FieldComponentCountRep",$ListBuild("Segment","Field","Repetition","Component","DataStructure"))
}

ClassMethod OperationKey(pArgs As %List) As %List
{
	Quit $ListBuild("DSAddComponents")_$List(pArgs,*,*) // the data structure is the last arg for both component and subcomponent
}

Method BeforePrompt(pHL7Configuration As HL7Configuration) As %List
{
	
	Set tDTVersion=$Piece(..DataStructure,":"),tDTName=$Piece(..DataStructure,":",2)
	Set tExistingCount=$ListLength($$$vaSchemaGbl(tDTVersion,"DT",tDTName))

	Set tMaxCount=..MessageSummary
	Set tMostComponentsMessage="Most components (or subcomponents) given in a message is "_tMaxCount
	
	Quit $ListBuild(
		"Existing component count for "_$$$DTINFO_" is "_tExistingCount,
		tMostComponentsMessage
	)
}

Method FixPrompt(pHL7Configuration As HL7Configuration) As %String [ CodeMode = expression ]
{
"Add "_..NumberToAdd()_" dummy components to "_$$$DTINFO
}

Method GetFixTarget() As %List [ CodeMode = expression ]
{
$ListBuild("DT",..DataStructure)
}

Method FixConfiguration(pHL7Configuration As HL7Configuration, pConfigChangeLog As ConfigChangeLog) As %String
{
	Set tMaxCount=..MessageSummary
	Set tCurrentCount=..CurrentCount(..DataStructure)	
	Set tToAddCount=tMaxCount-tCurrentCount
	$$$ACASSERT(tToAddCount>0,"FieldComponentCountRep: configuration already updated")
	
	Do pHL7Configuration.ExtendDataStructure(..DataStructure,tToAddCount)
	
	Do pConfigChangeLog.LogChange(..%ClassName(1),"","DT",..DataStructure,"",tCurrentCount,tMaxCount)
	
	Quit "Updated "_$$$DTINFO_" definition: added "_tToAddCount_" components"
}

Method FixConfigurationCompound(pHL7Configuration As HL7Configuration, pConfigChangeLog As ConfigChangeLog, pCustomVersion As %String, pSchemaName As %String, pLogger As Logger)
{
	$$$ACASSERT(..HL7Message'="","No message passed to FieldComponentCountRep object")
	
	Set tCompoundUpdate=##class(CompoundUpdate).%New(pHL7Configuration,pConfigChangeLog,pLogger)
	
	Set tSegmentIndex=$Piece(..Segment,":")
	Set tSegmentName=$Piece(..Segment,":",2)
	If ..IsSubcomponent {
		Set tRet=tCompoundUpdate.FieldComponentCountRepFixSubcomponent(..HL7Message,pCustomVersion,pSchemaName,tSegmentIndex,tSegmentName,..FieldIndex,..ComponentIndex,..NumberToAdd())
	}
	Else {
		Set tRet=tCompoundUpdate.FieldComponentCountRepFix(..HL7Message,pCustomVersion,pSchemaName,tSegmentIndex,tSegmentName,..FieldIndex,..NumberToAdd())
	}
	If tRet'="" {
		Do pLogger.OutputToLog("ERROR: "_tRet)
	}
}

ClassMethod DescribeChange(pHL7Configuration As HL7Configuration, pClassArgs As %String, pCategory As %String, pSubCategory As %String, pItem As %String, pOldData As %String, pNewData As %String) As %String [ CodeMode = expression ]
{
$ListBuild("Data structure "_pSubCategory_": add "_(pNewData-pOldData)_" component(s)",..CurrentCount(pSubCategory))
}

ClassMethod CurrentCount(pDataStructure As %String) As %Integer [ Private ]
{
	Set tDTVersion=$Piece(pDataStructure,":"),tDTName=$Piece(pDataStructure,":",2)
	Quit $ListLength($Get($$$vaSchemaGbl(tDTVersion,"DT",tDTName)))
}

Method NumberToAdd() As %Integer [ CodeMode = expression, Private ]
{
..MessageSummary-..CurrentCount(..DataStructure)
}

}
