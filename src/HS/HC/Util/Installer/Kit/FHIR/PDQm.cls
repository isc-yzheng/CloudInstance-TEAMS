Include %ZHSLIB

/// HS.HC.Util.Installer.Kit.FHIR.PDQm adds a starting set of production components
/// and definitions needed for handling the IHE PDQm profile in a Foundation type
/// namespace. Note that the user will need to manually configure the client-side
/// components and definitions.<br>
/// <br>
/// Example call to this class for setting up PDQm for FHIR DSTU2:<br>
/// <br>
/// Set status = ##class(HS.HC.Util.Installer.Kit.FHIR.PDQm).Add( , "FHIR", "DSTU2", "/csp/pdqm", "/csp/pdqm-oidc")<br>
/// <br>
/// Example call to this class for setting up PDQm for FHIR STU3:<br>
/// <br>
/// Set status = ##class(HS.HC.Util.Installer.Kit.FHIR.PDQm).Add( , "FHIR", "STU3", "/csp/pdqm", "/csp/pdqm-oidc")<br>
/// 
Class HS.HC.Util.Installer.Kit.FHIR.PDQm Extends HS.Util.Installer.Kit.Base
{

Parameter NamespaceTypes As %String = "Foundation";

/// This method calls the AddPDQm() method to add the PDQm production components and definitions.<br>
/// <br>Inputs:<br>
/// <li>pNamespaces   : (not used, leave blank)
/// <li>pFoundationNS : (required) The name of a Foundation type namespace.
/// <li>pFHIRVersion  : (required) Version of FHIR IHE profile to support - "DSTU2" or "STU3".
/// <li>pCSPApp       : CSP application to use for the PDQm end point. If no value is specified, then
///                     the value is "/csp/healthshare/<i>namespace_name</i>/pdqm/<i>fhir_version</i>".
/// <li>pCSPOIDCApp   : CSP application to use for the Open ID Connect / OAuth 2.0 enabled
///                     PDQm end point. If not specified, the value is
///                     "/csp/healthshare/<i>namespace_name</i>/pdqm-oidc/<i>fhir_version</i>"
ClassMethod Add(pNamespaces As HS.Util.Installer.Kit.Namespaces = "", pFoundationNS As %String = {$Namespace}, pFHIRVersion As %String, pCSPApp As %String = "", pCSPOIDCApp As %String = "") As %Status
{
	Quit ..AddPDQm(pNamespaces, pFoundationNS, $Get(pFHIRVersion), pCSPApp, pCSPOIDCApp)
}

/// This method calls the AddPDQm() method to add the PDQm production components and definitions.<br>
/// <br>Inputs:<br>
/// <li>pNamespaces  : (not used, leave blank)
/// <li>pNS          : (required) The name of a Foundation type namespace.
/// <li>pFHIRVersion : (required) Version of FHIR IHE profile to support - "DSTU2" or "STU3".
/// <li>pCSPApp      : CSP application to use for the PDQm end point. If no value is specified, then
///                    the value is "/csp/healthshare/<i>namespace_name</i>/pdqm/<i>fhir_version</i>".
/// <li>pCSPOIDCApp  : CSP application to use for the Open ID Connect / OAuth 2.0 enabled
///                    PDQm end point. If not specified, the value is
///                    "/csp/healthshare/<i>namespace_name</i>/pdqm-oidc/<i>fhir_version</i>"
ClassMethod AddFoundation(pNamespaces As HS.Util.Installer.Kit.Namespaces = "", pNS = {$Namespace}, pFHIRVersion As %String, pCSPApp As %String = "", pCSPOIDCApp As %String = "") As %Status
{
	Quit ..AddPDQm(pNamespaces, pNS, $Get(pFHIRVersion), pCSPApp, pCSPOIDCApp)
}

/// AddPDQm adds the PDQm production components and definitions.<br>
/// <br>Inputs:<br>
/// <li>pNamespaces  : (not used, leave blank)
/// <li>pNS          : (required) The name of a Foundation or Hub type namespace.
/// <li>pFHIRVersion : (required) Version of FHIR IHE profile to support - "DSTU2" or "STU3".
/// <li>pCSPApp      : CSP application to use for the PDQm end point. If no value is specified, then
///                    the value is "/csp/healthshare/<i>namespace_name</i>/pdqm/<i>fhir_version</i>".
/// <li>pCSPOIDCApp  : CSP application to use for the Open ID Connect / OAuth 2.0 enabled
///                    PDQm end point. If not specified, the value is
///                    "/csp/healthshare/<i>namespace_name</i>/pdqm-oidc/<i>fhir_version</i>"
ClassMethod AddPDQm(pNamespaces As HS.Util.Installer.Kit.Namespaces = "", pNS = {$Namespace}, pFHIRVersion As %String, pCSPApp As %String = "", pCSPOIDCApp As %String = "") As %Status
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
			Set tSC = $$$ERROR($$$GeneralError, "Invalid FHIR version not specified - must be DSTU2 or STU3")
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
			Set pCSPApp = "/csp/healthshare/"_$ZConvert(pNS, "L")_"/pdqm/"_$ZConvert(pFHIRVersion,"L")
		} ElseIf pCSPApp="/" {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid pdqm application specified - cannot be /")
		} Else {
			If $Extract(pCSPApp)'="/" Set pCSPApp = "/"_pCSPApp
			If $Extract(pCSPApp,*)="/" Set pCSPApp = $Extract(pCSPApp,1,*-1)
		}
		
		If $Get(pCSPOIDCApp)="" {
			Set pCSPOIDCApp = "/csp/healthshare/"_$ZConvert(pNS, "L")_"/pdqm-oidc/"_$ZConvert(pFHIRVersion,"L")
		} ElseIf pCSPOIDCApp="/" {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid pdqm application specified - cannot be /")
		} Else {
			If $Extract(pCSPOIDCApp)'="/" Set pCSPOIDCApp = "/"_pCSPOIDCApp
			If $Extract(pCSPOIDCApp,*)="/" Set pCSPOIDCApp = $Extract(pCSPOIDCApp,1,*-1)
		}
		
		Set tSC = ..SetupPDQmEndpoint(pNS, tHost, tPort, pCSPApp, tSSLConfigName, $$$HSServiceUserName, pFHIRVersion, 0, tSSLHost, tSSLPort)
		If $$$ISERR(tSC) Quit
		
		Set tSC = ..SetupPDQmEndpoint(pNS, tHost, tPort, pCSPOIDCApp, tSSLConfigName, $$$HSServiceUserName, pFHIRVersion, 1, tSSLHost, tSSLPort)
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

ClassMethod SetupPDQmEndpoint(pNS As %String, pHost As %String, pPort As %String, pCSPAppName As %String, pSSLConfigName As %String, pCredentialName As %String, pFHIRVersion As %String, pIsOIDC As %Boolean, pSSLHost As %String, pSSLPort As %String) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	New $Namespace
	
	Try {
		Set tConformanceId = "IHE.PDQm.supplier"
		
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
			Set tDescription = "FHIR "_pFHIRVersion_" PDQm Supplier service"
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
			Set tFHIRCSPConfigObj.ServiceConfigName = "HS.FHIR.PDQm.Supplier.Service."_pFHIRVersion
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
			Set tServiceName = "PDQm.Supplier."_pFHIRVersion
			Set tID = ##class(HS.Registry.Service.HTTP).IDForNameType(tServiceName, "HTTP")
			If tID="" {
				Set tService = ##class(HS.Registry.Service.HTTP).%New()
				Set tService.Name = tServiceName
				Set tService.Type = "HTTP"
				Set tService.Host = pHost
				Set tService.Port = pPort
				Set tService.URL = pCSPAppName
				Set tService.HTTPCredentialsConfig = pCredentialName
				Set tService.DeviceFunction = "PDQm.Supplier"
				Set tSC = tService.%Save()
				If $$$ISERR(tSC) Quit
			}
			
			Set tServiceName = "PDQm.SupplierSSL."_pFHIRVersion
			Set tID = ##class(HS.Registry.Service.HTTP).IDForNameType(tServiceName, "HTTP")
			If tID="" {
				Set tService = ##class(HS.Registry.Service.HTTP).%New()
				Set tService.Name = tServiceName
				Set tService.Type = "HTTP"
				Set tService.Host = pSSLHost
				Set tService.Port = pSSLPort
				Set tService.URL = pCSPAppName
				Set tService.HTTPCredentialsConfig = pCredentialName
				Set tService.DeviceFunction = "PDQm.Supplier"
				Set tService.SSLConfig = pSSLConfigName
				Set tSC = tService.%Save()
				If $$$ISERR(tSC) Quit
			}
		
		} Else {
			Set tServiceName = "PDQm.SupplierOIDC."_pFHIRVersion
			Set tID = ##class(HS.Registry.Service.HTTP).IDForNameType(tServiceName, "HTTP")
			If tID="" {
				Set tService = ##class(HS.Registry.Service.HTTP).%New()
				Set tService.Name = tServiceName
				Set tService.Type = "HTTP"
				Set tService.Host = pSSLHost
				Set tService.Port = pSSLPort
				Set tService.URL = pCSPAppName
				Set tService.DeviceFunction = "PDQm.Supplier"
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
    <Setting Target="Host" Name="PDQmConsumerOperationsDSTU2">HS.FHIR.PDQm.Consumer.Operations.DSTU2</Setting>
  </Item>
  <Item Name="HS.FHIR.PDQm.Supplier.Service.DSTU2" Category="" ClassName="HS.FHIR.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">HS.FHIR.PDQm.Supplier.Process.DSTU2</Setting>
    <Setting Target="Host" Name="FHIRVersion">DSTU2</Setting>
  </Item>
  <Item Name="HS.FHIR.PDQm.Supplier.Process.DSTU2" Category="" ClassName="HS.FHIR.vDSTU2.PDQm.Supplier.Process" PoolSize="2" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MPIOperations"></Setting>
  </Item>
  <Item Name="HS.FHIR.PDQm.Consumer.Operations.DSTU2" Category="" ClassName="HS.FHIR.vDSTU2.PDQm.Consumer.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ServiceName">PDQm.Supplier.DSTU2</Setting>
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
    <Setting Target="Host" Name="PDQmConsumerOperationsSTU3">HS.FHIR.PDQm.Consumer.Operations.STU3</Setting>
  </Item>
  <Item Name="HS.FHIR.PDQm.Supplier.Service.STU3" Category="" ClassName="HS.FHIR.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">HS.FHIR.PDQm.Supplier.Process.STU3</Setting>
    <Setting Target="Host" Name="FHIRVersion">STU3</Setting>
  </Item>
  <Item Name="HS.FHIR.PDQm.Supplier.Process.STU3" Category="" ClassName="HS.FHIR.vSTU3.PDQm.Supplier.Process" PoolSize="2" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MPIOperations"></Setting>
  </Item>
  <Item Name="HS.FHIR.PDQm.Consumer.Operations.STU3" Category="" ClassName="HS.FHIR.vSTU3.PDQm.Consumer.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ServiceName">PDQm.Supplier.STU3</Setting>
    <Setting Target="Host" Name="FHIRVersion">STU3</Setting>
  </Item>
  <Item Name="HS.Util.Trace.Operations" Category="" ClassName="HS.Util.Trace.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Items>
}

/// UpdatePDQmHosts carries out its work only if HS.IHE.PDQ.Supplier.Process is present and is
/// being used for FHIR PDQm.  If so, then this method adds HS.FHIR.PDQm.Supplier.Process, updates
/// TargetConfigName on HS.FHIR.PDQm.Supplier.Service to point at HS.FHIR.PDQm.Supplier.Process,
/// and removes HS.IHE.PDQ.Supplier.Process if there no non-FHIR use for it.
ClassMethod UpdatePDQmHosts(pNamespace As %String) As %Status [ Internal ]
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
		
		Set tFoundPDQmSupplierService = 0
		Set tFoundPDQSupplierProcess = 0
		Set tFoundPDQv2SupplierService = 0
		Set tFoundPDQv3SupplierService = 0
		
		For tI=1:1:tProdObj.Items.Count() {
			Set tItem=tProdObj.Items.GetAt(tI)
			If (tItem.ClassName="HS.FHIR.Service") && (tItem.Name = "HS.FHIR.PDQm.Supplier.Service") {
				Set tFoundPDQmSupplierService=1
			} ElseIf tItem.ClassName="HS.IHE.PDQ.Supplier.Process" {
				Set tFoundPDQSupplierProcess=1
			} ElseIf tItem.ClassName="HS.IHE.PDQv2.Supplier.Services" {
				Set tFoundPDQv2SupplierService=1
			} ElseIf tItem.ClassName="HS.IHE.PDQv3.Supplier.Services" {
				Set tFoundPDQv3SupplierService=1
			}
		}
		
		If 'tFoundPDQmSupplierService Quit
		
		Kill tProdObj
		
		// Add HS.FHIR.PDQm.Supplier.Process and update TargetConfigName on HS.FHIR.PDQm.Supplier.Service.
		Set tSC = ..ProductionMods(pNamespace, "UpdatePDQmHostsItems", 1)
		If $$$ISERR(tSC) Quit
		
		// Remove HS.IHE.PDQ.Supplier.Process if there is no further need for it.
		// RemoveConfigItem does not consider it an error if the item to remove
		// is not found.
		If '((tFoundPDQv2SupplierService)||(tFoundPDQv3SupplierService)) {
			Set tSC = ..GetProduction(.tProdObj)
			If $$$ISERR(tSC) Quit
			Set tItem = ##class(Ens.Config.Item).%New()
			Set tItem.ClassName = "HS.IHE.PDQ.Supplier.Process"
			Set tItem.Name = "HS.IHE.PDQ.Supplier.Process"
			Set tSC = ..RemoveConfigItem(tItem, tProdObj)
			If $$$ISERR(tSC) Quit
			Set tSC = ##class(HS.Util.Installer.Upgrade.Abstract).SaveProduction(tProdObj)
		}
		
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

XData UpdatePDQmHostsItems
{
<Items>
  <Item Name="HS.FHIR.PDQm.Supplier.Service.DSTU2" Category="" ClassName="HS.FHIR.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">HS.FHIR.PDQm.Supplier.Process.DSTU2</Setting>
  </Item>
  <Item Name="HS.FHIR.PDQm.Supplier.Process.DSTU2" Category="" ClassName="HS.FHIR.vDSTU2.PDQm.Supplier.Process" PoolSize="2" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MPIOperations">HUB</Setting>
  </Item>
</Items>
}

}
