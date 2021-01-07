/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Outcome)

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Analysis.MessageReport Extends %RegisteredObject [ Final ]
{

Property OptionalPath As %String [ Private ];

Property MessageTypes As %List [ Private ];

Property MessageCount As %Integer [ Private ];

Property PathIfUnique As %String [ Private ];

/// MatchingSchemas=$LB($LB(SCHEMANAME,SCHEMASPEC))
Property MatchingSchemas As %List [ Private ];

/// MismatchingBestSchema=list of $LB(SCHEMANAME,SCHEMASPEC)
Property MismatchingBestSchema As list Of %List [ Private ];

Property MismatchingBestSchemaFailureOutcome As list Of OutcomeBase [ Private ];

Method %OnNew(pOptionalPath As %String = "", pMessageTypes As %List, pMessageCount As %Integer, pPathIfUnique As %String) As %Status
{
	Set ..OptionalPath=pOptionalPath
	Set ..MessageTypes=pMessageTypes
	Set ..MessageCount=pMessageCount
	Set ..PathIfUnique=pPathIfUnique
	
	Quit $$$OK
}

/// Set the matching schemas for this report
/// <p> pMatchingSchemas=$LB($LB(SCHEMANAME,SCHEMASPEC))
Method MatchesSchemas(pMatchingSchemas As %List)
{
	$$$ACASSERT((pMatchingSchemas'='"") && (..MatchingSchemas="") && (..MismatchingBestSchema.Count()=0),"MessageReport parameters or schema properties are inconsistent")
	Set ..MatchingSchemas=pMatchingSchemas
}

/// Add a mismatching best schema for this report
/// <p> pMismatchingSchemas=$LB(SCHEMANAME,SCHEMASPEC)
Method MismatchesBestSchema(pMismatchingBestSchema As %List, pOutcome As OutcomeBase)
{
	$$$ACASSERT((pMismatchingBestSchema'='"") && (..MatchingSchemas=""),"MessageReport parameters or schema properties are inconsistent")
	Do ..MismatchingBestSchema.Insert(pMismatchingBestSchema)
	Do ..MismatchingBestSchemaFailureOutcome.Insert(pOutcome)
}

Method AnyResults() As %Boolean [ CodeMode = expression ]
{
(..MatchingSchemas'="")||(..MismatchingBestSchema.Count())
}

/// Only valid for calling if AnyResults returns 1: this method returns 1 if any schema matched 
Method Matched() As %Boolean [ CodeMode = expression ]
{
..Check(..AnyResults(),"Matched called for message report with no results") && (..MatchingSchemas'="")
}

/// Return $LB($LB(SCHEMANAME,SCHEMASPEC))
Method GetMatchingSchemas() As %List [ CodeMode = expression ]
{
..MatchingSchemas
}

Method BestSchemaCount() As %Integer [ CodeMode = expression ]
{
..MismatchingBestSchema.Count()
}

Method BestSchema(pIndex As %Integer) As %List [ CodeMode = expression ]
{
..MismatchingBestSchema.GetAt(pIndex)
}

Method BestSchemaFailureOutcome(pIndex As %Integer) As OutcomeBase [ CodeMode = expression ]
{
..MismatchingBestSchemaFailureOutcome.GetAt(pIndex)
}

Method GetMessageCount() As %Integer [ CodeMode = expression ]
{
..MessageCount
}

Method GetPathIfUnique() As %String [ CodeMode = expression ]
{
..PathIfUnique
}

/// Show everything
Method Show() As %String [ CodeMode = expression ]
{
..ShowSome(1,1,1)
}

Method ShowSome(pShowFullPath As %Boolean = 0, pShowMessageText As %Boolean = 0, pShowSchemas As %Boolean = 0) As %String
{
	Set tOut=""
	
	If ..OptionalPath'="" {
		Set tOut=tOut_"["_$Select(pShowFullPath:..OptionalPath,1:##class(%File).GetFilename(..OptionalPath))_"] "
	}
	
	If pShowMessageText {
		Set tOut=tOut_"(x"_..MessageCount_") "_$ListToString(..MessageTypes)
	}
	
	If pShowSchemas {
		Set tOut=tOut_" - "_..ShowSchemas()
	}
	
	Quit tOut
}

Method ShowMatchingSchemas() As %String
{
	If ..AnyResults(), ..Matched() {
		Set tOut=""
		Set tPtrI=0 While $ListNext(..MatchingSchemas,tPtrI,tElemI) {
			Set tOut=tOut_$ListBuild($List(tElemI))
		}
		Quit $ListToString(tOut)
	}
	Else {
			Quit ""
	}
}

Method ShowSchemas() As %String
{
	If ..AnyResults() {
		If ..Matched() {
			Quit "matching schemas: "_..ShowMatchingSchemas()
		}
		ElseIf ..MismatchingBestSchema.Count() {
			Quit "mismatching best schemas: "_$ListToString(..MismatchingBestSchemaNames())
		}
	}
	Else {
		Quit "(no schema information)"
	}
}

Method MismatchingBestSchemaNames() As %List [ Private ]
{
	Set tOut=""
	For tI=1:1:..MismatchingBestSchema.Count() {
		Set tOut=tOut_$ListBuild($List(..MismatchingBestSchema.GetAt(tI)))
	}
	
	Quit tOut
}

ClassMethod Check(Result As %Boolean, ErrorMessage As %String) [ Private ]
{
	If 'Result {
		Throw ##class(%Exception.General).%New(Message)
	}
	Quit 1
}

}
