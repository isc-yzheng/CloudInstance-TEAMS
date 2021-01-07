/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Import (EnsLib.HL7, EnsLib.HL7.MsgRouter, EnsLib.InteropTools.HL7.MessageAnalyzer, EnsLib.InteropTools.HL7.MessageAnalyzer.Message, EnsLib.InteropTools.HL7.MessageAnalyzer.Validation)

Include (EnsLib.InteropTools.HL7.MessageAnalyzer.Utils, EnsLib.InteropTools.HL7.MessageAnalyzer.VTColors)

Class EnsLib.InteropTools.HL7.MessageAnalyzer.Generate.Browser Extends %RegisteredObject
{

Property Message As Message [ Private ];

Property Version As %String [ Private ];

ClassMethod BrowseMessage(pMessageThing, pVersion As %String = "")
{
	Kill %objlasterror
	Set tBrowser=##class(Browser).%New(pMessageThing,pVersion)
	If tBrowser="" {
		Do $System.OBJ.DisplayError($Get(%objlasterror,$$$ERROR($$$GeneralError,"BrowseMessage: unknown error")))
		Quit
	}
	
	Do tBrowser.Browse()
}

Method %OnNew(pMessageThing, pVersion As %String = "") As %Status
{
	Set ..Message=..MakeMessage(pMessageThing,.tSC) If $$$ISERR(tSC) {Quit tSC}
	Set ..Version=pVersion
	
	Quit $$$OK
}

Method Browse()
{
	While 1 {
		
		Set tIn=..GetInput()
		If "^Q^q"[tIn {Quit}
		
		Try {
			Do ..Dispatch(tIn)
		}
		Catch tErr {
			Use 0
			Write:$X !
			Write tErr.DisplayString(),!!
		}
	}
}

Method Dispatch(pIn As %String)
{
	// translations
	If $Extract(pIn)="?" {
		Set tUseIn="H "_$$$TRIM($Extract(pIn,2,*))
	}
	ElseIf $$$ALLOWEXECUTE,$Extract(pIn)="!" {
		Set tUseIn="X "_$$$TRIM($Extract(pIn,2,*))
	}
	Else {
		Set tUseIn=pIn
	}
	
	Set tCommand=$$$TOUP($Piece(tUseIn," "))
	
	If tCommand?1.A {
		Do ..DispatchCommand(tCommand,$$$TRIM($Piece(tUseIn," ",2,*)))
	}
	Else {
		Do ..DispatchVDoc(tUseIn)
	}
}

Method DispatchCommand(pCommand As %String, pArgsString As %String) [ Private ]
{
	Do $Case(pCommand,
		"H":..CHelp(pArgsString),
		"LS":..CListSegments(pArgsString),
		"LA":..CListAll(pArgsString),
		"DT":..CDocType(pArgsString),
		"V":..CVersion(pArgsString),
		"VAL":..CValidate(pArgsString),
		"X":..CXecute(pArgsString),
		:..CError(pCommand,pArgsString)
	)
}

Method DispatchVDoc(pIn As %String) [ Private ]
{
	If pIn["=" {
		Do ..SetVDoc($$$TRIM($Piece(pIn,"=")),$$$TRIM($Piece(pIn,"=",2,*)))
	}
	Else {
		Do ..GetVDoc(pIn)
	}
}

Method SetVDoc(pVDoc As %String, pNewValue As %String) [ Private ]
{
	$$$THROWONERROR(tSC,..Message.SetValueAt(pNewValue,pVDoc))
}

Method GetVDoc(pVDoc As %String) [ Private ]
{
	Set tSC=$$$OK
	Set tValue=..Message.GetValueAt(pVDoc,,.tSC) $$$THROWONERROR(tSC,tSC)	
	Write pVDoc," = ",tValue,!
}

Method CHelp(pArgsString As %String) [ Private ]
{
	Write "LS   .. list all segments",!
	Write "LS N .. list segment #N",!
	Write "LA   .. list all segments, fields, repeats and subcomponents as a hierarchy",!
	Write "LA N .. list segments #N and its fields, repeats and subcomponents as a hierarchy",!
	Write "DT   .. show doctype",!
	Write "DT [VERSION:]SCHEMA .. set doctype",!
	Write "V    .. show version",!
	Write "V VERSION .. set version",!
	Write "VAL  .. validate message using default settings ('e' => validate everything)",!
	Write "VAL SETTINGS .. validate message using given settings",!
	If $$$ALLOWEXECUTE {
		Write "!LINE .. execute LINE as Cache' code",!
	}
	Write !
	Write "? .. this help",!
	Write "Q .. exit from this browser",!
}

Method CListSegments(pArgsString As %String) [ Private ]
{
	If pArgsString="" {
		For tI=1:1:..Message.SegCount {
			Do ..ShowSegment(tI)
		}
	}
	Else {
		Set tSegNo=+pArgsString
		If (tSegNo<1) || (tSegNo>..Message.SegCount) || (tSegNo[".") {
			Write "Invalid segment number",!
		}
		Else {
			Do ..ShowSegment(tSegNo)
		}
	}
}

Method CListAll(pArgsString As %String) [ Private ]
{
	If pArgsString="" {
		For tI=1:1:..Message.SegCount {
			Do ..ListSegment(tI)
		}
	}
	Else {
		Set tSegNo=+pArgsString
		If (tSegNo<1) || (tSegNo>..Message.SegCount) || (tSegNo[".") {
			Write "Invalid segment number",!
		}
		Else {
			Do ..ListSegment(tSegNo)
		}
	}
}

Method CDocType(pArgsString As %String) [ Private ]
{
	If pArgsString'="" {
		Kill %objlasterror
		Set ..Message.DocType=..SchemaFor(pArgsString)
		$$$THROWONERROR(tSC,$Get(%objlasterror,$$$OK))
	}

	Write "DocType: ",..Message.DocType,!
}

Method CVersion(pArgsString As %String) [ Private ]
{
	If pArgsString'="" {
		Set ..Version=pArgsString
	}

	Write "Version: ",..Version,!
}

Method CValidate(pArgsString As %String) [ Private ]
{
	Set tSettings=$Select(pArgsString="":"e-x",1:pArgsString)
	
	Set tConfig="Browser"
	Kill %objlasterror
	Set tRoutingEngine=##class(RoutingEngine).%New(.tConfig)
	If '$IsObject(tRoutingEngine) {
		$$$THROWONERROR(tSC,$Get(%objlasterror,$$$ERROR($$$GeneralError,"Unable to create routing engine")))
	}
	
	Set tSC=$$$OK
	Set tRet=tRoutingEngine.OnValidate(..Message,tSettings,.tSC)
	If $$$ISERR(tSC) {
		Kill tErrorList
		Do ##class(Common).StatusToErrorList(tSC,.tErrorList)
		For tI=1:1:$Get(tErrorList) {
			Write " ",tErrorList(tI),!
			Set tRetSM=##class(ValidationStatusMessages).DispatchStatusMessage(tErrorList(tI),1)
			If tRetSM'="" {
				Write " - matched: ",$List(tRetSM),"(",$ListToString($List(tRetSM,2)),")",!
				Set tClass=$Piece($List(tRetSM),":"),tMethod=$Piece($List(tRetSM),":",2)
				Set tArgs=$List(tRetSM,3)
				Do $ClassMethod("EnsLib.InteropTools.HL7.MessageAnalyzer.Validation."_tClass,tMethod,tArgs)
			}
		}
	}
}

Method CXecute(pArgsString As %String) [ Private ]
{
	Try {
		Xecute pArgsString
	}
	Catch (tErr) {
		Use 0
		Throw
	}
}

Method CError(pCommand As %String, pArgsString As %String) [ Private ]
{
	$$$THROWONERROR(tSC,$$$ERROR($$$GeneralError,"Unknown command: "_pCommand))
}

Method SchemaFor(pSchemaSpec As %String) As %String [ CodeMode = expression, Private ]
{
$Select(pSchemaSpec[":":pSchemaSpec,1:##class(Common).SchemaVersion(..Version)_":"_pSchemaSpec)
}

ClassMethod GetInput() As %String [ Private ]
{
	Do {
		Read "mb>",tRawIn,!
		Set tIn=$$$TRIM(tRawIn)
	} While tIn=""
	
	Quit tIn
}

/// pMessageThing can be any of the following:
/// <ul>
///  <li> an EnsLib.HL7.Message object
///  <li> an EnsLib.InteropTools.HL7.MessageAnalyzer.Message.SimpleMessage object
///  <li> a string containing CR or LF with a message in the standard HL7 text format
///  <li> a comma-separated list of segment names, each name matching 1 uppercase-letter followed by 2 uppercase-letters/digits
///  <li> a path to a file containing a message in the standard HL7 text format
ClassMethod MakeMessage(pMessageThing, Output pSC As %Status = {$$$OK}) As Message [ Private ]
{
	// if it's an object ..
	If $IsObject(pMessageThing) {
		
		// Message object => return it ..
		If pMessageThing.%ClassName(1)="EnsLib.HL7.Message" {
			Set pSC=$$$OK
			Quit pMessageThing
		}
		
		// .. SimpleMessage object => return Message created from the simple message's message text ..
		ElseIf pMessageThing.%ClassName(0)="SimpleMessage" {
			Quit pMessageThing.ToHL7Message(.pSC)
		}
		
		/// .. any other object => error ..
		Else {
			Set pSC=$$$ERROR($$$GeneralError,"Generate.Browser: don't know how to handle this sort of message object "_pMessageThing)
			Quit ""
		}
	}
	
	// .. not an object ..
	Else {
	
		// contains CR or LF => return Message created from the raw text ..  
		If (pMessageThing[$Char(13)) || (pMessageThing[$Char(10)) {
			Quit ##class(Message).ImportFromString(pMessageThing,.pSC)
		}
		
		// .. matches a segment sequence => return Message created from the text with commas changed to linefeeds ..
		ElseIf pMessageThing?1U2UN1.(1","1U2UN) {
			Quit ##class(SimpleMessage).%New(pMessageThing).ToHL7Message(.pSC)
		}
		
		// .. anything else => return Message created from the file at the path given by the text ..
		Else {
			Quit ##class(Message).ImportFromLibraryStream(##class(EnsLib.InteropTools.HL7.MessageAnalyzer.Common).ReadFileStream(pMessageThing),.pSC)
		}
	}
}

Method ShowSegment(pSegNo As %Integer) [ Private ]
{
	Set tSegment=..Message.GetSegmentAt(pSegNo,.tSC) $$$THROWONERROR(tSC,tSC)
	Set tSegmentString=tSegment.OutputToString(,,.tSC) $$$THROWONERROR(tSC,tSC)
	Write tSegmentString,!
}

Method ListSegment(pSegNo As %Integer) [ Private ]
{
	If $Get($$$GLOBALSETTING("VTCOLOR"),0) {
		Set tSEG=$$$VTFGBLUE,tREP=$$$VTFGGREEN,tFLD=$$$VTFGCYAN,tCMP=$$$VTFGMAGENTA,tSUB=$$$VTFGRED,tRESET=$$$VTRESET
	}
	Else {
		Set (tSEG,tFLD,tREP,tCMP,tSUB,tRESET)=""
	}
	
	Set tSegment=..Message.GetSegmentAt(pSegNo,.tSC) $$$THROWONERROR(tSC,tSC)
	Set tSegmentString=tSegment.OutputToString(,,.tSC) $$$THROWONERROR(tSC,tSC)
	
	// segment
	Write pSegNo,": ",tSEG,tSegmentString,tRESET,!
	If (tSegmentString[..Message.FS) || (tSegmentString[..Message.RS) || (tSegmentString[..Message.CS) || (tSegmentString[..Message.SS) {
			
		Set tSegmentFields=$ListFromString(tSegmentString,..Message.FS)
		Set tJ=-1 // fields start at 0
		Set tPtrJ=0 While $ListNext(tSegmentFields,tPtrJ,tFieldString) {
			Set tJ=tJ+1
			
			// field
			Write " F",tJ,": ",tFLD,tFieldString,tRESET,!
			If (tFieldString[..Message.RS) || (tFieldString[..Message.CS) || (tFieldString[..Message.SS) {		
				Set tFieldRepeats=$ListFromString(tFieldString,..Message.RS)
				Set tK=0
				Set tPtrK=0 While $ListNext(tFieldRepeats,tPtrK,tRepeatString) {
					Set tK=tK+1
					
					// repeat
					Write "  R",tK,": ",tREP,tRepeatString,tRESET,!
					If (tRepeatString[..Message.CS) || (tRepeatString[..Message.SS) {
						Set tRepeatComponents=$ListFromString(tRepeatString,..Message.CS)
						Set tL=0
						Set tPtrL=0 While $ListNext(tRepeatComponents,tPtrL,tComponentString) {
							Set tL=tL+1
							
							// component
							Write "   C",tL,": ",tCMP,tComponentString,tRESET,!
							If tComponentString[..Message.SS {
								Set tComponentSubcomponents=$ListFromString(tComponentString,..Message.SS)
								Set tM=0
								Set tPtrM=0 While $ListNext(tComponentSubcomponents,tPtrM,tSubcomponentString) {
									Set tM=tM+1
									
									// subcomponent
									Write "    S",tM,": ",tSUB,tSubcomponentString,tRESET,!
								}
							}		
						}
					}		
				}			
			}
		}
	}
}

}
