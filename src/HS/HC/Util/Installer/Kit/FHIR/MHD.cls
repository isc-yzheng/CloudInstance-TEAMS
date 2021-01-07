Include %ZHSLIB

/// HS.HC.Util.Installer.Kit.FHIR.MHD adds production components and definitions
/// needed for handling the IHE MHD profile in a Foundation type namespace.<br>
/// <br>
/// Example call to this class for setting up MHD for FHIR DSTU2:<br>
/// <br>
/// Set status = ##class(HS.HC.Util.Installer.Kit.FHIR.MHD).Add( , "FHIR", "DSTU2", "/csp/mhdrecipient", "/csp/mhdrecipient-oidc", "/csp/mhdresponder", "/csp/mhdresponder-oidc")<br>
/// <br>
/// Example call to this class for setting up MHD for FHIR STU3:<br>
/// <br>
/// Set status = ##class(HS.HC.Util.Installer.Kit.FHIR.MHD).Add( , "FHIR", "STU3", "/csp/mhdrecipient", "/csp/mhdrecipient-oidc", "/csp/mhdresponder", "/csp/mhdresponder-oidc")
/// 
Class HS.HC.Util.Installer.Kit.FHIR.MHD Extends HS.Util.Installer.Kit.Base
{

Parameter NamespaceTypes As %String = "Foundation";

/// This method calls AddMHD() to add the MHD production components and definitions.<br>
/// <br>Inputs:<br>
/// <li>pNamespaces   : (not used, leave blank)
/// <li>pFoundationNS : (required) The name of a Foundation type namespace.
/// <li>pFHIRVersion  : (required) Version of FHIR IHE profile to support - "DSTU2" or "STU3".
/// <li>pRecipientApp : CSP application to use for the MHD recipient end point. If not specified, then
///                     the value is "/csp/healthshare/<i>namespace_name</i>/mhdrecipient/<i>fhir_version</i>".
/// <li>pRecipientOIDCApp : CSP application to use for the Open ID Connect / OAuth 2.0 enabled
///                         MHD recipient end point. If not specified, the value is
///                         "/csp/healthshare/<i>namespace_name</i>/mhdrecipient-oidc/<i>fhir_version</i>"
/// <li>pResponderApp : CSP application to use for the MHD responder end point. If not specified, then
///                     the value is "/csp/healthshare/<i>namespace_name</i>/mhdresponder/<i>fhir_version</i>".
/// <li>pRecipientOIDCApp : CSP application to use for the Open ID Connect / OAuth 2.0 enabled
///                         MHD responder end point. If not specified, the value is
///                         "/csp/healthshare/<i>namespace_name</i>/mhdresponder-oidc/<i>fhir_version</i>"
ClassMethod Add(pNamespaces As HS.Util.Installer.Kit.Namespaces = "", pFoundationNS As %String = {$Namespace}, pFHIRVersion As %String, pRecipientApp As %String = "", pRecipientOIDCApp As %String = "", pResponderApp As %String = "", pResponderOIDCApp As %String = "") As %Status
{
	Quit ..AddMHD(pNamespaces, pFoundationNS, $Get(pFHIRVersion), pRecipientApp, pRecipientOIDCApp, pResponderApp, pResponderOIDCApp)
}

/// This method calls AddMHD() to add the MHD production components and definitions.<br>
/// <br>Inputs:<br>
/// <li>pNamespaces   : (not used, leave blank)
/// <li>pNS           : (required) The name of a Foundation type namespace.
/// <li>pFHIRVersion  : (required) Version of FHIR IHE profile to support - "DSTU2" or "STU3".
/// <li>pRecipientApp : CSP application to use for the MHD recipient end point. If not specified, then
///                     the value is "/csp/healthshare/<i>namespace_name</i>/mhdrecipient/<i>fhir_version</i>".
/// <li>pRecipientOIDCApp : CSP application to use for the Open ID Connect / OAuth 2.0 enabled
///                         MHD recipient end point. If not specified, the value is
///                         "/csp/healthshare/<i>namespace_name</i>/mhdrecipient-oidc/<i>fhir_version</i>"
/// <li>pResponderApp : CSP application to use for the MHD responder end point. If not specified, then
///                     the value is "/csp/healthshare/<i>namespace_name</i>/mhdresponder/<i>fhir_version</i>".
/// <li>pRecipientOIDCApp : CSP application to use for the Open ID Connect / OAuth 2.0 enabled
///                         MHD responder end point. If not specified, the value is
///                         "/csp/healthshare/<i>namespace_name</i>/mhdresponder-oidc/<i>fhir_version</i>"
ClassMethod AddFoundation(pNamespaces As HS.Util.Installer.Kit.Namespaces = "", pNS = {$Namespace}, pFHIRVersion As %String, pRecipientApp As %String = "", pRecipientOIDCApp As %String = "", pResponderApp As %String = "", pResponderOIDCApp As %String = "") As %Status
{
	Quit ..AddMHD(pNamespaces, pNS, $Get(pFHIRVersion), pRecipientApp, pRecipientOIDCApp, pResponderApp, pResponderOIDCApp)
}

/// AddMHD() adds the MHD production components and definitions.<br>
/// <br>Inputs:<br>
/// <li>pNamespaces   : (not used, leave blank)
/// <li>pNS           : (required) The name of a Foundation type namespace.
/// <li>pFHIRVersion  : (required) Version of FHIR IHE profile to support - "DSTU2" or "STU3".
/// <li>pRecipientApp : CSP application to use for the MHD recipient end point. If not specified, then
///                     the value is "/csp/healthshare/<i>namespace_name</i>/mhdrecipient/<i>fhir_version</i>".
/// <li>pRecipientOIDCApp : CSP application to use for the Open ID Connect / OAuth 2.0 enabled
///                         MHD recipient end point. If not specified, the value is
///                         "/csp/healthshare/<i>namespace_name</i>/mhdrecipient-oidc/<i>fhir_version</i>"
/// <li>pResponderApp : CSP application to use for the MHD responder end point. If not specified, then
///                     the value is "/csp/healthshare/<i>namespace_name</i>/mhdresponder/<i>fhir_version</i>".
/// <li>pRecipientOIDCApp : CSP application to use for the Open ID Connect / OAuth 2.0 enabled
///                         MHD responder end point. If not specified, the value is
///                         "/csp/healthshare/<i>namespace_name</i>/mhdresponder-oidc/<i>fhir_version</i>"
ClassMethod AddMHD(pNamespaces As HS.Util.Installer.Kit.Namespaces = "", pNS = {$Namespace}, pFHIRVersion As %String, pRecipientApp As %String = "", pRecipientOIDCApp As %String = "", pResponderApp As %String = "", pResponderOIDCApp As %String = "") As %Status
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
		
		If $Get(pRecipientApp)="" {
			Set pRecipientApp = "/csp/healthshare/"_$ZConvert(pNS, "L")_"/mhdrecipient/"_$ZConvert(pFHIRVersion,"L")
		} ElseIf pRecipientApp="/" {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid recipient application specified - cannot be /")
		} Else {
			If $Extract(pRecipientApp)'="/" Set pRecipientApp = "/"_pRecipientApp
			If $Extract(pRecipientApp,*)="/" Set pRecipientApp = $Extract(pRecipientApp,1,*-1)
		}
		
		If $Get(pRecipientOIDCApp)="" {
			Set pRecipientOIDCApp = "/csp/healthshare/"_$ZConvert(pNS, "L")_"/mhdrecipient-oidc/"_$ZConvert(pFHIRVersion,"L")
		} ElseIf pRecipientOIDCApp="/" {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid recipient application specified - cannot be /")
		} Else {
			If $Extract(pRecipientOIDCApp)'="/" Set pRecipientOIDCApp = "/"_pRecipientOIDCApp
			If $Extract(pRecipientOIDCApp,*)="/" Set pRecipientOIDCApp = $Extract(pRecipientOIDCApp,1,*-1)
		}
		
		If $Get(pResponderApp)="" {
			Set pResponderApp = "/csp/healthshare/"_$ZConvert(pNS, "L")_"/mhdresponder/"_$ZConvert(pFHIRVersion,"L")
		} ElseIf pResponderApp="/" {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid responder application specified - cannot be /")
		} Else {
			If $Extract(pResponderApp)'="/" Set pResponderApp = "/"_pResponderApp
			If $Extract(pResponderApp,*)="/" Set pResponderApp = $Extract(pResponderApp,1,*-1)
		}
		
		If $Get(pResponderOIDCApp)="" {
			Set pResponderOIDCApp = "/csp/healthshare/"_$ZConvert(pNS, "L")_"/mhdresponder-oidc/"_$ZConvert(pFHIRVersion,"L")
		} ElseIf pResponderOIDCApp="/" {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid responder application specified - cannot be /")
		} Else {
			If $Extract(pResponderOIDCApp)'="/" Set pResponderOIDCApp = "/"_pResponderOIDCApp
			If $Extract(pResponderOIDCApp,*)="/" Set pResponderOIDCApp = $Extract(pRecipientOIDCApp,1,*-1)
		}
		
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
			Set tSC = ##class(HS.HC.Util.Installer).SetCredential(pNS, $$$HSServiceUserName, $$$HSServiceUserName, "HS_Services", 0)
			If $$$ISERR(tSC) Quit
		}
		
		Set tSC = ..ProductionMods(pNS,"ProductionItems"_pFHIRVersion,1) Quit:$$$ISERR(tSC)
		
		Set tSC = ..ProductionMods(pNS,"XDSbConsumerOps",1)
		Quit:$$$ISERR(tSC)
		
		Set tSC = ..SetupResponderEndpoint(pNS, tHost, tPort, pResponderApp, tSSLConfigName, $$$HSServiceUserName, pFHIRVersion, 0, tSSLHost, tSSLPort)
		If $$$ISERR(tSC) Quit
		
		Set tSC = ..SetupResponderEndpoint(pNS, tHost, tPort, pResponderOIDCApp, tSSLConfigName, $$$HSServiceUserName, pFHIRVersion, 1, tSSLHost, tSSLPort)
		If $$$ISERR(tSC) Quit
		
		Set tSC = ..SetupRecipientEndpoint(pNS, tHost, tPort, pRecipientApp, tSSLConfigName, $$$HSServiceUserName, pFHIRVersion, 0, tSSLHost, tSSLPort)
		If $$$ISERR(tSC) Quit
		
		Set tSC = ..SetupRecipientEndpoint(pNS, tHost, tPort, pRecipientOIDCApp, tSSLConfigName, $$$HSServiceUserName, pFHIRVersion, 1, tSSLHost, tSSLPort)
		If $$$ISERR(tSC) Quit
		
		Set tSC = ..%New().AddRegistryEntries()
		If $$$ISERR(tSC) Quit
		
		Set tSC = ..AddConfigKeys(pNS)
		If $$$ISERR(tSC) Quit
		
		// We are assuming that a hub namespace already has XDSb set up the way it
		// wants, so do not update the IHE Coded Entry table there.
		If tNamespaceType="Foundation" {
			Set tSC = ##class(HS.Util.Installer.Kit.PostInstall.XDSbCodes).RunHub()
			If $$$ISERR(tSC) Quit
		}
		
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
		If ##class(HS.Data.OIDMap).GetOIDForCode("HSREPOSITORY","")="" {
			Set tSC = ##class(HS.Data.OIDMap).FileOID("HSREPOSITORY", "Repository", "1.3.6.1.4.1.21367.2010.1.2.300.1", "HSREPOSITORY")
			If $$$ISERR(tSC) Quit
		}
	
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
	
	Quit tSC
}

/// Sets up the CSP app, FHIR CSP Configuration entry, and Service
/// Registry entries for the MHD Responder end point.  For each
/// item to be set up, if the item already exists then this method
/// does not update it.
ClassMethod SetupResponderEndpoint(pNS As %String, pHost As %String, pPort As %String, pCSPAppName As %String, pSSLConfigName As %String, pCredentialName As %String, pFHIRVersion As %String, pIsOIDC As %Boolean, pSSLHost As %String, pSSLPort As %String) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		Set tConformanceId = "IHE.MHD.DocumentResponder"
		
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
			Set tDescription = "FHIR "_pFHIRVersion_" MHD Responder end point"
			set tRoles="%DB_"_$tr(pNS,"%")_",%DB_HSLIB,%DB_HSSYS"
			Set tCookiePath = ""
			Set tSC = ##class(HS.Util.SystemAPI).Invoke("CreateCSPApp", pNS, tIsUserPortal, pCSPAppName, pNS, "csp/healthshare/"_pNS, tDescription, tRoles, tCookiePath)
			If $$$ISERR(tSC) Quit
			If 'pIsOIDC {
				Set tProps("AutheEnabled") = $$$AutheCache
			} Else {
				Set tProps("AutheEnabled") = $$$AutheUnauthenticated
			}
			#; The MHD-specific REST handler is necessary only for Retrieve,
			#; but since we are installing the same end point for all MHD
			#; interactions, define to use it here.
			Set tProps("DispatchClass") = "HS.FHIR.v"_pFHIRVersion_".MHD.REST.Handler"
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
			Set tFHIRCSPConfigObj.ServiceConfigName = "HS.FHIR.MHD.Responder.Service."_pFHIRVersion
			Set tFHIRCSPConfigObj.ServiceClassName = "HS.FHIR.Service"
			Set tFHIRCSPConfigObj.ConformanceId = tConformanceId
			If pIsOIDC {
				Set tFHIRCSPConfigObj.UseOAuth = 1
				Set tFHIRCSPConfigObj.ResourceServerOAuthClient = tInstanceName_".RSClient"
			}
			Set tSC = tFHIRCSPConfigObj.%Save()
			If $$$ISERR(tSC) Quit
		}
		
		If 'pIsOIDC {
			Set tServiceName = "MHD.Responder."_pFHIRVersion
			Set tID = ##class(HS.Registry.Service.HTTP).IDForNameType(tServiceName, "HTTP")
			If tID="" {
				Set tService = ##class(HS.Registry.Service.HTTP).%New()
				Set tService.Name = tServiceName
				Set tService.Type = "HTTP"
				Set tService.Host = pHost
				Set tService.Port = pPort
				Set tService.URL = pCSPAppName
				Set tService.HTTPCredentialsConfig = pCredentialName
				Set tService.DeviceFunction = "MHD.Query"
				Set tSC = tService.%Save()
				If $$$ISERR(tSC) Quit
			}
			
			Set tServiceName = "MHD.ResponderSSL."_pFHIRVersion
			Set tID = ##class(HS.Registry.Service.HTTP).IDForNameType(tServiceName, "HTTP")
			If tID="" {
				Set tService = ##class(HS.Registry.Service.HTTP).%New()
				Set tService.Name = tServiceName
				Set tService.Type = "HTTP"
				Set tService.Host = pSSLHost
				Set tService.Port = pSSLPort
				Set tService.URL = pCSPAppName
				Set tService.HTTPCredentialsConfig = pCredentialName
				Set tService.DeviceFunction = "MHD.Query"
				Set tService.SSLConfig = pSSLConfigName
				Set tSC = tService.%Save()
				If $$$ISERR(tSC) Quit
			}
		
		} Else {
			Set tServiceName = "MHD.ResponderOIDC."_pFHIRVersion
			Set tID = ##class(HS.Registry.Service.HTTP).IDForNameType(tServiceName, "HTTP")
			If tID="" {
				Set tService = ##class(HS.Registry.Service.HTTP).%New()
				Set tService.Name = tServiceName
				Set tService.Type = "HTTP"
				Set tService.Host = pSSLHost
				Set tService.Port = pSSLPort
				Set tService.URL = pCSPAppName
				Set tService.DeviceFunction = "MHD.Query"
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

/// Sets up the CSP app, FHIR CSP Configuration entry, and Service
/// Registry entries for the MHD Responder end point.  For each
/// item to be set up, if the item already exists then this method
/// does not update it.
ClassMethod SetupRecipientEndpoint(pNS As %String, pHost As %String, pPort As %String, pCSPAppName As %String, pSSLConfigName As %String, pCredentialName As %String, pFHIRVersion As %String, pIsOIDC As %Boolean, pSSLHost As %String, pSSLPort As %String) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		Set $Namespace = "%SYS"
		
		Set tConformanceId = "IHE.MHD.DocumentRecipient"
		
		Set tAppObj = ##class(Security.Applications).%OpenId(pCSPAppName)
		Set tAppExists = $IsObject(tAppObj)
		Kill tAppObj
		
		Set tInstanceName = ##class(%SYS.System).GetInstanceName()
		
		Set $Namespace = pNS
		
		If 'tAppExists {
			#; This is not a user portal, however this flag gets the settings we need:
			#; CSP/ZEN enabled and Inbound Web Services disabled
			Set tIsUserPortal = 1
			Set tDescription = "FHIR "_pFHIRVersion_" MHD Recipient end point"
			set tRoles="%DB_"_$tr(pNS,"%")_",%DB_HSLIB,%DB_HSSYS"
			Set tCookiePath = ""
			Set tSC = ##class(HS.Util.SystemAPI).Invoke("CreateCSPApp", pNS, tIsUserPortal, pCSPAppName, pNS, "csp/healthshare/"_pNS, tDescription, tRoles, tCookiePath)
			If $$$ISERR(tSC) Quit
			If 'pIsOIDC {
				Set tProps("AutheEnabled") = $$$AutheCache
			} Else {
				Set tProps("AutheEnabled") = $$$AutheUnauthenticated
			}
			#; The MHD-specific REST handler is necessary only for Retrieve,
			#; but since we are installing the same end point for all MHD
			#; interactions, define to use it here.
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
			Set tFHIRCSPConfigObj.ServiceConfigName = "HS.FHIR.MHD.Recipient.Service."_pFHIRVersion
			Set tFHIRCSPConfigObj.ServiceClassName = "HS.FHIR.Service"
			Set tFHIRCSPConfigObj.ConformanceId = tConformanceId
			If pIsOIDC {
				Set tFHIRCSPConfigObj.UseOAuth = 1
				Set tFHIRCSPConfigObj.ResourceServerOAuthClient = tInstanceName_".RSClient"
			}
			Set tSC = tFHIRCSPConfigObj.%Save()
			If $$$ISERR(tSC) Quit
		}
		
		If 'pIsOIDC {
			Set tServiceName = "MHD.Recipient."_pFHIRVersion
			Set tID = ##class(HS.Registry.Service.HTTP).IDForNameType(tServiceName, "HTTP")
			If tID="" {
				Set tService = ##class(HS.Registry.Service.HTTP).%New()
				Set tService.Name = tServiceName
				Set tService.Type = "HTTP"
				Set tService.Host = pHost
				Set tService.Port = pPort
				Set tService.URL = pCSPAppName
				Set tService.HTTPCredentialsConfig = pCredentialName
				Set tService.DeviceFunction = "MHD.Repository"
				Set tSC = tService.%Save()
				If $$$ISERR(tSC) Quit
			}
			
			Set tServiceName = "MHD.RecipientSSL."_pFHIRVersion
			Set tID = ##class(HS.Registry.Service.HTTP).IDForNameType(tServiceName, "HTTP")
			If tID="" {
				Set tService = ##class(HS.Registry.Service.HTTP).%New()
				Set tService.Name = tServiceName
				Set tService.Type = "HTTP"
				Set tService.Host = pSSLHost
				Set tService.Port = pSSLPort
				Set tService.URL = pCSPAppName
				Set tService.HTTPCredentialsConfig = pCredentialName
				Set tService.DeviceFunction = "MHD.Repository"
				Set tService.SSLConfig = pSSLConfigName
				Set tSC = tService.%Save()
				If $$$ISERR(tSC) Quit
			}
			
		} Else {
			Set tServiceName = "MHD.RecipientOIDC."_pFHIRVersion
			Set tID = ##class(HS.Registry.Service.HTTP).IDForNameType(tServiceName, "HTTP")
			If tID="" {
				Set tService = ##class(HS.Registry.Service.HTTP).%New()
				Set tService.Name = tServiceName
				Set tService.Type = "HTTP"
				Set tService.Host = pSSLHost
				Set tService.Port = pSSLPort
				Set tService.URL = pCSPAppName
				Set tService.DeviceFunction = "MHD.Repository"
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

XData RegistryEntries
{
<Items>
<WebService>
<Name>XDSb.Registry</Name>
<Push>1</Push>
<SSLConfig></SSLConfig>
<EndPoint>http://{HostAndPort}/csp/healthshare/hsregistry/services/HS.IHE.XDSb.Registry.Services.cls</EndPoint>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
<DeviceFunction>XDSb.Query</DeviceFunction>
</WebService>
<WebService>
<Name>XDSb.Repository</Name>
<Push>1</Push>
<SSLConfig></SSLConfig>
<EndPoint>http://{HostAndPort}/csp/healthshare/hsrepository/services/HS.IHE.XDSb.Repository.Services.cls</EndPoint>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
<OIDMapCode>
<OIDMapCodeItem OIDMapCodeKey="Repository">HSREPOSITORY</OIDMapCodeItem>
</OIDMapCode>
<MTOM>1</MTOM>
<DeviceFunction>XDSb.Retrieve</DeviceFunction>
</WebService>
</Items>
}

XData ProductionItemsDSTU2
{
<Items>
  <Item Name="HS.Test.Service" Category="" ClassName="HS.Test.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MHDConsumerOperationsDSTU2">HS.FHIR.MHD.Consumer.Operations.DSTU2</Setting>
    <Setting Target="Host" Name="MHDSourceOperationsDSTU2">HS.FHIR.MHD.DocumentSource.Operations.DSTU2</Setting>
  </Item>
  <Item Name="HS.FHIR.MHD.Responder.Service.DSTU2" Category="" ClassName="HS.FHIR.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">HS.FHIR.MHD.Responder.Process.DSTU2</Setting>
    <Setting Target="Host" Name="FHIRVersion">DSTU2</Setting>
  </Item>
  <Item Name="HS.FHIR.MHD.Recipient.Service.DSTU2" Category="" ClassName="HS.FHIR.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">HS.FHIR.MHD.Recipient.Process.DSTU2</Setting>
    <Setting Target="Host" Name="FHIRVersion">DSTU2</Setting>
  </Item>
  <Item Name="HS.FHIR.MHD.Responder.Process.DSTU2" Category="" ClassName="HS.FHIR.vDSTU2.MHD.Responder.Process" PoolSize="2" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="RetrieveTarget">HS.HC.IHE.XDSb.Consumer.Operations</Setting>
    <Setting Target="Host" Name="QueryTarget">HS.HC.IHE.XDSb.Consumer.Operations</Setting>
  </Item>
  <Item Name="HS.FHIR.MHD.Recipient.Process.DSTU2" Category="" ClassName="HS.FHIR.vDSTU2.MHD.Recipient.Process" PoolSize="2" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ProvideTarget">HS.IHE.XDSb.DocumentSource.Operations</Setting>
  </Item>
 <Item Name="HS.FHIR.MHD.Consumer.Operations.DSTU2" Category="" ClassName="HS.FHIR.vDSTU2.MHD.Consumer.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MHDRegistryServiceName">MHD.Responder.DSTU2</Setting>
    <Setting Target="Host" Name="MHDRepositoryServiceName">MHD.Responder.DSTU2</Setting>
    <Setting Target="Host" Name="FHIRVersion">DSTU2</Setting>
  </Item>
  <Item Name="HS.FHIR.MHD.DocumentSource.Operations.DSTU2" Category="" ClassName="HS.FHIR.vDSTU2.MHD.DocumentSource.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ServiceName">MHD.Recipient.DSTU2</Setting>
  </Item>
  <Item Name="HS.IHE.XDSb.DocumentSource.Operations" Category="" ClassName="HS.IHE.XDSb.DocumentSource.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.Util.Trace.Operations" Category="" ClassName="HS.Util.Trace.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.FHIR.REST.Operation" Category="" ClassName="HS.FHIR.REST.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Items>
}

XData ProductionItemsSTU3
{
<Items>
  <Item Name="HS.Test.Service" Category="" ClassName="HS.Test.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MHDConsumerOperationsSTU3">HS.FHIR.MHD.Consumer.Operations.STU3</Setting>
    <Setting Target="Host" Name="MHDSourceOperationsSTU3">HS.FHIR.MHD.DocumentSource.Operations.STU3</Setting>
  </Item>
  <Item Name="HS.FHIR.MHD.Responder.Service.STU3" Category="" ClassName="HS.FHIR.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">HS.FHIR.MHD.Responder.Process.STU3</Setting>
    <Setting Target="Host" Name="FHIRVersion">STU3</Setting>
  </Item>
  <Item Name="HS.FHIR.MHD.Recipient.Service.STU3" Category="" ClassName="HS.FHIR.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">HS.FHIR.MHD.Recipient.Process.STU3</Setting>
    <Setting Target="Host" Name="FHIRVersion">STU3</Setting>
  </Item>
  <Item Name="HS.FHIR.MHD.Responder.Process.STU3" Category="" ClassName="HS.FHIR.vSTU3.MHD.Responder.Process" PoolSize="2" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="RetrieveTarget">HS.HC.IHE.XDSb.Consumer.Operations</Setting>
    <Setting Target="Host" Name="QueryTarget">HS.HC.IHE.XDSb.Consumer.Operations</Setting>
  </Item>
  <Item Name="HS.FHIR.MHD.Recipient.Process.STU3" Category="" ClassName="HS.FHIR.vSTU3.MHD.Recipient.Process" PoolSize="2" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ProvideTarget">HS.IHE.XDSb.DocumentSource.Operations</Setting>
  </Item>
 <Item Name="HS.FHIR.MHD.Consumer.Operations.STU3" Category="" ClassName="HS.FHIR.vSTU3.MHD.Consumer.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MHDRegistryServiceName">MHD.Responder.STU3</Setting>
    <Setting Target="Host" Name="MHDRepositoryServiceName">MHD.Responder.STU3</Setting>
    <Setting Target="Host" Name="FHIRVersion">STU3</Setting>
  </Item>
  <Item Name="HS.FHIR.MHD.DocumentSource.Operations.STU3" Category="" ClassName="HS.FHIR.vSTU3.MHD.DocumentSource.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ServiceName">MHD.Recipient.STU3</Setting>
  </Item>
  <Item Name="HS.IHE.XDSb.DocumentSource.Operations" Category="" ClassName="HS.IHE.XDSb.DocumentSource.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.Util.Trace.Operations" Category="" ClassName="HS.Util.Trace.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.FHIR.REST.Operation" Category="" ClassName="HS.FHIR.REST.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Items>
}

XData XDSbConsumerOps
{
<Items>
  <Item Name="HS.HC.IHE.XDSb.Consumer.Operations" Category="" ClassName="HS.HC.IHE.XDSb.Consumer.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  </Items>
}

}
