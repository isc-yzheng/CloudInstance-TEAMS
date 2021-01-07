/// HS.HC.Util.Installer.FHIR provides Terminal-based user prompts for installing
/// FHIR components into a Foundation type namespace.
Class HS.HC.Util.Installer.FHIR Extends HS.HC.Util.Installer
{

ClassMethod Install()
{
	If '..CheckGetKey() {
		Write !!,"License key not present, cannot install FHIR"
		Quit
	}
	
	Set tAbort = 0
	
	Set tNamespaceExists = 0
	For {
		Write !,"Namespace  : "
		Read tNamespace
		Set tNamespace = $ZConvert(tNamespace, "U")
		If tNamespace="" Set tAbort = 1 Quit
		If ..NamespaceExists(tNamespace) {
			Set tConfigItem = ##class(HS.Util.Installer.ConfigItem).%OpenId(tNamespace)
			If '$IsObject($Get(tConfigItem)) {
				Write "  namespace not defined in ConfigItem table"
				Continue
			}
			If tConfigItem.Type'="Foundation" {
				Write "  existing namespace must be Foundation namespace"
				Kill tConfigItem
				Continue
			}
			Kill tConfigItem
			Set tNamespaceExists = 1
			Write " will use existing namespace "_tNamespace
		}
		Quit
	}
	If tAbort=1 Write "  (aborted)" Quit
	
	For tFHIRVersion = "DSTU2", "STU3" {
		
		Write !
		
		Do ..YesNo("Install "_tFHIRVersion_"? (Y/N) ", .tYN)
		If tYN="N" Continue
		
		Write !
		
		For {
			Set tDefault = "/csp/healthshare/"_$ZConvert(tNamespace,"L")_"/fhir/"_$ZConvert(tFHIRVersion,"L")
			Write !,tFHIRVersion_" CSP app ["_tDefault_"]: "
			Read tCSPApp
			If tCSPApp="" Set tCSPApp = tDefault Quit
			Set tCSPApp = $ZConvert(tCSPApp, "L")
			If (tCSPApp'="/")&&($Extract(tCSPApp)="/") Quit
			Write "  invalid entry"
		}
		
		For {
			Set tDefault = "/csp/healthshare/"_$ZConvert(tNamespace,"L")_"/fhir-oidc/"_$ZConvert(tFHIRVersion,"L")
			Write !,tFHIRVersion_" CSP Open ID Connect (OAuth 2.0) app ["_tDefault_"]: "
			Read tCSPOIDCApp
			If tCSPOIDCApp="" Set tCSPOIDCApp = tDefault Quit
			Set tCSPOIDCApp = $ZConvert(tCSPOIDCApp, "L")
			If (tCSPOIDCApp'="/")&&($Extract(tCSPOIDCApp)="/") Quit
			Write "  invalid entry"
		}
		
		Write !
		
		Do ..YesNo("Install "_tFHIRVersion_" resource repository? (Y/N) ", .tRepo)
		
		Write !
		
		Do ..YesNo("Install "_tFHIRVersion_" PIXm? (Y/N) ", .tPIXm)
		
		If tPIXm="Y" {
			For {
				Set tDefault = "/csp/healthshare/"_$ZConvert(tNamespace,"L")_"/pixm/"_$ZConvert(tFHIRVersion,"L")
				Write !,tFHIRVersion_" PIXm CSP app ["_tDefault_"]: "
				Read tPIXmCSPApp
				Set tPIXmCSPApp = $ZConvert(tPIXmCSPApp, "L")
				If tPIXmCSPApp="" Set tPIXmCSPApp = tDefault Quit
				If (tPIXmCSPApp'="/")&&($Extract(tPIXmCSPApp)="/") Quit
				Write "  invalid entry"
			}
			For {
				Set tDefault = "/csp/healthshare/"_$ZConvert(tNamespace,"L")_"/pixm-oidc/"_$ZConvert(tFHIRVersion,"L")
				Write !,tFHIRVersion_" PIXm Open ID Connect (OAuth 2.0) CSP app ["_tDefault_"]: "
				Read tPIXmCSPOIDCApp
				Set tPIXmCSPOIDCApp = $ZConvert(tPIXmCSPOIDCApp, "L")
				If tPIXmCSPOIDCApp="" Set tPIXmCSPOIDCApp = tDefault Quit
				If (tPIXmCSPOIDCApp'="/")&&($Extract(tPIXmCSPOIDCApp)="/") Quit
				Write "  invalid entry"
			}
		} Else {
			Set tPIXmCSPApp = ""
			Set tPIXmCSPOIDCApp = ""
		}
		
		Write !
		
		Do ..YesNo("Install "_tFHIRVersion_" PDQm? (Y/N) ", .tPDQm)
		
		If tPDQm="Y" {
			For {
				Set tDefault = "/csp/healthshare/"_$ZConvert(tNamespace,"L")_"/pdqm/"_$ZConvert(tFHIRVersion,"L")
				Write !,tFHIRVersion_" PDQm CSP app ["_tDefault_"]: "
				Read tPDQmCSPApp
				Set tPDQmCSPApp = $ZConvert(tPDQmCSPApp, "L")
				If tPDQmCSPApp="" Set tPDQmCSPApp = tDefault Quit
				If (tPDQmCSPApp'="/")&&($Extract(tPDQmCSPApp)="/") Quit
				Write "  invalid entry"
			}
			For {
				Set tDefault = "/csp/healthshare/"_$ZConvert(tNamespace,"L")_"/pdqm-oidc/"_$ZConvert(tFHIRVersion,"L")
				Write !,tFHIRVersion_" PDQm Open ID Connect (OAuth 2.0) CSP app ["_tDefault_"]: "
				Read tPDQmCSPOIDCApp
				Set tPDQmCSPOIDCApp = $ZConvert(tPDQmCSPOIDCApp, "L")
				If tPDQmCSPOIDCApp="" Set tPDQmCSPOIDCApp = tDefault Quit
				If (tPDQmCSPOIDCApp'="/")&&($Extract(tPDQmCSPOIDCApp)="/") Quit
				Write "  invalid entry"
			}
		} Else {
			Set tPDQmCSPApp = ""
			Set tPDQmCSPOIDCApp = ""
		}
		
		Write !
		
		Do ..YesNo("Install "_tFHIRVersion_" MHD? (Y/N) ", .tMHD)
		
		If tMHD="Y" {
			For {
				Set tDefault = "/csp/healthshare/"_$ZConvert(tNamespace,"L")_"/mhdrecipient/"_$ZConvert(tFHIRVersion,"L")
				Write !,tFHIRVersion_" MHD recipient CSP app ["_tDefault_"]: "
				Read tMHDRecipientApp
				Set tMHDRecipientApp = $ZConvert(tMHDRecipientApp, "L")
				If tMHDRecipientApp="" Set tMHDRecipientApp = tDefault Quit
				If (tMHDRecipientApp'="/")&&($Extract(tMHDRecipientApp)="/") Quit
				Write "  invalid entry"
			}
			For {
				Set tDefault = "/csp/healthshare/"_$ZConvert(tNamespace,"L")_"/mhdrecipient-oidc/"_$ZConvert(tFHIRVersion,"L")
				Write !,tFHIRVersion_" MHD recipient Open ID Connect (OAuth 2.0) CSP app ["_tDefault_"]: "
				Read tMHDRecipientOIDCApp
				Set tMHDRecipientOIDCApp = $ZConvert(tMHDRecipientOIDCApp, "L")
				If tMHDRecipientOIDCApp="" Set tMHDRecipientOIDCApp = tDefault Quit
				If (tMHDRecipientOIDCApp'="/")&&($Extract(tMHDRecipientOIDCApp)="/") Quit
				Write "  invalid entry"
			}
			For {
				Set tDefault = "/csp/healthshare/"_$ZConvert(tNamespace,"L")_"/mhdresponder/"_$ZConvert(tFHIRVersion,"L")
				Write !,tFHIRVersion_" MHD responder CSP app ["_tDefault_"]: "
				Read tMHDResponderApp
				Set tMHDResponderApp = $ZConvert(tMHDResponderApp, "L")
				If tMHDResponderApp="" Set tMHDResponderApp = tDefault Quit
				If (tMHDResponderApp'="/")&&($Extract(tMHDResponderApp)="/") Quit
				Write "  invalid entry"
			}
			For {
				Set tDefault = "/csp/healthshare/"_$ZConvert(tNamespace,"L")_"/mhdresponder-oidc/"_$ZConvert(tFHIRVersion,"L")
				Write !,tFHIRVersion_" MHD responder Open ID Connect (OAuth 2.0) CSP app ["_tDefault_"]: "
				Read tMHDResponderOIDCApp
				Set tMHDResponderOIDCApp = $ZConvert(tMHDResponderOIDCApp, "L")
				If tMHDResponderOIDCApp="" Set tMHDResponderOIDCApp = tDefault Quit
				If (tMHDResponderOIDCApp'="/")&&($Extract(tMHDResponderOIDCApp)="/") Quit
				Write "  invalid entry"
			}
		} Else {
			Set tMHDRecipientApp = ""
			Set tMHDRecipientOIDCApp = ""
			Set tMHDResponderApp = ""
			Set tMHDResponderOIDCApp = ""
		}
		
		Set tVars(tFHIRVersion, "CSPApp") = tCSPApp
		Set tVars(tFHIRVersion, "CSPOIDCApp") = tCSPOIDCApp
		Set tVars(tFHIRVersion, "Repo") = tRepo
		Set tVars(tFHIRVersion, "PIXm") = tPIXm
		Set tVars(tFHIRVersion, "PIXm", "CSPApp") = tPIXmCSPApp
		Set tVars(tFHIRVersion, "PIXm", "CSPOIDCApp") = tPIXmCSPOIDCApp
		Set tVars(tFHIRVersion, "PDQm") = tPDQm
		Set tVars(tFHIRVersion, "PDQm", "CSPApp") = tPDQmCSPApp
		Set tVars(tFHIRVersion, "PDQm", "CSPOIDCApp") = tPDQmCSPOIDCApp
		Set tVars(tFHIRVersion, "MHD") = tMHD
		Set tVars(tFHIRVersion, "MHD", "RecipientApp") = tMHDRecipientApp
		Set tVars(tFHIRVersion, "MHD", "RecipientOIDCApp") = tMHDRecipientOIDCApp
		Set tVars(tFHIRVersion, "MHD", "ResponderApp") = tMHDResponderApp
		Set tVars(tFHIRVersion, "MHD", "ResponderOIDCApp") = tMHDResponderOIDCApp
	}
	
	Write !
	Do ..YesNo("Continue with Installation? (Y/N) ", .tContinue)
	
	If tContinue="N" Write "  (aborted)" Quit
	
	If 'tNamespaceExists {
		Set tSC = ..InstallFoundation(tNamespace)
		If $$$ISERR(tSC) Quit
	}
	
	For tFHIRVersion = "DSTU2", "STU3" {
		
		If '$Data(tVars(tFHIRVersion, "CSPApp")) Continue
		
		Write !
		Set tSC = ##class(HS.HC.Util.Installer.Kit.FHIR.HealthConnect).Add( , tNamespace, tFHIRVersion, tVars(tFHIRVersion, "CSPApp"), tVars(tFHIRVersion, "CSPOIDCApp"))
		If $$$ISERR(tSC) Quit
		
		If $Get(tVars(tFHIRVersion, "Repo"))="Y" {
			Write !
			Set tSC = ##class(HS.HC.Util.Installer.Kit.FHIR.Repository).Add( , tNamespace, tFHIRVersion, tVars(tFHIRVersion, "CSPApp"))
			If $$$ISERR(tSC) Quit
		}
		
		If $Get(tVars(tFHIRVersion, "PIXm"))="Y" {
			Write !
			Set tSC = ##class(HS.HC.Util.Installer.Kit.FHIR.PIXm).Add( , tNamespace, tFHIRVersion, tVars(tFHIRVersion,"PIXm","CSPApp"), tVars(tFHIRVersion,"PIXm","CSPOIDCApp"))
			If $$$ISERR(tSC) Quit
		}
		
		If $Get(tVars(tFHIRVersion, "PDQm"))="Y" {
			Write !
			Set tSC = ##class(HS.HC.Util.Installer.Kit.FHIR.PDQm).Add( , tNamespace, tFHIRVersion, tVars(tFHIRVersion,"PDQm","CSPApp"), tVars(tFHIRVersion,"PDQm","CSPOIDCApp"))
			If $$$ISERR(tSC) Quit
		}
		
		If $Get(tVars(tFHIRVersion, "MHD"))="Y" {
			Write !
			Set tSC = ##class(HS.HC.Util.Installer.Kit.FHIR.MHD).Add( , tNamespace, tFHIRVersion, tVars(tFHIRVersion,"MHD","RecipientApp"), tVars(tFHIRVersion,"MHD","RecipientOIDCApp"), tVars(tFHIRVersion,"MHD","ResponderApp"), tVars(tFHIRVersion,"MHD","ResponderOIDCApp"))
			If $$$ISERR(tSC) Quit
		}
	}
	
	Quit
}

ClassMethod YesNo(pPrompt As %String, ByRef pYN As %String)
{
	For {
		Write !,pPrompt
		Read pYN
		Set pYN = $ZConvert(pYN, "U")
		If pYN="YES" Set pYN = "Y"
		If pYN="NO" Set pYN = "N"
		If (pYN="Y")||(pYN="N") Quit
		Write "  invalid entry"
	}
	Quit
}

}
