/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Shell.ArgumentParser Extends %RegisteredObject
{

Property ClientName As %String [ Private ];

/// Just a simple string - e.g. "AXY" to allow -A, -X and -Y flags (flags are case-insensitive)
Property AllowedFlags As %String [ Private ];

Method %OnNew(pClientName As %String, pAllowedFlags As %String) As %Status
{
	Set ..ClientName=pClientName
	Set ..AllowedFlags=$$$TOUP(pAllowedFlags)
	
	Quit $$$OK
}

/// Returns either an error message or "" 
Method ParseArguments(pArgs As %String, Output pFreeArgs As %String, Output pFlags) As %String
{
	$$$SHOULDBEUNDEF(pFreeArgs)
	$$$SHOULDBEUNDEF(pFlags)
	
	$$$ACASSERT(pArgs'[$Char(9),..ClientName_": argument string should have had tabs removed")
	
	Set pSource=""
	Set pDest=""

	Set tLenArgs=$Length(pArgs)
	
	Set tP=1
	While tP<=tLenArgs {

		// skip spaces and tabs
		While tP<=tLenArgs,$Extract(pArgs,tP)=" " {
			Set tP=tP+1
		}
		If tP>tLenArgs {Quit}

		// fetch option flag if present
		If $Extract(pArgs,tP)="-" {
			Set tFlagCode=$$$TOUP($Extract(pArgs,tP+1))
			Set tP=tP+2
			If (tFlagCode="") || (..AllowedFlags'[tFlagCode) {
				Return ..ClientName_": unrecognized flag argument - '"_tFlagCode_"'"
			}
			If $Data(pFlags(tFlagCode)) {
				Return ..ClientName_": duplicate flag argument - '"_tFlagCode_"'"
			}
		}
		Else {
			Set tFlagCode=""
		}
		
		// skip spaces and tabs 
		While tP<=tLenArgs,$Extract(pArgs,tP)=" " {
			Set tP=tP+1
		}
		
		If tP>tLenArgs {
			If tFlagCode'="" {
				Return ..ClientName_": missing flag setting - '"_tThisArg_"'"
			}
			Quit
		}
		
		// cross and note this argument
		If $Extract(pArgs,tP)="""" {
			Set tP=tP+1
			Set tArgStartP=tP
			Set tEndQuoteP=##class(Common).IndexOf(pArgs,"""",tP)
			If 'tEndQuoteP {
				Return ..ClientName_": missing closing quote in argument"
			}
			Set tP=tEndQuoteP+1
			Set tThisArg=$Extract(pArgs,tArgStartP,tEndQuoteP-1)
		}
		Else {
			Set tArgStartP=tP
			Set tSpaceP=##class(Common).IndexOf(pArgs," ",tP)
			If tSpaceP {
				Set tThisArg=$Extract(pArgs,tArgStartP,tSpaceP-1)
				Set tP=tSpaceP+1
			}
			Else {
				Set tThisArg=$Extract(pArgs,tArgStartP,*)
				Set tP=tLenArgs+1
			}			
			If tThisArg="" {
				Quit
			}
		}
				
		// option argument
		If tFlagCode'="" {
			If tThisArg="" {
				Return ..ClientName_": missing flag setting - '"_tThisArg_"'"
			}
			Set pFlags(tFlagCode)=tThisArg
		}
		
		// free argument
		Else {
			Set pFreeArgs($I(pFreeArgs))=tThisArg
		}
	}
	
	// OK
	Quit ""
}

}
