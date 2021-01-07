Include %ZHSLIB

/// HS.HC.Util.Installer.Kit.FHIR.HealthConnect adds production components and definitions needed
/// for a basic FHIR production, without resource repository components.
/// 
/// Example:
/// 
/// Set tSC = ##class(HS.HC.Util.Installer.Kit.FHIR.HealthConnect).Add( , "FHIR", "STU3", "/csp/fhir", "/csp/fhir-oidc")
/// 
Class HS.HC.Util.Installer.Kit.FHIR.HealthConnect Extends HS.Util.Installer.Kit.Base
{

Parameter NamespaceTypes As %String = "Foundation";

/// This method calls AddFoundation() to add the FHIR components and definitions.<br>
/// <br>Inputs:<br>
/// <li>pNamespaces   : (not used, leave blank)
/// <li>pFoundationNS : (required) The name of a Foundation type namespace.
/// <li>pFHIRVersion  : (required) FHIR version (e.g., "DSTU2", "STU3").
ClassMethod Add(pNamespaces As HS.Util.Installer.Kit.Namespaces = "", pFoundationNS As %String = "", pFHIRVersion As %String, pCSPApp As %String = "", pCSPOIDCApp As %String = "") As %Status
{
	Quit ..AddFoundation( , pFoundationNS, $Get(pFHIRVersion), pCSPApp, pCSPOIDCApp)
}

/// This method adds the FHIR components and definitions.<br>
/// <br>Inputs:<br>
/// <li>pNamespaces   : (not used, leave blank)
/// <li>pFoundationNS : (required) The name of a Foundation type namespace.
/// <li>pFHIRVersion  : (required) FHIR version (e.g., "DSTU2", "STU3").
ClassMethod AddFoundation(pNamespaces As HS.Util.Installer.Kit.Namespaces = "", pNS = "", pFHIRVersion As %String, pCSPApp As %String = "", pCSPOIDCApp As %String = "") As %Status
{
	New $Namespace
	
	Set tSC = $$$OK
	
	Try {
		If pNS="" Set tSC = $$$ERROR($$$GeneralError, "Namespace not specified") Quit
		
		If $Get(pFHIRVersion)="" {
			Set tSC = $$$ERROR($$$GeneralError, "FHIR version not specified - must be DSTU2 or STU3")
			Quit
		}
		
		Set pFHIRVersion = $ZConvert(pFHIRVersion,"U")
		
		If '((pFHIRVersion="DSTU2")||(pFHIRVersion="STU3")) {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid FHIR version specified - must be DSTU2 or STU3")
			Quit
		}
		
		Set pNS = $ZConvert(pNS, "U")
		
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
			Set tSC = ##class(HS.HC.Util.Installer).SetCredential($Namespace,$$$HSServiceUserName,$$$HSServiceUserName,"HS_Services",0)
			If $$$ISERR(tSC) Quit
		}
		
		Set tSC = ..ProductionMods(pNS, "FoundationItems"_pFHIRVersion, 1)
		If $$$ISERR(tSC) Quit
		
		If $Get(pCSPApp)="" {
			Set pCSPApp = "/csp/healthshare/"_$ZConvert(pNS, "L")_"/fhir/"_$ZConvert(pFHIRVersion,"L")
		} ElseIf pCSPApp="/" {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid CSP application specified - cannot be /")
		} Else {
			If $Extract(pCSPApp)'="/" Set pCSPApp = "/"_pCSPApp
			If $Extract(pCSPApp,*)="/" Set pCSPApp = $Extract(pCSPApp,1,*-1)
		}
		
		If $Get(pCSPOIDCApp)="" {
			Set pCSPOIDCApp = "/csp/healthshare/"_$ZConvert(pNS, "L")_"/fhir-oidc/"_$ZConvert(pFHIRVersion,"L")
		} ElseIf pCSPOIDCApp="/" {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid fhir application specified - cannot be /")
		} Else {
			If $Extract(pCSPOIDCApp)'="/" Set pCSPOIDCApp = "/"_pCSPOIDCApp
			If $Extract(pCSPOIDCApp,*)="/" Set pCSPOIDCApp = $Extract(pCSPOIDCApp,1,*-1)
		}
		
		Set tSC = ..SetupGeneralEndpoint(pNS, tHost, tPort, pCSPApp, tSSLConfigName, $$$HSServiceUserName, pFHIRVersion, 0, tSSLHost, tSSLPort)
		If $$$ISERR(tSC) Quit
		
		Set tSC = ..SetupGeneralEndpoint(pNS, tHost, tPort, pCSPOIDCApp, tSSLConfigName, $$$HSServiceUserName, pFHIRVersion, 1, tSSLHost, tSSLPort)
		If $$$ISERR(tSC) Quit
		
		Set $Namespace = pNS
		
		Set tFacilityCode = "EMERGENCY"
		Set tFacilityOID = "1.3.6.1.4.1.21367.2010.1.2.300.2.2"
		If '##class(HS.Facility.Config).%ExistsId(tFacilityCode) {
			Set tFacility=##class(HS.Facility.Config).%New()
			Set tFacility.FacilityCode = tFacilityCode
			Set tFacility.Name = tFacilityCode
			Set tFacility.Description = tFacilityCode
			Set tFacility.OID = tFacilityOID
			Set tFacility.AssigningAuthority = 1
			Set tSC = tFacility.%Save()
			If $$$ISERR(tSC) Quit
			Set tSC = ##class(HS.Data.OIDMap).FileOID(tFacilityCode, "Facility", tFacilityOID, tFacilityCode,"Facility,AssigningAuthority")
			If $$$ISERR(tSC) Quit
		}
		
		Set tSC = ..ImportFHIRGlobals(pNS) Quit:$$$ISERR(tSC)
		Set tSC = ..ImportLookupJSON(pNS) Quit:$$$ISERR(tSC)
		
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
			Write !,..%ClassName(1)_" "_$$$CurrentMethod_" ERROR - "_$system.Status.GetErrorText(tSC),!
		} Else {
			Write !,..%ClassName(1)_" "_$$$CurrentMethod_" completed successfully",!
		}
	}
	
	Quit tSC
}

/// Sets up the CSP app, FHIR CSP Configuration entry, and Service
/// Registry entries for the general FHIR REST API end point.  For
/// each item to be set up, if the item already exists then this
/// method does not update it.
ClassMethod SetupGeneralEndpoint(pNS As %String, pHost As %String, pPort As %String, pCSPAppName As %String, pSSLConfigName As %String, pCredentialName As %String, pFHIRVersion As %String, pIsOIDC As %Boolean, pSSLHost As %String, pSSLPort As %String) As %Status
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
			Set tDescription = "InterSystems FHIR end point"
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
			Set tFHIRCSPConfigObj.ServiceConfigName = "HS.FHIR.Service."_pFHIRVersion
			Set tFHIRCSPConfigObj.ServiceClassName = "HS.FHIR.Service"
			Set tFHIRCSPConfigObj.ConformanceId = "InterSystemsFHIR"
			If pIsOIDC {
				Set tFHIRCSPConfigObj.UseOAuth = 1
				Set tFHIRCSPConfigObj.ResourceServerOAuthClient = tInstanceName_".RSClient"
			}
			Set tSC = tFHIRCSPConfigObj.%Save()
			If $$$ISERR(tSC) Quit
		}
		
		Set tServiceName = "FHIR.Service"_$Select(pIsOIDC:"OIDC",1:"")_"."_pFHIRVersion
		Set tID = ##class(HS.Registry.Service.HTTP).IDForNameType(tServiceName, "HTTP")
		If tID="" {
			Set tService = ##class(HS.Registry.Service.HTTP).%New()
			Set tService.Name = tServiceName
			Set tService.Type = "HTTP"
			Set tService.Host = $Select(pIsOIDC:pSSLHost,1:pHost)
			Set tService.Port = $Select(pIsOIDC:pSSLPort,1:pPort)
			Set tService.URL = pCSPAppName
			Set tService.HTTPCredentialsConfig = pCredentialName
			Set tService.SSLConfig = $Select(pIsOIDC:pSSLConfigName,1:"")
			Set tSC = tService.%Save()
			If $$$ISERR(tSC) Quit
		}
		
		Set tServiceName = "FHIR.ServiceSSL."_pFHIRVersion
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

ClassMethod ImportFHIRGlobals(pNamespace As %String = "") As %Status
{
	Set tSC = $$$OK
	
	New $Namespace
	
	Try {
		If pNamespace="" Set pNamespace = $Namespace
		
		Set $Namespace = pNamespace
		
		Set tDirName = $system.Util.InstallDirectory() _ "dev/fhir/gbl/"
		If '##class(%Library.File).DirectoryExists(tDirName) {
			Set tSC = $$$ERROR($$$GeneralError, tDirName _ " not found")
			Quit
		}
		
		Set tProject = ""
		For {
			Set tProject = $Order(^HS.XF.Config("Delivery", tProject))
			If tProject="" Quit
			If $Data(^HS.XF.Config("Delivery", tProject, "CustomPackage", "DTL")) {
				Set tCustomPackage(tProject) = ^HS.XF.Config("Delivery", tProject, "CustomPackage", "DTL")
			}
		}
		
		Set tSC = $system.OBJ.ImportDir(tDirName)
		
		Set tProject = ""
		For {
			Set tProject = $Order(tCustomPackage(tProject))
			If tProject="" Quit
			Set ^HS.XF.Config("Delivery", tProject, "CustomPackage", "DTL") = tCustomPackage(tProject)
		}
		
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	
	Quit tSC
}

ClassMethod ImportLookupJSON(pNamespace As %String = "") As %Status
{
	Set tSC = $$$OK
	
	New $Namespace
	
	Try {
		If pNamespace="" Set pNamespace = $Namespace
		
		Set $Namespace = pNamespace
		
		// Do not overlay or overwrite an existing ^HS.XF.LookupTable.
		// Once established by an install, it can be updated only via
		// the customization procedure.
		If $Data(^HS.XF.LookupTable) Quit
		
		Set tDirName = $system.Util.InstallDirectory() _ "dev/fhir/lookup/"
		If '##class(%Library.File).DirectoryExists(tDirName) {
			Set tSC = $$$ERROR($$$GeneralError, tDirName _ " not found")
			Quit
		}
		Set tFileName = ##class(%Library.File).NormalizeFilename("Lookup.json", tDirName)
		If '##class(%Library.File).Exists(tFileName) {
			Set tSC = $$$ERROR($$$GeneralError, tFileName _ " not found")
			Quit
		}
		
		Set tSC = ##class(HS.FHIR.DTL.Util.API.LookupTable).ImportLookupJSONToGlobal()
		
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	
	Quit tSC
}

XData FoundationItemsDSTU2
{
<Items>
  <Item Name="HS.Test.Service" Category="" ClassName="HS.Test.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.FHIR.Service.DSTU2" Category="" ClassName="HS.FHIR.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">HS.FHIR.Server.Process.DSTU2</Setting>
  </Item>
  <Item Name="HS.FHIR.REST.Operation" Category="" ClassName="HS.FHIR.REST.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MetadataClass">HS.FHIR.InteractionMetadata</Setting>
  </Item>
  <Item Name="HS.Util.Trace.Operations" Category="" ClassName="HS.Util.Trace.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.FHIR.Server.Process.DSTU2" Category="" ClassName="HS.FHIR.Server.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">HS.FHIR.REST.Operation</Setting>
    <Setting Target="Host" Name="ResourceSchemaRoot">HS.FHIR.vDSTU2.Model.Resource</Setting>
  </Item>
</Items>
}

XData FoundationItemsSTU3
{
<Items>
  <Item Name="HS.Test.Service" Category="" ClassName="HS.Test.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.FHIR.Service.STU3" Category="" ClassName="HS.FHIR.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">HS.FHIR.Server.Process.STU3</Setting>
  </Item>
  <Item Name="HS.FHIR.REST.Operation" Category="" ClassName="HS.FHIR.REST.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MetadataClass">HS.FHIR.InteractionMetadata</Setting>
  </Item>
  <Item Name="HS.Util.Trace.Operations" Category="" ClassName="HS.Util.Trace.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.FHIR.Server.Process.STU3" Category="" ClassName="HS.FHIR.Server.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">HS.FHIR.REST.Operation</Setting>
    <Setting Target="Host" Name="ResourceSchemaRoot">HS.FHIR.vSTU3.Model.Resource</Setting>
  </Item>
</Items>
}

}
