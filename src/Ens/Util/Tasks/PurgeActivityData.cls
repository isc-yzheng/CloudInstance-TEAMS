/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include Ensemble

Class Ens.Util.Tasks.PurgeActivityData Extends %SYS.Task.Definition [ System = 4 ]
{

/// Activity Table to purge
Property TableToPurge As %String(DISPLAYLIST = ",Seconds Table,Hourly Table, Daily Table", VALUELIST = ",s,hh,d") [ InitialExpression = "s" ];

/// Unit of period to purge
Property PeriodToKeep As %String(DISPLAYLIST = ",Seconds,Minutes,Hours,Days,Weeks,Month,Year", VALUELIST = ",s,mi,hh,d,wk,mm,yy") [ InitialExpression = "d" ];

/// Amount of period to purge
Property LengthOfPeriodToKeep As %Integer(MINVAL = 0) [ InitialExpression = 1 ];

Property WriteCountInEventLog As %Boolean;

/// The OnTask() method is called to execute the task
Method OnTask() As %Status
{
	#dim tSC As %Status = $$$OK
	#dim e As %Exception.AbstractException
	#dim tCount As %Integer
	
	If (..PeriodToKeep = "")||(..TableToPurge="") {
		Set tSC = $$$ERROR($$$GeneralError,"Incorrect Period or Table specified for purging Activity Counters task")
		Quit tSC
	}
	
	Set tSC = ##class(Ens.Activity.Utils).Purge(..LengthOfPeriodToKeep_..PeriodToKeep,..TableToPurge,.tCount)
	If ..WriteCountInEventLog $$$LOGINFO(tCount_" entries purged from table Ens.Activity.Data."_$Case(..TableToPurge,"s":"Seconds","hh":"Hours","d":"Days")_" by purge task")	
	
	If $$$ISERR(tSC) $$$LOGERROR("Error purging Activity Counters"_ $$$StatusDisplayString(tSC))
	
	Quit tSC
}

}
