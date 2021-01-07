Include %ZHSLIB

/// HS.HC.Util.Installer.Kit.FHIR.CapabilityStatement saves a specified FHIR Conformance or
/// CapabilityStatement resource to the resource repository.
/// 
/// Example:
/// 
/// Set tSC = ##class(HS.HC.Util.Installer.Kit.FHIR.CapabilityStatement).Add( , "FHIR", "STU3")
/// 
Class HS.HC.Util.Installer.Kit.FHIR.CapabilityStatement Extends HS.Util.Installer.Kit.Base
{

Parameter NamespaceTypes As %String = "Foundation";

/// This method calls AddFoundation() to save a Conformance or CapabilityStatement to the resource repository.<br>
/// <br>Inputs:<br>
/// <li>pNamespaces      : (not used, leave blank)
/// <li>pFoundationNS    : (required) The name of a Foundation type namespace.
/// <li>pFHIRVersion     : (required) FHIR version (e.g., "DSTU2", "STU3").
/// <li>pClassName       : Name of class that contains an XData block with the desired Conformance or
///                        CapabilityStatment content. If not specified, then the current class name
///                        is used.
/// <li>pXDataName       : Name of the XData block with the desired Conformance or CapabilityStatement
///                        content. If not specified, then the name "InterSystemsConformanceDSTU2" is
///                        used of pFHIRVersion is DSTU2, or "InterSystemsFHIRCapabilitySTU3" is used
///                        if pFHIRVersion is STU3.
/// <li>pResourceId      : Resource id to apply to the Conformance or CapabilityStatement resource when
///                        it is saved. If not specified, then the resource id from the resource content
///                        from the specified XData block will be used.
/// <li>pBaseURL         : Base URL to use as part of the url and implementation url values in the
///                        Conformance or CapabilityStatement resource when it is saved. If not
///                        specified, then the url and implementation url values from the resource
///                        content from the specified XData block will be used.
/// <li>pGenSearchTables : 1 = (re-)Generate the resource repository search tables using the saved
///                        Conformance or CapabilityStatement resource. 0 = Do not generate the
///                        search tables.
ClassMethod Add(pNamespaces As HS.Util.Installer.Kit.Namespaces = "", pFoundationNS As %String = "", pFHIRVersion As %String, pClassName As %String = "", pXDataName As %String = "", pResourceId As %String = "", pBaseURL As %String = "", pGenSearchTables As %Boolean = 0) As %Status
{
	Quit ..AddFoundation( , pFoundationNS, $Get(pFHIRVersion), pClassName, pXDataName, pResourceId, pBaseURL, pGenSearchTables)
}

/// This method saves a Conformance or CapabilityStatement to the resource repository.<br>
/// <br>Inputs:<br>
/// <li>pNamespaces      : (not used, leave blank)
/// <li>pFoundationNS    : (required) The name of a Foundation type namespace.
/// <li>pFHIRVersion     : (required) FHIR version (e.g., "DSTU2", "STU3").
/// <li>pClassName       : Name of class that contains an XData block with the desired Conformance or
///                        CapabilityStatment content. If not specified, then the current class name
///                        is used.
/// <li>pXDataName       : Name of the XData block with the desired Conformance or CapabilityStatement
///                        content. If not specified, then the name "InterSystemsConformanceDSTU2" is
///                        used of pFHIRVersion is DSTU2, or "InterSystemsFHIRCapabilitySTU3" is used
///                        if pFHIRVersion is STU3.
/// <li>pResourceId      : Resource id to apply to the Conformance or CapabilityStatement resource when
///                        it is saved. If not specified, then the resource id from the resource content
///                        from the specified XData block will be used.
/// <li>pBaseURL         : Base URL to use as part of the url and implementation url values in the
///                        Conformance or CapabilityStatement resource when it is saved. If not
///                        specified, then the url and implementation url values from the resource
///                        content from the specified XData block will be used.
/// <li>pGenSearchTables : 1 = (re-)Generate the resource repository search tables using the saved
///                        Conformance or CapabilityStatement resource. 0 = Do not generate the
///                        search tables.
ClassMethod AddFoundation(pNamespaces As HS.Util.Installer.Kit.Namespaces = "", pNS = "", pFHIRVersion As %String, pClassName As %String = "", pXDataName As %String = "", pResourceId As %String = "", pBaseURL As %String = "", pGenSearchTables As %Boolean = 0) As %Status
{
	New $Namespace
	
	Set tSC = $$$OK
	
	Try {
		If pNS="" {
			Set tSC = $$$ERROR($$$GeneralError, "Namespace not specified")
			Quit
		}
		
		Set pNS = $ZConvert(pNS, "U")
		
		If $Get(pFHIRVersion)="" {
			Set tSC = $$$ERROR($$$GeneralError, "FHIR version not specified - must be DSTU2 or STU3")
			Quit
		}
		
		Set pFHIRVersion = $ZConvert(pFHIRVersion,"U")
		
		If '((pFHIRVersion="DSTU2")||(pFHIRVersion="STU3")) {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid FHIR version specified - must be DSTU2 or STU3")
			Quit
		}
		
		If $Get(pClassName)="" Set pClassName = ..%ClassName(1)
		
		If $Get(pXDataName)="" {
			If pFHIRVersion="DSTU2" {
				Set pXDataName = "InterSystemsConformanceDSTU2"
			} Else {
				Set pXDataName = "InterSystemsFHIRCapabilitySTU3"
			}
		}
		
		Set $Namespace = pNS
		
		Set tSC = ##class(%RoutineMgr).GetWebServerPort(.tPort)
		If $$$ISERR(tSC) Set tSC = $$$ERROR($$$GeneralError, "Could not get web server port") Quit
		Set tHost = $ZConvert($$$HSNetworkHostName, "L")
		
		If pFHIRVersion="DSTU2" {
			Set tStorageClass = "HS.FHIR.vDSTU2.Repository.Storage"
			Set tResourceSchema = "HS.FHIR.vDSTU2.Model.Resource"
			Set tSearchTableBuilder = "HS.FHIR.vDSTU2.SearchTableBuilder"
		} Else {
			Set tStorageClass = "HS.FHIR.vSTU3.Repository.Storage"
			Set tResourceSchema = "HS.FHIR.vSTU3.Model.Resource"
			Set tSearchTableBuilder = "HS.FHIR.vSTU3.SearchTableBuilder"
		}
		
		Set tSC = ##class(HS.FHIR.Utils).GetCapabilityStatementFromXData("xml", pXDataName, pClassName, tResourceSchema, pResourceId, pBaseURL, , , , .tResourceStream)
		If $$$ISERR(tSC) Quit
		
		Set tSC = $ClassMethod(tStorageClass, "Update", "xml", tResourceSchema, , , 1, , , , tResourceStream, , .tStorageId, .tErrors)
		If $$$ISERR(tSC) Quit
		
		If pGenSearchTables {
			Set tSC = $ClassMethod(tStorageClass, "GetStorageObjectByStorageId", tStorageId, .tStorageObj)
			If $$$ISERR(tSC) Quit
			
			Set tSC = $ClassMethod(tSearchTableBuilder, "GenSearchTablesFromStorageObj", tStorageObj)
			If $$$ISERR(tSC) Quit
			
			Set tSC = $ClassMethod(tStorageClass, "Update", "xml", tResourceSchema, , , 1, , , , tResourceStream, , .tStorageId, .tErrors)
			If $$$ISERR(tSC) Quit
		}
		
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

/// This method calls AddFoundation() to save a Conformance or CapabilityStatement to the resource repository,
/// with some parameters defaulted in, for simpler out of the box manual setup.<br>
/// <br>Inputs:<br>
/// <li>pNamespaces      : (not used, leave blank)
/// <li>pFoundationNS    : (required) The name of a Foundation type namespace.
/// <li>pFHIRVersion     : (required) FHIR version. Must be "DSTU2" or "STU3".
/// <li>pBaseURL         : Base URL to use as part of the url and implementation url values in the
///                        Conformance or CapabilityStatement resource when it is saved. If not
///                        specified, then the value is defaulted to
///                        /csp/healthshare/namespace/fhir/fhirversion, where namespace is the
///                        namespace name, and fhirversion is "dstu2" or "stu3".
ClassMethod InitializeDefault(pNamespaces As HS.Util.Installer.Kit.Namespaces = "", pNS As %String, pFHIRVersion As %String, pBaseURL As %String = "") As %Status
{
	Set tSC = $$$OK
	
	New $Namespace
	
	Try {
		If $Get(pNS)="" {
			Set tSC = $$$ERROR($$$GeneralError, "Namespace not specified")
			Quit
		}
		
		Set pNS = $ZConvert(pNS, "U")
		
		If $Get(pFHIRVersion)="" {
			Set tSC = $$$ERROR($$$GeneralError, "FHIR version not specified - must be DSTU2 or STU3")
			Quit
		}
		
		Set pFHIRVersion = $ZConvert(pFHIRVersion,"U")
		
		If '((pFHIRVersion="DSTU2")||(pFHIRVersion="STU3")) {
			Set tSC = $$$ERROR($$$GeneralError, "Invalid FHIR version specified - must be DSTU2 or STU3")
			Quit
		}
		
		If $Get(pBaseURL)="" Set pBaseURL = "/csp/healthshare/"_$ZConvert(pNS,"L")_"/fhir/"_$ZConvert(pFHIRVersion,"L")
		
		Set tClassName = "HS.HC.Util.Installer.Kit.FHIR.Repository"
		
		If pFHIRVersion="DSTU2" {
			Set tXDataName = "InterSystemsConformanceDSTU2"
		} Else {
			Set tXDataName = "InterSystemsFHIRCapabilitySTU3"
		}
		
		Set $Namespace = pNS
		
		Set tSC = ..AddFoundation( , pNS, pFHIRVersion, tClassName, tXDataName, "InterSystemsFHIR", pBaseURL, 1)
		
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

ClassMethod AddOAuthEndpoints(pNamespaces As HS.Util.Installer.Kit.Namespaces = "", pNS As %String, pFHIRVersion As %String, pResourceId As %String, pIssuerEndpoint As %String) As %Status
{
	Set tSC = $$$OK
	
	New $Namespace
	
	Try {
		Set tHadProps = $Data(%propsByName)
		Set tHadPParams = $Data(%HSFHIRPeriodParams)
		Set tHadSParams = $Data(%HSFHIRSearchParams)
		Set tHadMax = $Data(%maxlocallength)
		
		Set pNS = $ZConvert(pNS, "U")
		Set pFHIRVersion = $ZConvert(pFHIRVersion,"U")
		
		Set tErrorText = ""
		
		If $Get(pNS)="" {
			Set tErrorText = "Namespace not specified"
		} ElseIf $Get(pFHIRVersion)="" {
			Set tErrorText = "FHIR version not specified - must be DSTU2 or STU3"
		} ElseIf '((pFHIRVersion="DSTU2")||(pFHIRVersion="STU3")) {
			Set tErrorText = "Invalid FHIR version specified - must be DSTU2 or STU3"
		}
		If tErrorText'="" Set tSC = $$$ERROR($$$GeneralError, tErrorText) Quit
		
		// Make sure that the namespace pNS is valid.
		Set $Namespace = pNS
		
		Set $Namespace = "%SYS"
		
		Set tIssuerEPHashed = $system.Encryption.SHAHash(512,pIssuerEndpoint)
		Set tServerDefinition = ##class(OAuth2.ServerDefinition).IssuerIndexOpen(tIssuerEPHashed)
		If '$IsObject(tServerDefinition) {
			Set tSC = $$$ERROR($$$GeneralError, "No OAuth 2.0 Client Server definition for issuer endpoint "_pIssuerEndpoint)
			Quit
		}
		Set tAuthEP = tServerDefinition.AuthorizationEndpoint
		Set tTokenEP = tServerDefinition.TokenEndpoint
		Kill tServerDefinition
		
		Set $Namespace = pNS
		
		If tAuthEP="" {
			Set tErrorText = "Authorization endpoint not found for issuer endpoint "_pIssuerEndpoint
		} ElseIf tTokenEP="" {
			Set tErrorText = "Token endpoint not found for issuer endpoint "_pIssuerEndpoint
		}
		If tErrorText'="" Set tSC = $$$ERROR($$$GeneralError, tErrorText) Quit
		
		// read the conformance or capabilities statement from repo
		// turn it into an HS FHIR object
		// update the auth info
		// turn it back into a stream
		// update the conformance or capabilities statement into repo
		
		If pFHIRVersion="DSTU2" {
			Set tResourceType = "Conformance"
			Set tClassRoot = "HS.FHIR.vDSTU2."
		} Else {
			Set tResourceType = "CapabilityStatement"
			Set tClassRoot = "HS.FHIR.vSTU3."
		}
		
		Set tContentType = "xml"
		
		Set tSC = $ClassMethod(tClassRoot_"Repository.Storage", "Read", tContentType, tClassRoot_"Model.Resource", tResourceType, pResourceId, , , , .tResourceStream, ,.tErrors)
		If $$$ISERR(tSC) Quit
		
		Set tSC = ##class(HS.FHIR.Utils).FHIRToHSFHIR(tContentType, tResourceStream, .tHSFHIRObj, tClassRoot_"Model.Resource")
		If $$$ISERR(tSC) Quit
		
		Set tUpdate = 0
		Set tRemove = 0
		Set tOAuthFound = ""
		Set tOAuthAuth = ""
		Set tOAuthToken = ""
		For i = 1:1:tHSFHIRObj.rest.Count() {
			If tHSFHIRObj.rest.GetAt(i).mode.value'="server" Continue
			Set tRest = tHSFHIRObj.rest.GetAt(i)
			If $IsObject(tRest.security) {
				For j = 1:1:tRest.security.extension.Count() {
					If tRest.security.extension.GetAt(j).url="http://fhir-registry.smarthealthit.org/StructureDefinition/oauth-uris" {
						Set tOAuthFound = 1
						For k = 1:1:tRest.security.extension.GetAt(j).extension.Count() {
							If tRest.security.extension.GetAt(j).extension.GetAt(k).url="authorize" {
								Set tOAuthAuth = tRest.security.extension.GetAt(j).extension.GetAt(k).valueUri.value
							} ElseIf tRest.security.extension.GetAt(j).extension.GetAt(k).url="token" {
								Set tOAuthToken = tRest.security.extension.GetAt(j).extension.GetAt(k).valueUri.value
							}
						}
					}
				}
			}
		}

		If tAuthEP'="" {
			If tAuthEP="-" {
				Set tRemove = 1
			} Else {
				Set tUpdate = 1
			}
		}
		If tTokenEP'="" {
			If tTokenEP="-" {
				Set tRemove = 1
			} Else {
				Set tUpdate = 1
			}
		}
		
		If (tUpdate=1)||(tRemove=1) {
			Set tFound = 0
			For i = 1:1:tHSFHIRObj.rest.Count() {
				If tHSFHIRObj.rest.GetAt(i).mode.value'="server" Continue
				Set tRest = tHSFHIRObj.rest.GetAt(i)
				If $IsObject(tRest.security) {
					If tRemove=1 Set tRest.security.service = ""
					For j = 1:1:tRest.security.extension.Count() {
						If tRest.security.extension.GetAt(j).url="http://fhir-registry.smarthealthit.org/StructureDefinition/oauth-uris" {
							If tRemove=1 Do tRest.security.extension.RemoveAt(j) Quit
							Set tFound = 1
							For k = 1:1:tRest.security.extension.GetAt(j).extension.Count() {
								If tRest.security.extension.GetAt(j).extension.GetAt(k).url="authorize" {
									Set tSC = tRest.security.extension.GetAt(j).extension.GetAt(k).SetValueUri(tAuthEP)
								} ElseIf tRest.security.extension.GetAt(j).extension.GetAt(k).url="token" {
									Set tSC = tRest.security.extension.GetAt(j).extension.GetAt(k).SetValueUri(tTokenEP)
								}
							}
						}
					}
					If (tUpdate=1)&&(tFound=0) {
						Set tExt1 = $ClassMethod(tClassRoot_"Model.Base.Extension", "%New")
						Set tExt1.url = "http://fhir-registry.smarthealthit.org/StructureDefinition/oauth-uris"
						Set tExt2 = $ClassMethod(tClassRoot_"Model.Base.Extension", "%New")
						Set tExt2.url = "authorize"
						Do tExt2.SetValueUri(tAuthEP)
						Set tExt3 = $ClassMethod(tClassRoot_"Model.Base.Extension", "%New")
						Set tExt3.url = "token"
						Do tExt3.SetValueUri(tTokenEP)
						Set tSC = tExt1.extension.Insert(tExt2)
						Set tSC = tExt1.extension.Insert(tExt3)
						Set tSC = tRest.security.extension.Insert(tExt1)
						Set tSC = tRest.security.SetService("SMART-on-FHIR","SMART-on-FHIR","http://hl7.org/fhir/restful-security-service")
					}
				} Else {
					Set tSecurity = $ClassMethod(tClassRoot_"Model.Resource."_tResourceType_".Security", "%New")
					Do tSecurity.SetCors(1)
					Set tExt1 = $ClassMethod(tClassRoot_"Model.Base.Extension", "%New")
					Set tExt1.url = "http://fhir-registry.smarthealthit.org/StructureDefinition/oauth-uris"
					Set tExt2 = $ClassMethod(tClassRoot_"Model.Base.Extension", "%New")
					Set tExt2.url = "authorize"
					Do tExt2.SetValueUri(tAuthEP)
					Set tExt3 = $ClassMethod(tClassRoot_"Model.Base.Extension", "%New")
					Set tExt3.url = "token"
					Do tExt3.SetValueUri(tTokenEP)
					Set tSC = tExt1.extension.Insert(tExt2)
					Set tSC = tExt1.extension.Insert(tExt3)
					Set tSC = tSecurity.extension.Insert(tExt1)
					Set tSC = tSecurity.SetService("SMART-on-FHIR","SMART-on-FHIR","http://hl7.org/fhir/restful-security-service")
					Set tRest.security = tSecurity
				}
			}
		}
		If $$$ISERR(tSC) Quit
		
		Set tSC = ##class(HS.FHIR.Utils).HSFHIRToFHIR(tContentType, tHSFHIRObj, .tNewResourceStream)
		If $$$ISERR(tSC) Quit
		
		Set tSC = $ClassMethod(tClassRoot_"Repository.Storage", "Update", tContentType, tClassRoot_"Model.Resource", , , , , , , tNewResourceStream)
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
	
	If '$Get(tHadProps) Kill %propsByName
	If '$Get(tHadPParams) Kill %HSFHIRPeriodParams
	If '$Get(tHadSParams) Kill %HSFHIRSearchParams
	If '$Get(tHadMax) Kill %maxlocallength
	
	Quit tSC
}

}
