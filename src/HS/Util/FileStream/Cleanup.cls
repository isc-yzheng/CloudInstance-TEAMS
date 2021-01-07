Include (Ensemble, HS.HC)

Class HS.Util.FileStream.Cleanup Extends %SYS.Task.Definition [ System = 4 ]
{

Parameter TaskName = "File Stream Cleanup";

Parameter DailyFrequency = "Several";

Parameter DailyFrequencyTime = "Minutes";

Parameter DailyIncrement = 5;

/// Remove stream files which are older than the PurgeMinutes
Property PurgeMinutes As %Integer [ InitialExpression = 10 ];

Property ReportToEventLog As %Boolean [ InitialExpression = 1 ];

Method OnTask() As %Status
{
	Try {
		Set tSC=$$$OK
		Do ..Cleanup()
	} Catch ex {
		Set tSC = ex.AsStatus()	
	}
	Quit tSC
}

/// Process cleanup for namespace
Method Cleanup()
{
	#Define Seconds(%h) (+%h * 86400) + $p(%h,",",2)
	Set tPath = ##class(HS.Util.StreamUtils).GetTempDirectory()
	Set tNow = $$$Seconds($h)
	Set tRS = ##class(%ResultSet).%New("%File:FileSet")
	Do tRS.%Execute(tPath,"*")
	While tRS.%Next() {
		Continue:tRS.Type="D"
		Set tTimeOfFile=$$$Seconds($ZDTH(tRS.DateModified,8))
		If (tNow - tTimeOfFile) > (..PurgeMinutes*60) {
			If ..ReportToEventLog {
				$$$LOGERROR($$$FormatText("File %1 remains, last updated at %2",tRS.Name,tRS.DateModified))
			}
			If '##class(%File).Delete(tRS.Name) {
				$$$LOGERROR($$$FormatText("Failed to delete %1",tRS.Name))
			}
		}
	}
}

/// Standardized Schedule method for tasks using Parameter TaskName
ClassMethod Schedule(pNS) As %Status
{
	#dim tTaskObj as %SYS.Task
	// Some temporary cleanup more than one of these were created for each namespace
	Set tTaskID="",tIsNew=0
	Set tRS=##class(%ResultSet.SQL).%Prepare("SELECT count(ID),ID from %SYS.Task where Name=? AND Namespace=?",.tER,"",..#TaskName,pNS)
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
		For idx=1:1:(3*4) { Set tTaskObj=$system.Task.%OpenId(tTaskID,,.tSC) Quit:$isObject(tTaskObj)  Hang 15}
		Quit:$$$ISERR(tSC) tSC
	} Else {
		Set tTaskObj=$system.Task.%New()
		Set tIsNew=1
	}
	Set tTaskObj.Name=..#TaskName
	Set tTaskObj.Description=..#TaskName
	Set tTaskObj.TaskClass=..%ClassName(1)  // The name of the Task Class (where OnTask is)
	Set tTaskObj.NameSpace=pNS  // Namespace the task will run in
	Set tTaskObj.RunAsUser=$$$HSTaskUserName
	if tIsNew {
		Set tTaskObj.DailyFrequency=tTaskObj.DailyFrequencyDisplayToLogical(..#DailyFrequency)
		If ..#DailyFrequency="Several" {
			Set tTaskObj.DailyFrequencyTime=tTaskObj.DailyFrequencyTimeDisplayToLogical(..#DailyFrequencyTime)
			Set tTaskObj.DailyIncrement=..#DailyIncrement  // (every x hour or x minutes depending on DailyFrequencyTime)
		}
		Set tTaskObj.Expires=1
		Set tTaskObj.StartDate=+$H
	}
	Set tSC=tTaskObj.%Save()
	If tSC Do $System.Task.Resume(tTaskObj.%Id())
	Quit tSC
}

}
