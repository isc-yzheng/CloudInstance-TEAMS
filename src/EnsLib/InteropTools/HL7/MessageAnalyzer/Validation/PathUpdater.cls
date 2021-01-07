/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.Common, EnsLib.InteropTools.HL7.MessageAnalyzer.Ensemble, EnsLib.InteropTools.HL7.MessageAnalyzer.Logging, EnsLib.HL7)

Include (EnsHL7, EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.Validation)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Validation.PathUpdater Extends %RegisteredObject
{

Property HL7Message As Message [ Private ];

Property CustomVersion As %String [ Private ];

Property SchemaName As %String [ Private ];

Property SegmentName As %String [ Private ];

Property SegmentIndex As %Integer [ Private ];

Property ConfigChangeLog As ConfigChangeLog [ Private ];

Property Logger As Logger [ Private ];

Method %OnNew(pHL7Message As Message, pCustomVersion As %String, pSchemaName As %String, pSegmentName As %String, pSegmentIndex As %Integer, pConfigChangeLog As ConfigChangeLog, pLogger As Logger) As %Status
{
	$$$ACASSERT(pSchemaName'[":","FieldComponentCountRep: pDocStruct should not include a schema prefix - "_pSchemaName)
	$$$ACASSERT(pSegmentName'[":","FieldComponentCountRep: pSegmentName should not include a schema prefix - "_pSegmentName)

	// the schema must be in custom
	$$$ACASSERT($Data($$$vaSchemaGbl(pCustomVersion,"MS",pSchemaName)),"Document structure "_pCustomVersion_":"_pSchemaName_" not found")

	Set ..HL7Message=pHL7Message
	Set ..CustomVersion=pCustomVersion
	Set ..SchemaName=pSchemaName
	Set ..SegmentName=pSegmentName
	Set ..SegmentIndex=pSegmentIndex
	Set ..ConfigChangeLog=pConfigChangeLog
	Set ..Logger=pLogger
	Quit $$$OK
}

/// pPath is $ListBuild($ListBuild(ACCESSPOINT,INDEX))
/// <p> Returns $ListBuild(0,ERR) or $ListBuild(1,KIND,LIBRARYVERSION,NAME)
/// <p> ERR is a string
/// <p> KIND refers to the final item: "DT" or "CT"
/// <p> LIBRARYVERSION is the original schema of the final item
/// <p> NAME is the name of the final item
/// <p> If the given path is "" the KIND, LIBRARYVERSION and NAME will all be returned as ""
/// <p> -
/// <p> pFindCodeTable is $ListBuild(FIELDINDEX,COMPONENTINDEX,SUBCOMPONENTINDEX,CODETABLE) if given
Method Update(pPath As %List, Output pPathResult As Path, pFindCodeTable As %List = "") As %List
{
	Set pPathResult=##class(Path).%New()
	Set tRet=..SetupSchemaAndSegment(pPathResult,.tSegmentStructure)
	If tRet'="" {Quit $ListBuild(0,tRet)}
	
	If pFindCodeTable'="" {
		Set $ListBuild(tFieldIndex,tComponentIndex,tSubcomponentIndex,tCodeTable)=pFindCodeTable
		Set tPath=..CodeMissingPath(..CustomVersion,tSegmentStructure,tFieldIndex,tComponentIndex,tSubcomponentIndex,tCodeTable)
		If tPath="" {
			Quit $ListBuild(0,"Unable to form path to codetable: "_tCodeTable)
		}
	}
	Else {
		If pPath="" {
			Quit $ListBuild(1,"","","")
		}

		Set tPath=pPath
	}
		
	Quit ..UpdateFromPath(tPath,pPathResult)
}

/// pPath is $ListBuild($ListBuild(ACCESSPOINT,INDEX))
/// <p> ACCESSPOINT is "DT" or "CT"
/// <p> INDEX is a field index or component index
/// <p> Returns $ListBuild(0,ERR) or $ListBuild(1,KIND,LIBRARYVERSION,NAME)
Method UpdateFromPath(pPath As %List, pPathResult As Path) As %List [ Private ]
{
	$$$ACASSERT($Get(pPath)'="","UpdateFromPath: no path given")
	
	Set tCurrentKind="SS"
	Set tCurrentItem=..SegmentName
	Set tCurrentLibraryVersion=""
	Set tIndex=""
	For tI=1:1:$ListLength(pPath) { // pPath is not expected to merit using $ListNext

		Set tRet=..UpdateFromPathItem($List(pPath,tI),pPathResult,tCurrentKind,tCurrentLibraryVersion,tCurrentItem)
		
		// if it's an error ..
		If '$List(tRet) {
			Return tRet
		}
		
		Set $ListBuild(tDummy,tCurrentKind,tCurrentLibraryVersion,tCurrentItem)=tRet
	}
	
	Quit $ListBuild(1,tCurrentKind,tCurrentLibraryVersion,tCurrentItem)
}

/// pPathItem is $ListBuild(ACCESSPOINT,INDEX)
/// <p> ACCESSPOINT is "DT" or "CT"
/// <p> INDEX is a field index or component index
/// <p> Returns $ListBuild(0,ERR) or $ListBuild(1,KIND,LIBRARYVERSION,NAME)
Method UpdateFromPathItem(pPathItem As %List, pPathResult As Path, pCurrentKind As %String, pCurrentLibraryVersion As %String, pCurrentItem As %String) As %List [ Private ]
{
	Set $ListBuild(tAccessPoint,tIndex)=pPathItem

	If tAccessPoint="DT" {
	
		// if the current is a segment ..
		If pCurrentKind="SS" {
	
			// get the existing reference to the field-level data structure from the custom segment structure
			Set tSegmentDataStructure=$List($ListGet($Get($$$vaSchemaGbl(..CustomVersion,"SS",pCurrentItem)),tIndex))
			If tSegmentDataStructure="" {Return $ListBuild(0,"Data structure does not appear in field "_tIndex_" of segment: '"_..CustomVersion_":"_pCurrentItem_"'")}
				
			Set tNextLibraryVersion=$Piece(tSegmentDataStructure,":")

			Set tSegmentDataStructureName=$Piece(tSegmentDataStructure,":",2)
			Set tCustomDT=..CustomVersion_":"_tSegmentDataStructureName

			Do pPathResult.AddToPath("DT",tSegmentDataStructureName)
		
			Do ..CopyDataStructureToCustomIfNeeded(tSegmentDataStructure,pPathResult)

			// if the custom segment structure's reference to the data structure is not to the custom version ..
			If tSegmentDataStructure'=tCustomDT {
				
				// set the custom segment's reference to the data structure to custom
				Set tSSRecField=$List($$$vaSchemaGbl(..CustomVersion,"SS",pCurrentItem),tIndex)
				Set $List(tSSRecField)=tCustomDT
				Set $List($$$vaSchemaGbl(..CustomVersion,"SS",pCurrentItem),tIndex)=tSSRecField
				Do ..ConfigChangeLog.LogChange(..%ClassName(1),"SS.SETDT","SS",..CustomVersion_":"_pCurrentItem,tIndex,tSegmentDataStructure,tCustomDT)
				Do ..Logger.OutputToLog("Updated segment structure "_..CustomVersion_":"_pCurrentItem_": used custom schema for field '"_tIndex_"' data structure '"_tSegmentDataStructureName_"'")
				
				Do pPathResult.SetUpdatedRef("SS",pCurrentItem)
			}
			
			Set tNextKind="DT"
			Set tNextItem=tSegmentDataStructureName
		}
		
		// .. the current is a data structure ..
		ElseIf pCurrentKind="DT" {
		
			// get the existing reference to the component-level data structure from the custom field-level data structure
			Set tDSDataStructure=$List($ListGet($Get($$$vaSchemaGbl(..CustomVersion,"DT",pCurrentItem)),tIndex))
			If tDSDataStructure="" {Return $ListBuild(0,"Data structure does not appear in component "_pPrevIndex_" of data structure: '"_..CustomVersion_":"_pCurrentItem_"'")}

			Set tNextLibraryVersion=$Piece(tDSDataStructure,":")
			
			Set tDSDataStructureName=$Piece(tDSDataStructure,":",2)
			Set tDSCustomDT=..CustomVersion_":"_tDSDataStructureName
			
			Do pPathResult.AddToPath("DT",tDSDataStructureName)
			
			Do ..CopyDataStructureToCustomIfNeeded(tDSDataStructure,pPathResult)
			
			// if the custom field-level data structure's reference to the component-level data structure is not to the custom version ..
			If tDSDataStructure'=tDSCustomDT {
				
				// set the custom field-level data structure's reference to the component-level data structure to custom
				Set tDTRecField=$List($$$vaSchemaGbl(..CustomVersion,"DT",pCurrentItem),tIndex)
				Set $List(tDTRecField)=tDSCustomDT
				Set $List($$$vaSchemaGbl(..CustomVersion,"DT",pCurrentItem),tIndex)=tDTRecField
				Do ..ConfigChangeLog.LogChange(..%ClassName(1),"DT.SET","DT",..CustomVersion_":"_pCurrentItem,tIndex,tDSDataStructure,tDSCustomDT)
				Do ..Logger.OutputToLog("Updated data structure "_..CustomVersion_":"_pCurrentItem_": used custom schema for component '"_tIndex_"' data structure '"_tDSDataStructureName_"'")
				
				Do pPathResult.SetUpdatedRef("DT",pCurrentItem)
			}
			
			Set tNextKind="DT"
			Set tNextItem=tDSDataStructureName	
		}
		
		Else {
			ZTrap
		}
	}

	ElseIf tAccessPoint="CT" {
	
		// if the current is a segment ..
		If pCurrentKind="SS" {

			// get the existing reference to the code table from the custom segment structure
			Set tSegmentCodeTable=$Get($$$vaSchemaGbl(..CustomVersion,"SS",pCurrentItem,"tables",tIndex))
			If tSegmentCodeTable="" {Return $ListBuild(0,"Code does not appear in field "_tIndex_" of segment: '"_..CustomVersion_":"_pCurrentItem_"'")}
			
			Set tNextLibraryVersion=$Piece(tSegmentCodeTable,":")
			
			Set tSegmentCodeTableName=$Piece(tSegmentCodeTable,":",2)
			Set tCTCustomCT=..CustomVersion_":"_tSegmentCodeTableName
			
			Do pPathResult.AddToPath("CT",tSegmentCodeTableName)
			
			Do ..CopyCodeTableToCustomIfNeeded(tSegmentCodeTable,pPathResult)
			
			// if the custom segment structure's reference to the code is not to the custom version ..
			If tSegmentCodeTable'=tCTCustomCT {
				
				// set the reference to the code table to custom
				Set $$$vaSchemaGbl(..CustomVersion,"SS",pCurrentItem,"tables",tIndex)=tCTCustomCT
				Do ..ConfigChangeLog.LogChange(..%ClassName(1),"SS.SETCT","SS",..CustomVersion_":"_pCurrentItem,tIndex,tSegmentCodeTable,tCTCustomCT)
				Do ..Logger.OutputToLog("Updated segment structure "_..CustomVersion_":"_pCurrentItem_": used custom schema for field '"_tIndex_"' code table '"_tSegmentCodeTableName_"'")
				
				Do pPathResult.SetUpdatedRef("SS",pCurrentItem)
			}
											
			Set tNextKind="CT"
			Set tNextItem=tSegmentCodeTableName	
		}
		
		// .. the current is a data structure ..
		ElseIf pCurrentKind="DT" {
	
			// get the existing reference to the code table from the custom data structure
			Set tDTCodeTable=$Get($$$vaSchemaGbl(..CustomVersion,"DT",pCurrentItem,"tables",tIndex))
			If tDTCodeTable="" {Return $ListBuild(0,"Code does not appear in component "_tIndex_" of data structure: '"_..CustomVersion_":"_pCurrentItem_"'")}
			
			Set tNextLibraryVersion=$Piece(tDTCodeTable,":")
			
			Set tDTCodeTableName=$Piece(tDTCodeTable,":",2)
			Set tCTCustomCT=..CustomVersion_":"_tDTCodeTableName
			
			Do pPathResult.AddToPath("CT",tDTCodeTableName)
			
			Do ..CopyCodeTableToCustomIfNeeded(tDTCodeTable,pPathResult)
			
			// if the custom data structure's reference to the code is not to the custom version ..
			If tDTCodeTable'=tCTCustomCT {
				
				// set the reference to the code table to custom
				Set $$$vaSchemaGbl(..CustomVersion,"DT",pCurrentItem,"tables",tIndex)=tCTCustomCT
				Do ..ConfigChangeLog.LogChange(..%ClassName(1),"DT.SETCT","DT",..CustomVersion_":"_pCurrentItem,tIndex,tDTCodeTable,tCTCustomCT)
				Do ..Logger.OutputToLog("Updated data structure "_..CustomVersion_":"_pCurrentItem_": used custom schema for component '"_tIndex_"' code table '"_tDTCodeTableName_"'")
				
				Do pPathResult.SetUpdatedRef("DT",pCurrentItem)
			}
											
			Set tNextKind="CT"
			Set tNextItem=tDTCodeTableName	
		}
	
		Else {
			ZTrap
		}		
	}
	
	Else {
		ZTrap
	}
	
	Quit $ListBuild(1,tNextKind,tNextLibraryVersion,tNextItem)
}

/// Returns error message, or "" if OK
Method SetupSchemaAndSegment(pPathResult As Path, Output pSegmentStructure As %String) As %String [ Private ]
{
	
	Do pPathResult.AddToPath("MS",..SchemaName)
	
	Do pPathResult.AddToPath("SS",..SegmentName)
	
	// find the part of the schema that the message segment corresponds to	
	Set tSchemaSource=$$$vaSchemaGbl(..CustomVersion,"MS",..SchemaName)
	
	Set tRet=..FindSegment(..CustomVersion,..SchemaName,tSchemaSource,..HL7Message,..SegmentIndex)
	If tRet="" {Quit "Unable to find segment"} // - failed to find the segment
	
	Set $ListBuild(tSchemaStartOffset,tSchemaEndOffset)=tRet
	Set tSchemaSegmentRef=$Extract(tSchemaSource,tSchemaStartOffset,tSchemaEndOffset)
	If tSchemaSegmentRef[":" {
		Set tSchemaSegmentVersion=$Piece(tSchemaSegmentRef,":")
		Set tSchemaSegmentName=$Piece(tSchemaSegmentRef,":",2)
	}
	Else {
		Set tSchemaSegmentVersion=..CustomVersion
		Set tSchemaSegmentName=tSchemaSegmentRef
	}
	
	If tSchemaSegmentName'=..SegmentName {Quit "Segment name in document structure does not match given segment name: '"_tSchemaSegmentName_"' <> '"_..SegmentName_"'"}
	
	// if the segment structure isn't in custom ..
	If '$Data($$$vaSchemaGbl(..CustomVersion,"SS",..SegmentName)) {
				
		// copy the segment structure (schema ref version to custom)
		Do ..CopyFrom(tSchemaSegmentVersion,..CustomVersion,"SS",..SegmentName)
		Do ..ConfigChangeLog.LogCopy(..%ClassName(1),"SS.COPY","SS",..SegmentName,tSchemaSegmentVersion,..CustomVersion)
		Do ..Logger.OutputToLog("Copied segment structure "_tSchemaSegmentVersion_":"_..SegmentName_" to "_..CustomVersion_":"_..SegmentName)
		
		Do pPathResult.SetCopied("SS",..SegmentName)
	}
	
	// if the custom schema's reference to the segment structure isn't what we want ..
	If tSchemaSegmentRef'=(..CustomVersion_":"_..SegmentName) {
	
		// set the custom schema's reference to the segment to custom
		Set tNewSchemaSource=tSchemaSource
		Set $Extract(tNewSchemaSource,tSchemaStartOffset,tSchemaEndOffset)=..CustomVersion_":"_..SegmentName
			
		Set $$$vaSchemaGbl(..CustomVersion,"MS",..SchemaName)=tNewSchemaSource
		Do ##class(Schema).BuildCategoryMaps(..CustomVersion)		
		
		Do ..ConfigChangeLog.LogChange(..%ClassName(1),"MS.SET","MS",..CustomVersion_":"_..SchemaName,..SegmentName,tSchemaSource,tNewSchemaSource)
	
		Do ..Logger.OutputToLog("Updated document structure "_..CustomVersion_":"_..SchemaName_": used custom schema for segment '"_..SegmentName_"'")

		Do pPathResult.SetUpdatedRef("MS",..SchemaName)
	}
		
	// no error
	Set pSegmentStructure=tSchemaSegmentRef
	Quit ""
}

ClassMethod DescribeChange(pHL7Configuration As HL7Configuration, pClassArgs As %String, pCategory As %String, pSubCategory As %String, pItem As %String, pOldData As %String, pNewData As %String) As %List
{
	If pClassArgs="CT.ADD" {
		Quit $ListBuild("Code table "_pSubCategory_": added code '"_pItem_"'",##class(HL7Configuration).ExistsInCodeTable(pSubCategory,pItem))
	}
	
	If pClassArgs="DT.ADD" {
		Quit $ListBuild("Data structure "_pSubCategory_": added "_(pNewData-pOldData)_" components",$$DSComponentCount(pSubCategory))
	}
	
	If pClassArgs="SS.SETCT" {
		Set tSSVersion=$Piece(pSubCategory,":")
		Set tSSName=$Piece(pSubCategory,":",2)
		Set tCurrentValue=$Get($$$vaSchemaGbl(tSSVersion,"SS",tSSName,"tables",pItem))
		Set tCodeTable=$Piece(pNewData,":",2)
		Quit $ListBuild("Segment structure "_pSubCategory_": used custom schema for field '"_pItem_"' code table '"_tCodeTable_"'",tCurrentValue)
	}
	
	If pClassArgs="DT.SETCT" {
		Set tDTVersion=$Piece(pSubCategory,":")
		Set tDTName=$Piece(pSubCategory,":",2)
		Set tCurrentValue=$Get($$$vaSchemaGbl(tDTVersion,"DT",tDTName,"tables",pItem))
		Set tCodeTable=$Piece(pNewData,":",2)
		Quit $ListBuild("Data structure "_pSubCategory_": used custom schema for component '"_pItem_"' code table '"_tCodeTable_"'",tCurrentValue)
	}
	
	If pClassArgs="SS.SETDT" {
		Set tSSVersion=$Piece(pSubCategory,":")
		Set tSSName=$Piece(pSubCategory,":",2)
		Set tCurrentValue=$List($ListGet($Get($$$vaSchemaGbl(tSSVersion,"SS",tSSName)),pItem))
		Set tDataStructure=$Piece(pNewData,":",2)
		Quit $ListBuild("Segment structure "_pSubCategory_": used custom schema for field '"_pItem_"' data structure '"_tDataStructure_"'",tCurrentValue)
	}
	
	If pClassArgs="MS.SET" {
		Set tCustomVersion=$Piece(pSubCategory,":")
		Set tDocStruct=$Piece(pSubCategory,":",2)
		Set tCurrentValue=$Get($$$vaSchemaGbl(tCustomVersion,"MS",tDocStruct))
		Quit $ListBuild("Document structure "_pSubCategory_": used custom schema for segment '"_pItem_"'",tCurrentValue)
	}
	
	If pClassArgs="DT.SET" {
		Set tDTVersion=$Piece(pSubCategory,":")
		Set tDTName=$Piece(pSubCategory,":",2)
		Set tCurrentValue=$List($ListGet($Get($$$vaSchemaGbl(tDTVersion,"DT",tDTName)),pItem))
		Set tSubDTTable=$Piece(pNewData,":",2)
		Quit $ListBuild("Data structure "_pSubCategory_": used custom schema for component "_pItem_" data structure '"_tSubDTTable_"'",tCurrentValue)
	}
	
	If pClassArgs="DT.SETOPT" {
		Quit $ListBuild("Data structure "_pSubCategory_": make "_$$$COMPINFOX(pHL7Configuration,pSubCategory,pItem)_" optional (was '"_pOldData_"')",##class(HL7Configuration).GetDataStructure(pSubCategory,pItem,$$$DTCREQUIRED))
	}
	
	If pClassArgs="DT.SETMAX" {
		Quit $ListBuild("Data structure "_pSubCategory_": set maximum length for "_$$$COMPINFOX(pHL7Configuration,pSubCategory,pItem)_" to "_pNewData_" (was "_pOldData_")",##class(HL7Configuration).GetDataStructure(pSubCategory,pItem,$$$DTCMAXLENGTH))
	}
	
	If pClassArgs="DT.SETMIN" {
		Quit $ListBuild("Data structure "_pSubCategory_": set minimum length for "_$$$COMPINFOX(pHL7Configuration,pSubCategory,pItem)_" to "_pNewData_" (was "_pOldData_")",##class(HL7Configuration).GetDataStructure(pSubCategory,pItem,$$$DTCMINLENGTH))
	}
	
	If pClassArgs="SS.ALLOWREP" {
		Quit $ListBuild("Segment structure "_pSubCategory_": allow repetitions of "_$$$FIELDINFOX(pHL7Configuration,pSubCategory,pItem)_" (was '"_pOldData_"')",##class(HL7Configuration).GetSegmentStructure(pSubCategory,pItem,$$$SSFREPEATING))
	}
	
	If pClassArgs="SS.SETREPMAX" {
		Quit $ListBuild("Segment structure "_pSubCategory_": set maximum repetitions of "_$$$FIELDINFOX(pHL7Configuration,pSubCategory,pItem)_" to "_pNewData_" (was '"_pOldData_"')",##class(HL7Configuration).GetSegmentStructure(pSubCategory,pItem,$$$SSFREPEATCOUNT))
	}
	
	If pClassArgs="SS.CLEARREPMAX" {
		Quit $ListBuild("Segment structure "_pSubCategory_": clear maximum repetitions of "_$$$FIELDINFOX(pHL7Configuration,pSubCategory,pItem)_" (was '"_pOldData_"')",##class(HL7Configuration).GetSegmentStructure(pSubCategory,pItem,$$$SSFREPEATCOUNT))
	}
	
	If pClassArgs="SS.SETOPT" {
		Quit $ListBuild("Segment structure "_pSubCategory_": make "_$$$FIELDINFOX(pHL7Configuration,pSubCategory,pItem)_" optional (was '"_pOldData_"')",##class(HL7Configuration).GetSegmentStructure(pSubCategory,pItem,$$$SSFREQUIRED))
	}
	
	If pClassArgs="SS.SETMAX" {
		Quit $ListBuild("Segment structure "_pSubCategory_": set maximum length for "_$$$FIELDINFOX(pHL7Configuration,pSubCategory,pItem)_" to "_pNewData_" (was "_pOldData_")",##class(HL7Configuration).GetSegmentStructure(pSubCategory,pItem,$$$SSFMAXLENGTH))
	}
	
	If pClassArgs="SS.SETMIN" {
		Quit $ListBuild("Segment structure "_pSubCategory_": set minimum length for "_$$$FIELDINFOX(pHL7Configuration,pSubCategory,pItem)_" to "_pNewData_" (was "_pOldData_")",##class(HL7Configuration).GetSegmentStructure(pSubCategory,pItem,$$$SSFMINLENGTH))
	}
	
	ZTrap
	
DSComponentCount(datastructure)
	Set dsversion=$Piece(datastructure,":"),dsname=$Piece(datastructure,":",2)
	Quit $ListLength($Get($$$vaSchemaGbl(dsversion,"DT",dsname)))
}

ClassMethod DescribeCopy(pHL7Configuration As HL7Configuration, pClassArgs As %String, pCategory As %String, pItem As %String, pSourceVersion As %String, pTargetVersion As %String) As %List
{
	If pClassArgs="CT.COPY" {
		Quit $ListBuild("Code table "_pItem_" copied from "_pSourceVersion_" to "_pTargetVersion)
	}
	
	If pClassArgs="SS.COPY" {
		Quit $ListBuild("Segment structure "_pItem_" copied from "_pSourceVersion_" to "_pTargetVersion)
	}
	
	If pClassArgs="DT.COPY" {
		Quit $ListBuild("Data structure "_pItem_" copied from "_pSourceVersion_" to "_pTargetVersion)
	}
	
	ZTrap
}

/// Returns $ListBuild(SCHEMASTARTOFFSET,SCHEMAENDOFFSET) or "" if not found
/// <p> SCHEMAENDOFFSET is the index of the last character of the segment reference, NOT the one after
ClassMethod FindSegment(pVersion As %String, pSchemaName As %String, pSchemaSource As %String, pHL7Message As Message, pSegmentIndex As %Integer) As %List [ Private ]
{
	// make a RigSchema
	Set tConfig=##class(EnsLib.InteropTools.HL7.MessageAnalyzer.Shell.Config).%New()
	Set tLogger=##class(EnsLib.InteropTools.HL7.MessageAnalyzer.Logging.Logger).%New()
	Set tRigSchema=##class(EnsLib.InteropTools.HL7.MessageAnalyzer.Common).MakeRigSchema(pSchemaSource,tConfig,tLogger,1,pSchemaName)
	
	// ensure it's compiled
	Do tRigSchema.CheckNFABuilder()
	
	// the segment names from the message
	Set tMessageSegmentTypes=..MessageSegmentTypes(pHL7Message)
	
	// the segment name at the index
	Set tMessageSegmentName=$List(tMessageSegmentTypes,pSegmentIndex)
	
	// match the schema against the message segments
	Set tRet=##class(EnsLib.InteropTools.HL7.MessageAnalyzer.Common).RunImplMatch(tMessageSegmentTypes,tRigSchema,tConfig,1)

	// the message-offset/schema-offset-list cross-reference
	Set tMSXList=$List(tRet,4)
	
	// for each outcome ..
	For tListI=1:1:$ListLength(tMSXList) {
	
		Set tMSX=$List(tMSXList,tListI)
		
		// for each message-offset/schema-offset-list entry ..
		For tXrefI=1:1:$ListLength(tMSX) {
		
			Set $ListBuild(tMessageOffset,tSchemaOffsets)=$List(tMSX,tXrefI)
			
			// if this is the right message offset ..
			If tMessageOffset=pSegmentIndex {
			
				Set $ListBuild(tSchemaStartOffset,tSchemaAfterEndOffset)=tSchemaOffsets
				
				// fetch the schema segment name
				Set tSchemaText=$Extract(pSchemaSource,tSchemaStartOffset,tSchemaAfterEndOffset-1)
				Set tSchemaSegmentName=$Select(tSchemaText[":":$Piece(tSchemaText,":",2),1:tSchemaText)
				
				// if it matches the message segment name ..
				If tSchemaSegmentName=tMessageSegmentName {
			
					// return the schema offsets after adjusting the end offset from after-end to at-end
					Return $ListBuild(tSchemaStartOffset,tSchemaAfterEndOffset-1)
				}
			}
		}
	}
	
	// not found
	Quit ""
}

ClassMethod MessageSegmentTypes(pHL7Message As Message) [ Private ]
{
	Set tSegCount=pHL7Message.SegCount
	Set tOut=""
	For i=1:1:tSegCount {
		Set tSegment=pHL7Message.getSegmentByIndex(i)
		Set tOut=tOut_$ListBuild(tSegment.SegTypeName)
	}
	
	Quit tOut
}

Method CopyDataStructureToCustomIfNeeded(pDataStructure As %String, pPathResult As Path) [ Private ]
{
	Set tDSVersion=$Piece(pDataStructure,":"),tDSName=$Piece(pDataStructure,":",2)
	
	// if the data structure is not in in custom ..
	If '$Data($$$vaSchemaGbl(..CustomVersion,"DT",tDSName)) {
	
		// copy the data structure (ref version to custom)
		Do ..CopyFrom(tDSVersion,..CustomVersion,"DT",tDSName,1)		
		Do ..ConfigChangeLog.LogCopy(..%ClassName(1),"DT.COPY","DT",tDSName,tDSVersion,..CustomVersion)		
		Do ..Logger.OutputToLog("Copied data structure "_tDSVersion_":"_tDSName_" to "_..CustomVersion_":"_tDSName)
		
		Do pPathResult.SetCopied("DT",tDSName)
	}
}

Method CopyCodeTableToCustomIfNeeded(pCodeTable As %String, pPathResult As Path) [ Private ]
{
	Set tCTVersion=$Piece(pCodeTable,":"),tCTName=$Piece(pCodeTable,":",2)
	
	// if the data structure is not in in custom ..
	If '$Data($$$vaSchemaGbl(..CustomVersion,"CT",tCTName)) {
	
		// copy the data structure (ref version to custom)
		Do ..CopyFrom(tCTVersion,..CustomVersion,"CT",tCTName,1)		
		Do ..ConfigChangeLog.LogCopy(..%ClassName(1),"CT.COPY","CT",tCTName,tCTVersion,..CustomVersion)		
		Do ..Logger.OutputToLog("Copied code table "_tCTVersion_":"_tCTName_" to "_..CustomVersion_":"_tCTName)
		
		Do pPathResult.SetCopied("CT",tCTName)
	}
}

/// Copies an entity to a custom version from its base version
/// <p> pKind is the global key - e.g. "SS" for a segment structure
/// <p> pItem is the name of the segment structure etc.
/// <p> - if the target entity already exists this method throws a fatal exception, unless pIfNeeded is passed as true in which case the method simply returns
ClassMethod CopyFromBase(pCustomVersion As %String, pKind As %String, pItem As %String, pIfNeeded As %Boolean = 0)
{
	Set tBaseVersion=..BaseVersion(pCustomVersion)
	$$$ACASSERT(tBaseVersion'="","CopyFromBase: '"_pCustomVersion_"' has no base schema")
	
	Do ..CopyFrom(tBaseVersion,pCustomVersion,pKind,pItem,pIfNeeded)
}

/// Copies an entity to a custom version from a given version
/// <p> pKind is the global key - e.g. "SS" for a segment structure
/// <p> pItem is the name of the segment structure etc. 
/// <p> - if the target entity already exists this method throws a fatal exception, unless pIfNeeded is passed as true in which case the method simply returns
ClassMethod CopyFrom(pSourceVersion As %String, pCustomVersion As %String, pKind As %String, pItem As %String, pIfNeeded As %Boolean = 0)
{
	If $Data($$$vaSchemaGbl(pCustomVersion,pKind,pItem)) {
		If pIfNeeded {
			Quit
		}
		$$$THROW("CopyFrom: destination exists")
	}
	
	Merge $$$vaSchemaGbl(pCustomVersion,pKind,pItem)=$$$vaSchemaGbl(pSourceVersion,pKind,pItem)
	Merge $$$vaSchemaDescGbl(pCustomVersion,pKind,pItem)=$$$vaSchemaDescGbl(pSourceVersion,pKind,pItem)
}

/// Given a custom version, return its base version (or "" if none)
ClassMethod BaseVersion(pCustomVersion As %String) As %String [ CodeMode = expression ]
{
$Get($$$vaSchemaGbl(pCustomVersion,"base"))
}

/// Create a custom version based on a given base.
/// <p> - throws a fatal exception if the custom version already exists
ClassMethod MakeCustomVersion(pCustomVersion As %String, pBaseVersion As %String)
{
	If $Data($$$vaSchemaGbl(pCustomVersion)) {
		$$$THROW("MakeCustomVersion: '"_pCustomVersion_"' already exists")
	}
	
	Set $$$vaSchemaGbl(pCustomVersion,"base")=pBaseVersion
	Set $$$vaSchemaGbl(pCustomVersion,"time")=$Now()
}

ClassMethod CopyAndUpdateMessageTypesIfNeeded(pCustomVersion As %String, pSchemaName As %String) As %List
{
	Set tBaseVersion=$$$vaSchemaGbl(pCustomVersion,"base")
	
	Set tChangedList=""
	Set tMT="" While 1 {
	
		Set tMT=$Order($$$vaSchemaGbl(tBaseVersion,"MT",tMT),+1,tRec) If tMT="" {Quit}
		
		Set tMTVersion=$Piece(tRec,":"),tMTSchema=$Piece(tRec,":",2)
		If tMTVersion=tBaseVersion,tMTSchema=pSchemaName {
		
			// if the message type isn't in custom ..
			If '$Data($$$vaSchemaGbl(pCustomVersion,"MT",tMT)) {
					
				// copy the message type (base version to custom)
				Do ..CopyFromBase(pCustomVersion,"MT",tMT,1)
				
				// update it to point to the custom schema
				Set $Piece($$$vaSchemaGbl(pCustomVersion,"MT",tMT),":")=pCustomVersion
				
				Set tChangedList=tChangedList_$ListBuild(tMT)
			}
		}
	}
	
	Quit tChangedList
}

/// Returns a path, or "" if failure
ClassMethod CodeMissingPath(pCustomVersion As %String, pSegmentStructure As %String, pFieldIndex As %Integer, pComponentIndex As %Integer, pSubcomponentIndex As %Integer, pCodeTable As %String) As %List [ Private ]
{
	Set tCustomCodeTable=pCustomVersion_":"_$Piece(pCodeTable,":",2)
	
	// Look for codetable reference in segment structure
	Set tSSVersion=$Piece(pSegmentStructure,":"),tSSName=$Piece(pSegmentStructure,":",2)
	Set tSSCodeTable=$Get($$$vaSchemaGbl(tSSVersion,"SS",tSSName,"tables",pFieldIndex))
	If (tSSCodeTable=pCodeTable) || (tSSCodeTable=tCustomCodeTable) {
		Quit $ListBuild($ListBuild("CT",pFieldIndex))
	}
	
	// Follow data structure reference in segment structure
	Set tSSDataStructure=$List($ListGet($Get($$$vaSchemaGbl(tSSVersion,"SS",tSSName)),pFieldIndex))
	If tSSDataStructure="" {
		Quit ""
	}
	Set tDTVersion=$Piece(tSSDataStructure,":"),tDTName=$Piece(tSSDataStructure,":",2)
	Set tDTCodeTable=$Get($$$vaSchemaGbl(tDTVersion,"DT",tDTName,"tables",pComponentIndex))
	If (tDTCodeTable=pCodeTable) || (tDTCodeTable=tCustomCodeTable) {
		Quit $ListBuild($ListBuild("DT",pFieldIndex),$ListBuild("CT",pComponentIndex))
	}
	
	// Follow data structure reference in segment data structure
	Set tDTDataStructure=$List($ListGet($Get($$$vaSchemaGbl(tDTVersion,"DT",tDTName)),pComponentIndex))
	If tDTDataStructure="" {
		Quit ""
	}
	Set tDTDTVersion=$Piece(tDTDataStructure,":"),tDTDTName=$Piece(tDTDataStructure,":",2)
	Set tDTDTCodeTable=$Get($$$vaSchemaGbl(tDTDTVersion,"DT",tDTDTName,"tables",pSubcomponentIndex))
	If (tDTDTCodeTable=pCodeTable) || (tDTDTCodeTable=tCustomCodeTable) {
		Quit $ListBuild($ListBuild("DT",pFieldIndex),$ListBuild("DT",pComponentIndex),$ListBuild("CT",pSubcomponentIndex))
	}
	
	Quit ""
}

}
