/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer.Validation, EnsLib.InteropTools.HL7.MessageAnalyzer.Validation.Segment, EnsLib.InteropTools.HL7.MessageAnalyzer.Message, EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace.Menu, EnsLib.InteropTools.HL7.MessageAnalyzer.Common, EnsLib.InteropTools.HL7.MessageAnalyzer.Ensemble)

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.Validation, EnsLib.InteropTools.HL7.MessageAnalyzer.Workflow)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Workspace.Workflow2Validation Extends %RegisteredObject
{

Property WorkspaceFolderName As %String [ Private ];

Property Workspace As Workspace [ Private ];

Property SchemaName As %String [ Private ];

Property MenuRunner As MenuRunner [ Private ];

Method %OnNew(pWorkspaceFolderName As %String, pWorkspace As Workspace, pSchemaName As %String, pMenuRunner As MenuRunner) As %Status
{
	If (pWorkspaceFolderName="") || (pWorkspace="") || (pSchemaName="") {ZTrap}
	
	Set ..WorkspaceFolderName=pWorkspaceFolderName
	Set ..Workspace=pWorkspace
	Set ..SchemaName=pSchemaName
	Set ..MenuRunner=pMenuRunner
	
	Quit $$$OK
}

Method RunValidation()
{
	// run the top menu to set up validation flags
	Set tValSpec=..RunValidationTopMenu()
	If tValSpec="^" {
		Quit  // they selected "^"
	}
	If tValSpec="" {
		Write "No options were selected.",!
		Do ..MenuRunner.Quitting() // if this is NOT done and the parent menu has only a single item: this method will be invoked again with the same operation ...
		Quit  // no validation options were selected
	}
	
	Write !,"Validating messages ..",!
	
	// open a message reader over the workspace
	Set tMessageSourceReader=##class(MessageSourceReader).%New(..WorkspaceFolderName,10)
	
	// set options
	Set tListAll=$Get($$$WFOPTIONSITEMREF("VALLISTALL"),0)
	Set tDebuggingMode=$Get($$$WFOPTIONSITEMREF("VALDEBUG"),0)
	
	// validate the messages
	Kill tInstances
	Kill tStats
	Set tMessageCount=..ValidateMessages(..Workspace.GetWorkspaceVersion()_":"_..SchemaName,tMessageSourceReader,tValSpec,tListAll,tDebuggingMode,.tInstances,.tStats)
	
	Do ..ShowAndUpdateVStats(tMessageCount,tValSpec,.tStats)
	
	// if there are no matches ..
	If '$Data(tInstances) {
		Write "No auto-fixable validation errors found",!
	}
	
	Else {

		Set tSchemaVersion=..Workspace.GetWorkspaceVersion()
		Set tHL7Configuration=##class(HL7Configuration).%New()
		Set tCategorizedFixes=##class(CategorizedFixes).%New(.tInstances)
		Do ##class(Workflow2ValidationByCategory).%New(tSchemaVersion,tHL7Configuration,tCategorizedFixes,tMessageCount,..MenuRunner).ProcessByCategory()
		
		// show items queued to fix
		Kill tToFix
		Do tCategorizedFixes.GetStatusInstances("tofix",.tToFix)
		
		If $Get(tToFix) {
		
			Write !!
			Write "Items queued for fixes to HL7 configuration:",!
			Set tAnyLibraryItems=0
			For tI=1:1:tToFix {
				Set tFixVersion=$Piece($List(tToFix(tI).GetFixTarget(),2),":")
				Set tMarker=$Select(tFixVersion=tSchemaVersion:" ",1:"*")
				Write " ",tMarker,tToFix(tI).FixPrompt(tHL7Configuration),!
				If tFixVersion'=tSchemaVersion {
					Set tAnyLibraryItems=1
				}
			}
			
			If tAnyLibraryItems {
				Write !,"Fixes marked with a '*' apply to library items, which will be copied to the custom schema: ",tSchemaVersion,!
			}
			
			Write !
			Set tIn=##class(Input).InputYN("Do you want to apply these fixes?")
			If tIn="Y" {
				Set tConfigChangeLog=##class(ConfigChangeLog).%New()
				$$$ACASSERT(..IsCustomVersion(tSchemaVersion),"RunValidation: Schema is a library version")
				Kill tLog
				Kill tErrorList
				Write !,"Applying fixes ..",!
				Do ..ApplyFixes(tHL7Configuration,tConfigChangeLog,tSchemaVersion,.tToFix,.tLog,.tErrorList)
				
				Write !!!
				
				// show the log
				If $Get(tLog) {
					Write "Updates to HL7 configuration:",!
					Write !,"Lines beginning with 'Path:' below summarize updates to document structures, segment structures, data structures and code tables",!
					Write "In such a line ",##class(Path).Documentation(),!!
					For tI=1:1:tLog {
						Write " ",tLog(tI),!
					}
				}
				Else {
					Write "No changes made to HL7 configuration",!
				}
				
				// show the errors
				If $Get(tErrorList) {
					Write !,"There ",$$was(tErrorList)," ",$$error(tErrorList),":",!
					For tI=1:1:tErrorList {
						Write " ",tErrorList(tI),!
					}
				}				
			}
			Else {
				Write "Fixes not applied",!
			}
		}
		Else {
			Write "No items queued for fixes to HL7 configuration",!
		}
	}
	
	Quit
	
was(n)
	Quit $Case(n,1:"was",:"were")

error(n)
	Quit $Case(n,1:"error",:"errors")
}

/// Returns validation flags if confirmed, otherwise "" (no options selected) or "^" (^ entered)
Method RunValidationTopMenu() As %String [ Private ]
{
	Kill tSelectable For tI="SF","SC","ST" {Set tSelectable(tI)=""}

	Set tMenu=##class(ValidationTopMenu).%New()	
	While ..MenuRunner.RunMenu(tMenu,.tSelectedOption) {	
		
		If $Data(tSelectable(tSelectedOption)) {
			Do tMenu.ToggleSelected(tSelectedOption)
		}

		ElseIf tSelectedOption="GO" {
			Set tSelectedOptions=tMenu.SelectedOptions()
			If tSelectedOptions="" {
				Return ""
			}
			Return ..ValSpecFor(tSelectedOptions)_"-x"
		}

		Else {
			ZTrap
		}
	}
	
	Quit "^"
}

/// Returns message count
ClassMethod ValidateMessages(pVersionedSchema As %String, pMessageSourceReader As MessageSourceReader, pValSpec As %String = "1", pListAll As %Boolean = 0, pDebuggingMode As %Boolean = 0, Output pInstances, Output pStats) As %Integer [ Private ]
{
	
	$$$SHOULDBEUNDEF(pInstances)
	$$$SHOULDBEUNDEF(pStats)
	
	// set up a validation object
	Set tValidate=##class(Validate).%New(pVersionedSchema,pValSpec,pListAll,pDebuggingMode)
	Do tValidate.SetValSpecInStats(.pStats)
	
	// for each message ..
	Set tMessageIndex=0
	While pMessageSourceReader.NextMessage(.tMessageText,.tMessageFilePath) {
	
		If ##class(FolderType).IsMessageFileName(tMessageFilePath) {
		
			Set tMessageIndex=tMessageIndex+1
			
			If pListAll {
				Write !,tMessageFilePath,!
			}		
			
			Do tValidate.ValidateMessage(tMessageText,tMessageIndex,.pInstances,.pStats)
		}
	}
	
	Quit tMessageIndex
}

ClassMethod ValSpecFor(pSelectedMenuTags As %List) As %String [ Private ]
{
	Set tRet=""
	For tI=1:1:$ListLength(pSelectedMenuTags) { // this $List is not expected to be long enough for $ListNext to be needed
		Set tRet=tRet_$Case($List(pSelectedMenuTags,tI),"SF":"argl","SC":"pojiw","ST":"but")
	}
	
	Quit tRet
}

Method ApplyFixes(pHL7Configuration As HL7Configuration, pConfigChangeLog As ConfigChangeLog, pCustomVersion As %String, ByRef pToFix, Output pLog, Output pErrorList) [ Private ]
{
	$$$SHOULDBEUNDEF(pLog)
	$$$SHOULDBEUNDEF(pErrorList)
	
	Set tFixValidationProblem=##class(FixValidationProblem).%New(pHL7Configuration,pConfigChangeLog,pCustomVersion,..SchemaName)
	
	// for each fix ..
	For tI=1:1:pToFix {
	
		// fix it
		Do tFixValidationProblem.Fix(pToFix(tI),.pLog,.pErrorList)
	}
}

ClassMethod ShowAndUpdateVStats(pMessageCount As %Integer, pValSpec As %String, ByRef pStats) [ Private ]
{
	Kill tPrevStats
	Merge tPrevStats=$$$WFPREVVSTATSREF
	
	Do ..ShowVStats(pMessageCount,pValSpec,.pStats,.tPrevStats)
	
	Kill $$$WFPREVVSTATSREF
	Merge $$$WFPREVVSTATSREF=pStats
}

ClassMethod ShowVStats(pMessageCount As %Integer, pValSpec As %String, ByRef pStats, ByRef pPrevStats) [ Private ]
{
	Set $ListBuild(tOKCount,tOKPercent,tFailCount,tFailPercent,tInvalidCount)=..GetVStats(.pStats)
		
	Set (tPrevCountMess,tPrevCountMess,tPrevPercentMess,tInvalidCountMess)="" // initial default
	If $Data(pPrevStats)\10 {
		If $Get(pPrevStats($$$VSTATSVALFLAGS))'=pValSpec {
			Write !,"(previous validation run enabled different validation flags so previous figures are not given)",!
		}
		Else { 
			Set tRet=..GetVStats(.pPrevStats)
			If tRet'="" {
				Set $ListBuild(tPrevOKCount,tPrevOKPercent,tPrevFailCount,tPrevFailPercent,tInvalidCount)=..GetVStats(.pPrevStats)
				Set tPrevCountMess=" (was "_tPrevOKCount_"/"_tPrevFailCount_")"
				Set tPrevPercentMess=" (was "_tPrevOKPercent_"/"_tPrevFailPercent_")"
			}
		}
	}
	
	Write !,pMessageCount," messages: ",tOKCount,"-ok/",tFailCount,"-failed",tPrevCountMess," - ",tOKPercent,"/",tFailPercent,tPrevPercentMess,!
	
	If tInvalidCount {
		Write tInvalidCount," invalid messages were found",!
	}
}

/// Returns "" if there were no stats
/// <p> Otherwise returns $LB(OKCOUNT,OKPERCENT,FAILCOUNT,FAILPERCENT,INVALIDCOUNT)
ClassMethod GetVStats(ByRef pStats) [ Private ]
{
	Set tTotalValidCount=$Get(pStats($$$VSTATSTOTALVALID))
	
	If 'tTotalValidCount {
		Quit ""
	}

	Set tFailCount=$Get(pStats($$$VSTATSVALFAILCANAUTOFIX))

	Set tOKCount=tTotalValidCount-tFailCount
	Set tOKPercent=$$percent(tOKCount,tTotalValidCount)
	Set tFailPercent=$$percent(tFailCount,tTotalValidCount)
	
	Set tInvalidCount=$Get(pStats($$$VSTATSINVALID))
	
	Quit $ListBuild(tOKCount,tOKPercent,tFailCount,tFailPercent,tInvalidCount)
	
percent(num,den)
	Quit $FNumber((num/den)*100,,0)_"%"
}

ClassMethod IsCustomVersion(pSchemaVersion As %String) [ CodeMode = expression, Private ]
{
##class(SchemaAccess).CanWriteToSchema(##class(GlobalInfo).%New(),pSchemaVersion)
}

}
