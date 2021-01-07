/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Output

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Control.ScanningControl Extends ControlBase [ Final ]
{

Property Graph As AbstractGraph [ InitialExpression = {##class(AbstractGraph).%New()}, Private ];

/// ..FinalDiffRecords(..)=Diff
Property FinalDiffRecords As list Of Diff [ Private ];

Method GetFinalDiffRecords(Output pFinalDiffRecords)
{
	$$$SHOULDBEUNDEF(pFinalDiffRecords)
	
	For tI=1:1:..FinalDiffRecords.Count() {
		Set pFinalDiffRecords(tI)=..FinalDiffRecords.GetAt(tI)
	}
	Set pFinalDiffRecords=..FinalDiffRecords.Count()
}

/// Select a branch to process next and return its index
Method ChooseBranch() As %Integer [ CodeMode = expression ]
{
..BranchCollection.SelectEarliestBranchIndex()
}

Method OnSucc(pBranchIndex As %Integer, pOutcome As OutcomeBase)
{
	$$$LOGOUTPUTIFCONFIGX(..Logger,$ListBuild("","ONSUCC: #"_pBranchIndex_" "_..BranchCollection.GetDiffRecords(pBranchIndex).Show()),"LOGSCANNINGCONTROL",..Config)
	
	Set tPrefix="#"_pBranchIndex_":"
	Set tSourceNodeList=..Graph.NodesStartingWith(tPrefix)
	If $ListLength(tSourceNodeList)>1 {ZTrap}
	
	Set tSourceNode=$Select(tSourceNodeList="":tPrefix,1:$List(tSourceNodeList))
	Set tDestNode="DONE"
	Do ..Graph.AddEdge(tSourceNode,tDestNode,"SUCCESS")
	
	Do ..FinalDiffRecords.Insert(..BranchCollection.GetDiffRecords(pBranchIndex))
}

Method OnFail(pBranchIndex As %Integer, pOutcome As OutcomeBase)
{
	$$$LOGOUTPUTIFCONFIGX(..Logger,$ListBuild("","ONFAIL: Branch #"_pBranchIndex_" outcome="_pOutcome.Show(0)_" resyncing="_pOutcome.ExpandResyncing()),"LOGSCANNINGCONTROL",..Config)
		
	Set tDiffRecords=..BranchCollection.GetDiffRecords(pBranchIndex)
	
	// unless it's a control-failure
	If pOutcome.FailureOutcomeType()'=$$$FOCONT {
	
		// starting a new resync ..
		If pOutcome.GetResyncing()=$$$RSNONE {
		
			// write separator if needed
			Do tDiffRecords.StartRegion()
			
			Set tLSE=pOutcome.BranchContext.LastSucceedingElement
			If tLSE="" {
				$$$LOGOUTPUTIFCONFIG1X(..Logger,"ScanningControl.OnFail: no LastSucceedingElement in outcome","LOGSCANNINGCONTROL",..Config)		
				Quit
			}
		
			Set tLeafElementList=..FindNextLeafElement(tLSE)
			If tLeafElementList="" {
				$$$LOGOUTPUTIFCONFIG1X(..Logger," last succeeding element="_tLSE.Show()_", no following element was found","LOGSCANNINGCONTROL",..Config)			
				Quit  // either a choice was found or the schema ended
			}
			
			If $ListLength(tLeafElementList)>1 {
				$$$LOGOUTPUTIFCONFIG1X(..Logger," choice of elements: "_$ListToString(tLeafElementList),"LOGSCANNINGCONTROL",..Config)
			}
			
			Set tPtrI=0 While $ListNext(tLeafElementList,tPtrI,tElemI) {
						
				Set tElementAfterLast=..GetElement(tElemI)

				$$$LOGOUTPUTIFCONFIG1X(..Logger," last succeeding element="_tLSE.Show()_", ElementAfterLast="_tElementAfterLast.Show(),"LOGSCANNINGCONTROL",..Config)			

				Do ..MakeNextBranches(pBranchIndex,pOutcome,tElementAfterLast,tDiffRecords)
			}
		}
		
		// .. continuing an existing resync ..
		Else {
		
			// if it's a schema-ended-failure ..
			If pOutcome.FailureOutcomeType()=$$$FOSEND {
			
				// add the remaining message types to the diff records
				Set tMSR=pOutcome.BranchContext.MSR.%ConstructClone(0)
				While 'tMSR.Ended() {
					Do tDiffRecords.AddMessageRecord($ListBuild(tMSR.Get(),tMSR.GetOffset(),pOutcome.BranchContext.LastFailingElement.SourceOffset))
					Do tMSR.Next()
				}
				
				Do ..FinalDiffRecords.Insert(tDiffRecords)
			}
			
			Else {
			
				Set tLFE=pOutcome.BranchContext.LastFailingElement
				If tLFE="" {
					$$$LOGOUTPUTIFCONFIG1X(..Logger,"ScanningControl.OnFail: no LastFailingElement in outcome","LOGSCANNINGCONTROL",..Config)		
					Quit
				}
							
				$$$LOGOUTPUTIFCONFIG1X(..Logger," last failing element="_tLFE.Show(),"LOGSCANNINGCONTROL",..Config)
					
				Do ..MakeNextBranches(pBranchIndex,pOutcome,tLFE,tDiffRecords)
			}
		}
	}
}

Method OnSink(pBranchIndex As %Integer)
{
	// just discard this branch
	Do ..BranchCollection.RemoveBranch(pBranchIndex)
}

Method OnExit()
{
	If ..Config.IsFlagSet("GRAPHSCANNINGCONTROL") {
		Set tDigraph=##class(%CPT.Tree.SimpleDigraph).%New("ScanningControl")
		Do ..Graph.AddToDigraph(tDigraph,"red")
		Do ##class(Common).ShowDigraph(tDigraph,"ScanningControl",..Config,..Config.IsFlagSet("LOGSCANNINGCONTROL"))
	}
}

Method OnCycle(pElement As ElementBase, pMSR As MessageSegmentReader, pDiffRecords As Diff) As %Boolean
{
	Quit 1
}

Method MakeNextBranches(pBranchIndex As %Integer, pOutcome As OutcomeBase, pElement As ElementBase, pDiffRecords As Diff) [ Private ]
{
	// get next elements in NFA, if any - to tNextElements(1..*)
	Do pElement.NextElements($This,.tNextElements)
	Set tSkippedElementName=pElement.ElementName
	
	// make clone MSR and progress it to the fail point, and if not ended: a second clone which is advanced by one more
	Set tMSR=pOutcome.BranchContext.MSR.%ConstructClone(0)
	Do ..AdvanceMSR(tMSR,pOutcome.BranchContext.LastSucceedingMessageRemaining)
	If tMSR.Ended() {
		Set tNextMSR=""
		Set tMessageCrossed=""
		Set tMessageCrossedOffset=""
	}
	Else {
		Set tNextMSR=tMSR.%ConstructClone(0)
		Set tMessageCrossed=tNextMSR.Get()
		Set tMessageCrossedOffset=tNextMSR.GetOffset()
		Do tNextMSR.Next()
	}
	
	Set tGraphCurrentMessageOffset=..ExpandedMSROffset(pOutcome.BranchContext.MSR)
	Set tGraphNextMessageOffset=..ExpandedMSROffset(tNextMSR)
	
	$$$ACASSERT($IsObject(pOutcome.BranchContext),"BranchContext field unset (or not an object) in Outcome")
	Set tBranchContextUse=pOutcome.BranchContext
	
	Set tResyncing=..BranchCollection.GetResyncing(pBranchIndex)
	
	$$$LOGOUTPUTIFCONFIG1X(..Logger,"ScanningControl.MakeNextBranches","LOGSCANNINGCONTROL",..Config)
	Set tMakeNextBranchesLog=$ListBuild(
		" failingelement="_tSkippedElementName,
		" branch=#"_pBranchIndex_":"_..BranchCollection.GetBranch(pBranchIndex).Show(),
		" outcome MSR @"_pOutcome.BranchContext.MSR.GetOffset()_" - "_pOutcome.BranchContext.MSR.RemainingText(),
		" current MSR @"_$Select(tMSR="":"EOF",1:tMSR.GetOffset()_" - "_tMSR.RemainingText()),
		" next MSR @"_$Select(tNextMSR="":"EOF",1:tNextMSR.GetOffset()_" - "_tNextMSR.RemainingText()),
		" last succeeding element="_pOutcome.BranchContext.LastSucceedingElement.Show(),
		" last succeeding message remaining="_pOutcome.BranchContext.LastSucceedingMessageRemaining,
		" resyncing="_tResyncing
	)
	$$$LOGOUTPUTIFCONFIGX(..Logger,tMakeNextBranchesLog,"LOGSCANNINGCONTROL",..Config)
	
	// if there are any next elements ..
	If $Get(tNextElements) {
	
		// Make a branch for each next-element/current-message combination
		Set tBranchContextUse1=tBranchContextUse.%ConstructClone(1)
		Set tBranchContextUse1.MSR=tMSR
		Do ..NextSchemaCurrentMessage(.tNextElements,pBranchIndex,pDiffRecords,tSkippedElementName,tBranchContextUse1,tGraphCurrentMessageOffset,tGraphNextMessageOffset,pOutcome.BranchContext.LastSucceedingElement.ElementName)
	}
	
	// if we're NOT resyncing in no-skip-message mode and there is an MSR clone ..
	If tResyncing'=$$$RSNOSM,tNextMSR'="" {
		
		// Make a branch for the current-element/next-message combination
		Set tBranchContextUse2=tBranchContextUse.%ConstructClone(1)
		Set tBranchContextUse2.MSR=tNextMSR
		Do ..CurrentSchemaNextMessage(pElement,pBranchIndex,pDiffRecords,tSkippedElementName,tBranchContextUse2,tGraphCurrentMessageOffset,tGraphNextMessageOffset,tMessageCrossed,tMessageCrossedOffset)
	}
}

/// Make a branch for each next-element/current-message combination
Method NextSchemaCurrentMessage(ByRef pNextElements As ElementBase, pBranchIndex As %Integer, pDiffRecords As Diff, pSkippedElementName As %String, pBranchContext As BranchContext, pGraphCurrentMessageOffset As %Integer, pGraphNextMessageOffset As %Integer, pLastSucceedingelementName As %String) [ Private ]
{
	Set tShouldNoteSkippedSchema=..ShouldNoteSkippedSchema(pLastSucceedingelementName,pSkippedElementName)
	For tI=1:1:pNextElements {
		Set tElementName=pNextElements(tI).ElementName
		Set tDiffRecords=pDiffRecords.%ConstructClone(1)
		If tShouldNoteSkippedSchema {
			Do tDiffRecords.AddSchemaRecord(pSkippedElementName)
			$$$LOGOUTPUTIFCONFIG1X(..Logger," AddSchemaRecord: "_pSkippedElementName,"LOGSCANNINGCONTROL",..Config)
		}
		Set tNewBranchIndex=..AddBranch(tElementName,pBranchContext,tDiffRecords,pBranchContext.MSR.RemainingText(),$$$RSNOSM)
		Do ..AddGraphEdge(pBranchIndex,pSkippedElementName,pGraphCurrentMessageOffset,tNewBranchIndex,tElementName,pGraphNextMessageOffset,"NC")
		$$$LOGOUTPUTIFCONFIG1X(..Logger," AddBranch #"_tNewBranchIndex_" for next/current: "_tElementName_" "_pBranchContext.MSR.Show()_" "_tDiffRecords.Show(),"LOGSCANNINGCONTROL",..Config)					
	}
}

/// Make a branch for the current-element/next-message combination
Method CurrentSchemaNextMessage(pElement As ElementBase, pBranchIndex As %Integer, pDiffRecords As Diff, pSkippedElementName As %String, pBranchContext As BranchContext, pGraphCurrentMessageOffset As %Integer, pGraphNextMessageOffset As %Integer, pMessageCrossed As %String, pMessageCrossedOffset As %Integer) [ Private ]
{
	Set tElementName=pElement.ElementName
	Set tDiffRecords=pDiffRecords.%ConstructClone(1)
	Set tSkippedMessageItem=$ListBuild(pMessageCrossed,pMessageCrossedOffset,pElement.SourceOffset)
	Do tDiffRecords.AddMessageRecord(tSkippedMessageItem)
	$$$LOGOUTPUTIFCONFIG1X(..Logger," AddMessageRecord: "_##class(DiffRegion).ShowMessage(tSkippedMessageItem,1),"LOGSCANNINGCONTROL",..Config)
	Set tNewBranchIndex=..AddBranch(tElementName,pBranchContext,tDiffRecords,pBranchContext.MSR.RemainingText(),$$$RSCANS)
	Do ..AddGraphEdge(pBranchIndex,pSkippedElementName,pGraphCurrentMessageOffset,tNewBranchIndex,tElementName,pGraphNextMessageOffset,"CN_"_pMessageCrossed)
	$$$LOGOUTPUTIFCONFIG1X(..Logger," AddBranch #"_tNewBranchIndex_" for current/next: "_tElementName_" "_pBranchContext.MSR.Show()_" "_tDiffRecords.Show(),"LOGSCANNINGCONTROL",..Config)
}

Method AddGraphEdge(pBranchIndex As %Integer, pSkippedElementName As %String, pOldMessageOffset As %String, pNewBranchIndex As %Integer, pNewElementName As %String, pNewMessageOffset As %String, pEdgeLabel As %String) [ Private ]
{
	Set tSourceLabel="#"_pBranchIndex_":"_pSkippedElementName_"@"_pOldMessageOffset
	Set tDestLabel="#"_pNewBranchIndex_":"_pNewElementName_"@"_pNewMessageOffset
	Do ..Graph.AddEdge(tSourceLabel,tDestLabel,pEdgeLabel)
	
	// update the branch source labels and create a links from the old labels
	Do ..UpdateBranchGraphLabel(tSourceLabel,..BranchCollection.GetBranch(pBranchIndex))
	Do ..UpdateBranchGraphLabel(tDestLabel,..BranchCollection.GetBranch(pNewBranchIndex))
}

Method UpdateBranchGraphLabel(pNewLabel As %String, pBranch As Branch) [ Private ]
{
	Set tOldLabel=pBranch.UpdateGraphLabel(pNewLabel)
	If tOldLabel'="",tOldLabel'=pNewLabel {	
		Do ..Graph.AddEdge(tOldLabel,pNewLabel,"")
	}
}

ClassMethod AdvanceMSR(pMSR As MessageSegmentReader, pRemainingText As %String) [ Private ]
{
	If $Length(pMSR.RemainingText()) < $Length(pRemainingText) {ZTrap}
	
	While $Length(pMSR.RemainingText()) > $Length(pRemainingText) {
		Do pMSR.Next()
	}
}

ClassMethod IsSuitableElement(pElement As ElementBase) As %Boolean [ CodeMode = expression, Private ]
{
'pElement.%IsA("EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Element.TerminalElement")
}

/// Given a failing element
/// <p> Return a list of leaf element keys in the SUCC chains
Method FindNextLeafElement(pElement As ElementBase) As %List [ Private ]
{
	Set tSuccList=pElement.GetSucc()
			
	// policy excludes multiple-success elements which advance the reader
	$$$ACASSERT($ListLength(tSuccList)=1,"LastSucceedingElement has "_$ListLength(tSuccList)_" success links (should be 1)")

	Set tStartElement=..GetElement($List(tSuccList))

	Kill tTodo
	Set tTodo($I(tTodo))=tStartElement
	
	// process todo entries
	Set tResult=""
	While 1 {
	
		Set tKey=$Order(tTodo(""),+1,tElement)
		If tKey="" {Quit}
		
		Kill tTodo(tKey)
		
		// as long as there are no fails (no fails implies a control element)
		While tElement.GetFail()="" {
	
			Set tSuccList=tElement.GetSucc()
			If tSuccList="" {
				Quit  // end of schema
			}
			
			// if it's a choice ..
			If $ListLength(tSuccList)>1 {
				Set tPtrI=0 While $ListNext(tSuccList,tPtrI,tElemI) {
					Set tTodo($I(tTodo))=..GetElement(tElemI)
				}
				Quit
			}
	
			Set tElement=..GetElement($List(tSuccList))
		}

		If tElement.GetFail()'="" {
			Set tResult=tResult_$ListBuild(tElement.ElementName)
		}
	}
	
	Quit tResult
}

Method ShouldNoteSkippedSchema(pLastSucceedingElementName As %String, pElementName As %String) As %Boolean [ Private ]
{
	If ..SameLeafName(pLastSucceedingElementName,pElementName) {
		Quit 0
	}
	
	Set tElement=..GetElement(pElementName)
	
	Set tSuccList=tElement.GetSucc()
			
	// policy excludes multiple-success elements which advance the reader
	$$$ACASSERT($ListLength(tSuccList)<=1,"Element has "_$ListLength(tSuccList)_" success links (should be 0 or 1) - "_tElement.Show())

	If tSuccList="" {
		Quit 1
	}
	
	// - now we know that there is exactly one success link -
	
	Set tSuccElementName=$List(tSuccList)
	
	Set tFailList=tElement.GetFail()

	// policy excludes multiple-failure elements
	$$$ACASSERT($ListLength(tFailList)<=1,"Element has "_$ListLength(tFailList)_" failure links (should be 0 or 1) - "_tElement.Show())
	
	If tFailList="" {
		Quit 1
	}

	// - now we know that there is exactly one failure link -
	
	Set tEName=$List(tFailList)
	
	Set tQueue=$ListBuild(tEName)
	Kill tSeen
	While tQueue'="" {
	
		Set tEName=$List(tQueue),tQueue=$List(tQueue,2,*)
		
		While tEName'=tSuccElementName,'$Data(tSeen(tEName)) {

			Set tSeen(tEName)=""
			
			Set tEElement=..GetElement(tEName)
			
			Set tESuccList=tEElement.GetSucc()
			If tESuccList="" {
				Return 1
			}
			
			// - now we know that there is exactly one success link -
			
			Set tEFailList=tEElement.GetFail()
			If tEFailList'="" {
				Return 1
			}
			
			// - now we know that there are no failure links -
			
			Set tEName=$List(tESuccList)

			If $ListLength(tESuccList)>1 {
				Set tQueue=tQueue_$List(tESuccList,2,*)
			}			
		}
	}
		
	Quit 0
}

ClassMethod ExpandedMSROffset(pMSR As MessageSegmentReader) [ Private ]
{
	If pMSR'="",'pMSR.Ended() {
		Quit pMSR.GetOffset()
	}
	
	Quit "EOF"
}

ClassMethod SameLeafName(pElementName1 As %String, pElementName2 As %String) [ Private ]
{
	If pElementName1["Leaf[",pElementName2["Leaf[" {
		Quit $Piece($Piece(pElementName1,"Leaf[",2),"]")=$Piece($Piece(pElementName2,"Leaf[",2),"]")
	}
	
	Quit 0
}

}
