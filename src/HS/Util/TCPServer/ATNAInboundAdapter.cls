/// Adapter that sends out a counted block of bytes over a TCP connection but receives no response block
Class HS.Util.TCPServer.ATNAInboundAdapter Extends EnsLib.TCP.InboundAdapter [ ClassType = "", Inheritance = right, ProcedureBlock, System = 4 ]
{

Parameter SERVICEINPUTCLASS = "Ens.StringContainer";

Parameter SERVICEOUTPUTCLASS = "Ens.StringContainer";

Method OnConnected() As %Status
{
	Set tQuitErr=1
	Try {
		Set tSC=..ReadMessage(.tInStr,..CallInterval,1)
		If $$$ISERR(tSC) {
			If ..IsReadError(tSC) {
				Set tSC=$$$ERROR($$$EnsErrInConnectionLost,"TCP Read Message",..IOAddr,$$$StatusDisplayString(tSC))
				Set tQuitErr=0  Do ..Disconnect()
				If ""=tInStr Set tTxt=$$$StatusText(tSC), tSC=$$$OK  If ..StayConnected<0 { $$$LOGWARNING(tTxt) } ElseIf ..%logConnections { $$$LOGINFO(tTxt) } Else { $$$sysTRACE(tTxt) } ; change error to info if lost connection with no data and trying to stay connected
			} ElseIf $$$StatusEquals(tSC,$$$EnsErrTCPTerminatedReadTimeoutExpired) {
				If ""=tInStr { Set tSC=$$$OK } ; no error if timed out with no data
				Else { Set tQuitErr=0 }
			}
			Quit
		}
		$$$ANEWINIOLOGENTRY($$$OK,"TCP ReadMessage on :"_..IOAddr,tInStr)
		#; no return is expected
		Set tAddress=..IOAddr
		If tAddress["<-" Set tAddress=$P(tAddress,"<-",2)
		Set ps=$S(tAddress["|":"|",1:":"), tAddress=$P(tAddress,ps,1)
		Set tSC=..BusinessHost.ProcessInput(##class(HS.Message.IHE.ATNA.InboundSubmission).%New(tInStr,tAddress), .tStringOut)  Quit:$$$ISERR(tSC)
		If $$$ISERR(tSC) {
			$$$ACLOSEIOLOGENTRY(tSC,"after TCP ReadMessage ProcessInput error on :"_..IOAddr,"")
			Quit
		}
		$$$ACLOSEIOLOGENTRY(tSC,"after TCP ProcessInput on :"_..IOAddr,"")
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	#; Returning error status would cause this listener job to terminate
	If $$$ISERR(tSC) {
		#; Never quit the listener, but drop the connection on unrecognized error
		If tQuitErr&&..Connected&&..StayConnected { $$$LOGERROR("Disconnecting due to "_$$$StatusDisplayString(tSC)) Set tSC=$$$OK  Do ..Disconnect() }
		If $$$ISERR(tSC) $$$LOGSTATUS(tSC)
	}
	Quit $$$OK
}

Method ReadMessage(Output pLine As %String = "", pTimeout As %Numeric = {..ReadTimeout}, pInbound As %Boolean = 0) As %Status
{
	Set tSC=$$$OK
	Try {
		Set tLen=""
		If -1=pTimeout { 
			For  {
				Set tTimedOut = 0
				Read *tChar
				Quit:tChar=32
				Set tLen=tLen_$c(tChar)
			}
		} Else { 
			For {
				Read *tChar:pTimeout  Set tTimedOut = '$Test Quit:tTimedOut
				Quit:tChar=32
				Set tLen=tLen_$c(tChar)
			}
		}
		Set tZB=$ZB
		Set $ZT=""
		If tTimedOut {
			Set tSC= $$$ERROR($$$EnsErrTCPReadBlockSizeTimeoutExpired,pTimeout,"GettingSize") Quit
		}
		If -1=pTimeout {
			Read tInStr#tLen
		} Else {
			Read tInStr#tLen:pTimeout
		}
		If tTimedOut {
			Set tSC= $$$ERROR($$$EnsErrTCPTerminatedReadTimeoutExpired,pTimeout,tLen) Quit
		}
		
		Set pLine = tLen_$c(32)_tInStr
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
