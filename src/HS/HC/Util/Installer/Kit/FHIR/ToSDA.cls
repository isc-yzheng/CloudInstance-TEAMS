Include %ZHSLIB

/// HS.HC.Util.Installer.Kit.FHIR.ToSDA adds production components and definitions needed for
/// using DTL to convert incoming FHIR DSTU2 requests into SDA3 In a Foundation type namespace.<br>
/// <br>
/// Example call to this class for setting up these components for FHIR DSTU2:<br>
/// <br>
/// Set status = ##class(HS.HC.Util.Installer.Kit.FHIR.ToSDA).Add( , "FHIR", "DSTU2", "/csp/fhirtosda", "/csp/fhirtosda-oidc")<br>
/// 
Class HS.HC.Util.Installer.Kit.FHIR.ToSDA Extends HS.Util.Installer.Kit.Base
{

Parameter NamespaceTypes As %String = "Foundation";

ClassMethod Add(pNamespaces As HS.Util.Installer.Kit.Namespaces = "", pFoundationNS As %String = {$Namespace}, pFHIRVersion As %String, pCSPApp As %String = "", pCSPOIDCApp As %String = "") As %Status
{
	Quit ..AddFoundation( , pFoundationNS, $Get(pFHIRVersion), pCSPApp, pCSPOIDCApp)
}

ClassMethod AddFoundation(pNamespaces As HS.Util.Installer.Kit.Namespaces = "", pNS = {$Namespace}, pFHIRVersion As %String, pCSPApp As %String = "", pCSPOIDCApp As %String = "") As %Status
{
	New $Namespace
	
	Set tSC = $$$OK
	
	Try {
		If pNS="" Set tSC = $$$ERROR($$$GeneralError, "Namespace not specified") Quit
		
		If $Get(pFHIRVersion)="" {
			Set tSC = $$$ERROR($$$GeneralError, "FHIR version not specified - must be DSTU2")
			Quit
		}
		
		Set pFHIRVersion = $ZConvert(pFHIRVersion,"U")
		
		If '((pFHIRVersion="DSTU2")) {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid FHIR version specified - must be DSTU2")
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
		
		If $Get(pCSPApp)="" {
			Set pCSPApp = "/csp/healthshare/"_$ZConvert(pNS, "L")_"/fhirtosda/"_$ZConvert(pFHIRVersion,"L")
		} ElseIf pCSPApp="/" {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid fhirtosda application specified - cannot be /")
		} Else {
			If $Extract(pCSPApp)'="/" Set pCSPApp = "/"_pCSPApp
			If $Extract(pCSPApp,*)="/" Set pCSPApp = $Extract(pCSPApp,1,*-1)
		}
		
		If $Get(pCSPOIDCApp)="" {
			Set pCSPOIDCApp = "/csp/healthshare/"_$ZConvert(pNS, "L")_"/fhirtosda-oidc/"_$ZConvert(pFHIRVersion,"L")
		} ElseIf pCSPOIDCApp="/" {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid fhirtosda application specified - cannot be /")
		} Else {
			If $Extract(pCSPOIDCApp)'="/" Set pCSPOIDCApp = "/"_pCSPOIDCApp
			If $Extract(pCSPOIDCApp,*)="/" Set pCSPOIDCApp = $Extract(pCSPOIDCApp,1,*-1)
		}
		
		Set tSC = ..ProductionMods(pNS, "FoundationItems", 1)
		If $$$ISERR(tSC) Quit
		
		Set tSC = ..SetupGeneralEndpoint(pNS, tHost, tPort, pCSPApp, tSSLConfigName, $$$HSServiceUserName, pFHIRVersion, tSSLHost, tSSLPort)
		If $$$ISERR(tSC) Quit
		
		Set tSC = ..SetupOAuthEndpoint(pNS, tHost, tPort, pCSPOIDCApp, tSSLConfigName, $$$HSServiceUserName, pFHIRVersion, tSSLHost, tSSLPort)
		If $$$ISERR(tSC) Quit
		
		Set tOverwrite = 0
		Set tSC = ##class(HS.HC.Util.Installer.Kit.FHIR.LookupTables).AddFoundation( , pNS, tOverwrite)
		If $$$ISERR(tSC) Quit
		
		Set $Namespace = pNS
		
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
		
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	
	If $$$WriteProg {
		If $$$ISERR(tSC) {
			Write !,..%ClassName(1)_" "_$$$CurrentMethod_" ERROR - "_$system.Status.GetErrorText(tSC)
		} Else {
			Write !,..%ClassName(1)_" "_$$$CurrentMethod_" completed successfully"
		}
	}
		
	Quit tSC
}

/// Sets up the CSP app, FHIR CSP Configuration entry, and Service
/// Registry entries for the FHIR REST API end point intended for
/// transforming the incoming FHIR into SDA3.  For each item to be
/// set up, if the item already exists then this method does not
/// update it.
ClassMethod SetupGeneralEndpoint(pNS As %String, pHost As %String, pPort As %String, pCSPAppName As %String, pSSLConfigName As %String, pCredentialName As %String, pFHIRVersion As %String, pSSLHost As %String, pSSLPort As %String) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
		Set $Namespace = "%SYS"
		
		Set tAppObj = ##class(Security.Applications).%OpenId(pCSPAppName)
		Set tAppExists = $IsObject(tAppObj)
		Kill tAppObj
		
		Set $Namespace = pNS
		
		If 'tAppExists {
			#; This is not a user portal, however this flag gets the settings we need:
			#; CSP/ZEN enabled and Inbound Web Services disabled
			Set tIsUserPortal = 1
			Set tDescription = "FHIR end point for transforming FHIR to SDA3"
			set tRoles="%DB_"_$tr(pNS,"%")_",%DB_HSLIB,%DB_HSSYS"
			Set tCookiePath = ""
			Set tSC = ##class(HS.Util.SystemAPI).Invoke("CreateCSPApp", pNS, tIsUserPortal, pCSPAppName, pNS, "csp/healthshare/"_pNS, tDescription, tRoles, tCookiePath)
			If $$$ISERR(tSC) Quit
			Set tProps("AutheEnabled") = $$$AutheCache
			Set tProps("DispatchClass") = "HS.FHIR.v"_pFHIRVersion_".REST.Handler"
			Set tSC=##class(HS.Util.SystemAPI).Invoke("UpdateCSPApp",pNS,pCSPAppName,$$$NVPairToList(tProps))
			If $$$ISERR(tSC) Quit
		}
		
		Set tFHIRCSPConfigObj = ##class(HS.Registry.FHIRCSPConfig).URLIndexOpen(pCSPAppName)
		If '$IsObject($Get(tFHIRCSPConfigObj)) {
			Set tFHIRCSPConfigObj = ##class(HS.Registry.FHIRCSPConfig).%New()
			Set tFHIRCSPConfigObj.URL = pCSPAppName
			Set tFHIRCSPConfigObj.ServiceConfigName = "HS.FHIR.ToSDAService."_pFHIRVersion
			Set tFHIRCSPConfigObj.ServiceClassName = "HS.FHIR.Service"
			Set tFHIRCSPConfigObj.ConformanceId = "InterSystemsFHIR"
			Set tFHIRCSPConfigObj.FHIRVersion = pFHIRVersion
			Set tSC = tFHIRCSPConfigObj.%Save()
			If $$$ISERR(tSC) Quit
		}
		
		Set tServiceName = "FHIRToSDA.Service."_pFHIRVersion
		Set tID = ##class(HS.Registry.Service.HTTP).IDForNameType(tServiceName, "HTTP")
		If tID="" {
			Set tService = ##class(HS.Registry.Service.HTTP).%New()
			Set tService.Name = tServiceName
			Set tService.Type = "HTTP"
			Set tService.Host = pHost
			Set tService.Port = pPort
			Set tService.URL = pCSPAppName
			Set tService.HTTPCredentialsConfig = pCredentialName
			Set tSC = tService.%Save()
			If $$$ISERR(tSC) Quit
		}
		
		Set tServiceName = "FHIRToSDASSL.Service."_pFHIRVersion
		Set tID = ##class(HS.Registry.Service.HTTP).IDForNameType(tServiceName, "HTTP")
		If tID="" {
			Set tService = ##class(HS.Registry.Service.HTTP).%New()
			Set tService.Name = tServiceName
			Set tService.Type = "HTTP"
			Set tService.Host = pSSLHost
			Set tService.Port = pSSLPort
			Set tService.URL = pCSPAppName
			Set tService.HTTPCredentialsConfig = pCredentialName
			Set tService.SSLConfig = pSSLConfigName
			Set tSC = tService.%Save()
			If $$$ISERR(tSC) Quit
		}
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

/// Sets up the CSP app, FHIR CSP Configuration entry, and Service
/// Registry entries for the FHIR REST API end point that uses an
/// OAuth 2.0 access token.  For each item to be set up, if the
/// item already exists then this method does not update it.
ClassMethod SetupOAuthEndpoint(pNS As %String, pHost As %String, pPort As %String, pCSPAppName As %String, pSSLConfigName As %String, pCredentialName As %String, pFHIRVersion As %String, pSSLHost As %String, pSSLPort As %String) As %Status [ Internal ]
{
	Set tSC = $$$OK
	
	Try {
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
			Set tDescription = "FHIR OAuth 2.0 end point for transforming FHIR to SDA3"
			set tRoles="%DB_"_$tr(pNS,"%")_",%DB_HSLIB,%DB_HSSYS"
			Set tCookiePath = ""
			Set tSC = ##class(HS.Util.SystemAPI).Invoke("CreateCSPApp", pNS, tIsUserPortal, pCSPAppName, pNS, "csp/healthshare/"_pNS, tDescription, tRoles, tCookiePath)
			If $$$ISERR(tSC) Quit
			Set tProps("AutheEnabled") = $$$AutheUnauthenticated
			Set tProps("DispatchClass") = "HS.FHIR.v"_pFHIRVersion_".REST.Handler"
			Set tSC=##class(HS.Util.SystemAPI).Invoke("UpdateCSPApp",pNS,pCSPAppName,$$$NVPairToList(tProps))
			If $$$ISERR(tSC) Quit
		}
		
		Set tFHIRCSPConfigObj = ##class(HS.Registry.FHIRCSPConfig).URLIndexOpen(pCSPAppName)
		If '$IsObject($Get(tFHIRCSPConfigObj)) {
			Set tFHIRCSPConfigObj = ##class(HS.Registry.FHIRCSPConfig).%New()
			Set tFHIRCSPConfigObj.URL = pCSPAppName
			Set tFHIRCSPConfigObj.ServiceConfigName = "HS.FHIR.ToSDAService."_pFHIRVersion
			Set tFHIRCSPConfigObj.ServiceClassName = "HS.FHIR.Service"
			Set tFHIRCSPConfigObj.ConformanceId = "InterSystemsFHIR"
			Set tFHIRCSPConfigObj.UseOAuth = 1
			Set tFHIRCSPConfigObj.FHIRVersion = pFHIRVersion
			Set tFHIRCSPConfigObj.ResourceServerOAuthClient = tInstanceName_".RSClient"
			Set tSC = tFHIRCSPConfigObj.%Save()
			If $$$ISERR(tSC) Quit
		}
		
		Set tServiceName = "FHIRToSDAOIDC.Service."_pFHIRVersion
		Set tID = ##class(HS.Registry.Service.HTTP).IDForNameType(tServiceName, "HTTP")
		If tID="" {
			Set tService = ##class(HS.Registry.Service.HTTP).%New()
			Set tService.Name = tServiceName
			Set tService.Type = "HTTP"
			Set tService.Host = pSSLHost
			Set tService.Port = pSSLPort
			Set tService.URL = pCSPAppName
			Set tService.SSLConfig = pSSLConfigName
			Set tSC = tService.%Save()
			If $$$ISERR(tSC) Quit
		}
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

XData FoundationItems
{
<Items>
  <Item Name="HS.Test.Service" Category="" ClassName="HS.Test.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.FHIR.ToSDAService.DSTU2" Category="" ClassName="HS.FHIR.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">HS.FHIR.ToSDA.DTL.Process.DSTU2</Setting>
  </Item>
  <Item Name="HS.Util.Trace.Operations" Category="" ClassName="HS.Util.Trace.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.FHIR.ToSDA.DTL.Process.DSTU2" Category="" ClassName="HS.FHIR.ToSDA.DTL.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Items>
}

}
