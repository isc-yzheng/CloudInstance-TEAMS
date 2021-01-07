Include HS.HC

/// Utility for adding pre-determined OAuth 2.0 auth server endpoints to the
/// Conformance and CapabilityStatement resources in the FHIR repository.
Class HS.HC.Util.Installer.FHIR.OAuth2 Extends %RegisteredObject
{

/// AddOAuthToCapability adds OAuth 2.0 authorization server auth and token endpoints
/// to the Conformance and CapabilityStatement resources in the FHIR repository.
/// The endpoint information is derived from the HS.Registry.FHIRCSPConfig
/// definitions for the current namespace.
ClassMethod AddOAuthToCapability() As %Status
{
	New $Namespace
	
	Set tSC = $$$OK
	
	Set tOrigNS = $Namespace
	
	Try {
		Set tConfigItem = ##class(HS.Util.Installer.ConfigItem).%OpenId($Namespace)
		Set tValidNSTypes = ",Hub,EdgeGateway,AccessGateway,FlashGateway,Foundation,"
		If ('$IsObject($Get(tConfigItem)))||(tValidNSTypes'[(","_tConfigItem.Type_",")) {
			Set tSC = $$$ERROR($$$GeneralError, $Namespace_" is not a valid namespace for this installer")
			Quit
		}
		
		// Update Conformance/CapabilityStatements based on what is defined in HS.Registry.FHIRCSPConfig.
		
		Set tSQL = "SELECT FHIRVersion,ConformanceId,UseOAuth,ResourceServerOAuthClient FROM HS_Registry.FHIRCSPConfig"
		Set tStatement = ##class(%SQL.Statement).%New()
		Set tSC = tStatement.%Prepare(.tSQL)
		Set tSQLResultSet = tStatement.%Execute()
		If (tSQLResultSet.%SQLCODE < 0) { 
			Set tSC = $$$ERROR($$$GeneralError, "Error executing query on FHIR CSP Config table: SQL error, SQLCODE="_tSQLResultSet.%SQLCODE_", Msg="_tSQLResultSet.%Message)
			Quit 
		}
		While tSQLResultSet.%Next() {
			If 'tSQLResultSet.UseOAuth Continue
			Set tOAuthClient = tSQLResultSet.ResourceServerOAuthClient
			If tOAuthClient="" Continue
			Set tConformanceId = tSQLResultSet.ConformanceId
			If tConformanceId="" Continue
			Set tFHIRVersion = tSQLResultSet.FHIRVersion
			If $Data(tDone(tFHIRVersion,tConformanceId)) Continue
			If '$Data(tAuthServerInfo(tOAuthClient)) {
				Kill tClientInfo
				Set tSC = ##class(HS.FHIR.Utils).GetOAuthClientInfo(tOAuthClient, .tClientInfo)
				If $$$ISERR(tSC) Quit
				Merge tAuthServerInfo(tOAuthClient) = tClientInfo
			}
			Set tSC = ##class(HS.HC.Util.Installer.Kit.FHIR.CapabilityStatement).AddOAuthEndpoints( , $Namespace, tFHIRVersion, tConformanceId, tAuthServerInfo(tOAuthClient,"issuer"))
			If $$$ISERR(tSC) Quit
			Set tDone(tFHIRVersion,tConformanceId) = ""
		}
		If $$$ISERR(tSC) Quit
		
		Set tSC = ##class(Ens.Director).GetProductionStatus(.tProdName, .tProdStatus)
		If $$$ISERR(tSC) Quit
		
		If tProdStatus=$$$eProductionStateRunning {
			Set tSC = ##class(Ens.Director).StopProduction()
			Set tSC = ##class(Ens.Director).StartProduction()
			Write !
		}
		If $$$ISERR(tSC) Quit
		
	} Catch eException {
		Set tSC = eException.AsStatus()
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

}
