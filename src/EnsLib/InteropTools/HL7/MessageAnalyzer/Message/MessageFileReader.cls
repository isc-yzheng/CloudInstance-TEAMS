/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Shell, EnsLib.InteropTools.HL7.MessageAnalyzer.Common)

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.SimpleMessage)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Message.MessageFileReader Extends %RegisteredObject
{

Property Input As %Stream [ Private, ReadOnly ];

Property LineNumber As %Integer [ Private ];

Property MessageCounter As %Integer [ Private ];

Property SkipLimit As %Integer [ Private ];

Parameter MESSAGESTARTSEGMENTNAMES = {$ListBuild("MSH","FHS","FTS","BHS","BTS")};

/// Takes either a stream or a file path as argument
Method %OnNew(pInput As %Stream, pConfig As Config = "") As %Status
{
	If $IsObject(pInput) {
		Set i%Input=pInput
	}
	Else {
		Set i%Input=##class(Common).ReadFileStream(pInput)
	}
	
	If 'i%Input.%IsA("EnsLib.InteropTools.HL7.MessageAnalyzer.Common.LineBufferedStream") {
		Set i%Input=##class(LineBufferedStream).%New(i%Input)
	}
	
	Set ..LineNumber=0
	Set ..MessageCounter=0
	
	Set ..SkipLimit=$Select(pConfig="":0,1:+pConfig.GetOptionValue("MESSAGESKIPCOUNT"))
	
	Quit $$$OK
}

/// Returns 0 if no more messages
Method NextMessage(Output pMessage As %String, Output pMessageNumber, Output pStartLineNo) As %Boolean
{
	For tI=1:1:..SkipLimit-1 {
		If '..NextMessageImpl() {
			Return 0
		}
	}
	
	Quit ..NextMessageImpl(.pMessage,.pMessageNumber,.pStartLineNo)
}

/// Returns 0 if no more messages
/// <p> Messages are in multi-line blocks separated by one or more blank lines
/// <br> Each line of a block is a message segment, beginning with a message type (e.g. MSH)
Method NextMessageImpl(Output pMessage As %String, Output pMessageNumber, Output pStartLineNo) As %Boolean [ Private ]
{
	While 1 {
	
		If '..NextMessageImplAll(.pMessage,.pMessageNumber,.pStartLine) {Return 0} // end of input
	
		If $Extract(pMessage,1,3)="MSH" {Return 1} // found MSH message
		
		// ... skip FHS, FTS, BHS, BTS messages
	}
}

/// Returns 0 if no more messages
/// <p> Messages are in multi-line blocks separated by one or more blank lines
/// <br> Each line of a block is a message segment, beginning with a message type (e.g. MSH)
Method NextMessageImplAll(Output pMessage As %String, Output pMessageNumber, Output pStartLineNo) As %Boolean [ Private ]
{
	Set tOut=""
	While 'i%Input.AtEnd {
	
		Set tLine=$$$TRIM(i%Input.ReadLine(,.tSC)) If $$$ISERR(tSC) {$$$ThrowStatus(tSC)}
		
		// if we've collected some lines and this line begins with a message-start segment ..
		If tOut'="", ..IsMessageStartSegmentName($Extract(tLine,1,3)) {
		
			// put this line back into the stream buffer
			Do i%Input.PutLineBack()
			
			// return what we have
			Quit  // quit the While loop
		}
		
		Set ..LineNumber=..LineNumber+1
		
		// if the line is not blank ..
		If tLine'="" {
		
			// if this the first line of a new message ..
			If tOut="" {
			
				// note the start-line-number of the message and increment the message count 
				Set tStartLineNo=..LineNumber
				Set ..MessageCounter=..MessageCounter+1
				
				// if this is a single-line message ..
				If $Piece(tLine,",")?1.AN {
					Set tOut=$ListFromString(tLine)
					Quit  // the message is complete
				}
			}
						
			// add the message line to the message we're building
			Set tOut=tOut_$ListBuild(tLine)
		}
	}

#define SHOULDPATCHMESSAGE 0
#if $$$SHOULDPATCHMESSAGE
	#define MAYBEPATCHMESSAGE(%VAR) Set %VAR=..PatchMessage(%VAR)
#else
	#define MAYBEPATCHMESSAGE(%VAR)
#endif
	
	// if we didn't read a message ..
	If tOut="" {
		Set pMessage=""
		Set pMessageNumber=""
		Set pStartLineNo=""
		Quit 0
	}
	
	// .. we read a message ..
	Else {
		Set pMessage=$ListToString(tOut,$Char(10))
		$$$MAYBEPATCHMESSAGE(pMessage)
		Set pMessageNumber=..MessageCounter
		Set pStartLineNo=tStartLineNo
		Quit 1
	}
}

ClassMethod PatchMessage(pMessage As %String) As %String [ Private ]
{
	Set tMSHSegment=$$$FIRSTSEGMENT(pMessage)
	Set tFDlm=$$$DEFAULT($Extract(tMSHSegment,4),"|")
	
	Set tMSHSegmentField2=$Piece(tMSHSegment,tFDlm,2)
	Set tCDlm=$$$DEFAULT($Extract(tMSHSegmentField2,1),"^")
	Set tFRDlm=$$$DEFAULT($Extract(tMSHSegmentField2,2),"~")
	Set tEscDlm=$$$DEFAULT($Extract(tMSHSegmentField2,3),"\")
	Set tSubCDlm=$$$DEFAULT($Extract(tMSHSegmentField2,4),"&")
	
	Set tNewFDlm="¦" // broken bar
	Set tNewCDlm="⇑" // arrow upwards double
	Set tNewFRDlm="÷" // division sign
	Set tNewEscDlm="‼" // double exclamation mark
	Set tNewSubCDlm="ξ" // small letter xi
	
	// if the message contains the new delimiters it means that:
	// EITHER: the message uses those characters in its content
	// OR: the message has already been transformed by this method
	// - either way, we just leave it unchanged
	If (pMessage[tNewFDlm) || (pMessage[tNewCDlm) || (pMessage[tNewFRDlm) || (pMessage[tNewEscDlm) || (pMessage[tNewSubCDlm) {Quit pMessage}
	
	// put explicit field etc. delimiters in where needed
	Set tRet=..EnsureDelimiters(pMessage)
	
	Set tRet=$Replace(tRet,tFDlm,tNewFDlm)
	Set tRet=$Replace(tRet,tCDlm,tNewCDlm)
	Set tRet=$Replace(tRet,tFRDlm,tNewFRDlm)
	Set tRet=$Replace(tRet,tEscDlm,tNewEscDlm)
	Set tRet=$Replace(tRet,tSubCDlm,tNewSubCDlm)
	Quit tRet
}

ClassMethod EnsureDelimiters(pMessage As %String) As %String [ Private ]
{
	Set tMSHSegment=$$$FIRSTSEGMENT(pMessage)
	Set tFDlm=$$$DEFAULT($Extract(tMSHSegment,4),"|")
	
	Set tMSHSegmentField2=$Piece(tMSHSegment,tFDlm,2)
	
	Set tF2=tMSHSegmentField2
	If $Length(tF2)=0 {Set tF2=tF2_"^"}
	If $Length(tF2)=1 {Set tF2=tF2_"~"}
	If $Length(tF2)=2 {Set tF2=tF2_"\"}
	If $Length(tF2)=3 {Set tF2=tF2_"&"}
	
	// if nothing changed ..
	If tF2=tMSHSegmentField2 {
		Quit pMessage
	}
	
	// write delimiter part back into message
	Set tNewMSHSegment=tMSHSegment
	Set $Piece(tNewMSHSegment,tFDlm,2)=tF2
	Set tSegDlm=$$$SEGMENTDELIMITER(pMessage)
	Quit tNewMSHSegment_tSegDlm_$Piece(pMessage,tSegDlm,2,*)
}

ClassMethod IsMessageStartSegmentName(pSegmentName As %String) As %Boolean [ CodeMode = expression, Private ]
{
$ListFind(..#MESSAGESTARTSEGMENTNAMES,pSegmentName)'=0
}

}
