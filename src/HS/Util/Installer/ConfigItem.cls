Include (HS.HC, HS.HC.Invoke)

/// A HealthShare configuration item
Class HS.Util.Installer.ConfigItem Extends (%Persistent, %XML.Adaptor, HS.Util.DataModel.Adaptor, HS.Util.Installer.AbstractConfigItemType) [ Inheritance = right ]
{

Parameter RESOURCE As STRING = {$$$HSInstallationManagement};

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

/// Type is set in the sub-classes, and used here as default for the Type property
Parameter TYPE As %String;

Parameter ClassMappingList = "HS,Test";

/// Where to locate the sample template definitions, ie Hub HS.Sample.Production.Hub (to get all items under that package)
Parameter SAMPLETEMPLATES;

/// Used in components to define the code database name where to locate sample templates
Parameter CODEDATABASE = "HSLIB";

/// Use the "HS" domain for localization.
Parameter DOMAIN = "HS";

/// Parameter that controls the relative importance of this component type in 
/// the HealthShare Home UI for selecting namespaces.
/// Lower values indicate components that should appear earlier in the UI.
/// The value is used as the default return value for the 
/// <method>GetConfigTypeUITier</method>() helper method.
Parameter UITIER As INTEGER = 10;

/// HSLIB
Property %HSLIB As %String [ InitialExpression = "HSLIB", Required ];

/// Time this config item was created
Property CreatedAt As %TimeStamp [ InitialExpression = {$ZDT($H,3)}, Required ];

/// Item name (also the namespace name)
Property Name As HS.Types.ComponentName [ Required ];

/// HealthShare network wide unique name<br />
/// The HSComponentName should be no longer than 320 characters (255 for Max FQDN, 64 for Max namespace length, plus 1 for colon)
Property HSComponentName As %String(MAXLEN = 320);

/// Type
Property Type As %String(DISPLAYLIST = ",Hub,Edge Gateway,Access Gateway,Flash Gateway,Bus,Foundation", MAXLEN = 12, VALUELIST = ",Hub,EdgeGateway,AccessGateway,FlashGateway,Bus,Foundation") [ InitialExpression = {..#TYPE}, Required ];

/// Production template
Property Template As %String(MAXLEN = 128);

/// Production name
Property Production As %String(MAXLEN = 128);

/// Activated status
Property Activated As %Boolean [ InitialExpression = 0 ];

/// Time this config item was last Activated (if at all)
Property LastActivated As %TimeStamp;

/// Name index to ensure uniqueness
Index NameIdx On Name [ IdKey, Unique ];

/// Description of this item
Property Description As %Text.Text;

/// Disabled flag
Property Disabled As %Boolean [ InitialExpression = 0 ];

Property Products As list Of %String;

/// One production in the federation, either the registry (default) or an edge,
/// is designated as the controller for the audit database.
/// The audit consolidation service runs there for alerts, and external ATNA inbound and outbound
/// services and operations run there.  
Property AuditProduction As %Boolean;

/// When not set, the database will be placed in the manager directory
Property DatabaseLocation As %String(MAXLEN = "");

/// Enumerate all configuration items
Query Configuration() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,Name,Type,CreatedAt,Description,Production,Activated,LastActivated,Disabled FROM ConfigItem
 ORDER BY Type, Name
}

/// The GetStored method of properties in persistent classes is designed (and documented) to
///  return an error if the referenced object instance does not exist.
/// This method works around that by returning "" in that case.
ClassMethod GetPropertyValue(pID = "", pPropertyName As %String = "", Output pSC As %Status) As %String
{
	set pSC=$$$OK,tValue=""
	try {
		set tValue=$zobjclassMethod(..%ClassName(1),pPropertyName_"GetStored",pID)
	} catch {
		set pSC=$$$ERROR($$$ObjectScriptError,$ze)
	}
	quit tValue
}

/// Mark this config item as being activated
/// Also saves any changed values
Method MarkActivated(pValue As %Boolean = 1) As %Status
{
	set ..Activated=pValue
	set ..LastActivated=$zdt($h,3)
	set tSC=..%Save()
	quit tSC
}

/// Open the configuration object pComponent with name pName
/// If it does not exist (an pCreate is set) then create an object of the specified type,
///  using any Settings provided and some (but not all) defaults
/// pHSLIB argument is not used - it's an ancient leftover
ClassMethod GetComponentByName(pName As %String, ByRef pComponent As HS.Util.Installer.ConfigItem, pCreate As %Boolean = 0, pType As %String = "", pHSLIB As %String = "HSLIB", ByRef pSettings) As %Status
{
	new $namespace
	set tSC=$$$OK,$ZT="Trap"
	do {
		Set pComponent = ""
		// Component names should be uppercase
		New $Namespace Set $Namespace="HSLIB"
		set pName=$ZCVT(pName,"U")
		&sql(SELECT ID INTO :tID FROM HS_Util_Installer.ConfigItem 
			WHERE Name=:pName)
		if SQLCODE=0 {
			// Found it ...
			set pComponent=..%OpenId(tID,,.tSC)
			Quit:$$$ISERR(tSC)
			Quit:pType=""
			Quit:(pType="Foundation" && (pComponent.%Extends("HS.Util.Installer.Foundation")))
			If ($classname(pComponent) = ("HS.Util.Installer."_pType)) || (pComponent.GetConfigTypeName() = pType) || ($classname(pComponent) = pType) {
				Quit
			}
			set tSC = $$$HSError($$$HSErrComponentWrongType,pName,pType)
			quit
		} elseIf SQLCODE=100 {
			// Not found ...
			if pCreate {
				If $G(pSettings("FoundationTypeClass")) ] "" {
					set tClass=pSettings("FoundationTypeClass")
				}
				ElseIf $G(pSettings("FoundationType"))]"" {
					set tClass="HS.Util.Installer."_pSettings("FoundationType")
				} Else {
					set tClass="HS.Util.Installer."_pType
				}
				if ##class(%Dictionary.CompiledClass).%ExistsId(tClass) {					
					if $classmethod(tClass,"%IsA","HS.Util.Installer.ConfigItem") {					
						set pComponent=$ZOBJCLASSMETHOD(tClass,"%New")
						set pComponent.Name=pName
						set pComponent.%HSLIB="HSLIB"
						//set pComponent.Production=pName_"."_pType_"Production"
						set pComponent.Production=pComponent.GetProductionName()
						// Apply any settings
						if $d(pSettings) {
							set tSetting="" for {
								set tSetting=$ORDER(pSettings(tSetting)) quit:tSetting=""
								try {
									set $ZOBJPROPERTY(pComponent,tSetting)=pSettings(tSetting)
								} Catch {}
							}
						}						
						set tSC = pComponent.%Save()
					}
					else {
						set tSC = $$$ERROR($$$HSErrComponentWrongType, pName, tClass)
					}
				} else {
					set tSC = $$$HSError($$$HSErrUnknownComponentType,tClass)
				}
			} else {
				set tSC = $$$HSError($$$HSErrComponentDoesNotExist,pName)
			}
		} else {
			// Some other error ...
			Set tSC = $$$ERROR($$$SQLError,SQLCODE,$G(%msg))
		}
	} While (0)
Exit
	quit tSC
Trap
	Do LOG^%ETN
	set tSC = $$$ERROR($$$ObjectScriptError,$ZE)
	goto Exit
}

/// This can be called from a running production to get the component name.
/// By Default, the component name is the same as the namespace.
/// In 2008.1, this was only sort-of findable, on edge gateways, as a setting on
/// HS.Gateway.HSWS.WebServices
/// Starting with 2008.2, there's a setting on the sample productions where this
/// will really live.
ClassMethod GetThisComponentName() As %String
{
	Set tConfig=..%OpenId($ZNSPACE)
	Quit $Select('$isObject(tConfig):$ZNSPACE,tConfig.HSComponentName="":$ZNSPACE,1:tConfig.HSComponentName)
}

ClassMethod SetThisComponentName(pHSName As %String) As %Status
{
	Set tConfig=..%OpenId($ZNSPACE)
	Set tConfig.HSComponentName=pHSName
	Quit tConfig.%Save()
}

/// Return the subclass of <class>%ZHSLIB.AbstractInstaller</class> that should be called
/// to perform HealthShare installer-related activities.
ClassMethod GetInstallerClass(ByRef pVars, pProduct As %String = "") As %Dictionary.Classname [ Internal ]
{
	Quit "Installer.Install"
}

/// Return the database from which installer-related activities should be performed.
ClassMethod GetInstallerDatabase(ByRef pVars, pProduct As %String = "") As %String [ Internal ]
{
	Quit "HSLIB"
}

/// Helper method to return whether a given namespace type is in the Health Connect code
/// base or in the larger HealthShare application.
ClassMethod IsFoundationConfigType() As %Boolean [ Internal ]
{
	Quit 1
}

/// Helper method to return the default CSP SessionEvents class that should be 
/// added to user-facing CSP applications for this ConfigItem type.
ClassMethod GetDefaultCSPSessionEventsClass() As %String [ CodeMode = expression ]
{
""
}

/// Helper method to return the default CSP SessionEvents class for a given namespace.
ClassMethod GetDefaultCSPSessionEventsClassForNamespace(pNamespace As %String) As %String
{
	// We're only using this value temporarily to get a handle on the specific subclass
	// so use concurrency of 0 to avoid all locking
	Set tConfigItem = ##class(HS.Util.Installer.ConfigItem).%OpenId(pNamespace,0,.tSC)
	$$$ThrowOnError(tSC)
	Quit tConfigItem.GetDefaultCSPSessionEventsClass()
}

/// Helper method to return the default CSP Custom Login page that should be 
/// added to user-facing CSP applications for this ConfigItem type.
ClassMethod GetDefaultCSPCustomLoginPage() As %String [ CodeMode = expression ]
{
""
}

/// Helper method to return the default CSP Custom Login page for a given namespace.
ClassMethod GetDefaultCSPCustomLoginPageForNamespace(pNamespace As %String) As %String
{
	// We're only using this value temporarily to get a handle on the specific subclass
	// so use concurrency of 0 to avoid all locking
	Set tConfigItem = ##class(HS.Util.Installer.ConfigItem).%OpenId(pNamespace,0,.tSC)
	$$$ThrowOnError(tSC)
	Quit tConfigItem.GetDefaultCSPCustomLoginPage()
}

/// Helper method to update the Custom Login Page for a given CSP Application.
/// By default, if a login page does not already exist, the newly provided
/// one won't be assigned. This behavior can be overriden by setting
/// <var>pOverrideExisting</var> to 1. <br />
ClassMethod UpdateLoginPageForCSPApplication(pApplicationName As %String, pLoginPage As %String, pOverrideExisting As %Boolean = 0) As %Status [ Internal ]
{
	#dim ex As %Exception.AbstractException
	Set sc = $$$OK
	Try {
		Set initNamespace = $Namespace
		New $Namespace
		Set $Namespace = "%SYS"
		If ##class(Security.Applications).Exists(pApplicationName, .appObj, .sc) {
			$$$ThrowOnError(sc)
			Set loginPage = appObj.LoginPage
			// Only set to provided login page if one doesn't exist OR
			// specifically asked to override
			If (loginPage = "") || pOverrideExisting {
				Set properties("LoginPage") = pLoginPage
				Set $Namespace = "HSSYS"
				Set sc = ##class(HS.Util.SystemAPI).Invoke("UpdateCSPApp", initNamespace, pApplicationName, $$$NVPairToList(properties))
				$$$ThrowOnError(sc)
			}
		}
		$$$ThrowOnError(sc)
	} Catch ex {
		Set sc = ex.AsStatus()
	}
	Return sc
}

Method GetPackageName() As %String [ ForceGenerate ]
{
	try {
		Set tName=..Name
		If $L(tName)>32 Set tName="Default" Quit
		Set tName=$TR(tName,"%_-","pud")
	} catch ex {
		Set tName="Default"
	}
	Quit tName_"PKG"
}

Method GetProductionName() As %String [ ForceGenerate ]
{
	Set tClass = ..%ClassName(0)
	If $E(tClass,$l(tClass)-2,$l(tClass))="LIB" {
		Set tProduction=$p(tClass,"LIB")_"Production"
	} Else {
		Set tProduction = tClass_"Production"
	}
	
	Quit ..GetPackageName()_"."_tProduction
}

ClassMethod CheckPrivileges(ByRef pLogFile) As %Status
{
	Set tSC = $$$OK
	// First check we have %Admin_Manage:USE privilige, else we won't get far
	if '$System.Security.Check("%Admin_Manage","Use") {
		write !!,"You need to have %Admin_Manage:USE privilege to run this"
		write !,"For example, add the role %All to your $username"
		write !
		do ##class(HS.HC.Util.Installer).Log(.pLogFile,$Classname(),"Install","User '" _ $username _ "' does not have the %Admin_Manage:USE privilege, but attempted to perform an install")
		set tSC=$$$HSError($$$HSErrNotEnoughPrivilege,"%Admin_Manager:USE")
		throw ##class(%Exception.StatusException).CreateFromStatus(tSC)
	}
	do ##class(HS.HC.Util.Installer).Log(.pLogFile,$Classname(),"Install","User '" _ $username _ "' has %Admin_Manage:USE privilege")
	Quit tSC
}

/// Saves Marker handled by OnProductionStart handler to perform actions that require a running Production
ClassMethod AddDeferredAction(pNamespace As %String, actionName As %String, value As %List)
{
	Set ^%SYS("HealthShare","DeferredActions", pNamespace, actionName ) = value
}

ClassMethod HasDeferredActions(pNamespace As %String)
{
	Quit $D(^%SYS("HealthShare","DeferredActions", pNamespace ))'<10
}

ClassMethod GetDeferredAction(pNamespace As %String, actionName As %String) As %List
{
	Quit $G(^%SYS("HealthShare","DeferredActions", pNamespace, actionName ))
}

ClassMethod ClearDeferredActions(pNamespace)
{
	Kill ^%SYS("HealthShare","DeferredActions", pNamespace )
}

/// Build CSP application
ClassMethod BuildPortalApp(pNamespace, ByRef pLogFile, pAddRoles As %String = "") As %Status
{
	try {
		Set tInitialNS=$namespace
		New $namespace
		Set tSC = $$$OK
		Set DBResource=..GetDBResourceName(pNamespace)
		Set $Namespace="HSLIB"
		Set tHSRole = "%HS_"_$e(DBResource,2,*)
		Set tCSPRoles=tHSRole_",%DB_HSLIB,%HS_DB_HSSYS,%DB_HSCUSTOM"
		Set tSC = ..CreateCSPRoles(tCSPRoles) Quit:$$$ISERR(tSC)
		Set:pAddRoles'="" tCSPRoles=tCSPRoles_","_pAddRoles
		Set tCSPSessionEventsClass = ##class(HS.Util.Installer.ConfigItem).GetDefaultCSPSessionEventsClassForNamespace(pNamespace)
		Set tNsp=$tr($zcvt(pNamespace,"L"),"%")
		Set tURL="/csp/healthshare/"_tNsp,tServiceURL=tURL_"/services"
		// Note: This does not update an existing application !
		Set tSC = ##class(HS.Util.SystemAPI).Invoke("CreateCSPApp",pNamespace,1,tURL,$tr(pNamespace,"%"),..CSPPath(tNsp),"HealthShare Foundation Portal",tCSPRoles,"/csp/healthshare",,tCSPSessionEventsClass)
		$$$ThrowOnError(tSC)
		// Only for new installs. Upgrades are handled in an upgrade step
		Set tSC = ..UpdateLoginPageForCSPApplication(tURL, ..GetDefaultCSPCustomLoginPage())
		$$$ThrowOnError(tSC)
		Set tSC = ##class(HS.Util.SystemAPI).Invoke("CreateCSPApp",pNamespace,0,tServiceURL,$tr(pNamespace,"%"),..CSPPath(tNsp),"HealthShare Foundation Services",tCSPRoles,"/csp/healthshare",,,1)
		$$$ThrowOnError(tSC)
		do ##class(HS.HC.Util.Installer).Log(.pLogFile,$ClassName(),"Install","Created Portal CSP app")
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Returns 1 if a web application with the give name exists. <br />
ClassMethod WebAppExists(pWebAppName As %String) As %Boolean
{
	New $Namespace
	Set $Namespace = "%SYS"
	Return ##class(Security.Applications).Exists(pWebAppName)
}

/// Create a web application to serve Angular UI (i.e. static files).
/// Only the minimum set of properties that are unique to web apps are
/// explicitly in the method signature. Any properties that should be set,
/// are set to their appropriate defaults for this use case. <br />
/// If the web app already exists, this method is a no-op. <br />
/// Returns as output, whether or not the web app already exists. <br />
/// Throws errors. <br />
/// @Argument	pName			Name of web application. <br />
/// @Argument	pNamespace		The namespace where pages for this application are run. <br />
/// @Argument	pPath			The physical path (directory) for the static files to be served. <br />
/// @Argument	pProperties		Name-value pair array of additional properties. <br />
/// @Argument	pFound			Boolean flag set to true if the web app already exists. <br />
ClassMethod CreateWebApplicationForUI(pName As %String, pNamespace As %String, pPath As %String, ByRef pProperties, Output pFound As %Boolean) [ Internal ]
{
	Set pFound = 0
	If ..WebAppExists(pName) {
		// Web app already exists. No-op
		Set pFound = 1
		Return
	}
	
	// Validation of method parameters
	
	// Ensure path is a full physical path. Not a relative one
	#define Slash $Case($$$isWINDOWS, 1: "\", : "/")
	If ($Extract(pPath, 1) = $$$Slash)  {
		Set pPath = $System.Util.InstallDirectory() _ $Extract(pPath, 2, *)
	}
	Set pPath = ##class(%Library.File).NormalizeDirectory(pPath)
 	If '##class(%Library.File).DirectoryExists(pPath) {
		Set success = ##class(%Library.File).CreateDirectoryChain(pPath)
		If 'success {
			$$$ThrowStatus($$$ERROR($$$GeneralError, "Failed to create directory for path: "_pPath))
		}
 	}
	
	// Defaults
	
	// Unauthenticated only because authentication is determined by REST calls
	Set props("AutheEnabled") = $$$AutheUnauthenticated
	// Only to be set for SOAP web services (which this is not)
	Set props("InbndWebServicesEnabled") = 0
	Set props("NameSpace") = pNamespace
	Set props("Path") = pPath
	// Always and cached so that IRIS server doesn't need to keep requesting static files
	Set props("ServeFiles") = 2
	// NEVER use CSP session cookie. Non-zen UI will never use CSP sessions.
	Set props("UseCookies") = 0
	
	// Override with contents of pProperties
	Merge props = pProperties
	
	// Create web app
	Set sc = ##class(HS.Util.SystemAPI).Invoke("CreateWebApplication", pNamespace, pName, $$$NVPairToList(props))
	$$$ThrowOnError(sc)
}

/// Create a web application to serve a REST API.
/// Only the minimum set of properties that are unique to web apps are
/// explicitly in the method signature. Any properties that should be set,
/// are set to their appropriate defaults for this use case. <br />
/// If the web app already exists, this method is a no-op. <br />
/// Returns as output, whether or not the web app already exists. <br />
/// Throws errors. <br />
/// @Argument    pName            Name of web application. <br />
/// @Argument    pNamespace        The namespace where pages for this application are run. <br />
/// @Argument    pDispatchClass    The subclass of %CSP.REST to dispatch all incoming requests to. <br />
/// @Argument    pProperties        Name-value pair array of additional properties. <br />
/// @Argument    pFound            Boolean flag set to true if the web app already exists. <br />
ClassMethod CreateWebApplicationForREST(pName As %String, pNamespace As %String, pDispatchClass As %String, ByRef pProperties, Output pFound As %Boolean) [ Internal ]
{
    Set pFound = 0
    If ..WebAppExists(pName) {
        // Web app already exists. No-op
        Set pFound = 1
        Return
    }
    
    // Validation of method parameters
    
    Set initNamespace = $Namespace
    If ##class(%SYS.Namespace).Exists(pNamespace) {
	    New $Namespace
	    Set $Namespace = pNamespace
	    If '##class(%Dictionary.CompiledClass).%ExistsId(pDispatchClass) {
	        $$$ThrowStatus($$$ERROR($$$GeneralError, "Dispatch class "_$$$QUOTE(pDispatchClass)_" does not exist in namespace "_$Namespace))
	    }
	    Set $Namespace = initNamespace
    }
    
    // Defaults
    
    // Needs unauthenticated for OAuth support of making calls to /auth endpoints
    Set props("AutheEnabled") = $$$AutheUnauthenticated + $$$AutheCache + $$$AutheDelegated
    Set props("DispatchClass") = pDispatchClass
    // Only to be set for SOAP web services (which this is not)
    Set props("InbndWebServicesEnabled") = 0
    Set props("NameSpace") = pNamespace
    // Standard set of roles for any HS application namespace web app. These are the minimum set of roles
    // any user entering the app should get
	// All roles (Matching or otherwise) are passed in via MatchRoles
	Set props("MatchRoles") = ..FormattedCSPRolesForCoreNamespace(pNamespace, 1)
	// NEVER use CSP session cookie. Non-zen UI will never use CSP sessions.
	Set props("UseCookies") = 0
    
    // Override with contents of pProperties
    Merge props = pProperties
    
    // Create web app
    Set sc = ##class(HS.Util.SystemAPI).Invoke("CreateWebApplication", pNamespace, pName, $$$NVPairToList(props))
    $$$ThrowOnError(sc)
}

ClassMethod CSPRolesForCoreNamespace(pNamespace As %String, pIncludeIRISSYS As %Boolean = 0) As %String
{
	// Reasoning behind each of the roles
	// - %HS_DB_<namespace>: SQL access to tables in this namespace
	// - %DB_HSLIB: Access to code in HSLIB. Needed because code is mapped from here
	// - %HS_DB_HSSYS: SQL access to tables in HSSYS which stores HS configuration data (such as registries)
	// - %DB_HSCUSTOM: Access to code in HSCUSTOM. Needed because HS.Local is mapped form here
	// - %DB_IRISSYS: Access to code in IRISSYS. Needed to access %Z* classes
	Quit "%HS_DB_"_$TR(pNamespace,"-_%","DU")_",%DB_HSLIB,%HS_DB_HSSYS,%DB_HSCUSTOM"_$Case(pIncludeIRISSYS, 1: ",%DB_IRISSYS", : "")
}

/// Returns a set of roles output by CSPRolesForCoreNamespace(), but formatted such that 
/// they can be used in the MatchRoles property of Security.Applications:Create()
/// The output is in the format :role1:role2:role3  <br />
/// @Argument	pNamespace	The namespace where the roles will be used. <br />
ClassMethod FormattedCSPRolesForCoreNamespace(pNamespace, pIncludeIRISSYS As %Boolean = 0) As %String
{
	set formattedRoles = ""
	set coreRoles = ..CSPRolesForCoreNamespace(pNamespace, pIncludeIRISSYS)
    for index = 1:1:$LENGTH(coreRoles, ",") {
		set role = $PIECE(coreRoles, ",", index)
		if role '="" {
			set formattedRoles = formattedRoles_":"_role
		}
	}
	
	return formattedRoles
}

ClassMethod UpdateClassMappings(pNamespace, pHSLIB, pOldList = "", pNewList = "")
{
	Set:pOldList="" pOldList = ..#ClassMappingList
	Set:pNewList="" pNewList = ..#ClassMappingList
	Do ##class(HS.HC.Util.Installer).DeleteClassMappings(,pNamespace,pOldList)	
	Do ##class(HS.HC.Util.Installer).AddClassMappings(,pNamespace,pNewList,pHSLIB)
	Quit $$$OK
}

ClassMethod GetDBResourceName(pNamespace As %String = "", ByRef tSC = {$$$OK}) As %String
{
	Set tResource=""
	try {
		New $namespace
		Set $Namespace="%SYS"
		Set tCfgNS=##Class(Config.Namespaces).Open(pNamespace)
		Set tCfgDB = ##class(Config.Databases).Open(tCfgNS.Globals)
		Set tObjDB=##class(SYS.Database).%OpenId(tCfgDB.Directory)
		Set tResource=tObjDB.ResourceName
	} catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tResource
}

ClassMethod CreateCSPRoles(pNames) As %Status
{
	Set tSC=$$$OK
	For i=1:1:$l(pNames,",")
	{
		Set tName=$p(pNames,",",i)
		Set tResourceDB = $p(tName,"_",3)
		Continue:tResourceDB=""  // we're only processing ones like %HS_DB_someDatabase
		Set tResource = "%DB_"_tResourceDB_":RWU"
		Set tSC=##class(HS.Util.SystemAPI).Invoke("AddUpdateRole",tResourceDB,tName,"",tResource)
		Quit:$$$ISERR(tSC)
	}
	Quit tSC
}

ClassMethod CreateNavigationApp() As %Status
{
	// This HCInvoke is necessary because things can be multi-threaded during setup. 
	// The call uses a keyword "SetupNavCSPApp" which is defined in HS.Invoke.mac, and 
	// resolves to a call to ##class(HS.UI.Navigation.Installer).SetUpCSPApp(). 
	$$$HCInvoke(tSC,$$$OK,"SetupNavCSPApp")
	$$$ThrowOnError(tSC)
}

ClassMethod CreateHSAUDIT() As %Status
{
	try {
		new $namespace
		Set tSC = $$$OK
		Set tDBName = "HSAUDIT"
		Set $Namespace="%SYS"
		Quit:##class(Config.Databases).Exists(tDBName)
		Set $namespace="HSLIB"
		// Create the IRIS.DAT (if not already there)
		Set tSC=##class(HS.Util.SystemAPI).CreateDatabase(tDBName) Quit:$$$ISERR(tSC)
		do ##class(HS.HC.Util.Installer).Log(.pLogFile,$classname(),"Install","Create "_$$$DatabaseFilename_" in "_tDBName)
	} catch ex {
		Set tSC = ex.AsStatus()
	} 
	Quit tSC
}

// only used for UnInstallAll

ClassMethod DeleteHSAUDIT() As %Status
{
	Quit ##class(HS.Util.SystemAPI).Invoke("DeleteDatabase","HSAUDIT","HSAUDIT")
}

/// Called for install of hub or edge, where that has been specified as the audit production
ClassMethod MapAllAuditDB() As %Status
{
	try {
		Set tSC=$$$OK
		Quit:'$$$IsAuditInstance(tDB)
		Set tSC=..MapAuditDB("HSSYS",tDB) Quit:$$$ISERR(tSC)
		Set tNS=""
		For {
			Set tNS=$O(^%SYS("HealthShare","Instances",tNS)) Quit:tNS=""
			Continue:'..ExistsNS(tNS)
			If $system.Mirror.IsMember() Continue:'..MirrorCheck(tNS)
			Set tSC=..MapAuditDB(tNS,tDB) Quit:$$$ISERR(tSC)
		}
	} Catch ex {
		Set tSC= ex.AsStatus()
	}
	Quit tSC
}

ClassMethod MirrorCheck(pNS) As %Boolean
{
	New $Namespace Set $Namespace = "%SYS"
	Set tRS = ##class(%ResultSet).%New()
	Set tRS.ClassName = "SYS.Mirror"
	Set tRS.QueryName = "MirroredDatabaseList"
	Set tSC = tRS.Execute("HSSYS,"_pNS)
	$$$ThrowOnError(tSC)
	Set tGotHSSYS = 0, tGotNS = 0
	// In case the input is lowercase
	Set tUpperNS = $ZCVT(pNS,"U")
	While tRS.Next(.tSC) {
		$$$ThrowOnError(tSC)
		Set tMirroredDBName = tRS.%Get("Name")
		Set tMirroredDBName = $ZCVT(tMirroredDBName,"U")
		If (tMirroredDBName = "HSSYS") {
			Set tGotHSSYS = 1
		} ElseIf (tMirroredDBName = tUpperNS) {
			Set tGotNS = 1
		}				
	}
	$$$ThrowOnError(tSC)
	Set tSC = tRS.Close()
	$$$ThrowOnError(tSC)
	If tGotHSSYS,'tGotNS Quit 0  //don't map a non mirror database to HSAUDIT if HSSYS is mirrored
	Quit 1
}

ClassMethod MapAuditDB(pNamespace, pAuditDB) As %Status
{
	try {
		Set tSC=$$$OK
		Quit:pAuditDB=pNamespace
		do ##class(HS.HC.Util.Installer).AddGlobalMappings("",pNamespace,"HS.IHE.Audit,OBJ.DSTIME:(""HS.IHE.ATNA.Repository.Aggregation"")",pAuditDB,1)
	} Catch ex {
		Set tSC= ex.AsStatus()
	}
	Quit tSC
}

/// This is a wrapper method that call Invoke to Update the roles for a CSPSystem User 
ClassMethod SetCSPSystemUserRoles(pNamespace As %String) As %Status [ Internal ]
{
	Set tSC = $$$OK
	Try {
		Set tCSPSystemUserRole = $ListBuild("%DB_"_pNamespace)
		Set tSC = ##class(HS.Util.SystemAPI).Invoke("UpdateUserRoles", pNamespace, "CSPSystem", tCSPSystemUserRole)
		$$$ThrowOnError(tSC)
		
		// Close CSP gateway connections  in order to update the user after roles have been updated
		#dim tReg As %CSP.Mgr.GatewayRegistry
		#dim tMgrs As %ListOfObjects
		#dim tMgr As %CSP.Mgr.GatewayMgr
		Set tReg = $System.CSP.GetGatewayRegistry()
		Set tMgrs = tReg.GetGatewayMgrs()
		
		For i = 1:1:tMgrs.Count() {
			Set tMgr = tMgrs.GetAt(i)
			// Deliberately ignore returned status because it could be 0 (bug in IRIS as of 2020.1)
			// This is due to a bug in %CSP.Mgr.GatewayMgrImpl:SendUpdateCmd()
			// No harm in ignoring. Can always restart the instance if needed to restart the CSP
			// gateway connections
			Do tMgr.CloseConnections()
		}
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

/// Helper method to support returning a display name for the ConfigItem type.
/// <var>pLocalize</var> controls whether the returned value should be localized.
/// Note that localization should be implemented in subclasses.
ClassMethod GetConfigTypeName(pLocalize As %Boolean = 0) As %String [ Internal ]
{
	Quit ..#TYPE
}

/// Helper method to indicate whether the current user is permitted to access
/// the details for the specified namespace based on their current roles.
/// The default requirement is for USE permissions on the general
/// <code>%Admin_Manage</code> resource.
ClassMethod CheckUISecurityResources(pNamespace As %String = "") As %Boolean [ Internal ]
{
	Quit $system.Security.Check("%Admin_Manage","USE")
}

/// Helper method to return an integer indicating the "tier" at which the 
/// ConfigItem type should appear in the HealthShare Home UI.
/// Lower values result in the type appearing earlier in the display.<br/>
/// The default implementation returns the value of ..#<parameter>UITIER</parameter>.
ClassMethod GetConfigTypeUITier() As %Integer [ Internal ]
{
	Quit ..#UITIER
}

/// Helper method to allow sub-classes to specify an alternative class to drive the
/// population of the UI menus for this namespace type.
/// The menu class should extend <class>HS.HC.Util.AbstractUIMenuClass</class> and SHOULD
/// implement the <code>addMenu()</code> method.
ClassMethod GetUIMenuClass(pInternalProductName As %String) As %Dictionary.Classname
{
	If (pInternalProductName = "HSLIB") {
		Quit ""
	}
	Else {
		Quit $piece(pInternalProductName,"LIB",1) _ ".Util.Portal"
	}
}

/// Helper method to identify the prefix that should be used to locate the
/// upgrade classes for the specified product. Note that the classes must extend 
/// <class>HS.Util.Installer.Upgrade.Abstract</class>, and have numeric trailing
/// values that match major version releases.
ClassMethod GetUpgradeClassPrefix(pInternalProductName As %String) As %String
{
	Quit $piece(pInternalProductName,"LIB",1) _ ".Util.Installer.Upgrade.V"
}

/// Called for uninstall of hub or edge
/// Also called by UnInstallAll, with pForce (and it ignores errors)
ClassMethod UnMapAllAuditDB(pForce As %Boolean = 0) As %Status
{
	try {
		Set tSC=$$$OK
		If '$$$IsAuditInstance(tDB) Quit:'pForce  Set tDB="HSAUDIT"
		Set tSC=..UnMapAuditDB("HSSYS",tDB) Quit:$$$ISERR(tSC)
		Set tNS=""
		For {
			Set tNS=$O(^%SYS("HealthShare","Instances",tNS)) Quit:tNS=""
			If ..ExistsNS(tNS) Set tSC=..UnMapAuditDB(tNS,tDB) Quit:$$$ISERR(tSC)
		}
	} Catch ex {
		Set tSC= ex.AsStatus()
	}
	Quit tSC
}

ClassMethod UnMapAuditDB(pNamespace, pAuditDB) As %Status
{
	try {
		Set tSC=$$$OK
		Quit:pAuditDB=pNamespace
		Set tSC=##class(HS.Util.SystemAPI).Invoke("DeleteGlobalMappings",pNamespace,pNamespace,"HS.IHE.Audit,OBJ.DSTIME:(""HS.IHE.ATNA.Repository.Aggregation"")")
	} Catch ex {
		Set tSC= ex.AsStatus()
	}
	Quit tSC
}

ClassMethod AuditRegistryServiceExists() As %Boolean
{
	Set tExists=0
	New $NameSpace
	Try {
		Set $NameSpace="HSSYS"
		Set tServ=##class(HS.Registry.Service.Abstract).EndPointForNameType("HSAudit.Repository","SOAP")
		If $IsObject(tServ) Set tExists=1
	} Catch(ex) {
	}
	Quit tExists
}

ClassMethod ExistsNS(pNamespace) As %Boolean
{
	New $Namespace
	try {
		Set $Namespace=pNamespace
		Set tExists=1
	} Catch ex {
		Set tExists=0
	}
	Quit tExists
}

ClassMethod ClearAuditLog()
{
 //Clear the Audit Log
 //If the Audit log has been set up in a secured database, this will (and should) fail
 //unless the caller has %ALL or the specific database role
 do ##class(%ZHSLIB.Audit.LogParticipant).%KillExtent()
 do ##class(%ZHSLIB.Audit.Log).%KillExtent()
 //Killing ^HS.Audit is needed due to a counter & SDA
 Kill ^HS.Audit,^HS.Audit.Consolidate,^HS.IHE.Audit,^%ZHSLIB.Audit.SysEvent
 Kill ^HS.AuditAlertQueue,^OBJ.DSTIME("HS.IHE.ATNA.Repository.Aggregation")
 //Once the audit data has been cleared, if the cube has ever been built, rebuild it to clear it out
 Set tCubeName="Audit Events"
 If $D(^DeepSee.Cubes("cubes",$$$UPPER(tCubeName),"lastDataUpdate")) {
	// Run the cube build in the background.  Using default parameters except tTracking.
	// tTracking argument tells DeepSee to capture the status information in the following globals
	// Since the job is run in the background:
	// ^CacheTemp.DeepSeeTracking
	// ^CacheTemp.CubeManagerUpdateTracking
	Set tTracking=1
	Job ##class(%DeepSee.Utils).%BuildCube(tCubeName,1,1,0,0,tTracking)
 }
}

/// This can now be run in either the registry or an edge on a different instance
ClassMethod SetupSampleDeepSee(pNamespace As %String) As %Status
{
	try {
		Set tSC = $$$OK
		new $namespace
		Set $namespace="HSLIB"
		Merge tCube=^DeepSee.Cubes
		Set $namespace=pNamespace
		Set tCubeName="Audit Events"
		//If cube hasn't been compiled, copy in cube definition
		If '$D(^DeepSee.Cubes("cubes",$$$UPPER(tCubeName))) {
			Set ^DeepSee.Cubes("classes","HS.IHE.ATNA.Repository.EventCube")="Audit Events"
			//If we're copying, this has to be null
			Set tCube("cubes",$$$UPPER(tCubeName),"lastDataUpdate")=""
			Merge ^DeepSee.Cubes("cubes",$$$UPPER(tCubeName))=tCube("cubes",$$$UPPER(tCubeName))
		}
		//Build cube if never built
		If '$G(^DeepSee.Cubes("cubes",$$$UPPER(tCubeName),"lastDataUpdate")) {
			// Run the cube build in the background.  Using default parameters except tTracking.
			// tTracking argument tells DeepSee to capture the status information in the following globals
			// Since the job is run in the background:
			// ^CacheTemp.DeepSeeTracking
			// ^CacheTemp.CubeManagerUpdateTracking
			Set tTracking=1
			Job ##class(%DeepSee.Utils).%BuildCube(tCubeName,1,1,0,0,tTracking)
		}
		//load in the sample pivots
		Set tSC=##class(HS.IHE.ATNA.Repository.SamplePivotContainer).%Process()
		Quit:$$$ISERR(tSC)
		//Create the task
		Set tSC=##class(HS.Util.SystemAPI).Invoke("ScheduleTask",pNamespace,"HS.IHE.ATNA.Repository.CubeSyncTask",pNamespace)
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	Quit tSC
}

ClassMethod BuildDBNS(pNamespace, ByRef pVars, ByRef pLogFile, pDoMirror As %Boolean = 1) As %Status
{
	try {
		new $namespace
		Set tSC = $$$OK
		Set $namespace="%SYS"
	 	// Check if pNamespace already exists
		Set tExists=##Class(Config.Namespaces).Exists(pNamespace)
		Set $namespace="HSLIB"
		Quit:tExists
		Set tDBName = $TR(pNamespace,"%-_","pdu")
		set DBResource="%DB_"_$ZCVT(tDBName,"U")

		If $Data(pVars("DBInstallDirectory"),tValue)#2 && (tValue '= "") {
			Set tDataDir = ##class(%File).NormalizeDirectory(tValue)
		}

		// Create the IRIS.DAT (if not already there)
		If $G(pVars("FromEnableEnsemble"))'=1 {
			//This gets set by %ZHSLIB.HealthShareMgr - the DB already exists, and might be mixed case
			do ##class(HS.HC.Util.Installer).Log(.pLogFile,$classname(),"Install","About to Create Database "_tDBName)
			If $system.Mirror.IsMember() do ##class(HS.HC.Util.Installer).Log(.pLogFile,$classname(),"Install","Database Create must wait for all mirror members")
			Set tSC=##class(HS.Util.SystemAPI).CreateDatabase(tDBName, pDoMirror, .tDataDir) Quit:$$$ISERR(tSC)
			do ##class(HS.HC.Util.Installer).Log(.pLogFile,$classname(),"Install","Create "_$$$DatabaseFilename_" in "_tDataDir_tDBName)
		}

		// Create the Namespace (if not already there)
		Set tSC=##class(HS.Util.SystemAPI).Invoke("CreateNamespace",tDBName,pNamespace,tDBName,tDBName) Quit:$$$ISERR(tSC)
		do ##class(HS.HC.Util.Installer).Log(.pLogFile,$classname(),"Install","Made Namespace "_pNamespace)
	} catch ex {
		Set tSC = ex.AsStatus()
	} 
	Quit tSC
}

ClassMethod ValidateName(pNamespace, ByRef pDatabase, ByRef pProduction) As %String
{
	Set (tReturn,pDatabase,pProduction)=""
	try {
		If pNamespace="HS" { Set tReturn="Name cannot be HS" Quit}
		If $l(pNamespace)>32 { Set tReturn="Name cannot exceed 32 characters" Quit}
		If $F(pNamespace,"%",2) { Set tReturn="% is only valid as a first character" Quit}
		If $l($tr($zstrip($e(pNamespace),"*A"),"%")) { Set tReturn="First character must be % or a letter" Quit}
		If $l($TR($zstrip(pNamespace,"*AN"),"%-_")) { Set tReturn="Name cannot contain punctuation" Quit}
	} catch ex {
		Set tReturn = $system.Status.GetErrorText(ex.AsStatus())
	}
	If tReturn="" {
		Set (pDatabase,pProduction)=$TR(pNamespace,"%-_","pdu")
	}
	
	Quit tReturn
}

ClassMethod InitializeInstall(ByRef pVars, ByRef pLogFile, ByRef pNamespace, ByRef pIsUpgrade, ByRef pInitialState) As %Status
{
	//assumes we have already done New $Roles and $Namespace
	Set tSC=$$$OK
	Try {
		If $ZCVT(pNamespace,"U")'?1.UN Set tSC=$$$ERROR($$$GeneralError,"Namespace Name must only contain letters and numbers") Quit
		If $IsObject($get(pVars("LogFile"))) {
			Set pLogFile = pVars("LogFile")
		}
		Set tSC = ..CheckPrivileges(.pLogFile) Quit:$$$ISERR(tSC)
		If $IsObject($get(pLogFile)) {
			Set pVars("LogFile") = pLogFile
		}
		Set tSC = ..SecureInitializeInstall(.pVars, .pLogFile, .pNamespace, .pIsUpgrade, .pInitialState)
	} Catch(ex) {
		Set tSC=ex.AsStatus()		
	}
	Quit tSC
}

ClassMethod SecureInitializeInstall(ByRef pVars, ByRef pLogFile, ByRef pNamespace, ByRef pIsUpgrade, ByRef pInitialState) As %Status [ Private ]
{
	Set tSC = $$$OK
	// Escalate roles, since user already passed ..CheckPrivileges in InitializeInstall.
	$$$AddAllRoleTemporary
	Try{
		//If Cache' has frozen plans on upgrade, unfreeze them
		Do $SYSTEM.SQL.FreezePlans(2,1)
		set pNamespace=$zcvt(pNamespace,"U")
		set pIsUpgrade=##class(HS.Util.Installer.ConfigItem).GetPropertyValue(pNamespace,"LastActivated")'=""
		// Switch to HSLIB
		set $namespace="HSLIB"
		set tVars="",tV="" for {set tV=$o(pVars(tV),1,tD) q:tV=""  set tVars=tVars_","_tV_"="_tD}
		do ##class(HS.HC.Util.Installer).Log(.pLogFile,$$$CurrentClass,$$$CurrentMethod,"") // Blank line
		do ##class(HS.HC.Util.Installer).Log(.pLogFile,$$$CurrentClass,$$$CurrentMethod,"*** Install "_pNamespace_" started at "_$zdt($h,3))
		do ##class(HS.HC.Util.Installer).Log(.pLogFile,$$$CurrentClass,$$$CurrentMethod,"pVars: "_$e(tVars,2,*))
		If 'pIsUpgrade {
			//check if there's a leftover IRIS.DAT - can't activate over it
			Set tDataDir = $G(pVars("DBInstallDirectory"))
			If tDataDir="" {
				Set tDataDir = $system.Util.ManagerDirectory()
			}
			Set tDataDir = ##class(%File).NormalizeDirectory(tDataDir_"/"_pNamespace)

			If ##class(%File).Exists(tDataDir_$$$DatabaseFilename) {
				Set $Namespace="%SYS",tExists=##class(Config.Databases).Exists(pNamespace),$Namespace="HSLIB"
				If 'tExists {
					do ##class(HS.HC.Util.Installer).Log(.pLogFile,$$$CurrentClass,$$$CurrentMethod,"Leftover "_$$$DatabaseFilename_" exists.  Can't activate")
					Set tSC=$$$ERROR($$$GeneralError,"Leftover "_$$$DatabaseFilename_" exists.  Can't activate") Quit
				}
			}
		}

		// Next, make sure the Production is stopped, allow it 30 secs
		if pIsUpgrade {
			set tSC=##class(HS.Director).StopProduction(pNamespace,30,.pInitialState,.tState)
			if $$$ISERR(tSC) throw ##class(%Exception.StatusException).CreateFromStatus(tSC)
			if tState'=$$$eProductionStateStopped {
				set tSC=$$$HSError($$$HSErrProductionNotStopped,$case(tState,$$$eProductionStateRunning:"Running",$$$eProductionStateSuspended:"Suspended",$$$eProductionStateTroubled:"Troubled",$$$eProductionStateNetworkStopped:"NetworkStopped",:"Unknown"))
				throw ##class(%Exception.StatusException).CreateFromStatus(tSC)
			}
			do ##class(HS.HC.Util.Installer).Log(.pLogFile,$$$CurrentClass,$$$CurrentMethod,"Production Stopped")
		} else { set pInitialState=0 } // do not autostart a new install
	 	do ##class(HS.HC.Util.Installer).Log(.pLogFile,$$$CurrentClass,$$$CurrentMethod,"IsUpgrade="_pIsUpgrade)
	}
	Catch ex{
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

ClassMethod InitializeComponent(ByRef pVars, ByRef pLogFile, pNamespace, ByRef pComponent, pDefaultTemplate) As %Status
{
	Set tSC=$$$OK
	Try {
		set tSC=..GetComponentByName(pNamespace,.pComponent,1,pVars("Type"),"HSLIB",.pVars) Quit:$$$ISERR(tSC)
		Do:'pComponent.Products.Find("HSLIB") pComponent.Products.Insert("HSLIB")
		do ##class(HS.HC.Util.Installer).Log(.pLogFile,$$$CurrentClass,$$$CurrentMethod,"tComponent "_pVars("Type")_" = "_pComponent.%Id())
		// Get values from pVars, component or default
		set tComponentName=$g(pVars("ComponentName"))
		if tComponentName="" {
			set tComponentName=pComponent.HSComponentName
			if tComponentName="" {
				set tComponentName=$g(pVars("HOSTNAME"),$$$HSNetworkHostName)_":"_pNamespace}}
		set (pComponent.HSComponentName,pVars("ComponentName"))=tComponentName
		set tProduction=$g(pVars("Production"))
		if tProduction="" {
			set tProduction=pComponent.Production
			if tProduction="" {
				set tProduction=pComponent.GetProductionName()
			}
		}
		Set tProduction=$tr(tProduction,"%_")
		set (pComponent.Production,pVars("Production"))=tProduction

		set tTemplate=$g(pVars("Template"))
		set:tTemplate="" tTemplate=pComponent.Template
		// If tTemplate exists, make sure it's a valid class.  If not, set to "" to allow defaulting
		If (($g(tTemplate)'="")&&('##class(%Dictionary.CompiledClass).%ExistsId(tTemplate))) {
			do ##class(HS.HC.Util.Installer).Log(.pLogFile,$$$CurrentClass,$$$CurrentMethod,"Template "_tTemplate_" does not exist, using default")
			Set tTemplate=""
		}
		If tTemplate="" {
				set tTemplate=pDefaultTemplate
		}
		set (pComponent.Template,pVars("Template"))=tTemplate
		If pVars("Type")'="Hub" {
			set tHubEndpoint=$g(pVars("HubEndpoint"))
			if tHubEndpoint="" {
				set tHubEndpoint=pComponent.HubEndpoint
				if tHubEndpoint="" {
					Do ##class(%RoutineMgr).GetWebServerPort(.tPort,,.tUrlPrefix)
					set tHubEndpoint="http://"_$G(pVars("HOSTNAME"),$$$HSNetworkHostName)_":"_tPort_tUrlPrefix_"/csp/healthshare/hsregistry/services/HS.Hub.HSWS.WebServices.cls"}}
			set (pComponent.HubEndpoint,pVars("HubEndpoint"))=tHubEndpoint
		}

		set tDescription=$g(pVars("Description"))
		if tDescription="" {
			set tDescription=pComponent.Description}
		set (pComponent.Description,pVars("Description"))=tDescription

		// Log the input params
	 	do ##class(HS.HC.Util.Installer).Log(.pLogFile,$$$CurrentClass,$$$CurrentMethod,"Name="_pComponent.Name)
	 	do ##class(HS.HC.Util.Installer).Log(.pLogFile,$$$CurrentClass,$$$CurrentMethod,"ComponentName="_pComponent.HSComponentName)
	 	do ##class(HS.HC.Util.Installer).Log(.pLogFile,$$$CurrentClass,$$$CurrentMethod,"Type="_pComponent.Type)
	 	do ##class(HS.HC.Util.Installer).Log(.pLogFile,$$$CurrentClass,$$$CurrentMethod,"Template="_tTemplate)
	 	do ##class(HS.HC.Util.Installer).Log(.pLogFile,$$$CurrentClass,$$$CurrentMethod,"Production="_tProduction)
	 	do ##class(HS.HC.Util.Installer).Log(.pLogFile,$$$CurrentClass,$$$CurrentMethod,"Description="_tDescription)
	 	do:pVars("Type")'="Hub" ##class(HS.HC.Util.Installer).Log(.pLogFile,$$$CurrentClass,$$$CurrentMethod,"HubEndpoint="_tHubEndpoint)
	} Catch(ex) {
		Set tSC=ex.AsStatus()		
	}
	Quit tSC
}

ClassMethod ScheduleSystemTasks(pNamespace, ByRef pLogFile) As %Status
{
	Set tSC=$$$OK
	Try {
		do ##class(HS.HC.Util.Installer).Log(.pLogFile,$$$CurrentClass,$$$CurrentMethod,"Scheduling system tasks in namespace '" _ pNamespace _ "'")
		// Set up scheduled jobs (if not already there)
		set tSC=##class(HS.Util.SystemAPI).Invoke("ScheduleTask","HSSYS","%ZHSLIB.Services.TaskUpdateRolesAndResources","HSSYS","Slave") Quit:$$$ISERR(tSC)
		do ##class(HS.HC.Util.Installer).Log(.pLogFile,$$$CurrentClass,$$$CurrentMethod,"Scheduled TaskUpdateRolesAndResources")
		//This one runs in the registry namespace
		set tSC=##class(HS.Util.SystemAPI).Invoke("ScheduleTask",pNamespace,"%ZHSLIB.Services.TaskCalculateUpdatedRAndR",pNamespace,"Hub") Quit:$$$ISERR(tSC)
		do ##class(HS.HC.Util.Installer).Log(.pLogFile,$$$CurrentClass,$$$CurrentMethod,"Scheduled TaskCalculateUpdatedRAndR")
		set tSC=##class(HS.Util.SystemAPI).Invoke("ScheduleTask","HSSYS","HS.Audit.EventTask","HSSYS") Quit:$$$ISERR(tSC)
		do ##class(HS.HC.Util.Installer).Log(.pLogFile,$$$CurrentClass,$$$CurrentMethod,"Scheduled ATNA HealthShare Event Aggregation Task for HSSYS")
		set tSC=##class(HS.Util.SystemAPI).Invoke("ScheduleTask","HSSYS","HS.Audit.SysEventTask","HSSYS") Quit:$$$ISERR(tSC)
		do ##class(HS.HC.Util.Installer).Log(.pLogFile,$$$CurrentClass,$$$CurrentMethod,"Scheduled ATNA IRIS Event Aggregation Task for HSSYS")		
	} Catch(ex) {
		Set tSC=ex.AsStatus()		
	}
	Quit tSC
}

ClassMethod InstallKits(pVars, pNamespace, pIsUpgrade) As %Status
{
	Set tSC=$$$OK
	New $Namespace
	Try {
		If ('$D(pVars("Kits"))) {
			If (pVars("Template")'="") {
				// Update kits based upon template if no kits were specified
				set tDefaultKits = $ListFromString($parameter(pVars("Template"), "DEFAULTKITS"))
				do ##class(HS.HC.Util.Installer).Log(.tLogFile,$$$CurrentClass,$$$CurrentMethod,"Default Kits = "_tDefaultKits)
				Set pVars("Kits") = tDefaultKits
			}
		}				

		Set tLogFile=$G(pVars("LogFile"))
		set tKitsList = $g(pVars("Kits"))
		set tPostInstall=0
		if (tKitsList'=""){
			do ##class(HS.HC.Util.Installer).Log(.tLogFile,$$$CurrentClass,$$$CurrentMethod,"Installing selected kits")
			set $namespace = pNamespace
			for i=1:1:$listlength(tKitsList){
				if '(##class(%Dictionary.ClassDefinition).%ExistsId($list(tKitsList,i))){
					do ##class(HS.HC.Util.Installer).Log(.tLogFile,$$$CurrentClass,$$$CurrentMethod,"Invalid kit name """_$list(tKitsList,i)_"""")
					continue
				}
			if ($list(tKitsList,i)["PostInstall"){
				set tPostInstall($i(tPostInstall))=$list(tKitsList,i)
				continue
			}
			do ##class(HS.HC.Util.Installer).Log(.tLogFile,$$$CurrentClass,$$$CurrentMethod,"Installing kit """_$list(tKitsList,i)_"""")
				set tSC = $classmethod($list(tKitsList,i),"Add"_pVars("Type"))
				do ##class(HS.HC.Util.Installer).Log(.tLogFile,$$$CurrentClass,$$$CurrentMethod,"Installed kit """_$list(tKitsList,i)_"""")
			}
			for i=1:1:tPostInstall{
			do ##class(HS.HC.Util.Installer).Log(.tLogFile,$$$CurrentClass,$$$CurrentMethod,"Installing kit """_tPostInstall(i)_"""")
				set tSC = $classmethod(tPostInstall(i),"Run"_pVars("Type"))
				do ##class(HS.HC.Util.Installer).Log(.tLogFile,$$$CurrentClass,$$$CurrentMethod,"Installed kit """_tPostInstall(i)_"""")
			}
			do ##class(HS.HC.Util.Installer).Log(.tLogFile,$$$CurrentClass,$$$CurrentMethod,"Installed all selected kits")
		}

		Do ##class(HS.Util.Installer.Kit.Base).PostInstallItems(pNamespace,pVars("Type"),$S(pIsUpgrade:"Upgrade",1:"New"))
	} Catch(ex) {
		Set tSC=ex.AsStatus()		
	}
	Quit tSC
}

/// Input a file directory path that is relative to the installation directory
/// This outputs a path that we can use as an Ensemble setting, relative to the default process directory,
/// assuming the default process' database directory is directly under (installdir)\mgr
/// This allows an installdemo to be mirrored on the same laptop
/// In production, the setting would always be changed to point to somewhere else,
/// and if a mirror, it would need to be the same physical directory on both sides
ClassMethod SettingsFilePath(tDirPath)
{
	Set tFilePath="..\.."_tDirPath
	If $$$isUNIX Set tFilePath=$TR(tFilePath,"\","/")
	Quit tFilePath
}

ClassMethod CSPPath(pNamespace) As %String
{
	Set pNamespace=$translate($zconvert(pNamespace,"L"),"%")
	If $$$isUNIX Quit "\csp\healthshare\"_pNamespace_"\"
	Quit "\CSP\healthshare\"_pNamespace_"\"
}

/// New wrapper for Uninstall - does purge.  Subsequent reinstall will fail if IRIS.DAT is still present
ClassMethod UnInstallP(pNamespace As %String) As %Status
{
	Quit ..UnInstall(pNamespace,1)
}

/// Most callers will pass 1 to purgefiles
/// This will attempt to clean up as much as possible, even if things are partially deleted
ClassMethod UnInstall(pNamespace As %String, pPurgeFiles As %Boolean = 0, pDeleteCSPApps As %Boolean = 1) As %Status
{
	try {
		set pNamespace=$ZCVT(pNamespace,"U")
		New $Namespace
		Try {
			Set $Namespace=pNamespace
			Set tNSExists=1
		} Catch {
			Set tNSExists=0
		}
	 	Set tSC2=..OnPreUnInstall(pNamespace,pPurgeFiles,.tLogFile)

		set $Namespace="HSLIB"
		set tSC=$$$OK
		Set tDBName = $TR(pNamespace,"%-_","pdu")
		set tDBResource="%DB_"_$ZCVT(tDBName,"U")
	 	do Log("") // Blank line
 		do Log("*** UnInstall "_pNamespace_" started at "_$zdt($h,3))
 		If tNSExists {
	 		// Send Gateway Disable request for all but the Hub
			If $g(^%SYS("HealthShare","Instances",pNamespace,"Type"))'="Hub"  && ($g(^%SYS("HealthShare","Instances",pNamespace,"Type"))'="Foundation") {
				Do ..GatewayDisableRequest(pNamespace)
			}
			// First, make sure the Production is not running, allow it 30 secs, (any other state is fine we are deleting it)
			set tSC=##class(HS.Director).StopProduction(pNamespace,30,.tInitialState,.tState,1) if $$$ISERR(tSC) quit
			if tState=$$$eProductionStateRunning {
				set tSC=$$$HSError($$$HSErrProductionNotStopped,$case(tState,$$$eProductionStateRunning:"Running",$$$eProductionStateSuspended:"Suspended",$$$eProductionStateTroubled:"Troubled",$$$eProductionStateNetworkStopped:"NetworkStopped",:"Unknown"))
				quit
			}
			do Log("Production Stopped")
 		}
		
		// Remove any scheduled tasks
		Set tSC2=##class(HS.Util.SystemAPI).Invoke("DeleteTasks",pNamespace,pNamespace)
		Do Log("Deleted Tasks",tSC2)
		If $G(^%SYS("HealthShare","AuditNS"))=pNamespace, tNSExists {
			Set $namespace=pNamespace
			Do ..ClearAuditLog()
			Set tSC2=..UnMapAllAuditDB()
			do Log("UnMapAllAuditDB",tSC2)
			Kill ^%SYS("HealthShare","AuditDB")
			Kill ^%SYS("HealthShare","AuditNS")
			Set $namespace="HSLIB"
		}
	
		// Purge the namespace
		// If pPurgeFiles also delete the IRIS.DAT and the directory
		Set tSC2=##class(HS.Util.SystemAPI).Invoke("DeleteNamespace",pNamespace,pNamespace,pPurgeFiles,pDeleteCSPApps)
		Do Log("DeleteNamespace",tSC2)
		//some of this is redundant, but we do it in case not everything works
		Set tSC2=##class(HS.Util.SystemAPI).Invoke("DeleteDatabase",tDBName,tDBName)
		Do Log("DeleteDatabase",tSC2)
		Set tSC2=##class(HS.Util.SystemAPI).Invoke("DeleteResource",pNamespace,tDBResource)
		do Log("Deleted Resource "_tDBResource,tSC2)
		Set tSC2=##class(HS.Util.SystemAPI).Invoke("DeleteRole",pNamespace,tDBResource)
		do Log("Deleted Role "_tDBResource,tSC2)
		//for now, cache' doesn't allow us to delete this role
		/*Set tHSRole = "%HS_DB_"_pNamespace
		Set tSC2=##class(HS.Util.SystemAPI).Invoke("DeleteRole",pNamespace,tHSRole)
		do Log("Deleted Resource & Role "_tHSRole,tSC2)*/
	 	set tDir="csp/healthshare/"_$zcvt(pNamespace,"L")_"/"
	 	Set tSC2=##class(HS.Util.SystemAPI).Invoke("RemoveDirectory",pNamespace,tDir)
	 	do Log("Removed CSP directory",tSC2)
	 	Kill ^%SYS("HealthShare","DeferredActions",pNamespace)
	 	Set tSC2=..OnUnInstall(pNamespace,pPurgeFiles,.tLogFile)
	 	Kill ^%SYS("HealthShare","Instances",pNamespace) // in case this wasn't already done
	 	do ..UnInstallCleanup()
	} Catch ex {
		Set tSC=ex.AsStatus()		
	}

	If $$$ISOK(tSC) {
		do Log("UnInstall "_pNamespace_" done at "_$zdt($h,3))
	} else {
		do Log("UnInstall failed at "_$zdt($h,3),tSC)
	}
	Quit tSC
	
Log(pMessage,pStatus = 1)
	Do ##class(HS.HC.Util.Installer).Log(.tLogFile,$Classname(),"UnInstall",pMessage)
	Set tCode=$system.Status.GetErrorCodes(pStatus) Quit:tCode=420||(tCode=5021)  //false positives
	If $$$ISERR(pStatus) Do ##class(HS.HC.Util.Installer).Log(.tLogFile,$Classname(),"UnInstall",$system.Status.GetErrorText(pStatus))
	Quit
}

ClassMethod GatewayDisableRequest(pNamespace) As %Status
{
	new $namespace
	#dim tRequest As HS.Message.GatewayRegistrationRequest
	Set $namespace=pNamespace
	Set tRequest = ##class(HS.Message.GatewayRegistrationRequest).%New()
	Set tRequest.Name = ..GetThisComponentName()
	Set tRequest.Status = "D"
	
	do ##class(HS.Util.HubServices).InvokeHubService("HS.Hub.HSWS.WebServices","HS.Hub.HSWS.WebServicesClient","RegisterGateway",.tResponse,tRequest)
	
	Quit 1
}

/// Install the configuration item in the specified namespace. pVars allows you to override/change configuration parameters, which will be updated in 
/// the HS.Util.Installer.ConfigItem database. The allowed subscripts in pVars will vary across the different subclasses of 
/// <class>HS.Util.Installer.ConfigItem</class>, and the method should be overridden and re-documented in each subclass. 
ClassMethod Install(pNamespace As %String, ByRef pVars) As %Status [ Abstract ]
{
}

ClassMethod ClearFHIRDbs(dbList As %List, pLogFile, purge) As %Status
{
	set sc=$$$OK
	try {
		set curNs = $namespace
		set $namespace = "%SYS"
		Set statement=##class(%SQL.Statement).%New()   
		Set sc = statement.%PrepareClassQuery("SYS.Database","FreeSpace") 
		if $$$ISERR(sc) quit  
		#dim rs as %ResultSet  = statement.%Execute("*")
		while rs.%Next() {
			set dbName = rs.%GetData(1)
			set dir = rs.%GetData(2)
			if dbName = "" continue
			if '$lf(dbList, dbName) continue
			set $namespace = curNs
			Set sc2=##class(HS.Util.SystemAPI).Invoke("DeleteDatabase",dbName,dbName)
			if $$$ISERR(sc2) {
					do ##class(HS.HC.Util.Installer).Log(.pLogFile,$$$CurrentClass,$$$CurrentMethod,"Exception during Uninstall; "_$system.Status.GetErrorText(sc2))
			}

			if purge {
				Set sc2=##class(%File).RemoveDirectoryTree(dir)
			}
			if $$$ISERR(sc2) {
					do ##class(HS.HC.Util.Installer).Log(.pLogFile,$$$CurrentClass,$$$CurrentMethod,"Exception during Uninstall; "_$system.Status.GetErrorText(sc2))
			}
			set $namespace = "%SYS"

		}
		kill rs
		set $namespace = curNs
	}
	catch(ex) {
		set $namespace = curNs
		Set sc=ex.AsStatus()
		do ##class(HS.HC.Util.Installer).Log(.pLogFile,$$$CurrentClass,$$$CurrentMethod,"Exception during Uninstall; "_$system.Status.GetErrorText(sc))
	}
	quit sc
}

/// Can be implemented on subclasses that aren't overriding UnInstall
ClassMethod OnUnInstall(pNamespace As %String, pPurgeFiles As %Boolean = 0, pLogFile) As %Status
{

	Quit $$$OK
}

ClassMethod OnPreUnInstall(pNamespace As %String, pPurgeFiles As %Boolean = 0, pLogFile) As %Status
{

	Quit $$$OK
}

/// On UnInstall, cleanup HSSYS if no other HS namespaces exist
ClassMethod UnInstallCleanup() As %Status
{
	//  
	// Loop through HealthShare instances, see if any Federated/non-Foundation namespaces exist 
	// If not, do cleanup of HSSYS database.
	// tLastNS=1 if this is the last HS Namespace
	Set tNS="",tLastNS=1
	For  {
		Set tNS=$O(^%SYS("HealthShare","Instances",tNS)) Quit:tNS=""
		If $g(^%SYS("HealthShare","Instances",tNS,"Type"))'="Foundation" 
		{
			// There is another HealthShare namespace, set tLastNS=0 and Quit
			Set tLastNS=0
			Quit
		}
		// Check for Other Foundation Type Applications, such as Analytics, Patient Index, etc that are Federated.
		If $g(^%SYS("HealthShare","Instances",tNS,"Type"))="Foundation"
		{
			Set tConfigItem = ##class(HS.Util.Installer.ConfigItem).%OpenId(tNS)
			If tConfigItem.%ClassName(0)'="Foundation" {
				// There is another HealthShare Federated namespace, set tLastNS=0 and Quit
				Set tLastNS=0
				Quit
			}
		}
	}
	// Cleanup HSSYS namespace if we are removing the last Federated HealthShare namespace on this instance
	If tLastNS=1 {
		Do ..GatewayDisableRequest("HSSYS")
		// Cleanup tasks and sync data from HSSYS
		// Switch namespace, because at this point, the original namespace is deleted, so no longer mapped to HSSYS
		new $namespace
		Set $namespace = "HSSYS"
		Do ##class(HS.HC.Util.Installer).DeleteTasks("HSSYS")
		// Reset Sync Data
		Set tSC = ##class(HS.Sync.Utils).DeleteSyncData()
		// Remove Sync Slave Flag
		Kill ^["HSSYS"]ISC.HS.SyncSlave
		//Clear the system audit tracking marker
		Kill ^%ZHSLIB.Audit.SysEvent
	}
}

ClassMethod ClearSystemAPI()
{
	If '$system.Mirror.IsMember() {Kill ^%SYS("HealthShare","SystemAPI"),^%SYS("HealthShareLocal","SystemAPI")}
}

ClassMethod GetSampleTemplates(Output pSampleProductions) As %Status
{
	Kill pSampleProductions
	New $namespace
	ZN "^^"_##class(%File).NormalizeDirectory($system.Util.InstallDirectory()_"mgr/")_$zcvt(..#CODEDATABASE,"l")
	Set tPackage = ..#SAMPLETEMPLATES
	If ##class(%Dictionary.CompiledClass).%ExistsId(tPackage) {
		Set pSampleProductions($i(pSampleProductions))=$lb(tPackage,tPackage)
	}
	Set tRS = ##class(%ResultSet).%New("%RoutineMgr:StudioOpenDialog")
	Set tCount=0
	Do tRS.Execute(tPackage_".*.cls",1,,,1,1)
	While tRS.Next() {
		Set tName = tRS.Get("Name")
		#; Remove ".cls" from the name
		Set tName = $E(tName,1,$L(tName)-4)
		If tName '= "" && (##class(%Dictionary.CompiledClass).%ExistsId(tName)) {
			// Only add to array if template is accessible
			If '##class(%ZHSLIB.KitManager).HasAccessTo(, $Classname(), "Templates", tName) {
				Continue
			}
			Set pSampleProductions($i(pSampleProductions))=$lb(tName,tName)
		}
	}
	Quit $$$OK
}

Storage Default
{
<Data name="ConfigItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CreatedAt</Value>
</Value>
<Value name="3">
<Value>Template</Value>
</Value>
<Value name="4">
<Value>Production</Value>
</Value>
<Value name="5">
<Value>Activated</Value>
</Value>
<Value name="6">
<Value>LastActivated</Value>
</Value>
<Value name="7">
<Value>Description</Value>
</Value>
<Value name="8">
<Value>Disabled</Value>
</Value>
<Value name="9">
<Value>HSComponentName</Value>
</Value>
<Value name="10">
<Value>Products</Value>
</Value>
<Value name="11">
<Value>AuditProduction</Value>
</Value>
<Value name="12">
<Value>DatabaseLocation</Value>
</Value>
</Data>
<Data name="ConfigItemHSLIBNode">
<Attribute>%HSLIB</Attribute>
<Structure>node</Structure>
<Subscript>"HSLIB"</Subscript>
</Data>
<Data name="ConfigItemTypeNode">
<Attribute>Type</Attribute>
<Structure>node</Structure>
<Subscript>"Type"</Subscript>
</Data>
<DataLocation>^%SYS("HealthShare","Instances")</DataLocation>
<DefaultData>ConfigItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%SYS("HealthShare","Instances")</IdLocation>
<IndexLocation>^HS.Util.Installer.ConfigItemI</IndexLocation>
<StreamLocation>^HS.Util.Installer.ConfigItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
