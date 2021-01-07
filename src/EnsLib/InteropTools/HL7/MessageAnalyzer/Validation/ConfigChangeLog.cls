/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import EnsLib.InteropTools.HL7.MessageAnalyzer.Logging

Include EnsLib.InteropTools.HL7.MessageAnalyzer.ConfigChange

/// Root is at ^Ens.MA("CONFIGCHANGE")
/// <p> ^(YYYY-MM-DD)=N
/// <p> ^(YYYY-MM-DD,1..N,0)=HH:MM
/// <p> ^(YYYY-MM-DD,1..N)=M
/// <p> ^(YYYY-MM-DD,1..N,1..M)=$LB(CLASS,CLASSARGS,CATEGORY,SUBCATEGORY,ITEM,OLDDATA,NEWDATA)
Class EnsLib.InteropTools.HL7.MessageAnalyzer.Validation.ConfigChangeLog Extends %RegisteredObject
{

/// YYYY-MM-DD format
Property SessionStartDate As %String [ Private ];

Property DayIndex As %Integer [ Private ];

Method %OnNew() As %Status
{
	Set tNow=$Horolog
	Set ..SessionStartDate=$ZDate(tNow,3)
	Set tSessionStartTime=$ZTime($Piece(tNow,",",2),1)
	Set ..DayIndex=$I($$$CONFIGCHANGETOP(..SessionStartDate))
	Set $$$CONFIGCHANGESTARTTIME(..SessionStartDate,..DayIndex)=tSessionStartTime 
	Quit $$$OK
}

Method LogChange(pClassName As %String, pClassArgs As %String, pCategory As %String, pSubCategory As %String, pItem As %String, pOldData As %String, pNewData As %String)
{
	Set tChangeIndex=$I($$$CONFIGCHANGESESS(..SessionStartDate,..DayIndex))
	Set $$$CONFIGCHANGEFIX(..SessionStartDate,..DayIndex,tChangeIndex)=$ListBuild(pClassName,pClassArgs,pCategory,pSubCategory,pItem,pOldData,pNewData)
}

Method LogCopy(pClassName As %String, pClassArgs As %String, pCategory As %String, pItem As %String, pSourceVersion As %String, pTargetVersion As %String)
{
	Set tChangeIndex=$I($$$CONFIGCHANGESESS(..SessionStartDate,..DayIndex))
	Set $$$CONFIGCHANGEFIX(..SessionStartDate,..DayIndex,tChangeIndex)=$ListBuild(pClassName,pClassArgs,pCategory,pItem,pSourceVersion,pTargetVersion)
}

ClassMethod DescribeRangeOfDays(pStartDate As %String = "", pEndDate As %String, pLogger As Logger = {##class(Logger).%New()}, pWithHeaderLine As %Boolean = 1)
{
	Set tHL7Configuration=##class(HL7Configuration).%New()
	
	// the end date defaults to the start date
	Set tUseEndDate=$Get(pEndDate,pStartDate)
	
	// if there's no start date ..
	If pStartDate="" {
	
		// start at the beginning
		Set tDate=""
	}
	
	Else {
	
		// start just before the start date (so that the first $Order in the While loop gives the start date)
		Set tDate=$Order($$$CONFIGCHANGETOP(pStartDate),-1)
	}

	If pWithHeaderLine {
		Set tNow=$Horolog
		Do pLogger.OutputToLog("Configuration Change Log on "_$$date(tNow)_" at "_$$time(tNow)_" for "_$$daterange)
	}
	
	// track whether we show anything
	Set tFoundAny=0
	
	While 1 {
	
		// next date to show
		Set tDate=$Order($$$CONFIGCHANGETOP(tDate),+1,tDayCount) If tDate="" {Quit}
		If tUseEndDate'="",tDate]]tUseEndDate {Quit}
		
		// show the date
		Do pLogger.OutputListToLog($ListBuild("","Changes on "_tDate))
		
		// note that we've shown something		
		Set tFoundAny=1
		
		// for each session on that date ..
		For tDayIndex=1:1:tDayCount {

			// show the time
			Set tTime=$$$CONFIGCHANGESTARTTIME(tDate,tDayIndex)
			Do pLogger.OutputListToLog($ListBuild(""," At "_tTime))
			
			// for each change in that session ..
			Set tChangeCount=$Get($$$CONFIGCHANGESESS(tDate,tDayIndex))
			For tChangeIndex=1:1:tChangeCount {
				Set tChangeDescription=..Describe(tHL7Configuration,tDate,tDayIndex,tChangeIndex,"  ")
				Do pLogger.OutputListToLog(tChangeDescription)
			}
		}
	}
	
	// if we didn't show anything ..
	If 'tFoundAny {
		Do pLogger.OutputToLog("No changes in the log for the given period.")
	}
	
	Quit
	
date(now)	Quit $ZDate(now,2)
time(now)		Quit $ZTime($Piece(now,",",2),3)
daterange()	Quit $$start_" to "_$$end
start()	Quit $Select(pStartDate="":"start",1:pStartDate)
end()	Quit $Select(tUseEndDate="":"end",1:tUseEndDate)
}

/// Returns a $List of lines of text describing the change
ClassMethod Describe(pHL7Configuration As HL7Configuration, pSessionStartDate As %String, pDayIndex As %Integer, pChangeIndex As %Integer, pIndent As %String = "") As %List
{
	Try {
	
		If '($Data($$$CONFIGCHANGEFIX(pSessionStartDate,pDayIndex,pChangeIndex),tRecord)#10) {ZTrap}	
		
		Return $Case($ListLength(tRecord),
			7:..DescribeChange(pHL7Configuration,tRecord,pIndent),
			6:..DescribeCopy(pHL7Configuration,tRecord,pIndent)
		)
	}
	
	Catch tErr {
		Return $ListBuild(tErr.DisplayString())
	}
}

ClassMethod DescribeChange(pHL7Configuration As HL7Configuration, pRecord As %List, pIndent As %String = "") As %List [ Private ]
{
	Set $ListBuild(tClassName,tClassArgs,tCategory,tSubCategory,tItem,tOldData,tNewData)=pRecord
	
	Set $ListBuild(tBasicDescription,tCurrentData)=$ClassMethod(tClassName,"DescribeChange",pHL7Configuration,tClassArgs,tCategory,tSubCategory,tItem,tOldData,tNewData)

	Set tOut=$ListBuild(pIndent_tBasicDescription)
	
	If tCurrentData'=tNewData {
		If tCurrentData=tOldData {
			Set tOut=tOut_$ListBuild(pIndent_" - the current configuration setting matches the previous setting: '"_tOldData_"'","")
		}
		Else {
			Set tOut=tOut_$ListBuild(pIndent_" - the current configuration setting does NOT match the applied setting - current: '"_tCurrentData_"', applied: '"_tNewData_"'","")
		} 
	}
	
	Quit tOut
}

ClassMethod DescribeCopy(pHL7Configuration As HL7Configuration, pRecord As %List, pIndent As %String = "") As %List [ Private ]
{
	Set $ListBuild(tClassName,tClassArgs,tCategory,tItem,tSourceVersion,tTargetVersion)=pRecord
	
	Set $ListBuild(tBasicDescription)=$ClassMethod(tClassName,"DescribeCopy",pHL7Configuration,tClassArgs,tCategory,tItem,tSourceVersion,tTargetVersion)

	Set tOut=$ListBuild(pIndent_tBasicDescription)
	
	Quit tOut
}

}
