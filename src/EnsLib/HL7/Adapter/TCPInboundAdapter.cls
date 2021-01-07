/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsHL7

/// Inbound adapter for HL7 v2 over TCP
Class EnsLib.HL7.Adapter.TCPInboundAdapter Extends EnsLib.TCP.InboundAdapter [ ClassType = "", ProcedureBlock, System = 4 ]
{

/* (override Setting InitialExpression inherited from base class) */
/// How many incoming connections should the OS hold open on our behalf until we get around to dealing with them? <p>
/// Set to 0 if only one connection at a time is expected. Set to a large number if many clients will connecting rapidly.
Property QSize As %Integer(MAXVAL = 1000, MINVAL = 0) [ InitialExpression = 0 ];

/* (override Setting InitialExpression inherited from base class) */
/// Spawn a new Job to handle each incoming TCP connection. Allows simultaneous handling of multiple connections. <br/>
/// Note that the performance of this setting can be affected by changing the configured QSize setting of this adapter and by configuring Job Servers as a system configuration option.
Property JobPerConnection As %Boolean [ InitialExpression = 0 ];

/// Local holder for lookahead line for Parser
Property %OutLine As %String;

Method OnInit() As %Status
{
	#; override (empty) superclass initial Terminators value
	Set ..Terminators=..BusinessHost.GetSegmentTerminator()
	Quit ##super()
}

Method OnConnected() As %Status
{
	Set tSC=$$$OK, tQuitErr=1
	Do {
		If ""=..%OutLine {
			$$$catTRACE("connwait","Beginning header read for terminator '"_$A(..Terminators)_"' with timeout "_..CallInterval_" on "_..IOAddr)
			Set tTimeout=..CallInterval, tZB=..Terminators, tLine=..Socket.ReadLine(32000,.tTimeout,.tSC,.tZB)
			If $$$ISERR(tSC) {
				If ..IsReadError(tSC) {
					Set tSC=$$$ERROR($$$EnsErrInConnectionLost,"HL7 Read",..IOAddr,$$$StatusDisplayString(tSC))
					Set tQuitErr=0  Do ..Disconnect()
					If ""=tLine Set tTxt=$$$StatusText(tSC), tSC=$$$OK  If ..StayConnected<0 { $$$LOGWARNING(tTxt) } ElseIf ..%logConnections { $$$LOGINFO(tTxt) } Else { $$$sysTRACE(tTxt) } ; change error to info if lost connection with no data
				}
			} ElseIf tTimeout=..CallInterval {
				If ""'=tLine { ; only report error if timed out after getting some data
					Set tSC=$$$ERROR($$$EnsErrTCPTerminatedReadTimeoutExpired,tTimeout,"EndData="_$A($E(..Terminators))_$S(""=$E(..Terminators,2):"",1:","_$A($E(..Terminators,2))),tLine)
					Set tQuitErr=0
				}
			}
			#; No need to check timeout - just see if we got any data
			Quit:""=tLine
			$$$catTRACE("connwait","Got line '"_tLine_"'")
			Quit:$$$ISERR(tSC)
			Set ..%OutLine=$LB(1,tZB,tLine)
		}
		$$$ANEWINIOLOGENTRY($$$OK,"TCP ReadHL7 on :"_..IOAddr,"EnsLib.HL7.Message")
		Set tSC=..BusinessHost.ProcessInput(..%OutLine,.tOutLine)
		Set ..%OutLine=tOutLine
		If $$$ISERR(tSC) {
			Set tIsWriteErr=..IsWriteError(tSC)
			If tIsWriteErr||..IsReadError(tSC) {
				Set tSC=$$$ERROR($$$EnsErrInConnectionLost,$S(tIsWriteErr:"HL7 Write",1:"HL7 Read"),..IOAddr,$$$StatusDisplayString(tSC))
				Set tQuitErr=0  Do ..Disconnect()
			}
			$$$ACLOSEIOLOGENTRY(tSC,"after TCP ProcessInput error on :"_..IOAddr,$$$NULLOREF)
		} Else {
			If $IsObject(..BusinessHost.IOLogEntry) && ..BusinessHost.IOLogEntry.IsEmpty() { Set ..BusinessHost.IOLogEntry=$$$NULLOREF } ; don't log empty IO if no error
			Else { $$$ACLOSEIOLOGENTRY(tSC,"after TCP ProcessInput on :"_..IOAddr,$$$NULLOREF) }
		}
	} While 0
	If $$$ISERR(tSC) {
		#; Drop the connection on unrecognized error
		If tQuitErr&&..Connected&&..StayConnected {
			$$$LOGERROR("Disconnecting due to "_$$$StatusDisplayString(tSC))
			Do ..Disconnect()
		} Else {
			$$$LOGSTATUS(tSC)
		}
	}
	#; Returning error status would cause this listener job to terminate; never quit the listener
	Quit $$$OK
}

Method Disconnect()
{
	If ""'=..%OutLine $$$LOGWARNING("Discarding leftover input '"_$LG(..%OutLine,3)_"'")
	Set ..%OutLine=""
	Do:..Connected ..BusinessHost.%Parser.Reset()
	Do ##super()
}

/// This method is used to Clear the receive buffer.
/// It will call Disconnect() if there is a Read error.
/// If used it is intended to be called immediately before returning an ACK
/// pClearFlag can be:
/// - 0 : do not discard any waiting inbound data
/// - 1 : discard waiting inbound data and log a warning in Event log<br/>
/// - 2 : discard waiting inbound data. Record in Event log only if Debug trace is enabled. <br/>
/// pDiscarded returns to the caller the first discarded line with any control characted mapped.
Method ClearRecvBuffer(pClearFlag As %Integer = 0, Output pDiscarded As %String, ByRef pIOLogEntry As Ens.Util.IOLog = {$$$NULLOREF}) As %Status
{
#define MapCtlChars(%s)	$TR(%s,$C(1,2,9,10,11,13,28),"12tlsre")
#define MapCtlLine(%s)	($$$MapCtlChars($E(%s,1,1000))_$S($L(%s)>1000:"...",1:""))
#define MapCtlLineZB(%s,%zb)	($$$MapCtlLine(%s)_"+"_$$$MapCtlChars(%zb))
		
	Set tSC = $$$OK
	Set pDiscarded = ""
	Quit:'pClearFlag $$$OK

	Try {	
		#; Clean out any pending messages because before we reply there should be
		#; none except possibly retries of the same message we are replying to
		Set tMaxReadLen = $$$HL7MaxReadLen
		$$$catTRACE("parse","Looking for data on wire before ACKing.")
		While '..Socket.AtEnd {
			Kill tZB  Set tLine=..Socket.ReadLine(tMaxReadLen,0,.tSC,.tZB)
			If $$$ISERR(tSC) {
				$$$LOGSTATUS(tSC)
				Quit
			}
			Quit:((""=tLine)&&(""=tZB))
			Set tMappedDiscardData = $$$MapCtlLineZB(tLine,tZB)
			If (pClearFlag#2) {
				$$$LOGWARNING("Discarding data found in buffer before HL7 ACK send: "_tMappedDiscardData)
			} Else {
				$$$catTRACE("parse","Discarding data found in buffer before HL7 ACK send: "_tMappedDiscardData)
			}
			If $IsObject(pIOLogEntry) {
				If '$$$IsdefObject(tDiscard) { Set tDiscard=##class(%Stream.GlobalCharacter).%New() }
				Do tDiscard.Write(tMappedDiscardData)
			}
			Set:(pDiscarded="") pDiscarded = tMappedDiscardData
		}
		If $$$IsdefObject(tDiscard) {
			Set tPreJunk=tDiscard.Read(1000) Do tDiscard.Rewind()
			Set tNote="Unexpected HL7 read data ("_$S(tDiscard.Size>1000:"...",1:"")_tPreJunk_") before Message on "_..Socket.Name
			Do ..BusinessHost.IOLogDiscard(tSC,tNote,tDiscard)
		}
	} Catch { 
		Set tSC = $$$EnsSystemError
	}
	If $$$ISERR(tSC) {
		If ..IsReadError(tSC) {
			Set tSC=$$$ERROR($$$EnsErrOutConnectionLost,"HL7 Read", ..Device, $$$StatusDisplayString(tSC))
			Do ..Disconnect()
		}
	}
	Quit tSC
}

}
