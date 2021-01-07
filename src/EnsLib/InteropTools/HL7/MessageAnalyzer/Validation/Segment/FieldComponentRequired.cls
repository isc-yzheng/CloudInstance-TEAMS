/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// This class covers validation errors reported for both components and subcomponents.
/// This is because the changes to the data structure definition are the same in both cases.
/// 
/// Validation flags: o (component), j (subcomponent)
Class EnsLib.InteropTools.HL7.MessageAnalyzer.Validation.Segment.FieldComponentRequired Extends SegmentValidationBase
{

Parameter ARGSCOMP = 1;

Parameter ARGSSUBC = 2;

/// Takes the values given by the ARGSXXXX class parameters
Property ArgsStyle As %Integer [ Private ];

Property ComponentIndex As %Integer [ Private ];

Property DataStructure As %String [ Private ];

Property Segment As %String [ Private ];

Property FieldIndex As %Integer [ Private ];

Property HL7Message As Message [ Private ];

Method %OnNew(pChangeKey As %List, pCleanedStatusMessage As %String, pArgs As %List) As %Status
{
	Set ..ChangeKey=pChangeKey
	Set ..CleanedStatusMessage=pCleanedStatusMessage
	Set ..ArgsStyle=$Case($ListLength(pArgs),5:..#ARGSCOMP,6:..#ARGSSUBC)
	If ..ArgsStyle=..#ARGSCOMP {
		Set ..ComponentIndex=$List(pArgs,4)
		Set ..DataStructure=$List(pArgs,5)
		Set ..Segment=$List(pArgs)
		Set ..FieldIndex=$List(pArgs,2)
	}
	ElseIf ..ArgsStyle=..#ARGSSUBC {
		Set ..ComponentIndex=$List(pArgs,5) // actually the subcomponent as named in the status error message
		Set ..DataStructure=$List(pArgs,6)
		Set ..Segment=$List(pArgs)
		Set ..FieldIndex=$List(pArgs,2)
	}
	Else {
		ZTrap
	}
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

	// 2 args - disabled because there is not enough information for a path-update
	//$$$RPPATTERN("ErrGeneral: Empty value found for required")
	//$$$RPADDRECORD(" '([^']+)' field (.+)","FieldComponentRequired",$ListBuild("DataStructure","ComponentIndex"))

	// 5 args
	$$$RPPATTERN("ErrGeneral: Required component missing in segment")
	$$$RPADDRECORD(" ([^\.]+)\.  Field ([^,]+), repetition ([^ ]+) is missing component ([^,]+), which is required in data structure (.+)\.","FieldComponentRequired",$ListBuild("Segment","Field","Repetition","Component","DataStructure"))

	// 6 args
	$$$RPPATTERN("ErrGeneral: Required subcomponent missing in segment")
	$$$RPADDRECORD(" ([^\.]+)\.  Field ([^,]+), repetition ([^,]+), component ([^ ]+) is missing subcomponent ([^,]+), which is required in data structure (.+)\.","FieldComponentRequired",$ListBuild("Segment","Field","Repetition","Component","Subcomponent","DataStructure"))
}

ClassMethod OperationKey(pArgs As %List) As %List
{
	Quit $ListBuild("DSSetComponentOptional")_$Case($ListLength(pArgs),
		5:$List(pArgs,4,5),
		6:$List(pArgs,5,6))
}

Method BeforePrompt(pHL7Configuration As HL7Configuration) As %List
{
	
	Quit ""
}

Method FixPrompt(pHL7Configuration As HL7Configuration) As %String [ CodeMode = expression ]
{
"Make "_$$$COMPINFO_" in "_$$$DTINFO_" optional"
}

Method GetFixTarget() As %List [ CodeMode = expression ]
{
$ListBuild("DT",..DataStructure)
}

Method FixConfiguration(pHL7Configuration As HL7Configuration, pConfigChangeLog As ConfigChangeLog) As %String
{
	Set tOldValue=##class(HL7Configuration).GetDataStructure(..DataStructure,..ComponentIndex,$$$DTCREQUIRED)
	
	$$$ACASSERT(tOldValue'="O","FieldComponentRequired: configuration already updated")

	Do ##class(HL7Configuration).UpdateDataStructure(..DataStructure,..ComponentIndex,$$$DTCREQUIRED,"O") // make the component optional
		
	Do pConfigChangeLog.LogChange(..%ClassName(1),"","DT",..DataStructure,..ComponentIndex,tOldValue,"O")
	
	Quit "Updated "_$$$DTINFO_" definition for "_$$$COMPINFO_": the component is now Optional"
}

Method FixConfigurationCompound(pHL7Configuration As HL7Configuration, pConfigChangeLog As ConfigChangeLog, pCustomVersion As %String, pSchemaName As %String, pLogger As Logger)
{
	$$$ACASSERT(..HL7Message'="","No message passed to FieldComponentRequired object")
	
	Set tCompoundUpdate=##class(CompoundUpdate).%New(pHL7Configuration,pConfigChangeLog,pLogger)
	
	Set tSegmentIndex=$Piece(..Segment,":")
	Set tSegmentName=$Piece(..Segment,":",2)
	
	If ..ArgsStyle=..#ARGSCOMP {	
		Set tRet=tCompoundUpdate.FieldRequiredFixComp(..HL7Message,pCustomVersion,pSchemaName,tSegmentIndex,tSegmentName,..FieldIndex,..ComponentIndex,..DataStructure)
	}
	ElseIf ..ArgsStyle=..#ARGSSUBC {
		Set tRet=tCompoundUpdate.FieldRequiredFixSubComp(..HL7Message,pCustomVersion,pSchemaName,tSegmentIndex,tSegmentName,..FieldIndex,..ComponentIndex,..DataStructure)
	}
	Else {
		ZTrap
	}
	
	If tRet'="" {
		Do pLogger.OutputToLog("ERROR: "_tRet)
	}
}

ClassMethod DescribeChange(pHL7Configuration As HL7Configuration, pClassArgs As %String, pCategory As %String, pSubCategory As %String, pItem As %String, pOldData As %String, pNewData As %String) As %String [ CodeMode = expression ]
{
$ListBuild("Data structure "_pSubCategory_": make "_$$$COMPINFOX(pHL7Configuration,pSubCategory,pItem)_" optional (was '"_pOldData_"')",##class(HL7Configuration).GetDataStructure(pSubCategory,pItem,$$$DTCREQUIRED))
}

}
