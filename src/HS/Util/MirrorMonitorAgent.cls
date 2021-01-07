Include (%ZHSLIB, HS.HC)

Class HS.Util.MirrorMonitorAgent [ Abstract ]
{

/// This could be run at system startup and when becoming primary.
/// If the primary has any pending system api tasks to complete, it needs to wait until these have been done
/// For now, we don't do it, since we may want to allow the user access to the system to activate
/// productions, use the mirror monitor, etc.
ClassMethod UpToDateWait() As %Status
{
	Set tSC=$$$OK
	Try {
		New $Namespace Set $Namespace="HSSYS"
		For {
			Quit:..IsUpToDate()
			// Make sure the agent is running
			Do ..StartAgent()
			Hang 5
		}
	} Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit:tSC
}

ClassMethod IsUpToDate() As %Boolean
{
	Quit:'$system.Mirror.IsMember() 1
	Quit:'$system.Mirror.IsPrimary() 1
	//are we waiting for a database to be created
	If $D(^%SYS("HealthShare","CreateDB"),tDBName) {
		set tMgrDir=$system.Util.ManagerDirectory()
		set tDataDir=##class(%File).NormalizeDirectory(tMgrDir_"/"_tDBName)
		Quit:'##class(%File).Exists(tDataDir_$$$DatabaseFilename) 0
	}
	Kill tDBArray Set tInfo= ..GetMirrorDBList(.tDBArray)
	Set tDBName="", tUpToDate=1
	For {
		Set tDBName=$O(tDBArray(tDBName)) Quit:tDBName=""
		If $G(^%SYS("HealthShare","SystemAPI",tDBName))>$G(^%SYS("HealthShareLocal","SystemAPI",tDBName)) {
			Set tUpToDate=0 Quit
		}
	}
	Quit tUpToDate
}

/// Called from OnStartHealthShare in %ZHSLIB.HealthShareMgr, and also from the HealthShare mirror monitor UI
ClassMethod StartAgent()
{
	Try {
		New $Namespace
		Set $Namespace="HSSYS" // can fail before we set up HSSYS
		Kill ^%SYS("HealthShareLocal","MirrorMonitorAgentStop")
		Lock +^%SYS("HealthShareLocal","MirrorMonitorAgent"):0
		// only job if not already running
		If $Test {
			Job ##Class(HS.Util.MirrorMonitorAgent).Background()
			Hang .5 //allow job to start and request lock
			Lock -^%SYS("HealthShareLocal","MirrorMonitorAgent")
		}
	} Catch(ex) {
		//
	}
}

/// Input how long to wait for it to stop
/// Outputs 1 if OK, 0 if it won't stop
ClassMethod StopAgent(pWait = 60) As %Boolean
{
	New $Namespace
	Set $Namespace="HSSYS"
	Lock +^%SYS("HealthShareLocal","MirrorMonitorAgent"):0
	If $Test {
		//agent not running
		Lock -^%SYS("HealthShareLocal","MirrorMonitorAgent")
		Quit 1
	}
	Set ^%SYS("HealthShareLocal","MirrorMonitorAgentStop")=1
	Set tStopped=0
	For tI=1:1:pWait {
		Hang 1
		Lock +^%SYS("HealthShareLocal","MirrorMonitorAgent"):0
		If $Test {
			//agent not running
			Lock -^%SYS("HealthShareLocal","MirrorMonitorAgent")
			Set tStopped=1
			Quit
		}
	}
	Quit tStopped
}

/// This runs in HSSYS
ClassMethod Background()
{
	Lock +^%SYS("HealthShareLocal","MirrorMonitorAgent"):10 Quit:'$Test  //insure that only one of these is running
	//For object sync to work, all mirror members must have the same instance GUID.
	//This code is needed until this issue is resolved at the Cache' system level
	Do ..ManageInstanceGUID()
	While 1 {
		If $Get(^%SYS("HealthShareLocal","MirrorMonitorAgentStop")) {
			Kill ^%SYS("HealthShareLocal","MirrorMonitorAgentStop")
			Quit
		}
		Set tHang = 10
		If $System.Mirror.IsMember() {
			Set tHang = ..Poll()
		}
		If tHang {
			Hang tHang
		}
	}
	Lock -^%SYS("HealthShareLocal","MirrorMonitorAgent")
}

/// Returns the hang time to be used between consecutive polls
ClassMethod Poll() As %Integer
{
	// Hang time to be used between consecutive polls
	Set tHang = 5
	Set $Namespace = "HSSYS"
	Kill tMirroredDatabaseArray
	Set tInfo = ..GetMirrorDBList(.tMirroredDatabaseArray)
	If (tInfo '= "") {
		Do ..Log("%SYS","",1,"Mirror Status",tInfo)
		Quit tHang
	}
	
	// Priority list of databases (for running steps on backup mirror member).
	// % and HSSYS should be run before other databases because other databases
	// may depend on calls made on these databases.
	Set tPriorityDatabaseList = $ListBuild("%", "HSSYS")
	// Priority array of database (mapping priority to database name)
	#dim tPrioritizedDatabaseArray As %String
	// Databases we have already added to the priority array
	#dim tSeenDatabaseArray As %String
	// First add prioritized databases
	Set tPointer = 0
	While $ListNext(tPriorityDatabaseList, tPointer, tDatabase) {
		// Check if databse is mirrored. If so, add to array
		If $Data(tMirroredDatabaseArray(tDatabase))#2 {
			Set tPrioritizedDatabaseArray($Increment(tPrioritizedDatabaseArray)) = tDatabase
			Set tSeenDatabaseArray(tDatabase) = ""
		}
	}
	
	// Add remaining databases
	Set tAuditDatabaseName = "HSAUDIT"
	Set tDatabase = ""
	While 1 {
		Set tDatabase = $Order(tMirroredDatabaseArray(tDatabase))
		If (tDatabase = "") {
			Quit
		}
		// Skip if its already been seen OR if its the Audit database
		If $Data(tSeenDatabaseArray(tDatabase))#2 || (tDatabase = tAuditDatabaseName) {
			Continue
		}
		Set tPrioritizedDatabaseArray($Increment(tPrioritizedDatabaseArray)) = tDatabase
	}
	// Ensure Audit Database is the last one, in case we're deleting it and other databases map to it
	IF $Data(tMirroredDatabaseArray(tAuditDatabaseName))#2 {
		Set tPrioritizedDatabaseArray($Increment(tPrioritizedDatabaseArray)) = tAuditDatabaseName
	}
	
	// Run steps for each database, in priority sequence
	Set tIndex = ""
	While 1 {
		Set tIndex = $Order(tPrioritizedDatabaseArray(tIndex), 1, tDBName)
		If (tIndex = "") {
			Quit
		}
		While $Get(^%SYS("HealthShare","SystemAPI",tDBName)) > $Get(^%SYS("HealthShareLocal","SystemAPI",tDBName)) {
			Set tStep = $Get(^%SYS("HealthShareLocal","SystemAPI",tDBName)) + 1
			Set tHang = 0
			Kill tArgs
			Set tArgs = ^%SYS("HealthShare","SystemAPI",tDBName,tStep,"Args",0)
			For tI=1:1:tArgs {
				If '$Data(^%SYS("HealthShare","SystemAPI",tDBName,tStep,"Args",tI)) {
					Continue
				}
				Set tType = ^%SYS("HealthShare","SystemAPI",tDBName,tStep,"Args",tI)
				Set tValue = ^%SYS("HealthShare","SystemAPI",tDBName,tStep,"Args",tI,"Value")
				If (tType = "stream") {
					Set tArgs(tI) = ##class(%Stream.GlobalBinary).%New()
					Do tArgs(tI).Write(tValue)
				} Else {
					Set tArgs(tI) = tValue
				}
			}
			Set tMethodName = $Piece(^%SYS("HealthShare","SystemAPI",tDBName,tStep), "^" , 2)
			If (tMethodName = "CreateDB") {
				// Dummy step for CreateDB for logging only - skip it for step processing
				Set ^%SYS("HealthShareLocal", "SystemAPI", tDBName) = tStep
				Continue
			}
			Try {
				Set $Namespace = "HSSYS"
				Set tSC = $ClassMethod("HS.Util.SystemAPI",tMethodName,tArgs...)
				Set $Namespace = "HSSYS"
			} Catch(ex) {
				Set tSC = ex.AsStatus()
				Do ##class(%SYS.System).WriteToConsoleLog($System.Status.GetErrorText(tSC),,2)
			}
			Set tMessage=tDBName_" Step "_tStep_" "_$Select($$$ISOK(tSC):"OK",1:$system.Status.GetErrorText(tSC))
			Do ..Log(tDBName,tStep,$$$ISERR(tSC),tMethodName,tMessage)
			Set ^%SYS("HealthShareLocal","SystemAPI",tDBName) = tStep
		}
	}
	//Once we're caught up, check for new database - we have to wait, because a leftover uninstall might have told us
	//to uninstall the database
	If $Data(^%SYS("HealthShare","CreateDB"), tDBNameStep) {
		Set tHang = 0
		Set tDBName 	= $Piece(tDBNameStep, "^", 1)
		Set tStep 		= $Piece(tDBNameStep, "^", 2)
		Set tLocation 	= $Piece(tDBNameStep, "^", 3)
		If (tLocation = "") {
			Set tLocation = ##class(%Library.File).ManagerDirectory()
		}
		Set tDataDir = ##class(%File).NormalizeDirectory(tLocation_"/"_tDBName)
		If ##class(%File).Exists(tDataDir_$$$DatabaseFilename) {
			// database already exists - it ought to be in mirror
			If '$Data(tMirroredDatabaseArray(tDBName)) {
				Do ..Log(tDBName,tStep,1,"CreateDB",tDBName_" Step "_tStep_" Datafile exists for "_tDBName_" but it's not a mirrored database")
			}
		} Else {
			Set tSC = ##class(HS.Util.SystemAPI).DoCreateDatabase(tDBName,tDataDir)
			Set $Namespace = "HSSYS"
			Set tMessage = tDBName_" Step "_tStep_" "_$Select($$$ISOK(tSC):"OK",1:$system.Status.GetErrorText(tSC))
			Do ..Log(tDBName,tStep,$$$ISERR(tSC),"CreateDB",tMessage)
		}
		Set ^%SYS("HealthShareLocal", "SystemAPI", tDBName) = tStep
	}
	Quit tHang
}

ClassMethod GetMirrorDBList(Output pDBArray) As %String
{
	New $Namespace
	Set $Namespace = "%SYS"
	Try {
		Set tInfo = ""
		Set tRS = ##class(%ResultSet).%New()
		Set tRS.ClassName = "SYS.Mirror"
		Set tRS.QueryName = "MirroredDatabaseList"
		Set tSC = tRS.Execute()
		$$$ThrowOnError(tSC)
		Set pDBArray("%") = ""
		While tRS.Next(.tSC) {
			$$$ThrowOnError(tSC)
			Set tMirroredDBName = tRS.%Get("Name")
			Set pDBArray(tMirroredDBName) = ""
		}
		$$$ThrowOnError(tSC)
		Set tSC = tRS.Close()
		$$$ThrowOnError(tSC)
	} Catch ex {
		Set tInfo = $system.Status.GetErrorText(tSC)
	}	
	Quit tInfo
}

ClassMethod Log(pDatabase, pStep, pIsError As %Boolean, pMethod As %String, pMessage As %String)
{
	Try {
		If pStep="Create",pIsError {
			//potential repeating error - log only once a minute, not once every 5 seconds.
			If $G(%LastCreateDB)=pDatabase,$ZH-$G(%LastCreateZH)<60 Quit
			Set %LastCreateDB=pDatabase,%LastCreateZH=$ZH
		}
		New $Namespace
		If pIsError {
			Set $Namespace="%SYS"
			Do ##class(%SYS.System).WriteToConsoleLog("Mirror Monitor Error running "_pMethod_": "_pMessage,,2)
		}
		Set $Namespace="HSSYS"
		If $system.Mirror.IsPrimary() {
			// Log leftover steps done on primary after failover
			Do ##class(HS.Util.Mirror.WebServices).AgentLog(##class(%SYS.System).GetUniqueInstanceName(1),pDatabase,pStep,pMethod,pIsError,pMessage)
			Quit
		}
		If '$D(%PrimaryConnect) {
			Do ..GetPrimaryConnectInfo(.tLocation, .tUserCredentials, .tSSLConfig)
			Set %PrimaryConnect("Location")=tLocation
			Set %PrimaryConnect("Credentials")=tUserCredentials
			Set %PrimaryConnect("SSLConfig")=tSSLConfig
		}
		Set tSoap=##class(HS.Util.Mirror.WebServicesClient).%New()
		Set tCredentials = ##class(Ens.Config.Credentials).%OpenId(%PrimaryConnect("Credentials"))
		Set tSoap.SSLConfiguration=%PrimaryConnect("SSLConfig")
		Set tSoap.OpenTimeout=10
		Set tSoap.Location=%PrimaryConnect("Location")
		Set tSC=tSoap.WSSecurityLogin(tCredentials.Username,tCredentials.Password) QUIT:'tSC
		Do tSoap.AgentLog(##class(%SYS.System).GetUniqueInstanceName(1),pDatabase,pStep,pMethod,pIsError,pMessage)
	} Catch ex {
		Do ##class(%SYS.System).WriteToConsoleLog("Mirror Monitor Error while logging: "_ex.DisplayString(),,2)
	}
}

ClassMethod GetPrimaryConnectInfo(Output pLocation As %String, Output pUserCredentials As %String, Output pSSLConfig As %String) As %Status
{
	New $Namespace
	Set $Namespace="HSSYS"
	#dim tConfig as HS.Registry.Service.SOAP = ##class(HS.Registry.Service.SOAP).EndPointForNameType("HSREGISTRY","SOAP")
	If $IsObject(tConfig) {
		Set pUserCredentials = tConfig.UsernameTokenProfileConfig
		Set pSSLConfig=tConfig.SSLConfig
	} Else {
		Set pUserCredentials = $$$HSServiceUserGetMake
		Set pSSLConfig=""
	}
	Do ##class(%RoutineMgr).GetWebServerPort(.tPort,,.tUrlPrefix)
	//These should always be there
	If $D(^%SYS("HealthShare","MirrorPrimaryPort")) Set tPort=^("MirrorPrimaryPort"),tUrlPrefix=^("MirrorPrimaryUrlPrefix")
	Set:tUrlPrefix'="" tUrlPrefix="/"_tUrlPrefix
	Set tHost=$$$HSNetworkHostName
	Set pLocation="http"_$S(pSSLConfig="":"",1:"s")_"://"_tHost_":"_tPort_tUrlPrefix_"/csp/healthshare/hssys/services/HS.Util.Mirror.WebServices.cls"
}

ClassMethod ManageInstanceGUID()
{
	Try {
		Set tNonPrimary=0
		If $system.Mirror.IsMember() {
			If $system.Mirror.IsPrimary() {
				//Take the primary member's instance GUID and record it in a mirrored database
				Set:'$D(%SYS("HealthShare","ObjSyncInstanceGUID")) ^%SYS("HealthShare","ObjSyncInstanceGUID")=##class(%SYS.System).InstanceGUID()
			} ElseIf $D(^%SYS("HealthShare","ObjSyncInstanceGUID")) {
				//Copy our mirrored version of the instance GUID into the place used by object sync
				Set ^["^^"_$zu(12)]SYS("INSTANCEGUID")=^%SYS("HealthShare","ObjSyncInstanceGUID")
				Set tNonPrimary=1
			}

		}
		//can't run this on a non-primary mirror member, but do run it anywhere else
		If $system.Version.GetMajor()>2016,'tNonPrimary {
			New $Namespace
			Set $Namespace="HSSYS"
			Do ##class(%SYNC.Utils).setSyncGUID(##class(%SYS.System).InstanceGUID())
		}
	} Catch ex {
		Do ##class(%SYS.System).WriteToConsoleLog("Mirror Monitor Error while logging: "_ex.DisplayString(),,2)
	}
}

}
