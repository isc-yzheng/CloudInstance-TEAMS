Include (Ensemble, HS.HC)

Class HS.HC.Util.Installer
{

/// Install/Update (activate) a Foundation in pNamespace
/// pVars allows you to override/change configuration parameters, which
/// will be updated in the HS.Util.Installer.ConfigItem database
ClassMethod InstallFoundation(pNamespace As %String, ByRef pVars) As %Status
{
	set tSC=##class(HS.Util.Installer.Foundation).Install(pNamespace,.pVars)
	quit tSC
}

/// deprecated - leftover from ancient history - we have only ever supported HSLIB as the library namespace
ClassMethod findHSLib() As %String
{
	Quit "HSLIB"
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
ClassMethod StopProduction(pNamespace As %String, pTimeout As %Numeric = 30, ByRef pInitialState As %Integer, ByRef pState As %Integer, pForce As %Boolean = 0) As %Status [ CodeMode = expression ]
{
##class(HS.Director).StopProduction($g(pNamespace),pTimeout,.pInitialState,.pState,pForce)
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
ClassMethod StartProduction(pNamespace As %String, pProductionName, ByRef pState As %Integer) As %Status [ CodeMode = expression ]
{
##class(HS.Director).StartProduction($g(pNamespace),$G(pProductionName),.pState)
}

ClassMethod NamespaceExists(pNamespace) As %Boolean
{
	New $Namespace
	set $namespace="%SYS"
 	// Check if pNamespace already exists
	Quit ##Class(Config.Namespaces).Exists(pNamespace)
}

/// Ensemble enable a namespace
/// the first and third arguments are no longer used
ClassMethod EnableEnsemble(pDummy, pNamespace As %String, pDummy2, pEnsPortalSuffix As %String = "ensemble", pEnsPortalPrefix As %String = "healthshare", pCookiePath As %String = "/csp/healthshare", pAuthMethods As %Integer = 36, ByRef pLogFile As %String)
{
	New $Namespace
	Try{
		Set tInitNamespace = $Namespace
		Set tSC=##class(HS.Util.SystemAPI).Invoke("CreateEnsembleMappings",pNamespace,pNamespace) Quit:$$$ISERR(tSC)
		do ..Log(.pLogFile,$$$CurrentClass,$$$CurrentMethod,"Created Ensemble Mappings")
		Do ..ActivateConfiguration(,pNamespace)
		do ..Log(.pLogFile,$$$CurrentClass,$$$CurrentMethod,"Configuration Loaded")
		Set tSC=##class(HS.Util.SystemAPI).Invoke("AddEnsembleSQLPrivileges",pNamespace,pNamespace) Quit:$$$ISERR(tSC)
		//For upgrade of non-primary, we're done - otherwise, we get protect errors on HSSYS upgrade
		If $system.Mirror.IsMember(),'$system.Mirror.IsPrimary() Quit
		//The steps below don't need explicit mirroring - they only change data, not configuration
		Lock +^HS.Installer.Compile("Ensemble")
		Set tSC=##class(%EnsembleMgr).mirrorUpgradeSteps(pNamespace) if $$$ISERR(tSC) throw ##class(%Exception.StatusException).CreateFromStatus(tSC)
		//Starting in 2016.1, compile the DeepSee dashboard
		If $system.Version.GetMajor()>2015 {
			do ..Log(.pLogFile,$$$CurrentClass,$$$CurrentMethod,"Compiling Ensemble DeepSee Dashboard")
			Set $Namespace=pNamespace
			Set tSC = $system.OBJ.CompilePackage("Ens.DeepSee","csk-d")
			do ##class(Ens.Util.Statistics).EnableStatsForProduction()
			Set $namespace=tInitNamespace
		}
		/// Add SyncCommit for Ensemble 
		Do ##class(%Library.EnsembleMgr).setConfigFlags(,pNamespace)
		Lock -^HS.Installer.Compile("Ensemble")
		do ..Log(.pLogFile,$$$CurrentClass,$$$CurrentMethod,"Ensemble Enabled")
	}
	Catch ex{
		Set tSC = ex.AsStatus()
		do ..Log(.pLogFile,$$$CurrentClass,$$$CurrentMethod,$System.Status.GetErrorText(tSC))
		Lock -^HS.Installer.Compile("Ensemble")
	}
}

/// Open and read the current config file and set up a Config.Configuration object (2208)
/// Just return "" (2009+)
ClassMethod GetConfigObject() As %RegisteredObject
{
	Quit ""
}

/// Add a list of class/package mappings
/// Adds them to the current configuration, but does not activate
/// pNamespace is the current namespace being configured, where the classes are to be used
/// pAddList is a comma-list of package specs, like "HS*,web*,..."
/// pFrom is the database containing the package
/// The mappings are assumed to not exist, use DeleteClassMappings to remove them first (to get correct order!)
/// The first argument is no longer used
ClassMethod AddClassMappings(pDummy, pNamespace As %String, pAddList As %String, pFrom As %String) As %Status
{
	Quit ##class(HS.Util.SystemAPI).Invoke("AddClassMappings",pNamespace,pNamespace,pAddList,pFrom)
}

/// Remove a list of class/package mappings for the selected Namespace
/// The first argument is no longer used
ClassMethod DeleteClassMappings(pDummy, pNamespace As %String, pDeleteList As %String = "") As %Status
{
	Quit ##class(HS.Util.SystemAPI).Invoke("DeleteClassMappings",,pNamespace,pDeleteList)
}

/// Add a list of routine mappings of specified type ("ALL", "INC", etc)
/// Adds them to the current configuration, but does not activate
/// pNamespace is the current namespace being configured, where the routines are to be used
/// pAddList is a comma-list of routine specs, like "A*,BA*,..."
/// pType is the type to map, "ALL" or "INC"
/// pFrom is the database containing the routines
/// The mappings are assumed to not exist, use DeleteRoutineMappings to remove them first
/// The first argument is no longer used
ClassMethod AddRoutineMappings(pDummy, pNamespace As %String, pAddList As %String, pType As %String = "ALL", pFrom As %String) As %Status
{
	Quit ##class(HS.Util.SystemAPI).Invoke("AddRoutineMappings",pNamespace,pNamespace,pAddList,pType,pFrom)
}

/// Remove a list of routine mappings of specified type ("ALL", "INC", etc)
/// The first argument is no longer used
ClassMethod DeleteRoutineMappings(pDummy, pNamespace As %String, pDeleteList As %String = "", pType As %String = "ALL")
{
	Quit ##class(HS.Util.SystemAPI).Invoke("DeleteRoutineMappings",,pNamespace,pDeleteList,pType)
}

/// Copy a class and Compile it
/// Return 1 if copied/replaced, 0 if not
ClassMethod CopyClass(pNamespace As %String, pSrc As %String, pTarget As %String) As %Integer
{
	New $namespace
	Set $namespace=pNamespace
	// if target does not already exists, copy it in
	if '##class(%Dictionary.ClassDefinition).%ExistsId(pTarget) {
		// check source class exists
		if '##class(%Dictionary.ClassDefinition).%ExistsId(pSrc) throw ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$ClassDoesNotExist,pSrc))
		set tSrcDef = ##class(%Dictionary.ClassDefinition).%OpenId(pSrc)
		set tTargetDef = tSrcDef.%ConstructClone(1)
		set tTargetDef.Name = pTarget
		#; when building a production from scratch using HS.Util.AbstractProduction we need to change the superclass
		If pSrc="HS.Util.AbstractProduction" Set tTargetDef.Super="HS.Util.AbstractProduction"
		set tSC = tTargetDef.%Save() if $$$ISERR(tSC) throw ##class(%Exception.StatusException).CreateFromStatus(tSC)
		set tCopied=1
	} else { set tCopied=0}
	// (always) compile
	set tSC = $system.OBJ.Compile(pTarget,"ck") if $$$ISERR(tSC) throw ##class(%Exception.StatusException).CreateFromStatus(tSC)
	quit tCopied
}

/// Build a list of classes in HSLIB which need to populate ^oddXML instead of ^oddCOM due to 
/// ^oddCOM being read-only for some classes, then change to the specified namespace and 
/// recompile those classes to ensure that they are correctly listed as extensions in ^oddXML in
/// the target namespace.
ClassMethod CompileXMLExtensions(pNamespace As %String = {$namespace}, Output pClassList, pExcludeEns As %Boolean = 1, pExcludeZen As %Boolean = 0) As %Status
{
	new $namespace
	Lock +^CacheTemp.HSInstall("CompileExtensionClasses")
	Kill pClassList
	set tStatus=$$$OK
	Try {
		Set $namespace = "HSLIB"
		Set tSuperKey = ""
		For {
			Set tSuperKey = $order(^oddXML(tSuperKey))
			Quit:(tSuperKey = "")
			If pExcludeZen && ($piece(tSuperKey,".",1) = "%ZEN") Continue
			If pExcludeEns && ($piece(tSuperKey,".", 1) = "Ens") Continue
			Set tClassKey = ""
			For {
				Set tClassKey = $order(^oddXML(tSuperKey, "c", tClassKey))
				Quit:(tClassKey = "")
				Set pClassList(tClassKey) = ""
			}
		}
		If $data(pClassList) {
			Set $namespace = pNamespace
			Set pClassList="" 
			#; pClassList comes from HSLIB remove any classes which don't exist in this namespace
			for  {
				Set pClassList=$o(pClassList(pClassList)) Quit:pClassList=""
				If '##class(%Library.ClassDefinition).%ExistsId(pClassList) {
					Kill pClassList(pClassList)
				} Else {
					Set tStatus=##class(%Projection.XML).CreateProjection(pClassList)
					Quit:$$$ISERR(tStatus)
				}
			}
		}
		Else {
			Set pClassList = ""
		}
	}
	Catch ex {
		Set tStatus = ex.AsStatus()
	}
	Lock -^CacheTemp.HSInstall("CompileExtensionClasses")
	Quit tStatus
}

/// Add configuration items from one production into an existing production, and save the new production
ClassMethod MergeConfigItems(pNamespace As %String, pFromName As %String, pToName As %String) As %Status
{
	// Same as upgrading an existing configuration
	Quit ##class(HS.Util.Installer.Upgrade.Abstract).MergeConfigItems(pNamespace,pFromName,pToName)
}

/// Load CSR rules then CSP pages
ClassMethod LoadPage(pNamespace As %String, pName As %String, pDir As %String, pFlags As %String)
{
 new $namespace
 set tSC=$$$OK,$zt="Trap"
 set $namespace=pNamespace
 if pName'="" {
	 if $zcvt(pName,"U")?.e1".CSR" {set tSC=$system.CSP.LoadRule(pName,pFlags)}
	 else {set tSC=$system.CSP.LoadPage(pName,pFlags)}
 }
 if pDir'="" {
	 set tSC=$system.CSP.LoadRuleDir(pDir,pFlags)
	 set tSC=$system.CSP.LoadPageDir(pDir,pFlags)
 }
Trap 
 quit tSC
}

/// Classmethod to create a new credential
/// This code is copied from %EnsembleMgr.SetCredentials and
///  Ens.Config.Credentials and modified to not return an error
///  if the Credential exists and pOverwrite is not set
ClassMethod SetCredential(pNamespace As %String, pName As %String, pUsername As %String, pPassword As %String, pOverwrite As %Boolean = 0) As %Status
{
	new $namespace
	set tSC=$$$OK
	set $namespace=pNamespace
	
	If ##class(Ens.Config.Credentials).%ExistsId(pName) {
		if pOverwrite {set tObj = ##class(Ens.Config.Credentials).%OpenId(pName)}
		else {set tObj=""}
	} Else {
		Set tObj = ##class(Ens.Config.Credentials).%New()
		if tObj="" set tSC=%objlasterror
	}
	If $IsObject($G(tObj)) {
		Set tObj.SystemName = pName
		Set tObj.Username = pUsername
		Set tObj.Password = pPassword
		Set tSC = tObj.%Save()
	}
	Quit tSC
}

/// Delete a resource if it exists
ClassMethod DeleteResource(pResource, pDatabase As %String = "%")
{
 	Set tSC=##class(HS.Util.SystemAPI).Invoke("DeleteResource",pDatabase,pResource)
}

/// Apply a bag of Settings to the production
ClassMethod ApplySettings(pTargetNS As %String, pProductionName As %String, ByRef pSettings, ByRef pResults)
{
 // Note: This is a modified copy of %EnsembleMgr.ApplySettings and
 // Ens.Production,  but
 //   it does not error (and abort) when an invalid setting is found
 //   it does not overwrite existing settings
 //   it returns a Results array of messages
 new $namespace

 // Switch to target Namespace
 set $namespace=pTargetNS
		
 // Grab the name and state of the running production
 set tSC=##class(Ens.Director).GetProductionStatus(.tRunningProduction,.tState) if $$$ISERR(tSC) throw ##class(%Exception.StatusException).CreateFromStatus(tSC)

 // Open the production up
 set tProduction=##class(Ens.Config.Production).%OpenId(pProductionName,,.tSC) if $$$ISERR(tSC) throw ##class(%Exception.StatusException).CreateFromStatus(tSC)	

 // Walk the bag of settings, set up pResults to show what happened
 set tItem=""
 for {
	set tItem=$ORDER(pSettings(tItem)) quit:tItem=""
	#dim tItemObj As Ens.Config.Item
	set tItemObj=tProduction.FindItemByConfigName(tItem)
	if '$IsObject(tItemObj) {
		set pResults($i(pResults))="Setting:"_tItem_" not found"
		continue
	}
	set tTarget=""
	for {
		set tTarget=$ORDER(pSettings(tItem,tTarget)) quit:tTarget=""
		set tSetting=""
		for {
			set tSetting=$ORDER(pSettings(tItem,tTarget,tSetting)) quit:tSetting=""
			if tTarget="Item" {  // setting a property *on* the config item
				if $$$comMemberDefined("Ens.Config.Item",$$$cCLASSproperty,tSetting) {
					set $ZOBJPROPERTY(tItemObj,tSetting)=pSettings(tItem,tTarget,tSetting)
					set pResults($i(pResults))="Setting:"_tItem_":"_tTarget_":"_tSetting_"="_pSettings(tItem,tTarget,tSetting)
				} else {  // No such property
					set pResults($i(pResults))="Setting:"_tItem_":"_tTarget_":"_tSetting_" not found"
				}
			} else {
				#dim tSettingObj As Ens.Config.Setting
				set tSettingObj=tItemObj.FindSettingByName(tSetting,tTarget)
				// if found, don't change it
				if $IsObject(tSettingObj) {
					set pResults($i(pResults))="Setting:"_tItem_":"_tTarget_":"_tSetting_" exists, not changed"
					continue
				}
				// Note we do not currently validate the setting (exists or is valid)
				set tSettingObj=##class(Ens.Config.Setting).%New()
				do tItemObj.Settings.Insert(tSettingObj)
				set tSettingObj.Name=tSetting
				set tSettingObj.Target=tTarget
				set tSettingObj.Value=pSettings(tItem,tTarget,tSetting)
				set pResults($i(pResults))="Setting:"_tItem_":"_tTarget_":"_tSetting_"="_pSettings(tItem,tTarget,tSetting)
			}
		}
	}
 }
			
 // Save the changes we made to the production
 set tSC=tProduction.%Save(1) if $$$ISERR(tSC) throw ##class(%Exception.StatusException).CreateFromStatus(tSC)

 // Regenerate the XData in the corresponding class
 set tSC=tProduction.SaveToClass() if $$$ISERR(tSC) throw ##class(%Exception.StatusException).CreateFromStatus(tSC)
		
 // Finally, does the production need updating?
 if (tRunningProduction=pProductionName)&&(tState=$$$eProductionStateRunning) {
	set tSC=##class(Ens.Director).UpdateProduction($G($$$ConfigProdSetting("UpdateTimeout"),10))
	if $$$ISERR(tSC) throw ##class(%Exception.StatusException).CreateFromStatus(tSC)
 }
}

/// If any item in pComponent exists in pProduction in pNamespace
///  then create pDirectory, if not already there
/// Returns 1 if created, -1 if already there, 0 if failed, -2 if not needed
/// Deprecated - do not use.  Use CreateDataDirectoryNew instead
ClassMethod CreateDataDirectory(pNamespace As %String, pProduction As %String, pComponent As %String, pDirectory As %String) As %Integer
{
	Set tInsDir=$ZCVT($system.Util.InstallDirectory(),"L")
	If $ZCVT($E(pDirectory,1,$L(tInsDir)),"L")'=tInsDir Quit 0  //pDirectory must start with installdir
	Set tDirectory=$E(pDirectory,$L(tInsDir)+1,*)
	Quit +..CreateDataDirectoryNew(pNamespace,pProduction,pComponent,tDirectory)
}

/// If any item in pComponent exists in pProduction in pNamespace
///  then create pDirectory, if not already there
/// pDirectory is relative to the system installation directory
ClassMethod CreateDataDirectoryNew(pNamespace As %String, pProduction As %String, pComponent As %String, pDirectory As %String) As %Status
{
 new $namespace
 set $namespace=pNamespace
 Set tSC=$$$OK
 do {
	set tProductionObj=##class(Ens.Config.Production).%OpenId(pProduction,,.tSC) Quit:$$$ISERR(tSC)
	set found=0 for i=1:1:$l(pComponent,",") {
		set tComponent=$p(pComponent,",",i)
		if $IsObject(tProductionObj.FindItemByConfigName(tComponent)) set found=1 quit
	}
	Quit:'found
	Set tSC=##class(HS.Util.SystemAPI).Invoke("CreateDirectoryChain",pNamespace,pDirectory)
 } while (0)
 quit tSC
}

ClassMethod MapHSSYSForNamespace(pNS, pActivate = 0) As %Status
{
	try {
		Set tSC=$$$OK
		Set tTarget = "IRISSYS"
		do ..AddGlobalMappings("",pNS,"%SYS",tTarget)
		do ..DeleteGlobalMappings("",pNS,"HS.XF.*")
		do ..AddGlobalMappings("",pNS,"%SYS(""HealthShare""),OAuth2.*","HSSYS")
		Set tComponent = ##class(HS.Util.Installer.ConfigItem).%OpenId(pNS,0)
		If $isObject(tComponent) && (tComponent.%ClassName(1)'="HS.Util.Installer.Foundation") {
			/// Don't map items for foundation namespaces, HS.AuditAlertQueue otherwise can't send to different repositories
			do ..AddGlobalMappings("",pNS,"HS.AuditQueue,HS.AuditAlertQueue","HSSYS")
			// Call Sync Mapping for every non-Foundation namespace to make sure mappings are up to date.
			Set tSC = ##class(HS.Sync.Utils).Mapping(pNS,0)
		}
		If pNS="HSLIB" {
			do ..AddGlobalMappings("","HSLIB","ZEN.BackgroundStatus","HSSYS")
			/// map for /csp/hslib application to work
			Set tSC = ##class(HS.Sync.Utils).Mapping("HSLIB",0)
		}
		Do:pActivate ..ActivateConfiguration(,pNS)
	} Catch ex {
		Set tSC= ex.AsStatus()
	}
	Quit tSC
}

ClassMethod MapHSCUSTOMForNamespace(pNS, pActivate = 0) As %Status
{
	try {
		Set tSC=$$$OK
		Set tSC=..AddClassMappings("",pNS,"HS.Local","HSCUSTOM")
		Quit:$$$ISERR(tSC)
		Do:pActivate ..ActivateConfiguration(,pNS)
	} Catch ex {
		Set tSC= ex.AsStatus()
	}
	Quit tSC
}

/// Use $$$CheckComponentStatus("VIEWER") or $$$ValidateComponentStatus("VIEWER")
/// Moved to %ZHSLIB.HealthShareMgr
ClassMethod ComponentStatus(pComponent = "", pLicensed = 1, pRevalidate = 0) As %Boolean [ Internal ]
{
	Quit ##class(%ZHSLIB.HealthShareMgr).ComponentStatus(pComponent,pLicensed,pRevalidate)
}

/// Delete all Tasks for the namespace
ClassMethod DeleteTasks(pNamespace)
{
	Set tSC=##class(HS.Util.SystemAPI).Invoke("DeleteTasks",pNamespace,pNamespace)
}

/// Log a message to the InstallLogFile and/or to the Terminal
/// pLogFile - file to write log into
///   undefined = not open, try to open $$$InstallLogFile
///   "" = do not log
///   0 = log only to terminal
///   oref = open logfile (append mode)
/// pClass = 0 means close log 
ClassMethod Log(ByRef pLogFile As %File, pClass As %String, pMethod As %String, pText As %String)
{

 new $namespace
 // Just close ?
 if $g(pClass)=0 do:+$g(pLogFile) pLogFile.Close() quit

 // Make logfile object pLogFile
 if '$d(pLogFile) {
	 //Shifting to HealthShareLocal to allow log to happen on non-primary mirror member
	 //otherwise would get <PROTECT> error incrementing log # in ^%SYS("HealthShare")
	 If '$D(^%SYS("HealthShareLocal","Log")) Set ^%SYS("HealthShareLocal","Log")=$G(^%SYS("HealthShare","Log"))
	 Set tFile=$system.Util.ManagerDirectory()_"HS.Util.Installer."_$I(^%SYS("HealthShareLocal","Log"))_".log"
	 set tFile=##class(%File).NormalizeFilename(tFile)
	 set pLogFile=##class(%File).%New(tFile)
 }

 // Try to (re-)open if not open
 if +pLogFile,'pLogFile.IsOpen {
	 do pLogFile.Open("WSA",2) // try for 2 seconds
	 if 'pLogFile.IsOpen {
		write !,"Cannot open logfile ",pLogFile.Name
		set pLogFile=0}}

 // Write message to logfile and/or terminal
 set tLine=pClass_":"_pMethod_" "_pText
 if +pLogFile do pLogFile.WriteLine($zt($p($h,",",2),1)_" "_tLine)
 if $l(pLogFile) write !,tLine
 If $G(%HSBackgroundLog) {
	 Set $Namespace="HSLIB"
	 Do ##Class(HS.UI.Installer.Activate).%SetBackgroundMethodStatus(tLine)
 }
 quit
}

/// Setup permissions ...
ClassMethod SetupPermissions(pNamespace As %String = {$namespace}, pRole As %String) As %Status
{
	Quit ##class(HS.Util.SystemAPI).Invoke("SetupPermissions",pNamespace,pNamespace,pRole)
}

/// Import a file (or directory)
ClassMethod Import(pNamespace As %String, pTarget As %String, pWildCards As %String = "*.*", pFlags As %String = "", pIgnoreErrors As %Integer = 0)
{
	New $namespace
	Set $namespace=pNamespace
	if ##class(%File).DirectoryExists(pTarget) {
		set tSC = $system.OBJ.ImportDir(pTarget,pWildCards,pFlags)
	} else {
		set tSC = $system.OBJ.Load(pTarget,pFlags)
	}
	if $$$ISERR(tSC) {
		if 'pIgnoreErrors throw ##class(%Exception.StatusException).CreateFromStatus(tSC)
	}
}

/// Add a list of global mappings of specified type
/// Adds them to the current configuration, but does not activate
/// pNamespace is the current namespace being configured, where the globals are to be used
/// pAddList is a comma-list of global specs, like "A,B:(""sub"")",C"
/// pFrom is the database containing the globals
/// The mappings are assumed to not exist, use DeleteGlobalMappings to remove them first
/// The first argument is no longer used
/// pSetCollation is set to force Collation of the mapping to use the new global collation for the pFrom database
/// This is needed for some SLM (Subscript Level Mapping) cases, such as ^OBJ.DSTIME
ClassMethod AddGlobalMappings(pDummy, pNamespace As %String, pAddList As %String, pFrom As %String, pSetCollation As %Boolean = 0)
{
	Quit ##class(HS.Util.SystemAPI).Invoke("AddGlobalMappings",pNamespace,pNamespace,pAddList,pFrom,pSetCollation)
}

/// Remove a list of global mappings
/// The first argument is no longer used
ClassMethod DeleteGlobalMappings(pDummy, pNamespace As %String, pDeleteList As %String = "")
{
	Quit ##class(HS.Util.SystemAPI).Invoke("DeleteGlobalMappings",,pNamespace,pDeleteList)
}

/// Export and Activate a configuration
/// first argument is no longer used
ClassMethod ActivateConfiguration(pDummy, pNS = {$namespace})
{
	Set tSC=##class(HS.Util.SystemAPI).Invoke("ActivateConfiguration",pNS,pNS)
	if $$$ISERR(tSC) throw ##class(%Exception.StatusException).CreateFromStatus(tSC)
}

ClassMethod CheckGetKey() As %Integer
{
 set done=""
 while done="" {
	if $system.License.KeyOrderNumber() set done=1 quit  // has license
	write !!,"Your system has no (valid) license key present"
	write !,"Copy the 'iris.key' file into "_$system.Util.ManagerDirectory()
	write !," and then enter 'y' below"
	write !,"Or enter 'q' below to quit"
	read !,"Action >",a
	set a=$zcvt(a,"L") if "q"[a set done=0 quit
	if a="y" do $system.License.Upgrade()
 }
 //
 quit done
}

ClassMethod StandardGlobalMapping()
{
	Set add="IRIS.Msg:(""HS"")" _
			",IRIS.Msg:(""HSErr"")" _
			",IRIS.MsgNames:(""HS"")" _
			",IRIS.MsgNames:(""HSErr"")" _
			",IRIS.Msg:(""HSFHIRErr"")" _
			",IRIS.MsgNames:(""HSFHIRErr"")" _
			",IRIS.Msg:(""HSFHIRXErr"")" _
			",IRIS.MsgNames:(""HSFHIRXErr"")" _
			",EnsHL7.Annotation:(""HealthShare_2.5"")" _
			",EnsHL7.Schema:(""HealthShare_2.5"")" _
			",EnsHL7.Description:(""HealthShare_2.5"")" _
			",SchemaMap.*"
	Quit add
}

}
