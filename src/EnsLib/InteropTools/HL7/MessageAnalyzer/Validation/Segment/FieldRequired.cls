/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Validation flags: r
Class EnsLib.InteropTools.HL7.MessageAnalyzer.Validation.Segment.FieldRequired Extends SegmentValidationBase
{

Property FieldIndex As %Integer [ Private ];

Property SegmentStructure As %String [ Private ];

Property Segment As %String [ Private ];

Property HL7Message As Message [ Private ];

Method %OnNew(pChangeKey As %List, pCleanedStatusMessage As %String, pArgs As %List) As %Status
{
	Set ..ChangeKey=pChangeKey
	Set ..CleanedStatusMessage=pCleanedStatusMessage
	Set $ListBuild(tSegment,tFieldIndex,tSegmentStructure)=pArgs
	Set ..FieldIndex=tFieldIndex
	Set ..SegmentStructure=tSegmentStructure
	Set ..Segment=tSegment
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

	$$$RPPATTERN("ErrGeneral: Required field missing in segment")
	
	// the error message appears both with and without the comma after the field index ..
	$$$RPADDRECORD(" ([^\.]+)\.  Missing field ([^,]+), which is required in segment structure (.+)\.","FieldRequired",$ListBuild("Segment","Field","SegmentStructure"))
	$$$RPADDRECORD(" ([^\.]+)\.  Missing field ([^,]+) which is required in segment structure (.+)\.","FieldRequired",$ListBuild("Segment","Field","SegmentStructure"))
}

ClassMethod OperationKey(pArgs As %List) As %List
{
	Quit $ListBuild("SSSetFieldOptional")_$List(pArgs,2,3)
}

Method BeforePrompt(pHL7Configuration As HL7Configuration) As %List
{
	Quit ""
}

Method FixPrompt(pHL7Configuration As HL7Configuration) As %String [ CodeMode = expression ]
{
"Make "_$$$FIELDINFO_" in "_$$$SSINFO_" optional"
}

Method GetFixTarget() As %List [ CodeMode = expression ]
{
$ListBuild("SS",..SegmentStructure)
}

Method FixConfiguration(pHL7Configuration As HL7Configuration, pConfigChangeLog As ConfigChangeLog) As %String
{
	Set tOldValue=##class(HL7Configuration).GetSegmentStructure(..SegmentStructure,..FieldIndex,$$$SSFREQUIRED)
	
	$$$ACASSERT(+tOldValue'="O","FieldRequired: configuration already updated")		
	
	Do ##class(HL7Configuration).UpdateSegmentStructure(..SegmentStructure,..FieldIndex,$$$SSFREQUIRED,"O") // make the field optional
	
	Do pConfigChangeLog.LogChange(..%ClassName(1),"","SS",..SegmentStructure,..FieldIndex,tOldValue,"O")	

	Quit "Updated "_$$$SSINFO_" definition for "_$$$FIELDINFO_": the field is now Optional"
}

Method FixConfigurationCompound(pHL7Configuration As HL7Configuration, pConfigChangeLog As ConfigChangeLog, pCustomVersion As %String, pSchemaName As %String, pLogger As Logger)
{
	$$$ACASSERT(..HL7Message'="","No message passed to FieldRequired object")
	
	Set tCompoundUpdate=##class(CompoundUpdate).%New(pHL7Configuration,pConfigChangeLog,pLogger)
	
	Set tSegmentIndex=$Piece(..Segment,":")
	Set tSegmentName=$Piece(..Segment,":",2)
	
	Set tRet=tCompoundUpdate.FieldRequiredFix(..HL7Message,pCustomVersion,pSchemaName,tSegmentIndex,tSegmentName,..FieldIndex,..SegmentStructure)
	
	If tRet'="" {
		Do pLogger.OutputToLog("ERROR: "_tRet)
	}
}

ClassMethod DescribeChange(pHL7Configuration As HL7Configuration, pClassArgs As %String, pCategory As %String, pSubCategory As %String, pItem As %String, pOldData As %String, pNewData As %String) As %String [ CodeMode = expression ]
{
$ListBuild("Segment structure "_pSubCategory_": make "_$$$FIELDINFOX(pHL7Configuration,pSubCategory,pItem)_" optional (was '"_pOldData_"')",##class(HL7Configuration).GetSegmentStructure(pSubCategory,pItem,$$$SSFREQUIRED))
}

}
