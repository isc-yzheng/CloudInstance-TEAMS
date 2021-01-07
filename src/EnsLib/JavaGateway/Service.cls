/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Include %occJava

/// A service responsible for starting, monitoring and stopping the Java Gateway Server in a production.
Class EnsLib.JavaGateway.Service Extends Ens.BusinessService [ ClassType = "", ProcedureBlock, System = 4 ]
{

/// This adapter does not handle communication with external systems, it's for internal use of this class only.
Parameter ADAPTER = "EnsLib.JavaGateway.ServiceAdapter";

/// IP address or name of the machine where the JVM to be used by the Java Gateway Server is located.
Property Address As %String [ InitialExpression = "127.0.0.1" ];

/// TCP port number for communication between the Java Gateway Server and the proxy classes in InterSystems IRIS.
Property Port As %String [ InitialExpression = "55555" ];

/// Location of the JVM (similar to JAVA_HOME environment variable).  It is used to find the target JVM and assemble the 
/// command to start the Java Gateway. <br>
/// Note: If there is a default JVM on the machine that is usable without the need to specify its location,
/// this setting may be left blank.
Property JavaHome As %String(MAXLEN = 1023);

/// DEPRECATED : We now check the version of the java executable before starting the gateway.
/// There is no need fo the user to tell which version of the JARs to use anymore.
/// Version of JDK used to select the intended version of the InterSystems .jar files.
/// It is used to assemble the command to start the Java Gateway.
Property JDKVersion As %String(DISPLAYLIST = ",Java 1.7,Java 1.8", VALUELIST = ",JDK17,JDK18") [ Deprecated, InitialExpression = "JDK18" ];

/// CLASSPATH containing the files required to be passed as an argument when starting the JVM.
/// The user should typically provide here the files containing the classes used via the Java Gateway. 
/// We assume that the user has properly quoted the classpath and supplied the correct separators for the platform
/// in case of multiple files. <br>
/// Note that additional classpath can be specified in business operations derived from <class>EnsLib.JavaGateway.AbstractOperation</class>.
/// See property AdditionalPaths in that class.
Property ClassPath As %String(MAXLEN = 32000);

/// Fully qualified name of a file to log all communication between the InterSystems IRIS server and the Java Gateway.
/// Usually this setting should be left blank, and used only for trouble-shooting.
Property Logfile As %String(MAXLEN = 1023);

/// Number of seconds between each communication with the Java Gateway Server to check if it is active.
/// The default is 10 seconds.
/// When enabled, the minimum value is 5 seconds and the maximum value is 3600 seconds (1 hour). <br>
/// A value of 0 disables the monitoring feature; in this case, if the Gateway goes down, the status indicator color in the Production Configuration page will not be automatically updated.<br>
/// See also properties <property>HeartbeatFailureTimeout</property>, <property>HeartbeatFailureAction</property>
/// and <property>HeartbeatFailureRetry</property>, which only apply if monitoring is enabled.
Property HeartbeatInterval As %Integer(MAXVAL = 3600, MINVAL = 0) [ InitialExpression = 10 ];

/// Number of seconds without responding to the heartbeat, to consider that the Java Gateway Server is in failure state.
/// If this value is smaller than property <property>HeartbeatInterval</property>, it will be considered in
/// failure state every time the Java Gateway communication check fails.
/// The default is 30 seconds. 
/// The maximum value is 86400 seconds (1 day). <br>
/// See also properties <property>HeartbeatInterval</property>, <property>HeartbeatFailureAction</property>
/// and <property>HeartbeatFailureRetry</property>.
Property HeartbeatFailureTimeout As %Integer(MAXVAL = 86400, MINVAL = 0) [ InitialExpression = 30 ];

/// What action(s) to take if the Java Gateway Server goes into failure state.
/// Setting it to <b>Restart</b> (default) will cause the Java Gateway to be restarted.
/// Setting it to <b>Alert</b> will generate an alert entry in the Event Log. <br>
/// Note 1: This is independent of the <b>Alert on Error</b> setting. <br>
/// Note 2: If <property>Address</property> points to a remote system, this feature <b>must not</b>
/// restart the server; only alerts may be generated. <br>
/// See also properties <property>HeartbeatInterval</property>, <property>HeartbeatFailureTimeout</property>
/// and <property>HeartbeatFailureRetry</property>.
Property HeartbeatFailureAction As %String(DISPLAYLIST = ",None,Restart,Alert,Restart and Alert", VALUELIST = ",N,R,A,RA") [ InitialExpression = "R", Required ];

/// In case the Java Gateway Server goes into failure state, and stays in failure state, how much time
/// to wait before retrying the <property>HeartbeatFailureAction</property>.
/// The default value is 300 seconds (5 minutes).
/// A value of 0 disables this retry, meaning that once there is a failure that can't be immediately recovered,
/// there won't be automatic attempts to recovery. <br>
/// See also properties <property>HeartbeatInterval</property>, <property>HeartbeatFailureTimeout</property>
/// and <property>HeartbeatFailureAction</property>.
Property HeartbeatFailureRetry As %Integer(MAXVAL = 86400, MINVAL = 0) [ InitialExpression = 300 ];

/// Optional arguments to be passed to the Java Virtual Machine (JVM) to include when assembling the 
/// command to start the Java Gateway. <br>
/// For example, you can specify system properties: <b>Dsystemvar=value</b> <br>
/// or set the maximum heap size: <b>Xmx256m</b> <br>
/// and so on, as needed.
Property JVMArgs As %String(MAXLEN = 32000);

/// If set to <b>True</b>, enables Java debugging via TCP, allowing a Java debugger (such as Eclipse or Jswat) to attach. 
/// The default is <b>False</b>. <br>
/// The following arguments can be set: <property>JavaDebug</property>, <property>JavaDebugSuspend</property>
/// and <parameter>JAVADEBUG</parameter>.
Property JavaDebug As %Boolean [ InitialExpression = "0" ];

/// Specifies the port to listen on if <property>JavaDebug</property> is <b>True</b>.  The default is 8000.
Property JavaDebugPort As %String [ InitialExpression = "8000" ];

/// If <property>JavaDebug</property> is <b>True</b>, this setting indicates whether the JVM is suspended
/// on start in order to wait for the debugger to attach. 
/// The default is <b>No</b>.
Property JavaDebugSuspend As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",y,n") [ InitialExpression = "n" ];

/// Java debugging parameters, used if <property>JavaDebug</property> is <b>True</b>: <br>
/// (see http://java.sun.com/j2se/1.3/docs/guide/jpda/conninv.html#Xrunjdwp)
/// <ul>
/// <li> -Xdebug : Enable debugging </li>
/// <li> -Xnoagent : Disables oldjdb support </li>
/// <li> -Djava.compiler=NONE : Disable JIT compiler </li>
/// <li> -Xrunjdwp : JDWP Options
///      <ul>
///      <li> transport=dt_socket, (Use TCP/IP) </li>
///      <li> address=8000, (Listen on port 8000) </li>
///      <li> suspend=y, (Suspend the Java process until the debugger connects) </li>
///      <li> server=y (Listen for incoming debugger connection) </li> </ul> </ul>
Parameter JAVADEBUG As %String = "-Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=${JavaDebugPort},suspend=${JavaDebugSuspend},server=y";

Parameter SETTINGS = "Address:Basic,Port:Basic,HeartbeatInterval,HeartbeatFailureTimeout,HeartbeatFailureAction,HeartbeatFailureRetry,JavaHome,ClassPath,JVMArgs,Logfile,UsePassphrase,JavaDebug,JavaDebugPort,JavaDebugSuspend,-ArchiveIO";

/// List of default JARs needed by the Java Gateway server including when used by the InterSystems IRIS JDBC Adapter.
/// Note that the needed files vary with the InterSystems IRIS version.
Parameter JAVAGATEWAYJARS As COSEXPRESSION = "$$$javaGatewayJAR_"",""_$$$javaJDBCJAR";

/// This timeout should work in most if not all cases.
Parameter PIPEREADTIMEOUT As %Integer = 10;

/// Internal property that contains the pipe device used to start the Java Gateway server.
Property PipeDevice As %String(MAXLEN = 1023) [ Internal, Private ];

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
			Set tSC = ..PingJavaGateway(..Port, ..Address)
			If $$$ISOK(tSC) {
				// Succeeded; update status and reset failure tracking base timestamp
				If ..GatewayStatus'="OK" {
					$$$SetHostMonitor(..%ConfigName,$$$eMonitorStatus,"OK")
					Set ..GatewayStatus = "OK"
				}
				Set ..HeartbeatFailureStart = 0
			} Else {
				// Failed; update status, log warning, check failure timeout
				If ..GatewayStatus'="Error" {
					$$$SetHostMonitor(..%ConfigName,$$$eMonitorStatus,"Error")
					Set ..GatewayStatus = "Error"
				}
				$$$LOGWARNING("Java Gateway server did not respond to PING request: "_$$$StatusDisplayString(tSC))
				Set t = $ZH
				If '..HeartbeatFailureStart {
					Set ..HeartbeatFailureStart = t
				}
				If (t-..HeartbeatFailureStart)>..HeartbeatFailureTimeout {
					// Handle the Java Gateway failure
					$$$LOGERROR("Java Gateway Server failure timeout on "_..Address_$S(..Address[":":"|",1:":")_..Port)
					If ..HeartbeatFailureAction["A" {
						Do ..SendAlert(##class(Ens.AlertRequest).%New($LB(..%ConfigName,"Java Gateway Server failure timeout on "_..Address_$S(..Address[":":"|",1:":")_..Port)))
					}
					If ..HeartbeatFailureAction["R" {
						$$$LOGINFO("Restarting the Java Gateway Server")
						// Stop the gateway just in case, collecting errors
						Set tSC = ..StopGateway(..Port, ..Address)
						Set tSC1 = ..StopJava(..PipeDevice)  Set:$$$ISERR(tSC1) tSC1=$$$ADDSC(tSC,tSC1)
						// Restart the gateway
						Set tSC = ..StartGateway(..JavaHome, ..ClassPath, ..JVMArgs, ..Port, ..Logfile, ..JavaDebug, .tDevice, ..Address, ..JavaDebugPort, ..JavaDebugSuspend, ..UsePassphrase)
						If $$$ISERR(tSC) {
							Set tSC=$$$ADDSC(tSC,tSC1)
							$$$LOGERROR("Failed to restart the Java Gateway Server: "_$$$StatusDisplayString(tSC))
						} Else {
							If $$$ISERR(tSC1) {
								$$$LOGWARNING("Error stopping Java Gateway Server before restart: "_$$$StatusDisplayString(tSC1))
							}
							Set ..PipeDevice = tDevice
							$$$SetHostMonitor(..%ConfigName,$$$eMonitorStatus,"OK")
							$$$LOGINFO("Java Gateway Server restarted successfully")
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
		Set ..%WaitForNextCallInterval=1 ; Adapter will set this anyway but this prevents BS from doing extraneous trace logging
	}
	Catch {
		Set tSC = $$$EnsSystemError ; log it
	}
	Quit $$$OK
}

/// Upon instantiating this service, adjust some properties and start the Java Gateway Server.
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
		Set ..Adapter.CallInterval = 10 // default 10 seconds if not checking heartbeat
	}
	$$$sysTRACE("Setting CallInterval = "_..Adapter.CallInterval)

	Set tSC = ..StartGateway(..JavaHome, ..ClassPath, ..JVMArgs, ..Port, ..Logfile, ..JavaDebug, .tDevice, ..Address, ..JavaDebugPort, ..JavaDebugSuspend, ..UsePassphrase)
	If $$$ISERR(tSC) {
		$$$SetHostMonitor(..%ConfigName,$$$eMonitorStatus,"Error")
		Set ..GatewayStatus = "Error"
		$$$LOGERROR("Failed to start the Java Gateway server: "_$$$StatusDisplayString(tSC))
	}
	Else {
		$$$SetHostMonitor(..%ConfigName,$$$eMonitorStatus,"OK")
		Set ..GatewayStatus = "OK"
		Set ..PipeDevice = tDevice
		$$$LOGINFO("Java Gateway Server started successfully")
	}
	Quit tSC
}

/// Shutdown the Java Gateway Server.
Method OnTearDown() As %Status
{
	$$$LOGINFO("Stopping Java Gateway")
	Set tSC = ..StopGateway(..Port, ..Address)
	If $$$ISERR(tSC) {
		$$$LOGERROR("Failed to stop the Java Gateway Server: "_$$$StatusDisplayString(tSC))
		$$$SetHostMonitor(..%ConfigName,$$$eMonitorStatus,"Error")
	}
	Set tSC = ..StopJava(..PipeDevice)
	Quit $$$OK
}

/// Check if the TCP port is available.  For remote servers the check is just syntatical, and the port is CLOSEd. 
/// For a local server the additional verifications are done: First we check if a client connection *cannot* 
/// be established, meaning there is no TCP server listening and the port is okay for the gateway to use. 
/// Second, we check if the port is available to initiate a server side connection.
ClassMethod CheckTCP(pPort As %String, pAddress As %String = "127.0.0.1") As %Status [ Internal ]
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
			Open tDev:(:pPort:"S":/BINDTO="127.0.0.1"):1
			Close tDev
			If '$T Set tSC = $$$ERROR($$$EnsErrGeneral, "TCP port "_pPort_" already in use") Quit
		}
	}
	Catch {
		Set tSC = $$$SystemError
	}

	Quit tSC
}

/// Start up the Java Gateway Server.
ClassMethod StartGateway(pJavaHome As %String, pClassPath As %String, pJVMArgs As %String, pPort As %String, pLogfile As %String = "", pDebug As %Boolean = 0, ByRef pDevice As %String = "", pAddress As %String = "127.0.0.1", pDebugPort As %String = "", pDebugSuspend As %String = "", pUsePassphrase As %Boolean = 0) As %Status
{
	Set tSC = $$$OK

	Try {
		// Check if TCP port is good to use
		Set tSC = ..CheckTCP($G(pPort), pAddress)

		If $$$ISOK(tSC) {
			// Start the Java Gateway server, only if it's local
			If (pAddress="127.0.0.1") || ($ZCVT(pAddress,"l")="localhost") || ($ZCVT(pAddress,"l")=$ZCVT($ZU(110),"l")) {
				$$$LOGINFO("Starting Java Gateway with: Port="_pPort_", JavaHome="_pJavaHome_", ClassPath="_pClassPath_", JVMArgs="_pJVMArgs_", LogFile="_pLogfile_", JavaDebug="_$S(pDebug:"y, JavaDebugPort="_pDebugPort_", JavaDebugSuspend="_pDebugSuspend,1:"n"))
				#dim tPassphraseList As %List = ""
				Set tSC = ..RunJava(pJavaHome, pClassPath, pJVMArgs, pDebug,  pPort, pLogfile, .pDevice, pDebugPort, pDebugSuspend, pUsePassphrase, .tPassphraseList)
				If $$$ISOK(tSC) {
					Do ##class(%Net.Remote.Gateway).%RegisterSuperServer(+$G(pPort), $Namespace, tPassphraseList)
				}
			}
			Else {
				$$$LOGINFO("Java Server not local to the InterSystems IRIS server, won't be started by this service")
			}
		}
	}

	Catch {
		Set tSC = $$$EnsSystemError ; log it
	}

	Quit tSC
}

/// Connect to a running Java Gateway Server.
ClassMethod ConnectGateway(pEndpoint As %String, ByRef pGateway As EnsLib.JavaGateway.JavaGateway, pDebug As %Boolean = 0, pTimeout As %Numeric = 5, pAdditionalPaths As %String = "") As %Status
{
	Set tSC = $$$OK

	Try {
		// Create a gateway instance
		Set pGateway = ##class(EnsLib.JavaGateway.JavaGateway).%New()
		If '$IsObject(pGateway) Set tSC = %objlasterror Quit

		Set tHost = $P(pEndpoint,";",1)
		Set tPort = +$P(pEndpoint,";",2)
		Set tNS = $P(pEndpoint,";",3)

		// Appropriate defaults
		If tHost = "" Set tHost = "127.0.0.1"
		If tNS = "" Set tNS = $namespace

		// Check port
		If 'tPort || (tPort'?.N) Set tSC = $$$ERROR($$$EnsErrGeneral, "Invalid or missing port '"_tPort_"'") Quit

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
		$$$sysTRACE($classname()_" invoking %Connect with Address='"_tHost_"', Port='"_tPort_"', Namespace='"_tNS_"', Timeout="_pTimeout_", AdditionalPaths="_pAdditionalPaths)
		Set tSC = pGateway.%Connect(tHost, tPort, tNS, $S(pDebug:120,1:pTimeout), tPath,,,0)
		If 'tSC $$$sysTRACE("Error in %Connect: "_$$$StatusDisplayString(tSC))
	}
	Catch {
		Set tSC = $$$EnsSystemError ; log it
	}
	If $$$ISERR(tSC) && $IsObject(pGateway) {
		Do pGateway.%Disconnect()
		Kill pGateway
	}
	Quit tSC
}

/// Shutdown the Gateway.
ClassMethod StopGateway(pPort As %String, pAddress As %String = "127.0.0.1", pTimeout As %Numeric = 5) As %Status
{
	Set tSC = $$$OK

	Try {
		If (pAddress="127.0.0.1") || ($ZCVT(pAddress,"l")="localhost") || ($ZCVT(pAddress,"l")=$ZCVT($ZU(110),"l")) {
			If $G(pPort) Close "|TCP|"_+pPort
			Set tGateway = $$$NULLOREF
			Set tSC = ..ConnectGateway(pAddress_";"_pPort_";"_$namespace, .tGateway, 0, pTimeout)
			If $$$ISOK(tSC) {
				$$$sysTRACE("Invoking %Shutdown")
				Set tSC = tGateway.%Shutdown()
				$$$sysTRACE("%Shutdown returned status: "_$$$StatusDisplayString(tSC))
			}
		}
		Else {
			$$$LOGINFO("The Java Gateway Server is not local to the InterSystems IRIS server so it won't be shut down or stopped by this service")
		}
	}
	Catch {
		Set tSC = $$$SystemError
	}

	Do ##class(%Net.Remote.Gateway).%DeregisterSuperServer(+pPort, $Namespace)

	Quit tSC
}

/// "Ping" the Java Gateway server to check if it's alive.
ClassMethod PingJavaGateway(pPort As %String, pAddress As %String = "127.0.0.1") As %Status
{
	If $G(pPort)="" Quit $$$ERROR($$$EnsErrGeneral, "The Java Gateway port must be specified")

	Set tSC = $$$OK
	Try {
		$$$catTRACE("connwait","JG PING: Invoking ##class(%Net.Remote.Gateway).%Ping("_pAddress_", "_pPort_", 4)")
		Set tSC = ##class(%Net.Remote.Gateway).%Ping(pAddress, pPort, 4)
	}
	Catch {
		Set tSC = $$$SystemError
	}
	If $$$ISOK(tSC) {
		$$$catTRACE("connwait","Java Gateway PING successful")
	}
	Else {
		$$$sysTRACE("Error in Java Gateway PING: "_$$$StatusDisplayString(tSC))
	}
	Quit tSC
}

/// Assemble the command to start the Java Gateway Server based on the settings, and execute the command.
ClassMethod RunJava(pJavaHome As %String = "", pClassPath As %String = "", pJVMArgs As %String = "", pDebug As %Boolean = 0, pPort As %String = "", pLogfile As %String = "", ByRef pDevice As %String, pDebugPort As %String = "", pDebugSuspend As %String = "", pUsePassphrase As %Boolean = 0, ByRef pPassphraseList As %String = "") As %Status
{
	Set tSC = $$$OK
	Set pDevice = ""

	Try {
		// build gateway server definition
		Set gwyDefn = ##class(%Net.Remote.ObjectGateway).%New()
		Set gwyDefn.JavaHome = pJavaHome
		Set gwyDefn.Type = 1 // Java
		Set gwyDefn.MainClassName = $$$javaGatewayClass
		Set gwyDefn.ClassPath = pClassPath
		Set gwyDefn.Port = pPort
		Set gwyDefn.LogFile = pLogfile
		Set gwyDefn.UsePassphrase = pUsePassphrase
		Set gwyDefn.JVMArgs = pJVMArgs
		If pDebug {
			Set debugParams = ..JavaDebugParams(pDebugPort, pDebugSuspend)
			If (gwyDefn.JVMArgs="") {
				Set gwyDefn.JVMArgs = debugParams
			} Else {
				Set gwyDefn.JVMArgs = gwyDefn.JVMArgs_" "_debugParams
			}
		}
		
		// build OS command for starting gateway server
		Set tSC = ##class(%Net.Remote.Service).CmdLineForJava(gwyDefn,.cmd,.cmdArgs,.predictedCmdStr)
		If $$$ISERR(tSC) Quit

		Set pPassphraseList = gwyDefn.passphraseList
		
		// replace passphrase in predicted command string
		Set indexOfPassphraseInStr = $Length($Get(predictedCmdStr))-$Length($listget(gwyDefn.passphraseList,2))-2
		Set:pUsePassphrase predictedCmdStr = $Extract($Get(predictedCmdStr),1,indexOfPassphraseInStr)_
					$Replace($Get(predictedCmdStr),$Listget(gwyDefn.passphraseList,2),"*Passphrase Required*",
								indexOfPassphraseInStr,1)
		$$$LOGINFO("Executing via CPIPE: "_$Get(predictedCmdStr))

		// start the gateway server
		Set tSC = ..RunCommandViaCPIPE(cmd,,.tOutput,..#PIPEREADTIMEOUT,,.cmdArgs)

		If 'pDebug {
			// This is the usual case; the only output we get from java would be error(s)
			If tOutput'="" {
				$$$LOGERROR("Execution returned: "_tOutput)
				Set tSC = $$$ERROR($$$EnsErrGeneral, "An error occurred when starting the Gateway Server")
			}
		}
		Else {
			// If JavaDebug is enabled, there will always be output which may be just the output from the debug option(s),
			// or it may also contain errors, so we give warnings for the user to check it
			$$$LOGWARNING("Execution returned: "_tOutput)
			$$$LOGWARNING("Check contents returned from the Java Gateway to ensure there are no errors")
			Set tSC = ..PingJavaGateway(+pPort, "127.0.0.1")
			If $$$ISERR(tSC) {
				$$$LOGERROR("Java Gateway server did not respond to PING request: "_$$$StatusDisplayString(tSC))
				Set tSC = $$$ERROR($$$EnsErrGeneral, "An error occurred when starting the Gateway Server")
			}
		}
	}
	Catch {
		Set tSC = $$$EnsSystemError
	}

	Quit tSC
}

ClassMethod StopJava(ByRef pDevice As %String) As %Status [ Internal ]
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
	If $$$ISERR(tSC) { // convert from InterSystems IRIS error status to Interoperability specific error status
		Set errorText = $system.Status.GetErrorText(tSC)
		If (errorText["Failed to open temporary file") {
			Set tSC = $$$ERROR($$$EnsErrGeneral,errorText)
		} Else {
			Set tSC = $$$SystemError
		}
	}
	Quit tSC
}

ClassMethod JavaDebugParams(pDebugPort As %String, pDebugSuspend As %String) As %String
{
	Set tDebug = ..#JAVADEBUG

	Try {
		For parm = "JavaDebugPort", "JavaDebugSuspend" {
			Set what = "${"_parm_"}"
			If parm="JavaDebugPort" { Set value = pDebugPort }
			ElseIf parm="JavaDebugSuspend" { Set value = pDebugSuspend }
			Set p = 1
			For {
				Set p = $F(tDebug,what,p)
				Quit:'p
				Set tDebug = $E(tDebug,1,p-$L(what)-1)_value_$E(tDebug,p,$L(tDebug))
				Set p = p+$L(value)-$L(what)
			}			
		}
	}
	Catch {
		Set tSC = $$$EnsSystemError ; log it
	}

	Quit tDebug
}

}
