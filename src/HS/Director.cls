Include HS.HC

/// Class to manage HealthShare
Class HS.Director
{

/// Stop all HealthShare instances
ClassMethod StopAll(pQuietly As %Boolean = 0, pForce As %Boolean = 1) As %Status
{
	Quit ..invokeAll("StopProduction",,,,pQuietly,pForce)
}

/// Stop a particular HealthShare instance
/// See also ..StopProduction()
ClassMethod Stop(pComponent As %String = {$namespace}, pQuietly As %Boolean = 0) As %Status
{
	Quit ..invokeAll("StopProduction",,pComponent,,pQuietly)
}

/// Start all HealthShare instances (in correct order)
ClassMethod StartAll(pQuietly As %Boolean = 0) As %Status
{
	Quit ..invokeAll("StartProduction",1,,,pQuietly)
}

/// Start a particular HealthShare instance
/// See also ..StartProduction()
ClassMethod Start(pComponent As %String = {$namespace}, pQuietly As %Boolean = 0) As %Status
{
	Quit ..invokeAll("StartProduction",1,pComponent,,pQuietly)
}

/// Start or Restart all HealthShare instances
ClassMethod RestartAll(pQuietly As %Boolean = 0, pForce As %Boolean = 1) As %Status
{
	Quit ..invokeAll("RestartProduction",,,,pQuietly,pForce)
}

/// Restart a particular HealthShare instance
/// Only works if the instance is stopped
/// See also ..StartProduction()
ClassMethod Restart(pComponent As %String = {$namespace}, pQuietly As %Boolean = 0) As %Status
{
	Quit ..invokeAll("RestartProduction",,pComponent,,pQuietly)
}

/// Start (or Restart) all HealthShare instances (in this HSLIB, in correct order)
ClassMethod StartOrRestartAll(pDelay As %Integer = 0) As %Status
{
	try {
		New $namespace
		Set tSC=$$$OK
		Do ..GetProductionList(..PRODUCTIONSTOPORDER(),.tList)
		Set (tGroup,tItem)=""
		For  {
			Set tGroup=$O(tList("O",tGroup)) Quit:tGroup=""
			For  {
				Set tItem=$O(tList("O",tGroup,tItem)) Quit:tItem=""
				Set tComponent = tList("O",tGroup,tItem)
				if tComponent.Activated=0 continue  // if it has got de-activated due to an upgrade
				set tSC=..StopProduction(tComponent.Name,30,.tInitialState,.tState)
				if tState'=$$$eProductionStateStopped set tSC=$$$HSError($$$HSErrProductionNotStopped,$p("Running,Stopped,Suspended,Troubled,NetworkStopped",",",tState)) quit
			}
			if $$$ISERR(tSC) quit
		}
		if $$$ISERR(tSC) quit

		Do ..GetProductionList(..PRODUCTIONSTARTORDER(),.tList)
		Set (tGroup,tItem)=""
		For  {
			Set tGroup=$O(tList("O",tGroup)) Quit:tGroup=""
			For  {
				Set tItem=$O(tList("O",tGroup,tItem)) Quit:tItem=""
				Set tComponent = tList("O",tGroup,tItem)
				set tSC=..StartProduction(tComponent.Name,,.tState)
				if tState'=$$$eProductionStateRunning set tSC=$$$HSError($$$HSErrProductionNotStarted,$p("Running,Stopped,Suspended,Troubled,NetworkStopped",",",tState)) quit
				hang pDelay ;to ensure that they get registered in the order in which they're started
			}
			if $$$ISERR(tSC) quit
		}
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Replaced parameters with expression methods, with defined order based on non-existence of the global entry
ClassMethod PRODUCTIONSTARTORDER() As %String [ CodeMode = expression ]
{
$G(^%SYS("HealthShare","ProductionStartOrder"),"Hub,Bus,FlashGateway,EdgeGateway,AccessGateway,FoundationType"_$S(##class(%ZHSLIB.HealthShareMgr).IsHealthShareInstance():"",1:",Foundation"))
}

/// Replaced parameters with expression methods, with defined order based on non-existence of the global entry
ClassMethod PRODUCTIONSTOPORDER() As %String [ CodeMode = expression ]
{
$G(^%SYS("HealthShare","ProductionStopOrder"),$S(##class(%ZHSLIB.HealthShareMgr).IsHealthShareInstance():"",1:"Foundation,")_"FoundationType,AccessGateway,EdgeGateway,FlashGateway,Bus,Hub")
}

/// Set the component as Disabled, but do not stop it if running
ClassMethod Disable(pComponent As %String = {$namespace}, pDisable As %Boolean = 1) As %Status
{
	Set tSC=$$$OK,$ZT="Trap"
	Do {
		#dim tComponent As HS.Util.Installer.ConfigItem
		
		// Let's look up that component
		Set tSC = ##class(HS.Util.Installer.ConfigItem).GetComponentByName(pComponent,.tComponent)
		Quit:$$$ISERR(tSC)
		
		// Now, let's enable/disable it
		Set tComponent.Disabled = pDisable
		Set tSC = tComponent.%Save()
		
	} While (0)
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
}

/// Set the component as not disabled, but do not start it here
ClassMethod Enable(pComponent As %String = {$namespace}, pEnable As %Boolean = 1) As %Status
{
	Quit ..Disable(pComponent, 'pEnable)
}

/// Deactivate all HealthShare namespaces where the db version does not match installed version or
/// there are upgrades steps to be run (for HS or any product)
ClassMethod DeactivateAll() As %Status
{
	// This does not run on a non-primary mirror member
	If $system.Mirror.IsMember(),'$system.Mirror.IsPrimary() Quit $$$OK
	Set tNS="",tSC=$$$OK
	For  {
		Set tNS=$O(^%SYS("HealthShare","Instances",tNS))
		Quit:tNS=""
		Set tComponent = ##class(HS.Util.Installer.ConfigItem).%OpenId(tNS)
		If tComponent.Type="Foundation" && (tComponent.%ClassName(0)="Foundation") Continue
		Continue:'..CheckNS(tNS,tComponent)
		Set tProducts = tComponent.Products
		#; if there are no products we haven't done the upgrade to 13 yet
		Set tDeactivate=$S(tProducts.Count():0,1:1)		
		If 'tDeactivate {
			For tIdx = 1:1:tProducts.Count() {
				Set tProduct=tProducts.GetAt(tIdx)
				Set tVersion=$G(tVersion(tProduct))
				Set:tVersion="" tVersion=##class(HS.Util.Installer.Upgrade.Loader).GetCurrentVersion(tProduct,,tComponent)
				// Handle Case of Upgrades from hscore 15.01 to 15.02 for HSPI running in Hub namespace.
				If (tProduct="HSPILIB"&&(tComponent.Type="Hub")) {
					If ('$D($$$ProductVersion(tProduct,tNS,15))&&($$$ProductCurrentVersion("HSLIB",tNS)=15)) {
						Do ..FixHSPILIB()
					}
				}
				
				// On upgrades to 2019.1+, remove MPRLLIB if it still exists.
				// For patient index namespaces and hubs with patient index, switch mappings from MPRLLIB to HSPILIB.
				set tMPRLLIBInstalled= ##class(%ZHSLIB.HealthShareMgr).CheckDBInstalled("MPRLLIB")
				set tPatientIndexNamespace= ((tProduct="HSPILIB")||((tProduct="HSLIB") &&(tComponent.Type="Hub")&&tProducts.Find("HSPILIB")))
				Set tID=##class(HS.Registry.Service.SOAP).IDForNameType("HSPI","SOAP")
				set tPatientIndexEnabledHub = ((tProduct="HSLIB") &&(tComponent.Type="Hub")&&(tID'=""))
				set tRemap = (tPatientIndexNamespace || tPatientIndexEnabledHub)
				set tbeforeVersion = ##class(HS.Util.Installer.Upgrade.Loader).GetVersion(tProduct,tNS)
				if ((tbeforeVersion<tVersion) && (tVersion>=17) && tMPRLLIBInstalled){
					set tSC3 = ..RemoveMPRLLIB(tNS,tRemap)
					If $$$ISERR(tSC3) {
						Do ##class(%SYS.System).WriteToConsoleLog("Error removing mappings to MPRLLIB.")
						Do ##class(%SYS.System).WriteToConsoleLog($System.Status.GetErrorText(tSC3))
						Set tSC3=$$$OK
					}
					else {
						Do ##class(%SYS.System).WriteToConsoleLog("Successfully removed mappings to MPRLLIB.")
					}
				}	
				do:(tPatientIndexNamespace||tPatientIndexEnabledHub) ..HSPICompileLocal(tNS)
				If $g($$$ProductCurrentVersion(tProduct,tNS))\1'=tVersion Set tDeactivate=1 Quit
			}
		}
		If 'tDeactivate {
			Do ##class(HS.Util.Installer.Upgrade.Loader).GetUpgradeMethods(tNS,,.tUpToDate)
			Set:'tUpToDate tDeactivate=1
		}

		Set:tDeactivate tSC= ..Deactivate(tNS) Quit:$$$ISERR(tSC)
		Write:tDeactivate !,"Deactivating ",tNS
	}
	// Before exiting, build the SDA/CDA Annotations for HSSYS	
	new $namespace
	Set $namespace="HSSYS"
	Set tSC2=##class(HS.Doc.Utility.Setup).BuildAll()
	If $$$ISERR(tSC2) {
		Do ##class(%SYS.System).WriteToConsoleLog("Error building SDA/CDA Annotations in HSSYS.")
		Do ##class(%SYS.System).WriteToConsoleLog($System.Status.GetErrorText(tSC2))
		Set tSC2=$$$OK
	}
	//
	Quit tSC
}

ClassMethod CheckNS(pNS, pComponent As HS.Util.Installer.ConfigItem) As %Boolean
{
	New $Namespace
	Set tOK=1
	Try {
		Set $Namespace=pNS
	} Catch(ex) {
		//namespace doesn't exist
		Set tOK=0
		If pComponent.LastActivated'="" {
			//Mark as never activated if the namespace doesn't exist
			//Probab ly is a failover to a non-mirrored ns/db
			Set pComponent.LastActivated=""
			Set pComponent.Activated=0
			Do pComponent.%Save()
		}
	}
	Quit tOK
}

/// Correct ^HS.Upgrade global for HSPILIB product for 15.01 to 15.02 upgrade
ClassMethod FixHSPILIB()
{
	// Manually build nodes for HSPILIB to set baseline for upgrades
	Set ^HS.Upgrade("Product","HSPILIB","CurrentVersion")=15
	Set ^HS.Upgrade("Product","HSPILIB","UpgradeVersionSteps",13,"UpgradeStep1")=1
	Set ^HS.Upgrade("Product","HSPILIB","UpgradeVersionSteps",13,"UpgradeStep2")=1
	Set ^HS.Upgrade("Product","HSPILIB","UpgradeVersionSteps",14,"UpgradeStep1")=1
	Set ^HS.Upgrade("Product","HSPILIB","UpgradeVersionSteps",14,"UpgradeStep2")=1
	Set ^HS.Upgrade("Product","HSPILIB","UpgradeVersionSteps",15,"UpgradeStep1")=1
	Set ^HS.Upgrade("Product","HSPILIB","UpgradeVersionSteps",15,"UpgradeStep2")=1
	Set ^HS.Upgrade("Product","HSPILIB","UpgradeVersionSteps",15,"UpgradeStep3")=1
	Quit
}

ClassMethod RemoveMPRLLIB(pNamespace As %String, pUpdateMappings As %Boolean = 0) As %Status
{
	#define CurrentClass         $classname()
	#define CurrentMethod        ##safeexpression(""""_$get(%methodname)_"""")
	
	set tSC = $$$OK
	try {
				
		;Delete existing mappings between this namespace and MPRLLIB
		New $namespace
		Set $namespace="HSLIB"
		
		set tInstalled= ##class(%ZHSLIB.HealthShareMgr).CheckDBInstalled("MPRLLIB")
		if 'tInstalled{
			Do ##class(HS.Util.Installer).Log(.tLogFile,$$$CurrentClass,$$$CurrentMethod,"MPRLLIB was already deleted.")
			quit
		}
		
		if pUpdateMappings {
		
			set tSC = ##class(HS.Util.SystemAPI).Invoke("DeleteClassMappings",  pNamespace, pNamespace,"%MPRL")                     Quit:$$$ISERR(tSC)
			set tSC = ##class(HS.Util.SystemAPI).Invoke("DeleteRoutineMappings",pNamespace, pNamespace,"%MPRL","ALL")               Quit:$$$ISERR(tSC)
			set tSC = ##class(HS.Util.SystemAPI).Invoke("DeleteGlobalMappings",pNamespace, pNamespace,"IRIS.Msg(""MPRL"")")         Quit:$$$ISERR(tSC)
			set tSC = ##class(HS.Util.SystemAPI).Invoke("DeleteGlobalMappings",pNamespace, pNamespace,"IRIS.MsgNames(""MPRL"")") Quit:$$$ISERR(tSC)
			set tSC = ##class(HS.Util.SystemAPI).Invoke("DeleteGlobalMappings", pNamespace, pNamespace,"%MPRL.*")                   Quit:$$$ISERR(tSC)
			set tSC = ##class(HS.Util.SystemAPI).Invoke("DeleteRoutineMappings",pNamespace, pNamespace,"mprllibBuild","INC")        Quit:$$$ISERR(tSC)

			;Replace them with mappings to HSPILIB
			set tSC = ##class(HS.Util.SystemAPI).Invoke("AddClassMappings",  pNamespace, pNamespace,"%MPRL","HSPILIB")               Quit:$$$ISERR(tSC)
			set tSC = ##class(HS.Util.SystemAPI).Invoke("AddClassMappings",  pNamespace, pNamespace,"HSPI","HSPILIB")                Quit:$$$ISERR(tSC)
			set tSC = ##class(HS.Util.SystemAPI).Invoke("AddRoutineMappings",pNamespace, pNamespace,"%MPRL","ALL","HSPILIB")         Quit:$$$ISERR(tSC)
			set tSC = ##class(HS.Util.SystemAPI).Invoke("AddRoutineMappings",pNamespace, pNamespace,"HSPI","ALL","HSPILIB")          Quit:$$$ISERR(tSC)
			set tSC = ##class(HS.Util.SystemAPI).Invoke("AddRoutineMappings",pNamespace, pNamespace,"hspilibBuild","INC","HSPILIB")  Quit:$$$ISERR(tSC)
			set tSC = ##class(HS.Util.SystemAPI).Invoke("AddGlobalMappings", pNamespace, pNamespace,"IRIS.Msg(""HSPI"")","HSPILIB")  Quit:$$$ISERR(tSC)
			set tSC = ##class(HS.Util.SystemAPI).Invoke("AddGlobalMappings", pNamespace, pNamespace,"IRIS.Msg(""MPRL"")","HSPILIB")  Quit:$$$ISERR(tSC)
			set tSC = ##class(HS.Util.SystemAPI).Invoke("AddGlobalMappings", pNamespace, pNamespace,"%MPRL.*","HSPILIB")             Quit:$$$ISERR(tSC)
			set tSC = ##class(HS.Util.SystemAPI).Invoke("AddClassMappings",  pNamespace, pNamespace,"HSDQ","HSPILIB")                Quit:$$$ISERR(tSC)
			set tSC = ##class(HS.Util.SystemAPI).Invoke("AddRoutineMappings",pNamespace, pNamespace,"HSDQ","ALL","HSPILIB")          Quit:$$$ISERR(tSC)
			set tSC = ##class(HS.Util.SystemAPI).Invoke("AddGlobalMappings", pNamespace, pNamespace,"IRIS.Msg(""HSDQ"")","HSPILIB")  Quit:$$$ISERR(tSC)
			set tSC = ##class(HS.Util.SystemAPI).Invoke("ActivateConfiguration",pNamespace, pNamespace) Quit:$$$ISERR(tSC)

			;Write to log file
			Do ##class(HS.Util.Installer).Log(.tLogFile,$$$CurrentClass,$$$CurrentMethod,"Deleted mappings from "_pNamespace_" to MPRLLIB. Replaced them with mappings to HSPILIB.")
		}
		;Find remaining namespaces with mappings to MPRRLIB 
		Set $namespace="%SYS"
		set tSC= ##class(Config.Namespaces).NamespacesByDB("MPRLLIB",.tNamespaces,0) Quit:$$$ISERR(tSC)
		
		;If there are remaining namespaces with mappings to MPRLLIB, do not delete MPRLLIB, 
		; else unmirror MPRLLIB and delete it from CPF file, but keep IRIS.DAT file. Rename MPRLLIB Folder in mgr. 
		if tNamespaces'=""
		{
			Set $namespace="HSLIB"
			Do ##class(HS.Util.Installer).Log(.tLogFile,$$$CurrentClass,$$$CurrentMethod,"Cannot delete MPRRLIB. The following namespaces have mappings to it: "_tNamespaces)
		}
		else 
		{
			Set $namespace="HSLIB"
			Do ##class(HS.Util.Installer).Log(.tLogFile,$$$CurrentClass,$$$CurrentMethod,"Did not find namespaces with mappings to MPRRLIB. Will proceed to delete MPRLLIB.")
			
			;Unmirror MPRLLIB
			Set tSC= ##class(HS.Util.SystemAPIMethods).UnMirrorDatabase("MPRLLIB") QUIT:$$$ISERR(tSC) 
			
			Do ##class(HS.Util.Installer).Log(.tLogFile,$$$CurrentClass,$$$CurrentMethod,"Unmirrored MPRLLIB.")
			
			Set $namespace="%SYS"
			;Remove MPRLLIB from CPF file
			Set tSC=##class(Config.Databases).Delete("MPRLLIB") QUIT:$$$ISERR(tSC)
			
			;Copy mgr/mprllib folder to mgr/mprllibCOPY  
			set tMgrDir=$system.Util.ManagerDirectory()
			set tOldDirName=##class(%File).NormalizeDirectory(tMgrDir_"/"_"mprllib")
			set tNewDirName=##class(%File).NormalizeDirectory(tMgrDir_"/"_"mprllibCOPY")
			set tCopyStatus= ##class(%Library.File).CopyDir(tOldDirName,tNewDirName)
			
			;Log the removal from CPF file and the CopyDir step
			Set $namespace="HSLIB"
			Do ##class(HS.Util.Installer).Log(.tLogFile,$$$CurrentClass,$$$CurrentMethod,"Removed MPRLLIB from CPF File.")
			
			if tCopyStatus { 			
				Do ##class(HS.Util.Installer).Log(.tLogFile,$$$CurrentClass,$$$CurrentMethod,"Copied mgr/mprllib to mgr/mprllibCOPY.")
			
				;Delete mgr/mprllib
				set $namespace="%SYS"
				set tSC=##class(SYS.Database).DeleteDatabase(tOldDirName) QUIT:$$$ISERR(tSC)
				do ##class(%Library.File).RemoveDirectoryTree(tOldDirName)
				
				;Log the deletion of mgr/mprllib
				Set $namespace="HSLIB"
				Do ##class(HS.Util.Installer).Log(.tLogFile,$$$CurrentClass,$$$CurrentMethod,"Deleted mgr/mprllib.")


				; Verify that MPRLLIB is no longer a component. 
				; Also updates ^%SYS("HealthShare","ComponentDatabase",pDB) so it reflects that MPRLLIB is no longer a component.
				; Updates the version string
				set tInstalled= ##class(%ZHSLIB.HealthShareMgr).CheckDBInstalled("MPRLLIB")
				if 'tInstalled {
					Do ##class(HS.Util.Installer).Log(.tLogFile,$$$CurrentClass,$$$CurrentMethod,"Verified that MPRLLIB is no longer a component.")
				} else {
					Do ##class(HS.Util.Installer).Log(.tLogFile,$$$CurrentClass,$$$CurrentMethod,"MPRLLIB is still a component.")
				}				
			}else {
				Do ##class(HS.Util.Installer).Log(.tLogFile,$$$CurrentClass,$$$CurrentMethod,"Could not copy mgr/mprllib to mgr/mprllibCOPY.")
			}
		}
	} catch {
		set tSC=$$$ERROR($$$ObjectScriptError,$ZE) 
	}
	
	If $$$ISERR(tSC){
			Do ##class(HS.Util.Installer).Log(.tLogFile,$$$CurrentClass,$$$CurrentMethod,"Quit RemoveMPRLLIB prematurely due to the following error: "_$System.Status.GetErrorText(tSC))
	}

	quit tSC
}

ClassMethod HSPICompileLocal(pNS)
{
	New $Namespace
	set $Namespace = pNS
	set definitionClass = ##class(HS.Registry.Config).GetKeyValue("\HSPI\LinkageDefinition","Local.Linkage.Definition")
	set exist=##class(%Dictionary.CompiledClass).%ExistsId(definitionClass)
	do:exist $system.OBJ.Compile(definitionClass)
}

/// Set the component as not activated, but do not stop it if running
ClassMethod Deactivate(pComponent As %String = {$namespace}) As %Status
{
	Set tSC=$$$OK,$ZT="Trap"
	Do {
		#dim tComponent As HS.Util.Installer.ConfigItem
		
		// Let's look up that component
		Set tSC = ##class(HS.Util.Installer.ConfigItem).GetComponentByName(pComponent,.tComponent)
		Quit:$$$ISERR(tSC)
		
		// Now, let's enable/disable it
		Set tComponent.Activated=0
		Set tSC = tComponent.%Save()
		
	} While (0)
Exit
	Quit tSC
Trap
	Set $ZT="",tSC=$$$EnsSystemError
	Goto Exit
}

/// Helper for invoking a single operation on all instances
/// [Previously private]
ClassMethod invokeAll(pMethod As %String, pPassProduction As %Boolean = 0, pComponent As %String = "", pForHSLib As %String = {$$$HSLIB}, pQuietly As %Boolean = 0, pForce As %Boolean = 1) As %Status [ Internal ]
{
	#dim tSC As %Status
	try {
		New $namespace
		Set tSC=$$$OK,tIO=$IO
		If $e(pMethod,1,4)="Stop" {
			Set tOrder=..PRODUCTIONSTOPORDER()
		} Else {
			Set tOrder = ..PRODUCTIONSTARTORDER()
		}
		Set pComponent = $ZCVT(pComponent,"U")
		
		If pQuietly {
			Set tNullDevice=$SYSTEM.Device.GetNullDevice()
			Open tNullDevice
			Use tNullDevice
		}

		Do ..GetProductionList(tOrder,.tList)
		If pComponent]"" {
			Set tComponent = $g(tList("NS",pComponent))
			Quit:'$IsObject(tComponent)
			Set tSC =..invokeMethod(tComponent,pMethod,pPassProduction,pForce)
			Quit
		}
		Set (tGroup,tItem, tFatal)=""
		For  {
			Set tGroup=$O(tList("O",tGroup)) Quit:tGroup=""
			For  {
				Set tItem=$O(tList("O",tGroup,tItem)) Quit:tItem=""
				Set tComponent = tList("O",tGroup,tItem)

				Set tSC2 = ..invokeMethod(tComponent,pMethod,pPassProduction,pForce)
				If $$$ISERR(tSC2),$G(tList("Type",tGroup))="Hub", pMethod="StartProduction",pPassProduction {
					//Error starting the hub as part of StartAll is fatal
					Set tFatal=1
					Do ##class(%SYS.System).WriteToConsoleLog("HS.Director:StartAll: "_$system.Status.GetErrorText(tSC2))
					Quit
				}
				// Accumulate any errors encountered
				Set:$$$ISERR(tSC2) tSC = $$$ADDSC(tSC,tSC2)
			}
			Quit:tFatal
		}
	} Catch eException {
		Set tSC=eException.AsStatus()
	}
	// Switch back to the original namespace
	If $G(tIO)]"" && ($IO'=tIO) Use tIO
	If $G(tNullDevice)]"" Close tNullDevice
	Quit tSC
}

ClassMethod invokeMethod(pComponent, pMethod, pPassProduction, pForce) As %Status
{
	try {
		new $namespace
		Set tSC = $$$OK
		// Switch namespaces
		$$$LOGINFO("Switching to namespace '"_pComponent.Name_"' ["_pComponent.Type_"]")
		Set $namespace=pComponent.Name

		Set tProduction = pComponent.Production
		Set:tProduction="" tProduction=pComponent.Name_"."_pComponent.Type_"Production"			
		
		// Verify production class exists before proceeding
		If '##class(%Dictionary.ClassDefinition).%Exists($lb(tProduction)) Quit
		
		set tSC=##class(Ens.Director).GetProductionStatus(.tProductionName,.tState) quit:$$$ISERR(tSC)
		Set tMethod=pMethod
		if tState=$$$eProductionStateTroubled  {
			Set tSC=##class(Ens.Director).RecoverProduction()
			If $$$ISERR(tSC) Write !,"Production is troubled or suspended, unable to recover" Quit
		}
		If tState=$$$eProductionStateStopped || (tState=$$$eProductionStateSuspended) { Set:pMethod["Restart" tMethod="StartProduction"}

		If tProduction="" {
			Set tSC=$$$HSError($$$HSErrComponentNotConfigured,tNS)
		} Else {
			If pPassProduction {
				Set tSC = $ZOBJCLASSMETHOD("Ens.Director",tMethod,tProduction)
			} Else {
				If tMethod="StartProduction" {
					Set tSC = $ZOBJCLASSMETHOD("Ens.Director",tMethod)
				} Else {
					// if stop / restart we will force
					Set tTimeout=##class(Ens.Director).GetProductionSettingValue(tProductionName,"ShutdownTimeout")
					If tTimeout="" Kill tTimeout
					Set tSC = $ZOBJCLASSMETHOD("Ens.Director",tMethod,.tTimeout,pForce)
				}
			}
		}
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	
	// If the error is that the production is already running on StartProduction, reset the status to $$$OK
	If $$$ISERR(tSC) && (tMethod="StartProduction") {
		If $System.Status.GetErrorText(tSC) [ "ErrProductionAlreadyRunning" Set tSC=$$$OK
	}
	Quit tSC
}

/// Terminal based console service
ClassMethod Console(tNS As %String = {$namespace}) [ Internal ]
{
	new $namespace
	Set tHSLib = $$$HSLIB
	If (tHSLib=tNS)!(tNS="") {
		Set (tNS,tTarget)="" For {
			Set tNS = $O(^%SYS("HealthShare","Instances",tNS)) Quit:tNS=""
			Set:tTarget'="" tTarget = tTarget_","
			Set tTarget = tTarget_tNS
		}
	} Else {
		Set tTarget = tNS
	}
	
	Do setup(tTarget)
	Set temp="",lines=(my-6),last="",to=1
	
	Do {
		Do collect(tTarget,.tData,lines)
		
		If last'=$G(tData(1)) {
			Do render(.tData,lines)
			Set last=$G(tData(1)),to=0.5
		} Else {
			Set to=to+0.5
		}
		
		Set tCmd = $$prompt($S(to>5:5,1:to),.temp)
		If tCmd="" Continue
		
		Set tCmdUpper = $P($ZCVT(tCmd,"U")," ")
		Set tArgs = $P(tCmd," ",2,$L(tCmd," "))
		Kill:tArgs="" tArgs
		
		Quit:"/Q/QUIT/"[("/"_tCmdUpper_"/")
		
		If "/STOA/STOPALL/"[("/"_tCmdUpper_"/") {
			Do ##class(HS.Director).StopAll(1)
		} ElseIf "/STAA/STARTALL/"[("/"_tCmdUpper_"/") {
			Do ##class(HS.Director).StartAll(1)
		} ElseIf "/RESA/RESTARTALL/"[("/"_tCmdUpper_"/") {
			Do ##class(HS.Director).RestartAll(1)
		} ElseIf "/STA/START/"[("/"_tCmdUpper_"/") {
			Do ##class(HS.Director).Start(.tArgs,1)
		} ElseIf "/STO/STOP/"[("/"_tCmdUpper_"/") {
			Do ##class(HS.Director).Stop(.tArgs,1)
		} ElseIf "/RES/RESTART/"[("/"_tCmdUpper_"/") {
			Do ##class(HS.Director).Restart(.tArgs,1)
		} ElseIf "/E/EXAMINE/"[("/"_tCmdUpper_"/") {
			// TODO
		} ElseIf "/P/PURGE/"[("/"_tCmdUpper_"/") {
			Do purge(tTarget)
			Do setup(tTarget)
		} Else {
			Do reporterr("Unknown command: "_tCmd)
		}
		
	} While (1)
		
	Write /C(1,my-2)
	Quit
	;
setup(ns)
	// Switch to the DTM mnemonic space to get nice terminal I/O commands
	Use 0::"^%XDTM"
	Do termdimensions

	Set bold="/color(10,9)"
	Set blink="/am"
	Set normal="/aa"
	
	// types are Assert,Error,Warning,Info,Trace,Alert
	Set typecolor(1)="/aa"
	Set typecolor(2)="/color(6,4)"
	Set typecolor(3)="/color(0,6)"
	Set typecolor(4)="/color(0,3)"
	Set typecolor(5)="/color(0,1)"
	Set typecolor(6)="/color(0,5)"
	
	Write /CLR,/C(1,1),@bold,$$pad("  HealthShare Console",mx),!
	Write "    ",$$pad(ns,mx-6),"  ",!,@normal
	Write /C(1,my-3),@bold,$$pad("",mx),@normal
	Quit
collect(nslist,data,max)
	Kill data
	Set data = $ZDT($H,2)
	For i=1:1:$l(nslist,",") {
		Set ns=$P(nslist,",",i)
		Do collectns(ns,.data,max)
	}
	// Now sort
	Set ts="" For {
		Set ts=$O(data(0,ts),-1) Quit:ts=""
		Set ix="" For {
			Set ix=$O(data(0,ts,ix)) Quit:ix=""
			Set data($I(data(0)))=data(0,ts,ix)
		}
	}
	Quit
collectns(ns,data,max)
	Set thisns=$namespace,$ZT="nserr",SQLCODE=0
	set:thisns'=ns $namespace=ns
	&sql(DECLARE c1 CURSOR FOR
			SELECT TOP :max %ID, TimeLogged, Type, ConfigName, Text
					FROM ENS_UTIL.LOG
					ORDER BY %ID DESC)
	&sql(OPEN c1)
	While (SQLCODE=0) {
		kill id,time,type,name,text
		&sql(FETCH c1 INTO :id, :time, :type, :name, :text) Quit:SQLCODE'=0
		
		Set data(0,time,$I(data(time)))=$LB(time,ns,id,type,name,text)
	}
	If SQLCODE'=0,SQLCODE'=100 do reporterr(SQLCODE_": "_%msg)
	&sql(CLOSE c1)
restorens
	set:$namespace'=thisns $namespace=thisns
	Quit
nserr
	Do reporterr($ZE)
	Goto restorens
purge(nslist)
	For i=1:1:$l(nslist,",") {
		Set ns=$P(nslist,",",i)
		Job ##class(Ens.Util.Tasks.Purge).PurgeAll():(ns)
	}
	Quit
reporterr(err)
	Write /C(1,my-2),@blink,"ERROR: ",err,@normal
	Quit
render(data,lines)
	Write /C(mx-4-$L(data),1),@bold,"[",data,"]",@normal
	Set used=0
	For i=1:1:lines {
		Quit:used'<lines
		If '$D(data(i)) Write $$pad("",mx) Quit
		
		// Render one row
		Set type = $LG(data(i),4)
		Write /C(1,3+used)
		Write @$S(type=4&&(i#2):normal,1:typecolor(type))
		
		Write $LG(data(i),1)," ",$$pad($LG(data(i),2),8),"  ",$$pad($LG(data(i),3),6),"  "
		Write $$pad(##class(Ens.Util.Log).TypeLogicalToDisplay(type),8)," "
		Write $$pad($LG(data(i),5),mx-51),!
		
		Set used=used+1,text=$TR($LG(data(i),6),$C(13,10),"  "),l=$L(text)
		Set:l>((lines-used)*mx) l=(lines-used)*mx
		Write $E(text,1,l)
		Set c=l\mx+(l#mx>0)
		Set used=used+c
		If l#mx>0 Write $$pad("",mx-(l#mx))		
	}
	Write @normal
	Quit
pad(s,w)
	Quit $S($L(s)>w:$E(s,1,w),1:s_$J("",w-$L(s)))
prompt(to,temp)
	Write /C(mx-20,my-3),@bold,"? ",$J("",18)
	Set input=""
	For {
		Write /C(mx-18,my-3),temp
		Read *c:to
		Quit:'$T
		
		If (c=13)!(c=10) {
			Set input = temp,temp=""
			Quit
		}
		
		If c=8 {
			Set temp = $E(temp,1,$L(temp)-1)
			Write *8," ",*8
			Continue
		}
		
		Set temp=temp_$C(c)
	}
	Write @normal
	Quit input
termdimensions
    If $I'?1"CON:".E {
       Write *-1 Read x:0 Write $C(27,91)_"6n" Read x:3 Set loc=$Key
       If $E(loc,1,2)=$C(27,91),loc?2E1.n1";"1.n1"R" {
          Write $C(27,91)_"999;999H"_$C(27,91)_"6n" Read x Set pos=$Key
          Write $E(loc,1,$L(loc)-1)_"H" Hang 0
          If $E(pos,1,2)=$C(27,91),pos?2E1.n1";"1.n1"R" {
                 Set x=$E(pos,3,$L(pos)-1),my=1+x,mx=$P(x,";",2)
          }
       }
    } Else {
	    Do CURRENT^%IS
	    Set mx=RM
	    Set my=SL
    }
	Quit
}

ClassMethod GetProductionList(pOrder, Output pList, pRestrictions = 1, pForHSLib As %String = {$$$HSLIB}) As %Status
{
	#dim tNS As %String
	#dim tType As %String
	#dim tProduction As %String
	#dim tHSLib As %String
	#dim tComponent As HS.Util.Installer.ConfigItem
	Kill pList
	For tIdx = 1:1:$l(pOrder,",") {
		Set tType=$p(pOrder,",",tIdx)
		Continue:tType=""
		Set tPosition(tType)=tIdx
	}
	Set tNS=""
		For {
			Set tNS = $ORDER(^%SYS("HealthShare","Instances",tNS))
			Quit:tNS=""
		
			// Determine the type and the production
			Set tHSLib = $G(^%SYS("HealthShare","Instances",tNS,"HSLIB"),pForHSLib)
		
			If pForHSLib'="",tHSLib'=pForHSLib Continue

			Set tSC = ##class(HS.Util.Installer.ConfigItem).GetComponentByName(tNS,.tComponent,,,tHSLib)
			Quit:$$$ISERR(tSC)

			If tComponent.%IsA("HS.Util.Installer.FoundationType") {
				Set tType = "FoundationType"
			} Else {
				Set tType = tComponent.Type
			}
			If tType="" || '$G(tPosition(tType)) continue

			// Skip if never activated (the namespace does not exist)
			If pRestrictions && (tComponent.LastActivated="") {
				$$$LOGINFO("Component '"_tNS_"' ["_tComponent.Type_"] is NEVER ACTIVATED, skipping")
				Continue
			}
	
			If pRestrictions && (tComponent.Disabled) {
				$$$LOGINFO("Component '"_tNS_"' ["_tComponent.Type_"] is DISABLED, skipping")
				Continue
			}
			Set tIdx = tPosition(tType)
			Set pList("Type",tIdx)=tType
			Set pList("O",tIdx,$i(pList("O",tIdx)))=tComponent
			Set pList("NS",tNS)=tComponent
		}
	Quit $$$OK
}

/// Try to stop the Production in pNamespace (if not already stopped)
///  (we assume only one Production per namespace !)
/// Result can be:
///   failure, returns %Status
///   success, returns
///      pState=1 ($$$eProductionStateRunning)
///      pState=2 ($$$eProductionStateStopped)
///      pState=3 ($$$eProductionStateSuspended)
///      pState=4 ($$$eProductionStateTroubled)
///      pState=5 ($$$eProductionStateNetworkStopped) 
ClassMethod StopProduction(pNamespace As %String, pTimeout As %Numeric = 30, ByRef pInitialState As %Integer, ByRef pState As %Integer, pForce As %Boolean = 0) As %Status
{
 set tSC=$$$OK,$ZT="Trap"
 new $namespace
 set $namespace=pNamespace
 do {
	set (pInitialState,pState)=0
	// Get current status
	Set tEnsOK=1
	Try {
		set tSC=##class(Ens.Director).GetProductionStatus(.tProductionName,.pInitialState) quit:$$$ISERR(tSC)
	} Catch(ex) {
		Set tEnsOK=0
	}
	If 'tEnsOK Set tSC=$$$OK Quit  // handle the case where there's no Ensemble mapping in place
	// If not running, OK - don't worry about suspended or other states - we can't let them prevent us from activating
	if pInitialState'=$$$eProductionStateRunning set pState=$$$eProductionStateStopped quit
	// Try to stop it
	set tSC=##class(Ens.Director).StopProduction(pTimeout,pForce) quit:$$$ISERR(tSC)
	// Check if it stopped
	set tSC=##class(Ens.Director).GetProductionStatus(.tProductionName,.pState) quit:$$$ISERR(tSC)
 } while (0)
Exit
 quit tSC
Trap
 set $ZT="",tSC=$$$EnsSystemError
 goto Exit
}

/// Try to start pProduction in pNamespace (if it is stopped)
/// Result can be:
///   failure, returns %Status
///   success, returns
///      pState=1 ($$$eProductionStateRunning)
///      pState=2 ($$$eProductionStateStopped)
///      pState=3 ($$$eProductionStateSuspended)
///      pState=4 ($$$eProductionStateTroubled)
///      pState=5 ($$$eProductionStateNetworkStopped) 
ClassMethod StartProduction(pNamespace As %String, pProductionName, ByRef pState As %Integer) As %Status
{
 set tSC=$$$OK,$ZT="Trap"
 new $namespace
 set $namespace=pNamespace
 do {
	// Get current status
	set tSC=##class(Ens.Director).GetProductionStatus(.tProductionName,.pState) quit:$$$ISERR(tSC)
	// If not stopped quit
	if pState'=$$$eProductionStateStopped quit
	// Get the production to be started (if not provided)
	if $g(pProductionName)="" {
		set pProductionName=##class(HS.Util.Installer.ConfigItem).GetPropertyValue(pNamespace,"Production",.tSC) quit:$$$ISERR(tSC)
	}
	// Check not disabled
	set tDisabled=##class(HS.Util.Installer.ConfigItem).GetPropertyValue(pNamespace,"Disabled",.tSC) quit:$$$ISERR(tSC)
	if tDisabled set tSC=$$$HSError($$$HSErrProductionDisabled) quit
	// Try to start it
	set tSC=##class(Ens.Director).StartProduction(pProductionName) quit:$$$ISERR(tSC)
	// Check if it started
	set tSC=##class(Ens.Director).GetProductionStatus(.tProductionName,.pState) quit:$$$ISERR(tSC)
 } while (0)
Exit
 quit tSC
Trap
 set $ZT="",tSC=$$$EnsSystemError
 goto Exit
}

}
