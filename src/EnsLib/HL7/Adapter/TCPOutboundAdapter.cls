/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include EnsHL7

/// Outbound adapter for HL7 v2 over TCP
Class EnsLib.HL7.Adapter.TCPOutboundAdapter Extends EnsLib.TCP.OutboundAdapter [ ClassType = "", ProcedureBlock, System = 4 ]
{

/* override comment */
/// If true, wait to read an ACK or other reply message back from the socket before returning.
Property GetReply As %Boolean [ InitialExpression = 1 ];

/* (override Setting InitialExpression inherited from base class) */
/// Number of seconds to wait on each connection attempt
Property ConnectTimeout As %Numeric(MINVAL = 0) [ InitialExpression = 5 ];

/* (override Setting InitialExpression inherited from base class) */
/// Number of seconds to wait for a response to begin arriving back from the remote system after sending a request. Setting the timeout to -1 means wait forever.
Property ResponseTimeout As %Numeric(MINVAL = -1) [ InitialExpression = 30 ];

Method OnInit() As %Status
{
	#; override (empty) superclass initial Terminators value
	Set ..Terminators=..BusinessHost.GetSegmentTerminator()
	Quit ##super()
}

/// Accepts HL7 Messages and forwards them to a remote IP address, reading a response HL7 Message object returned from the remote IP address if the GetReply setting property is enabled.
Method HL7Message(pMsgOut As EnsLib.HL7.Message, Output pMsgIn As EnsLib.HL7.Message, pExpectedSequenceNumber As %String) As %Status
{
	Set pMsgIn=$$$NULLOREF
	Set tSC = ..Connect(..ConnectTimeout)
	If $$$ISERR(tSC) { Set:$$$StatusEquals(tSC,$$$EnsErrOutConnectExpired,$$$EnsErrOutConnectException) ..BusinessHost.Retry=1  Quit tSC }

	If ..GetReply {
		Set tLine=..BusinessHost.%Parser.%LookaheadLine
		If ""=tLine {
			#; Do a fast check for any data at all before calling the stream parser
			Set $ZT="Trap"
			Read tLine:0
			Set $ZT=""
Read
			Set:""'=tLine ..BusinessHost.%Parser.%LookaheadLineIsNew=1, ..BusinessHost.%Parser.%LookaheadLine=tLine, ..BusinessHost.%Parser.%LookaheadLineTerminator=$ZB
		}
		If ""'=tLine {
			#; clean out any pending acks left over from earlier messages
			Set tLine=""
			Set tStartTimeout=..BusinessHost.%Parser.StartTimeout, ..BusinessHost.%Parser.StartTimeout=0
			For i=1:1 {
				Set tSC=..BusinessHost.%Parser.ParseFramedIOStream(..Socket,.tPreMsgIn,0,..BusinessHost.IOLogEntry)
				If $$$ISERR(tSC) {
					If ..IsReadError(tSC) {
						Set tSC=$$$ERROR($$$EnsErrOutConnectionLost,"HL7 pre-write Read",..IOAddr,$$$StatusDisplayString(tSC))
						Set ..BusinessHost.Retry=1  Do ..Disconnect()
					} ElseIf $$$StatusEquals(tSC,$$$EnsErrTCPTerminatedReadTimeoutExpired) {
						Set tSC=$$$OK
					} Else {
						$$$LOGSTATUS(tSC)
					}
					If $$$IsdefObject(tPreMsgIn) $$$LOGWARNING("Discarding data found in buffer before HL7 send: "_tPreMsgIn.OutputToString())
					$$$ASAVEIOLOGENTRY(tSC,"after HL7 TCP pre-write Read "_i_" error on "_..IOAddr,tPreMsgIn)
					Quit
				} Else {
					If $IsObject(tPreMsgIn) $$$LOGWARNING("Discarding data found in buffer before HL7 send: "_tPreMsgIn.OutputToString())
					$$$ASAVEIOLOGENTRY(tSC,"after HL7 TCP pre-write Read "_i_" on "_..IOAddr,tPreMsgIn)
				}
			}
			Set ..BusinessHost.%Parser.StartTimeout=tStartTimeout
			Quit:$$$ISERR(tSC)&&..BusinessHost.Retry tSC ; ignore non-disconnect errors : parse errors etc
		}
	}
	Set:..Connected tSC=..BusinessHost.OutputFramedToIOStream(..Socket, pMsgOut,..BusinessHost.Separators,.pExpectedSequenceNumber,0,..BusinessHost.IOLogEntry)
	If $$$ISERR(tSC) {
		If ..IsWriteError(tSC) {
			Set tSC=$$$ERROR($$$EnsErrOutConnectionLost,"HL7 Write",..IOAddr,$$$StatusDisplayString(tSC))
			Set ..BusinessHost.Retry=1  Do ..Disconnect()
		} Else {
			If '..StayConnected { Do ..Disconnect() }
			Else { Do ..TestConnection() } ; calls Disconnect() if connection is down
		}
		$$$ASAVEIOLOGENTRY(tSC,"after TCP WriteHL7 error on "_..IOAddr,$$$NULLOREF)
		Quit tSC
	}
	$$$ASAVEIOLOGENTRY(tSC,"after TCP WriteHL7 on "_..IOAddr,$$$NULLOREF)
	Do ..BusinessHost.%Parser.ResetPosition()
	If ..GetReply {
		Set tSC=..BusinessHost.%Parser.ParseFramedIOStream(..Socket,.pMsgIn,0,..BusinessHost.IOLogEntry)
		If $$$ISERR(tSC) {
			If ..IsReadError(tSC) {
				Set tSC=$$$ERROR($$$EnsErrOutConnectionLost,"HL7 Read",..IOAddr,$$$StatusDisplayString(tSC))
				Set ..BusinessHost.Retry=1  Do ..Disconnect()
			} Else {
				Set:$$$StatusEquals(tSC,$$$EnsErrTCPTerminatedReadTimeoutExpired) ..BusinessHost.Retry=1
				Do ..TestConnection() ; calls Disconnect() if connection is down
			}
			$$$ASAVEIOLOGENTRY(tSC,"after TCP ReadHL7 error on "_..IOAddr,pMsgIn)
		} Else {
			$$$ASAVEIOLOGENTRY(tSC,"after TCP ReadHL7 on "_..IOAddr,pMsgIn)
		}
	}
	Do:'..StayConnected&&'..BusinessHost.Retry ..Disconnect()
	Quit tSC
Trap
	Set $ZT="", tSC=$$$SystemError
	If ..IsReadError(tSC) {
		Set tSC=$$$ERROR($$$EnsErrOutConnectionLost,"HL7 pre-write Read",..IOAddr,$$$StatusDisplayString(tSC))
		Set ..BusinessHost.Retry=1  Do ..Disconnect()
	}
	Set tLine=$G(tLine)
	Goto Read
}

Method Disconnect()
{
	Do:..Connected ..BusinessHost.%Parser.Reset()
	Do ##super()
}

}
