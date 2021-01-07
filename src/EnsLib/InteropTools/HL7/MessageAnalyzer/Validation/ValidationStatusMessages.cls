/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.Validation)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Validation.ValidationStatusMessages Extends %RegisteredObject
{

/// Given a validation status message string, return either $LB(CLASS,$LB(ARGNAME,..),$LB(ARG,..)) or "" if no match is found
ClassMethod DispatchStatusMessage(pValidationStatusMessage As %String, pListAll As %Boolean = 0, pDebuggingMode As %Boolean = 0, Output pCleanedStatusMessage) As %List
{
	// caller should have set up the PPG
	If ($Data($$$VSMROOT)\10)=0 {ZTrap}
	
	// clean the status message and trim it (to avoid <SUBSCRIPT> errors, for a start)
	Set pCleanedStatusMessage=$Extract(..CleanStatusMessage(pValidationStatusMessage),1,200)
	
	// find the key corresponding to this status message - i.e. the longest matching prefix
	Set tKey=$Order($$$VSMROOT(pCleanedStatusMessage),+1,tCount)
	If tKey="" {Quit ""} // our status message collated after the last prefix in the PPG
	
	$$$ACASSERT($Extract(tKey,*)="~","Key does not end with '~'")
	
	// get the prefix from the key
	Set tPrefix=$Extract(tKey,1,*-1)
	If tPrefix'=$Extract(pCleanedStatusMessage,1,$Length(tPrefix)) {Quit ""} // it's not actually a prefix of this status message
	
	// get the suffix - the suffix is what follows the prefix in the status message
	Set tSuffix=$Extract(pCleanedStatusMessage,$Length(tPrefix)+1,*)
	
	If pDebuggingMode {
		Write "Message prefix=<<",tPrefix,">>, suffix=<<",tSuffix,">>",!
	}
	
	// for each regex ..
	For tI=1:1:tCount {
	
		Set $ListBuild(tRegex,tClass,tArgNames)=$$$VSMROOT(tKey,tI)

		If pDebuggingMode {
			Write " Regex=<<",tRegex,">>, class=<<",tClass,">>, argnames=<<",$ListToString(tArgNames),">>",!
		}

		Set tMatcher=##class(%Regex.Matcher).%New(tRegex)
		
		// if the regex matches the suffix ..
		If tMatcher.Match(tSuffix) {
		
			// collect the group values
			Set tValues=""
			For tJ=1:1:tMatcher.GroupCount {
				Set tValues=tValues_$ListBuild(tMatcher.Group(tJ))
			}
			
			If pDebuggingMode {
				Write "  Match: group values=<<",$ListToString(tValues),">>",!
			}
		
			// we've found a match so return the dispatch info
			Return $ListBuild(tClass,tArgNames,tValues)
		}
		
		Else {
			If pDebuggingMode {
				Write "  No match",!
			}
		}
	}
	
	If pListAll || pDebuggingMode {
		Write "Warning: error message string matched a prefix but the rest of the message did not match any of the patterns:",!
		Write "- original error message: ",pValidationStatusMessage,! 
		Write "- cleaned error message:  ",pCleanedStatusMessage,! 
		Write "- prefix: ",tPrefix,!
	} 
	
	Quit ""
}

ClassMethod CleanStatusMessage(pStatusMessage As %String) As %String [ Private ]
{
	Set tMessage=pStatusMessage
	
	// remove program location information from the end
	If tMessage["[",$Extract(tMessage,*)="]" {
		Set tMessage=$Piece(tMessage,"[",1,*-1)
	}
	
	// remove everything up to "<...>"
	If tMessage["<",$Piece(tMessage,"<",2,*)[">" {
		Set tMessage="<"_$Piece(tMessage,"<",2,*)
	}
	
	// remove <...>
	If $Extract(tMessage)="<" {
		Set tMessage=$Piece(tMessage,">",2,*)
	}
	
	Quit $$$TRIM(tMessage)
}

/// Set up PPG with validation status message patterns:
/// <p> ^||Ens.MAVSM(PREFIX_"~")=COUNT
/// <p> ^||Ens.MAVSM(PREFIX_"~",1..COUNT)=$LB(REGEX,CLASS,$LB(GROUPNAME,..))
ClassMethod SetupPatterns()
{
	Set tThisPackage=$Piece($ClassName(),".",1,*-1)
	Set tSubpackageList=$ListBuild("Segment")
	
	Kill $$$VSMROOT
	
	// for each subpackage in the list ..
	Set tPtr=0 While $ListNext(tSubpackageList,tPtr,tSubpackage) {

		// full name of the subpackage
		Set tPackage=tThisPackage_"."_tSubpackage
		
		// name of the registrar class
		Set tRegistrarClass=tPackage_".Registrar"
		
		// invoke the registrar
		Do $ClassMethod(tRegistrarClass,"RegisterThisPackage")
	}
}

}
