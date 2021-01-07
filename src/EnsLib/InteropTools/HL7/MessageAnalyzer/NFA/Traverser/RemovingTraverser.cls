/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Traverser.RemovingTraverser Extends BaseTraverser
{

Property Trim As %Integer [ MultiDimensional, Private ];

Method %OnNew(pMachine As Machine, ByRef pTrim) As %Status
{
	#Dim tSC As %Status
	
	$$$THROWONERROR(tSC,##super(pMachine))
	
	Merge ..Trim=pTrim
	
	Quit $$$OK
}

Method Seen(pElement As ElementBase)
{
	#Dim tSkipCount,tI,tSuccList
	#Dim tElement As ElementBase
	
	If $Data(..Trim(pElement.ElementName),tSkipCount) {

		Set tElement=pElement
		For tI=1:1:tSkipCount {
			Set tElement=..SuccElement(tElement)
		}
		
		If pElement.%IsA("EnsLib.InteropTools.HL7.MessageAnalyzer.NFA.Element.BacktrackElement") {
			Do pElement.SetContextVar(tElement.GetContextVar())
		}
		
		Set tNewSucc=$ListBuild(..SuccElement(tElement).ElementName)

		Do pElement.SetNext(tNewSucc,"",1)
	}
}

Method Unseen(pUnseenNames As %List)
{
	// not of interest
}

Method SuccElement(pElement As ElementBase) As ElementBase [ Private ]
{
	Set tSuccList=pElement.GetSucc()
	If ($ListLength(tSuccList)'=1) || (pElement.GetFail()'="") {$$$FATAL("RemovingTraverser.SuccElement: succ list should have 1 item and fail list should be empty - "_pElement.Show())}
	Quit ..Machine.GetAt($List(tSuccList))
}

}
