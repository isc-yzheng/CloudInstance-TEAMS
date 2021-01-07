/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer

Include (EnsHL7, EnsLib.InteropTools.HL7.MessageAnalyzer.EnsembleExport, EnsLib.InteropTools.HL7.MessageAnalyzer.Utils)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Ensemble.Export Extends %RegisteredObject
{

Property Version As %String [ Private ];

Property VersionBase As %String [ Private ];

/// Schemas(SCHEMANAME)=DEFINITION
Property Schemas As array Of %String [ Private ];

Property SegmentStructures As SegmentStructures [ Private ];

Method %OnNew(pVersion As %String) As %Status
{
	Set ..Version=pVersion
	Set ..VersionBase=$Get($$$vaSchemaGbl(..Version,"base"))
	Set ..SegmentStructures=##class(SegmentStructures).%New(pVersion)
	Quit $$$OK
}

Method AddSchema(pSchemaName As %String, pDefinition As %String)
{
	$$$ACASSERT(##class(Common).IsStandardSchema(pDefinition),"AddSchema: expected standard schema format")
	
	If ..Schemas.IsDefined(pSchemaName) {$$$FATAL("AddSchema: schema '"_pSchemaName_"' already present")}

	Set tPreparedDefinition=..SegmentStructures.Prepare(pSchemaName,pDefinition)
	
	$$$THROWONERROR(tSC,..Schemas.SetAt(tPreparedDefinition,pSchemaName))
}

Method AnyData() As %Boolean [ CodeMode = expression ]
{
(..Schemas.Next("")'="") || ..SegmentStructures.AnyData()
}

Method GetVersion() As %String [ CodeMode = expression ]
{
..Version
}

Method WriteStream(pOutputStream As %Stream.Object)
{
	Do ..WriteFileHeader(pOutputStream)
	
	Do ..WriteSegmentStructures(pOutputStream)
	
	Do ..WriteSchemas(pOutputStream)
	
	Do ..WriteFileTrailer(pOutputStream)
}

Method WriteStreamWithExistingDefinitions(pOutputStream As %Stream.Object, pDefinitionsStream As %Stream.Object)
{
	While 'pDefinitionsStream.AtEnd {
		Set tLine=pDefinitionsStream.ReadLine(,.tSC) If $$$ISERR(tSC) {$$$ThrowStatus(tSC)}
		If tLine["</Category" {
			Set tTrailerLine=tLine
			Quit
		}
		$$$THROWONERROR(tSC,pOutputStream.WriteLine(tLine))
	}
	
	Do ..WriteSegmentStructures(pOutputStream)
	
	Do ..WriteSchemas(pOutputStream)
	
	$$$THROWONERROR(tSC,pOutputStream.WriteLine(tTrailerLine))
	
	While 'pDefinitionsStream.AtEnd {
		Set tLine=pDefinitionsStream.ReadLine(,.tSC) If $$$ISERR(tSC) {$$$ThrowStatus(tSC)}
		$$$THROWONERROR(tSC,pOutputStream.WriteLine(tLine))
	}
}

Method WriteFileHeader(pOutputStream As %Stream.Object) [ Private ]
{
	$$$THROWONERROR(tSC,pOutputStream.WriteLine("<?xml version=""1.0"" encoding=""UTF-8""?>"))
	$$$THROWONERROR(tSC,pOutputStream.WriteLine("<Export generator="""_$$$EXPORTGENERATOR_""" version="""_$$$EXPORTVERSION_""" zv="""_$ZVersion_""" ts="""_$zdt($h,3)_""">"))
	$$$THROWONERROR(tSC,pOutputStream.WriteLine("<Document name="""_..Version_".HL7"">"))
	Set tBasePart=$Select(..VersionBase="":"",1:" base="""_..VersionBase_"""")
	$$$THROWONERROR(tSC,pOutputStream.WriteLine("<Category name="""_..Version_""""_tBasePart_">"))
}

Method WriteSegmentStructures(pOutputStream As %Stream.Object) [ Private ]
{
	Set tName="" While 1 {
		Set tName=..SegmentStructures.Next(tName) If tName="" {Quit}
		$$$THROWONERROR(tSC,pOutputStream.WriteLine("<SegmentStructure name='"_tName_"' description='"_$$$XMLENC(..SegmentStructures.GetAt(tName))_"'/>"))
	}
}

Method WriteSchemas(pOutputStream As %Stream.Object) [ Private ]
{
	Set tSchemaName="" While 1 {
		Set tSchemaName=..Schemas.Next(tSchemaName) If tSchemaName="" {Quit}
		$$$THROWONERROR(tSC,pOutputStream.WriteLine("<MessageStructure name='"_tSchemaName_"' definition='"_$$$XMLENC(..Schemas.GetAt(tSchemaName))_"'/>"))
	}
}

Method WriteFileTrailer(pOutputStream As %Stream.Object) [ Private ]
{
	$$$THROWONERROR(tSC,pOutputStream.WriteLine("</Category>"))
	$$$THROWONERROR(tSC,pOutputStream.WriteLine("</Document></Export>"))
}

}
