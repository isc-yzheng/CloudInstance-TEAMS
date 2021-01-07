/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Derive.TreeTaskList Extends %RegisteredObject [ Final ]
{

Property TreeTaskList As list Of TreeTask [ Private ];

Method AddTask(pTreeTask As TreeTask)
{
	Do ..TreeTaskList.Insert(pTreeTask)
}

Method NextTask(Output pTreeTask As TreeTask) As %Boolean
{
	If ..TreeTaskList.Count()=0 {
		Quit 0
	}
	
	Set pTreeTask=..TreeTaskList.GetAt(1)
	Do ..TreeTaskList.RemoveAt(1)
	
	Quit 1
}

Method TaskCount() As %Integer [ CodeMode = expression ]
{
..TreeTaskList.Count()
}

/// Sort the tasks by pattern term count and remove the given proportion
Method Trim(pRemoveFraction As %Numeric)
{
	// sanity check
	If ((pRemoveFraction<=0) || (pRemoveFraction>0.9)) {
		$$$FATAL("Trim: RemoveFraction is less than or equal to 0 or greater than 0.9 - " + pRemoveFraction)
	}
	
	// tTasks(TERMCOUNT)=$LB(TREETASKINDEX,...)
	Set tTasks=##class(%ArrayOfDataTypes).%New()
	
	// collect treetasklist indexes, keyed by: treetask tree pattern term count
	Set tTaskCount=..TreeTaskList.Count()
	For tI=1:1:tTaskCount {
		Set tPattern=..TreeTaskList.GetAt(tI).GetTree().Pattern()
		Set tTermCount=##class(Common).TermCount(tPattern)
		Set tOldIndexList=$Select(tTasks.IsDefined(tTermCount):tTasks.GetAt(tTermCount),1:"")
		$$$THROWONERROR(tSC,tTasks.SetAt(tOldIndexList_$ListBuild(tI),tTermCount))  
	}
	
	// scan treetasklist indexes from highest to lowest term count, collecting treetasklist indexes in tToDelete
	Set tDeleteCount=(tTaskCount*pRemoveFraction)\1
	Set tDeletedSoFar=0
	Kill tToDelete
	Set tTermCount="" While 1 {
		Set tTermCount=tTasks.Previous(tTermCount) If tTermCount="" {Quit}
		Set tIndexList=tTasks.GetAt(tTermCount)
		If (tDeletedSoFar+$ListLength(tIndexList))>tDeleteCount {
			Quit
		}
		Set tPtrI=0 While $ListNext(tIndexList,tPtrI,tElemI) {
			Set tToDelete(tElemI)=""
		}
		Set tDeletedSoFar=tDeletedSoFar+$ListLength(tIndexList)
	}
	
	// scan tToDelete in reverse order and delete each given one
	Set tIndex="" While 1 {
		Set tIndex=$Order(tToDelete(tIndex),-1) If tIndex="" {Quit}
		Do ..TreeTaskList.RemoveAt(tIndex)
	}
}

Method Dump()
{
	Set tCount=..TreeTaskList.Count()
	If tCount=0 {
		Write "No Tree Tasks Left",!
	}
	Else {
		Write "Tree Tasks:",!!
		For tI=1:1:tCount {
			Set tTreeTask=..TreeTaskList.GetAt(tI)
			Write " ",tI,": ",tTreeTask.Show(),!
		}
	}
}

}
