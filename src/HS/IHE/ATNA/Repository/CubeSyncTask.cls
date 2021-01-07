Include %ZHSLIB

Class HS.IHE.ATNA.Repository.CubeSyncTask Extends %SYS.Task.Definition
{

Method OnTask() As %Status
{
	Try {
		Set tSC=$$$OK
		Set tCubeName="Audit Events"
		Set tSC=##class(%DeepSee.Utils).%SynchronizeCube(tCubeName)
	} Catch ex {
		Set tSC = ex.AsStatus()	
	}
	Quit tSC
}

ClassMethod Schedule(pNS) As %Status
{
	#dim task as %SYS.Task
	#define TaskName "Audit Cube Synchronization Task"
	// Some temporary cleanup more than one of these were created for each namespace
	Set tTaskID="",tIsNew=0
	Set tRS=##class(%ResultSet.SQL).%Prepare("SELECT count(ID),ID from %SYS.Task where Name=? AND Namespace=?",.tER,"",$$$TaskName,pNS)
	If '$isObject(tER) {
		Do tRS.%Next() 
		Set tTaskID=tRS.%GetData(2)
		if tRS.%GetData(1)>1 {
			While tRS.%Next() {
				Set tTaskID=tRS.%GetData(2)
				Set tSC=$system.Task.%DeleteId(tTaskID)
				Set tTaskID=""
			}
		}
	}
	If tTaskID {
		/// loop for up to 3 minutes
		For idx=1:1:(3*4) { Set tTaskObj=$system.Task.%OpenId(tTaskID) Quit:$isObject(tTaskObj)  Hang 15}
	} Else {
		Set tTaskObj=$system.Task.%New(),tIsNew=1
	}
	Set tTaskObj.Name=$$$TaskName
	Set tTaskObj.Description=$$$TaskName
	Set tTaskObj.TaskClass=..%ClassName(1)  // The name of the Task Class (where OnTask is)
	Set tTaskObj.NameSpace=pNS  // Namespace the task will run in
	Set tTaskObj.RunAsUser=$$$HSTaskUserName
	if tIsNew {
		Set tTaskObj.DailyFrequency=tTaskObj.DailyFrequencyDisplayToLogical("Once")
		Set tTaskObj.DailyStartTime=3600 //1 AM
		Set tTaskObj.Expires=1
	}
	Set tSC=tTaskObj.%Save()
	If tSC Do $System.Task.Resume(tTaskObj.%Id())
	Quit tSC
}

}
