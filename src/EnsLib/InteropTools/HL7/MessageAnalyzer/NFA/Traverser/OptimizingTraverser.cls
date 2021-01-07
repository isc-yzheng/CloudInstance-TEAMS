/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Traverser.OptimizingTraverser Extends BaseTraverser
{

Method Seen(pElement As ElementBase)
{
	Do ..ProcessLinks(pElement,1)
	Do ..ProcessLinks(pElement,0)
}

Method Unseen(pUnseenNames As %List)
{
	// not of interest
}

Method ProcessLinks(pElement As ElementBase, pIsSucc As %Boolean) [ Final, Private ]
{
	#Dim tI,tLink
	#Dim tChanged As %Boolean
	#Dim tNext,tNewList As %List
	#Dim tElement As ElementBase
	
	Set tNext=$Select(pIsSucc:pElement.GetSucc(),1:pElement.GetFail())
	Set tNewList=""
	Set tChanged=0
	Set tPtrI=0 While $ListNext(tNext,tPtrI,tElemI) {	
		Set tElement=..Machine.GetAt(tElemI)
		If tElement.CanRemove(..Machine) {
			Set tNewList=tNewList_tElement.GetSuccTransparent(..Machine)
			Set tChanged=1
		}
		Else {
			Set tNewList=tNewList_$ListBuild(tElemI)
		}
	}
	
	If tChanged {
		Do pElement.ReplaceSuccOrFail(tNewList,pIsSucc)
	}
}

}
