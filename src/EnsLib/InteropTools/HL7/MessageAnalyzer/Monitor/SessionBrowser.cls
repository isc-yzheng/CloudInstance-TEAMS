/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.Monitor)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Monitor.SessionBrowser Extends %RegisteredObject
{

Property SessionId As %Integer [ Private ];

Method Interactive()
{
	Write:$X !
	Write "Message Analyzer Sessions",!
	Write "(^ to exit)",!
	Write !
	
	Do ..Help()
	
	If ($Data($$$MXSESSIONROOTREF)\10)=0 {
		Write "No sessions in global",!
		Quit
	}
	
	Do ..SummarizeSessions()
	
	While 1 {
		Do ..Prompt()
		Read tRawIn,!
		If tRawIn="^" {
			Quit
		}
		Set tIn=$$$TRIM(tRawIn)
		If tIn'="" {
			Do ..Dispatch(tIn)
		}
	}
}

Method Dispatch(pIn As %String) [ Private ]
{
	Set tCommand=$$$TOUP($Extract(pIn)),tArgs=$$$TRIM($Extract(pIn,2,*))
	
	If tCommand="S" {
		If (tArgs="") || '$Data($$$MXSESSIONREF(tArgs)) {
			Write "'S' must be followed by a valid session id",!
			Quit
		}
		Set ..SessionId=tArgs
		Do ..SummarizeRuns()
	}
	
	ElseIf tCommand="R" {
		If ..SessionId="" {
			Write "Use 'S' to select a session before selecting a run",!
			Quit
		}
		If tArgs="" {
			Write "'R' must be followed by a valid run id for session #",..SessionId,!
			Quit
		}
		Set tRunId=$Piece(tArgs," "),tEventType=$Piece(tArgs," ",2)
		If (tRunId="") || '$Data($$$MXRUNREF(..SessionId,tRunId)) {
			Write "'R' must be followed by a valid run id in session #",..SessionId,!
			Quit
		}
		If tEventType="" {
			Do ..SummarizeOneRun(tRunId)
		}
		Else {
			Do ..ListRun(tRunId,tEventType)
		}
	}
	
	Else {
		Write "- not recognized",!
	}
}

Method Prompt() As %String [ Private ]
{
	Write ..SessionId_">"
}

ClassMethod SummarizeSessions() [ Private ]
{
	Set tSessionCount=0
	Set tSessionId="" While 1 {
		Set tSessionId=$Order($$$MXSESSIONREF(tSessionId)) If tSessionId="" {Quit}
		Set tSessionCount=tSessionCount+1
	}
	
	$$$ACASSERT(tSessionCount,"SummarizeSessions: no sessions")
	
	Write "There are ",tSessionCount," sessions",!
	
	Set tLatestSessionId=$Order($$$MXSESSIONREF(""),-1,tData)
	Write "Latest session #",tLatestSessionId," at ",$ZDate(tData),!
}

Method SummarizeRuns() [ Private ]
{
	Write "Session #",..SessionId," runs",!
	Set tRunId="" While 1 {
		Set tRunId=$Order($$$MXRUNREF(..SessionId,tRunId),+1,tData) If tRunId="" {Quit}
		Write " #",tRunId," on ",$ZDate(tData)," at ",$ZTime($Piece(tData,",",2)),!
	}
}

Method SummarizeOneRun(pRunId As %Integer) [ Private ]
{
	Set tData=$$$MXRUNREF(..SessionId,pRunId)
	Write "Run #",pRunId," on ",$ZDate(tData)," at ",$ZTime($Piece(tData,",",2)),!
	
	Kill tEventTypes
	Set tScanId="" While 1 {
		Set tScanId=$Order($$$MXSCANREF(..SessionId,pRunId,tScanId),+1,tData) If tScanId="" {Quit}
		Set tEventId="" While 1 {
			Set tEventId=$Order($$$MXSCANEVENTREF(..SessionId,pRunId,tScanId,tEventId),+1,tData) If tEventId="" {Quit}
			Set tEventTypes(tData)=""
		}
	}

	Set tOut=""
	Set tEventKey="" While 1 {
	 Set tEventKey=$Order(tEventTypes(tEventKey)) If tEventKey="" {Quit}
	 Set tOut=tOut_$ListBuild(tEventKey)
	}
	
	Write " - event types: ",$ListToString(tOut),!
}

Method ListRun(pRunId As %Integer, pEventType As %String) [ Private ]
{
	Set tData=$$$MXRUNREF(..SessionId,pRunId)
	Write "Run #",pRunId," on ",$ZDate(tData)," at ",$ZTime($Piece(tData,",",2)),!
	
	Set tScanId="" While 1 {
		Set tScanId=$Order($$$MXSCANREF(..SessionId,pRunId,tScanId),+1,tData) If tScanId="" {Quit}
		Write " Scan #",tScanId," on ",$ZDate(tData)," at ",$ZTime($Piece(tData,",",2)),!
		Set tEventId="" While 1 {
			Set tEventId=$Order($$$MXSCANEVENTREF(..SessionId,pRunId,tScanId,tEventId),+1,tData) If tEventId="" {Quit}
			If tData=pEventType {
				Write "  Event #",tEventId,": ",tData,!
				Set tEventSub="" While 1 {
					Set tEventSub=$Order($$$MXSCANEVENTSUBREF(..SessionId,pRunId,tScanId,tEventId,tEventSub),+1,tData) If tEventSub="" {Quit}
					Write "   ",tEventSub," = ",..ShowValue(tData),!
				}
			}
		}
	}
}

Method ShowValue(pValue) As %String [ Private ]
{
	Try {
		Set tShow=$ListToString(pValue)
	}
	Catch {
		Set tShow=pValue
	}
	
	If $Length(tShow)>60 {
		Quit $Extract(tShow,1,60)_" ..."
	}
	
	Quit tShow
}

ClassMethod Help() [ Private ]
{
	Write "'S sessionid' selects that session",!
	Write "'R runid' summarizes the run",!
	Write "'R runid eventtype' summarizes events of that type in the run",!
}

}
