Include (HS.HC, %ZHSLIB)

/// Foundation Installer
Class HS.Util.Installer.Foundation Extends HS.Util.Installer.ConfigItem
{

/// TYPE is used to default the Type property
Parameter TYPE As %String = "Foundation";

/// Parameter that controls the relative importance of this component type in 
/// the HealthShare Home UI for selecting namespaces.
/// Lower values indicate components that should appear earlier in the UI.
/// The value is used as the default return value for the 
/// <method>GetConfigTypeUITier</method>() helper method.
Parameter UITIER As INTEGER = 2;

/// The Hub WS address - for sub types of foundation, and potentially foundation at some point
Property HubEndpoint As HS.Types.EndPoint;

/// Install a Foundation in the specified namespace. 
/// pVars allows you to override/change configuration parameters, which
/// will be updated in the HS.Util.Installer.ConfigItem database:
/// <ul>
/// <li>LogFile - current log file for install operation</li>
/// <li>Type - hardcoded to "Foundation"</li>
/// <li>Component - current component name</li>
/// <li>Kits - list of class names of kits to install (%Library.ListOfDataTypes)</li>
/// <li>Production - class name of production, default namespacePKG.BusProduction</li>
/// <li>Template - production template to use</li>
/// <li>Description - a description of the production</li>
/// </ul>
ClassMethod Install(pNamespace As %String, ByRef pVars) As %Status
{
	// run from HSLIB namespace, remember where you started
	try {
		New $Roles
		If $IsObject($get(pVars("LogFile"))) {
			Set tLogFile = pVars("LogFile")
		}
		Set tSC = ..CheckPrivileges(.tLogFile) Quit:$$$ISERR(tSC)
		If $IsObject($get(tLogFile)) {
			Set pVars("LogFile") = $get(tLogFile)
		}
		Set tLogFile = $get(tLogFile)
		// Escalate roles, since user already passed ..CheckPrivileges above.
		Set tSC = ..SecureInstall(pNamespace,.pVars,.tLogFile)
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	do:$$$ISERR(tSC) ##class(HS.HC.Util.Installer).Log(.tLogFile,$ClassName(),"Install",$system.Status.GetErrorText(tSC))
	do ##class(HS.HC.Util.Installer).Log(.tLogFile,0) // close logfile
	Quit tSC
}

ClassMethod SecureInstall(pNamespace As %String, ByRef pVars, ByRef pLogFile) As %Status [ Private ]
{
	Set tSC = $$$OK
	$$$AddAllRoleTemporary
	Try{
		Set tIsUpgrade=##class(HS.Util.Installer.ConfigItem).GetPropertyValue(pNamespace,"LastActivated")'=""
		Set pVars("Upgrade")=tIsUpgrade
		#dim tComponent as HS.Util.Installer.Foundation
	 	Set pNamespace=$ZCVT(pNamespace,"U")
		set pVars("Type")="Foundation"
		set tSC=##class(HS.Util.Installer.ConfigItem).GetComponentByName(pNamespace,.tComponent,1,"Foundation","HSLIB",.pVars)
		Quit:$$$ISERR(tSC)
		Set pVars("Component")=tComponent
		If $ZCVT(pNamespace,"U")'?1.UN,tComponent.%ClassName(1)'="HS.Util.Installer.Foundation" {
			Set tSC=$$$ERROR($$$GeneralError,"Namespace Name must only contain letters and numbers") Quit
		}
		if $g(pVars("HubEndpoint"))'="" {
			set tComponent.HubEndpoint=$g(pVars("HubEndpoint"))
		}
	 	do ##class(HS.HC.Util.Installer).Log(.pLogFile,$classname(),"Install","tComponent Foundation = "_tComponent.%Id())
		Set tDoMirror=tComponent.%ClassName(1)'="HS.Util.Installer.Foundation"
		Set tSC = ..BuildDBNS(pNamespace,.pVars,.pLogFile,tDoMirror) Quit:$$$ISERR(tSC)
		Do ##class(HS.HC.Util.Installer).MapHSSYSForNamespace(pNamespace)
		Do ##class(HS.HC.Util.Installer).MapHSCUSTOMForNamespace(pNamespace)
		do ##class(HS.HC.Util.Installer).EnableEnsemble("",pNamespace,"",,,,,.pLogFile)
		Set add = ##class(HS.HC.Util.Installer).StandardGlobalMapping()
		do ##class(HS.HC.Util.Installer).AddGlobalMappings(,pNamespace,add,"HSLIB")
		set add="HS,HSMOD,SchemaMap"
		do ##class(HS.HC.Util.Installer).AddClassMappings(,pNamespace,add,"HSLIB")
		do ##class(HS.HC.Util.Installer).Log(.pLogFile,$$$CurrentClass,$$$CurrentMethod,"Added Package mappings "_add)
		// A bug in Cache?  rINC is mapped with package mapping but rINDEX which is used for IsUpToDate is not
		Set add="HSMOD.*,SchemaMap*"
		do ##class(HS.HC.Util.Installer).AddRoutineMappings(,pNamespace,add,"INC","HSLIB")
		do ##class(HS.HC.Util.Installer).Log(.pLogFile,$$$CurrentClass,$$$CurrentMethod,"Added include mappings "_add)
		// Save / Reload CPF
		Do ##class(HS.HC.Util.Installer).ActivateConfiguration(,pNamespace)
		Set tCodeDatabase = ..GetInstallerDatabase(.pVars)
		If (tCodeDatabase = "HSLIB") {
			Set tRole = ""
		}
		Else {
			Set tRole = "%DB_" _ tCodeDatabase
		}
		Set tSC = ..BuildPortalApp(pNamespace,.pLogFile,tRole) Quit:$$$ISERR(tSC)
		Set tSC = ..AdditionalSetup(pNamespace,.pVars,.pLogFile) Quit:$$$ISERR(tSC)
		// Ensure ^oddXML is correctly populated for XML classes which extend classes in %SYS and ENSLIB
		set tSC = ##class(HS.HC.Util.Installer).CompileXMLExtensions(pNamespace)
		if $$$ISERR(tSC) Throw ##class(%Exception.StatusException).CreateFromStatus(tSC)
		do ##class(HS.HC.Util.Installer).Log(.tLogFile,$$$CurrentClass,$$$CurrentMethod,"Recompiled XML extension classes")
		
		do ##class(HS.FHIRServer.Installer).InstallNamespace(pNamespace)
		set tSC = ##class(HS.HC.Util.Installer.Kit.FHIR.HealthConnect).ImportFHIRGlobals(pNamespace) Quit:$$$ISERR(tSC)
		set tSC = ##class(HS.HC.Util.Installer.Kit.FHIR.HealthConnect).ImportLookupJSON(pNamespace) Quit:$$$ISERR(tSC)
	
		$$$ThrowOnError( ##class(%ZHSLIB.PackageManager.Developer.Utils).AddPackageMapping(pNamespace, "%SYSTEM.Context.HealthShare", tCodeDatabase) )
		set tSC=tComponent.MarkActivated(1) if $$$ISERR(tSC) throw ##class(%Exception.StatusException).CreateFromStatus(tSC)
		do ##class(HS.HC.Util.Installer).Log(.tLogFile,$$$CurrentClass,$$$CurrentMethod,"Install "_pNamespace_" done at "_$zdt($h,3))
		do ##class(HS.HC.Util.Installer).Log(.tLogFile,0) // close logfile
	}
	Catch ex{
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Generic foundation namespace versus PatientIndex or Analytics, Community
ClassMethod AdditionalSetup(pNamespace, ByRef pVars, ByRef pLogFile) As %Status
{
	Set tSC=$$$OK
	If 'pVars("Upgrade") {
		// Copy in the template as the production, if it does not exist, and (always) compile it
		lock +^HS.Installer.Compile("Production")
		If $G(pVars("Template"))=""||($G(pVars("Template"))="Ens.Production") {
			Do ..CreateProduction(.pVars,.tLogFile,pNamespace)
		} Else {
			set tCopied=##class(HS.HC.Util.Installer).CopyClass(pNamespace,pVars("Template"),pVars("Production"))
			do ##class(HS.HC.Util.Installer).Log(.tLogFile,$$$CurrentClass,$$$CurrentMethod,$s(tCopied:"Copied & ",1:"")_"Compiled template "_pVars("Template")_" as "_pVars("Production"))
		}
		lock -^HS.Installer.Compile("Production")
		// Add Production Credentials
		// This will NOT overwrite existing credentials
		Set tName=$$$HSServiceUserGetMake
		set:tName]"" tSC = ##class(HS.HC.Util.Installer).SetCredential(pNamespace,tName,tName,tName,0) if $$$ISERR(tSC) Throw ##class(%Exception.StatusException).CreateFromStatus(tSC)
		do ##class(HS.HC.Util.Installer).Log(.tLogFile,$$$CurrentClass,$$$CurrentMethod,"Set Credential "_tName)
	}
	// Map HS.Doc.Data.* globals for SDA/CDA Annotations to HSSYS for Foundation namespaces.
	Set tSC = ##class(HS.Doc.Utility.Setup).Mapping(pNamespace)
	If $$$ISERR(tSC) Quit tSC
	
	Set tSC = ##class(HS.Util.Installer.Kit.Base).PostInstallItems(pNamespace,"Foundation",$S(pVars("Upgrade"):"Upgrade",1:"New"))
	If $$$ISERR(tSC) Quit tSC
	Quit tSC
}

ClassMethod CreateProduction(ByRef pVars, ByRef pLogFile, pNamespace) As %Status
{
	New $namespace
	Set $namespace=pNamespace
	set tSC=..GetComponentByName(pNamespace,.pComponent,1,pVars("Type"),"HSLIB",.pVars) Quit:$$$ISERR(tSC)
	set tProduction=$g(pVars("Production"))
	if tProduction="" {
		set tProduction=pComponent.Production
		if tProduction="" {
			set tProduction=pComponent.GetProductionName()
		}
	}
	Set tProduction=$tr(tProduction,"%_")
	set (pComponent.Production,pVars("Production"))=tProduction

	Set tClass=##class(%Dictionary.ClassDefinition).%New(pVars("Production"))
	Set tClass.Super="Ens.Production"
	Set tXData = ##class(%Dictionary.XDataDefinition).%New()
	Set tXData.Name="ProductionDefinition"
	Do tXData.Data.Write("<Production Name="""_pVars("Production")_""" LogGeneralTraceEvents=""false""></Production>")	
	Do tClass.XDatas.Insert(tXData)
	Set tSC = tClass.%Save()
	Set tSC= $system.OBJ.Compile(pVars("Production"),"fck-dv")
	do ##class(HS.HC.Util.Installer).Log(.tLogFile,$$$CurrentClass,$$$CurrentMethod,"Compiled template "_pVars("Production"))
	Set ^Ens.Configuration("csp","LastProduction")=pVars("Production")
}

/// Reset calls the Reset() method on all classes that extend HS.Util.Installer.Foundation.Reset.
/// If multiple Reset() calls are made, the failure of one call does not abort the execution of
/// this method. All failure statuses are gathered into one %Status object that is then returned
/// by this method.
ClassMethod Reset(pDummy As %Integer = 0) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Do ##class(HS.HC.Util.Installer).Log(.tLogFile, $$$CurrentClass, $$$CurrentMethod, "in "_$Namespace_" started at "_$ZDateTime($Horolog,3))
		
		Set tResultSet = ##class(%ResultSet).%New("%Dictionary.ClassDefinition:SubclassOf")
		Set tSC = tResultSet.%Execute("HS.Util.Installer.Foundation.Reset")
		If $$$ISERR(tSC) Quit
		
		Set tInitialState = 0
		Set tStoppedProd = 0
		
		While tResultSet.%Next() {
			// If the current production has not been checked for stopped, check to
			// see if the current production is running. If it is, then make a note
			// of that, and stop the production.
			If 'tStoppedProd {
				// Make sure the Production is stopped, allow it 30 secs
				Set tSC = ##class(HS.HC.Util.Installer).StopProduction($Namespace, 30, .tInitialState, .tState)
				If $$$ISERR(tSC) Quit
				If tInitialState = $$$eProductionStateStopped {
					Do ##class(HS.HC.Util.Installer).Log(.tLogFile, $$$CurrentClass, $$$CurrentMethod, "Production not running")
				} ElseIf tState = $$$eProductionStateStopped {
					Do ##class(HS.HC.Util.Installer).Log(.tLogFile, $$$CurrentClass, $$$CurrentMethod, "Production Stopped")
				} ElseIf tState = $$$eProductionStateSuspended {
					Do ##class(HS.HC.Util.Installer).Log(.tLogFile, $$$CurrentClass, $$$CurrentMethod, "Production is suspended")
				} Else {
					Set tSC = $$$ERROR($$$GeneralError, "Production not stopped, state = "_$case(tState,$$$eProductionStateRunning:"Running",$$$eProductionStateTroubled:"Troubled",$$$eProductionStateNetworkStopped:"NetworkStopped",:"Unknown"))
					Do ##class(HS.HC.Util.Installer).Log(.tLogFile, $$$CurrentClass, $$$CurrentMethod, "Production failed to stop")
				}
				Set tStoppedProd = 1
			}
			Try {
				Set tSC1 = $ClassMethod(tResultSet.Name, "Reset", pDummy)
			} Catch ex {
				Set tSC1 = ex.AsStatus()
			}
			// Accumulate errors.
			Set tSC = $$$ADDSC(tSC, tSC1)
		}
		If $$$ISERR(tSC) Quit
		
		// If the current production was running before we started calling Reset()
		// methods, then start it back up again.
		If tInitialState=$$$eProductionStateRunning {
			Set tSC = ##class(HS.HC.Util.Installer).StartProduction($namespace,,.tState)
			If $$$ISERR(tSC) Quit
			If tState=$$$eProductionStateRunning {
				Do ##class(HS.HC.Util.Installer).Log(.tLogFile, $$$CurrentClass, $$$CurrentMethod, "Production restarted")
			} Else {
				Do ##class(HS.HC.Util.Installer).Log(.tLogFile, $$$CurrentClass, $$$CurrentMethod, "Production failed to restart")
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	If $$$ISERR(tSC) {
		Set tErrorText = ""
		Set tErrorCodes = $system.Status.GetErrorCodes(tSC)
		For i = 1:1:$Length(tErrorCodes,",") {
			If tErrorText'="" Set tErrorText = tErrorText_", "
			Set tErrorText = tErrorText_$system.Status.GetOneErrorText(tSC,i)
		}
		Do ##class(HS.HC.Util.Installer).Log(.tLogFile, $$$CurrentClass, $$$CurrentMethod, "in "_$Namespace_" failed at "_$ZDateTime($Horolog,3)_" - "_tErrorText)
	} Else {
		Do ##class(HS.HC.Util.Installer).Log(.tLogFile, $$$CurrentClass, $$$CurrentMethod, "in "_$Namespace_" done at "_$ZDateTime($Horolog,3))
	}
	
	Quit tSC
}

ClassMethod OnPreUnInstall(pNamespace As %String, pPurgeFiles As %Boolean = 0, pLogFile) As %Status
{
	set tSC=$$$OK
	try {
			set %FHIRDBList = ""
			if $namespace = pNamespace {
			set %FHIRDBList = ##class(HS.FHIRServer.Repo).getFHIRDbList()
			
		}

		
		
	}
	catch(ex) {
		Set tSC=ex.AsStatus()
		do ##class(HS.HC.Util.Installer).Log(.pLogFile,$$$CurrentClass,$$$CurrentMethod,"Exception during Uninstall; "_$system.Status.GetErrorText(tSC))
	}
	quit tSC
}

ClassMethod OnUnInstall(pNamespace As %String, pPurgeFiles As %Boolean = 0, pLogFile) As %Status
{
	set tSC=$$$OK
	
		if $g(%FHIRDBList)'="" {
				
				write !, "Deleting FHIR databases: ", $lts(%FHIRDBList),!
				do ..ClearFHIRDbs(%FHIRDBList, pLogFile, pPurgeFiles)
				
		}
		
		return tSC
}

ClassMethod UnInstall(pNamespace As %String, pPurgeFiles As %Boolean = 0) As %Status
{
	Quit $$$OK
}

/// Helper method to indicate whether the current user is permitted to access
/// the details for the specified namespace based on their current roles.
ClassMethod CheckUISecurityResources(pNamespace As %String = "") As %Boolean [ Internal ]
{
	Quit ##super(pNamespace) || $system.Security.Check($$$HSHubManagement,"USE")
}

/// Helper method to support returning a display name for the ConfigItem type.
/// <var>pLocalize</var> controls whether the returned value should be localized.
ClassMethod GetConfigTypeName(pLocalize As %Boolean = 0) As %String [ Internal ]
{
	Quit $select(pLocalize: $$$Text("Foundation"), 1: "Foundation")
}

Storage Default
{
<Data name="FoundationDefaultData">
<Subscript>"Foundation"</Subscript>
<Value name="1">
<Value>HubEndpoint</Value>
</Value>
</Data>
<DefaultData>FoundationDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
