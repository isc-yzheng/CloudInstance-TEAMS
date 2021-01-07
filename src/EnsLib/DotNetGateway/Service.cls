/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include %occDotNet

/// A service responsible for starting, monitoring and stopping the .NET Gateway Server in a production.
Class EnsLib.DotNetGateway.Service Extends Ens.BusinessService [ ClassType = "", ProcedureBlock, System = 4 ]
{

/// This adapter does not handle communication with external systems, it's for internal use of this class only.
Parameter ADAPTER = "EnsLib.DotNetGateway.ServiceAdapter";

/// IP address or name of the machine where the .NET Gateway Server executable is located.
Property DotNetServer As %String [ InitialExpression = "127.0.0.1" ];

/// TCP port number for communication between the .NET Gateway Server and the proxy classes in Ensemble.
Property Port As %String [ InitialExpression = "55000" ];

/// Which IP address, among the several IP addresses that the machine has, that allows incoming connections.
/// Specify 0.0.0.0 or null to listen on all IP addresses local to the machine (127.0.0.1, VPN address, etc.).
/// You can also specify a single existing local IP address to restrict the listener to that IP address. 
Property AllowedIPAddresses As %String [ InitialExpression = "0.0.0.0" ];

/// On 64-bit platforms, indicates if the Gateway server is to be executed as 32-bit (default) or 64-bit.
Property Exec64 As %Boolean [ InitialExpression = 0 ];

/// .NET version, used to select the intended directory for the target external executable.
Property DotNetVersion As %String(DISPLAYLIST = ",2.0,4.0,4.5,Core2.1", VALUELIST = ",2.0,4.0,4.5,Core2.1") [ InitialExpression = "4.5" ];

/// Location of the .NET Gateway Server executable.
/// It is used to find the target executable and assemble the command to start the .NET Gateway
/// on a local server. <br>
/// If this setting is not specified, the default directory used is ...\Dev\dotnet\bin\ under 
/// the Ensemble installation directory.
Property FilePath As %String(MAXLEN = 1023);

/// Fully qualified name of a file to log all communication between Ensemble and the .NET Gateway Server.
/// Usually this setting should be left blank, and used only for trouble-shooting.
Property Logfile As %String(MAXLEN = 1023);

/// Number of seconds between each communication with the .NET Gateway Server to check if it is active.
/// The default is 10 seconds.
/// When enabled, the minimum value is 5 seconds and the maximum value is 3600 seconds (1 hour). <br>
/// A value of 0 disables the monitoring feature; in this case, if the Gateway goes down, the status indicator color in the Production Configuration page will not be automatically updated.<br>
/// See also properties <property>HeartbeatFailureTimeout</property>, <property>HeartbeatFailureAction</property>
/// and <property>HeartbeatFailureRetry</property>, which only apply if monitoring is enabled.
Property HeartbeatInterval As %Integer(MAXVAL = 3600, MINVAL = 0) [ InitialExpression = 10 ];

/// Number of seconds without responding to the heartbeat, to consider that the .NET Gateway Server is in failure state.
/// If this value is smaller than property <property>HeartbeatInterval</property>, it will be considered in
/// failure state every time the .NET Gateway communication check fails.
/// The default is 30 seconds. 
/// The maximum value is 86400 seconds (1 day). <br>
/// See also properties <property>HeartbeatInterval</property>, <property>HeartbeatFailureAction</property>
/// and <property>HeartbeatFailureRetry</property>.
Property HeartbeatFailureTimeout As %Integer(MAXVAL = 86400, MINVAL = 0) [ InitialExpression = 30 ];

/// What action(s) to take if the .NET Gateway Server goes into failure state.
/// Setting it to <b>Restart</b> (default) will cause the .NET Gateway to be restarted.
/// Setting it to <b>Alert</b> will generate an alert entry in the Event Log. <br>
/// Note 1: This is independent of the <b>Alert on Error</b> setting. <br>
/// Note 2: If <property>DotNetServer</property> points to a remote system, this feature <b>must not</b>
/// restart the server; only alerts may be generated. <br>
/// See also properties <property>HeartbeatInterval</property>, <property>HeartbeatFailureTimeout</property>
/// and <property>HeartbeatFailureRetry</property>.
Property HeartbeatFailureAction As %String(DISPLAYLIST = ",None,Restart,Alert,Restart and Alert", VALUELIST = ",,R,A,RA") [ InitialExpression = "R", Required ];

/// In case the .NET Gateway Server goes into failure state, and stays in failure state, how much time
/// to wait before retrying the <property>HeartbeatFailureAction</property>.
/// The default value is 300 seconds (5 minutes).
/// A value of 0 disables this retry, meaning that once there is a failure that can't be immediately recovered,
/// there won't be automatic attempts to recovery. <br>
/// See also properties <property>HeartbeatInterval</property>, <property>HeartbeatFailureTimeout</property>
/// and <property>HeartbeatFailureAction</property>.
Property HeartbeatFailureRetry As %Integer(MAXVAL = 86400, MINVAL = 0) [ InitialExpression = 300 ];

Parameter SETTINGS = "DotNetServer:Basic,Port:Basic,AllowedIPAddresses,Exec64,DotNetVersion,FilePath:Basic,Logfile,UsePassphrase,HeartbeatInterval,HeartbeatFailureTimeout,HeartbeatFailureAction,HeartbeatFailureRetry,-ArchiveIO";

/// This timeout should work in most if not all cases.
Parameter PIPEREADTIMEOUT As %Integer = 10;

/// Internal property that contains the pipe device used to start the .NET Gateway server.
Property PipeDevice As %String [ Internal, Private ];

/// Internal property to keep track of the elapsed failure time for the heartbeat feature.
Property HeartbeatFailureStart As %String [ Internal, Private ];

/// Internal property to keep track of the grace time after failure before restoring the heartbeat.
Property HeartbeatGraceStart As %String [ Internal, Private ];

/// Internal property to keep track of the status of Gateway Server.
Property GatewayStatus As %String [ InitialExpression = "OK", Internal, Private ];

/// If Gateway is to be started requiring a passphrase for connection
Property UsePassphrase As %Boolean [ InitialExpression = 0 ];

/// This service does not actually handle input data.
/// The call interval is used as the heartbeat interval if enabled.
Method OnProcessInput(pInput As %RegisteredObject, pOutput As %RegisteredObject) As %Status
{
	Try {
		$$$SetHostMonitor(..%ConfigName,$$$eMonitorStatus,..GatewayStatus)
		If ..HeartbeatGraceStart>0 {
			If ($ZH-..HeartbeatGraceStart)<..HeartbeatFailureRetry Quit  // Within grace period
			// Grace period is over
			Set ..HeartbeatGraceStart = 0
			Set ..HeartbeatFailureStart = 0
		}
		If ..HeartbeatInterval>0 {
			// Heartbeat is enabled
			Set s = ..PingDotNetGateway(..Port, ..DotNetServer)
			If s {
				// Succeeded; update status, reset failure track time
				If ..GatewayStatus'="OK" {
					$$$SetHostMonitor(..%ConfigName,$$$eMonitorStatus,"OK")
					Set ..GatewayStatus = "OK"
				}
				Set ..HeartbeatFailureStart = 0
			}
			Else {
				// Failed; update status, log warning, check failure timeout
				If ..GatewayStatus'="Error" {
					$$$SetHostMonitor(..%ConfigName,$$$eMonitorStatus,"Error")
					Set ..GatewayStatus = "Error"
				}
				$$$LOGWARNING(".NET Gateway Server did not respond to PING request")
				Set t = $ZH
				If '..HeartbeatFailureStart {
					Set ..HeartbeatFailureStart = t
				}
				If (t-..HeartbeatFailureStart)>..HeartbeatFailureTimeout {
					// Handle the .NET Gateway failure
					$$$LOGERROR(".NET Gateway Server failure timeout on "_..DotNetServer_$S(..DotNetServer[":":"|",1:":")_..Port)
					If ..HeartbeatFailureAction["A" {
						$$$LOGALERT(".NET Gateway Server failure timeout on "_..DotNetServer_$S(..DotNetServer[":":"|",1:":")_..Port)
					}
					If ..HeartbeatFailureAction["R" {
						// Stop the gateway just in case, ignoring errors
						Set tSC = ..StopGateway(..Port, ..DotNetServer)
						Set tSC = ..StopDotNet(..PipeDevice)
						// Restart the gateway
						$$$LOGINFO("Restarting the .NET Gateway Server")
						Set tSC = ..StartGateway(..FilePath, ..Port, ..AllowedIPAddresses, ..Logfile, .tDevice, ..DotNetServer, ..Exec64, ..DotNetVersion, ..UsePassphrase)
						If $$$ISERR(tSC) {
							$$$LOGERROR("Failed to restart the .NET Gateway Server")
							$$$LOGSTATUS(tSC)
						}
						Else {
							Set ..PipeDevice = tDevice
							$$$SetHostMonitor(..%ConfigName,$$$eMonitorStatus,"OK")
							$$$LOGINFO(".NET Gateway Server restarted successfully")
							Set ..GatewayStatus = "OK"
							Set ..HeartbeatGraceStart = 0
							Set ..HeartbeatFailureStart = 0
						}
					}
					If (..HeartbeatFailureStart>0) && (..HeartbeatFailureRetry>..HeartbeatInterval) {
						// Will observe grace time ..HeartbeatFailureRetry
						Set ..HeartbeatGraceStart = $ZH
					}
				}
			}
		}
	}
	
	Catch {
	}
	
	Quit $$$OK
}

/// Upon instantiating this service, adjust some properties and start the .NET Gateway Server.
Method OnInit() As %Status
{
	// Adjust adapter's CallInterval based on heartbeat interval
	If ..HeartbeatInterval>0 {
		If ..HeartbeatInterval<5 {
			Set ..HeartbeatInterval = 5 // Minimum value is 5 seconds
			$$$LOGINFO("HeartbeatInterval adjusted to minimum value of 5 seconds")
		}
		Set ..Adapter.CallInterval = ..HeartbeatInterval
	}
	Else {
		Set ..%WaitForNextCallInterval = 0
		Set ..Adapter.CallInterval = 86400
	}
	$$$sysTRACE("Setting CallInterval = "_..Adapter.CallInterval_", %WaitForNextCallInterval = "_..%WaitForNextCallInterval)
	
	Set tSC = ..StartGateway(..FilePath, ..Port, ..AllowedIPAddresses, ..Logfile, .tDevice, ..DotNetServer, ..Exec64, ..DotNetVersion, ..UsePassphrase)
	If $$$ISERR(tSC) {
		$$$SetHostMonitor(..%ConfigName,$$$eMonitorStatus,"Error")
		Set ..GatewayStatus = "Error"
		$$$LOGERROR("Failed to start the .NET Gateway server")
		$$$LOGSTATUS(tSC)
	}
	Else {
		Set ..PipeDevice = tDevice
		$$$SetHostMonitor(..%ConfigName,$$$eMonitorStatus,"OK")
		Set ..GatewayStatus = "OK"
		$$$LOGINFO(".NET Gateway Server started successfully")
	}
	
	Quit tSC
}

/// Shutdown the .NET Gateway Server.
Method OnTearDown() As %Status
{
	$$$LOGINFO("Stopping .NET Gateway")
	Set tSC = ..StopGateway(..Port, ..DotNetServer)
	If $$$ISERR(tSC) {
		$$$LOGERROR("Failed to stop the .NET Gateway Server")
		$$$LOGSTATUS(tSC)
		$$$SetHostMonitor(..%ConfigName,$$$eMonitorStatus,"Error")
	}
	Set tSC = ..StopDotNet(..PipeDevice)
	Quit $$$OK
}

/// This Internal method has been deprecated for %Net.Remote.Utility::CheckLocalPortFree
/// Check if the TCP port is available.  For remote servers the check is just syntatical, and the port is CLOSEd. 
/// For a local server the additional verifications are done: First we check if a client connection *cannot* 
/// be established, meaning there is no TCP server listening and the port is okay for the gateway to use. 
/// Second, we check if the port is available to initiate a server side connection.
ClassMethod CheckTCP(pPort As %String, pAddress As %String = "127.0.0.1") As %Status [ Deprecated, Internal ]
{
	Set tSC = $$$OK
	
	Try {
		Set pPort = $G(pPort)
		If 'pPort Set tSC = $$$ERROR($$$EnsErrGeneral, "Invalid or missing port '"_pPort_"'") Quit
		Set pPort = +pPort
		Set tDev = "|TCP|"_pPort
		Close tDev
		If (pAddress="127.0.0.1") || ($ZCVT(pAddress,"l")="localhost") || ($ZCVT(pAddress,"l")=$ZCVT($ZU(110),"l")) {
			// Try to open the TCP device as a server to check if it is available to be used
			Open tDev:(:pPort:"S"):1
			Close tDev
			If '$T Set tSC = $$$ERROR($$$EnsErrGeneral, "TCP port "_pPort_" already in use") Quit
		}
	}
	Catch {
		Set tSC = $$$SystemError
	}

	Quit tSC
}

/// Start up the .NET Gateway Server.
ClassMethod StartGateway(pFilePath As %String, pPort As %String, pAllowedIPAddresses As %String, pLogfile As %String = "", ByRef pDevice As %String = "", pServer As %String = "127.0.0.1", pExec64 As %Boolean = 0, pVersion As %String = "2.0", pUsePassphrase As %Boolean = 0) As %Status
{
	Set tSC = $$$OK
	If $G(pAllowedIPAddresses)="" Set pAllowedIPAddresses = "0.0.0.0"
	
	Try {
		// Check if TCP port is good to use
		#dim tIsFree =##class(%Net.Remote.Utility).CheckLocalPortFree(pServer,pPort,pAllowedIPAddresses)
		If tIsFree {
			// Start the .NET Gateway server, only if it's local
			If (pServer="127.0.0.1") || ($ZCVT(pServer,"l")="localhost") || ($ZCVT(pServer,"l")=$ZCVT($ZU(110),"l")) {
				$$$LOGINFO("Starting .NET Gateway with: FilePath="_pFilePath_", Port="_pPort_", AllowedIPAddresses="_pAllowedIPAddresses_", Logfile="_pLogfile_", 64-bit="_$S(pExec64:"Yes",1:"No")_", Version="_pVersion)
				#dim tPassphraseList As %List = ""
				Set tSC = ..RunDotNet(pFilePath, pPort, pAllowedIPAddresses, pLogfile, .pDevice, pExec64, pVersion, pUsePassphrase, .tPassphraseList)
				If $$$ISOK(tSC) {
					Do ##class(%Net.Remote.Gateway).%RegisterSuperServer(+$G(pPort), $Namespace, tPassphraseList)
				} Else {
					#; If the error does not mention already in use then call stop in case did start
					If ($system.Status.GetErrorText(tSC)'["already in use") {
						Try {Do ..StopGateway(pPort, pServer)} Catch {}
					}
				}
			}
			Else {
				$$$LOGINFO(".NET Server not local to the Ensemble server, won't be started by this service")
			}
		} Else {
			Set tSC = $$$ERROR($$$EnsErrGeneral, "TCP port "_pPort_" already in use on interface "_pAllowedIPAddresses)
		}
	}
	
	Catch {
		Set tSC = $$$EnsSystemError
	}

	Quit tSC
}

/// Connect to a running .NET Gateway Server.
ClassMethod ConnectGateway(pEndpoint As %String, ByRef pGateway As %Net.Remote.Gateway, pTimeout As %Numeric = 5, pAdditionalPaths As %String = "") As %Status
{
	Set tSC = $$$OK
	
	Try {
		// Create a gateway instance
		Set pGateway = ##class(%Net.Remote.Gateway).%New()
		If '$IsObject(pGateway) Set tSC = %objlasterror Quit
		
		Set tHost = $P(pEndpoint,";",1)
		Set tPort = +$P(pEndpoint,";",2)
		Set tNS = $P(pEndpoint,";",3)
		
		// Appropriate defaults
		If tHost = "" Set tHost = "127.0.0.1"
		If tNS = "" Set tNS = $namespace
		
		// Check port
		If ('tPort) || (tPort'?.N) Set tSC = $$$ERROR($$$EnsErrGeneral, "Invalid or missing port '"_tPort_"'") Quit
		
		$$$sysTRACE($classname()_" invoking %Connect with DotNetServer='"_tHost_"', Port='"_tPort_"', tNamespace='"_tNS_"', Timeout="_pTimeout_", AdditionalPaths="_pAdditionalPaths)
		
		// Convert pAdditionalPaths to %ListOfDataTypes if not null
		If pAdditionalPaths="" {
			Set tPath = ""
		}
		Else {
			Set tPath=##class(%ListOfDataTypes).%New()
			For i = 1:1:$L(pAdditionalPaths,",") {
				Do tPath.Insert($P(pAdditionalPaths,",",i))
			}
		}
		
		// And connect
		Set tSC = pGateway.%Connect(tHost, tPort, tNS, pTimeout, tPath,,,0)
		If 'tSC $$$sysTRACE("Error in %Connect: "_$system.Status.GetOneErrorText(tSC))
	}
	
	Catch {
		Set tSC = $$$EnsSystemError
	}
	
	If $$$ISERR(tSC) && $IsObject(pGateway) {
		Do pGateway.%Disconnect()
		Kill pGateway
	}

	Quit tSC
}

/// Shutdown the Gateway.
ClassMethod StopGateway(pPort As %String, pServer As %String = "127.0.0.1", pTimeout As %Numeric = 5) As %Status
{
	Set tSC = $$$OK
	
	Try {
		If (pServer="127.0.0.1") || ($ZCVT(pServer,"l")="localhost") || ($ZCVT(pServer,"l")=$ZCVT($ZU(110),"l")) {
			If $G(pPort) Close "|TCP|"_+pPort
			Set tGateway = $$$NULLOREF
			Set tSC = ..ConnectGateway(pServer_";"_pPort_";"_$namespace, .tGateway, pTimeout)
			If '$$$ISERR(tSC) {
				$$$sysTRACE("Invoking %Shutdown")
				Set tSC = tGateway.%Shutdown()
				$$$sysTRACE("%Shutdown returned "_$system.Status.GetOneErrorText(tSC))
			}
		}
		Else {
			$$$LOGINFO(".NET Server not local to the Ensemble server, won't be shutdown or stopped by this service")
		}
	}
	
	Catch {
		Set tSC = $$$EnsSystemError
	}
	
	Do ##class(%Net.Remote.Gateway).%DeregisterSuperServer(+pPort, $Namespace)

	Quit tSC
}

/// "Ping" the .NET Gateway Server to check if it's alive.
ClassMethod PingDotNetGateway(pPort As %String, pServer As %String = "127.0.0.1") As %Status
{
	If $G(pPort)="" Quit $$$ERROR($$$EnsErrGeneral, "The .NET Gateway port must be specified")

	Set tSC = $$$OK

	Try {
		$$$sysTRACE(".NET Gateway PING: Invoking ##class(%Net.Remote.Gateway).%Ping("_pServer_", "_pPort_", 4)")
		Set tSC = ##class(%Net.Remote.Gateway).%Ping(pServer, pPort, 4)
		If tSC {
			$$$sysTRACE(".NET Gateway PING successful")
		}
		Else {
			$$$sysTRACE("Error in .NET Gateway PING: "_$system.Status.GetOneStatusText(tSC))
		}
	}
	Catch {
		Set tSC = $$$SystemError
	}
	Quit tSC
}

/// Assemble the command to start the .NET Gateway Server based on the settings, and execute the command.
ClassMethod RunDotNet(pFilePath As %String = "", pPort As %String = "", pAllowedIPAddresses As %String = "0.0.0.0", pLogfile As %String = "", ByRef pDevice As %String = "", pExec64 As %Boolean = 0, pVersion As %String = "2.0", pUsePassphrase As %Boolean = 0, ByRef pPassphraseList As %String = "") As %Status
{
	#dim tSC = $$$OK
	Set pDevice = ""

	Try {
		// build gateway server definition
		Set gwyDefn = ##class(%Net.Remote.ObjectGateway).%New()
		Set gwyDefn.FilePath = pFilePath
		Set gwyDefn.Exec64 = pExec64
		Set gwyDefn.DotNetVersion = pVersion
		Set gwyDefn.Port = +pPort
		Set gwyDefn.AllowedIPAddresses = pAllowedIPAddresses
		Set gwyDefn.LogFile = pLogfile
		Set gwyDefn.UsePassphrase = pUsePassphrase
		
		// build OS command for starting gateway server
		Set tSC = ##class(%Net.Remote.Service).CmdLineForDotNet(gwyDefn,.cmd,.cmdArgs,.predictedCmdStr)
		If $$$ISERR(tSC) {
			Set tSC = $$$EnsSystemError
			Quit
		}
		Set pPassphraseList = gwyDefn.passphraseList
		
		// replace passphrase in predicted command string
		Set indexOfPassphraseInStr = $Length($Get(predictedCmdStr))-$Length($listget(gwyDefn.passphraseList,2))-2
		Set:pUsePassphrase predictedCmdStr = $Extract($Get(predictedCmdStr),1,indexOfPassphraseInStr)_
					$Replace($Get(predictedCmdStr),$Listget(gwyDefn.passphraseList,2),"*Passphrase Required*",
								indexOfPassphraseInStr,1)
		$$$LOGINFO("Executing via CPIPE: "_$Get(predictedCmdStr))

		// start the gateway server
		Set tSC = ..RunCommandViaCPIPE(cmd,,.tOutput,..#PIPEREADTIMEOUT,,.cmdArgs)
		
		// Log output returned
		$$$LOGINFO("Execution returned: "_tOutput)
		/*
			If error returned then the service will stop but there is the
			possibility that the gateway process was actually started.
			This will require the user to stop the gateway process using the OS.
			This is different from the SMP Gateway management which
			lets the user decide if actually started but that is direct control
			and is not using an intermediary service.
		*/
		Set tSC = ..checkOutputForListening(tOutput)

	}
	Catch {
		Set tSC = $$$EnsSystemError
	}

	Quit tSC
}

/// Close the CPIPE device.
ClassMethod StopDotNet(ByRef pDevice As %String) As %Status [ Internal ]
{
	Quit $$$OK
}

/// Execute OS command asynchronously.
ClassMethod RunCommandViaCPIPE(pCmd As %String, Output pDevice, Output pOutput, pTimeout As %Numeric = 10, Output pRetCode As %String, ByRef pCmdArgs) As %Status
{
	Set pDevice = ""
	Set pOutput = ""
	Set pRetCode = ""

	Set tSC = ##class(%Net.Remote.Utility).RunCommandViaCPIPE(pCmd,.pDevice,.pOutput,pTimeout,1,.pCmdArgs)
	Close pDevice:"I"
	If $$$ISERR(tSC) { // convert from Cache error status to Ensemble error status
		Set errorText = $system.Status.GetErrorText(tSC)
		If (errorText["Failed to open temporary file") {
			Set tSC = $$$ERROR($$$EnsErrGeneral,errorText)
		} Else {
			Set tSC = $$$SystemError
		}
	}
	Quit tSC
}

/// Internal method to determine from Gateway output text if gateway started <br>
/// Successful start of the gateway indicated by a line in the output
/// starting with "Listening on" and no more output lines.
/// (taken from DotNetGatewaySS:Main) <br>
/// If more than one line in the output a warning will be logged.
/// Controlled by parameter pLogWarning with default of true.<br>
ClassMethod checkOutputForListening(pOutput As %String, pLogWarning As %Boolean = 1) [ Internal ]
{
	#dim tSC As %Status = $$$OK

	#dim listeningOnLineNumber = 0
	#dim lineSeparator = $Char(10) // covers $c(13,10) as well 
	#dim numberOfOutputLines = $Length(pOutput,lineSeparator)
	If ($Extract(pOutput,*) = lineSeparator) Set numberOfOutputLines = (numberOfOutputLines - 1)
	#dim outputLine
	#dim lineNumber

	For lineNumber=1:1:numberOfOutputLines{

		Set outputLine = $Piece(pOutput,lineSeparator,lineNumber)
		If $$$DotNetOutputLineIndicatesListening(outputLine) {
			Set listeningOnLineNumber = lineNumber
			Quit
		}

	}

	If pLogWarning && (numberOfOutputLines>1) $$$LOGWARNING("Unexpected contents returned from the .NET Gateway, please check")

	#; Will be an error if output and no "Listening on" or lines after the "Listening on"
	#dim txt = $Piece(pOutput,lineSeparator,(listeningOnLineNumber+1),$Length(pOutput,lineSeparator))
	If txt'="" Set tSC = $$$ERROR($$$EnsErrGeneral, txt)

	Return tSC
}

}
