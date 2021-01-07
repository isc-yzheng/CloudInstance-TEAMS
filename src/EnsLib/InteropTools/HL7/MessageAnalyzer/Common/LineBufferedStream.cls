/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsLib.InteropTools.HL7.MessageAnalyzer.Utils

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Common.LineBufferedStream Extends %RegisteredObject
{

Property Stream As %Stream.Object [ Private ];

/// Tracks last line read from the stream in case we need to buffer it
Property LastReadFromStream As %String [ Private ];

/// Empty list ("") => no buffered line, single-item list has buffered line
Property BufferedLine As %List [ Private ];

/// Tracks last 'len' returned from ReadLine in case we need to return it from a buffer
Property LastLen As %Integer [ Private ];

/// Tracks last 'eol' returned from ReadLine in case we need to return it from a buffer
Property LastEol As %Boolean [ Private ];

Property AtEnd As %Boolean [ Private ];

/// Set when a non-OK status is returned by the stream
Property StreamBadStatus As %String [ Private ];

Method %OnNew(pStream As %Stream.Object) As %Status
{
	Set ..Stream=pStream
	Set ..BufferedLine=""
	Set ..StreamBadStatus=""
	Quit $$$OK
}

Method ReadLine(ByRef len As %Integer, ByRef sc As %Status, ByRef eol As %Boolean) As %CacheString
{
	If ..StreamBadStatus'="" {
		Set tSC=$$$ERROR($$$GeneralError,"LineBufferedStream: caller used stream after it returned a error status code")
		$$$ThrowStatus($$$ADDSC(tSC,..StreamBadStatus))
	}
	
	If ..BufferedLine'="" {
		Set tResult=$List(..BufferedLine)
		Set ..BufferedLine=""
		Set len=..LastLen
		Set sc=$$$OK
		Set eol=..LastEol
		Quit tResult
	}
	
	Set ..LastReadFromStream=..Stream.ReadLine(.len,.sc,.eol)
	If $$$ISERR(sc) {
		Set ..StreamBadStatus=sc
	}
	
	Set ..LastLen=len
	Set ..LastEol=eol
	Quit ..LastReadFromStream
}

Method AtEndGet() As %Boolean [ CodeMode = expression ]
{
(..BufferedLine="") && ..Stream.AtEnd
}

Method PutLineBack()
{
	If ..BufferedLine'="" {
		$$$THROW("LineBufferedStream: attempt to put back more than one line")
	}
	
	Set ..BufferedLine=$ListBuild(..LastReadFromStream)
}

}
