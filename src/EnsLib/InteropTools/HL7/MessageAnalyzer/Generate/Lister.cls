/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Message)

Include (EnsHL7, EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.Validation)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Generate.Lister Extends %RegisteredObject
{

Property SimpleMessage As SimpleMessage [ Private ];

Property Version As %String [ Private ];

Method %OnNew(pSimpleMessage As SimpleMessage, pVersion As %String) As %Status
{
	Set ..SimpleMessage=pSimpleMessage
	Set ..Version=##class(Common).SchemaVersion(pVersion)
	Quit $$$OK
}

ClassMethod ListGivenMessage(pMessageFilepath As %String, pVersion As %String = "")
{
	Set tMessageText=##class(Common).FileContents(pMessageFilepath)
	Set tSimpleMessage=##class(SimpleMessage).%New(tMessageText)
	Do ##class(Lister).%New(tSimpleMessage,pVersion).ListMessage()
}

Method ListMessage()
{
	// for each segment ..
	Set tSegmentCount=..SimpleMessage.SegmentCount()
	For tSegno=1:1:tSegmentCount {
		Set tSegment=..SimpleMessage.SegmentByIndex(tSegno)
		Set tSegmentFields=..SimpleMessage.SegmentFields(tSegment)
		Do ..ListSegment(tSegno,tSegmentFields)
	}
}

Method ListSegment(pSegno As %Integer, pSegmentFields As %List)
{
	If $ListGet(pSegmentFields)="" {
		Write "Segment #",pSegno," has no name",!
		Quit
	}
	
	Set tSegmentNamePart=$List(pSegmentFields)
	If tSegmentNamePart[":" {
		Set tUseVersion=$Piece(tSegmentNamePart,":")
		Set tSegmentName=$Piece(tSegmentNamePart,":",2,*)
	}
	Else {
		Set tUseVersion=..Version
		Set tSegmentName=tSegmentNamePart		
	}
	
	Write " SEGMENT ",tSegmentName,!
	
	Set tSegmentDefinition=$Get($$$vaSchemaGbl(tUseVersion,"SS",tSegmentName))
	If tSegmentDefinition="" {
		Write "Segment #",tSegno," (",tSegmentName,") has no definition in version ",tUseVersion,!
		Quit
	}
	
	// load field names
	Set tRef=$Name($$$vaSchemaGbl(tUseVersion,"SS",tSegmentName))
	Kill tNames // tNames(FIELDDEFINDEX)=PROPERTYNAME
	Do ..GetNames(tRef,.tNames)
	
	// for each field ..
	Set tFieldno=0
	Set tPtr=0 While $ListNext(tSegmentDefinition,tPtr,tFieldDefinition) {
		
		Set tFieldno=tFieldno+1
		
		Set tFieldName=$Get(tNames(tFieldno),"(unknown)")
		Set tFieldValue=$ListGet(pSegmentFields,tFieldno)
		If tFieldValue'="" {
			Write "  ",tSegmentNamePart,":[FIELD ",tFieldName,"=",tFieldValue,"]"
		}
		Else {
			Write "  ",tSegmentNamePart,":[FIELD ",tFieldName,"]"
		}
		
		Set (tFDataTypePart,tFSymbol,tFRepeatCount,tFMaxLength,tFRequired,tFRepeating,tFMinLength)=""
		Set $ListBuild(tFDataTypePart,tFSymbol,tFRepeatCount,tFMaxLength,tFRequired,tFRepeating,tFMinLength)=tFieldDefinition
		
		Write " datatype=",tFDataTypePart
		If tFSymbol'="" {Write " symbol=",$$symbol(tFSymbol)}
		If tFRepeatCount'="" {Write " repeat=",tFRepeatCount}
		If tFMaxLength'="" {Write " maxlength=",tFMaxLength}
		If tFRequired'="" {Write " required=",tFRequired}
		If tFRepeating'="" {Write " repeating=",tFRepeating}
		If tFMinLength'="" {Write " minlength=",tFMinLength}
		Write !
		
		If tFDataTypePart'="" {
			Set tFieldComponents=..SimpleMessage.FieldComponents(tFieldValue)
			Do ..ListDataType(tFDataTypePart,tFieldComponents,"   ")
		}
	}
	
	Quit
	
symbol(s)
	Quit $Case(s,
		"!":"exactly one",
		"*":"zero or more",
		"+":"one or more",
		"?":"conditional (?)",
		"&":"conditional (&)",
		:"?? - "_s)
}

Method ListDataType(pDataTypePart As %String, pFieldComponents As %List, pIndent As %String) [ Private ]
{
	If pDataTypePart[":" {
		Set tUseVersion=$Piece(pDataTypePart,":")
		Set tDataTypeName=$Piece(pDataTypePart,":",2,*)
	}
	Else {
		Set tUseVersion=..Version
		Set tDataTypeName=pDataTypePart		
	}
	
	Set tRef=$Name($$$vaSchemaGbl(tUseVersion,"DT",tDataTypeName))
	Kill tNames // tNames(FIELDDEFINDEX)=PROPERTYNAME
	Do ..GetNames(tRef,.tNames)
	
	Set tCompDefs=$$$vaSchemaGbl(tUseVersion,"DT",tDataTypeName)
	
	Set tCompno=0	
	Set tPtr=0 While $ListNext(tCompDefs,tPtr,tDef) {
		
		Set tCompno=tCompno+1
		
		Set tCompName=$Get(tNames(tCompno),"(unknown)")
		Set tCompValue=$ListGet(pFieldComponents,tCompno)
		If tCompValue'="" {
			Write pIndent,pDataTypePart,":[COMPONENT ",tCompName,"=",tCompValue,"]"
		}
		Else {
			Write pIndent,pDataTypePart,":[COMPONENT ",tCompName,"]"
		}
		
		Set (tCDataStructure,tCMinLength,tCMaxLength,tCRequired)=""
		Set $ListBuild(tCDataStructure,tCMinLength,tCMaxLength,tCRequired)=tDef
		
		If tCDataStructure'="" {Write " datatype=",tCDataStructure}
		If tCMinLength'="" {Write " minlength=",tCMinLength}
		If tCMaxLength'="" {Write " maxlength=",tCMaxLength}
		If tCRequired'="" {Write " required=",tCRequired}
		Write !
		
		If tCDataStructure'="" {
			Set tComponents=$ListBuild(tCompValue)
			Do ..ListDataType(tCDataStructure,tComponents,pIndent_" ")
		}
		
	}
}

ClassMethod GetNames(pRef As %String, Output pNames) [ Private ]
{
	$$$SHOULDBEUNDEF(pNames)
	
	Set tName="" While 1 {
		Set tName=$Order(@pRef@("names",tName),+1,tIndex) If tName="" {Quit}
		Set pNames(tIndex)=tName
	}
}

}
