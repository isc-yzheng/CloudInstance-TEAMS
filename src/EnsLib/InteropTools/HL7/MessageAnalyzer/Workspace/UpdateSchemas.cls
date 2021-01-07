/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.HL7, EnsLib.InteropTools.HL7.MessageAnalyzer.Ensemble)

Include (EnsHL7, EnsLib.InteropTools.HL7.MessageAnalyzer.Utils)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace.UpdateSchemas
{

ClassMethod UpdateSchemas(pWorkspaceFolderName As %String, pVersion As %String, pSchemaName As %String, pDerivedSchemaSource As %String)
{
	Set tSegmentStructures=##class(SegmentStructures).%New(pVersion)
	Set tPreparedSchemaSource=tSegmentStructures.Prepare(pSchemaName,pDerivedSchemaSource)
	
	// write segment structures
	Set tName="" While 1 {
		Set tName=tSegmentStructures.Next(tName) If tName="" {Quit}
		Set $$$vaSchemaGbl(pVersion,"SS",tName)=""
	}	
	
	// write schema
	Set $$$vaSchemaGbl(pVersion,"MS",pSchemaName)=tPreparedSchemaSource
	
	// update indices
	Do ##class(Schema).BuildCategoryMaps(pVersion)
}

}
