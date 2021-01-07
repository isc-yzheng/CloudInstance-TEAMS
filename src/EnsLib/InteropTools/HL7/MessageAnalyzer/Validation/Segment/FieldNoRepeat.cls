/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Validation flags: a
Class EnsLib.InteropTools.HL7.MessageAnalyzer.Validation.Segment.FieldNoRepeat Extends SegmentValidationBase
{

Property FieldIndex As %Integer [ Private ];

Property RepetitionNotAllowed As %Boolean [ Private ];

Property SegmentStructure As %String [ Private ];

Property Segment As %String [ Private ];

Property HL7Message As Message [ Private ];

Method %OnNew(pChangeKey As %List, pCleanedStatusMessage As %String, pArgs As %List) As %Status
{
	Set ..ChangeKey=pChangeKey
	Set ..CleanedStatusMessage=pCleanedStatusMessage
	Set $ListBuild(tSegment,tFieldIndex,tText1,tSegmentStructure,tText2)=pArgs
	Set ..FieldIndex=tFieldIndex
	Set ..RepetitionNotAllowed=(tText1="although")
	Set ..SegmentStructure=tSegmentStructure
	Set ..MessageSummary=0
	Set ..Segment=tSegment
	Quit $$$OK
}

Method AddMessageImpl(pArgs As %List, pHL7Message As Message)
{
	Set tRepetitionNotAllowed=($List(pArgs,3)="although")
	
	// repetition used but is not allowed ..
	If tRepetitionNotAllowed {
		Set ..RepetitionNotAllowed=1
	}
	
	// .. repetition used with more repeats than allowed ..
	Else {
	
		Set $ListBuild(tSegment,tFieldIndex,tText1,tSegmentStructure,tText2)=pArgs
	
		Set tSegmentIndex=$Piece(tSegment,":")
		Set tFieldData=pHL7Message.GetValueAt(tSegmentIndex_":"_..FieldIndex,,.tSC) $$$THROWONERROR(tSC,tSC)
		Set tSummary=$Length(tFieldData,pHL7Message.RS)
		If tSummary>..MessageSummary {
			Set ..MessageSummary=tSummary
		}	
	}

	If ..HL7Message="" {
		Set ..HL7Message=pHL7Message
	}
}

ClassMethod RegisterPatterns(Output pRecords)
{
	$$$SHOULDBEUNDEF(pRecords)

	$$$RPPATTERN("ErrGeneral: Forbidden repetition in segment")
	$$$RPADDRECORD(" ([^\.]+)\.  Field ([^ ]+) repeats (although|more often than) segment structure ([^ ]+) (does not permit|permits) it to\.","FieldNoRepeat",$ListBuild("Segment","Field","Text1","SegmentStructure","Text2"))
}

ClassMethod OperationKey(pArgs As %List) As %List
{
	Quit $ListBuild("SSSetFieldRepeatingAndMaxRepeats")_$List(pArgs,2,2)_$List(pArgs,4,4)
}

Method BeforePrompt(pHL7Configuration As HL7Configuration) As %List
{
	
	Set tPrePrompts=""
	
	// repetition used but is not allowed ..
	If ..RepetitionNotAllowed {
		Set tPrePrompts=tPrePrompts_$ListBuild("Field definition for "_$$$SSINFO_" "_$$$FIELDINFO_" does not allow it to repeat")
	}
	
	// repetition used with more repeats than allowed ..
	If ..MessageSummary > 0 {
	
		Set tMaxRepeats=..MessageSummary
		Set tPrePrompts=tPrePrompts_$ListBuild("Most repeats used in a message is "_tMaxRepeats)
		
		Set tExistingLimit=##class(HL7Configuration).GetSegmentStructure(..SegmentStructure,..FieldIndex,$$$SSFREPEATCOUNT)
		Set tPrePrompts=tPrePrompts_$ListBuild("Existing repeat limit for "_$$$SSINFO_" "_$$$FIELDINFO_" is "_tExistingLimit)
	}
	
	$$$ACASSERT(tPrePrompts'="","FieldNoRepeat.BeforePrompt: neither validation error condition is true")
	
	Quit tPrePrompts
}

Method FixPrompt(pHL7Configuration As HL7Configuration) As %String
{
	// if repetition is not currently allowed ..
	If ..RepetitionNotAllowed {
	
		// if there was one or more messages with more repeats than allowed ..
		If ..MessageSummary > 0 {
			Quit "Enable "_..MessageSummary_" repeats for "_$$$FIELDINFO_" in "_$$$SSINFO
		}
		Else {
			Quit "Enable repeats for "_$$$FIELDINFO_" in "_$$$SSINFO
		}
	}
	Else {
		$$$ACASSERT(..MessageSummary > 0, "FieldNoRepeat.FixPrompt: neither repetition-not-allowed nor message summary is set")
		Quit "Increase the permitted number of repeats for "_$$$FIELDINFO_" in "_$$$SSINFO		  
	}
}

Method GetFixTarget() As %List [ CodeMode = expression ]
{
$ListBuild("SS",..SegmentStructure)
}

Method FixConfiguration(pHL7Configuration As HL7Configuration, pConfigChangeLog As ConfigChangeLog) As %String
{
	// repetition used but is not allowed ..
	If ..RepetitionNotAllowed {

		Set tOldValue=##class(HL7Configuration).GetSegmentStructure(..SegmentStructure,..FieldIndex,$$$SSFREPEATING)
		
		$$$ACASSERT(+tOldValue=0,"FieldNoRepeat: configuration already updated (repeating)")		

		Do ##class(HL7Configuration).UpdateSegmentStructure(..SegmentStructure,..FieldIndex,$$$SSFREPEATING,1) // enable repeats
		
		Do pConfigChangeLog.LogChange(..%ClassName(1),"AllowRep","SS",..SegmentStructure,..FieldIndex,tOldValue,1)	
	}
	
	// repetition used with more repeats than allowed ..
	If ..MessageSummary > 0 {
		
		Set tMaxRepeat=..MessageSummary

		Set tOldValue=##class(HL7Configuration).GetSegmentStructure(..SegmentStructure,..FieldIndex,$$$SSFREPEATCOUNT)
		
		$$$ACASSERT(tOldValue<tMaxRepeat,"FieldNoRepeat: configuration already updated (max repeats)")		
		
		Do ##class(HL7Configuration).UpdateSegmentStructure(..SegmentStructure,..FieldIndex,$$$SSFREPEATCOUNT,tMaxRepeat) // set the repeat limit

		Do pConfigChangeLog.LogChange(..%ClassName(1),"SetRepMax","SS",..SegmentStructure,..FieldIndex,tOldValue,tMaxRepeat)	

		Quit "Updated "_$$$SSINFO_" definition for "_$$$FIELDINFO_": the field now allows "_tMaxRepeat_" repeats"
	}

	Set tOldValue=##class(HL7Configuration).GetSegmentStructure(..SegmentStructure,..FieldIndex,$$$SSFREPEATCOUNT)

	// just repeating
	Do ##class(HL7Configuration).UpdateSegmentStructure(..SegmentStructure,..FieldIndex,$$$SSFREPEATCOUNT,"") // clear the repeat limit
	
	Do pConfigChangeLog.LogChange(..%ClassName(1),"ClearRepMax","SS",..SegmentStructure,..FieldIndex,tOldValue,"")	
	
	Quit "Updated "_$$$SSINFO_" definition for "_$$$FIELDINFO_": the field now allows repeats"
}

Method FixConfigurationCompound(pHL7Configuration As HL7Configuration, pConfigChangeLog As ConfigChangeLog, pCustomVersion As %String, pSchemaName As %String, pLogger As Logger)
{
	$$$ACASSERT(..HL7Message'="","No message passed to FieldNoRepeat object")
	
	Set tCompoundUpdate=##class(CompoundUpdate).%New(pHL7Configuration,pConfigChangeLog,pLogger)
	
	Set tSegmentIndex=$Piece(..Segment,":")
	Set tSegmentName=$Piece(..Segment,":",2)
	
	Set tRet=tCompoundUpdate.FieldNoRepeatFix(..HL7Message,pCustomVersion,pSchemaName,tSegmentIndex,tSegmentName,..FieldIndex,..SegmentStructure,..RepetitionNotAllowed,..MessageSummary)
	
	If tRet'="" {
		Do pLogger.OutputToLog("ERROR: "_tRet)
	}
}

ClassMethod DescribeChange(pHL7Configuration As HL7Configuration, pClassArgs As %String, pCategory As %String, pSubCategory As %String, pItem As %String, pOldData As %String, pNewData As %String) As %String
{
	Quit $Case(pClassArgs,
		"AllowRep":$ListBuild("Segment structure "_pSubCategory_": allow repetitions of "_$$$FIELDINFOX(pHL7Configuration,pSubCategory,pItem)_" (was '"_pOldData_"')",##class(HL7Configuration).GetSegmentStructure(pSubCategory,pItem,$$$SSFREPEATING)),
		"SetRepMax":$ListBuild("Segment structure "_pSubCategory_": set maximum repetitions of "_$$$FIELDINFOX(pHL7Configuration,pSubCategory,pItem)_" to "_pNewData_" (was '"_pOldData_"')",##class(HL7Configuration).GetSegmentStructure(pSubCategory,pItem,$$$SSFREPEATCOUNT)),
		"ClearRepMax":$ListBuild("Segment structure "_pSubCategory_": clear maximum repetitions of "_$$$FIELDINFOX(pHL7Configuration,pSubCategory,pItem)_" (was '"_pOldData_"')",##class(HL7Configuration).GetSegmentStructure(pSubCategory,pItem,$$$SSFREPEATCOUNT))
	)
}

}
