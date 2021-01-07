/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.Common, EnsLib.InteropTools.HL7.MessageAnalyzer.Ensemble, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging, EnsLib.HL7)

Include (EnsHL7, EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.Validation)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Validation.CompoundUpdate Extends %RegisteredObject
{

Property HL7Configuration As HL7Configuration [ Private ];

Property ConfigChangeLog As ConfigChangeLog [ Private ];

Property Logger As Logger [ Private ];

Method %OnNew(pHL7Configuration As HL7Configuration, pConfigChangeLog As ConfigChangeLog, pLogger As Logger) As %Status
{
	Set ..HL7Configuration=pHL7Configuration
	Set ..ConfigChangeLog=pConfigChangeLog
	Set ..Logger=pLogger
	Quit $$$OK
}

/// <p> DOCSTRUCT -> SEGSTRUCT -> CODETABLE
/// <p> DOCSTRUCT -> SEGSTRUCT -> DATASTRUCT -> CODETABLE
/// <p> DOCSTRUCT -> SEGSTRUCT -> DATASTRUCT -> DATASTRUCT -> CODETABLE
Method CodeMissingFix(pHL7Message As Message, pCustomVersion As %String, pSchemaName As %String, pSegmentIndex As %Integer, pSegmentName As %String, pFieldIndex As %String, pComponentIndex As %String, pSubcomponentIndex As %String, pCodeTable As %String, pNewCode As %String) As %String
{
	Set tPathUpdater=##class(PathUpdater).%New(pHL7Message,pCustomVersion,pSchemaName,pSegmentName,pSegmentIndex,..ConfigChangeLog,..Logger)
	
	Set tFindCodeTable=$ListBuild(pFieldIndex,pComponentIndex,pSubcomponentIndex,pCodeTable)
	Set tRet=tPathUpdater.Update("",.tPathResult,tFindCodeTable)
	If '$List(tRet) {Quit $List(tRet,2)}
	
	Do ..Logger.OutputToLog(tPathResult.PathRepr())
	
	Set $ListBuild(tDummy,tKind,tLibraryVersion,tName)=tRet
	
	// if the code is not in the custom code table ..
	If '$Data($$$vaSchemaGbl(pCustomVersion,"CT",tName,pNewCode)) {
	
		// add the code to the code table if needed
		Do ..HL7Configuration.AddToCodeTable(pCustomVersion_":"_tName,pNewCode) // add the code to the table
		Do ..ConfigChangeLog.LogChange(..%ClassName(1),"CT.ADD","CT",pCustomVersion_":"_tName,pNewCode,0,1)
		Do ..Logger.OutputToLog("Updated "_$$$CTINFOX(pCustomVersion_":"_tName)_": added code '"_pNewCode_"'")
	}

	Quit ""
}

/// <p> component: DOCSTRUCT -> SEGSTRUCT -> DATASTRUCT
Method FieldComponentCountRepFix(pHL7Message As Message, pCustomVersion As %String, pSchemaName As %String, pSegmentIndex As %Integer, pSegmentName As %String, pFieldIndex As %Integer, pNumberToAdd As %Integer) As %String
{
	Set tPathUpdater=##class(PathUpdater).%New(pHL7Message,pCustomVersion,pSchemaName,pSegmentName,pSegmentIndex,..ConfigChangeLog,..Logger)
	
	Set tPath=$ListBuild($ListBuild("DT",pFieldIndex))
	Set tRet=tPathUpdater.Update(tPath,.tPathResult)
	If '$List(tRet) {Quit $List(tRet,2)}
	
	Do ..Logger.OutputToLog(tPathResult.PathRepr())
	
	Set $ListBuild(tDummy,tKind,tLibraryVersion,tName)=tRet
	
	// extend data structure referred to by segment if needed
	Set tCustomDT=pCustomVersion_":"_tName
	Do ..ExtendDataStructureIfNeeded(tCustomDT,pNumberToAdd)
	
	Quit ""
}

/// <p> subcomponent: DOCSTRUCT -> SEGSTRUCT -> DATASTRUCT -> DATASTRUCT
Method FieldComponentCountRepFixSubcomponent(pHL7Message As Message, pCustomVersion As %String, pSchemaName As %String, pSegmentIndex As %Integer, pSegmentName As %String, pFieldIndex As %Integer, pComponentIndex As %Integer, pNumberToAdd As %Integer) As %String
{
	Set tPathUpdater=##class(PathUpdater).%New(pHL7Message,pCustomVersion,pSchemaName,pSegmentName,pSegmentIndex,..ConfigChangeLog,..Logger)
	
	Set tPath=$ListBuild($ListBuild("DT",pFieldIndex),$ListBuild("DT",pComponentIndex))
	Set tRet=tPathUpdater.Update(tPath,.tPathResult)
	If '$List(tRet) {Quit $List(tRet,2)}
	
	Do ..Logger.OutputToLog(tPathResult.PathRepr())
	
	Set $ListBuild(tDummy,tKind,tLibraryVersion,tName)=tRet
		
	// extend data structure referred to by field-level data structure if needed
	Set tDSCustomDT=pCustomVersion_":"_tName
	Do ..ExtendDataStructureIfNeeded(tDSCustomDT,pNumberToAdd)
		
	Quit ""
}

/// <p> DOCSTRUCT -> SEGSTRUCT -> DATASTRUCT
Method FieldRequiredFixComp(pHL7Message As Message, pCustomVersion As %String, pSchemaName As %String, pSegmentIndex As %Integer, pSegmentName As %String, pFieldIndex As %Integer, pComponentIndex As %Integer, pDataStructure As %String) As %String
{
	Set tPathUpdater=##class(PathUpdater).%New(pHL7Message,pCustomVersion,pSchemaName,pSegmentName,pSegmentIndex,..ConfigChangeLog,..Logger)
	
	Set tPath=$ListBuild($ListBuild("DT",pFieldIndex))
	Set tRet=tPathUpdater.Update(tPath,.tPathResult)
	If '$List(tRet) {Quit $List(tRet,2)}
	
	Do ..Logger.OutputToLog(tPathResult.PathRepr())
	
	Set $ListBuild(tDummy,tKind,tLibraryVersion,tName)=tRet
	
	// make component optional if needed
	Set tDSCustomDT=pCustomVersion_":"_tName
	Do ..MakeComponentOptionalIfNeeded(tDSCustomDT,pComponentIndex)
	
	Quit ""
}

/// <p> DOCSTRUCT -> SEGSTRUCT -> DATASTRUCT -> DATASTRUCT
Method FieldRequiredFixSubComp(pHL7Message As Message, pCustomVersion As %String, pSchemaName As %String, pSegmentIndex As %Integer, pSegmentName As %String, pFieldIndex As %Integer, pComponentIndex As %Integer, pDataStructure As %String) As %String
{
	Set tPathUpdater=##class(PathUpdater).%New(pHL7Message,pCustomVersion,pSchemaName,pSegmentName,pSegmentIndex,..ConfigChangeLog,..Logger)
	
	Set tPath=$ListBuild($ListBuild("DT",pFieldIndex),$ListBuild("DT",pComponentIndex))
	Set tRet=tPathUpdater.Update(tPath,.tPathResult)
	If '$List(tRet) {Quit $List(tRet,2)}
	
	Do ..Logger.OutputToLog(tPathResult.PathRepr())
	
	Set $ListBuild(tDummy,tKind,tLibraryVersion,tName)=tRet
	
	// make component optional if needed
	Set tDSCustomDT=pCustomVersion_":"_tName
	Do ..MakeComponentOptionalIfNeeded(tDSCustomDT,pComponentIndex)
	
	Quit ""
}

/// <p> DOCSTRUCT -> SEGSTRUCT -> DATASTRUCT
Method FieldSizeMaxFixComp(pHL7Message As Message, pCustomVersion As %String, pSchemaName As %String, pSegmentIndex As %Integer, pSegmentName As %String, pFieldIndex As %Integer, pComponentIndex As %Integer, pDataStructure As %String, pMaxUsed As %Integer) As %String
{
	Set tPathUpdater=##class(PathUpdater).%New(pHL7Message,pCustomVersion,pSchemaName,pSegmentName,pSegmentIndex,..ConfigChangeLog,..Logger)
	
	Set tPath=$ListBuild($ListBuild("DT",pFieldIndex))
	Set tRet=tPathUpdater.Update(tPath,.tPathResult)
	If '$List(tRet) {Quit $List(tRet,2)}
	
	Do ..Logger.OutputToLog(tPathResult.PathRepr())
	
	Set $ListBuild(tDummy,tKind,tLibraryVersion,tName)=tRet
	
	// set component max size if needed
	Set tDSCustomDT=pCustomVersion_":"_tName
	Do ..UpdateComponentSizeMaxIfNeeded(tDSCustomDT,pComponentIndex,pMaxUsed)
	
	Quit ""
}

/// <p> DOCSTRUCT -> SEGSTRUCT -> DATASTRUCT -> DATASTRUCT
Method FieldSizeMaxFixSubComp(pHL7Message As Message, pCustomVersion As %String, pSchemaName As %String, pSegmentIndex As %Integer, pSegmentName As %String, pFieldIndex As %Integer, pComponentIndex As %Integer, pDataStructure As %String, pMaxUsed As %Integer) As %String
{
	Set tPathUpdater=##class(PathUpdater).%New(pHL7Message,pCustomVersion,pSchemaName,pSegmentName,pSegmentIndex,..ConfigChangeLog,..Logger)
	
	Set tPath=$ListBuild($ListBuild("DT",pFieldIndex),$ListBuild("DT",pComponentIndex))
	Set tRet=tPathUpdater.Update(tPath,.tPathResult)
	If '$List(tRet) {Quit $List(tRet,2)}
	
	Do ..Logger.OutputToLog(tPathResult.PathRepr())
	
	Set $ListBuild(tDummy,tKind,tLibraryVersion,tName)=tRet
	
	// set component max size if needed
	Set tDSCustomDT=pCustomVersion_":"_tName
	Do ..UpdateComponentSizeMaxIfNeeded(tDSCustomDT,pComponentIndex,pMaxUsed)
	
	Quit ""
}

/// <p> DOCSTRUCT -> SEGSTRUCT -> DATASTRUCT
Method FieldSizeMinFixComp(pHL7Message As Message, pCustomVersion As %String, pSchemaName As %String, pSegmentIndex As %Integer, pSegmentName As %String, pFieldIndex As %Integer, pComponentIndex As %Integer, pDataStructure As %String, pMinUsed As %Integer) As %String
{
	Set tPathUpdater=##class(PathUpdater).%New(pHL7Message,pCustomVersion,pSchemaName,pSegmentName,pSegmentIndex,..ConfigChangeLog,..Logger)
	
	Set tPath=$ListBuild($ListBuild("DT",pFieldIndex))
	Set tRet=tPathUpdater.Update(tPath,.tPathResult)
	If '$List(tRet) {Quit $List(tRet,2)}
	
	Do ..Logger.OutputToLog(tPathResult.PathRepr())
	
	Set $ListBuild(tDummy,tKind,tLibraryVersion,tName)=tRet
	
	// set component min size if needed
	Set tDSCustomDT=pCustomVersion_":"_tName
	Do ..UpdateComponentSizeMinIfNeeded(tDSCustomDT,pComponentIndex,pMinUsed)
	
	Quit ""
}

/// <p> DOCSTRUCT -> SEGSTRUCT -> DATASTRUCT -> DATASTRUCT
Method FieldSizeMinFixSubComp(pHL7Message As Message, pCustomVersion As %String, pSchemaName As %String, pSegmentIndex As %Integer, pSegmentName As %String, pFieldIndex As %Integer, pComponentIndex As %Integer, pDataStructure As %String, pMinUsed As %Integer) As %String
{
	Set tPathUpdater=##class(PathUpdater).%New(pHL7Message,pCustomVersion,pSchemaName,pSegmentName,pSegmentIndex,..ConfigChangeLog,..Logger)
	
	Set tPath=$ListBuild($ListBuild("DT",pFieldIndex),$ListBuild("DT",pComponentIndex))
	Set tRet=tPathUpdater.Update(tPath,.tPathResult)
	If '$List(tRet) {Quit $List(tRet,2)}
	
	Do ..Logger.OutputToLog(tPathResult.PathRepr())
	
	Set $ListBuild(tDummy,tKind,tLibraryVersion,tName)=tRet
	
	// set component min size if needed
	Set tDSCustomDT=pCustomVersion_":"_tName
	Do ..UpdateComponentSizeMinIfNeeded(tDSCustomDT,pComponentIndex,pMinUsed)
	
	Quit ""
}

/// <p> DOCSTRUCT -> SEGSTRUCT
Method FieldNoRepeatFix(pHL7Message As Message, pCustomVersion As %String, pSchemaName As %String, pSegmentIndex As %Integer, pSegmentName As %String, pFieldIndex As %Integer, pSegmentStructure As %String, pRepNotAllowed As %Boolean, pMessageMaxRep As %Integer) As %String
{
	$$$ACASSERT(pRepNotAllowed || (pMessageMaxRep'=0),"FieldComponentCountRepFix: neither operation flag is set")
	
	Set tPathUpdater=##class(PathUpdater).%New(pHL7Message,pCustomVersion,pSchemaName,pSegmentName,pSegmentIndex,..ConfigChangeLog,..Logger)
	
	Set tPath="" // just process the schema and segment
	Set tRet=tPathUpdater.Update(tPath,.tPathResult)
	If '$List(tRet) {Quit $List(tRet,2)}
	
	Do ..Logger.OutputToLog(tPathResult.PathRepr())
	
	Set $ListBuild(tDummy,tKind,tLibraryVersion,tName)=tRet
	
	Set tSSCustomSS=pCustomVersion_":"_$Piece(pSegmentStructure,":",2)
	
	If pRepNotAllowed {

		// allow repeats
		Do ..UpdateSSRepeatsAllowedIfNecessary(tSSCustomSS,pFieldIndex)
	}
	
	If pMessageMaxRep {
	
		// set the repeat limit
		Do ..UpdateSSRepeatLimitIfNecessary(tSSCustomSS,pFieldIndex,pMessageMaxRep)
	}
	
	Else {
	
		// clear the repeat limit
		Do ..UpdateSSClearRepeatsIfNecessary(tSSCustomSS,pFieldIndex)
	}
	
	Quit ""
}

/// <p> DOCSTRUCT -> SEGSTRUCT
Method FieldRequiredFix(pHL7Message As Message, pCustomVersion As %String, pSchemaName As %String, pSegmentIndex As %Integer, pSegmentName As %String, pFieldIndex As %Integer, pSegmentStructure As %String) As %String
{
	Set tPathUpdater=##class(PathUpdater).%New(pHL7Message,pCustomVersion,pSchemaName,pSegmentName,pSegmentIndex,..ConfigChangeLog,..Logger)
	
	Set tPath="" // just process the schema and segment
	Set tRet=tPathUpdater.Update(tPath,.tPathResult)
	If '$List(tRet) {Quit $List(tRet,2)}
	
	Do ..Logger.OutputToLog(tPathResult.PathRepr())
	
	Set $ListBuild(tDummy,tKind,tLibraryVersion,tName)=tRet
	
	Set tSSCustomSS=pCustomVersion_":"_$Piece(pSegmentStructure,":",2)
	
	// make field optional
	Do ..UpdateSSMakeFieldOptionalIfNecessary(tSSCustomSS,pFieldIndex)
	
	Quit ""
}

/// <p> DOCSTRUCT -> SEGSTRUCT
Method FieldSizeMaxFix(pHL7Message As Message, pCustomVersion As %String, pSchemaName As %String, pSegmentIndex As %Integer, pSegmentName As %String, pFieldIndex As %Integer, pSegmentStructure As %String, pMaxUsed As %Integer) As %String
{
	Set tPathUpdater=##class(PathUpdater).%New(pHL7Message,pCustomVersion,pSchemaName,pSegmentName,pSegmentIndex,..ConfigChangeLog,..Logger)
	
	Set tPath="" // just process the schema and segment
	Set tRet=tPathUpdater.Update(tPath,.tPathResult)
	If '$List(tRet) {Quit $List(tRet,2)}
	
	Do ..Logger.OutputToLog(tPathResult.PathRepr())
	
	Set $ListBuild(tDummy,tKind,tLibraryVersion,tName)=tRet
	
	Set tSSCustomSS=pCustomVersion_":"_$Piece(pSegmentStructure,":",2)
	
	// set max for field
	Do ..UpdateSSSetFieldSizeMaxIfNecessary(tSSCustomSS,pFieldIndex,pMaxUsed)
	
	Quit ""
}

/// <p> DOCSTRUCT -> SEGSTRUCT
Method FieldSizeMinFix(pHL7Message As Message, pCustomVersion As %String, pSchemaName As %String, pSegmentIndex As %Integer, pSegmentName As %String, pFieldIndex As %Integer, pSegmentStructure As %String, pMinUsed As %Integer) As %String
{
	Set tPathUpdater=##class(PathUpdater).%New(pHL7Message,pCustomVersion,pSchemaName,pSegmentName,pSegmentIndex,..ConfigChangeLog,..Logger)
	
	Set tPath="" // just process the schema and segment
	Set tRet=tPathUpdater.Update(tPath,.tPathResult)
	If '$List(tRet) {Quit $List(tRet,2)}
	
	Do ..Logger.OutputToLog(tPathResult.PathRepr())
	
	Set $ListBuild(tDummy,tKind,tLibraryVersion,tName)=tRet
	
	Set tSSCustomSS=pCustomVersion_":"_$Piece(pSegmentStructure,":",2)
	
	// set min for field
	Do ..UpdateSSSetFieldSizeMinIfNecessary(tSSCustomSS,pFieldIndex,pMinUsed)
	
	Quit ""
}

/// Forwarder to handle older log entries and entries made in this class
ClassMethod DescribeChange(pHL7Configuration As HL7Configuration, pClassArgs As %String, pCategory As %String, pSubCategory As %String, pItem As %String, pOldData As %String, pNewData As %String) As %List [ CodeMode = expression ]
{
##class(PathUpdater).DescribeChange(pHL7Configuration,pClassArgs,pCategory,pSubCategory,pItem,pOldData,pNewData)
}

/// Forwarder to handle older log entries and entries made in this class
ClassMethod DescribeCopy(pHL7Configuration As HL7Configuration, pClassArgs As %String, pCategory As %String, pItem As %String, pSourceVersion As %String, pTargetVersion As %String) As %List [ CodeMode = expression ]
{
##class(PathUpdater).DescribeCopy(pHL7Configuration,pClassArgs,pCategory,pItem,pSourceVersion,pTargetVersion)
}

Method ExtendDataStructureIfNeeded(pDataStructure As %String, pNumberToAdd As %Integer) [ Private ]
{
	Set tDTVersion=$Piece(pDataStructure,":"),tDTName=$Piece(pDataStructure,":",2)
	
	Set tCurrentCount=$ListLength($$$vaSchemaGbl(tDTVersion,"DT",tDTName))
	Set tRequiredCount=tCurrentCount + pNumberToAdd
		
	// if the data structure table has too few fields ..
	If $ListLength($$$vaSchemaGbl(tDTVersion,"DT",tDTName)) < tRequiredCount {
		
		// add fields to the data structure			
		Do ..HL7Configuration.ExtendDataStructure(pDataStructure,pNumberToAdd)
		Do ..ConfigChangeLog.LogChange(..%ClassName(1),"DT.ADD","DT",pDataStructure,"",tCurrentCount,tRequiredCount)	
		Do ..Logger.OutputToLog("Updated "_$$$DTINFOX(pDataStructure)_" definition: added "_pNumberToAdd_" components")
	}
}

Method MakeComponentOptionalIfNeeded(pDataStructure As %String, pComponentIndex As %Integer) [ Private ]
{
	// if the component is NOT optional ..
	Set tOldValue=##class(HL7Configuration).GetDataStructure(pDataStructure,pComponentIndex,$$$DTCREQUIRED)
	If tOldValue'="O" {
	
		// make the component optional
		Do ##class(HL7Configuration).UpdateDataStructure(pDataStructure,pComponentIndex,$$$DTCREQUIRED,"O")		
		Do ..ConfigChangeLog.LogChange(..%ClassName(1),"","DT.SETOPT",pDataStructure,pComponentIndex,tOldValue,"O")	
		Do ..Logger.OutputToLog("Updated "_$$$DTINFOX(pDataStructure)_" definition for "_$$$COMPINFOX(..HL7Configuration,pDataStructure,pComponentIndex)_": the component is now Optional")
	}
}

Method UpdateComponentSizeMaxIfNeeded(pDataStructure As %String, pComponentIndex As %Integer, pMaxUsed As %Integer) [ Private ]
{
	Set tOldValue=##class(HL7Configuration).GetDataStructure(pDataStructure,pComponentIndex,$$$DTCMAXLENGTH)
	
	// if the component max size is smaller than the given ..
	If tOldValue<pMaxUsed {

		// set the component maximum size
		Do ##class(HL7Configuration).UpdateDataStructure(pDataStructure,pComponentIndex,$$$DTCMAXLENGTH,pMaxUsed)
		Do ..ConfigChangeLog.LogChange(..%ClassName(1),"","DT.SETMAX",pDataStructure,pComponentIndex,tOldValue,pMaxUsed)	
		Do ..Logger.OutputToLog("Updated "_$$$DTINFOX(pDataStructure)_" definition for "_$$$COMPINFOX(..HL7Configuration,pDataStructure,pComponentIndex)_": the component maximum length is now "_pMaxUsed)
	}
}

Method UpdateComponentSizeMinIfNeeded(pDataStructure As %String, pComponentIndex As %Integer, pMinUsed As %Integer) [ Private ]
{
	Set tOldValue=##class(HL7Configuration).GetDataStructure(pDataStructure,pComponentIndex,$$$DTCMINLENGTH)
	
	// if the component min size is larger than the given ..
	If tOldValue>pMinUsed {

		// set the component minimum size
		Do ##class(HL7Configuration).UpdateDataStructure(pDataStructure,pComponentIndex,$$$DTCMINLENGTH,pMinUsed)
		Do ..ConfigChangeLog.LogChange(..%ClassName(1),"","DT.SETMIN",pDataStructure,pComponentIndex,tOldValue,pMinUsed)	
		Do ..Logger.OutputToLog("Updated "_$$$DTINFOX(pDataStructure)_" definition for "_$$$COMPINFOX(..HL7Configuration,pDataStructure,pComponentIndex)_": the component maximum length is now "_pMinUsed)
	}
}

Method CopyDataStructureToCustomIfNeeded(pCustomVersion As %String, pDataStructure As %String) [ Private ]
{
	Set tDSVersion=$Piece(pDataStructure,":"),tDSName=$Piece(pDataStructure,":",2)
	
	// if the data structure is not in in custom ..
	If '$Data($$$vaSchemaGbl(pCustomVersion,"DT",tDSName)) {
	
		// copy the data structure (ref version to custom)
		Do ##class(PathUpdater).CopyFrom(tDSVersion,pCustomVersion,"DT",tDSName,1)		
		Do ..ConfigChangeLog.LogCopy(..%ClassName(1),"DT.COPY","DT",tDSName,tDSVersion,pCustomVersion)		
		Do ..Logger.OutputToLog("Copied data structure "_tDSVersion_":"_tDSName_" to "_pCustomVersion_":"_tDSName)
	}
}

Method UpdateSSRepeatsAllowedIfNecessary(pSegmentStructure As %String, pFieldIndex As %Integer) [ Private ]
{
	Set tOldValue=##class(HL7Configuration).GetSegmentStructure(pSegmentStructure,pFieldIndex,$$$SSFREPEATING)
		
	If 'tOldValue {

		// set segment to allow repeats 
		Do ##class(HL7Configuration).UpdateSegmentStructure(pSegmentStructure,pFieldIndex,$$$SSFREPEATING,1)
		Do ..ConfigChangeLog.LogChange(..%ClassName(1),"SS.ALLOWREP","SS",pSegmentStructure,pFieldIndex,tOldValue,1)	
		Do ..Logger.OutputToLog("Updated "_$$$SSINFOX(pSegmentStructure)_" definition for "_$$$FIELDINFOX(..HL7Configuration,pSegmentStructure,pFieldIndex)_": the field now allows repeats")
	}
}

Method UpdateSSRepeatLimitIfNecessary(pSegmentStructure As %String, pFieldIndex As %Integer, pMessageMaxRep As %Integer) [ Private ]
{
	Set tOldValue=##class(HL7Configuration).GetSegmentStructure(pSegmentStructure,pFieldIndex,$$$SSFREPEATCOUNT)
		
	If tOldValue<pMessageMaxRep {		
		
		// set the repeat limit
		Do ##class(HL7Configuration).UpdateSegmentStructure(pSegmentStructure,pFieldIndex,$$$SSFREPEATCOUNT,pMessageMaxRep)
		Do ..ConfigChangeLog.LogChange(..%ClassName(1),"SS.SETREPMAX","SS",pSegmentStructure,pFieldIndex,tOldValue,pMessageMaxRep)	
		Do ..Logger.OutputToLog("Updated "_$$$SSINFOX(pSegmentStructure)_" definition for "_$$$FIELDINFOX(..HL7Configuration,pSegmentStructure,pFieldIndex)_": the field now allows "_tMaxRepeat_" repeats")
	}
}

Method UpdateSSClearRepeatsIfNecessary(pSegmentStructure As %String, pFieldIndex As %Integer) [ Private ]
{
	Set tOldValue=##class(HL7Configuration).GetSegmentStructure(pSegmentStructure,pFieldIndex,$$$SSFREPEATCOUNT)

	If tOldValue'="" {
	
		// clear the repeat limit
		Do ##class(HL7Configuration).UpdateSegmentStructure(pSegmentStructure,pFieldIndex,$$$SSFREPEATCOUNT,"")
		Do ..ConfigChangeLog.LogChange(..%ClassName(1),"SS.CLEARREPMAX","SS",pSegmentStructure,pFieldIndex,tOldValue,"")	
		Do ..Logger.OutputToLog("Updated "_$$$SSINFOX(pSegmentStructure)_" definition for "_$$$FIELDINFOX(..HL7Configuration,pSegmentStructure,pFieldIndex)_": the field now allows any number of repeats")
	}
}

Method UpdateSSMakeFieldOptionalIfNecessary(pSegmentStructure As %String, pFieldIndex As %Integer) [ Private ]
{
	Set tOldValue=##class(HL7Configuration).GetSegmentStructure(pSegmentStructure,pFieldIndex,$$$SSFREQUIRED)
	
	If tOldValue'="O" {	
		
		// make the field optional
		Do ##class(HL7Configuration).UpdateSegmentStructure(pSegmentStructure,pFieldIndex,$$$SSFREQUIRED,"O")
		Do ..ConfigChangeLog.LogChange(..%ClassName(1),"SS.SETOPT","SS",pSegmentStructure,pFieldIndex,tOldValue,"O")	
		Do ..Logger.OutputToLog("Updated "_$$$SSINFOX(pSegmentStructure)_" definition for "_$$$FIELDINFOX(..HL7Configuration,pSegmentStructure,pFieldIndex)_": the field is now Optional")
	}
}

Method UpdateSSSetFieldSizeMaxIfNecessary(pSegmentStructure As %String, pFieldIndex As %Integer, pMaxUsed As %Integer) [ Private ]
{
	Set tOldValue=##class(HL7Configuration).GetSegmentStructure(pSegmentStructure,pFieldIndex,$$$SSFMAXLENGTH)
	
	If tOldValue<pMaxUsed {
	
		// set the field maximum size
		Do ##class(HL7Configuration).UpdateSegmentStructure(pSegmentStructure,pFieldIndex,$$$SSFMAXLENGTH,pMaxUsed)
		Do ..ConfigChangeLog.LogChange(..%ClassName(1),"SS.SETMAX","SS",pSegmentStructure,pFieldIndex,tOldValue,pMaxUsed)	
		Do ..Logger.OutputToLog("Updated "_$$$SSINFOX(pSegmentStructure)_" definition for "_$$$FIELDINFOX(..HL7Configuration,pSegmentStructure,pFieldIndex)_": the field maximum length is now "_pMaxUsed)
	}
}

Method UpdateSSSetFieldSizeMinIfNecessary(pSegmentStructure As %String, pFieldIndex As %Integer, pMinUsed As %Integer) [ Private ]
{
	Set tOldValue=##class(HL7Configuration).GetSegmentStructure(pSegmentStructure,pFieldIndex,$$$SSFMINLENGTH)
	
	If tOldValue>pMinUsed {
	
		// set the field minimum size
		Do ##class(HL7Configuration).UpdateSegmentStructure(pSegmentStructure,pFieldIndex,$$$SSFMINLENGTH,pMinUsed)
		Do ..ConfigChangeLog.LogChange(..%ClassName(1),"SS.SETMIN","SS",pSegmentStructure,pFieldIndex,tOldValue,pMinUsed)	
		Do ..Logger.OutputToLog("Updated "_$$$SSINFOX(pSegmentStructure)_" definition for "_$$$FIELDINFOX(..HL7Configuration,pSegmentStructure,pFieldIndex)_": the field minimum length is now "_pMinUsed)
	}
}

}
