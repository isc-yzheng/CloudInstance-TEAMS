Include %ZHSLIB

/// HS.HC.Util.Installer.Kit.FHIR.PIXm adds a starting set of production components
/// and definitions needed for handling the IHE PIXm profile in a Foundation type
/// namespace. Note that the user will need to manually configure the client-side
/// components and definitions.<br>
/// <br>
/// Example call to this class for setting up PIXm for FHIR DSTU2:<br>
/// <br>
/// Set status = ##class(HS.HC.Util.Installer.Kit.FHIR.PIXm).Add( , "FHIR", "DSTU2", "/csp/pixm", "/csp/pixm-oidc")<br>
/// <br>
/// Example call to this class for setting up PIXm for FHIR STU3:<br>
/// <br>
/// Set status = ##class(HS.HC.Util.Installer.Kit.FHIR.PIXm).Add( , "FHIR", "STU3", "/csp/pixm", "/csp/pixm-oidc")<br>
/// 
Class HS.HC.Util.Installer.Kit.FHIR.PIXm Extends HS.Util.Installer.Kit.Base
{

Parameter NamespaceTypes As %String = "Foundation";

/// This method calls the AddPIXm() method to add the PIXm production components and definitions.<br>
/// <br>Inputs:<br>
/// <li>pNamespaces   : (not used, leave blank)
/// <li>pFoundationNS : (required) The name of a Foundation type namespace.
/// <li>pFHIRVersion  : (required) Version of FHIR IHE profile to support - "DSTU2" or "STU3".
/// <li>pCSPApp       : CSP application to use for the PIXm end point. If no value is specified, then
///                     the value is "/csp/healthshare/<i>namespace_name</i>/pixm/<i>fhir_version</i>".
/// <li>pCSPOIDCApp   : CSP application to use for the Open ID Connect / OAuth 2.0 enabled
///                     PIXm end point. If not specified, the value is
///                     "/csp/healthshare/<i>namespace_name</i>/pixm-oidc/<i>fhir_version</i>"
ClassMethod Add(pNamespaces As HS.Util.Installer.Kit.Namespaces = "", pFoundationNS As %String = {$Namespace}, pFHIRVersion As %String, pCSPApp As %String = "", pCSPOIDCApp As %String = "") As %Status
{
	Quit ..AddPIXm(pNamespaces, pFoundationNS, $Get(pFHIRVersion), pCSPApp, pCSPOIDCApp)
}

/// This method calls the AddPIXm() method to add the PIXm production components and definitions.<br>
/// <br>Inputs:<br>
/// <li>pNamespaces  : (not used, leave blank)
/// <li>pNS          : (required) The name of a Foundation type namespace.
/// <li>pFHIRVersion : (required) Version of FHIR IHE profile to support - "DSTU2" or "STU3".
/// <li>pCSPApp      : CSP application to use for the PIXm end point. If no value is specified, then
///                    the value is "/csp/healthshare/<i>namespace_name</i>/pixm/<i>fhir_version</i>".
/// <li>pCSPOIDCApp  : CSP application to use for the Open ID Connect / OAuth 2.0 enabled
///                    PIXm end point. If not specified, the value is
///                    "/csp/healthshare/<i>namespace_name</i>/pixm-oidc/<i>fhir_version</i>"
ClassMethod AddFoundation(pNamespaces As HS.Util.Installer.Kit.Namespaces = "", pNS = {$Namespace}, pFHIRVersion As %String, pCSPApp As %String = "", pCSPOIDCApp As %String = "") As %Status
{
	Quit ..AddPIXm(pNamespaces, pNS, $Get(pFHIRVersion), pCSPApp, pCSPOIDCApp)
}

/// AddPIXm adds the PIXm production components and definitions.<br>
/// <br>Inputs:<br>
/// <li>pNamespaces  : (not used, leave blank)
/// <li>pNS          : (required) The name of a Foundation type namespace.
/// <li>pFHIRVersion : (required) Version of FHIR IHE profile to support - "DSTU2" or "STU3".
/// <li>pCSPApp      : CSP application to use for the PIXm end point. If no value is specified, then
///                    the value is "/csp/healthshare/<i>namespace_name</i>/pixm/<i>fhir_version</i>".
/// <li>pCSPOIDCApp  : CSP application to use for the Open ID Connect / OAuth 2.0 enabled
///                    PIXm end point. If not specified, the value is
///                    "/csp/healthshare/<i>namespace_name</i>/pixm-oidc/<i>fhir_version</i>"
ClassMethod AddPIXm(pNamespaces As HS.Util.Installer.Kit.Namespaces = "", pNS = {$Namespace}, pFHIRVersion As %String, pCSPApp As %String = "", pCSPOIDCApp As %String = "") As %Status
{
	New $Namespace
	
	Set tSC = $$$OK
	
	Try {
		If pNS="" Set tSC = $$$ERROR($$$GeneralError, "Namespace not specified") Quit
		
		Set pNS = $ZConvert(pNS, "U")
		
		Set tConfigItem = ##class(HS.Util.Installer.ConfigItem).%OpenId(pNS)
		If '$IsObject($Get(tConfigItem)) {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid namespace specified")
			Quit
		}
		Set tNamespaceTypes = ..#NamespaceTypes
		Set tNamespaceType = tConfigItem.Type
		
		Set tSC = ..ValidateNamespaceType(tNamespaceTypes, tNamespaceType)
		If $$$ISERR(tSC) Quit
		
		If $Get(pFHIRVersion)="" {
			Set tSC = $$$ERROR($$$GeneralError, "FHIR version not specified - must be DSTU2 or STU3")
			Quit
		}
		
		Set pFHIRVersion = $ZConvert(pFHIRVersion,"U")
		
		If '((pFHIRVersion="DSTU2")||(pFHIRVersion="STU3")) {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid FHIR version specified - must be DSTU2 or STU3")
			Quit
		}
		
		Set $Namespace = pNS
		
		Set tSC = ##class(%RoutineMgr).GetWebServerPort(.tPort)
		If $$$ISERR(tSC) Set tSC = $$$ERROR($$$GeneralError, "Could not get web server port") Quit
		Set tHost = $ZConvert($$$HSNetworkHostName, "L")
		
		If $$$HSSecureIsActive {
			Set tSSLHost = $$$HSSecureHostName
			Set tSSLPort = $$$HSSecurePort
		} Else {
			Set tSSLHost = tHost
			Set tSSLPort = ""
		}
		
		Set tSSLConfigName = "DEFAULT"
		
		Set tSC = ##class(HS.Util.SystemAPI).Invoke("CreateSSLConfig", "%", tSSLConfigName, "")
		If $$$ISERR(tSC) Quit
		
		If '##class(Ens.Config.Credentials).%ExistsId($$$HSServiceUserName) {
			Set tSC = ##class(HS.HC.Util.Installer).SetCredential(pNS,$$$HSServiceUserName,$$$HSServiceUserName,"HS_Services",0)
			If $$$ISERR(tSC) Quit
		}
		
		Set tSC = ..AddProductionMods(pNS, pFHIRVersion)
		If $$$ISERR(tSC) Quit
		
		If $Get(pCSPApp)="" {
			Set pCSPApp = "/csp/healthshare/"_$ZConvert(pNS, "L")_"/pixm/"_$ZConvert(pFHIRVersion,"L")
		} ElseIf pCSPApp="/" {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid pixm application specified - cannot be /")
		} Else {
			If $Extract(pCSPApp)'="/" Set pCSPApp = "/"_pCSPApp
			If $Extract(pCSPApp,*)="/" Set pCSPApp = $Extract(pCSPApp,1,*-1)
		}
		
		If $Get(pCSPOIDCApp)="" {
			Set pCSPOIDCApp = "/csp/healthshare/"_$ZConvert(pNS, "L")_"/pixm-oidc/"_$ZConvert(pFHIRVersion,"L")
		} ElseIf pCSPOIDCApp="/" {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid pixm application specified - cannot be /")
		} Else {
			If $Extract(pCSPOIDCApp)'="/" Set pCSPOIDCApp = "/"_pCSPOIDCApp
			If $Extract(pCSPOIDCApp,*)="/" Set pCSPOIDCApp = $Extract(pCSPOIDCApp,1,*-1)
		}
		
		Set tSC = ..SetupPIXmEndpoint(pNS, tHost, tPort, pCSPApp, tSSLConfigName, $$$HSServiceUserName, pFHIRVersion, 0, tSSLHost, tSSLPort)
		If $$$ISERR(tSC) Quit
		
		Set tSC = ..SetupPIXmEndpoint(pNS, tHost, tPort, pCSPOIDCApp, tSSLConfigName, $$$HSServiceUserName, pFHIRVersion, 1, tSSLHost, tSSLPort)
		If $$$ISERR(tSC) Quit
		
		Set tSubVals("CustomURL") = pCSPApp
		
		Set tSC = ..AddHSREGISTRYRegistryEntries(pNS, pCSPApp)
		If $$$ISERR(tSC) Quit
		
		Set tSC = ..AddConfigKeys(pNS)
		If $$$ISERR(tSC) Quit
		
		Set tSC = ##class(Ens.Director).GetProductionStatus(.tProdName, .tProdStatus)
		If $$$ISERR(tSC) Quit
		
		If tProdStatus=$$$eProductionStateStopped {
			Set tSC = ##class(HS.HC.Util.Installer).StartProduction(pNS, tProdName)
			Write !
		} ElseIf tProdStatus=$$$eProductionStateRunning {
			Set tSC = ##class(Ens.Director).UpdateProduction()
			Write !
		} ElseIf tProdStatus=$$$eProductionStateSuspended {
			Set tSC = $$$ERROR($$$GeneralError, "Production is currently suspended - cannot activate changes")
		} ElseIf tProdStatus=$$$eProductionStateTroubled {
			Set tSC = $$$ERROR($$$GeneralError, "Production is currently troubled - cannot activate changes")
		}
		If $$$ISERR(tSC) Quit
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	If $$$WriteProg {
		If $$$ISERR(tSC) {
			Write !,..%ClassName(1)_" "_$$$CurrentMethod_" ERROR - "_$system.Status.GetErrorText(tSC)
		} Else {
			Write !,..%ClassName(1)_" completed successfully"
		}
	}
	
	Quit tSC
}

ClassMethod SetupPIXmEndpoint(pNS As %String, pHost As %String, pPort As %String, pCSPAppName As %String, pSSLConfigName As %String, pCredentialName As %String, pFHIRVersion As %String, pIsOIDC As %Boolean, pSSLHost As %String, pSSLPort As %String) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	New $Namespace
	
	Try {
		Set tConformanceId = "IHE.PIXm.Manager"
		
		Set $Namespace = "%SYS"
		
		Set tAppObj = ##class(Security.Applications).%OpenId(pCSPAppName)
		Set tAppExists = $IsObject(tAppObj)
		Kill tAppObj
		
		Set tInstanceName = ##class(%SYS.System).GetInstanceName()
		
		Set $Namespace = pNS
		
		If 'tAppExists {
			#; This is not a user portal, however this flag gets the settings we need:
			#; CSP/ZEN enabled and Inbound Web Services disabled
			Set tIsUserPortal = 1
			Set tDescription = "FHIR "_pFHIRVersion_" PIXm Manager service"
			set tRoles="%DB_"_$tr(pNS,"%")_",%DB_HSLIB,%DB_HSSYS"
			Set tCookiePath = ""
			Set tSC = ##class(HS.Util.SystemAPI).Invoke("CreateCSPApp", pNS, tIsUserPortal, pCSPAppName, pNS, "csp/healthshare/"_pNS, tDescription, tRoles, tCookiePath)
			If $$$ISERR(tSC) Quit
			If 'pIsOIDC {
				Set tProps("AutheEnabled") = $$$AutheCache
			} Else {
				Set tProps("AutheEnabled") = $$$AutheUnauthenticated
			}
			Set tProps("DispatchClass") = "HS.FHIR.v"_pFHIRVersion_".REST.Handler"
			Set tSC=##class(HS.Util.SystemAPI).Invoke("UpdateCSPApp",pNS,pCSPAppName,$$$NVPairToList(tProps))
			If $$$ISERR(tSC) Quit
		} Else {
			If $$$WriteProg {
				Write !,"CSP application "_pCSPAppName_" already exists - will not be updated",!
			}
		}
		
		Set tFHIRCSPConfigObj = ##class(HS.Registry.FHIRCSPConfig).URLIndexOpen(pCSPAppName)
		If '$IsObject($Get(tFHIRCSPConfigObj)) {
			Set tFHIRCSPConfigObj = ##class(HS.Registry.FHIRCSPConfig).%New()
			Set tFHIRCSPConfigObj.URL = pCSPAppName
			Set tFHIRCSPConfigObj.FHIRVersion = pFHIRVersion
			Set tFHIRCSPConfigObj.ServiceConfigName = "HS.FHIR.PIXm.Manager.Service."_pFHIRVersion
			Set tFHIRCSPConfigObj.ServiceClassName = "HS.FHIR.Service"
			Set tFHIRCSPConfigObj.ConformanceId = tConformanceId
			If pIsOIDC {
				Set tFHIRCSPConfigObj.UseOAuth = 1
				Set tFHIRCSPConfigObj.ResourceServerOAuthClient = tInstanceName_".RSClient"
			}
			Set tSC = tFHIRCSPConfigObj.%Save()
		} Else {
			Kill tFHIRCSPConfigObj
		}
		
		If 'pIsOIDC {
			Set tServiceName = "PIXm.Manager."_pFHIRVersion
			Set tID = ##class(HS.Registry.Service.HTTP).IDForNameType(tServiceName, "HTTP")
			If tID="" {
				Set tService = ##class(HS.Registry.Service.HTTP).%New()
				Set tService.Name = tServiceName
				Set tService.Type = "HTTP"
				Set tService.Host = pHost
				Set tService.Port = pPort
				Set tService.URL = pCSPAppName
				Set tService.HTTPCredentialsConfig = pCredentialName
				Set tService.DeviceFunction = "PIXm.Manager"
				Set tSC = tService.%Save()
				If $$$ISERR(tSC) Quit
			}
			
			Set tServiceName = "PIXm.ManagerSSL."_pFHIRVersion
			Set tID = ##class(HS.Registry.Service.HTTP).IDForNameType(tServiceName, "HTTP")
			If tID="" {
				Set tService = ##class(HS.Registry.Service.HTTP).%New()
				Set tService.Name = tServiceName
				Set tService.Type = "HTTP"
				Set tService.Host = pSSLHost
				Set tService.Port = pSSLPort
				Set tService.URL = pCSPAppName
				Set tService.HTTPCredentialsConfig = pCredentialName
				Set tService.DeviceFunction = "PIXm.Manager"
				Set tService.SSLConfig = pSSLConfigName
				Set tSC = tService.%Save()
				If $$$ISERR(tSC) Quit
			}
		
		} Else {
			Set tServiceName = "PIXm.ManagerOIDC."_pFHIRVersion
			Set tID = ##class(HS.Registry.Service.HTTP).IDForNameType(tServiceName, "HTTP")
			If tID="" {
				Set tService = ##class(HS.Registry.Service.HTTP).%New()
				Set tService.Name = tServiceName
				Set tService.Type = "HTTP"
				Set tService.Host = pSSLHost
				Set tService.Port = pSSLPort
				Set tService.URL = pCSPAppName
				Set tService.DeviceFunction = "PIXm.Manager"
				Set tService.SSLConfig = pSSLConfigName
				Set tSC = tService.%Save()
				If $$$ISERR(tSC) Quit
			}
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

ClassMethod ValidateNamespaceType(pNamespaceTypes As %String, pNamespaceType As %String) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		If '((","_pNamespaceTypes_",")[(","_pNamespaceType_",")) {
			Set tSC = $$$ERROR($$$GeneralError, "Namespace type "_pNamespaceType_" is invalid for this installer")
			Quit
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

ClassMethod AddProductionMods(pNamespace As %String, pFHIRVersion As %String) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		Set tSC = ..ProductionMods(pNamespace, "FoundationItems"_pFHIRVersion, 1)
		If $$$ISERR(tSC) Quit
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

ClassMethod AddHSREGISTRYRegistryEntries(pNamespace As %String, pCSPApp As %String) As %Status [ Internal ]
{
	Quit $$$OK
}

ClassMethod AddConfigKeys(pNamespace As %String) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	New $Namespace
	
	Set $Namespace = pNamespace
	
	Try {
		If ##class(HS.Registry.Config).GetKeyValue("\IHE\AffinityDomain")="" {
			Set tSC = ##class(HS.Registry.Config).AddUpdateKeyValue("\IHE\AffinityDomain","HomeCommunity")
			If $$$ISERR(tSC) Quit
		}
		If ##class(HS.Registry.Config).GetKeyValue("\IHE\HomeCommunity")="" {
			Set tSC = ##class(HS.Registry.Config).AddUpdateKeyValue("\IHE\HomeCommunity","HomeCommunity")
			If $$$ISERR(tSC) Quit
		}
		If ##class(HS.Data.OIDMap).GetOIDForCode("HomeCommunity","")="" {
			Set tSC = ##class(HS.Data.OIDMap).FileOID("HomeCommunity", "AssigningAuthority", "1.3.6.1.4.1.21367.2010.1.2.300", "Home Community","HomeCommunity")
			If $$$ISERR(tSC) Quit
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

XData FoundationItemsDSTU2
{
<Items>
  <Item Name="HS.Test.Service" Category="" ClassName="HS.Test.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="PIXmConsumerOperationsDSTU2">HS.FHIR.PIXm.Consumer.Operations.DSTU2</Setting>
  </Item>
  <Item Name="HS.FHIR.PIXm.Manager.Service.DSTU2" Category="" ClassName="HS.FHIR.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">HS.FHIR.PIXm.Manager.Process.DSTU2</Setting>
    <Setting Target="Host" Name="FHIRVersion">DSTU2</Setting>
  </Item>
  <Item Name="HS.FHIR.PIXm.Manager.Process.DSTU2" Category="" ClassName="HS.FHIR.vDSTU2.PIXm.Manager.Process" PoolSize="2" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MPIOperations"></Setting>
    <Setting Target="Host" Name="HUB"></Setting>
  </Item>
  <Item Name="HS.FHIR.PIXm.Consumer.Operations.DSTU2" Category="" ClassName="HS.FHIR.vDSTU2.PIXm.Consumer.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ServiceName">PIXm.Manager.DSTU2</Setting>
    <Setting Target="Host" Name="FHIRVersion">DSTU2</Setting>
  </Item>
  <Item Name="HS.Util.Trace.Operations" Category="" ClassName="HS.Util.Trace.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Items>
}

XData FoundationItemsSTU3
{
<Items>
  <Item Name="HS.Test.Service" Category="" ClassName="HS.Test.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="PIXmConsumerOperationsSTU3">HS.FHIR.PIXm.Consumer.Operations.STU3</Setting>
  </Item>
  <Item Name="HS.FHIR.PIXm.Manager.Service.STU3" Category="" ClassName="HS.FHIR.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">HS.FHIR.PIXm.Manager.Process.STU3</Setting>
    <Setting Target="Host" Name="FHIRVersion">STU3</Setting>
  </Item>
  <Item Name="HS.FHIR.PIXm.Manager.Process.STU3" Category="" ClassName="HS.FHIR.vSTU3.PIXm.Manager.Process" PoolSize="2" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MPIOperations"></Setting>
    <Setting Target="Host" Name="HUB"></Setting>
  </Item>
  <Item Name="HS.FHIR.PIXm.Consumer.Operations.STU3" Category="" ClassName="HS.FHIR.vSTU3.PIXm.Consumer.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ServiceName">PIXm.Manager.STU3</Setting>
    <Setting Target="Host" Name="FHIRVersion">STU3</Setting>
  </Item>
  <Item Name="HS.Util.Trace.Operations" Category="" ClassName="HS.Util.Trace.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Items>
}

/// UpdatePIXmHosts carries out its work only if HS.IHE.PIX.Manager.Process is present and is
/// being used for FHIR PIXm.  If so, then this method adds HS.FHIR.PIXm.Manager.Process, updates
/// TargetConfigName on HS.FHIR.PIXm.Manager.Service to point at HS.FHIR.PIXm.Manager.Process,
/// and removes HS.IHE.PIX.Manager.Process if there no non-FHIR use for it.
ClassMethod UpdatePIXmHosts(pNamespace As %String) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		Set $Namespace = pNamespace
		
		Set tSC = ..GetProduction(.tProdObj)
		If $$$ISERR(tSC) {
			// Production not found means that there is no current production, or the
			// current namespace production does not extend HS.Util.AbstractProduction,
			// in which case we will just ignore it.
			If $system.Status.GetErrorText(tSC)["Production Item not found" Set tSC = $$$OK
			Quit
		}
		
		Set tFoundPIXmManagerService = 0
		Set tFoundPIXManagerProcess = 0
		Set tFoundPIXv2ManagerService = 0
		Set tFoundPIXv2ConsumerService = 0
		Set tFoundPIXv3ManagerService = 0
		Set tFoundPIXv3ConsumerService = 0
		
		For tI=1:1:tProdObj.Items.Count() {
			Set tItem=tProdObj.Items.GetAt(tI)
			If (tItem.ClassName="HS.FHIR.Service") && (tItem.Name = "HS.FHIR.PIXm.Manager.Service") {
				Set tFoundPIXmManagerService=1
			} ElseIf tItem.ClassName="HS.IHE.PIX.Manager.Process" {
				Set tFoundPIXManagerProcess=1
			} ElseIf tItem.ClassName="HS.IHE.PIXv2.Manager.Services" {
				Set tFoundPIXv2ManagerService=1
			} ElseIf tItem.ClassName="HS.IHE.PIXv2.Consumer.Services" {
				Set tFoundPIXv2ConsumerService=1
			} ElseIf tItem.ClassName="HS.IHE.PIXv3.Manager.Services" {
				Set tFoundPIXv3ManagerService=1
			} ElseIf tItem.ClassName="HS.IHE.PIXv3.Consumer.Services" {
				Set tFoundPIXv3ConsumerService=1
			}
		}
		
		If 'tFoundPIXmManagerService Quit
		
		Kill tProdObj
		
		// Add HS.FHIR.PIXm.Manager.Process and update TargetConfigName on HS.FHIR.PIXm.Manager.Service.
		Set tSC = ..ProductionMods(pNamespace, "UpdatePIXmHostsItems", 1)
		If $$$ISERR(tSC) Quit
		
		// Remove HS.IHE.PIX.Manager.Process if there is no further need for it.
		// RemoveConfigItem does not consider it an error if the item to remove
		// is not found.
		If '((tFoundPIXv2ManagerService)||(tFoundPIXv2ConsumerService)||(tFoundPIXv3ManagerService)||(tFoundPIXv3ConsumerService)) {
			Set tProduction = ..GetProduction(.tProdObj)
			If $$$ISERR(tSC) Quit
			Set tItem = ##class(Ens.Config.Item).%New()
			Set tItem.ClassName = "HS.IHE.PIX.Manager.Process"
			Set tItem.Name = "HS.IHE.PIX.Manager.Process"
			Set tSC = ..RemoveConfigItem(tItem, tProdObj)
			If $$$ISERR(tSC) Quit
			Set tSC = ##class(HS.Util.Installer.Upgrade.Abstract).SaveProduction(tProdObj)
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

XData UpdatePIXmHostsItems
{
<Items>
  <Item Name="HS.FHIR.PIXm.Manager.Service.DSTU2" Category="" ClassName="HS.FHIR.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">HS.FHIR.PIXm.Manager.Process.DSTU2</Setting>
  </Item>
  <Item Name="HS.FHIR.PIXm.Manager.Process.DSTU2" Category="" ClassName="HS.FHIR.vDSTU2.PIXm.Manager.Process" PoolSize="2" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MPIOperations">HUB</Setting>
  </Item>
</Items>
}

}
