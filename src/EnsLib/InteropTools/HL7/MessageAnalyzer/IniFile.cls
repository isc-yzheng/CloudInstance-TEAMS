/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

/// Note that the section and key names in the .INI file can be of any letter case but the section spec and section names passed to methods of this class MUST use upper-case in section and key names
Class EnsLib.InteropTools.HL7.MessageAnalyzer.IniFile Extends %RegisteredObject
{

/// SingleSections(SECTIONNAME,KEY)=VALUE
Property SingleSections As %String [ MultiDimensional, Private ];

/// MultiSections(SECTIONNAME,SECTIONINDEX,KEY)=VALUE
Property MultiSections As %String [ MultiDimensional, Private ];

/// Throws an exception if the load fails
Method %OnNew(pSectionSpec As %String, pInputStream As %Stream.Object) As %Status
{
	Do ..Load(pSectionSpec,pInputStream)
	
	Quit $$$OK
}

ClassMethod FromFile(pSectionSpec As %String, pPath As %String) As IniFile [ CodeMode = expression ]
{
##class(IniFile).%New(pSectionSpec,##class(EnsLib.InteropTools.HL7.MessageAnalyzer.Common).ReadFileStream(pPath))
}

ClassMethod FromString(pSectionSpec As %String, pString As %String, pDelimiter As %String = {$Char(10)}) As IniFile
{
	Set tStream=##class(%Stream.GlobalCharacter).%New()
	Set tPtr=0 While $ListNext($ListFromString(pString,pDelimiter),tPtr,tLine) {
		$$$THROWONERROR(tSC,tStream.WriteLine(tLine))
	}
	$$$THROWONERROR(tSC,tStream.Rewind())

	Quit ##class(IniFile).%New(pSectionSpec,tStream)
}

Method GetSingleSection(pSectionName As %String, ByRef pSingleSection)
{
	Merge pSingleSection=..SingleSections(pSectionName)
}

Method GetMultiSectionCount(pSectionName As %String) As %Integer [ CodeMode = expression ]
{
+$Order(..MultiSections(pSectionName,""),-1)
}

Method GetMultiSectionAtIndex(pSectionName As %String, pSectionIndex As %Integer, ByRef pMultiSection)
{
	Merge pMultiSection=..MultiSections(pSectionName,pSectionIndex)
}

Method Dump()
{
	Write "IniFile",!
	
	If $Data(..SingleSections)\10 {
		Set tSection="" While 1 {
			Set tSection=$Order(..SingleSections(tSection)) If tSection="" {Quit}
			Write " ",tSection,!
			Set tKey="" While 1 {
				Set tKey=$Order(..SingleSections(tSection,tKey),+1,tValue) If tKey="" {Quit}
				Write "  ",tKey,"=",tValue,!
			}
		}
	}
	
	If $Data(..MultiSections)\10 {
		Set tSection="" While 1 {
			Set tSection=$Order(..MultiSections(tSection)) If tSection="" {Quit}
			For tI=1:1:..GetMultiSectionCount(tSection) {			
				Write " ",tSection,"#",tI,!
				Set tKey="" While 1 {
					Set tKey=$Order(..MultiSections(tSection,tI,tKey),+1,tValue) If tKey="" {Quit}
					Write "  ",tKey,"=",tValue,!
				}
			}
		}
	}
}

Method Load(pSectionSpec As %String, pInputStream As %Stream.Object) [ Private ]
{
	
	Kill tSectionInfo
	Do ..ParseSectionSpec(pSectionSpec,.tSectionInfo)
	
	Set tSection="NONE",tSectionIndex=0
	While 'pInputStream.AtEnd {
		Set tLine=$$$TRIM(pInputStream.ReadLine(,.tSC)) If $$$ISERR(tSC) {$$$ThrowStatus(tSC)}
		If tLine'="" {
			Do ..LoadLine(tLine,.tSectionInfo,.tSection,.tSectionIndex)
		}
	}
}

Method LoadLine(pLine As %String, ByRef pSectionInfo, ByRef pSection As %String, ByRef pSectionIndex As %Integer) [ Private ]
{
				
	If $Extract(pLine)="[" {
		If $Extract(pLine,*)'="]" {$$$THROW("Section line does not end with ']'")}
		Set pSection=$$$TOUP($Extract(pLine,2,*-1))
		If pSection="" {$$$THROW("Empty section is not allowed")}
		If '$Data(pSectionInfo(pSection),tIsMultiple) {$$$THROW("Section '"_pSection_"' is not in the specification")}
		If tIsMultiple {
			Set pSectionIndex=$Order(..MultiSections(pSection,""),-1)+1
		}
		Else {
			Set pSectionIndex=0
		}
	}
	
	ElseIf pLine["=" {
		Set tKey=$$$TOUP($Piece(pLine,"=")),tValue=$Piece(pLine,"=",2,*)
		If pSectionIndex {
			If $Data(..MultiSections(pSection,pSectionIndex,tKey)) {$$$THROW("Key '"_tKey_"' in section '"_pSection_"#"_pSectionIndex_"' has already been assigned")}
			Set ..MultiSections(pSection,pSectionIndex,tKey)=tValue
		}
		Else {
			If $Data(..SingleSections(pSection,tKey)) {$$$THROW("Key '"_tKey_"' in section '"_pSection_"' has already been assigned")}
			Set ..SingleSections(pSection,tKey)=tValue
		}
	}
	
	Else {
		$$$THROW("Expected section line or assignment line: "_pLine)
	}
}

/// Returns pSectionInfo(SECTIONNAME)=ISMULTIPLE
Method ParseSectionSpec(pSectionSpec As %String, Output pSectionInfo) [ Private ]
{
	$$$SHOULDBEUNDEF(pSectionInfo)
	
	Set tPtr=0 While $ListNext($ListFromString(pSectionSpec),tPtr,tOneSectionSpec) {
		If $Extract(tOneSectionSpec,*)="*" {
			Set tSectionName=$Extract(tOneSectionSpec,1,*-1)
			Set tIsMultiple=1
		}
		Else {
			Set tSectionName=tOneSectionSpec
			Set tIsMultiple=0
		}
		If tSectionName="" {$$$THROW("Empty section name in specification")}
		If $Data(pSectionInfo(tSectionName)) {$$$THROW("Duplicate section name in specification: "_tSectionName)}
		Set pSectionInfo(tSectionName)=tIsMultiple
	}
}

}
