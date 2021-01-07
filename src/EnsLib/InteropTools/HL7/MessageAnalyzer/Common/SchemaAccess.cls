/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer.Ensemble

Include EnsHL7

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Common.SchemaAccess
{

/// databases which should not be written to
Parameter SYSTEMDATABASES = {$ListBuild("ENSLIB","HSLIB")};

/// Utility function: can/should I write to this HL7 schema?
ClassMethod CanWriteToSchema(pGlobalInfo As GlobalInfo, pSchemaVersion As %String) As %Boolean [ CodeMode = expression ]
{
..CanWriteToGlobal(pGlobalInfo,$Name($$$vaSchemaGbl(pSchemaVersion))) && ..CanWriteToGlobal(pGlobalInfo,$Name($$$vaSchemaDescGbl(pSchemaVersion)))
}

/// Policy function: can/should I write to this global reference?
ClassMethod CanWriteToGlobal(pGlobalInfo As GlobalInfo, pRef As %String) As %Boolean [ Private ]
{
	Set tDB=pGlobalInfo.DatabaseFor(pRef)
	If tDB="" {Quit 0} // a mapping we can't handle
	If tDB="." {Quit 1} // unmapped
	Quit $ListFind(..#SYSTEMDATABASES,tDB)=0
}

}
