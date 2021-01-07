/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (EnsHL7, EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.Validation)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Validation.HL7Configuration Extends %RegisteredObject
{

/// Names(REF)=LASTINDEX - or 0 if no names under REF
/// <p> Names(REF,INDEX)=NAME
Property Names As %String [ MultiDimensional, Private ];

/// CodeTableNextIndex(VERSION:CODETABLE)=NEXTINDEX
Property CodeTableNextIndex As %Integer [ MultiDimensional, Private ];

Method GetNameByKey(pVersionedStructureName As %String, pStructureKey As %String, pIndex As %Integer) As %String [ CodeMode = expression ]
{
..GetNameByRef(..StructureRef(pVersionedStructureName,pStructureKey),pIndex)
}

Method GetNameByRef(pRef As %String, pIndex As %Integer) As %String [ Private ]
{
	If '$Data(..Names(pRef)) {
		Do ..LoadNamesFor(pRef)
	}
	
	Quit $Get(..Names(pRef,pIndex),"#"_pIndex)
}

Method StructureRef(pVersionedStructureName As %String, pStructureKey As %String) As %String [ CodeMode = expression ]
{
$Name($$$vaSchemaGbl($Piece(pVersionedStructureName,":"),pStructureKey,$Piece(pVersionedStructureName,":",2)))
}

ClassMethod GetStructureName(pStructure As %String, pStructureKey As %String) As %String
{
	Set tVersion=$Piece(pStructure,":"),tName=$Piece(pStructure,":",2)
	Quit $Get($$$vaSchemaDescGbl(tVersion,pStructureKey,tName),"#"_tName)
}

ClassMethod GetSegmentStructureName(pSegmentStructure As %String) As %String
{
	Set tSSVersion=$Piece(pSegmentStructure,":"),tSSName=$Piece(pSegmentStructure,":",2)
	Quit $Get($$$vaSchemaDescGbl(tSSVersion,"SS",tSSName),"#"_tSSName)
}

ClassMethod GetSegmentStructure(pSegmentStructure As %String, pFieldIndex As %Integer, pListOffset As %Integer) As %String
{
	Set tSSVersion=$Piece(pSegmentStructure,":"),tSSName=$Piece(pSegmentStructure,":",2)
	Quit $ListGet($ListGet($Get($$$vaSchemaGbl(tSSVersion,"SS",tSSName)),pFieldIndex),pListOffset)
}

ClassMethod UpdateSegmentStructure(pSegmentStructure As %String, pFieldIndex As %Integer, pListOffset As %Integer, pNewSetting)
{
	Set tSSVersion=$Piece(pSegmentStructure,":"),tSSName=$Piece(pSegmentStructure,":",2)
	
	Set tField=$ListGet($$$vaSchemaGbl(tSSVersion,"SS",tSSName),pFieldIndex)
	Set $List(tField,pListOffset)=pNewSetting
	Set $List($$$vaSchemaGbl(tSSVersion,"SS",tSSName),pFieldIndex)=tField
}

ClassMethod SegmentStructureInfo(pSegmentStructure As %String) As %String [ CodeMode = expression ]
{
"segment structure "_pSegmentStructure_" ("_..GetSegmentStructureName(pSegmentStructure)_")"
}

ClassMethod GetDataStructureName(pDataStructure As %String) As %String
{
	Set tDTVersion=$Piece(pDataStructure,":"),tDTName=$Piece(pDataStructure,":",2)
	Quit $Get($$$vaSchemaDescGbl(tDTVersion,"DT",tDTName),"#"_tDTName)
}

ClassMethod GetDataStructure(pDataStructure As %String, pComponentIndex As %Integer, pListOffset As %Integer) As %String
{
	Set tDTVersion=$Piece(pDataStructure,":"),tDTName=$Piece(pDataStructure,":",2)
	Quit $ListGet($ListGet($Get($$$vaSchemaGbl(tDTVersion,"DT",tDTName)),pComponentIndex),pListOffset)
}

ClassMethod UpdateDataStructure(pDataStructure As %String, pComponentIndex As %Integer, pListOffset As %Integer, pNewSetting)
{
	Set tDTVersion=$Piece(pDataStructure,":"),tDTName=$Piece(pDataStructure,":",2)
	
	Set tComponent=$ListGet($$$vaSchemaGbl(tDTVersion,"DT",tDTName),pComponentIndex)
	Set $List(tComponent,pListOffset)=pNewSetting
	Set $List($$$vaSchemaGbl(tDTVersion,"DT",tDTName),pComponentIndex)=tComponent
}

Method ExtendDataStructure(pDataStructure As %String, pToAddCount As %Integer)
{
	Set tDTVersion=$Piece(pDataStructure,":"),tDTName=$Piece(pDataStructure,":",2)
	
	Set tRef=$Name($$$vaSchemaGbl(tDTVersion,"DT",tDTName))
	
	// ensure these names are in the cache
	If '$Data(..Names(tRef)) {
		Do ..LoadNamesFor(tRef)
	}
	
	Set tRecord=$ListBuild("","","","O")
	
	Set tToAdd=""
	Kill tNewNameArr
	Set tLastIndex=..Names(tRef)
	For tI=1:1:pToAddCount {
		Set tIndex=$I(tLastIndex)
		Set tNewNameArr(..MakeNameFor(tRef,tIndex))=tIndex
		Set tToAdd=tToAdd_$ListBuild(tRecord)
	}
	
	// update the DT global
	Set $$$vaSchemaGbl(tDTVersion,"DT",tDTName)=$$$vaSchemaGbl(tDTVersion,"DT",tDTName)_tToAdd
	Merge $$$vaSchemaGbl(tDTVersion,"DT",tDTName,"names")=tNewNameArr
	
	// update our cache
	Do ..LoadNamesFor(tRef)
}

ClassMethod DataStructureInfo(pDataStructure As %String) As %String [ CodeMode = expression ]
{
"data structure "_pDataStructure_" ("_..GetDataStructureName(pDataStructure)_")"
}

ClassMethod GetCodeTableName(pCodeTable As %String) As %String
{
	Set tCTVersion=$Piece(pCodeTable,":"),tCTName=$Piece(pCodeTable,":",2)
	Quit $Get($$$vaSchemaDescGbl(tCTVersion,"CT",tCTName),"#"_tCTName)
}

ClassMethod ExistsInCodeTable(pCodeTable As %String, pCode As %String) As %Boolean
{
	Set tCTVersion=$Piece(pCodeTable,":"),tCTName=$Piece(pCodeTable,":",2)
	Quit $Data($$$vaSchemaGbl(tCTVersion,"CT",tCTName,pCode))
}

Method AddToCodeTable(pCodeTable As %String, pCode As %String)
{
	$$$ACASSERT('..ExistsInCodeTable(pCodeTable,pCode),"AddToCodeTable: entry already present for code '"_pCode_"' in table "_pCodeTable)

	If '$Data(..CodeTableNextIndex(pCodeTable)) {
		Do ..LoadCodeTable(pCodeTable)
	}
	
	Set tCTVersion=$Piece(pCodeTable,":"),tCTName=$Piece(pCodeTable,":",2)
	Set tCodeDescription=..MakeCodeTableNameFor(pCodeTable,pCode)
	
	Set $$$vaSchemaGbl(tCTVersion,"CT",tCTName,pCode)=..CodeTableNextIndex(pCodeTable)
	Set ..CodeTableNextIndex(pCodeTable)=..CodeTableNextIndex(pCodeTable)+1
	Set $$$vaSchemaDescGbl(tCTVersion,"CT",tCTName,pCode)=tCodeDescription
}

ClassMethod CodeTableInfo(pCodeTable As %String) As %String [ CodeMode = expression ]
{
"code table "_pCodeTable_" ("_..GetCodeTableName(pCodeTable)_")"
}

Method ComponentInfo(pDataStructure As %String, pComponentIndex As %Integer) As %String [ CodeMode = expression ]
{
"component "_pComponentIndex_" ("_..GetNameByKey(pDataStructure,"DT",pComponentIndex)_")"
}

Method FieldInfo(pSegmentStructure As %String, pFieldIndex As %Integer) As %String [ CodeMode = expression ]
{
"field "_pFieldIndex_" ("_..GetNameByKey(pSegmentStructure,"SS",pFieldIndex)_")"
}

ClassMethod MakeNameFor(pRef As %String, pIndex As %Integer) As %String [ Private ]
{
	Set tNewName="Unknown"_pIndex
	While $Data(@pRef@("names",tNewName)) {
		Set tNewName=tNewName_"x"
	}
	
	Quit tNewName
}

ClassMethod MakeCodeTableNameFor(pCodeTable As %String, pCode As %String) [ Private ]
{
	Set tCTVersion=$Piece(pCodeTable,":"),tCTName=$Piece(pCodeTable,":",2)
	Set tNewName="Added: code '"_pCode_"'"
	While $Data($$$vaSchemaGbl(tCTVersion,"CT",tCTName,tNewName)) {
		Set tNewName=tNewName_"."
	}
	
	Quit tNewName
}

Method LoadCodeTable(pCodeTable As %String) [ Private ]
{
	Set tCTVersion=$Piece(pCodeTable,":"),tCTName=$Piece(pCodeTable,":",2)
	Kill tIndices
	Set tCodeKey="" While 1 {
		Set tCodeKey=$Order($$$vaSchemaGbl(tCTVersion,"CT",tCTName,tCodeKey),+1,tCodeIndex) If tCodeKey="" {Quit}
		Set tIndices(tCodeIndex)=""
	}	
	
	Set ..CodeTableNextIndex(pCodeTable)=$Order(tIndices(""),-1)+1
}

Method LoadNamesFor(pRef As %String) [ Private ]
{
	Kill ..Names(pRef)
	Set tName="" While 1 {
		Set tName=$Order(@pRef@("names",tName),+1,tIndex) If tName="" {Quit}
		Set ..Names(pRef,tIndex)=tName
	}
	
	Set ..Names(pRef)=$Select($Data(..Names(pRef))\10:$Order(..Names(pRef,""),-1),1:0)
}

}
