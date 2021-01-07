/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Monitor

/// When running the shell a reference to the sole instance of this class is stored in local %masession
Class EnsLib.InteropTools.HL7.MessageAnalyzer.Monitor.Session Extends %RegisteredObject
{

Property SessionId As %Integer [ ReadOnly ];

Property RunId As %Integer [ ReadOnly ];

Property ScanId As %Integer [ ReadOnly ];

Method %OnNew() As %Status
{
	Set i%SessionId=$I($$$MXSESSIONROOTREF)
	Set $$$MXSESSIONREF(..SessionId)=$H
	Set i%RunId=0
	Set i%ScanId=0
	
	Quit $$$OK
}

Method StartRun()
{
	$$$ACASSERT(..SessionId,"Session.StartRun: session id not set")
	
	Set i%RunId=$I($$$MXRUNROOTREF(..SessionId))
	Set $$$MXRUNREF(..SessionId,..RunId)=$H
	Set i%ScanId=0
}

Method StartScan()
{
	$$$ACASSERT(..SessionId,"Session.StartScan: session id not set")
	$$$ACASSERT(..RunId,"Session.StartScan: run id not set")

	Set i%ScanId=$I($$$MXSCANROOTREF(..SessionId,..RunId))
	Set $$$MXSCANREF(..SessionId,..RunId,..ScanId)=$H
}

Method ScanEvent(pEventType As %String, pSubnodes... As %List)
{
	$$$ACASSERT(..SessionId,"Session.ScanEvent: session id not set")
	$$$ACASSERT(..RunId,"Session.ScanEvent: run id not set")
	$$$ACASSERT(..ScanId,"Session.ScanEvent: scan id not set")

	Set tEventId=$I($$$MXSCANEVENTROOTREF(..SessionId,..RunId,..ScanId))
	Set $$$MXSCANEVENTREF(..SessionId,..RunId,..ScanId,tEventId)=pEventType
	For tI=1:1:$Get(pSubnodes) {
		Set $ListBuild(tKey,tValue)=pSubnodes(tI)
		Set $$$MXSCANEVENTSUBREF(..SessionId,..RunId,..ScanId,tEventId,tKey)=tValue
	}
}

ClassMethod Cleanup(pKeepDays As %Integer = 2)
{
	Set tCleanupBeforeDate=$Piece($H,",")-pKeepDays
	
	Set tSession="" While 1 {
	
		Set tSession=$Order($$$MXSESSIONREF(tSession),+1,tSessionDateTime) If tSession="" {Quit}
		
		If $Piece(tSessionDateTime,",") < tCleanupBeforeDate {
			Kill $$$MXSESSIONREF(tSession)
		}
	}
}

}
